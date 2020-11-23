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
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework;

namespace Inergy.Indev3.UI
{
    public partial class UnhandledError : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                IndException indExc = (IndException)this.Session[SessionStrings.ERROR_MESSAGE];
               
                txtErrorMessage.Text = indExc.Message;
                txtStackTrace.Text = indExc.StackTrace;                
               

                this.Session[SessionStrings.ERROR_MESSAGE] = null;
            }
        }
    }
}