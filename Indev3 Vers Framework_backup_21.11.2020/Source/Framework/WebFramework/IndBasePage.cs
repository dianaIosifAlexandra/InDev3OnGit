using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Authorization;
using System.Security.Principal;
using Inergy.Indev3.ApplicationFramework;
using System.Web;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Configuration;
using System.Web.Configuration;
using System.Web.UI.WebControls;
using System.Collections;
using System.Drawing;
using System.Web.UI.HtmlControls;
using Telerik.WebControls;
using Inergy.Indev3.BusinessLogic.Common;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic;
using System.Diagnostics;


namespace Inergy.Indev3.WebFramework
{
    /// <summary>
    /// The base class for all pages in the application
    /// </summary>
    public abstract class IndBasePage : Page
    {
        #region Members
        private const int ALWAYS_EXPIRES = -1440;
        private HtmlInputHidden IsDirty;
        private bool ResponseShouldTerminate;
        protected bool PageLoadSucceeded;
        #endregion Members

        #region Properties
        protected EncryptingSupport encryptingSupport;
        internal virtual Panel pnlErrors
        {
            get 
            {
                return GetErrorsPanel();
            }
        }

        public bool PageResponseShouldTerminate
        {
            get
            {
                return ResponseShouldTerminate;
            }
        }
        #endregion


        #region Constructors
        public IndBasePage()
        {
            PageLoadSucceeded = true;
            encryptingSupport = new EncryptingSupport();
        }
        #endregion Constructors

