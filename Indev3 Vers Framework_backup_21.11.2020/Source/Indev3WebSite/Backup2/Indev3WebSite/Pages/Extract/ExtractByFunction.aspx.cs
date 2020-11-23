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
using System.Collections.Generic;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.BusinessLogic.Extract;
using Inergy.Indev3.BusinessLogic.Common;
using System.Text;

namespace Inergy.Indev3.UI
{
    public partial class Pages_Extract_ExtractByFunction : IndBasePage
    {
        #region Members
        CurrentUser currentUser = null;
        #endregion

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //Add the ajax settings for this window
                AddAjaxSettings();
                string issuer = (string.IsNullOrEmpty(Page.Request.Params.Get("__EVENTTARGET")) ? string.Empty : Page.Request.Params.Get("__EVENTTARGET"));

                if (!Page.IsPostBack || issuer.Contains("lnkChange"))
                {
                    PopulateComboBoxes();
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

        protected void cmbRegion_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                cmbInergyLocation.SelectedIndex = 0;
                if (cmbRegion.SelectedIndex == 0)
                {
                    LoadRegions();
                }
                LoadCountries();                
                LoadInergyLocations();
                cmbCountry.ClearSelection();
                cmbCountry.FindItemByValue(ApplicationConstants.INT_NULL_VALUE.ToString()).Selected = true;
                cmbInergyLocation.ClearSelection();
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
                string idCountrySelected = ApplicationConstants.INT_NULL_VALUE.ToString();
                string idRegionSelected = ApplicationConstants.INT_NULL_VALUE.ToString();
                DataRow row = null;
                cmbInergyLocation.SelectedIndex = 0;
                cmbRegion.SelectedIndex = 0;
                if (!cmbCountry.IsEmptyValueSelected())
                {
                    idCountrySelected = cmbCountry.SelectedValue;
                    row = cmbCountry.GetComboSelection();
                    idRegionSelected = row["IdRegion"].ToString();
                    cmbRegion.SelectedValue = idRegionSelected;
                }
                LoadInergyLocations();
                LoadCountries();
                LoadRegions();
                if (idRegionSelected != ApplicationConstants.INT_NULL_VALUE.ToString())
                    cmbRegion.SelectedValue = idRegionSelected;
                if (idCountrySelected != ApplicationConstants.INT_NULL_VALUE.ToString())
                    cmbCountry.SelectedValue = idCountrySelected;              
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
                string idILSelected = ApplicationConstants.INT_NULL_VALUE.ToString();
                if (!cmbInergyLocation.IsEmptyValueSelected())
                {
                    idILSelected = cmbInergyLocation.SelectedValue;
                    DataRow row = cmbInergyLocation.GetComboSelection();
                    string idCountrySelected = row["IdCountry"].ToString();
                    //load country combo only with 2 elements: Empty and the country related to selected inergy location
                    LoadCountriesFiltered(int.Parse(idCountrySelected), ApplicationConstants.INT_NULL_VALUE);
                    cmbCountry.SelectedValue = idCountrySelected;
                    row = cmbCountry.GetComboSelection();
                    string idRegionSelected = row["IdRegion"].ToString();
                    //load region combo only with 2 elements: Empty and the region related to selected country
                    LoadRegionsFiltered(int.Parse(idRegionSelected));
                    cmbRegion.SelectedValue = idRegionSelected;
                    //load region inergy location with inergy locations related to selected country
                    LoadInergyLocationsFiltered(int.Parse(idCountrySelected));
                    cmbInergyLocation.SelectedValue = idILSelected;
                }
                else
                {
                    //reload all combos with all data
                    cmbRegion.ClearSelection();
                    cmbCountry.ClearSelection();
                    cmbInergyLocation.ClearSelection();

                    LoadRegions();
                    LoadCountries();
                    LoadInergyLocations();
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

        protected void cmbFunction_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                if (cmbFunction.SelectedValue == ApplicationConstants.INT_NULL_VALUE.ToString())
                    LoadFunctions();
                
                LoadDepartments();
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

        protected void cmbDepartment_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                string idDepartmentSelected = ApplicationConstants.INT_NULL_VALUE.ToString();
                if (!cmbDepartment.IsEmptyValueSelected())
                {
                    DataRow row = cmbDepartment.GetComboSelection();
                    idDepartmentSelected = cmbDepartment.SelectedValue;
                    string idFunctionSelected = row["IdFunction"].ToString();
                    //load function combo only with 2 elements: Empty and the function related to selected department
                    LoadFunctionsFiltered(int.Parse(idFunctionSelected));
                    cmbFunction.SelectedValue = idFunctionSelected;
                    //load department combo with departments related to selected function
                    LoadDepartmentsFiltered(int.Parse(idFunctionSelected));
                    cmbDepartment.SelectedValue = idDepartmentSelected;
                }
                else
                {
                    //reload function and department combo with all data
                    cmbFunction.ClearSelection();
                    LoadDepartments();
                    LoadFunctions();
                }
                LoadFunctions();
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

        protected void btnDownload_Click(object sender, EventArgs e)
        {
            try
            {
                DownloadFile();
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

        #endregion

        #region Methods
        private void PopulateComboBoxes()
        {
            LoadYearCombo();
            LoadRegions();
            LoadCountries();
            LoadInergyLocations();
            LoadFunctions();
            LoadDepartments();
            LoadCategoryCombo();
        }

        private void LoadYearCombo()
        {
            //Set the combo data source
            cmbYear.DataSource = PeriodUtils.GetYears();
            cmbYear.DataBind();
            cmbYear.SelectedIndex = cmbYear.Items.Count - 1- ApplicationConstants.YEAR_AHEAD_TO_INCLUDE ; /*select curent year*/
        }

        private void LoadRegions()
        {
            int regionId;

            if (cmbRegion.IsEmptyValueSelected())
            {
                if (currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
                {
                    LoadCountries();
                    DataRow row = cmbCountry.GetComboSelection();
                    regionId = (int)row["IdRegion"];
                }
                else
                {
                    regionId = ApplicationConstants.INT_NULL_VALUE;
                }
            }
            else
            {
                regionId = Int32.Parse(cmbRegion.SelectedValue);
            }

            LoadRegionsFiltered(regionId);
        }

        private void LoadRegionsFiltered(int regionId)
        {
            ExtractByFunctionFilter extractByFunctionFilter = new ExtractByFunctionFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

            extractByFunctionFilter.IdRegion = regionId;

            DataSet regionDS = extractByFunctionFilter.SelectProcedure("SelectRegion");
            cmbRegion.DataSource = regionDS;
            cmbRegion.DataMember = regionDS.Tables[0].ToString();
            cmbRegion.DataValueField = "Id";
            cmbRegion.DataTextField = "Name";
            if (currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
            {
                cmbRegion.SelectedValue = regionId.ToString();
                cmbRegion.Enabled = false;
            }
            else
            {
                cmbRegion.SelectedIndex = -1;
            }
            cmbRegion.DataBind();
            
            
        }

        private void LoadCountries()
        {
            if (!cmbRegion.IsEmptyValueSelected())
            { 
                //load countries filtered by region
                LoadCountriesFiltered(ApplicationConstants.INT_NULL_VALUE, Int32.Parse(cmbRegion.SelectedValue));
            }
            else if (!cmbInergyLocation.IsEmptyValueSelected())
            {
                //load countries filtered by inergy location
                LoadCountriesFiltered((int)cmbInergyLocation.GetComboSelection()["IdCountry"], ApplicationConstants.INT_NULL_VALUE);
            }
            else
            {
                if (currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
                {
                    LoadCountriesFiltered(currentUser.IdCountry, ApplicationConstants.INT_NULL_VALUE);
                }
                else
                {
                    //load all countries
                    LoadCountriesFiltered(ApplicationConstants.INT_NULL_VALUE, ApplicationConstants.INT_NULL_VALUE);
                }
            }
        }

        private void LoadCountriesFiltered(int countryId, int regionId)
        {
            ExtractByFunctionFilter extractByFunctionFilter = new ExtractByFunctionFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

            DataSet countryDS;
            if (regionId != ApplicationConstants.INT_NULL_VALUE)
            {
                extractByFunctionFilter.IdRegion = regionId;
                countryDS = extractByFunctionFilter.SelectProcedure("SelectCountriesForRegion");
            }
            else
            {
                extractByFunctionFilter.IdCountry = countryId;
                countryDS = extractByFunctionFilter.SelectProcedure("SelectCountry");
            }
           
            cmbCountry.DataSource = countryDS;
            cmbCountry.DataMember = countryDS.Tables[0].ToString();
            cmbCountry.DataValueField = "Id";
            cmbCountry.DataTextField = "Name";
            if (currentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
            {
                cmbCountry.SelectedValue = currentUser.IdCountry.ToString();
                cmbCountry.Enabled = false;
            }
            else
            {
                cmbCountry.SelectedIndex = -1;
            }
            cmbCountry.DataBind();
        }

        private void LoadInergyLocations()
        {
            int countryId;

            //See if there is a country selected in order to pass it the stored procedure
            if (cmbCountry.IsEmptyValueSelected())
                countryId = ApplicationConstants.INT_NULL_VALUE;
            else
                countryId = Int32.Parse(cmbCountry.SelectedValue);

            LoadInergyLocationsFiltered(countryId);
        }

        private void LoadInergyLocationsFiltered(int countryId)
        {
            ExtractByFunctionFilter extractByFunctionFilter = new ExtractByFunctionFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

            extractByFunctionFilter.IdCountry = countryId;

            DataSet inergyLocationDS = extractByFunctionFilter.SelectProcedure("SelectInergyLocation");
            cmbInergyLocation.DataSource = inergyLocationDS;
            cmbInergyLocation.DataMember = inergyLocationDS.Tables[0].ToString();
            cmbInergyLocation.DataValueField = "Id";
            cmbInergyLocation.DataTextField = "Name";
            cmbInergyLocation.SelectedIndex = -1;
            cmbInergyLocation.DataBind();
        }

        private void LoadFunctions()
        {
            int functionId;

            if (cmbFunction.IsEmptyValueSelected())
                functionId = ApplicationConstants.INT_NULL_VALUE;
            else
                functionId = Int32.Parse(cmbFunction.SelectedValue);

            LoadFunctionsFiltered(functionId);
        }

        private void LoadFunctionsFiltered(int functionId)
        {
            cmbFunction.Items.Clear();
            ExtractByFunctionFilter extractByFunctionFilter = new ExtractByFunctionFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

            extractByFunctionFilter.IdFunction = functionId;

            DataSet functionDS = extractByFunctionFilter.SelectProcedure("SelectFunction");
            cmbFunction.DataSource = functionDS;
            cmbFunction.DataMember = functionDS.Tables[0].ToString();
            cmbFunction.DataValueField = "Id";
            cmbFunction.DataTextField = "Name";
            cmbFunction.DataBind();
        }

        private void LoadDepartments()
        {
            int functionId;

            if (cmbFunction.IsEmptyValueSelected())
                functionId = ApplicationConstants.INT_NULL_VALUE;
            else
                functionId = Int32.Parse(cmbFunction.SelectedValue);

            LoadDepartmentsFiltered(functionId);
        }

        private void LoadDepartmentsFiltered(int functionId)
        {
            ExtractByFunctionFilter extractByFunctionFilter = new ExtractByFunctionFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            extractByFunctionFilter.IdFunction = functionId;

            DataSet departmentDS = extractByFunctionFilter.SelectProcedure("SelectDepartmentsForFunction");

            cmbDepartment.DataSource = departmentDS;
            cmbDepartment.DataMember = departmentDS.Tables[0].ToString();
            cmbDepartment.DataValueField = "Id";
            cmbDepartment.DataTextField = "Name";
            cmbDepartment.DataBind();
            cmbDepartment.SelectedIndex = 0;
        }

        private void LoadCategoryCombo()
        {
            EExtractSourceFunction source = new EExtractSourceFunction();
            cmbSource.DataSource = EnumUtil.MakeEnumWithSpaces(source);
            cmbSource.DataTextField = "Key";
            cmbSource.DataValueField = "Value";
            cmbSource.DataBind();
            cmbSource.SelectedIndex = 0;
        }

        private void DownloadFile()
        {
            String fileContent;
            DataSet ds;

            ds = GetDataSet();
            if (ds == null)
            {
                this.ShowError(new IndException(ApplicationMessages.EXCEPTION_EXTRACT_NODATA));
                return;
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                fileContent = ExtractMethod(ds);
                if (fileContent.Length > 0)
                {
                    //Download the file
                    DownloadUtils.DownloadFile(GetExportFileName(), fileContent);

                }
            }
            else
                this.ShowError(new IndException(ApplicationMessages.EXCEPTION_EXTRACT_NODATA));

        }

        //concatenate the file name to export
        //rule: 
        /*Program code (max 10 chars)
        Project code (max 10 chars)
        Budget Type (max 10)
        Version number (in case the exported budget type is revised or refoprecast)
        Separator is "_". extension of file is CSV.*/
        private string GetExportFileName()
        {
            string fileName;
            fileName = cmbYear.SelectedItem.Text;
            if (cmbFunction.SelectedItem.Text != "")
            {
                fileName += "_" + cmbFunction.SelectedItem.Text;
            }
            else
            {
                fileName += "_ALL";
            }
            if (cmbDepartment.SelectedItem.Text != "")
            {
                fileName += "_" + cmbDepartment.SelectedItem.Text;
            }
            if (cmbInergyLocation.SelectedItem.Text != "")
            {
                fileName += "_" + cmbInergyLocation.SelectedItem.Text;
            }
            else if (cmbCountry.SelectedItem.Text != "")
            {
                fileName += "_" + cmbCountry.SelectedItem.Text;
            }
            else if (cmbRegion.SelectedItem.Text != "")
            {
                fileName += "_" + cmbRegion.SelectedItem.Text;
            }
            fileName += "_" + cmbSource.SelectedItem.Text + ".csv";
            return fileName;
        }


        private DataSet GetDataSet()
        {
            DataSet ds;
            ExtractByFunctionFilter extractByFunctionFilter = new ExtractByFunctionFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            extractByFunctionFilter.Year = int.Parse(cmbYear.SelectedItem.Text);
            extractByFunctionFilter.IdRegion = int.Parse(cmbRegion.SelectedValue);
            extractByFunctionFilter.IdCountry = int.Parse(cmbCountry.SelectedValue);
            extractByFunctionFilter.IdInergyLocation = int.Parse(cmbInergyLocation.SelectedValue);
            extractByFunctionFilter.IdFunction = int.Parse(cmbFunction.SelectedValue);
            extractByFunctionFilter.IdDepartment = int.Parse(cmbDepartment.SelectedValue);
            CurrentUser user = (CurrentUser )SessionManager.GetSessionValueRedirect(this, "CurrentUser");
            extractByFunctionFilter.IdCurrencyAssociate = user.IdCurrency ;

            extractByFunctionFilter.ActiveStatus = cmbActive.SelectedValue;
            extractByFunctionFilter.CostTypeCategory = cmbCostType.SelectedValue;
            ds = extractByFunctionFilter.GetData(int.Parse(cmbSource.SelectedItem.Value));

            if (ds != null)
            {
                ds.Tables[0].Columns["Exchange Rate"].ColumnName = "Exchange Rate (" + user.CodeCurrency + ")";
                ds.AcceptChanges();
            }

            return ds;
        }

        private string ExtractMethod(DataSet ds)
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
            fileContent.Append(DSUtils.BuildCSVExport(rows, visibleColumnNames, true));
            return fileContent.ToString();
        }

        /// <summary>
        /// Adds the ajax settings for this window
        /// </summary>
        private void AddAjaxSettings()
        {
            //get the ajax manager from the IndBasePage
            RadAjaxManager ajaxManager = GetAjaxManager();
            ajaxManager.ClientEvents.OnRequestStart = "RequestStartNoMaster";
            ajaxManager.ClientEvents.OnResponseEnd = "ResponseEndNoMaster";

            //get the errors pannel
            Panel phErrors = (Panel)Master.FindControl("pnlErrors");

            //add ajax settings
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbRegion, phErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbRegion, cmbRegion);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbRegion, cmbCountry);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbRegion, cmbInergyLocation);

            ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, phErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, cmbRegion);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, cmbCountry);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, cmbInergyLocation);

            ajaxManager.AjaxSettings.AddAjaxSetting(cmbInergyLocation, phErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbInergyLocation, cmbRegion);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbInergyLocation, cmbCountry);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbInergyLocation, cmbInergyLocation);

            ajaxManager.AjaxSettings.AddAjaxSetting(cmbDepartment, phErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbDepartment, cmbFunction);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbDepartment, cmbDepartment);
            
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbFunction, phErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbFunction, cmbFunction);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbFunction, cmbDepartment);

            //it can't be sent binary files via call backs
            //ajaxManager.AjaxSettings.AddAjaxSetting(btnDownload, phErrors); 
        }
        #endregion
    }
}
