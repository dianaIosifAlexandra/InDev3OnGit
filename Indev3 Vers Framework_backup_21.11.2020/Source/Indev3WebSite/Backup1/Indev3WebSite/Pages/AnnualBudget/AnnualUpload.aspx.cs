using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.AnnualBudget;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Upload;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;

public partial class Pages_AnnualBudget_AnnualUpload : IndBasePage
{
    #region Members
    ArrayList errorMessages = new ArrayList();
    CurrentUser currentUser;
    #endregion
    
    #region events
    protected void Page_Load(object sender, EventArgs e)
    {
        currentUser = SessionManager.GetCurrentUser(this.Page) as CurrentUser;
        try
        {
            //This code adds the javascript code to change the clearUploadsFlag flag before form submission:
            btnUpload.Attributes["onclick"] = "javascript: clearUploadsFlag = false;";
            LoadYearCombo();
            LoadDataGrid();
        }
        catch (IndException ex)
        {
            ShowError(ex);
            return;
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
            return;
        }

    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        ArrayList uploadMessages = new ArrayList();
        String strLink = GetLogLink(Request.ApplicationPath); 

        if (filUpload.UploadedFiles.Count > 0)
        {
            try
            {

                if (VerifyRequiredFields())
                {
                    DoUploadFile();
                    LoadDataGrid();

                    uploadMessages.Add(ApplicationMessages.UPLOAD_SUCCESFULLY);
                }
                else
                {
                    LogErrorToDataBase(errorMessages[0].ToString(), filUpload.UploadedFiles[0].FileName);

                    uploadMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, ApplicationUtils.GetCleanFileName(filUpload.UploadedFiles[0].FileName)));
                    uploadMessages.Add(strLink);
                }
            }
            catch (IndException ex)
            {
                LogErrorToDataBase(ex.Message, filUpload.UploadedFiles[0].FileName);               
                
                uploadMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, ApplicationUtils.GetCleanFileName(filUpload.UploadedFiles[0].FileName)));
                uploadMessages.Add(strLink);
            }
        }
        else
        {
            uploadMessages.Add(ApplicationMessages.UPLOAD_ZERO_SIZE);
            uploadMessages.Add(strLink);
        }

        this.ShowError(uploadMessages);
    }

    protected void btnProcess_Click(object sender, EventArgs e)
    {
        try
        {
            if (grdProcessInformation.MasterTableView.Items.Count == 0)
            {
                this.ShowError(new IndException("There is no file to process."));
                return;
            }
            ArrayList processedMessages = new ArrayList();
            bool result = ProcessFiles(ref processedMessages);

            if (processedMessages.Count > 0)
            {
                //if at least one file failed to import, we add the link to the log
                if (!result)
                {
                    String strLink = GetLogLink(Request.ApplicationPath);
                    processedMessages.Add(strLink);
                }
            }
            LoadDataGrid();
            this.ShowError(processedMessages);
        }
        catch (IndException ex)
        {
            ShowError(ex);
            return;
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
            return;
        }
    }
    #endregion

    #region Methods
    private void LoadDataGrid()
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

        string dirUrl = @"..\..\" + ConfigurationManager.AppSettings["UploadFolderAnnual"];//@"..\..\UploadDirectoriesAnnual\InProcess";
        string filesPath = HttpContext.Current.Server.MapPath(dirUrl);
        string[] filesArr = Directory.GetFiles(filesPath);
        string fileName = string.Empty;
        string realFileName = string.Empty;
        for (int i = 0; i <= filesArr.Length - 1; i++)
        {
            //get only csv files
            if (Path.GetExtension(filesArr[i].ToString()) != ".csv")
                continue;
            //only BA and TA are allowed to see all files
            if ((currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM) && (ApplicationUtils.GetCleanFileName(filesArr[i].ToString()).Substring(0, 3) != currentUser.CountryCode))
                continue;
            realFileName = Path.GetFileName(filesArr[i]);
            string[] arr = Path.GetFileNameWithoutExtension(filesArr[i]).Split('_');            
            fileName = arr[0] + Path.GetExtension(filesArr[i]);
            uf.Add(new UploadFile(File.GetLastWriteTime(filesArr[i]), fileName, realFileName));
        }

        return uf;

    }

    private void LoadYearCombo()
    {
        cmbYear.Items.Add(new RadComboBoxItem(String.Empty, ApplicationConstants.INT_NULL_VALUE.ToString()));
        cmbYear.DataSource = PeriodUtils.GetYears(); 
        cmbYear.DataBind();            
    }

    /// <summary>
    /// method for verify required fields
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private bool VerifyRequiredFields()
    {

        if (cmbYear.SelectedValue == ApplicationConstants.INT_NULL_VALUE.ToString())
        {
            errorMessages.Add("* Select Year");
            return false;
        }       

        string countryName = SessionManager.GetCurrentUser(this.Page).CountryName;
        string countryCode = SessionManager.GetCurrentUser(this.Page).CountryCode;
        //check file type FRA2007.csv
        if (filUpload.UploadedFiles[0].GetNameWithoutExtension().Length != 7)
        {
            errorMessages.Add(string.Format(ApplicationMessages.ANNUAL_IMPORT_WRONG_FILE_FORMAT,filUpload.UploadedFiles[0].GetName()));
            return false;
        }
        //check Year from file            
        string year = filUpload.UploadedFiles[0].GetNameWithoutExtension().Substring(3, 4);
        if (cmbYear.Text != year)
        {
            errorMessages.Add(string.Format(ApplicationMessages.ANNUAL_IMPORT_WRONG_YEAR,filUpload.UploadedFiles[0].GetName()));
            return false;
        }
        //confrunt country file with country current associate
        if (currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
        {
            if (filUpload.UploadedFiles[0].GetNameWithoutExtension().Substring(0, 3).ToUpper() != countryCode.ToUpper())
            {
                errorMessages.Add(string.Format(ApplicationMessages.IMPORT_WRONG_COUNTRY, filUpload.UploadedFiles[0].GetName(),countryName));
                return false;
            }
        }        

        return true;
    }
   
    /// <summary>
    /// upload selected file
    /// </summary>
    private void DoUploadFile()
    {
        string dirUrl = @"..\..\" + ConfigurationManager.AppSettings["UploadFolderAnnual"];//@"..\..\UploadDirectoriesAnnual\InProcess";
        string dirPath = Server.MapPath(dirUrl);

        if (Directory.Exists(dirPath))
        {
            try
            {               
                // Directory.CreateDirectory(dirPath);
                string fileUrl = dirPath + "\\" + Path.GetFileName(filUpload.UploadedFiles[0].FileName);

                filUpload.UploadedFiles[0].SaveAs(fileUrl, true);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        else
        {
            throw new IndException("Upload failed. Directory InProcess does not exist!");
        }
    }

    private bool ProcessFiles(ref ArrayList processedMessages)
    {
        string dirUrl = ConfigurationManager.AppSettings["UploadFolderAnnual"];
        string dirPath = Server.MapPath(@"..\..\" + dirUrl);
        string shareName = @"\\" + Server.MachineName +  @"\"  + dirUrl;
        string fileName = string.Empty;
        bool bResult = false;

        if (!Directory.Exists(dirPath))
        {
           processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FOLDER_DOES_NOT_EXIST, dirUrl));
           return false;
        }

        foreach (GridDataItem item in grdProcessInformation.MasterTableView.Items)
        {
            fileName = shareName + @"\" + item["InProcessRealFileName"].Text;
            if (!File.Exists(fileName))
            {
                processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_NOT_EXIST, Path.GetFileName(fileName),shareName));
                LogErrorToDataBase(string.Format(ApplicationMessages.IMPORT_FILE_NOT_EXIST, Path.GetFileName(fileName), shareName), fileName);
                continue;
            }

            FileInfo fi = new FileInfo(fileName);
            //log error if the file has 0 size
            if (fi.Length == 0)
            {
                processedMessages.Add(string.Format(ApplicationMessages.PROCESS_ZERO_SIZE, ApplicationUtils.GetCleanFileName(fileName)));
                LogErrorToDataBase(string.Format(ApplicationMessages.PROCESS_ZERO_SIZE, ApplicationUtils.GetCleanFileName(fileName)), fileName);
                MoveFileToDirectory(false, fileName);
                continue;
            }
            try
            {
                bResult = ProcessFile(fileName, ref processedMessages);
                MoveFileToDirectory(bResult, fileName);
            }
            catch (Exception ex)
            {
                processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, ApplicationUtils.GetCleanFileName(fileName)));
                LogErrorToDataBase(ex.Message, ApplicationUtils.GetCleanFileName(fileName));
                continue; //we continue with the next file
            }
        }
        return bResult;
    }
    /// <summary>
    /// put the data from imports table to actual data after constraints check
    /// </summary>
    private bool ProcessFile(string fileName, ref ArrayList processedMessages)
    {       
        int idImport = ApplicationConstants.INT_NULL_VALUE;
        int result = ApplicationConstants.INT_NULL_VALUE;
        int resultFileExist = ApplicationConstants.INT_NULL_VALUE;
        string duplicateError = string.Empty;


        string cleanFileName = ApplicationUtils.GetCleanFileName(fileName);

        AnnualUpload annualUpload = new AnnualUpload(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
        annualUpload.IdAssociate = currentUser.IdAssociate;
        try
        {
            annualUpload.FileName = fileName;
            resultFileExist = annualUpload.CheckFileAlreadyUploaded();
        }
        catch(Exception ex)
        {
            processedMessages.Add(ApplicationMessages.IMPORT_CHECK_FILE_CRASH);
            LogErrorToDataBase(ex.Message, fileName);
            return false;
        }
        if (resultFileExist < 0)
        {
            processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ALREADY_UPLOADED, cleanFileName));
            return false;
        }
        try
        {
            idImport = annualUpload.WriteToAnnualImportTable();
        }
        catch (Exception ex)
        {
            processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, cleanFileName));
            LogErrorToDataBase(ex.Message, fileName);
            return false;
        }
        if (idImport<0)
        {
            processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, cleanFileName));
            return false;
        }

        try
        {
            annualUpload.IdImport = idImport;
            result = annualUpload.InsertIntoAnnualTable();
        }
        catch (IndException ex)
        {
            result = -100;

            if (((IndException)ex).BaseException is SqlException)
            {
                SqlException sqlBaseException =  ((SqlException)((IndException)ex).BaseException);
                if (sqlBaseException.Number == 2627) //The exception number for primary key violation
                {
                    duplicateError = "At least one record from the file " + cleanFileName + " already exists in the database.";
                }
            }
    
            if(string.IsNullOrEmpty(duplicateError))
                LogProcessErrorToDataBase(idImport,ex.Message, fileName);
            else
                LogProcessErrorToDataBase(idImport,duplicateError, fileName);
               
        }
        if (result >= 0)
        {         
            processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_PROCESSED, cleanFileName));
            return true;
        }
        else
        {            
            processedMessages.Add(string.Format(ApplicationMessages.IMPORT_FILE_ERROR, cleanFileName));
            return false;
        }
       
        
    }

    /// <summary>
    /// move the file after importing
    /// </summary>
    /// <param name="success"></param>
    /// <param name="fileName"></param>
    private void MoveFileToDirectory(bool success, string fileName)
    {

        if (success)
        {
            string dirUrlProcessed = @"..\..\" + ConfigurationManager.AppSettings["UploadFolderProcessedAnnual"];
            string dirPathProcessed = Server.MapPath(dirUrlProcessed);
            if (Directory.Exists(dirPathProcessed))
            {
                File.Copy(fileName, dirPathProcessed + @"\" + Path.GetFileName(fileName), true);
                File.Delete(fileName);
            }
            else
                throw new IndException(ApplicationMessages.IMPORT_DESTINATION_UNKNOWN);
        }
        else
        {
            string dirUrlCancelled = @"..\..\" + ConfigurationManager.AppSettings["UploadFolderCancelledAnnual"];// @"..\..\UploadDirectoriesAnnual\Cancelled";
            string dirPathCancelled = Server.MapPath(dirUrlCancelled);
            if (Directory.Exists(dirPathCancelled))
            {
                File.Copy(fileName, dirPathCancelled + @"\" + Path.GetFileName(fileName), true);
                File.Delete(fileName);
            }
            else
                throw new IndException(ApplicationMessages.IMPORT_DESTINATION_UNKNOWN);
        }
    }

    private void LogErrorToDataBase(string message, string fileName)
    {        
        AnnualImports annualImports = new AnnualImports(SessionManager.GetConnectionManager(this.Page));

        annualImports.FileName = fileName;
        annualImports.Message = message;
        annualImports.IdAssociate = currentUser.IdAssociate;
        annualImports.UploadErrorsToLogTables();
    }

    private void LogProcessErrorToDataBase(int idImport, string message, string fileName)
    {
        AnnualImports annualImports = new AnnualImports(SessionManager.GetConnectionManager(this.Page));
        annualImports.IdImport = idImport;
        annualImports.Message = message;
        annualImports.FileName = fileName;
        annualImports.ProcessErrorsToLogTables();
    }

    private string GetLogLink(String applicationPath)
    {
        return "( <a href='" + applicationPath + "/Catalogs.aspx?Code=ANL'>View Log</a> )";
    }
    #endregion
}
