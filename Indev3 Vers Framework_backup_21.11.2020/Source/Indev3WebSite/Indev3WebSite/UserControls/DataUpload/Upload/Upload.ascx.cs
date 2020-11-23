using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Upload;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.WebControls;
using Telerik.WebControls;


namespace Inergy.Indev3.UI
{
    public partial class UserControls_DataUpload_Upload_Upload : IndBaseControl
    {
        private enum TargetDirectoryEnum
        {
            DIRECTORY_PROCESSED = 0,
            DIRECTORY_CANCELLED
        }

        private bool _isUserAllowedOnImportSource;
        private bool IsUserAllowedOnImportSource
        {
            get { return _isUserAllowedOnImportSource; }
            set { _isUserAllowedOnImportSource = value; }
        }

        protected List<string> FilesWithCostCentersWithoutHR
        {
            get
            {
                if (ViewState["FilesWithCostCentersWithoutHR"] == null)
                {
                    ViewState["FilesWithCostCentersWithoutHR"] = new List<string>();
                }
                return (List<string>)ViewState["FilesWithCostCentersWithoutHR"];
            }
            set
            {
                ViewState["FilesWithCostCentersWithoutHR"] = value;
            }
        }

        ArrayList errorMessages = new ArrayList();

        CurrentUser currentUser;

        #region Event Handlers
        protected void Page_Load(object sender, EventArgs e)
        {
            currentUser = SessionManager.GetCurrentUser(this.Page) as CurrentUser;
            try
            {
                //This code adds the javascript code to change the clearUploadsFlag flag before form submission:
                btnUpload.Attributes["onclick"] = "javascript: clearUploadsFlag = false;";

                if (!Page.IsPostBack)
                {
                    //load grid
                    LoadGrid();
                    //load File type combo
                    LoadFileTypeCombo();

                    //Check if it is situation: Reject file with cost centers without hourly rates
                    if (HttpContext.Current.Request.QueryString["filename"] != null)
                    {
                        string fileName = HttpContext.Current.Request.QueryString["filename"].ToString();
                        if (!string.IsNullOrEmpty(fileName))
                        {
                            string dirUrl = ConfigurationManager.AppSettings["UploadFolder"];
                            string filesPath = HttpContext.Current.Server.MapPath(dirUrl);
                            string fullFileName = filesPath + @"\" + fileName;
                            MoveFileToDirectory(TargetDirectoryEnum.DIRECTORY_CANCELLED, fullFileName);
                            if (FilesWithCostCentersWithoutHR.Contains(fileName))
                            {
                                FilesWithCostCentersWithoutHR.Remove(fileName);
                            }
                            LoadGrid();
                        }
                    }
                }

            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
        }

        /// <summary>
        /// buton that clicks upload
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnUpload_Click(object sender, EventArgs e)
        {
            try
            {
                //if an empty fille is uploaded the file is not even seen by the telerik upload control
                if (filUpload.UploadedFiles.Count == 0)
                {
                    ReportControlError(new IndException(ApplicationMessages.UPLOAD_ZERO_SIZE));
                    return;
                }

                if (VerifyRequiredFields(filUpload.UploadedFiles[0].GetName()))
                {
                    DoUploadFile();
                    LoadGrid();                    
                    ReportControlError(new IndException(ApplicationMessages.UPLOAD_SUCCESFULLY));
                }
                else
                {
                    LogErrorToDataBase(errorMessages[0].ToString(), filUpload.UploadedFiles[0].FileName);
                    ReportControlError(new IndException(errorMessages));
                    return;
                }
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
        }


        /// <summary>
        /// trigger processing file from In Process folder
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnProcess_Click(object sender, EventArgs e)
        {
            try
            {
                if (grdProcessInformation.MasterTableView.Items.Count == 0)
                {
                    ReportControlError(new IndException("There is no file to process."));
                    return;
                }

                ArrayList processedMessages = new ArrayList();
                int CountFileFailed = 0; //this will be set on true if at least one of the import files failed
                List<int> importsWithCostCentersWithoutHR = new List<int>(); //this will be contain importIds which has no error but it has cost centers without hourly rate

                CountFileFailed = ProcessFiles(ref processedMessages, ref importsWithCostCentersWithoutHR);

                //refresh grid because we moved the file to Cancelled or Processed folders
                LoadGrid();

                if (processedMessages.Count > 0)
                {

                    //if at least one file failed to import, we add the link to the log
                    if (CountFileFailed > 0)
                    {
                        String strLink = GetLogLink(Request.ApplicationPath, 0, 0);
                        processedMessages.Add(strLink);
                    }

                    ReportControlError(new IndException(processedMessages));
                    return;
                }
            }

            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }

        }

        #endregion Event Handlers

        #region Private Methods

        private string GetLogLink(String applicationPath, int type, int idImport)
        {
            if (type == 0)
            {
                return "( <a href='" + applicationPath + "/Catalogs.aspx?Code=DLG'>View Log</a> )";
            }
            else
            {
                return "<a href='#' onclick=ShowPopUp('" + ResolveUrl("~/Pages/Upload/DataLogsDetail.aspx?IdImport=" + idImport.ToString() + "&Validation=OO") + "',0,1024,'" + ResolveUrl("~/Upload.aspx") + "','" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "'); return false;>View Cost Centers without Hourly Rate</a>";
            }
        }

        private string GetDismissFile(string applicationPath, string fileName)
        {
            return "<a href='" + applicationPath + "/Upload.aspx?filename=" + fileName + "'>Reject the file</a>";
        }

        private int ProcessFiles(ref ArrayList processedMessages, ref List<int> importsWithCostCentersWithoutHR)
        {
            string fileName = string.Empty;
            // get the directory from appsettings
            string dirUrl = ConfigurationManager.AppSettings["UploadFolder"];
            string dirPath = Server.MapPath(dirUrl);
            string shareName = @"\\" + Server.MachineName + @"\" + dirUrl;

            int iResult;

            if (!Directory.Exists(dirPath))
            {
                processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FOLDER_DOES_NOT_EXIST, dirUrl));
                return 0;
            }

