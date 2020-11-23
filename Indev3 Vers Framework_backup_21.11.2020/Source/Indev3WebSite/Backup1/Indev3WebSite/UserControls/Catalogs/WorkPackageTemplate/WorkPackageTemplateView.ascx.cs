using System;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.Entities;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.WebFramework.Utils;

public partial class UserControls_Catalogs_WorkPackageTemplate_WorkPackageTemplateView : GenericUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            wp.EntityType = typeof(WorkPackageTemplate);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL, ApplicationConstants.MODULE_WORK_PACKAGE_TEMPLATE);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL, ApplicationConstants.MODULE_WORK_PACKAGE_TEMPLATE);
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
            this.ModuleCode = ApplicationConstants.MODULE_WORK_PACKAGE_TEMPLATE;
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
            if (currentUser.GetPermission(ApplicationConstants.MODULE_WORK_PACKAGE_TEMPLATE, Operations.Edit) == Permissions.Restricted)
            {
                base.SetViewEntityProperties(entity);
            }

            //((WorkPackageTemplate)entity).IdProject = ((CurrentProject)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_PROJECT)).Id;
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
