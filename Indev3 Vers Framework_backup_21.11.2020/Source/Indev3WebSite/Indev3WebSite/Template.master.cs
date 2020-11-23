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

namespace Inergy.Indev3.UI
{
    public partial class Template : System.Web.UI.MasterPage
    {
        public string LogoImage
        {
            get
            {
                float ieVersion = Inergy.Indev3.WebFramework.Utils.HelperFunctions.GetInternetExplorerVersion();
                if (ieVersion > 0 && ieVersion <= 8.0)
                {
                    return "~/Images/logo_ie8.png";
                }
                else
                {
                    return "~/Images/logo.png";
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        public void SetBackButtonNavigateUrl(string url)
        {
            nav.SetBackButtonNavigateUrl(url);
        }
    }
}