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
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using Telerik.WebControls;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


public partial class UserControls_Budget_CostCenterFilter_Filter : IndPopUpBasePage
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

    #region Event Handlers
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            CostCenterFilter costCenterFilter;

            //restore the costCenterFilter
            costCenterFilter = (CostCenterFilter)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_COSTCENTER);

            if (!Page.IsPostBack)
            {
                if (costCenterFilter != null)
                {
                    LoadCountriesFiltered(costCenterFilter.IdCountry);
                    cmbCountry.SelectedValue = costCenterFilter.IdCountry.ToString();

                    LoadInergyLocationsFiltered(costCenterFilter.IdCountry);
                    cmbInergyLocation.SelectedValue = costCenterFilter.IdInergyLocation.ToString();

                    LoadCostCentersFiltered(costCenterFilter.IdCountry, costCenterFilter.IdInergyLocation, costCenterFilter.IdFunction);
                    //we do NOT select the cost center on purpose

                    LoadFunctions();
                    cmbFunction.SelectedValue = costCenterFilter.IdFunction.ToString();
                }
                else
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

    protected void cmbCountry_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            //we read the initial owner selected
            String currentCountry = cmbCountry.SelectedValue;

            // reload the Countries
            LoadCountries();

            //if one owner is selected then the selection is restored
            if (currentCountry != ApplicationConstants.INT_NULL_VALUE.ToString() &&
                currentCountry != String.Empty)
            {
                cmbCountry.SelectedValue = currentCountry;
            }

            // reload the Inergy Locations
            LoadInergyLocations();

            // reload the cost centers
            LoadCostCenters();
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
            DataRow row = null;

            if (!cmbInergyLocation.IsEmptyValueSelected())
            {
                //below phrase should work because of the check above
                row = cmbInergyLocation.GetComboSelection();
                cmbCountry.SelectedValue = row["IdCountry"].ToString();

                //re-load the countries
                LoadCountries();
            }


            //re-load the inergy location
            LoadInergyLocations();
            if (row != null) //restore the selection
                cmbInergyLocation.SelectedValue = row["Id"].ToString();

            // reload the cost centers
            LoadCostCenters();
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
            // reload the cost centers
            LoadCostCenters();
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

    protected void cmbCostCenter_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            DataRow row = null;

            if (!cmbCostCenter.IsEmptyValueSelected())
            {
                //below phrase should work because of the check above
                row = cmbCostCenter.GetComboSelection();

                cmbCountry.SelectedValue = row["IdCountry"].ToString();
                cmbInergyLocation.SelectedValue = row["IdInergyLocation"].ToString();

                LoadCountries();
                cmbCountry.SelectedValue = row["IdCountry"].ToString();

                LoadInergyLocations();
                cmbInergyLocation.SelectedValue = row["IdInergyLocation"].ToString();

                cmbFunction.SelectedValue = row["IdFunction"].ToString();
            }


            LoadCostCenters();
            if (row != null) // restore the value
                cmbCostCenter.SelectedValue = row["Id"].ToString();
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

    protected void btnOk_Click(object sender, EventArgs e)
    {
        try
        {
            //gather information about the selected item
            CostCenterFilter costCenterFilter = GetCostCenterInfo();

            //Close the window
            //HACK : to be put in a method
            if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonClickScript"))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonClickScript", "window.returnValue = 1; window.close();", true);
            }

            SessionManager.SetSessionValue(this, SessionStrings.CURRENT_COSTCENTER, costCenterFilter);
            SessionManager.SetSessionValue(this, SessionStrings.ADD_CC_TO_TARGET, lstAddCCtoWPs.SelectedValue);

            //Since the pop-up will close anyway, we do not need to transport to the client all the page viewstate since it will not be used anyway
            //In addition, the items of the comboboxes do not need to be rendered on the client.
            this.EnableViewState = false;

            cmbCostCenter.Items.Clear();
            cmbCountry.Items.Clear();
            cmbFunction.Items.Clear();
            cmbInergyLocation.Items.Clear();
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
        try
        {
            base.OnPreRender(e);
            if (!ClientScript.IsOnSubmitStatementRegistered(this.Page.GetType(), "ResizePopUp"))
            {
                ClientScript.RegisterOnSubmitStatement(this.Page.GetType(), "ResizePopUp", "SetPopUpHeight(); if(Page_IsValid) this.disabled=true;");
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

    protected override void RenderChildren(HtmlTextWriter writer)
    {
        try
        {
            if (Convert.ToInt32(cmbCountry.Height.Value) > 90)
                cmbCountry.Height = Unit.Pixel(90);

            if (Convert.ToInt32(cmbInergyLocation.Height.Value) > 90)
                cmbInergyLocation.Height = Unit.Pixel(90);

            if (Convert.ToInt32(cmbFunction.Height.Value) > 90)
                cmbFunction.Height = Unit.Pixel(90);

            if (Convert.ToInt32(cmbCostCenter.Height.Value) > 90)
                cmbCostCenter.Height = Unit.Pixel(90);


            base.RenderChildren(writer);
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
    #endregion Event Handlers

    #region Private Methods
    private void PopulateComboBoxes()
    {
        LoadCountries();
        LoadInergyLocations();
        LoadFunctions();
        LoadCostCenters();

    }

    private CostCenterFilter GetCostCenterInfo()
    {
        //Get the selection for the cmbCostCenter combo/error is thrown if there is none
        DataRow row = cmbCostCenter.GetComboSelection();

        CostCenterFilter costCenterFilter = new CostCenterFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

        costCenterFilter.IdCountry = (int)row["IdCountry"];
        costCenterFilter.IdInergyLocation = (int)row["IdInergyLocation"];
        costCenterFilter.IdFunction = (int)row["IdFunction"];
        costCenterFilter.IdCostCenter = (int)row["Id"];
        costCenterFilter.NameCostCenter = row["Name"].ToString();

        return costCenterFilter;
    }
    private void LoadCountries()
    {
        int countryId;       

        if (cmbCountry.IsEmptyValueSelected())
            countryId = ApplicationConstants.INT_NULL_VALUE;
        else
            countryId = Int32.Parse(cmbCountry.SelectedValue);

        LoadCountriesFiltered(countryId);
    }

    private void LoadCountriesFiltered(int countryId)
    {
        CostCenterFilter costCenterFilter = new CostCenterFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

        costCenterFilter.IdCountry = countryId;

        DataSet countryDS = costCenterFilter.SelectProcedure("SelectCountry");
        cmbCountry.DataSource = countryDS;
        cmbCountry.DataMember = countryDS.Tables[0].ToString();
        cmbCountry.DataValueField = "Id";
        cmbCountry.DataTextField = "Name";
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
        CostCenterFilter costCenterFilter = new CostCenterFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

        costCenterFilter.IdCountry = countryId;

        DataSet inergyLocationDS = costCenterFilter.SelectProcedure("SelectInergyLocation");
        cmbInergyLocation.DataSource = inergyLocationDS;
        cmbInergyLocation.DataMember = inergyLocationDS.Tables[0].ToString();
        cmbInergyLocation.DataValueField = "Id";
        cmbInergyLocation.DataTextField = "Name";
        cmbInergyLocation.DataBind();
    }

    private void LoadFunctions()
    {
        CostCenterFilter costCenterFilter = new CostCenterFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

        DataSet functionDS = costCenterFilter.SelectProcedure("SelectFunction");
        cmbFunction.DataSource = functionDS;
        cmbFunction.DataMember = functionDS.Tables[0].ToString();
        cmbFunction.DataValueField = "Id";
        cmbFunction.DataTextField = "Name";
        cmbFunction.DataBind();
    }

    private void LoadCostCenters()
    {
        int countryId;
        int inergyLocationId;
        int functionId;
        
        //See if there is a country selected in order to pass it the stored procedure
        if (cmbCountry.IsEmptyValueSelected())
            countryId = ApplicationConstants.INT_NULL_VALUE;
        else
            countryId = Int32.Parse(cmbCountry.SelectedValue);

        //See if there is a InergyLocation selected in order to pass it the stored procedure
        if (cmbInergyLocation.IsEmptyValueSelected())
            inergyLocationId = ApplicationConstants.INT_NULL_VALUE;
        else
            inergyLocationId = Int32.Parse(cmbInergyLocation.SelectedValue);

        //See if there is a InergyLocation selected in order to pass it the stored procedure
        if (cmbFunction.IsEmptyValueSelected())
            functionId = ApplicationConstants.INT_NULL_VALUE;
        else
            functionId = Int32.Parse(cmbFunction.SelectedValue);

        LoadCostCentersFiltered(countryId, inergyLocationId, functionId); 
    }

    private void LoadCostCentersFiltered(int countryId, int inergyLocationId, int functionId)
    {
        CostCenterFilter costCenterFilter = new CostCenterFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

        costCenterFilter.IdCountry = countryId;
        costCenterFilter.IdInergyLocation = inergyLocationId;
        costCenterFilter.IdFunction = functionId;

        DataSet costCenterDS = costCenterFilter.SelectProcedure("SelectCostCenter");
        cmbCostCenter.DataSource = costCenterDS;
        cmbCostCenter.DataMember = costCenterDS.Tables[0].ToString();
        cmbCostCenter.DataValueField = "Id";
        cmbCostCenter.DataTextField = "Code";
        cmbCostCenter.DataBind();   
    }

    #endregion Private Methods
}
