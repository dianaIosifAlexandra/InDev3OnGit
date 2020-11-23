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
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework;
using Telerik.WebControls;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework;


public partial class UserControls_Budget_ProjectCoreTeamMember_ProjectCoreTeamMemberEdit : GenericUserControl
{
    #region Members
    private CurrentProject CurrentProject;
    #endregion Members

    #region Constructors
    public UserControls_Budget_ProjectCoreTeamMember_ProjectCoreTeamMemberEdit()
    {
        this.Entity = new ProjectCoreTeamMember();
    }
    #endregion Constructors

    #region Event Handlers
    protected void Page_Load(object sender, EventArgs e)
    {
        base.OnPreRender(e);
        try
        {
            //If we are in edit mode, set the before save operation
            if (ProjectCoreTeamMemberEditControl.EditMode)
            {
                ProjectCoreTeamMemberEditControl.BeforeSave = new GenericEditControl.BeforeSaveDelegate(BeforePCTSave);
            }

            //If IsPostBack is true and if we are not in edit mode, add the after save handler to be exectuted after the actual save
            if (IsPostBack && !ProjectCoreTeamMemberEditControl.EditMode)
                ProjectCoreTeamMemberEditControl.AddSaveHandler(AfterSave);

            if (!IsPostBack)
            {
                if (SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CORE_TEAM_ASSOCIATE) != null)
                    SessionManager.RemoveValueFromSession((IndBasePage)this.Page, SessionStrings.CORE_TEAM_ASSOCIATE);

                CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.CURRENT_USER);
                if ((currentUser.UserRole.Id != ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR && currentUser.UserRole.Id != ApplicationConstants.ROLE_KEY_USER) || currentUser.IdAssociate == ((ProjectCoreTeamMember)ProjectCoreTeamMemberEditControl.Entity).IdAssociate || !ProjectCoreTeamMemberEditControl.EditMode)
                {
                    trImpersonate.Visible = false;
                }
                else
                {
                    trImpersonate.Visible = true;
                    chkImpersonate.Checked = currentUser.IdImpersonatedAssociate == ((ProjectCoreTeamMember)ProjectCoreTeamMemberEditControl.Entity).IdAssociate;
                }
            }

            btnSelect.Click += new EventHandler(btnSelect_Click);
            if ((CurrentProject = (CurrentProject)SessionManager.GetSessionValueRedirect((IndPopUpBasePage)this.Page, SessionStrings.CURRENT_PROJECT)) != null)
            {
                ((ProjectCoreTeamMember)this.Entity).IdProject = CurrentProject.Id;
            }
            //Disable the parent ajax because we have an ajax manager on this page
            ProjectCoreTeamMemberEditControl.AjaxManager.EnableAJAX = false;
            if (this.ProjectCoreTeamMemberEditControl.EditMode == true)
            {
                btnSelect.Enabled = false;
                lblLastUpdateText.Visible = true;
            }
            else
            {
                lblLastUpdateText.Visible = false;
            }