            int CountFileFailed = 0;

            //loop trough all files in grid
            foreach (GridDataItem item in grdProcessInformation.MasterTableView.Items)
            {
                fileName = shareName + @"\" + item["InProcessRealFileName"].Text;
                if (!File.Exists(fileName))
                {
                    //put message in arraylist to be shown on page
                    processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_NOT_EXIST, item["InProcessFileName"].Text, shareName));
                    LogErrorToDataBase(string.Format(ApplicationMessages.IMPORT_FILE_NOT_EXIST, item["InProcessFileName"].Text, shareName), fileName);
                    CountFileFailed++;
                    continue;
                }

                FileInfo fi = new FileInfo(fileName);
                //if the file has 0 size
                if (fi.Length == 0)
                {
                    processedMessages.Add(string.Format(ApplicationMessages.PROCESS_ZERO_SIZE, ApplicationUtils.GetCleanFileName(fileName)));
                    LogErrorToDataBase(string.Format(ApplicationMessages.PROCESS_ZERO_SIZE, ApplicationUtils.GetCleanFileName(fileName)), fileName);
                    MoveFileToDirectory(TargetDirectoryEnum.DIRECTORY_CANCELLED, fileName);
                    CountFileFailed++;
                    continue;
                }

                try
                {
                    int idImport = 0;
                    iResult = ProcessFile(fileName, ref processedMessages, ref idImport);                    
                    if (iResult > 0)
                    {
                        MoveFileToDirectory(TargetDirectoryEnum.DIRECTORY_PROCESSED, fileName);
                    }
                    else if (iResult < 0)
                    {
                        CountFileFailed++;
                        MoveFileToDirectory(TargetDirectoryEnum.DIRECTORY_CANCELLED, fileName);
                    }
                    else if (iResult == 0)
                    {
                        importsWithCostCentersWithoutHR.Add(idImport);
                    }
                }
                catch (IndException ex)
                {                    
                    processedMessages.Add(ex.Message);
                    LogErrorToDataBase(ex.Message, fileName);
                    MoveFileToDirectory(TargetDirectoryEnum.DIRECTORY_CANCELLED, fileName);
                    continue; //we continue with the next file.
                }
            }

            return CountFileFailed;
        }

        /// <summary>
        /// put the data from imports table to actual data after constraints check
        /// </summary>
        private int ProcessFile(string fileName, ref ArrayList processedMessages, ref int idImport)
        {
            idImport = ApplicationConstants.INT_NULL_VALUE;
            int resultChronologicalOrder = ApplicationConstants.INT_NULL_VALUE;
            int NonExistingAssociates = ApplicationConstants.INT_NULL_VALUE;
            string fileNameNonExistingAssociates = string.Empty;

            //check if file is not already imported
            string[] str = Path.GetFileName(fileName).Split('_');
            string cleanFileName = str[0] + Path.GetExtension(fileName);

            Imports imp = new Imports(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));

            bool validationResult;

            validationResult = CheckFileAlreadyExists(imp, fileName, cleanFileName, processedMessages);
            if (validationResult == false)
                return -1;
            
            try
            {
                resultChronologicalOrder = imp.CheckChronologicalImports(cleanFileName);
            }
            catch (IndException ex)
            {
                processedMessages.Add(ex.Message);
                ChronologicalErrorsToDB(ex.Message, fileName);
                return -1;
            }            

            //write in imports table
            try
            {
                idImport = imp.InsertToImportsTable(fileName, currentUser.IdAssociate);
            }
            catch (IndException ex)
            {
                processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, cleanFileName));
                LogErrorToDataBase(string.Format(ApplicationMessages.IMPORT_FILE_UPLOAD_ERROR, cleanFileName, ex.Message), fileName);
                return -1;
            }
            if (idImport < 0)
            {
                processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, cleanFileName));
                return -1;
            }

            int result = ApplicationConstants.INT_NULL_VALUE;
            string duplicateError = string.Empty;

            bool isConsistencyKRMError = false; //KRM stands for "key row(s) missing"
            String consistencyKRMError = String.Empty;
            String consistencyKRMMessage = "key row(s) were missing from import";

            try
            {
                if (FilesWithCostCentersWithoutHR.Contains(fileName))
                {
                    //file is processed second time. Skip Cost Centers without Hourly Rate
                    result = imp.InsertToActualTable(fileName, currentUser.IdAssociate, idImport, true);
                }
                else
                {
                    result = imp.InsertToActualTable(fileName, currentUser.IdAssociate, idImport, false);               
                }
            }
            catch (IndException ex)
            {
                result = -100;

                if (((IndException)ex).BaseException is SqlException)
                {
                    SqlException sqlBaseException = ((SqlException)((IndException)ex).BaseException);
                    if (sqlBaseException.Number == 2627) //The exception number for primary key violation
                    {
                        duplicateError  = "At least one record from the file " + cleanFileName + " already exists in the database.";
                    }
                    
                    if (sqlBaseException.Message.Contains(consistencyKRMMessage))
                    {
                        consistencyKRMError = sqlBaseException.Message;
                        isConsistencyKRMError = true;
                    }
                }

                if (!isConsistencyKRMError) //for this we write the message below
                {
                    if (string.IsNullOrEmpty(duplicateError))
                        LogProcessErrorToDataBase(idImport, ex.Message, fileName);
                    else
                        LogProcessErrorToDataBase(idImport, duplicateError, fileName);
                }
            }

            
            // consistency error treatment
            int rowsInserted = 0;
            String strError = String.Empty;

            try
            {
                if (isConsistencyKRMError)
                {
                    strError += consistencyKRMError;

                    rowsInserted = InsertKeyRowsMissingInDB(idImport);
                    if (rowsInserted > 0)
                    {
                        DataTable dtRowsMissing = SelectKeyRowsMissingFromDB(idImport);
                        
                        LogWriteKeyrowsMissingToLogTable(idImport, strError, fileName, dtRowsMissing);
                    }
                    else
                    {
                        LogProcessErrorToDataBase(idImport, strError, fileName);
                    }
                }
            }
            catch (Exception ex)
            {
                LogProcessErrorToDataBase(idImport, ex.Message, fileName);
            }
            /////////////////////////////

            try
            {               
                DataSet dsNonExistingAssociates = imp.SelectNonExistingAssociateNumbers(idImport);
                if(result>=0)                
                    fileNameNonExistingAssociates = GetServerPath(TargetDirectoryEnum.DIRECTORY_PROCESSED) + @"\" + ApplicationUtils.GetCleanFileName(Path.GetFileNameWithoutExtension(fileName)) +  "_MissingAssociates.txt";
                else
                    fileNameNonExistingAssociates = GetServerPath(TargetDirectoryEnum.DIRECTORY_CANCELLED) + @"\" + ApplicationUtils.GetCleanFileName(Path.GetFileNameWithoutExtension(fileName)) + "_MissingAssociates.txt";

                NonExistingAssociates = ApplicationUtils.CreateAssociatesTextFile(dsNonExistingAssociates, fileNameNonExistingAssociates);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            string msg = string.Empty;
            if (result >= 0 && result != ApplicationConstants.COST_CENTER_WITHOUT_HOURLYRATE_CODE_FROM_SP)
            {
                msg = string.Format(ApplicationMessages.IMPORT_FILE_PROCESSED, cleanFileName);
                if (NonExistingAssociates >= 0)
                {
                    fileNameNonExistingAssociates = ConfigurationManager.AppSettings["UploadFolderProcessed"] + @"\" + ApplicationUtils.GetCleanFileName(Path.GetFileNameWithoutExtension(fileName)) + "_MissingAssociates.txt";
                    msg += string.Format(ApplicationMessages.UPLOAD_MISSING_ASSOCIATES + ApplicationMessages.UPLOAD_ASSOCIATES_INSERTED, NonExistingAssociates + 1, fileNameNonExistingAssociates);
                }
                processedMessages.Add(msg);
                //If file was in this collection and it has been successfully processed, then remove it
                if (FilesWithCostCentersWithoutHR.Contains(fileName)) FilesWithCostCentersWithoutHR.Remove(fileName);
                return 1;
            }
            else
            {
                int returnValue = 0;
                if (result == ApplicationConstants.COST_CENTER_WITHOUT_HOURLYRATE_CODE_FROM_SP)
                {
                    msg = string.Format(ApplicationMessages.IMPORT_FILE_CC_WITHOUT_HR, cleanFileName);
                    msg +="<BR>" + GetLogLink(Request.ApplicationPath, 1, idImport)
                           + "<BR>" + GetDismissFile(Request.ApplicationPath, Path.GetFileName(fileName));
                    if (!FilesWithCostCentersWithoutHR.Contains(fileName)) FilesWithCostCentersWithoutHR.Add(fileName);
                    returnValue = 0;
                }
                else
                {
                    msg = string.Format(ApplicationMessages.IMPORT_FILE_ERROR, cleanFileName);
                    if (FilesWithCostCentersWithoutHR.Contains(fileName)) FilesWithCostCentersWithoutHR.Remove(fileName);
                    returnValue = -1;
                }
                if (NonExistingAssociates >= 0)
                {
                    fileNameNonExistingAssociates = ConfigurationManager.AppSettings["UploadFolderCancelled"] + @"\" + ApplicationUtils.GetCleanFileName(Path.GetFileNameWithoutExtension(fileName)) + "_MissingAssociates.txt";
                    msg += string.Format(ApplicationMessages.UPLOAD_MISSING_ASSOCIATES, NonExistingAssociates + 1, fileNameNonExistingAssociates);
                }
                processedMessages.Add(msg);
                return returnValue;
            }
        }

        private bool CheckFileAlreadyExists(Imports imp, string fileName, string cleanFileName, ArrayList processedMessages)
        {
            int resultFileExist = ApplicationConstants.INT_NULL_VALUE;
            try
            {
                resultFileExist = imp.CheckFileAlreadyUploaded(fileName);
            }
            catch (IndException ex)
            {
                processedMessages.Add("There was an error checking if file was already processed. Consult logs for details.");
                ChronologicalErrorsToDB("There was an error checking if file was already processed." + ex.Message, cleanFileName);
                return false;
            }
            if (resultFileExist < 0)
            {
                processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, cleanFileName));
                ChronologicalErrorsToDB(string.Format(ApplicationMessages.IMPORT_FILE_ALREADY_UPLOADED, cleanFileName), fileName);
                return false;
            }

            return true;
        }

        /// <summary>
        /// move the file after importing
        /// </summary>
        /// <param name="success"></param>
        /// <param name="fileName"></param>
        private void MoveFileToDirectory(TargetDirectoryEnum eTargetDir, string fileName)
        {
            string dirPath;

            try
            {
                dirPath = GetServerPath(eTargetDir);
              
                if (Directory.Exists(dirPath))
                {
                    File.Copy(fileName, dirPath + @"\" + Path.GetFileName(fileName), true);
                    File.Delete(fileName);
                }
                else
                    throw new IndException(ApplicationMessages.IMPORT_DESTINATION_UNKNOWN);
                
            }
            catch (Exception ex)
            {
                throw new IndException(string.Format(ApplicationMessages.IMPORT_FILE_ERROR_ON_MOVING, Path.GetFileName(fileName), ex.Message));
            }

        }
        /// <summary>
        /// load file type combo
        /// </summary>
        private void LoadFileTypeCombo()
        {
            ImportSources imp = new ImportSources(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            cmbFileType.DataSource = imp.SelectApplicationTypes();
            cmbFileType.DataValueField = "IdCodeName";
            cmbFileType.DataTextField = "SourceName";
            cmbFileType.DataBind();
        }
        /// <summary>
        /// load the grid with datasource
        /// </summary>
        private void LoadGrid()
        {
            grdProcessInformation.DataSource = GetSource();
            grdProcessInformation.Rebind();

        }

        /// <summary>
        /// Get the source of the grid from InProcess directory files
        /// </summary>
        /// <returns>generic list of UploadFile class type</returns>
        private List<UploadFile> GetSource()
        {

            List<UploadFile> uf = new List<UploadFile>();

            string dirUrl = ConfigurationManager.AppSettings["UploadFolder"];
            string filesPath = HttpContext.Current.Server.MapPath(dirUrl);
            string[] filesArr = Directory.GetFiles(filesPath);
            string fileName = string.Empty;
            string realFileName = string.Empty;
            for (int i = 0; i <= filesArr.Length - 1; i++)
            {
                //get only csv files
                if (Path.GetExtension(filesArr[i].ToString()).ToLower() != ".csv")
                    continue;
                //only BA and TA are allowed to see all files
                if ((currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM) && !IsUserAllowedOnImportSource) 
                    continue;
                realFileName = Path.GetFileName(filesArr[i]);
                string[] arr = Path.GetFileNameWithoutExtension(filesArr[i]).Split('_');
                fileName = arr[0] + Path.GetExtension(filesArr[i]);
                uf.Add(new UploadFile(File.GetLastWriteTime(filesArr[i]), fileName, realFileName));
            }

            return uf;

        }

        /// <summary>
        /// method for verify required fields
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private bool VerifyRequiredFields(string fileName)
        {           
            if ((int)dtStartDate.GetValue() == ApplicationConstants.INT_NULL_VALUE)
            {
                errorMessages.Add(ApplicationMessages.IMPORT_SELECT_YEARMONTH);
                return false;
            }

            if (cmbFileType.SelectedIndex == ApplicationConstants.INT_NULL_VALUE)
            {
                errorMessages.Add(ApplicationMessages.IMPORT_SELECT_FILETYPE);
                return false;
            }


            try
            {
                string fileNameNoExtension = filUpload.UploadedFiles[0].GetNameWithoutExtension();
                string countryName = SessionManager.GetCurrentUser(this.Page).CountryName;
                string countryFirstThreeLetters = SessionManager.GetCurrentUser(this.Page).CountryCode;
                //check file type SAPFRA012007.csv
                if (fileNameNoExtension.Length != 12)
                {
                    errorMessages.Add(string.Format(ApplicationMessages.IMPORT_WRONG_FILE_FORMAT, fileName));
                    return false;
                }
                //check YearMonth from file
                string month = fileNameNoExtension.Substring(6, 2);
                int monthOut;
                if (!int.TryParse(month, out monthOut))
                {
                    errorMessages.Add(string.Format(ApplicationMessages.UPLOAD_WRONG_MONTH, month, fileName));
                    return false;
                }
                if (int.Parse(month) < 1 || int.Parse(month) > 12)
                {
                    errorMessages.Add(string.Format(ApplicationMessages.UPLOAD_WRONG_MONTH, month, fileName));
                    return false;
                }
                string year = fileNameNoExtension.Substring(8, 4);
                int yearOut;
                if (!int.TryParse(year, out yearOut))
                {
                    errorMessages.Add(string.Format(ApplicationMessages.UPLOAD_WRONG_YEAR, month, fileName));
                    return false;
                }
                if (int.Parse(year) < YearMonth.FirstYear)
                {
                    errorMessages.Add(string.Format(ApplicationMessages.UPLOAD_WRONG_YEAR, year, fileName));
                    return false;
                }
                if (dtStartDate.Text != year + month)
                {
                    errorMessages.Add(string.Format(ApplicationMessages.IMPORT_WRONG_YEARMONTH, fileName, dtStartDate.Text));
                    return false;
                }
                
                #region confront associate with selected file type
                string comboValue = cmbFileType.SelectedValue;
                int IdImportSource = GetIdFromCombo();

                ImportSources dbis = new ImportSources(SessionManager.GetSessionValueNoRedirect(
                                                this.Page, 
                                                SessionStrings.CONNECTION_MANAGER));

                dbis.IdCurrentAssociate = currentUser.IdAssociate;
                dbis.IdImportSource = IdImportSource;

                if (currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
                {
                    IsUserAllowedOnImportSource = dbis.IsUserAllowedOnImportSource();
                    if(!IsUserAllowedOnImportSource)
                    {
                        errorMessages.Add(string.Format(
                                    ApplicationMessages.IMPORT_COUNTRY_NOT_IN_IMPORTSOURCE, 
                                    countryName, 
                                    cmbFileType.SelectedItem.Text));
                        return false;   
                    }
                }
                #endregion

                #region confront application file with combo application type
                if (!comboValue.EndsWith(fileNameNoExtension.Substring(0, 3), StringComparison.CurrentCultureIgnoreCase))
                {
                    string fileType = comboValue.Substring(comboValue.IndexOf(ApplicationConstants.SEPARATOR_SQL) + 1);
                    errorMessages.Add(string.Format(
                                    ApplicationMessages.IMPORT_WRONG_APPLICATION, 
                                    fileName, fileType));
                    return false;
                }
                #endregion
            }
            catch (Exception ex)
            {
                errorMessages.Add(ex.Message);
                return false;
            }
            return true;
        }

        /// <summary>
        /// upload selected file
        /// </summary>
        private void DoUploadFile()
        {

            // get the directory from appsettings
            string dirUrl = ConfigurationManager.AppSettings["UploadFolder"];
            string dirPath = Server.MapPath(dirUrl);

            if (Directory.Exists(dirPath))
            {
                try
                {
                    string idSource = "_" + cmbFileType.SelectedValue.Substring(0, cmbFileType.SelectedValue.Length - 4);
                    string fileUrl = dirPath + "\\" + Path.GetFileNameWithoutExtension(filUpload.UploadedFiles[0].FileName)
                                    + idSource + Path.GetExtension(filUpload.UploadedFiles[0].FileName);
                    filUpload.UploadedFiles[0].SaveAs(fileUrl, true);                   
                }
                catch (IndException ex)
                {
                    throw ex;
                }
                catch (Exception ex)
                {
                    LogErrorToDataBase(ex.Message, filUpload.UploadedFiles[0].FileName);
                    throw new IndException(String.Format(ApplicationMessages.IMPORT_FILE_UPLOAD_ERROR, filUpload.UploadedFiles[0].FileName, ex.Message));
                }
            }
            else
            {
                if (!Page.ClientScript.IsClientScriptBlockRegistered("DirectoryNotExist"))
                {
                    Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "DirectoryNotExist", "DoAlertMessage('Directory In Process does not exist')", true);
                }
                throw new IndException(String.Format(ApplicationMessages.IMPORT_FILE_UPLOAD_ERROR, filUpload.UploadedFiles[0].FileName, "Directory " + dirPath +  " does not exists!"));
            }
        }

        private void WriteRowToImportedTable()
        {
            // get the directory from appsettings
            string dirUrl = ConfigurationManager.AppSettings["UploadFolder"];
            string filesPath = HttpContext.Current.Server.MapPath(dirUrl);
            string[] files = Directory.GetFiles(filesPath);            
            
            //get connection manager from session
            object connManager = SessionManager.GetConnectionManager(this.Page);

            for (int i = 0; i <= files.Length - 1; i++)
            {
                Imports importClass = new Imports(connManager);
                importClass.InsertToImportsTable(files[i], currentUser.IdAssociate);

            }
        }

        private void ChronologicalErrorsToDB(string message, string fileName)
        {
            Imports imp = new Imports(SessionManager.GetConnectionManager(this.Page));
            imp.FileName = fileName;
            imp.Message = message;
            imp.IdAssociate = currentUser.IdAssociate;
            imp.IdSource = GetIdFromCombo();
            imp.ChronologicalErrorToDB();
        }

        private int GetIdFromCombo()
        {
            return int.Parse(cmbFileType.SelectedValue.Substring(0, cmbFileType.SelectedValue.Replace(ApplicationConstants.SEPARATOR_SQL, String.Empty).Length - 3));
        }

        private void LogErrorToDataBase(string message, string fileName)
        {            
            Imports imp = new Imports(SessionManager.GetConnectionManager(this.Page));
            imp.FileName = fileName;
            imp.IdAssociate = currentUser.IdAssociate;
            imp.Message = message;
            imp.IdSource = GetIdFromCombo();
            imp.UploadErrorsToLogTables();
        }

        private void LogProcessErrorToDataBase(int idImport,string message, string fileName)
        {
            Imports imp = new Imports(SessionManager.GetConnectionManager(this.Page));
            imp.IdImport = idImport;
            imp.FileName = fileName;
            imp.Message = message;
            imp.IdSource = GetIdFromCombo();                           
            imp.ProcessErrorToLogTable();
        }

        private void LogWriteKeyrowsMissingToLogTable(int idImport, string message, string fileName, DataTable dtKeyrowsMissing)
        {
            Imports imp = new Imports(SessionManager.GetConnectionManager(this.Page));
            imp.IdImport = idImport;
            imp.FileName = fileName;
            imp.Message = message;
            imp.IdSource = GetIdFromCombo();
            imp.WriteKeyrowsMissingToLogTable(dtKeyrowsMissing);
        }

        private string GetServerPath(TargetDirectoryEnum eTargetDir)
        {
            string dirUrl = string.Empty;
            string dirPath = string.Empty;
              switch (eTargetDir)
              {
                case TargetDirectoryEnum.DIRECTORY_PROCESSED:
                {
                    dirUrl = ConfigurationManager.AppSettings["UploadFolderProcessed"];
                    dirPath = Server.MapPath(dirUrl);
                }
                break;
                case TargetDirectoryEnum.DIRECTORY_CANCELLED:
                {
                 dirUrl = ConfigurationManager.AppSettings["UploadFolderCancelled"];
                 dirPath = Server.MapPath(dirUrl);
                }
                break;
                default:
                {
                 throw new IndException("Unknown TargetDirectoryEnum member: " + eTargetDir.ToString());
                }
              }
              return dirPath;
        }

        private int InsertKeyRowsMissingInDB(int idImport)
        {
            //get connection manager from session
            object connManager = SessionManager.GetConnectionManager(this.Page);

            ImportDetailsKeyRowsMissing importDetailsKeyRowsMissing = new ImportDetailsKeyRowsMissing(idImport, connManager);
            int rowsInserted = importDetailsKeyRowsMissing.InsertKeyRowsMissing();

            return rowsInserted;
        }

        private DataTable SelectKeyRowsMissingFromDB(int idImport)
        {
            //get connection manager from session
            object connManager = SessionManager.GetConnectionManager(this.Page);

            ImportDetailsKeyRowsMissing importDetailsKeyRowsMissing = new ImportDetailsKeyRowsMissing(idImport, connManager);
            DataTable dt = importDetailsKeyRowsMissing.SelectKeyRowsMissing();

            return dt;
        }


        private int AddKeyRowsMissingToRejectedFile(string fileName, DataTable missingRows)
        {
            int nRowsWritten = 0;

            ArrayList columnsToSkip = new ArrayList();
            columnsToSkip.Add("IdImport");
            columnsToSkip.Add("IdRow");
            columnsToSkip.Add("IdImportPrevious");

            nRowsWritten = DSUtils.WriteDataTableToCSVFile(missingRows, columnsToSkip, fileName, true);

            return nRowsWritten;
        }


        #endregion Private Methods
    }
}