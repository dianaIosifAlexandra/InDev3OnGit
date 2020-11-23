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
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.Common;

/// <summary>
/// This page is the Select country pop-up which appears when the application starts, the session expires or when pressing Change button
/// from User settings. It is not inherited from IndBasePage because, in that case, an infinite loop would occur (because the code that opens this
/// window is in the load event handler of IndBasePage)
/// </summary>
public partial class Pages_Authorization_SelectUserCountry : Page
{
    #region Event Handlers
    protected void Page_Load(object sender, EventArgs e)
    {
        int ALWAYS_EXPIRES = -1440;

        //Add code to remove caching of any of the application pages
        Response.CacheControl = "no-cache";
        Response.Expires = ALWAYS_EXPIRES;
        Response.AddHeader("Pragma", "no-cache");

        if (!IsPostBack)
        {
            LoadCountries();
        }
    }
    
    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        //Resize the height of the pop-up on submit, if it is the case
        if (!ClientScript.IsOnSubmitStatementRegistered(this.Page.GetType(), "ResizePopUp"))
        {
            ClientScript.RegisterOnSubmitStatement(this.Page.GetType(), "ResizePopUp", "SetPopUpHeight();");
        }
        //Get the bool value indicating if the page is opened from user settings page or not
        bool isFromUserSettings = String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["UserSettings"]) ? false : true;
        if (!isFromUserSettings)
        {
            //Hide the cancel button if not coming from user settings
            btnCancel.Visible = false;
        }
    }

    protected void btnLogin_Click(object sender, ImageClickEventArgs e)
    {
        if (Page.IsValid)
        {
            //Get the bool value indicating if the page is opened from user settings page or not
            bool isFromUserSettings = String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["UserSettings"]) ? false : true;
            //If the page is not opened from user settings, the former information about the current user is deleted and the current country
            //id is put into session so that the next time IndBasePage loads, it will load the new user
            if (!isFromUserSettings)
            {
                //Store the selected country into session
                Session[SessionStrings.CURRENT_USER_COUNTRY_ID] = int.Parse(cmbCountries.SelectedValue);
                //Erase the previous information about this user so that it is refreshed
                Session[SessionStrings.CURRENT_USER] = null;
                Session[SessionStrings.CURRENT_PROJECT] = null;
            }
            //If the page is opened from user settings, the new user must not be save until the "Save configuration" button is pressed in that
            //page. A new temporary currentuser object is created which will be the current user of the application once the user settings are
            //saved
            else
            {
                if (Session[SessionStrings.INERGY_LOGIN] == null)
                {
                    ClientScript.RegisterClientScriptBlock(this.GetType(), "SessionExpiredClose", "doReturn(-1);", true);
                    return;
                }
                object connectionManager = Session[SessionStrings.CONNECTION_MANAGER];
                CurrentUser tempCurrentUser = new CurrentUser(Session[SessionStrings.INERGY_LOGIN].ToString(), connectionManager);
                tempCurrentUser.IdCountry = int.Parse(cmbCountries.SelectedValue);
                tempCurrentUser.LoadUserDetails();
                Session[SessionStrings.TEMP_CURRENT_USER] = tempCurrentUser;
            }
            //Close the pop-up
            if (!ClientScript.IsClientScriptBlockRegistered(this.GetType(), "CloseSelectCountryPopUp"))
                ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseSelectCountryPopUp", "doReturn(1);", true);
        }
    }

    protected override void RenderChildren(HtmlTextWriter writer)
    {
        //Set the height of the countries combobox so that scrollbars do not appear in this pop-up window
        if (cmbCountries.Items.Count >= 3)
            cmbCountries.Height = Unit.Pixel(69);
        else
            cmbCountries.Height = Unit.Empty;
        base.RenderChildren(writer);
    }
    #endregion Event Handlers

    #region Private Methods
    /// <summary>
    /// Loads the countries of the users that have the given inergy login from the database
    /// </summary>
    private void LoadCountries()
    {
        if (Session[SessionStrings.INERGY_LOGIN] == null)
        {
            ClientScript.RegisterClientScriptBlock(this.GetType(), "SessionExpiredClose", "doReturn(-1);", true);
            return;
        }

        string inergyLogin = Session[SessionStrings.INERGY_LOGIN].ToString();
        //Build a currentUser object only to get the countries of the user having the known inergy login (the inergy login is the only
        //information we know so far when opening this window when the application starts or after the session has expired)
        CurrentUser newCurrentUser = new CurrentUser(inergyLogin, Session[SessionStrings.CONNECTION_MANAGER]);
        DataTable tblCountries = newCurrentUser.GetUserCountries();
        DSUtils.AddEmptyRecord(tblCountries);

        //Get the bool value indicating if the page is opened from user settings page or not
        bool isFromUserSettings = String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["UserSettings"]) ? false : true;
        if (isFromUserSettings)
        {
            if (Session[SessionStrings.CURRENT_USER] == null)
            {
                ClientScript.RegisterClientScriptBlock(this.GetType(), "SessionExpiredClose", "doReturn(-1);", true);
                return;
            }
            tblCountries.PrimaryKey = new DataColumn[] { tblCountries.Columns["Id"] };

            int currentCountryId = ((CurrentUser)Session[SessionStrings.CURRENT_USER]).IdCountry;
            DataRow currentCountryRow = tblCountries.Rows.Find(currentCountryId);

            tblCountries.Rows.Remove(currentCountryRow);
        }
        
        cmbCountries.DataSource = tblCountries;
        cmbCountries.DataValueField = "Id";
        cmbCountries.DataTextField = "Name";
        cmbCountries.DataBind();
    }
    #endregion Private Methods
}
