using System;
using System.Data;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Financial;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.WebFramework.WebControls;
using System.Text;
using System.Collections.Generic;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Collections;


public partial class Pages_Financial_ExchangeRate : IndBasePage
{
	#region Properties
	
	/// <summary>
	/// The connection manger used by this page
	/// </summary>
	private object ConnectionManager = null;
	
	/// <summary>
	/// The grid data source
	/// </summary>
	private DataSet SourceDS;
	
	#endregion Properties

	protected override void OnPreRender(EventArgs e)
	{
		try
		{
			base.OnPreRender(e);
			pnlExchangeRates.Attributes.Add("style", "Height: auto;");

			foreach (GridColumn column in grdExchangeRates.MasterTableView.Columns)
			{
				ApplyColumnCSSClass(column);
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
		
	protected void Page_Load(object sender, EventArgs e)
	{
		try
		{
			if (!IsPostBack)
			{
				LoadYearCombo();
			}
			//Loads the data for the screen
            Inergy.Indev3.BusinessLogic.Authorization.CurrentUser currentUser = SessionManager.GetCurrentUser(this);

            if (currentUser == null || currentUser.UserRole.Id != ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR)
            {
                grdExchangeRates.Columns[0].Visible = false;
            }
			LoadExchangeRates();
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
	
	protected void cmbYear_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
    {
		try
		{
			LoadExchangeRates();
            grdExchangeRates.Rebind();
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

	/// <summary>
	/// Applies the columns css class
	/// </summary>
	/// <param name="column">the column to which the css class is applied</param>
	private void ApplyColumnCSSClass(GridColumn column)
	{
		if (GetColumnIndex(column) % 2 == 1)
		{
			column.ItemStyle.CssClass = "IndEvenColumn";
		}
		else
		{
			column.ItemStyle.CssClass = "IndOddColumn";
		}
	}

	/// <summary>
	/// Gets the index of the current column (taking into account only the visible columns, not the hidden ones)
	/// </summary>
	/// <param name="currentColumn">the column whose index is calculated</param>
	/// <returns>the index of the current column (taking into account only the visible columns, not the hidden ones)</returns>
	private int GetColumnIndex(GridColumn currentColumn)
	{
		int index = grdExchangeRates.Columns.IndexOf(currentColumn);
		int visibleIndex = 0;
		foreach (GridColumn column in grdExchangeRates.Columns)
		{
			if (column is GridColumn && column.Display)
			{
				if (grdExchangeRates.Columns.IndexOf(column) < index)
				{
					visibleIndex++;
				}
			}
		}
		return visibleIndex;
	}
	
	private void LoadYearCombo()
	{
		//Set the combo data source
		cmbYear.DataSource = PeriodUtils.GetYears();
		cmbYear.DataBind();
		cmbYear.SelectedIndex = cmbYear.Items.Count - 1 - ApplicationConstants.YEAR_AHEAD_TO_INCLUDE; /*select curent year*/
	}
    
	/// <summary>
	/// Geths the datasource for the grid and binds it
	/// </summary>
	private void LoadExchangeRates()
	{
		//Get the connection manger
		ConnectionManager = SessionManager.GetConnectionManager(this);

		ExchangeRates exchangeRates = new ExchangeRates(ConnectionManager);
		//Use the year selected in the combo
		exchangeRates.Year = int.Parse(cmbYear.Items[cmbYear.SelectedIndex].Text);
		//Get the dataset
		SourceDS = exchangeRates.GetAll(true);
		
		grdExchangeRates.DataSource = SourceDS;
		grdExchangeRates.DataMember = SourceDS.Tables[0].TableName;
		//grdExchangeRates.Rebind();
	}

    protected void grdExchangeRates_UpdateCommand(object source, GridCommandEventArgs e)
    {
        GridEditableItem editedItem = e.Item as GridEditableItem;
        hdnIsDirty.Value = "1";

        try
        {
            DoUpdateAction(editedItem);
        }
        catch (IndException indExc)
        {
            e.Canceled = true;
            ShowError(indExc);
        }
        catch (Exception exc)
        {
            e.Canceled = true;
            ShowError(new IndException(exc));
        }
    }

    protected void grdExchangeRates_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdExchangeRates.DataSource = SourceDS;        
    }

    private void DoUpdateAction(GridEditableItem item)
    {
        ConversionUtils conversionUtils = new ConversionUtils();

        int idCurrency = 0;
        Hashtable newValues = new Hashtable();
        //Extract the values entered by the user
        item.ExtractValues(newValues);
        //If the new value is null, convert it to the empty string to avoid multiple null checks
        if (newValues["BudgetExchangeRate"] == null)
        {
            newValues["BudgetExchangeRate"] = String.Empty;
        }

        ArrayList errors = new ArrayList();
        decimal rate = 0;
        //Check if the update hour is of decimal type
        if (!String.IsNullOrEmpty(newValues["BudgetExchangeRate"].ToString()) && decimal.TryParse(newValues["BudgetExchangeRate"].ToString(), out rate) == false)
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_NOT_NUMERIC, "Budget Exchange Rate"));
        if (String.IsNullOrEmpty(newValues["BudgetExchangeRate"].ToString()))
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_CANNOT_BE_EMPTY, "Budget Exchange Rate"));
        if (rate < 0)
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_MUST_BE_POSITIVE, "Budget Exchange Rate"));
        string temp = item.GetDataKeyValue("IdCurrency").ToString();
        if (string.IsNullOrEmpty(temp) || !int.TryParse(temp, out idCurrency))
            errors.Add(ApplicationMessages.MessageWithParameters("IdCurrency is missing", "Budget Exchange Rate"));

        //If there are errors the update shouldn't be done
        if (errors.Count != 0)
        {
            throw new IndException(errors);
        }

        UpdateBudgetExchangeRate(idCurrency, rate);

    }

    private void UpdateBudgetExchangeRate(int idCurrency, decimal rate)
    {
        try
        {
            object connManager = SessionManager.GetConnectionManager(this);
            ExchangeRate exchangeRate = new ExchangeRate(ConnectionManager);
            //Use the year selected in the combo
            exchangeRate.Year = int.Parse(cmbYear.Items[cmbYear.SelectedIndex].Text);
            exchangeRate.Value = rate;
            exchangeRate.IdCurrency = idCurrency;
            exchangeRate.IdCategory = ApplicationConstants.ID_EXCHANGE_RATE_FOR_BUDGET;
            exchangeRate.SetModified();
            //save value
            exchangeRate.Save();
            LoadExchangeRates();
            grdExchangeRates.Rebind();
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
        }
    }

    protected void btnDoPostback_Click(object sender, EventArgs e)
    {
        ResponseRedirect(Request.Url.ToString());
    }

}
