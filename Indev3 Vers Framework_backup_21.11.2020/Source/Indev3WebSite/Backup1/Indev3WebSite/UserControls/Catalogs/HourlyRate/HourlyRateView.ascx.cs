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
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.Entities;
using Telerik.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_HourlyRate_HourlyRateView : GenericUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            RadAjaxManager ajaxManager = ((IndBasePage)this.Page).GetAjaxManager();
            ajaxManager.AjaxSettings.Clear();
            ajaxManager.EnableAJAX = false;

            this.HourlyRateViewControl.DataSourcePersistent = false;
            HourlyRateViewControl.EntityType = typeof(HourlyRate);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL, ApplicationConstants.MODULE_HOURLY_RATE);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL, ApplicationConstants.MODULE_HOURLY_RATE);
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
            this.ModuleCode = ApplicationConstants.MODULE_HOURLY_RATE;
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
    
    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            base.OnPreRender(e);
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
            if (currentUser.GetPermission(ApplicationConstants.MODULE_HOURLY_RATE, Operations.View) == Permissions.Restricted)
            {
                base.SetViewEntityProperties(entity);
                ((HourlyRate)entity).IdCountry = ((CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER)).IdCountry;
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