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
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_ProjectType_ProjectTypeView : GenericUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ProjectTypeViewControl.EntityType = typeof(ProjectType);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL, ApplicationConstants.MODULE_PROJECT_TYPE);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL, ApplicationConstants.MODULE_PROJECT_TYPE);
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
            this.ModuleCode = ApplicationConstants.MODULE_PROJECT_TYPE;
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
}
