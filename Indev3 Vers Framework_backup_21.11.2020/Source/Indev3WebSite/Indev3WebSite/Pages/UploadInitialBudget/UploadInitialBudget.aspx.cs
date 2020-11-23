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
using Inergy.Indev3.BusinessLogic.UploadInitialBudget;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Upload;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;
using Inergy.Indev3.BusinessLogic.Extract;

public partial class Pages_UploadInitialBudget_UploadInitialBudget : IndBasePage
{
    #region Members
    ArrayList errorMessages = new ArrayList();
    CurrentUser currentUser;

    private enum TargetDirectoryEnum
    {
        DIRECTORY_PROCESSED = 0,
        DIRECTORY_CANCELLED
    }

    #endregion

    private CurrentProject currentProject
    {
        get
        {
            return SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
        }
    }        

    #region events
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string issuer = (string.IsNullOrEmpty(Page.Request.Params.Get("__EVENTTARGET")) ? string.Empty : Page.Request.Params.Get("__EVENTTARGET"));
            currentUser = SessionManager.GetCurrentUser(this.Page) as CurrentUser;

            if (!Page.IsPostBack || issuer.Contains("lnkChange"))
                DisplayCurrentProjectLabel();

            //This code adds the javascript code to change the clearUploadsFlag flag before form submission:
            btnUpload.Attributes["onclick"] = "javascript: clearUploadsFlag = false;";
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
        if (filUpload.UploadedFiles.Count > 0)
        {
            try
            {
                if (VerifyRequiredFields())
                {
                    int idImport = DoUploadFile();
                    this.ShowError(new IndException(string.Format(ApplicationMessages.UPLOAD_SUCCESSFULY_BUDGET_INITIAL,idImport)));
                }
                else
                    this.ShowError(new IndException(string.Format(ApplicationMessages.IMPORT_FILE_INITIAL_BUDGET_ERROR, ApplicationUtils.GetCleanFileName(filUpload.UploadedFiles[0].FileName), errorMessages[0].ToString() )));
            }
            catch (IndException ex)
            {
                string showError = string.Format(ApplicationMessages.IMPORT_FILE_INITIAL_BUDGET_ERROR, ApplicationUtils.GetCleanFileName(filUpload.UploadedFiles[0].FileName), ex.Message);
                this.ShowError(new IndException(showError));
            }
        }
        else
            this.ShowError(new IndException(ApplicationMessages.UPLOAD_ZERO_SIZE));
    }

    protected void btnProcess_Click(object sender, EventArgs e)
    {
        try
        {
            int idImport = default(int);
            Int32.TryParse(ProcessIdHdn.Value.ToString(), out idImport);
            ImportInitialBudget initialBudgetUpload = new ImportInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            try
            {
                int retVal = initialBudgetUpload.InsertToBudgetTable(idImport);
                if (retVal >= 0)
                {
                    this.ShowError(new IndException(string.Format(ApplicationMessages.IMPORT_FILE_PROCESSED, idImport.ToString())));
                    TrackingActivityLog tkl = new TrackingActivityLog(SessionManager.GetConnectionManager(this));
                    tkl.InsertTrackingActivityLog(currentProject, currentUser, ETrackingActivity.UploadedInitialBudget); 
                }
            }
            catch (Exception ex)
            {
                this.ShowError(new IndException(ex.Message.ToString()));
            }
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
            return;
        }
    }
    #endregion

    #region Methods    

    /// <summary>
    /// method for verify required fields
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private bool VerifyRequiredFields()
    {        
        //check file type InitialBudget<ProjectCode>.csv
        string fileName = ApplicationConstants.DEFAULT_INITIAL_BUDGET_FILE_NAME;
        fileName = fileName.Replace("#", currentProject.ProjectCode); 
        if (filUpload.UploadedFiles[0].GetName() != fileName )
        {
            errorMessages.Add(string.Format(ApplicationMessages.INITIAL_IMPORT_WRONG_FILE_FORMAT, filUpload.UploadedFiles[0].GetName()));
            return false;
        }                        
        return true;
    }
   
    /// <summary>
    /// upload selected file
    /// </summary>
    private int DoUploadFile()
    {
        //TODO is this a security threat?
        string dirUrl = @"..\..\" + ConfigurationManager.AppSettings["UploadFolderInitial"];
        string dirPath = Server.MapPath(dirUrl);

        if (Directory.Exists(dirPath))
        {
            try
            {
                // Directory.CreateDirectory(dirPath);
                string fileUrl = dirPath + "\\" + Path.GetFileName(filUpload.UploadedFiles[0].FileName);
                filUpload.UploadedFiles[0].SaveAs(fileUrl, true);
                return ProcessUploadedFile(fileUrl);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        else
            throw new IndException(string.Format(ApplicationMessages.IMPORT_FILE_UPLOAD_ERROR, filUpload.UploadedFiles[0].FileName, "Directory " + dirPath + " does not exists!"));
    }   

    private int ProcessUploadedFile(string fileName)
    {
        int idImport = ApplicationConstants.INT_NULL_VALUE;
        string cleanFileName = ApplicationUtils.GetCleanFileName(fileName);
        string shareFilePath = string.Empty;

        // get the directory from appsettings
        string dirUrl = ConfigurationManager.AppSettings["UploadFolderInitial"];
        string dirPath = Server.MapPath(dirUrl);
        string shareName = @"\\" + Server.MachineName + @"\" + dirUrl;
        shareFilePath = shareName + @"\" + cleanFileName;
        ImportInitialBudget initialBudgetUpload = new ImportInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
        
        try
        {
            idImport = initialBudgetUpload.WriteToInitialBudgetImportTable(shareFilePath, currentUser.IdAssociate);
            if (idImport > 0)
            {
                btnProcess.Enabled = true;
                ProcessIdHdn.Value = idImport.ToString();
                MoveFileToDirectory(TargetDirectoryEnum.DIRECTORY_PROCESSED, shareFilePath);
            }
            return idImport;
        }
        catch (Exception ex)
        {
            btnProcess.Enabled = false;
            MoveFileToDirectory(TargetDirectoryEnum.DIRECTORY_CANCELLED, shareFilePath);
            throw new IndException(ex);
        }            
    }    

    private void DisplayCurrentProjectLabel()
    {
        if (currentProject != null)
        {
            lblProgramName.Text = currentProject.ProgramName + " [" + currentProject.ProgramCode + "]";
            lblProjectName.Text = currentProject.Name;
        }
    }

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

    private string GetServerPath(TargetDirectoryEnum eTargetDir)
    {
        string dirUrl = string.Empty;
        string dirPath = string.Empty;
        switch (eTargetDir)
        {
            case TargetDirectoryEnum.DIRECTORY_PROCESSED:
                {
                    dirUrl = @"..\..\" + ConfigurationManager.AppSettings["UploadFolderInitialProcessed"];                    
                    dirPath = Server.MapPath(dirUrl);
                }
                break;
            case TargetDirectoryEnum.DIRECTORY_CANCELLED:
                {
                    dirUrl = @"..\..\" + ConfigurationManager.AppSettings["UploadFolderInitialCancelled"];
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

    #endregion
}
