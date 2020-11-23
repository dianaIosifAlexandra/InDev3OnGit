using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.UI;
using System.Web.Configuration;

public partial class ReportPlaceHolder : IndBasePage
{
    public string Code
    {
        get {
            if (Request.QueryString["code"] == null)
                return string.Empty;
            else
                return Request.QueryString["code"].ToString();
            }        
    }

    public string BreadCrumb
    {
        get
        {
            if (Request.QueryString["nav"] == null)
                return "Welcome";
            else
                return Request.QueryString["nav"].ToString();
        }    
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (string.IsNullOrEmpty(Code))
                return;

            Configuration configSql = WebConfigurationManager.OpenWebConfiguration("~");
            ReportingSettingsSection reportingSection = (ReportingSettingsSection)configSql.GetSection("ReportingSettings");

            string URL = reportingSection.VirtualDirectory + "/" + Code;
            iframeRep.Attributes["src"] = URL;            
        }
        catch (IndException ex)
        {
            ShowError(ex);
            return;
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
            return;
        }
    }

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        try
        {
        ((Label)this.Page.Master.FindControl("bc").Controls[0]).Text = BreadCrumb;
        }
        catch (IndException ex)
        {
            ShowError(ex);
            return;
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
            return;
        }
    }
}
