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
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.UI
{
    public partial class ErrorForm : IndPopUpBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (SessionManager.GetSessionValueRedirect(this, SessionStrings.ERROR_MESSAGE) != null)
                {
                    string errorMessage = SessionManager.GetSessionValueRedirect(this, SessionStrings.ERROR_MESSAGE).ToString();
                    DisplayErrorMessage(errorMessage);
                    btnClose.Attributes.Add("onclick", "self.close();");
                }
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

        private void DisplayErrorMessage(string errorMsg)
        {
            this.txtError.Text = errorMsg;
            SessionManager.SetSessionValue(this, SessionStrings.ERROR_MESSAGE, null);
        }
    }
}