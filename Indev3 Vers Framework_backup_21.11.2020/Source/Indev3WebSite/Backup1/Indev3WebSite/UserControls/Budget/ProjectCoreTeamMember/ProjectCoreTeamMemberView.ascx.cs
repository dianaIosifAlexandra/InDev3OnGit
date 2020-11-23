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
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_Budget_ProjectCoreTeamMember_ProjectCoreTeamMemberView : GenericUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ProjectCoreTeamMemberViewControl.EntityType = typeof(ProjectCoreTeamMember);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL, ApplicationConstants.MODULE_CORE_TEAM);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL, ApplicationConstants.MODULE_CORE_TEAM);
            
            SetCopyTeamButtonProperties();
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

    protected override void ApplyPermissions()
    {
        try
        {
            this.ModuleCode = ApplicationConstants.MODULE_CORE_TEAM;
            //Instead of calling the GenericViewControl method ApplayPerrmissions from here
            //we will call it from its class beacuse of the event order
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

    public override void SetViewEntityProperties(IGenericEntity entity)
    {
        try
        {
            CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER);
            if (currentUser.GetPermission(ApplicationConstants.MODULE_CORE_TEAM, Operations.View) == Permissions.Restricted)
            {
                base.SetViewEntityProperties(entity);
                ((ProjectCoreTeamMember)entity).IdProject = ((CurrentProject)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_PROJECT)).Id;
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
    
    private void SetCopyTeamButtonProperties()
    {
		try
		{
			CurrentProject currentProject = SessionManager.GetCurrentProject(this.Page) as CurrentProject;
			object connectionManager = SessionManager.GetConnectionManager(this.Page);
			if (connectionManager != null)
			{
				ProjectCoreTeamMember coreTeamMember = new ProjectCoreTeamMember(connectionManager);
				coreTeamMember.IdProject = currentProject.Id;
				coreTeamMember.IdAssociate = currentProject.IdAssociate;

				btnOpenPopupCopyCoreTeam.Visible = (coreTeamMember.IsAssociatePMOnProject());
				btnOpenPopupCopyCoreTeam.OnClientClick = "ShowPopUpWithReload('" +
					ResolveUrl("~/UserControls/Budget/ProjectCopyCoreTeam/CopyCoreTeam.aspx") + "', 0, 700, '" +
					ResolveUrl("~/Catalogs.aspx?Code=CRT") + "', '" +
					ResolveUrl("~/Default.aspx?SessionExpired=1") + "', 'true', '" + this.Page.Form.ClientID + "');return false;";
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
}
