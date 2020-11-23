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

public partial class UserControls_Owner_OwnerEdit : GenericUserControl
{
    public UserControls_Owner_OwnerEdit()
    {
        this.Entity = new Owner();
    }


    protected override void RenderChildren(HtmlTextWriter writer)
    {
        try
        {
            if (cmbOwnerType.Items.Count >= 4)
                cmbOwnerType.Height = Unit.Pixel(90);
            else
                cmbOwnerType.Height = Unit.Empty;

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