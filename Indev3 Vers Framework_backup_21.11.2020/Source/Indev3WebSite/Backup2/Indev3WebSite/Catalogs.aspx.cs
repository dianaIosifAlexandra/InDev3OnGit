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
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework.GenericControls;

namespace Inergy.Indev3.UI
{
    public partial class Catalogs : IndBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    //*************************************************************************************
                    //Reset Filters and Page Number for catalogs grid if we are not coming from the add/edit window of the catalog
                    if (!string.IsNullOrEmpty(Page.Request.Headers["Referer"]))
                    {
                        SessionManager.RemoveValueFromSession(this.Page, SessionStrings.FILTER_EXPRESSION);
                        SessionManager.RemoveValueFromSession(this.Page, SessionStrings.FILTER_ITEM);
                        SessionManager.RemoveValueFromSession(this.Page, SessionStrings.PAGE_NUMBER_MAPPING);
                    }
                    //*************************************************************************************
                }
                
                Control c;
                if (HttpContext.Current.Request.QueryString.Keys.Count == 0)
                {
                    this.ShowError(new IndException(ApplicationMessages.EXCEPTION_COULD_NOT_GET_CATALOGUE_CODE_PARAMETER));
                    return;
                }
                //The code parameter is always the first parameter
                string codeParam = HttpContext.Current.Request.QueryString.Keys[0];
                string catalogueCode = HttpContext.Current.Request.QueryString[codeParam];

                string ascxPath = ApplicationConstants.GetASCXPath(catalogueCode);

                c = Page.LoadControl(ascxPath);
                c.ID = "parentGenericView";
                this.plhCatalogue.Controls.Add(c);
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

        protected override void RaisePostBackEvent(IPostBackEventHandler sourceControl, string eventArgument)
        {
            try
            {
                if (eventArgument == "Rebind")
                {
                    IndCatGrid sourceGrid = (IndCatGrid)sourceControl;
                    sourceGrid.SetPage();
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

            base.RaisePostBackEvent(sourceControl, eventArgument);
        }

        public override void CSVExport()
        {
            try
            {
                GenericViewControl genericViewControl = new GenericViewControl();
                for (int i = 0; i < this.plhCatalogue.FindControl("parentGenericView").Controls.Count; i++)
                {
                    if (this.plhCatalogue.FindControl("parentGenericView").Controls[i] is GenericViewControl)
                    {
                        genericViewControl = (GenericViewControl)this.plhCatalogue.FindControl("parentGenericView").Controls[i];
                        genericViewControl.ExportData();
                        break;
                    }
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
    }
}