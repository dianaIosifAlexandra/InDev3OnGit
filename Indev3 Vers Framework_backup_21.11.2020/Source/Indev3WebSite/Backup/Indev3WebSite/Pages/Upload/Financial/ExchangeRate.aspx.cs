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
	
	protected void cmbYear_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
		try
		{
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
		grdExchangeRates.Rebind();
	}

	public override void CSVExport()
	{
		try
		{
			ExportData();
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

	public void ExportData()
	{
		try
		{
			//StringBuilder that will hold the contents of the csv file to be exported
			StringBuilder fileContent = new StringBuilder();
			//List holding visible column names
			List<string> visibleColumnNames = new List<string>();
			//Populate visibleColumnNames with the visible columns in the grid (exclude the ones that are hidden)
			foreach (GridColumn column in grdExchangeRates.MasterTableView.Columns)
			{
				if (column is GridBoundColumn && column.Display)
				{
					visibleColumnNames.Add(column.UniqueName);
					//Add the header text to the StringBuilder object that holds the contents of the csv file
					fileContent.Append("\"" + column.UniqueName + "\";");
				}
			}
			//Remove the last semicolon in the header
			fileContent.Remove(fileContent.Length - 1, 1);
			//Get the datarows from the grid which obey the filter condition
			DataRow[] rows = (((DataSet)grdExchangeRates.DataSource).Tables[0]).Select();
			if (rows.Length > 0)
			{
				//Append the actual grid contents to the StringBuilder
				fileContent.Append(DSUtils.BuildCSVExport(rows, visibleColumnNames, true));
			}
			//Download the file
			DownloadUtils.DownloadFile(ApplicationConstants.DEFAULT_FILE_NAME, fileContent.ToString());
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
