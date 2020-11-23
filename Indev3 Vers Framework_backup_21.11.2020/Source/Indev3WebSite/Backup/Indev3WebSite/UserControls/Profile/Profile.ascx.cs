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
using System.Collections.Generic;

using Telerik.WebControls;

using Inergy.Indev3.BusinessLogic.Authorization;

using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.ApplicationFramework.Common;

public partial class UserControls_Profile_Profile : GenericUserControl
{
    #region Members
    /// <summary>
    /// Specifies whether errors appeared during the loading of the page
    /// </summary>
    private bool HasErrors;
    private Profile profile;
    #endregion Members

    #region Event Handlers
    /// <summary>
    /// Page_load event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //This can only happen if the current user has no right in the application (after changing the country, the new user may be
            //in this situaton)
            if (SessionManager.GetCurrentUser(this.Page) != null && !SessionManager.GetCurrentUser(this.Page).HasViewPermission(ApplicationConstants.MODULE_PROFILE))
            {
                HideControls();
                throw new IndException(ApplicationMessages.EXCEPTION_NO_PERMISSION_TO_VIEW_PAGE);
            }

            if (!IsPostBack && HasErrors)
            {
                HideControls();
                return;
            }

            //Instantiate a profile object
            profile = new Profile(SessionManager.GetConnectionManager(this.ParentPage));

            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL, ApplicationConstants.MODULE_PROFILE);
            if (SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.PAGE_NUMBER_MAPPING) != null)
            {
                Dictionary<string, int> pageNoMapping = (Dictionary<string, int>)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.PAGE_NUMBER_MAPPING);
                string controlName = SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL).ToString();
                grdAssociateRoles.CurrentPage = pageNoMapping[controlName];
            }
            RadAjaxManager ajaxManager = ((IndBasePage)this.Page).GetAjaxManager();
            ajaxManager.AjaxSettings.AddAjaxSetting(grdAssociateRoles, grdAssociateRoles);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbAssociates, lblInergyLogin);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbAssociates, cmbRoles);

            Panel pnlErrors = (Panel)this.Page.Master.FindControl("pnlErrors");
            ajaxManager.AjaxSettings.AddAjaxSetting(pnlProfile, pnlErrors);

            //if (!IsPostBack)
            //{
                PopulateControls();
            //}
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
    /// Event handler fort the SelectedIndexChanged event of cmbAssociates
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void cmbAssociates_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        CurrentUser currentUser = ((CurrentUser)SessionManager.GetSessionValueRedirect(this.ParentPage, SessionStrings.CURRENT_USER));

        try
        {
            //Refresh the inergy login label according to the selected assocaite
            if (cmbAssociates.SelectedValue == ApplicationConstants.INT_NULL_VALUE.ToString())
            {
                lblInergyLogin.Text = "";
                cmbRoles.SelectedValue = ApplicationConstants.INT_NULL_VALUE.ToString();
                cmbRoles.Enabled = false;
            }
            else
            {
                cmbRoles.Enabled = true;
                int idAssociate = int.Parse(cmbAssociates.SelectedValue);
                DataTable roleTable = profile.GetAssociateRole(idAssociate);
                if (roleTable.Rows.Count > 0)
                {
                    cmbRoles.SelectedValue = roleTable.Rows[0]["Id"].ToString();
                    if (int.Parse(roleTable.Rows[0]["Id"].ToString()) == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR && 
                        currentUser.UserRole.Id !=ApplicationConstants.ROLE_TECHNICAL_ADMINISTATOR)
                    {
                        RadComboBoxItem item = cmbRoles.FindItemByValue(ApplicationConstants.ROLE_TECHNICAL_ADMINISTATOR.ToString());
                        item.Enabled = false;
                    }
                }
                else
                {
                    cmbRoles.SelectedValue = ApplicationConstants.INT_NULL_VALUE.ToString();
                    cmbRoles.Text = String.Empty;
                }
                //Get the datasource for the cmbProjects combo
                DataTable tbl = (DataTable)cmbAssociates.DataSource;
                DataRow row = tbl.Rows[cmbAssociates.SelectedIndex];
                //Updates the label on the screen
                lblInergyLogin.Text = (row["InergyLogin"] == DBNull.Value) ? "" : row["InergyLogin"].ToString();
            }
        }
        catch (IndException indEx)
        {
            HasErrors = true;
            ReportControlError(indEx);
            return;
        }
        catch (Exception ex)
        {
            HasErrors = true;
            ReportControlError(new IndException(ex));
            return;
        }
    }
    /// <summary>
    /// Event handler for the click event of btnSave
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            int idRole;
            //Get the id of the selected associate
            DataTable associatesTable = (DataTable)cmbAssociates.DataSource;
            if (cmbAssociates.SelectedIndex == ApplicationConstants.INT_NULL_VALUE || (int)associatesTable.Rows[cmbAssociates.SelectedIndex]["Id"] == ApplicationConstants.INT_NULL_VALUE)
            {
                throw new IndException(ApplicationMessages.EXCEPTION_MUST_SELECT_AN_ASSOCIATE);
            }
            int idAssociate = (int)associatesTable.Rows[cmbAssociates.SelectedIndex]["Id"];

            //get the idRole from Request.Form collection because we load the Role combo on every roundtrip to server
            string roleRequest = Request.Form[ApplicationUtils.GetClientValueName(cmbRoles.ClientID)];
            idRole = (string.IsNullOrEmpty(roleRequest))?ApplicationConstants.INT_NULL_VALUE : Int32.Parse(roleRequest);

            //Save the role for the associate
            //If no role was selected, than this associate will have its role deleted
            if (idRole == ApplicationConstants.INT_NULL_VALUE)
            {
                DeleteAssociateRole(idAssociate);
            }
            else
            {
                InsertOrUpdateAssociateRole(idAssociate, idRole);
            }
        }
        catch (IndException indEx)
        {
            HasErrors = true;
            ReportControlError(indEx);
            return;
        }
        catch (Exception ex)
        {
            HasErrors = true;
            ReportControlError(new IndException(ex));
            return;
        }
    }

    #endregion Event Handlers

    #region Private Methods
    private void PopulateControls()
    {
        //Populate the associates combo
        DataTable associatesDataTable = profile.GetAssociates();
        cmbAssociates.DataSource = associatesDataTable;
        cmbAssociates.DataValueField = "Id";
        cmbAssociates.DataTextField = "AssociateCountry";
        cmbAssociates.DataBind();

        //Populate the roles combo
        DataTable rolesTable = profile.GetRoles();
        cmbRoles.DataSource = rolesTable;
        cmbRoles.DataValueField = "Id";
        cmbRoles.DataTextField = "Name";
        cmbRoles.DataBind();
        
        DataTable dtRoles = profile.GetAssociateRoles();
        grdAssociateRoles.VirtualDataSource = dtRoles;
       
    }

    /// <summary>
    /// Hides the controls in the page whenever needed (if an error ocurrs when loading data from the database etc.)
    /// </summary>
    private void HideControls()
    {
        grdAssociateRoles.Visible = false;
        lblAssociates.Visible = false;
        lblInergyLogin.Visible = false;
        lblRoles.Visible = false;
        cmbAssociates.Visible = false;
        cmbRoles.Visible = false;
        btnSave.Visible = false;
        lblRequiredFieldAssociate.Visible = false;
        lblLogin.Visible = false;

    }
    /// <summary>
    /// Removes the role from the given associate
    /// </summary>
    /// <param name="idAssociate">the id of the associate</param>
    private void DeleteAssociateRole(int idAssociate)
    {
        int noRowsAffected = profile.DeleteAssociateRole(idAssociate);
        if (noRowsAffected == 1)
        {
            if (!Page.ClientScript.IsClientScriptBlockRegistered(Page.GetType(), "RemoveConfirmation"))
            {
                Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "RemoveConfirmation", "alert('You have successfully removed the selected associate role.');window.location = 'Catalogs.aspx?Code=" + ApplicationConstants.MODULE_PROFILE + "';", true);
            }
            //If the role of the current user has been modified, clear the session information of the current user, such that it will be 
            //reloaded from the database when IndBasePage loads
            CurrentUser currentUser = ((CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER));
            if (idAssociate == currentUser.IdAssociate)
            {
                //SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.CURRENT_USER, null);
                RefreshCurrentUser(currentUser);
            }
        }
        else
        {
            if (!Page.ClientScript.IsClientScriptBlockRegistered(Page.GetType(), "SaveError"))
            {
                Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "SaveError", "alert('Warning! The selected associate was not added to the selected role.');", true);
            }
        }
    }

    /// <summary>
    /// Adds a role to the given associate or updates the associate role if he does not have one
    /// </summary>
    /// <param name="idAssociate">the id of the associate</param>
    /// <param name="idRole">the id of the role</param>
    private void InsertOrUpdateAssociateRole(int idAssociate, int idRole)
    {
        int noRowsAffected = profile.SaveAssociateRole(idAssociate, idRole);
        if (noRowsAffected == 1)
        {
            if (!Page.ClientScript.IsClientScriptBlockRegistered(Page.GetType(), "SaveConfirmation"))
            {
                Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "SaveConfirmation", "alert('You have successfully updated the role information for the selected associate.');window.location = 'Catalogs.aspx?Code=" + ApplicationConstants.MODULE_PROFILE + "';", true);
            }
            //If the role of the current user has been modified, clear the session information of the current user, such that it will be 
            //reloaded from the database when IndBasePage loads
            CurrentUser currentUser = ((CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER));
            if (idAssociate == currentUser.IdAssociate)
            {
                //SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.CURRENT_USER, null);
                RefreshCurrentUser(currentUser);
            }
        }
        else
        {
            if (!Page.ClientScript.IsClientScriptBlockRegistered(Page.GetType(), "SaveError"))
            {
                Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "SaveError", "alert('Warning! The selected associate was not added to the selected role.');", true);
            }
        }
    }

    private void RefreshCurrentUser(CurrentUser currentUser)
    {
        CurrentUser tempCurrentUser = new CurrentUser(currentUser.InergyLogin.ToString(), SessionManager.GetConnectionManager(this.ParentPage));
        tempCurrentUser.IdCountry = currentUser.IdCountry;
        tempCurrentUser.LoadUserDetails();
        tempCurrentUser.Settings = currentUser.Settings;

        SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.CURRENT_USER, tempCurrentUser);
    }
    
    #endregion Private Methods
}
