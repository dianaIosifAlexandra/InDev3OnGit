using System;
using System.Collections.Generic;
using System.Text;
using System.Web;

namespace Inergy.Indev3.WebFramework.Utils
{
    public static class HelperFunctions
    {
        static public float GetInternetExplorerVersion()
        {
            //http://msdn.microsoft.com/en-us/library/ms537509%28v=vs.85%29.aspx
            // Returns the version of Internet Explorer or a -1
            // (indicating the use of another browser).
            float rv = -1;
            System.Web.HttpBrowserCapabilities browser = HttpContext.Current.Request.Browser;
            string agent = HttpContext.Current.Request.UserAgent;
            if (browser.Browser == "IE")
            {
                rv = (float)(browser.MajorVersion + browser.MinorVersion);
            }

            if (agent.Contains("rv:") || agent.Contains("Trident/7.0"))
            {
                rv = (float)11.0;
            }

            if (agent.Contains("Trident/4.0"))
            {
                rv = (float)8.0;
            }
            return rv;
        }
    }
}
