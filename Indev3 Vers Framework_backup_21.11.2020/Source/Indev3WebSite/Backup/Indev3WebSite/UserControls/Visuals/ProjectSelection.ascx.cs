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
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;

public partial class UserControls_Visuals_ProjectSelection : GenericUserControl
{
    private const int ProjectLength = 55;
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //Set the module code of this user control
            this.ModuleCode = ApplicationConstants.MODULE_PROJECT_SELECTION;
            CurrentProject project = (CurrentProject)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_PROJECT);
            string url = ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx");
            lnkChange.OnClientClick = "return ShowPopUpWithoutPostBackWithDirtyCheck('" + url + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')";
            lblProjectName.Text = (project == null) ? "No project selected" : "Current project: " + ApplicationUtils.DisplayEntity(project.Name, ProjectLength);
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
    /// Apply permissions to project selection
    /// </summary>
    protected override void ApplyPermissions()
    {
        try
        {
            CurrentUser currentUser;
            if ((currentUser = (CurrentUser)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER)) == null)
            {
                lnkChange.Enabled = false;
                lnkChange.OnClientClick = String.Empty;
                return;
            }

            base.ApplyPermissions();
            //The "Change" link will not be enabled if the current user does not have permission to change the project.
            lnkChange.Enabled = currentUser.HasViewPermission(this.ModuleCode);
            //If the label is disabled, erase its client click event
            if (!lnkChange.Enabled)
            {
                lnkChange.OnClientClick = String.Empty;
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
