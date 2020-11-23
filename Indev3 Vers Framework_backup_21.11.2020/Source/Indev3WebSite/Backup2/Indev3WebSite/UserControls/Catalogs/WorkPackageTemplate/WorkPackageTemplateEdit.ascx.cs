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
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_Catalogs_WorkPackageTemplate_WorkPackageTemplateEdit : GenericUserControl
{
    public UserControls_Catalogs_WorkPackageTemplate_WorkPackageTemplateEdit()
    {
        this.Entity = new WorkPackageTemplate();
    }

    public override void SetAdditionalProperties(IGenericEntity entity)
    {
        try
        {
            IWorkPackageTemplate WorkPackageTemplate = (IWorkPackageTemplate)entity;

            //read from session the needed values
            CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER);
            ApplicationSettings appSettings = (ApplicationSettings)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.APPLICATION_SETTINGS);

            base.SetViewEntityProperties(entity);
            WorkPackageTemplate.IdLastUserUpdate = currentUser.IdAssociate;
            WorkPackageTemplate.LastUserUpdate = currentUser.AssociateName;
            
            WorkPackageTemplate.SetSettings(appSettings);
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
            CurrentUser currentUser = SessionManager.GetCurrentUser(this.Page);
            bool canDisplayWarning = true;
            if (!IsPostBack)
            {
                if (currentUser.GetPermission(ApplicationConstants.MODULE_WORK_PACKAGE_TEMPLATE, Operations.Edit) == Permissions.Restricted)
                {
                    this.lblCode.Enabled = false;
                    this.lblDisplayNo.Enabled = false;
                    this.lblName.Enabled = false;
                    this.lblPhase.Enabled = false;
                    this.txtCode.Enabled = false;
                    this.txtRank.Enabled = false;
                    this.txtName.Enabled = false;
                    this.cmbPhase.Enabled = false;
                    if (chkIsActive.Checked == false)
                    {
                        chkIsActive.Enabled = false;
                        canDisplayWarning = false;
                    }
                }
                if (currentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR)
                {
                    chkIsActive.Enabled = true;
                    canDisplayWarning = true;
                }
            }

            //Confirmation message (before saving) will appear only in edit mode and if the current user has restricted edit permissions (he is
            //program manager for this project)
            if (this.WP.EditMode && currentUser.GetPermission(ApplicationConstants.MODULE_WORK_PACKAGE_TEMPLATE, Operations.Edit) == Permissions.Restricted && !Page.ClientScript.IsOnSubmitStatementRegistered(this.Page.GetType(), "Confirmation") && canDisplayWarning)
            {
                this.Page.ClientScript.RegisterOnSubmitStatement(this.Page.GetType(), "Confirmation", "if(Page_IsValid) {if (!confirm('Are you sure you want to save your modifications?')) return false;}");
            }
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
    
    protected override void CreateChildControls()
    {
        try
        {
            base.CreateChildControls();
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
