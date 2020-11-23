using System;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.Entities;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.DataAccess;
using System.Data;

public partial class UserControls_WorkPackage_WorkPackageView : GenericUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {       
        try
        {
            wp.EntityType = typeof(WorkPackage);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL, ApplicationConstants.MODULE_WORK_PACKAGE);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL, ApplicationConstants.MODULE_WORK_PACKAGE);
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
            this.ModuleCode = ApplicationConstants.MODULE_WORK_PACKAGE;
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
            base.SetViewEntityProperties(entity);

            CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER);
            if (currentUser.GetPermission(ApplicationConstants.MODULE_WORK_PACKAGE, Operations.Edit) == Permissions.Restricted)
            {
                ((WorkPackage)entity).IdAssociate = ((CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER)).IdAssociate;
            }      

            //the below tests shows that we are opening the WP catalogue in a new window 
            //from an existing indev3 instance
            string strProjectId = Request.QueryString["ProjectId"];
            if (!String.IsNullOrEmpty(strProjectId))
            {
                int projectId = Convert.ToInt32(strProjectId);

                //we set the projectId for the work package catalogue
                ((WorkPackage)entity).IdProject = projectId;
            }
            else
            {
                ((WorkPackage)entity).IdProject = ((CurrentProject)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_PROJECT)).Id;
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