        #region Public Methods
        public bool BuildCurrentUserSession()
        {
            try
            {
                if (SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_USER) == null)
                {
                    CurrentUser currentUser = new CurrentUser(User.Identity.Name, SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
                    if (SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_USER_COUNTRY_ID) != null)
                    {
                        currentUser.IdCountry = (int)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_USER_COUNTRY_ID);
                    }
                    else
                    {
                        currentUser.IdCountry = ApplicationConstants.INT_NULL_VALUE;
                    }
                    int noUsers = currentUser.LoadUserDetails();

                    //if we have more than one user and no country is specified 
                    //we redirect and show the popup to majke the user choose his country
                    if (noUsers > 1)
                    {
                        SessionManager.SetSessionValue(this, SessionStrings.INERGY_LOGIN, User.Identity.Name);
                        if (!ClientScript.IsStartupScriptRegistered(this.GetType(), "OpenSelectCountryPopUp"))
                        {
                            //The url of the page which will be loaded after the select countries pop-up is closed
                            string returnUrl = Request.Url.ToString();
                            //If the session has expired, redirect to default.aspx page (removing the query string which indicates that the 
                            //session has expired) after select country pop-up is closed
                            if (HttpContext.Current.Request.QueryString.Keys.Count > 0 && !String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["SessionExpired"]))
                            {
                                returnUrl = "~/Default.aspx";
                            }
                            ClientScript.RegisterStartupScript(this.GetType(), "OpenSelectCountryPopUp", "ShowPopUp('" + ResolveUrl("~/Pages/Authorization/SelectUserCountry.aspx") + "', 0, 300, '" + ResolveUrl(returnUrl) + "', '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "');", true);
                        }
                        return false;
                    }

                    if (currentUser.IdAssociate != ApplicationConstants.INT_NULL_VALUE)
                    {
                        SessionManager.SetSessionValue(this, SessionStrings.CURRENT_USER, currentUser);
                    }
                    else
                    {
                        ShowError(new IndException(ApplicationMessages.EXCEPTION_NOT_HAVE_RIGHTS + User.Identity.Name));
                        return false;
                    }
                }
                return true;
            }
            catch (IndException ex)
            {
                ShowError(ex);
                return false;
            }
            catch (InvalidCastException invCastEx)
            {
                ShowError(new IndException(invCastEx));
                return false;
            }
        }

        /// <summary>
        /// Returns the Ajax Manager on the master page
        /// </summary>
        /// <param name="currentPage"></param>
        /// <returns></returns>
        public RadAjaxManager GetAjaxManager()
        {
            RadAjaxManager ajaxManager;
            try
            {
                ajaxManager = this.Master.FindControl("Aj") as RadAjaxManager;
            }
            catch (Exception ex)
            {
                ShowError(new IndException(ex));
                return null;
            }
            //If the control is not found the method returns null
            return ajaxManager;
        }

        public virtual void CSVExport()
        {
        }

        public void SetDirty(bool bDirty)
        {
            HtmlInputHidden controlDirty = (HtmlInputHidden)this.FindControl("IsDirty");
            controlDirty.Value = bDirty ? "1" : "0";
        }

        #endregion Public Methods

        #region Protected Methods
        /// <summary>
        /// Displays an error pop-up 
        /// </summary>
        /// <param name="errorMsg">The message displayed in the pop-up</param>
        protected internal virtual void ShowError(IndException indExc)
        {
            AddError(indExc.Message);
        }

        protected internal virtual void ShowError(ArrayList errors)
        {
            foreach (string error in errors)
            {
                AddError(error);
            }
        }

        protected virtual void HideChildControls()
        {
            //TODO add code in derived pages
        }
        protected override void OnInit(EventArgs e)
        {
            //Add code to remove caching of any of the application pages
            Response.CacheControl = "no-cache";
            Response.Expires = ALWAYS_EXPIRES;
            Response.AddHeader("Pragma", "no-cache");
            base.OnInit(e);
        }
        /// <summary>
        /// Override the load event of the page
        /// </summary>
        /// <param name="e"></param>
        protected override void OnLoad(EventArgs e)
        {
            ApplicationSettings settings = (ApplicationSettings)SessionManager.GetSessionValueRedirect((IndBasePage)this, SessionStrings.APPLICATION_SETTINGS);
            if (settings == null)            
                return;//the page should be already redirected.

            base.OnLoad(e);

            try
            {
                if (SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER) == null)
                {
                    SessionConnectionHelper sessionConnectionHelper = new SessionConnectionHelper();
                    object connectionManager = sessionConnectionHelper.GetNewConnectionManager(settings.ConnectionString, settings.CommandTimeout);
                    SessionManager.SetSessionValue(this, SessionStrings.CONNECTION_MANAGER, connectionManager);
                }

                //If there is no user information in the session
                if (BuildCurrentUserSession())
                    BuildUserSettingsSession();


                //Store the default accounts into the application list
                if (Application[SessionStrings.DEFAULT_ACCOUNTS] == null)
                {
                    object connectionManager = SessionManager.GetConnectionManager(this);
                    Application[SessionStrings.DEFAULT_ACCOUNTS] = EntityUtils.GetDefaultAccounts(connectionManager);
                }
                //Store the exportable catalog codes
                if (Application[SessionStrings.EXPORTABLE_CATALOG_CODES] == null)
                {
                    Application[SessionStrings.EXPORTABLE_CATALOG_CODES] = EntityUtils.GetExportableCatalogs();
                }
            }
            catch (IndException indExc)
            {
                this.ShowError(indExc);
                PageLoadSucceeded = false;
                return;
            }
            catch (Exception exc)
            {
                this.ShowError(new IndException(exc));
                PageLoadSucceeded = false;
                return;
            }

        }

        /// <summary>
        /// Handles any uncaught exception
        /// </summary>
        /// <param name="e"></param>
        protected override void OnError(EventArgs e)
        {
            HttpContext ctx = HttpContext.Current;
            //Get the exception
            Exception exc = ctx.Server.GetLastError();
            //Redirect to the error aspx
            SessionManager.SetSessionValue(this, SessionStrings.ERROR_MESSAGE, new IndException(exc));
            ResponseRedirect("~/UnhandledError.aspx");
        }

        protected override void CreateChildControls()
        {
            IsDirty = new HtmlInputHidden();
            IsDirty.ID = "IsDirty";
            IsDirty.Value = "0";
            this.Controls.Add(IsDirty);
            try
            {
                base.CreateChildControls();
            }
            catch (IndException indExc)
            {
                ShowError(indExc);
                return;
            }
        }
        #endregion Protected Methods

        #region Private Methods
        private void AddError(String errMessage)
        {
            Label lblError = new Label();

            lblError.ID = "lblError" + encryptingSupport.GetUniqueKey();
            lblError.Text = errMessage;
            lblError.CssClass = CSSStrings.ErrorLabelCssClass;

            GetErrorsPanel().Controls.Add(lblError);
            LiteralControl br = new LiteralControl("<BR>");
            GetErrorsPanel().Controls.Add(br);
        }

        private void BuildUserSettingsSession()
        {
            //Instantiate a CurrentUser object 
            CurrentUser currentUser = SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_USER) as CurrentUser;

            if (currentUser.Settings == null)
            {
                if (currentUser.IdAssociate != ApplicationConstants.INT_NULL_VALUE)
                {
                    UserSettings userSettings = new UserSettings(currentUser.IdAssociate, SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
                    DataTable userSettingsDataTable = userSettings.SelectUserSettings();
                    if (userSettingsDataTable.Rows.Count == 1)
                    {
                        DataRow row = userSettingsDataTable.Rows[0];
                        currentUser.Settings = new UserSettings(currentUser.IdAssociate, (AmountScaleOption)row["AmountScaleOption"], (int)row["NumberOfRecordsPerPage"], (CurrencyRepresentationMode)row["CurrencyRepresentation"], SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
                    }
                    else
                    {
                        currentUser.Settings = new UserSettings(currentUser.IdAssociate, SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
                    }
                }
            }
        }
        
        private Panel GetErrorsPanel()
        {
            Panel _pnlErrors = null;

            if(base.Master != null)
                _pnlErrors = base.Master.FindControl("pnlErrors") as Panel;
            else
                _pnlErrors = base.FindControl("pnlErrors") as Panel;

            Debug.Assert(_pnlErrors != null, ApplicationMessages.EXCEPTION_PANEL_NOT_EXIST);
            
            return _pnlErrors;
        }
        #endregion Private Methods

        #region Methods for handling redirect 
        public void ResponseRedirect(string URL)
        {
            //mak the fact the we need to avoid some of the following events from the page
            ResponseShouldTerminate = true;

            //if claine has already cliecked on another page this is false
            if (this.Response.IsClientConnected)
            {
                // If still connected, redirect
                // to another page. 
                this.Response.Redirect(URL, false);

                //finish the request - we are now redirected
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            else
            {
                // If the browser is not connected
                // stop all response processing.
                Response.End();
            }
        }

        protected override void RaisePostBackEvent(IPostBackEventHandler sourceControl, string eventArgument)
        {
            if (ResponseShouldTerminate == false)
                base.RaisePostBackEvent(sourceControl, eventArgument);
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (ResponseShouldTerminate == false)
                base.Render(writer);
        }
        #endregion
    }
}
