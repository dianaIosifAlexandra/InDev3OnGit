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
using System.Drawing;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_Budget_Interco_IntercoMassAttribution : IndPopUpBasePage
{
    protected void btnApply_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                decimal percent = decimal.Parse(txtPercent.Text);
                Session[SessionStrings.PERCENT] = percent;

                if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonClickScript"))
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonClickScript", "window.returnValue = 1; window.close();", true);
                }
            }
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
    }

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            base.OnPreRender(e);
            if (!ClientScript.IsOnSubmitStatementRegistered(this.Page.GetType(), "ResizePopUp"))
            {
                ClientScript.RegisterOnSubmitStatement(this.Page.GetType(), "ResizePopUp", "SetPopUpHeight();");
            }
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
    }
}
