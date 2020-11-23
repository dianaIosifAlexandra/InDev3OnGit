using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using System.Collections.Generic;

namespace Inergy.Indev3.UI
{
    public partial class PopUp : IndPopUpBasePage
    {
        PageStatePersister _pers;

        protected override PageStatePersister PageStatePersister
        {
            get
            {
                if (_pers == null)
                {
                    _pers = new SessionPageStatePersister(this);
                }
                return _pers;
            }
        }

        protected override void OnInit(EventArgs e)
        {
            try
            {
                base.OnInit(e);
                if (HttpContext.Current.Request.QueryString.Keys.Count != 2)
                {
                    this.ShowError(new IndException(ApplicationMessages.EXCEPTION_COULD_NOT_GET_CATALOGUE_CODE_PARAMETER));
                    return;
                }
                //The code parameter is always the first parameter
                string codeParam = HttpContext.Current.Request.QueryString.Keys[0];
                string catalogueCode = HttpContext.Current.Request.QueryString[codeParam];
                string idParameter = HttpContext.Current.Request.QueryString.Keys[1];
                string catalogueKey = HttpContext.Current.Request.QueryString[idParameter];

                SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_PARAMETERS, null);

                if (!String.IsNullOrEmpty(catalogueKey))
                    CreateEditParameters(catalogueKey);

                Control editControl = null;

                string editControlName = SessionManager.GetSessionValueRedirect(this, SessionStrings.EDIT_CONTROL).ToString();

                string ascxPath = ApplicationConstants.GetASCXPath(catalogueCode, ApplicationConstants.EDIT_ASCX_INDEX);

                editControl = Page.LoadControl(ascxPath);
                plhEditControl.Controls.Add(editControl);
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


        public void CreateEditParameters(string key)
        {
            try
            {
                Dictionary<string, object> editParameters = new Dictionary<string, object>();

                string[] keyParts = key.Split(new char[] { ',' });
                foreach (string pair in keyParts)
                {
                    string[] attr = pair.Split(new char[] { '=' });
                    editParameters.Add(attr[0], attr[1]);
                }

                SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_PARAMETERS, editParameters);
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
}