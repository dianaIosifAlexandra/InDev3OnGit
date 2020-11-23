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

using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;

public partial class UserControls_Associate_AssociateEdit : GenericUserControl
{
    public UserControls_Associate_AssociateEdit()
    {
        this.Entity = new Associate();
    }
    protected override void OnLoad(EventArgs e)
    {
        try
        {
            base.OnLoad(e);
            this.AssociateEditControl.AddSaveHandler(SaveButton_Click);
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

            if (!IsPostBack)
            {
                CurrentUser currentUser = SessionManager.GetCurrentUser(this.Page);
                Operations operation;
                if (!AssociateEditControl.EditMode)
                {
                    operation = Operations.Add;
                }
                else
                {
                    operation = Operations.Edit;
                }
                if (currentUser.GetPermission(ApplicationConstants.MODULE_ASSOCIATE, operation) == Permissions.Restricted)
                {
                    cmbCountry.Enabled = false;
                    if (!AssociateEditControl.EditMode)
                    {
                        cmbCountry.SelectedValue = currentUser.IdCountry.ToString();
                    }
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
 
    private void SaveButton_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            CurrentUser currentUser = SessionManager.GetCurrentUser(this.Page);

            if (((Associate)this.AssociateEditControl.Entity).Id == currentUser.IdAssociate)
            {
                SessionManager.SetSessionValue(this.Page, SessionStrings.CURRENT_USER, null);
                ((IndBasePage)this.Page).BuildCurrentUserSession();
            }
            if(((Associate)this.AssociateEditControl.Entity).InergyLogin == currentUser.InergyLogin)
                SessionManager.SetSessionValue(this.Page, SessionStrings.INERGY_LOGIN, this.Page.User.Identity.Name);
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