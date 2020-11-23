using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework;
using System.Web.Configuration;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Olap;
using Inergy.Indev3.BusinessLogic.Budget;

namespace Inergy.Indev3.UI
{
    public partial class _Default : IndBasePage
    {
        #region Event Handlers
        protected override void  OnInit(EventArgs e)
        {
            try
            {
                base.OnInit(e);               
                if (!IsPostBack)
                {
                    SetApplicationSettings();
                }
            }
            catch (IndException ex)
            {
                ShowDefaultPageError(ex);
                return;
            }
            catch (Exception ex)
            {
                ShowDefaultPageError(ex);
                return;
            }
        }
        
        protected override void OnPreRender(EventArgs e)
        {
            try
            {               
                if (HttpContext.Current.Request.QueryString["SessionExpired"] != null
                    && !IsPostBack) //IsPostBack is checked to avoid displaying message twice, after CountrySelector & ProjectSelector
                {
                    throw new IndException(ApplicationMessages.EXCEPTION_PAGE_EXPIRED);
                }
                base.OnPreRender(e);
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
        protected override void OnLoad(EventArgs e)
        {
            try
            {
                base.OnLoad(e);
                if (PageLoadSucceeded)
                {
                    if (!IsPostBack)
                    {
                        UpdateOlapPeriods();
                    }
                }
            }
            catch (IndException ex)
            {
                ShowDefaultPageError(ex);
                return;
            }
            catch (Exception ex)
            {
                ShowDefaultPageError(new IndException(ex));
                return;
            }

            // do not use this code inside of the try ... catch
            string newPage = Request.QueryString["NewPage"];
            string code = Request.QueryString["Code"];
            string projectId = Request.QueryString["ProjectId"];

            if (!String.IsNullOrEmpty(newPage))
            {
                if (!String.IsNullOrEmpty(code))
                {
                    if (code == ApplicationConstants.MODULE_WORK_PACKAGE)
                    {
                        //set the current project
                        if (!String.IsNullOrEmpty(projectId))
                            SetCurrentProject(Convert.ToInt32(projectId));
                        
                        //redirect to corresponding catalogue
                        Response.Redirect("Catalogs.aspx?Code=" + code + "&ProjectId=" + projectId);
                    }
                    else
                        Response.Redirect("Catalogs.aspx?Code=" + code);
                }
            }
        }
        #endregion Event Handlers

        #region Private Methods

        private void SetApplicationSettings()
        {
            Configuration configSql = WebConfigurationManager.OpenWebConfiguration("~");
            SqlSettingsSection sqlSection = (SqlSettingsSection)configSql.GetSection("SqlSettings");

            ApplicationSettings settings = new ApplicationSettings();

            settings.SqlDatabaseName = sqlSection.SqlDatabaseName;
            settings.SqlPassword = sqlSection.SqlPassword;
            settings.SqlUserName = sqlSection.SqlUserName;
            settings.SqlServerName = sqlSection.SqlServerName;
            settings.ConnectionTimeout = sqlSection.ConnectionTimeout;
            settings.CommandTimeout = sqlSection.CommandTimeout;

            Configuration configMail = WebConfigurationManager.OpenWebConfiguration("~");
            MailSettingsSection mailSection = (MailSettingsSection)configMail.GetSection("MailSettings");

            settings.MailFrom = mailSection.AdministrativeMail;
            settings.MailServer = mailSection.MailServer;

            SessionManager.SetSessionValue((IndBasePage)this, SessionStrings.APPLICATION_SETTINGS, settings);
        }

        /// <summary>
        /// Updates the Olap_Periods table. Checks if the max year is equal to the current year + 2 and if it is not, updates the periods
        /// </summary>
        private void UpdateOlapPeriods()
        {
            object connectionManager = SessionManager.GetConnectionManager(this);
            if (connectionManager == null)
                throw new IndException("Connection Manager is null!");
            OlapHelper olapHelper = new OlapHelper(connectionManager);
            olapHelper.GetEntity().ExecuteCustomProcedure("UpdateOlapPeriods", olapHelper);
        }

        private void ShowDefaultPageError(Exception exc)
        {           
            SessionManager.SetSessionValue(this, SessionStrings.ERROR_MESSAGE, new IndException(exc));           
            this.ResponseRedirect("~/UnhandledError.aspx");
        }

        private void SetCurrentProject(int projectId)
        {
            CurrentProject prj = new CurrentProject(null);
            ProjectSelectorFilter prjFilter = new ProjectSelectorFilter(ApplicationConstants.INT_NULL_VALUE, projectId, 
                                SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));

            prj.Id = prjFilter.IdProject;

            //NOTE: in some conditions below line gives an error 
            //because the object is looked for on a different session
            prj.IdAssociate = SessionManager.GetCurrentUser((IndBasePage)this.Page).IdAssociate;
            prj.IdProgram = prjFilter.IdProgram;
            prj.IdOwner = prjFilter.IdOwner;
            prj.Name = prjFilter.ProjectName;

            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.CURRENT_PROJECT, prj);
        }

        #endregion Private Methods
    }
}
