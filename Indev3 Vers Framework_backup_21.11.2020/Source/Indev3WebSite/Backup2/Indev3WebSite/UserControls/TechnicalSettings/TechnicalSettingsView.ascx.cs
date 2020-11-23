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
using Inergy.Indev3.WebFramework.GenericControls;

using Inergy.Indev3.ApplicationFramework;
using System.Web.Configuration;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Telerik.WebControls;
using System.Data.SqlClient;
using Inergy.Indev3.WebFramework.Utils;

namespace Inergy.Indev3.UI
{
    public partial class UserControls_Settings_TechnicalSettingsView : GenericUserControl
    {
        #region Event Handlers
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    LoadData();
                }
                RadAjaxManager ajaxManager = ((IndBasePage)this.Page).GetAjaxManager();
                Panel pnlErrors = (Panel)this.Page.Master.FindControl("pnlErrors");
                ajaxManager.AjaxSettings.AddAjaxSetting(pnlMailSettings, pnlErrors);
                ajaxManager.AjaxSettings.AddAjaxSetting(pnlSqlServerSettings, pnlErrors);
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            //save in configuration sql section
            try
            {
                SaveSettings();
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (SqlException ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
            Response.Redirect("~/Default.aspx");
        }


        #endregion Event Handlers

        #region Private Methods
        /// <summary>
        /// load data from web.config file to textboxes
        /// </summary>
        private void LoadData()
        {
            ApplicationSettings settings = (ApplicationSettings)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.APPLICATION_SETTINGS);
            txtSqlServerName.Text = settings.SqlServerName;
            txtSqlDatabaseName.Text = settings.SqlDatabaseName;
            txtSqlServerPassword.Text = settings.SqlPassword;
            txtSqlServerUserName.Text = settings.SqlUserName;

            txtMailServer.Text = settings.MailServer;
            txtAdministrativeMail.Text = settings.MailFrom;


        }
        /// <summary>
        /// save data from textboxes to web.config file
        /// </summary>
        /// <returns></returns>
        private void SaveSettings()
        {
            ApplicationSettings settings = (ApplicationSettings)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.APPLICATION_SETTINGS);
            //save in ApplicationSettings object

            TestSqlConnection();

            settings.SqlServerName = txtSqlServerName.Text;
            settings.SqlDatabaseName = txtSqlDatabaseName.Text;
            settings.SqlPassword = txtSqlServerPassword.Text;
            settings.SqlUserName = txtSqlServerUserName.Text;
            settings.MailServer = txtMailServer.Text;
            settings.MailFrom = txtAdministrativeMail.Text;

            Configuration configSql = WebConfigurationManager.OpenWebConfiguration("~");
            SqlSettingsSection sqlSection = (SqlSettingsSection)configSql.GetSection("SqlSettings");

            sqlSection.SqlDatabaseName = settings.SqlDatabaseName;
            sqlSection.SqlPassword = settings.SqlPassword;
            sqlSection.SqlUserName = settings.SqlUserName;
            sqlSection.SqlServerName = settings.SqlServerName;
            configSql.Save();


            //save in mailsettings congfiguration file

            Configuration configMail = WebConfigurationManager.OpenWebConfiguration("~");
            MailSettingsSection mailSection = (MailSettingsSection)configMail.GetSection("MailSettings");
            mailSection.MailServer = settings.MailServer;
            mailSection.AdministrativeMail = settings.MailFrom;
            configMail.Save();

            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.APPLICATION_SETTINGS, settings);
        }

        /// <summary>
        /// test sql connection for data in textboxes
        /// </summary>
        private void TestSqlConnection()
        {
            string connString = "Data Source=" + txtSqlServerName.Text + ";Initial Catalog=" + txtSqlDatabaseName.Text + ";User ID=" + txtSqlServerUserName.Text + ";Password=" + txtSqlServerPassword.Text + ";";
            SqlConnection cn = new SqlConnection(connString);
            try
            {
                cn.Open();
            }
            finally
            {
                cn.Close();
            }
        }

        #endregion
        #region Events
       
        

        protected void btnTestSqlConnection_Click(object sender, EventArgs e)
        {
            try
            {
                TestSqlConnection();
                if (!Page.ClientScript.IsClientScriptBlockRegistered(Page.GetType(), "ConnOpen"))
                {
                    Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "ConnOpen", "DoAlertMessage('Connection test succeeded!')", true);
                }
            }
            catch (SqlException ex)
            {
                HideChildControls();
                if (!Page.ClientScript.IsClientScriptBlockRegistered(Page.GetType(), "ConnNotOpen"))
                {
                    Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "ConnNotOpen", "DoAlertMessage('Connection test failed!')", true);
                    Logger.WriteLine(ex.Message);
                }
            }
        }

        private void HideChildControls()
        {
            lblMailServer.Visible = false;
            txtMailServer.Visible = false;
            lblAdministrativeMail.Visible = false;
            txtAdministrativeMail.Visible = false;
            lblSqlServerName.Visible = false;
            txtSqlServerName.Visible = false;
            lblSqlServerUserName.Visible = false;
            txtSqlServerUserName.Visible = false;
            lblSqlServerPassword.Visible = false;
            txtSqlServerPassword.Visible = false;
            lblSqlDatabaseName.Visible = false;
            txtSqlDatabaseName.Visible = false;
            lblWarning.Visible = false;
        }
 
        #endregion Private Methods

    }
}
