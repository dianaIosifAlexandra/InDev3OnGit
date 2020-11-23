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
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.BusinessLogic.Catalogues;

using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_Department_DepartmentEdit : GenericUserControl
{
    public UserControls_Department_DepartmentEdit()
    {
        this.Entity = new Department();
    }

    protected override void RenderChildren(HtmlTextWriter writer)
    {
        try
        {
            if (cmbFunction.Items.Count >= 3)
                cmbFunction.Height = Unit.Pixel(70);
            else
                cmbFunction.Height = Unit.Empty;
            base.RenderChildren(writer);
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