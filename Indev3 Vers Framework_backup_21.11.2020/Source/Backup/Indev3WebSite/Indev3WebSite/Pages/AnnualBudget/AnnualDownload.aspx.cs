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
using Telerik.WebControls;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.AnnualBudget;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Collections.Generic;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;

public partial class Pages_AnnualBudget_AnnualDownload : IndBasePage
{
    #region Members
    CurrentUser currentUser = null;
    protected const int CountryDefaultValue = -1;
    protected const int CountryAllValue = -2;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //AddAjaxSettings();
            if (!Page.IsPostBack)
                LoadControls();
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
    protected void Page_Init(object sender, EventArgs e)
    {
        try
        {
            currentUser = SessionManager.GetCurrentUser(this);
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

    protected void cmbCountry_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {           
            LoadInergyLocationsCombo();
            cmbInergyLocation.SelectedIndex = 0;
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

    protected void cmbInergyLocation_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            DataSet ds = GetCountrySource();
            if (ds == null)
                return;
            cmbCountry.ClearSelection();
            if (cmbInergyLocation.SelectedValue != ApplicationConstants.INT_NULL_VALUE.ToString())
            {
                cmbCountry.SelectedValue = ds.Tables[0].Rows[0]["Id"].ToString();
            }
            else
            {
                LoadInergyLocationsCombo();
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


    protected void btnExtract_Click(object sender, EventArgs e)
    {
        int CountryID = int.Parse(cmbCountry.SelectedValue);
        //this is an workaround cause by the fact that country combo can have 2 initial values (-2 for All, -1 for Select country)
        // but in stored procedure we only send one value (-1) if user pass the client validator.
        if (CountryID == CountryAllValue)
            CountryID = CountryDefaultValue;

        AnnualDownload extract = new AnnualDownload(SessionManager.GetConnectionManager(this));
        extract.IdCountry = CountryID;
        extract.IdInergyLocation = int.Parse(cmbInergyLocation.SelectedValue);
        extract.Year = int.Parse(cmbYear.SelectedValue);

        String fileContent;
        try
        {
            DataSet ds = extract.ExtractFromDataSource();
            if (ds == null)
            {
                this.ShowError(new IndException(string.Format(ApplicationMessages.EXCEPTION_ANNUALBUDGET_DOWNLOAD_NODATA,
                    cmbCountry.SelectedItem, cmbInergyLocation.SelectedItem, cmbYear.SelectedItem)));
                return;
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                fileContent = ExtractMethod(ds);
                if (fileContent.Length > 0)
                {
                    string exportFileName = string.Empty;
                    if (int.Parse(cmbCountry.SelectedValue) == CountryAllValue)
                        exportFileName = "All" + cmbYear.SelectedValue + ".csv";
                    else
                        exportFileName = CountryCode(int.Parse(cmbCountry.SelectedValue)) + cmbYear.SelectedValue + ".csv";

                    //Download the file
                    DownloadUtils.DownloadFile(exportFileName, fileContent);

                }
            }
            else
                this.ShowError(new IndException(string.Format(ApplicationMessages.EXCEPTION_ANNUALBUDGET_DOWNLOAD_NODATA,
                    cmbCountry.SelectedItem.Text, cmbInergyLocation.SelectedItem.Text, cmbYear.SelectedItem.Text)));

        }
        catch (Exception ex)
        {
            this.ShowError(new IndException(ex.Message));
        }
    }
    
    #region Private Methods
    private void LoadControls()
    {
        LoadCountryCombo();
        LoadInergyLocationsCombo();
        LoadYearCombo();
    }

    private void LoadCountryCombo()
    {       
        cmbCountry.Items.Clear();
        if (currentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR || currentUser.UserRole.Id == ApplicationConstants.ROLE_TECHNICAL_ADMINISTATOR)
        {
            cmbCountry.Items.Add(new RadComboBoxItem("All", CountryAllValue.ToString()));
        }
        else
        {
            cmbCountry.Items.Add(new RadComboBoxItem("-Select country-", CountryDefaultValue.ToString()));
        }
        cmbCountry.DataSource = GetCountrySource();
        cmbCountry.DataTextField = "Name";
        cmbCountry.DataValueField = "Id";
        cmbCountry.DataBind();
    }

    private void LoadInergyLocationsCombo()
    {        
        cmbInergyLocation.Items.Clear();
        cmbInergyLocation.Items.Add(new RadComboBoxItem("All", ApplicationConstants.INT_NULL_VALUE.ToString()));
        InergyLocation inergyLocation = new InergyLocation(SessionManager.GetConnectionManager(this));       
        int cmbSelectedValue = string.IsNullOrEmpty(cmbCountry.SelectedValue) ? ApplicationConstants.INT_NULL_VALUE : int.Parse(cmbCountry.SelectedValue);
        //if current user is with financial team then he is restricted to his country
        if (cmbSelectedValue == ApplicationConstants.INT_NULL_VALUE && currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
        {
            cmbSelectedValue = currentUser.IdCountry;
        }
        if (cmbSelectedValue != CountryAllValue)
            inergyLocation.IdCountry = cmbSelectedValue;
        DataSet ds = inergyLocation.SelectInergyLocation_Country();
        cmbInergyLocation.DataSource = ds;
        cmbInergyLocation.DataTextField = "Name";
        cmbInergyLocation.DataValueField = "Id";
        cmbInergyLocation.DataBind();
        cmbCountry.SelectedValue = cmbSelectedValue.ToString();
    }

    private void LoadYearCombo()
    {
        cmbYear.Items.Add(new RadComboBoxItem("-Select year-", ApplicationConstants.INT_NULL_VALUE.ToString()));
        for (int i = YearMonth.FirstYear; i <= YearMonth.LastYear; i++)
            cmbYear.Items.Add(new RadComboBoxItem(i.ToString(), i.ToString()));
    }
    

    private String ExtractMethod(DataSet ds)
    {
        //StringBuilder that will hold the contents of the csv file to be exported
        StringBuilder fileContent = new StringBuilder();
        //List holding visible column names
        List<string> visibleColumnNames = new List<string>();
        foreach (DataColumn col in ds.Tables[0].Columns)
        {
            visibleColumnNames.Add(col.ColumnName);
            fileContent.Append("\"" + col.ColumnName + "\";");
        }
        if (fileContent.ToString().EndsWith(";"))
            fileContent.Remove(fileContent.Length - 1, 1);

        DataRow[] rows = ds.Tables[0].Select();
        fileContent.Append(DSUtils.BuildCSVExport(rows, visibleColumnNames,true));
        return fileContent.ToString();
    }

    private void AddAjaxSettings()
    {

        //get the ajax manager from the page
        RadAjaxManager ajaxManager = GetAjaxManager();
        Panel pnlErrors = (Panel)this.Page.Master.FindControl("pnlErrors");
        ajaxManager.EnableAJAX = false;

        ////add ajax settings
        ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, cmbInergyLocation);
        ajaxManager.AjaxSettings.AddAjaxSetting(cmbInergyLocation, cmbCountry);
        ajaxManager.AjaxSettings.AddAjaxSetting(btnExtract, pnlErrors);
    }

    private string CountryCode(int IdCountry)
    {
        string returnCode = string.Empty;
        if (IdCountry > 0)
        {
            Country country = new Country(SessionManager.GetConnectionManager(this.Page));
            country.Id = IdCountry;

            DataSet ds = country.GetAll(true);
            returnCode = ds.Tables[0].Rows[0]["Code"].ToString();

        }
        return returnCode;
    }
    private DataSet GetCountrySource()
    {
        Country country = new Country(SessionManager.GetConnectionManager(this));
        //if current user is with financial team then he is restricted to his country
        if (currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
        {
            country.Id = currentUser.IdCountry;
        }

        int IdInergyLocation = string.IsNullOrEmpty(cmbInergyLocation.SelectedValue) ? ApplicationConstants.INT_NULL_VALUE : int.Parse(cmbInergyLocation.SelectedValue);
        if (IdInergyLocation != ApplicationConstants.INT_NULL_VALUE)
            country.IdInergyLocation = IdInergyLocation;

        return country.GetCountry_InergyLocation();
    }
    #endregion Private Methods
}