            //If before save has been pressed, the save operation has already occured by this point and call the after save operation
            string eventArgs = Request.Params.Get("__EVENTARGUMENT");
            if (IsPostBack && !String.IsNullOrEmpty(eventArgs) && eventArgs.Contains("BeforeSaveMessage"))
            {
                ProjectCoreTeamMemberEditControl.SaveEntity();
                AfterSave(null, null);
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

    protected override void RenderChildren(HtmlTextWriter writer)
    {
        try
        {
            if (cmbFunction.Items.Count >= 3)
                cmbFunction.Height = Unit.Pixel(90);
            else
                cmbFunction.Height = Unit.Empty;

            base.RenderChildren(writer);
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

    private void btnSelect_Click(object sender, EventArgs e)
    {
        try
        {
            if (SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CORE_TEAM_ASSOCIATE) != null)
            {
                txtMember.Text = ((Associate)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CORE_TEAM_ASSOCIATE)).Name;
                txtEmployeeNumber.Text = ((Associate)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CORE_TEAM_ASSOCIATE)).EmployeeNumber;
                this.ParentPage.SetDirty(true);
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

    #region Public Methods
    public void AfterSave(object sender, ImageClickEventArgs e)
    {
        try
        {
            //if we do not have anty error from the save.
            Control pnlErrors = this.ParentPage.FindControl("pnlErrors");
            if (pnlErrors != null && pnlErrors.Controls.Count == 0)
            {
                CurrentUser currentUser = SessionManager.GetCurrentUser(this.Page) as CurrentUser;
                //if the user role changed is exactly the one of the current user
                if (((ProjectCoreTeamMember)ProjectCoreTeamMemberEditControl.Entity).IdAssociate == currentUser.IdAssociate)
                {
                    CurrentUser updatedUser = new CurrentUser(currentUser.InergyLogin, SessionManager.GetConnectionManager(this.Page));
                    updatedUser.IdCountry = currentUser.IdCountry;

                    updatedUser.LoadUserDetails();
                    SessionManager.SetSessionValue(this.Page, SessionStrings.CURRENT_USER, updatedUser);

					CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this.Page, SessionStrings.CURRENT_PROJECT) as CurrentProject;
					ProjectSelectorFilter prjFilter = new ProjectSelectorFilter(ApplicationConstants.INT_NULL_VALUE, currentProject.Id, currentProject.IdAssociate,
								SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
					
					currentProject.ProjectFunctionWPCodeSuffix = prjFilter.ProjectFunctionWPCodeSuffix;
					SessionManager.SetSessionValue(this.Page, SessionStrings.CURRENT_PROJECT, currentProject);
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
    #endregion Public Methods

    #region Private Methods

    private void BeforePCTSave()
    {

        CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.CURRENT_USER);
        if (currentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR || currentUser.UserRole.Id == ApplicationConstants.ROLE_KEY_USER)
        {
            ProjectCoreTeamMember member = (ProjectCoreTeamMember)ProjectCoreTeamMemberEditControl.Entity;
            bool oldIsImpersonated = member.IsImpersonated;
            bool newIsImpersonated = chkImpersonate.Checked;
            member.IsImpersonated = newIsImpersonated;
            if (member.IsImpersonated)
            {
                currentUser.IdImpersonatedAssociate = member.IdAssociate;
                currentUser.NameImpersonatedAssociate = member.CoreTeamMemberName;
                currentUser.IdProjectFunctionImpersonated = member.IdFunction;
                currentUser.IdProjectImpersonated = member.IdProject;
            }
            else
            {
                currentUser.IdImpersonatedAssociate = 0;
                currentUser.NameImpersonatedAssociate = string.Empty;
                currentUser.IdProjectImpersonated = 0;
                currentUser.IdProjectFunctionImpersonated = 0;
            }
        }
        
        bool oldIsActive = ((ProjectCoreTeamMember)ProjectCoreTeamMemberEditControl.Entity).IsActive;
        bool newIsActive = chkActive.Checked;

        //If the core team member was not made inactive from active, do nothing
        if (!oldIsActive || newIsActive)
        {
            Page.ClientScript.RegisterStartupScript(Page.GetType(), "BeforeSaveScript", Page.ClientScript.GetPostBackEventReference(btnDoPostBack, "BeforeSaveMessage"), true);
            return;
        }

        object connectionManager = SessionManager.GetConnectionManager(this.Page);
        if (connectionManager != null)
        {
            ProjectCoreTeamMember coreTeamMember = (ProjectCoreTeamMember)ProjectCoreTeamMemberEditControl.Entity;
            DataSet dsOpenBudgets = coreTeamMember.GetOpenBudgets();
            if (dsOpenBudgets.Tables[0].Rows.Count == 0)
            {
                Page.ClientScript.RegisterStartupScript(Page.GetType(), "BeforeSaveScript", Page.ClientScript.GetPostBackEventReference(btnDoPostBack, "BeforeSaveMessage"), true);
                return;
            }

            foreach (DataRow row in dsOpenBudgets.Tables[0].Rows)
            {
                if (row["BudgetState"].ToString() == ApplicationConstants.BUDGET_STATE_WAITING_APPROVAL ||
                    row["BudgetState"].ToString() == ApplicationConstants.BUDGET_STATE_APPROVED)
                {
                    Page.ClientScript.RegisterStartupScript(Page.GetType(), "BeforeSaveScript", "if (confirm('You are making inactive a Core Team Member which has at least one budget in Waiting for Approval or Approved state. The budget information will be lost. Are you sure you want to continue?')) { " + Page.ClientScript.GetPostBackEventReference(btnDoPostBack, "BeforeSaveMessage") + " }", true);
                    return;
                }
            }

            Page.ClientScript.RegisterStartupScript(Page.GetType(), "BeforeSaveScript", Page.ClientScript.GetPostBackEventReference(btnDoPostBack, "BeforeSaveMessage"), true);
        }
    }
    #endregion Private Methods
}
