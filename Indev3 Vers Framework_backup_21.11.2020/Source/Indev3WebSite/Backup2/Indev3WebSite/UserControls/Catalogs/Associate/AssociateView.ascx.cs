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
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_Associate_AssociateView : GenericUserControl
{
    /// <summary>
    /// Page_Load event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //Set the entity type of this view control
            AssociateViewControl.EntityType = typeof(Associate);
            //Save the ViewControl and EditControl in session
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL, ApplicationConstants.MODULE_ASSOCIATE);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL, ApplicationConstants.MODULE_ASSOCIATE);
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
            this.ModuleCode = ApplicationConstants.MODULE_ASSOCIATE;
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
            if (currentUser.GetPermission(ApplicationConstants.MODULE_ASSOCIATE, Operations.View) == Permissions.Restricted)
            {
                ((Associate)entity).IdCountry = ((CurrentUser)SessionManager.GetCurrentUser(this.Page)).IdCountry;              
            }
            ((Associate)entity).IdCurrentAssociate = ((CurrentUser)SessionManager.GetCurrentUser(this.Page)).IdAssociate;
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