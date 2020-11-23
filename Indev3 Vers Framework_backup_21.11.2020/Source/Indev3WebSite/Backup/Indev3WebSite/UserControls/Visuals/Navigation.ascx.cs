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
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;
using System.Collections.Generic;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_Visuals_Navigation : IndBaseControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            SetCsvExportButtonState();
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
    
    protected void btnCsv_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ((IndBasePage)this.Page).CSVExport();
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

    protected void btnRefresh_Click(object sender, ImageClickEventArgs e)
    {
        ParentPage.ResponseRedirect(ParentPage.Request.Url.ToString());
    }

    public void SetBackButtonNavigateUrl(string url)
    {
        btnBack.OnClientClick = "window.location='" + url + "'; return false";
    }

    /// <summary>
    /// Gets the RadMenuItem in the menu that has the specified module code
    /// </summary>
    /// <param name="radMenu"></param>
    /// <param name="moduleCode"></param>
    /// <returns></returns>
    private RadMenuItem FindItemByModuleCode(RadMenu mnuMain, string moduleCode)
    {
        //Get all items in the menu
        ArrayList menuItems = mnuMain.GetAllItems();
        //For each IndMenuItem
        foreach (IndMenuItem menuItem in menuItems)
        {
            if (menuItem.ModuleCode == moduleCode)
                return menuItem;
        }
        return null;
    }

    /// <summary>
    /// Makes the csv export button enabled or disabled, depending on the current page
    /// </summary>
    private void SetCsvExportButtonState()
    {
		bool isException = false;
		if (Page.Request.Url.ToString().ToLower().Contains("exchangerates.aspx") ||
			Page.Request.Url.ToString().ToLower().Contains("revisedbudget.aspx") ||
			Page.Request.Url.ToString().ToLower().Contains("reforecastbudget.aspx"))
		{
			isException = true;
		}
		
		if (!Page.Request.Url.ToString().ToLower().Contains("catalogs.aspx") && !isException)
        {
            SetCsvButtonEnabled(false);
            return;
        }

        string catalogCode = String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["Code"]) ? string.Empty : HttpContext.Current.Request.QueryString["Code"];
        List<String> exportableCatalogCodes = (List<String>)Application[SessionStrings.EXPORTABLE_CATALOG_CODES];
        if (exportableCatalogCodes == null)
        {
            SetCsvButtonEnabled(false);
            return;
        }

        if (exportableCatalogCodes.Contains(catalogCode.ToUpper()) || isException)
        {
            SetCsvButtonEnabled(true);
        }
        else
        {
            SetCsvButtonEnabled(false);
        }
    }

    /// <summary>
    /// Sets the csv button enabled or disabled, depending on the given argument and sets the corresponding image url
    /// </summary>
    /// <param name="isEnbled"></param>
    private void SetCsvButtonEnabled(bool isEnabled)
    {
        if (!isEnabled)
        {
            btnCsv.ImageUrl = "~/Images/rightbuttons_csv_disabled.png";
            btnCsv.ImageUrlOver = "~/Images/rightbuttons_csv_disabled.png";
        }
        else
        {
            btnCsv.ImageUrl = "~/Images/rightbuttons_csv.png";
            btnCsv.ImageUrlOver = "~/Images/rightbuttons_csv_over.png";
        }
        btnCsv.Enabled = isEnabled;
    }
}
