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

public partial class UserControls_Country_CountryEdit : GenericUserControl
{
    public UserControls_Country_CountryEdit()
    {
        this.Entity = new Country();
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
   
    protected override void RenderChildren(HtmlTextWriter writer)
    {
        try
        {
            if (cmbCurrency.Items.Count > 5)
            {
                cmbCurrency.Height = Unit.Pixel(90);
            }
            else
            {
                cmbCurrency.Height = Unit.Empty;
            }

            if (cmbRegion.Items.Count > 5)
            {
                cmbRegion.Height = Unit.Pixel(90);
            }
            else
            {
                cmbRegion.Height = Unit.Empty;
            }
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
