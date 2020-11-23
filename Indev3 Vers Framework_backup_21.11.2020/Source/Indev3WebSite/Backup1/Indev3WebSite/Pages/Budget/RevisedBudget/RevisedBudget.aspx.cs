using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.UI;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.WebControls;
using Telerik.WebControls;

public partial class Pages_Budget_RevisedBudget_RevisedBudget : IndBasePage
{
    #region Constants
    /// <summary>
    /// The width of the cost center column in the hours and sales grid when the cost center currency column is visible (local currency)
    /// </summary>
    private const int COST_CENTER_WIDTH_CURRENCY_HOURS = 242;
    /// <summary>
    /// The width of the cost center column in the hours and sales grid when the cost center currency column is not visible (user currency)
    /// </summary>
    private const int COST_CENTER_WIDTH_NO_CURRENCY_HOURS = 264;
    /// <summary>
    /// The width of the cost center column in the summary (validation) grid when the cost center currency column is visible (local currency)
    /// </summary>
    private const int COST_CENTER_WIDTH_CURRENCY_SUMMARY = 304;
    /// <summary>
    /// The width of the cost center column in the summary (validation) grid when the cost center currency column is not visible (user currency)
    /// </summary>
    private const int COST_CENTER_WIDTH_NO_CURRENCY_SUMMARY = 326;
    #endregion Constants

    #region Members
    /// <summary>
    /// Session key for hours dataset
    /// </summary>
    private const string HOURS_DATASET = "HoursDS";
    /// <summary>
    /// Session key for costs & sales dataset 
    /// </summary>
    private const string COSTS_DATASET = "CostsDS";
    /// <summary>
    /// Session key for validation dataset 
    /// </summary>
    private const string VALIDATION_DATASET = "ValidationDataSet";
    /// <summary>
    /// List of cost centers which are currently in edit mode
    /// </summary>
    private const string REVISED_EDITING_COST_CENTERS_LIST = "RevisedEditingCostCentersList";
    /// <summary>
    /// Holds the dataset of the hours grid
    /// </summary>
    private DataSet DsHours = null;
    /// <summary>
    /// Holds the dataset of the costs & sales grid
    /// </summary>
    private DataSet DsCosts = null;
    /// <summary>
    /// Holds the dataset of the validation grid
    /// </summary>
    private DataSet DsValidation = null;
    /// <summary>
    /// Holds the associate id from Query String when page is from follow up
    /// </summary>
    private int followUpIdAssociate = ApplicationConstants.BUDGET_DIRECT_ACCESS;

    private ConversionUtils conversionUtils = new ConversionUtils();

    public int FollowUpIdAssociate
    {
        get { return ((string.IsNullOrEmpty(this.Request.QueryString["IdAssociate"])) ? ApplicationConstants.BUDGET_DIRECT_ACCESS : Int32.Parse(this.Request.QueryString["IdAssociate"])); }
        set { followUpIdAssociate = value; }
    }

    //property to hold the version of budget from QueryString when page comes from follow up    
    private string _budgetVersion = "N";
    public string BudgetVersion
    {
        get { return (string.IsNullOrEmpty(this.Request.QueryString["BudgetVersion"])? _budgetVersion:this.Request.QueryString["BudgetVersion"].ToString());}
        set { _budgetVersion = value; }
    }
    //hold the codification for Evidence button 1=Revised
    private int _budgetType = 1;

    /// <summary>
    /// Specified whether associate currency is selected for this user (in the user settings) or not
    /// </summary>
    private bool IsAssociateCurrency = true;
    /// <summary>
    /// Marks if the grid is readonly
    /// </summary>
    private bool isGridReadOnly = false;

    private RevisedBudgetTotals totals;

    #endregion Members

    #region Event Handlers
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            LoadComboStateFromQueryString();
            

            CurrentUser currentUser = SessionManager.GetCurrentUser(this);
            CurrentProject currentProject = SessionManager.GetCurrentProject(this);

            if (currentUser.Settings.CurrencyRepresentation != CurrencyRepresentationMode.Associate)
                IsAssociateCurrency = false;

            //Show the correct warning message, depending on whether user currency or local currency is selected
            if (IsAssociateCurrency)
                lblWarning.Text = ApplicationConstants.BUDGET_USER_CURRENCY_WARNING_MESSAGE;
            else
            {
                lblWarning.Text = ApplicationConstants.BUDGET_LOCAL_CURRENCY_WARNING_MESSAGE;
            }

            if (!Page.IsPostBack)
            {
                if (SessionManager.GetSessionValueNoRedirect(this, "RevisedSelectedTab") == null)
                    tabStripRevisedBudget.SelectedIndex = 0;
                tabStripRevisedBudget.SelectedIndex = (int)SessionManager.GetSessionValueNoRedirect(this, "RevisedSelectedTab");
                MultiPageContainer.SelectedIndex = (int)SessionManager.GetSessionValueNoRedirect(this, "RevisedSelectedTab");

				PopulateCountriesCombobox();
            }

            ShowGrid(tabStripRevisedBudget.SelectedIndex);
            if (tabStripRevisedBudget.SelectedIndex == 2)
                btnSave.Visible = false;
            else
                btnSave.Visible = true;
            
            //AddAjaxSettings();

            if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
            {
                btnPreselection.OnClientClick = "try{window.location = '" + ResolveUrl("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REVISED) + "';} catch(e) {} return false;";
                ((Template)this.Master).SetBackButtonNavigateUrl(ResolveUrl("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REVISED));
                btnPreselection.ToolTip = "Preselection Screen";
            }
            else
            {
                btnPreselection.OnClientClick = "try{window.location = '" + ResolveUrl("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_REVISED + "&IdAssociate=" + FollowUpIdAssociate.ToString() + "&BudgetType=1&BudgetVersion=" + BudgetVersion) + "';} catch(e) {} return false;";
                ((Template)this.Master).SetBackButtonNavigateUrl(ResolveUrl("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_REVISED + "&IdAssociate=" + FollowUpIdAssociate.ToString() + "&BudgetType=1&BudgetVersion=" + BudgetVersion));
                btnPreselection.ToolTip = "Follow-up Screen";
                btnSave.Visible = false;
            }

            if (IsPostBack)
                HandlePagePostback();

            //If the hours data source doesn't exist, load it from the database
            if (DsHours == null)
            {
                LoadHoursData();
                //Set the hours data source value in session
                SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
            }
            //If the costs data source doesn't exist, load it from the database
            if (DsCosts == null)
            {
                LoadCostsSalesData();
                //Set the costs data source value in session
                SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
            }
            // If the validation data source doesn't exist, build it
            if (DsValidation == null)
            {
                BuildValidationData();
                //Set the validation data source value in session
                SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);
            }


            if (!IsPostBack && cmbAmountScale.Text != AmountScaleOption.Unit.ToString())
            {
                //When the page loads for the first time, remove the edited cost centers from the last visit to the page
                SessionManager.RemoveValueFromSession(this, SessionStrings.EDITED_COST_CENTERS);
                SessionManager.RemoveValueFromSession(this, SessionStrings.REVISED_OTHER_COSTS_LIST);
                RadComboBoxSelectedIndexChangedEventArgs loadEventArgs = new RadComboBoxSelectedIndexChangedEventArgs();
                loadEventArgs.OldText = AmountScaleOption.Unit.ToString();
                loadEventArgs.Text = cmbAmountScale.Text;
                cmbAmountScale_SelectedIndexChanged(cmbAmountScale, loadEventArgs);
                //The first time the page loads, set the unsafe in edit mode controls enabled and the save button disabled
            }

            SetContextMenu(tabStripRevisedBudget.SelectedIndex);
            SetCurencyColumnVisible(tabStripRevisedBudget.SelectedIndex);
            if (!IsPostBack)
            {
                SetUnsafeInEditModeControlsEnabledState(true);
            }
        }
        catch (IndException exc)
        {
            HideChildControls();
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            HideChildControls();
            ShowError(new IndException(exc));
            return;
        }
    }

    private void LoadComboStateFromQueryString()
    {
        if (String.IsNullOrEmpty(Request.QueryString["AmountScale"]))
            throw new IndException("Could not get amount scale from querystring");

        cmbAmountScale.SelectedValue = Request.QueryString["AmountScale"];
        cmbAmountScale.Text = Request.QueryString["AmountScale"];
    }

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            
            DisplayTotals(tabStripRevisedBudget.SelectedIndex);

            //FOLLOWUP           
            //set visibility for buttons and grid readonly
            SetButtonsVisibility();

            base.OnPreRender(e);


            // for differentiation submit budgets
            Color colorSubmitted = IndConstants.ColorSubmitted;
			Color colorSubmittedForPhase = IndConstants.ColorSubmittedForPhase;
            
            bool isSubmitted = false;

            if (FollowUpIdAssociate == ApplicationConstants.INT_NULL_VALUE)
                isSubmitted = true;
            else
            {
                string budgetState = GetCurrentBudgetState();

                if (budgetState == ApplicationConstants.BUDGET_STATE_WAITING_APPROVAL ||
                    budgetState == ApplicationConstants.BUDGET_STATE_APPROVED ||
                    budgetState == ApplicationConstants.BUDGET_STATE_VALIDATED)
                {
                    isSubmitted = true;
                }
            }

            foreach (GridItem item in grdHours.Items)
            {
				bool isPhaseItem = (item.ItemIndexHierarchical.IndexOf(":") == -1);
                if (item is GridEditableItem && isGridReadOnly)
                {
                    foreach (TableCell cell in item.Cells)
                    {
                        cell.Enabled = false;
                        if (isSubmitted)
                        {
							cell.BackColor = isPhaseItem ? colorSubmittedForPhase : colorSubmitted;
                        }
                    }
                    ((GridDataItem)item)["ExpandColumn"].Enabled = true;
                }
                if (item.OwnerTableView.Name == grdHours.MasterTableView.DetailTables[0].DetailTables[0].Name)
                {
                    ((IndImageButton)((GridDataItem)item)["DeleteColumn"].Controls[1]).Enabled = !item.IsInEditMode;
                    (((GridDataItem)item)["CurrencyCode"]).Enabled = true;
                }

                if (isSubmitted)
                {
                    grdHours.MasterTableView.BackColor = colorSubmitted;
                }
            }
            foreach (GridItem item in grdCostsSales.Items)
            {
				bool isPhaseItem = (item.ItemIndexHierarchical.IndexOf(":") == -1);
                if (item is GridEditableItem && isGridReadOnly)
                {
                    foreach (TableCell cell in item.Cells)
                    {
                        cell.Enabled = false;
                        if (isSubmitted)
                        {
							cell.BackColor = isPhaseItem ? colorSubmittedForPhase : colorSubmitted;
                        }
                    }
                    ((GridDataItem)item)["ExpandColumn"].Enabled = true;
                }
                if (item.OwnerTableView.Name == grdCostsSales.MasterTableView.DetailTables[0].DetailTables[0].Name)
                {
                    ((IndImageButton)((GridDataItem)item)["DeleteColumn"].Controls[1]).Enabled = !item.IsInEditMode;
                }
                if (isSubmitted)
                {
                    grdCostsSales.MasterTableView.BackColor = colorSubmitted;
                }
            }
            foreach (GridItem item in grdValidation.Items)
            {
				bool isPhaseItem = (item.ItemIndexHierarchical.IndexOf(":") == -1);
                if (item is GridEditableItem && isGridReadOnly)
                {
                    foreach (TableCell cell in item.Cells)
                    {
                        cell.Enabled = false;
                        if (isSubmitted)
                        {
							cell.BackColor = isPhaseItem ? colorSubmittedForPhase : colorSubmitted;
                        }
                    }
                    ((GridDataItem)item)["ExpandColumn"].Enabled = true;
                }
                if (isSubmitted)
                {
                    grdValidation.MasterTableView.BackColor = colorSubmitted;
                }
            }

            AddAjaxSettings();
        }
        catch (IndException indExc)
        {
            ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
       
    }

    protected void grdHours_NeedDataSource(object source, Telerik.WebControls.GridNeedDataSourceEventArgs e)
    {
        try
        {
            if (DsHours != null)
            {
                grdHours.MasterTableView.DataSource = DsHours.Tables[0];
                grdHours.MasterTableView.DetailTables[0].DataSource = DsHours.Tables[1];
                grdHours.MasterTableView.DetailTables[0].DetailTables[0].DataSource = DsHours.Tables[2];

                //Set the format strings for each table
                SetColumnsFormatString(grdHours.MasterTableView);
                SetColumnsFormatString(grdHours.MasterTableView.DetailTables[0]);
                SetColumnsFormatString(grdHours.MasterTableView.DetailTables[0].DetailTables[0]);
            }
        }
        catch (IndException indExc)
        {
            HideChildControls();
            ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            HideChildControls();
            ShowError(new IndException(exc));
            return;
        }
    }

    protected void grdCostsSales_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        try
        {
            if (DsCosts != null)
            {
                grdCostsSales.MasterTableView.DataSource = DsCosts.Tables[0];
                grdCostsSales.MasterTableView.DetailTables[0].DataSource = DsCosts.Tables[1];
                grdCostsSales.MasterTableView.DetailTables[0].DetailTables[0].DataSource = DsCosts.Tables[2];

                //Set the format strings for each table
                SetColumnsFormatString(grdCostsSales.MasterTableView);
                SetColumnsFormatString(grdCostsSales.MasterTableView.DetailTables[0]);
                SetColumnsFormatString(grdCostsSales.MasterTableView.DetailTables[0].DetailTables[0]);
            }
        }
        catch (IndException indExc)
        {
            HideChildControls();
            ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            HideChildControls();
            ShowError(new IndException(exc));
            return;
        }
    }

    protected void grdValidation_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        try
        {
            if (DsValidation != null)
            {
                grdValidation.MasterTableView.DataSource = DsValidation.Tables[0];
                grdValidation.MasterTableView.DetailTables[0].DataSource = DsValidation.Tables[1];
                grdValidation.MasterTableView.DetailTables[0].DetailTables[0].DataSource = DsValidation.Tables[2];

                //Set the format strings for each table
                SetColumnsFormatString(grdValidation.MasterTableView);
                SetColumnsFormatString(grdValidation.MasterTableView.DetailTables[0]);
                SetColumnsFormatString(grdValidation.MasterTableView.DetailTables[0].DetailTables[0]);
            }
        }
        catch (IndException indExc)
        {
            HideChildControls();
            ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            HideChildControls();
            ShowError(new IndException(exc));
            return;
        }
    }

    protected void cmbAmountScale_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            AmountScaleOption oldAmountScale = BudgetUtils.GetAmountScaleOptionFromText(e.OldText);
            AmountScaleOption newAmountScale = BudgetUtils.GetAmountScaleOptionFromText(e.Text);
            if (newAmountScale < oldAmountScale)
            {
                LoadHoursData();
                LoadCostsSalesData();
                BuildValidationData();
                oldAmountScale = AmountScaleOption.Unit;
            }
            AmountScaleConvert(oldAmountScale, newAmountScale);
            grdHours.Rebind();
            grdCostsSales.Rebind();
            grdValidation.Rebind();
            //Set the hours data source value in session
            SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
            //Set the costs data source value in session
            SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
            //Set the validation data source value in session
            SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);


            if (totals == null)
                totals = new RevisedBudgetTotals();

            totals.BuildHoursTotal(DsHours.Tables[0]);
            totals.BuildCostsTotal(DsCosts.Tables[0]);
            totals.BuildSummaryTotal(DsValidation.Tables[0]);
        }
        catch (IndException indExc)
        {
            HideChildControls();
            ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            HideChildControls();
            ShowError(new IndException(exc));
            return;
        }
    }

	/// <summary>
	/// Event handler for the SelectedIndexChanged event of cmbCountry
	/// </summary>
	/// <param name="sender"></param>
	/// <param name="e"></param>
	protected void cmbCountry_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
	{
		try
		{
			LoadHoursData();
			LoadCostsSalesData();
			BuildValidationData();

			AmountScaleOption amountScale = BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);
			if (amountScale != AmountScaleOption.Unit)
			{
				AmountScaleConvert(AmountScaleOption.Unit, amountScale);
			}

			grdHours.Rebind();
			grdCostsSales.Rebind();
			grdValidation.Rebind();
			//Set the hours data source value in session
			SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
			//Set the costs data source value in session
			SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
			//Set the validation data source value in session
			SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);

			if (totals == null)
				totals = new RevisedBudgetTotals();

			totals.BuildHoursTotal(DsHours.Tables[0]);
			totals.BuildCostsTotal(DsCosts.Tables[0]);
			totals.BuildSummaryTotal(DsValidation.Tables[0]);

			SetUnsafeInEditModeControlsEnabledState(true);
		}
		catch (IndException exc)
		{
			HideChildControls();
			ShowError(exc);
			return;
		}
		catch (Exception exc)
		{
			HideChildControls();
			ShowError(new IndException(exc));
			return;
		}
	}
	
    protected void tabStripRevisedBudget_TabClick(object sender, TabStripEventArgs e)
    {
        try
        {
            SessionManager.SetSessionValue(this, "RevisedSelectedTab", e.Tab.Index);

            bool grdHoursNeedsRebind = false;
            bool grdCostsNeedsRebind = false;

            SessionManager.RemoveValueFromSession(this, SessionStrings.EDITED_COST_CENTERS);
            SetContextMenu(e.Tab.Index);
            ShowGrid(e.Tab.Index);
            //When changing the tab, all items that are in edit mode are now made non-editable and the submit button is made enabled
            foreach (GridItem item in grdHours.EditItems)
            {
                if (item.IsInEditMode)
                {
                    item.Edit = false;
                    grdHoursNeedsRebind = true;
                }
            }
            foreach (GridItem item in grdCostsSales.EditItems)
            {
                if (item.IsInEditMode)
                {
                    item.Edit = false;
                    grdCostsNeedsRebind = true;
                }
            }
            SetUnsafeInEditModeControlsEnabledState(true);

            //If the hours or costs grid needs to be rebound (because the edit state of some items was changed), rebind the grid
            if (grdHoursNeedsRebind)
            {
                grdHours.Rebind();
            }
            if (grdCostsNeedsRebind)
            {
                grdCostsSales.Rebind();
            }


            if (totals == null)
                totals = new RevisedBudgetTotals();

            totals.BuildHoursTotal(DsHours.Tables[0]);
            totals.BuildCostsTotal(DsCosts.Tables[0]);
            totals.BuildSummaryTotal(DsValidation.Tables[0]);

			lblNoWPsAffected.Text = String.Empty;
        }
        catch (IndException indExc)
        {
            this.ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            this.ShowError(new IndException(exc));
            return;
        }
    }

    /// <summary>
    /// Item created event handler of grdHours and grdCosts
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void grdHours_ItemCreated(object sender, GridItemEventArgs e)
    {
        try
        {
            //If the item is in edit mode
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                if (e.Item.IsInEditMode)
                {
                    //For each column
                    foreach (GridColumn col in item.OwnerTableView.Columns)
                    {
                        //If the column has a textbox as edit item, apply the corresponding style
                        if ((item[col] != null) && (item[col].Controls.Count != 0))
                        {
                            if (item[col].Controls[0] is TextBox)
                            {
                                TextBox txtEdit = (TextBox)item[col].Controls[0];
                                txtEdit.CssClass = CSSStrings.BudgetEditTextBoxCssClass;
                                AddJavascriptRestrictKeysScript(txtEdit, col.UniqueName);
                            }
                        }
                    }
                }
                if (item.OwnerTableView.Name == "WPTableView")
                {
                    IndImageButton btnAddCostCenter = item["AddCostCenter"].Controls[1] as IndImageButton;
                    btnAddCostCenter.OnClientClick = "if (ShowPopUpWithoutPostBack('../../../UserControls/Budget/CostCenterFilter/CostCenterFilter.aspx',0,400, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')){" + this.ClientScript.GetPostBackEventReference(btnDoPostBack, btnAddCostCenter.ClientID) + "};return false;";
                }

                if ((item.OwnerTableView.Name == "HoursCostCenterView") || (item.OwnerTableView.Name == "CostsCostCenterView"))
                {
                    IndImageButton btnDelete = item["DeleteColumn"].Controls[1] as IndImageButton;
                    btnDelete.OnClientClick = "needToConfirm=false;" + btnDelete.OnClientClick;
                }
                if (item.OwnerTableView.Name == "CostsCostCenterView")
                {
                    LinkButton btnOtherCosts = item["UpdateCost"].Controls[1] as LinkButton;
                    if (btnOtherCosts != null)
                        btnOtherCosts.OnClientClick = "needToConfirm=false;" + btnOtherCosts.OnClientClick;
                }
            }
            CreateHeaderText(e.Item, "grdHours");
        }
        catch (IndException indExc)
        {
            this.ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            this.ShowError(new IndException(exc));
            return;
        }
    }

    /// <summary>
    /// Item created event handler of grdValorization
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void grdValidation_ItemCreated(object sender, GridItemEventArgs e)
    {
        try
        {
            CreateHeaderText(e.Item, "grdValidation");
        }
        catch (IndException indExc)
        {
            this.ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            this.ShowError(new IndException(exc));
            return;
        }
    }

    protected void grdHours_UpdateCommand(object source, GridCommandEventArgs e)
    {
        GridDataItem dataItem = (GridDataItem)e.Item;
        bool operationFailed = false;
        try
        {
            DoUpdateAction((IndGrid)source, e, true);
        }
        catch (IndException indExc)
        {
            operationFailed = true;
            e.Canceled = true;
            ShowError(indExc);           
        }
        catch (Exception exc)
        {
            operationFailed = true;
            e.Canceled = true;
            ShowError(new IndException(exc));            
        }
        finally
        {
            //If there is no item in edit mode, set the submit button enabled
            if (((IndGrid)source).EditIndexes.Count > 1)
                SetUnsafeInEditModeControlsEnabledState(false);
            else
                SetUnsafeInEditModeControlsEnabledState(true);
        }
        try
        {
            if (operationFailed)
            {
                if (dataItem.OwnerTableView.Name != grdHours.MasterTableView.DetailTables[0].DetailTables[0].Name)
                {
                    ReloadGrids(grdHours);
                    grdHours.Rebind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
        }
    }

    protected void grdCostsSales_UpdateCommand(object source, GridCommandEventArgs e)
    {
        GridDataItem dataItem = (GridDataItem)e.Item;
        bool operationFailed = false;
        try
        {
            DoUpdateAction((IndGrid)source, e, false);
        }
        catch (IndException indExc)
        {
            operationFailed = true;
            e.Canceled = true;
            ShowError(indExc);
        }
        catch (Exception exc)
        {
            operationFailed = true;
            e.Canceled = true;
            ShowError(new IndException(exc));            
        }
        finally
        {
            //If there is no item in edit mode, set the submit button enabled
            if (((IndGrid)source).EditIndexes.Count > 1)
                SetUnsafeInEditModeControlsEnabledState(false);
            else
                SetUnsafeInEditModeControlsEnabledState(true);
        }
        try
        {
            if (operationFailed)
            {
                if (dataItem.OwnerTableView.Name != grdCostsSales.MasterTableView.DetailTables[0].DetailTables[0].Name)
                {
                    ReloadGrids(grdCostsSales);
                    grdCostsSales.Rebind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
        }
    }

    protected void lnkOtherCosts_Click(object sender, EventArgs e)
    {
        try
        {
            GridTableCell owningCell = (GridTableCell)(((LinkButton)sender).Parent);
            GridDataItem dataItem = (GridDataItem)owningCell.Parent;

            Hashtable newValues = new Hashtable();
            dataItem.ExtractValues(newValues);
            int idProject = int.Parse(dataItem["IdProject"].Text);
            int idPhase = int.Parse(dataItem["IdPhase"].Text);
            int idWP = int.Parse(dataItem["IdWP"].Text);
            int idCostCenter = int.Parse(dataItem["IdCostCenter"].Text);
            
            SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);

            RevisedBudgetOtherCosts revisedOtherCosts = new RevisedBudgetOtherCosts();
            revisedOtherCosts = BuildRevisedBudgetOtherCosts(dataItem);

            //Save othercosts to session so that it can be retrieved in other costs pop up
            SessionManager.SetSessionValue(this, SessionStrings.REVISED_OTHER_COSTS, revisedOtherCosts);
            if (!ClientScript.IsClientScriptBlockRegistered(this.GetType(), "OpenOtherCostsPopUp"))
            {
                ClientScript.RegisterClientScriptBlock(this.GetType(), "OpenOtherCostsPopUp", "if (ShowPopUpWithoutPostBack('" + ResolveUrl("~/Pages/Budget/RevisedBudget/OtherCosts.aspx?IsAssociateCurrency=" + (IsAssociateCurrency ? 1 : 0)) + "&AmountScaleOption=" + cmbAmountScale.Text + "',0,450, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) {" + ClientScript.GetPostBackEventReference(btnDoPostBack, ((Control)sender).ClientID) + " }", true);
            }
        }
        catch (IndException indExc)
        {
            this.ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            this.ShowError(new IndException(exc));
            return;
        }
    }

    /// <summary>
    /// Returns a row from the thrid table of the source dataset that correpsonds to the given key
    /// </summary>
    /// <param name="projectId">The Projects's id</param>
    /// <param name="phaseId">The Phase Id</param>
    /// <param name="wpId">The WP Id</param>
    /// <param name="costCenterId">The Cost Center Id</param>
    /// <returns></returns>
    private DataRow GetDataSourceRow(int projectId, int phaseId, int wpId, int costCenterId)
    {
        try
        {
            foreach (DataRow row in DsCosts.Tables[2].Rows)
            {
                if (((int)row["IdProject"] == projectId) && ((int)row["IdPhase"] == phaseId) &&
                    ((int)row["IdWP"] == wpId) && ((int)row["IdCostCenter"] == costCenterId))
                    return row;
            }
            return null;
        }
        catch (IndException indExc)
        {
            this.ShowError(indExc);
            return null;
        }
        catch (Exception exc)
        {
            this.ShowError(new IndException(exc));
            return null;
        }
    }

    protected void grdHours_CancelCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            DoCancelAction((IndGrid)source, (GridDataItem)e.Item, false);
        }
        catch (IndException indExc)
        {
            HideChildControls();
            ShowError(indExc);
            e.Canceled = true;
            return;
        }
        catch (Exception exc)
        {
            HideChildControls();
            ShowError(new IndException(exc));
            e.Canceled = true;
            return;
        }
    }

    protected void grdCostsSales_CancelCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            DoCancelAction((IndGrid)source, (GridDataItem)e.Item, true);
        }
        catch (IndException indExc)
        {
            HideChildControls();
            ShowError(indExc);
            e.Canceled = true;
            return;
        }
        catch (Exception exc)
        {
            HideChildControls();
            ShowError(new IndException(exc));
            e.Canceled = true;
            return;
        }
    }

    protected void btnDeleteCostCenter_Click(object sender, EventArgs e)
    {
        try
        {
            GridDataItem item = ((Control)sender).Parent.Parent as GridDataItem;

            object connManager = SessionManager.GetConnectionManager(this);

            RevisedBudget revisedBudget = new RevisedBudget(connManager);
            revisedBudget.IdProject = int.Parse(item["IdProject"].Text);
            revisedBudget.IdPhase = int.Parse(item["IdPhase"].Text);
            revisedBudget.IdWP = int.Parse(item["IdWP"].Text);
            revisedBudget.IdCostCenter = int.Parse(item["IdCostCenter"].Text);
            revisedBudget.IdAssociate = SessionManager.GetCurrentUser(this).IdAssociate;
            revisedBudget.SetDeleted();

            DataSet ds = null;
            if (item.OwnerTableView.OwnerGrid == grdHours)
            {
                ds = DsHours;
            }
            if (item.OwnerTableView.OwnerGrid == grdCostsSales)
            {
                ds = DsCosts;
            }

            bool currentItemInEditMode = item.IsInEditMode;

            StoreEditedCostCentersIndexes(tabStripRevisedBudget.SelectedIndex);
            StoreEditedCostCenters((IndGrid)item.OwnerTableView.OwnerGrid, revisedBudget);

            //Get the start and end year month values
            DataRow parentRow = GetCostCenterParentRow(ds, revisedBudget.IdProject, revisedBudget.IdPhase, revisedBudget.IdWP);
            YearMonth startYearMonth = new YearMonth(parentRow["StartYearMonth"].ToString());
            YearMonth endYearMonth = new YearMonth(parentRow["EndYearMonth"].ToString());

            CurrentUser currentUser = SessionManager.GetCurrentUser(this);

            try
            {
                //Check if the wp period has changed in the meanwhile
                WorkPackage currentWP = new WorkPackage(connManager);
                currentWP.IdProject = revisedBudget.IdProject;
                currentWP.IdPhase = revisedBudget.IdPhase;
                currentWP.Id = revisedBudget.IdWP;
                currentWP.StartYearMonth = startYearMonth.Value;
                currentWP.EndYearMonth = endYearMonth.Value;

                currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);

                revisedBudget.SaveBudget(startYearMonth, endYearMonth, null, true);
                OpenBudgetState(int.Parse(item["IdProject"].Text), currentUser.IdAssociate);
                if (item.IsInEditMode)
                    item.Edit = false;
            }
            catch (IndException indExc)
            {
                this.ShowError(indExc);
                return;
            }

            //Refresh the costs & sales dataset
            LoadHoursData();
            LoadCostsSalesData();
            BuildValidationData();

            if (cmbAmountScale.Text != AmountScaleOption.Unit.ToString())
            {
                RadComboBoxSelectedIndexChangedEventArgs loadEventArgs = new RadComboBoxSelectedIndexChangedEventArgs();
                loadEventArgs.OldText = AmountScaleOption.Unit.ToString();
                loadEventArgs.Text = cmbAmountScale.Text;
                cmbAmountScale_SelectedIndexChanged(cmbAmountScale, loadEventArgs);
            }
            else
            {
                SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
                SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
                SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);
                //Rebind the grid that issued the request
                grdHours.Rebind();
                grdCostsSales.Rebind();
                grdValidation.Rebind();
            }
            RestoreEditedCostCentersIndexes(tabStripRevisedBudget.SelectedIndex);

            RemoveRevisedOtherCostsFromSession(item);

            //If there is no item in edit mode or if the item that was in edit mode was deleted, set the submit button enabled
            if (item.OwnerTableView.OwnerGrid.EditIndexes.Count == 0 || (item.OwnerTableView.OwnerGrid.EditIndexes.Count == 1 && currentItemInEditMode))
                SetUnsafeInEditModeControlsEnabledState(true);
            else
                SetUnsafeInEditModeControlsEnabledState(false);
        }
        catch (IndException indExc)
        {
            HideChildControls();
            this.ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            HideChildControls();
            this.ShowError(new IndException(exc));
            return;
        }
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            IndGrid issuerGrid = null;
            string tableViewName = null;
            switch (tabStripRevisedBudget.SelectedIndex)
            {
                case 0:
                    issuerGrid = grdHours;
                    tableViewName = "HoursCostCenterView";
                    break;
                case 1:
                    issuerGrid = grdCostsSales;
                    tableViewName = "CostsCostCenterView";
                    break;
                default:
                    throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
            }
            //Get all items, no matter on what level
            foreach (GridItem gridItem in issuerGrid.Items)
            {
                //Ignore the items that are not on the last table view
                if (gridItem.OwnerTableView.Name != tableViewName)
                    continue;
                if (!(gridItem is GridDataItem))
                    continue;
                GridDataItem item = gridItem as GridDataItem;
                CommandEventArgs eventArgs = new CommandEventArgs("Update", null);
                GridCommandEventArgs args = new GridCommandEventArgs(gridItem, false, eventArgs);
                if (item.Edit)
                {
                    if (issuerGrid == grdHours)
                    {
                        try
                        {
                            DoUpdateAction(issuerGrid, args, true);
                            item.Edit = false;
                        }
                        catch (IndException indExc)
                        {
                            ReloadGrids(issuerGrid);
                            issuerGrid.Rebind();
                            this.ShowError(indExc);
                            return;
                        }
                    }
                    else
                    {
                        try
                        {
                            DoUpdateAction(issuerGrid, args, false);
                            item.Edit = false;
                        }
                        catch (IndException indExc)
                        {
                            ReloadGrids(issuerGrid);
                            issuerGrid.Rebind();
                            this.ShowError(indExc);
                            return;
                        }
                    }
                }
            }
            //If there is no item in edit mode, set the submit button enabled
            if (issuerGrid.EditIndexes.Count == 0)
                SetUnsafeInEditModeControlsEnabledState(true);
            ReloadGrids(issuerGrid);

            //For some reason, if we do not set the datasource of the grid to null, even when the grid rebinds,
            //the values are refreshed only for the first row that is saved. We must explicitly set
            //the datasource of the grid to null to avoid this
            issuerGrid.DataSource = null;
            issuerGrid.MasterTableView.DataSource = null;
            issuerGrid.MasterTableView.DetailTables[0].DataSource = null;
            issuerGrid.MasterTableView.DetailTables[0].DetailTables[0].DataSource = null;

            issuerGrid.Rebind();
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
    }
    protected void grdHours_EditCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            IndGrid currentGrid = null;
            DataSet currentDs = null;
            switch (tabStripRevisedBudget.SelectedIndex)
            {
                case 0:
                    currentGrid = grdHours;
                    currentDs = DsHours;
                    break;
                case 1:
                    currentGrid = grdCostsSales;
                    currentDs = DsCosts;
                    break;
                case 2:
                    throw new NotImplementedException("Tab index: " + tabStripRevisedBudget.SelectedIndex + " does not support Edit Cost Center operation");
                default:
                    throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
            }
            //Store the edited cost center values
            StoreEditedCostCenters(currentGrid, (RevisedBudget)null);

            SetUnsafeInEditModeControlsEnabledState(false);
            //Restore the edited cost center values
            RestoreEditedCostCenters(currentDs);

            //The grid needs to rebind such that all rows that should now be in edit mode are set in edit mode
            currentGrid.Rebind();
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
    }

    protected void grdHours_PreRender(object sender, EventArgs e)
    {
        try
        {
            MakeInactiveWPsReadOnly((IndGrid)sender);
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
    }

    protected void grdCostsSales_PreRender(object sender, EventArgs e)
    {
        try
        {
            MakeInactiveWPsReadOnly((IndGrid)sender);
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
    }
    #endregion Event Handlers

    #region Private Methods
    /// <summary>
    /// GET the Budget State for the current or associate id from query string
    /// </summary>
    private string GetCurrentBudgetState()
    {
        //Submit button visible for CTM only in Open state
        //Approve button visible for PM only in Waiting for approval state
        //Reject button visible for PM in Waiting for approval and Approved states         


        string budgetState = String.Empty;
        //Get the connection manager from the session
        object conMan = SessionManager.GetConnectionManager(this);
        // Get the current project
        CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
        //Get the current logged user
        CurrentUser user = (CurrentUser)SessionManager.GetSessionValueRedirect(this.Page, SessionStrings.CURRENT_USER);

        //get the budget state for this associate from database
        FollowUpRevisedBudget followUpRevisedBudget = new FollowUpRevisedBudget(conMan);
        followUpRevisedBudget.IdProject = currentProject.Id;
        followUpRevisedBudget.BudVersion = BudgetVersion;
        followUpRevisedBudget.IdAssociate = ((FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS ? user.IdAssociate : FollowUpIdAssociate));

        budgetState = followUpRevisedBudget.GetRevisedBudgetStateForEvidence("GetRevisedBudgetStateForEvidence");

        if (string.IsNullOrEmpty(budgetState))
        {
            budgetState = ApplicationConstants.BUDGET_STATE_NONE;
        }
        return budgetState;
    }

    /// <summary>
    /// Set Buttons visibility for approve, reject, submit buttons
    /// </summary>
    private void SetButtonsVisibility()
    {
        // Get the current project
        CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
        //Get the current logged user
        CurrentUser user = (CurrentUser)SessionManager.GetSessionValueRedirect(this.Page, SessionStrings.CURRENT_USER);       
        //check to see the budget valid state
        bool isBudgetValid = GetBudgetIsValidState_Revised();

        //if budget is validated disable all
        if (isBudgetValid)
        {
            SetButtonsAndGridReadOnly();
            return;
        }

        //if budget for all user must be shown from follow up...disable all
        if (FollowUpIdAssociate == ApplicationConstants.INT_NULL_VALUE)
        {
            SetButtonsAndGridReadOnly();
            return;
        }

        //get the current budget state
        string budgetState = GetCurrentBudgetState();

        //do the test only if the page comes from FollowUp screen otherwise only show Submit Button if state is Open
        if (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            //if ther is PM on the current project - we enable the buttons for PM
             // if the user is BA OR TA then he sees the approve and reject buttons
            if (user.ProgramManagerProjects.ContainsKey(currentProject.Id) ||
                (user.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR) ||
                (user.UserRole.Id == ApplicationConstants.ROLE_TECHNICAL_ADMINISTATOR))
            {
                SetVisibleButtonsForPM(budgetState);
            }           

            EvidenceButton.SubmitVisible = false;
            //if it comes from followup grid si readonly no matter the state
            SetGridReadOnly();
        }
        else
        {
            switch (budgetState)
            {
                case ApplicationConstants.BUDGET_STATE_OPEN:
                    EvidenceButton.SubmitVisible = true;
                    break;
                case ApplicationConstants.BUDGET_STATE_NONE:
                    break;
                default:
                    SetGridReadOnly();
                    break;
            }
        }
    }

    private void SetGridReadOnly()
    {
        isGridReadOnly = true;
        //When the grid is made readonly, the save all button becomes invisible
        btnSave.Visible = false;

        RadAjaxManager ajaxManager = GetAjaxManager();
        switch (tabStripRevisedBudget.SelectedIndex)
        {
            case 0:
                if (btnSave.Visible)
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, btnSave);
                break;
            case 1:
                if (btnSave.Visible)
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, btnSave);
                break;
            case 2:
                if (btnSave.Visible)
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdValidation, btnSave);
                break;
            default:
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
        }
    }

    private void SetVisibleButtonsForCTM(string budgetState)
    {
        if (string.IsNullOrEmpty(budgetState))
        {
            throw new IndException(ApplicationMessages.EXCEPTION_BUDGET_STATE_MISSING);
        }
        if (budgetState == ApplicationConstants.BUDGET_STATE_OPEN)
        {
            EvidenceButton.SubmitVisible = true;
        }
    }
    //a PM user can approve, reject a budget
    private void SetVisibleButtonsForPM(string stateCode)
    {
        if (string.IsNullOrEmpty(stateCode))
        {
            throw new IndException(ApplicationMessages.EXCEPTION_BUDGET_STATE_MISSING);
        }
        switch (stateCode)
        {
            case ApplicationConstants.BUDGET_STATE_WAITING_APPROVAL:
                EvidenceButton.ApprovedVisible = true;
                EvidenceButton.RejectVisible = true;
                break;

            case ApplicationConstants.BUDGET_STATE_APPROVED:
                EvidenceButton.RejectVisible = true;
                break;

        }

        //EvidenceButton.SubmitVisible = false;
    }

    private void SetButtonsAndGridReadOnly()
    {
        EvidenceButton.SubmitVisible = false;
        EvidenceButton.RejectVisible = false;
        EvidenceButton.ApprovedVisible = false;

        //the budget is validated so no changes can be done
        SetGridReadOnly();
    }

    /// <summary>
    /// get the validated status of the whole budget
    /// </summary>
    /// <returns></returns>
    private bool GetBudgetIsValidState_Revised()
    {
        CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
        FollowUpRevisedBudget followUpRevisedBudget = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
        followUpRevisedBudget.IdProject = currentProject.Id;
        followUpRevisedBudget.BudVersion = BudgetVersion;
        bool isValid = followUpRevisedBudget.GetRevisedBudgetValidState("GetRevisedScalarValidState");
        return isValid;
    }


    /// <summary>
    /// Load the hours data from the database
    /// </summary>
    private void LoadHoursData()
    {
        int idAssociate = ApplicationConstants.INT_NULL_VALUE;
        object connectionManager = SessionManager.GetConnectionManager(this);
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        RevisedBudget budget = new RevisedBudget(connectionManager);

        //If the budget is accessed from follow-up
        if (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            budget.Version = BudgetVersion;
        }

        //If FollowUpIdAssociate is direct in page
        if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            idAssociate = currentUser.IdAssociate;
        }
        else
        {
            idAssociate = FollowUpIdAssociate;
        }

        budget.IsAssociateCurrency = IsAssociateCurrency;
        budget.IdAssociate = idAssociate;
        budget.IdAssociateViewer = currentUser.IdAssociate;

		int idCountry;
		if (int.TryParse(cmbCountry.SelectedValue, out idCountry) == false)
		{
			throw new IndException(ApplicationMessages.EXCEPTION_BUDGET_COUNTRY_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
		}
		budget.IdCountry = idCountry;

        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        budget.IdProject = currentProject.Id;

        DsHours = budget.GetHours();

        if (!IsPostBack)
        {
            //Fill exchange rate only the first time when the dataset is loaded
            FillExchangeRateCache();
        }

        //Apply the needed datasource transformation
        budget.ApplyDataSourceTransformations(DsHours, IsAssociateCurrency, SessionManager.GetCurrentUser(this), SessionManager.GetCurrencyConverter(this), 0);

        if (tabStripRevisedBudget.SelectedIndex == 0)
        {
            //Restores values from the currently cost centers that are in edit mode
            RestoreEditedCostCenters(DsHours);
        }


        if (totals == null)
            totals = new RevisedBudgetTotals();
        totals.BuildHoursTotal(DsHours.Tables[0]);
    }

    
    /// <summary>
    /// Load the costs & sales data from the database
    /// </summary>
    private void LoadCostsSalesData()
    {
        int idAssociate = ApplicationConstants.INT_NULL_VALUE;
        object connectionManager = SessionManager.GetConnectionManager(this);
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        RevisedBudget budget = new RevisedBudget(connectionManager);
        if (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            budget.Version = BudgetVersion;
        }

        //If FollowUpIdAssociate is direct in page
        if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            idAssociate = currentUser.IdAssociate;
        }
        else
        {
            idAssociate = FollowUpIdAssociate;
        }

        budget.IsAssociateCurrency = IsAssociateCurrency;
        budget.IdAssociate = idAssociate;
        budget.IdAssociateViewer = currentUser.IdAssociate;

		int idCountry;
		if (int.TryParse(cmbCountry.SelectedValue, out idCountry) == false)
		{
			throw new IndException(ApplicationMessages.EXCEPTION_BUDGET_COUNTRY_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
		}
		budget.IdCountry = idCountry;

        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        budget.IdProject = currentProject.Id;

        DsCosts = budget.GetCostsSales();

        //Apply the needed datasource transformation
        budget.ApplyDataSourceTransformations(DsCosts, IsAssociateCurrency, SessionManager.GetCurrentUser(this), SessionManager.GetCurrencyConverter(this), 1);

        if (tabStripRevisedBudget.SelectedIndex == 1)
        {
            //Restores values from the currently cost centers that are in edit mode
            RestoreEditedCostCenters(DsCosts);
        }


        if (totals == null)
            totals = new RevisedBudgetTotals();
        totals.BuildCostsTotal(DsCosts.Tables[0]);
    }

    /// <summary>
    /// Builds the validation data from data from the other 2 tabs
    /// </summary>
    private void BuildValidationData()
    {
        object connectionManager = SessionManager.GetConnectionManager(this);
        DsValidation = (new RevisedBudget(connectionManager)).BuildValidationDataSet(DsHours, DsCosts);
        //Apply the needed datasource transformation
        (new RevisedBudget(connectionManager)).ApplyDataSourceTransformations(DsValidation, IsAssociateCurrency, SessionManager.GetCurrentUser(this), SessionManager.GetCurrencyConverter(this), 2);


        if (totals == null)
            totals = new RevisedBudgetTotals();
        totals.BuildSummaryTotal(DsValidation.Tables[0]);

        grdValidation.Rebind();
    }
    /// <summary>
    /// Sets the visible property of one of the 3 grids to true, and false to the other 2, depending on the selected tab index
    /// </summary>
    /// <param name="tabIndex">the index of the selected tab</param>
    private void ShowGrid(int tabIndex)
    {
        //Depending on the clicked tab, set the visible properties of the 3 grids
        switch (tabIndex)
        {
            case 0:
                SetGridsVisible(true, false, false);
                break;
            case 1:
                SetGridsVisible(false, true, false);
                break;
            case 2:
                SetGridsVisible(false, false, true);
                break;
            default:
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
        }
    }
    /// <summary>
    /// Sets the visible property of the 3 grids in the page, depending on the grid that is currently showing
    /// </summary>
    /// <param name="grdHoursVisible">if true, grdHours is visible, otherwise it is not visible</param>
    /// <param name="grdCostsSalesVisible">if true, grdCostsSales is visible, otherwise it is not visible</param>
    /// <param name="grdValidationVisible">if true, grdValidation is visible, otherwise it is not visible</param>
    private void SetGridsVisible(bool grdHoursVisible, bool grdCostsSalesVisible, bool grdValidationVisible)
    {
        grdHours.Visible = grdHoursVisible;
        grdCostsSales.Visible = grdCostsSalesVisible;
        grdValidation.Visible = grdValidationVisible;
    }
    
    /// <summary>
    /// Converts decimal data in the 3 grids from one amount scale option to another
    /// </summary>
    /// <param name="oldAmountScale"></param>
    /// <param name="newAmountScale"></param>
    private void AmountScaleConvert(AmountScaleOption oldAmountScale, AmountScaleOption newAmountScale)
    {
        RevisedBudget budget = new RevisedBudget(SessionManager.GetConnectionManager(this));
        //Set amount scale for hours dataset
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsHours.Tables[0]);
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsHours.Tables[1]);
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsHours.Tables[2]);
        
        //Set amount scale for costs dataset
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsCosts.Tables[0]);
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsCosts.Tables[1]);
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsCosts.Tables[2]);

        //Set amount scale for validation dataset
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsValidation.Tables[0]);
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsValidation.Tables[1]);
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsValidation.Tables[2]);
    }

    private void AddCostCenter(string issuer)
    {
        bool isWPActive;

        //Get the grid that caused the add cost center operation
        IndGrid issuerGrid = GetAddCCIssuerGrid(tabStripRevisedBudget.SelectedIndex);
        
        StoreEditedCostCenters(issuerGrid, (RevisedBudget)null);

        string MassAttribution = (SessionManager.GetSessionValueNoRedirect(this, SessionStrings.ADD_CC_TO_TARGET) == null) ?
                                        ApplicationConstants.ADD_CC_TO_CURRENT_WP :
                                        (string)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.ADD_CC_TO_TARGET);
        bool useMassAttribution = (MassAttribution == ApplicationConstants.ADD_CC_TO_CURRENT_WP ? false : true);
        int rowToUpdate = 0;
		int updatedRows = 0;
		lblNoWPsAffected.Text = String.Empty;        
        //Find the detail table where the cost center must be inserted
        for (int i = 0; i < issuerGrid.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = issuerGrid.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                // Get the current project
                CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
                string ProjectFunctionWPCodeSuffix = currentProject.ProjectFunctionWPCodeSuffix;

                DataRow drCurrentWP = DsHours.Tables[1].Rows[rowToUpdate];
                string currentWPCode = drCurrentWP["WPCode"].ToString();
                string currentWPCodeSuffix = currentWPCode.Substring(currentWPCode.Length - 2, 2);

                //Check if the current wp is active
                if (bool.TryParse(detailTableView.Items[j]["IsActive"].Text, out isWPActive) == false)
                    throw new IndException("Value of 'IsActive' column must be of boolean type.");
                //Check if WP Code Suffix is not empty
                if (MassAttribution == ApplicationConstants.ADD_CC_TO_MY_WPS && ProjectFunctionWPCodeSuffix == String.Empty)
                    throw new IndException("Current project function has no WP Code Suffix defined.");

                GridDataItem item = detailTableView.Items[j];
                IndImageButton currentButton = item["AddCostCenter"].Controls[1] as IndImageButton;
                if (currentButton == null)
                    return;

                bool addCC = false;
                if (((currentButton.ClientID == issuer) || (useMassAttribution)) && isWPActive)
                {
                    if (MassAttribution != ApplicationConstants.ADD_CC_TO_MY_WPS)
                        addCC = true;
                    else
                        addCC = (ProjectFunctionWPCodeSuffix.IndexOf(currentWPCodeSuffix) > -1);
                }

                if (addCC)
                {
                    //Get the selected cost center from session
                    CostCenterFilter costCenter = SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_COSTCENTER) as CostCenterFilter;
                    if (costCenter == null)
                        return;
                    int idAssociate = ((CurrentUser)SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER)).IdAssociate;
                    object connectionManager = SessionManager.GetConnectionManager(this);
                    //Build an RevisedBudgetHours object
                    RevisedBudget revisedBudget = new RevisedBudget(connectionManager);
                    //Set the necessary fields for insert
                    revisedBudget.IdProject = int.Parse(item["IdProject"].Text);
                    revisedBudget.IdPhase = int.Parse(item["IdPhase"].Text);
                    revisedBudget.IdWP = int.Parse(item["IdWP"].Text);
                    revisedBudget.IdCostCenter = costCenter.IdCostCenter;
                    revisedBudget.CostCenterName = costCenter.NameCostCenter;
                    revisedBudget.IdAssociate = idAssociate;

                    //Get the start and end year month values
                    YearMonth startYearMonth = new YearMonth(item["StartYearMonth"].Text);
                    YearMonth endYearMonth = new YearMonth(item["EndYearMonth"].Text);

                    RevisedBudgetOtherCosts otherCosts = new RevisedBudgetOtherCosts(SessionManager.GetConnectionManager(this));
                    otherCosts.IdProject = revisedBudget.IdProject;
                    otherCosts.IdPhase = revisedBudget.IdPhase;
                    otherCosts.IdWP = revisedBudget.IdWP;
                    otherCosts.IdCostCenter = revisedBudget.IdCostCenter;
                    otherCosts.IdAssociate = revisedBudget.IdAssociate;
                    otherCosts.SetNew();

                    try
                    {
                        //Check if the wp period has changed in the meanwhile
                        WorkPackage currentWP = new WorkPackage(SessionManager.GetConnectionManager(this));
                        currentWP.IdProject = revisedBudget.IdProject;
                        currentWP.IdPhase = revisedBudget.IdPhase;
                        currentWP.Id = revisedBudget.IdWP;
                        currentWP.StartYearMonth = startYearMonth.Value;
                        currentWP.EndYearMonth = endYearMonth.Value;

                        currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);
                       
                        //Insert into the database
                        revisedBudget.SetNew();
                        revisedBudget.SaveBudget(startYearMonth, endYearMonth, otherCosts, true);

                        OpenBudgetState(int.Parse(item["IdProject"].Text), idAssociate);

                        //Update all 3 datasets
                        if (!useMassAttribution)
                        {
                            ReloadData();
                        }
                        
                    }
                    catch (IndException exc)
                    {
                        ShowError(exc);
                        if (!useMassAttribution)
                            return;
                    }
                    catch (Exception exc)
                    {
                        ShowError(new IndException(exc));
                        if (!useMassAttribution)
                            return;
                    }
                    if (!useMassAttribution)
                        return;
                    
                    updatedRows++;
                }
                rowToUpdate++;
            }
        }
		if (MassAttribution == ApplicationConstants.ADD_CC_TO_MY_WPS && updatedRows == 0)
		{
			lblNoWPsAffected.Text = "No Work Packages qualify for the criteria \"My WPs\"";
		}
        if (useMassAttribution)
        {
            ReloadData();
        }
        if (issuerGrid.EditIndexes.Count == 0)
            SetUnsafeInEditModeControlsEnabledState(true);
        else
            SetUnsafeInEditModeControlsEnabledState(false);
    }

    /// <summary>
    /// Returns the grid that issued the add cost center operation, depending on the current tab
    /// </summary>
    /// <param name="tabIndex"></param>
    /// <returns></returns>
    private IndGrid GetAddCCIssuerGrid(int tabIndex)
    {
        //Get the grid that caused the add cost center operation
        IndGrid issuerGrid = null;
        switch (tabIndex)
        {
            case 0:
                issuerGrid = grdHours;
                break;
            case 1:
                issuerGrid = grdCostsSales;
                break;
            case 2:
                throw new NotImplementedException("Tab index: " + tabCostsSales.TabIndex + " does not support Add Cost Center operation");
            default:
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
        }

        return issuerGrid;
    }

    /// <summary>
    /// Add ajax settings depending on the selected tab
    /// </summary>
    private void AddAjaxSettings()
    {
        RadAjaxManager ajaxManager = GetAjaxManager();
        Panel pnlErrors = (Panel)Master.FindControl("pnlErrors");
        
        //Depending on the clicked tab, set the ajax settings
        switch (tabStripRevisedBudget.SelectedIndex)
        {
            case 0:
                ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, grdHours);
                ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, grdHours);
				ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, grdHours);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, pnlErrors);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, grdHours);
                //Grid must update all controls which become invisible when an error ocurrs
                ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, cmbAmountScale);
				ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, cmbCountry);
                if (pnlTotalsHours.Visible)
                {
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, pnlTotalsHours);
                    ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, pnlTotalsHours);
                    ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, pnlTotalsHours);
					ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, pnlTotalsHours);
                }
                if (lblWarning.Visible)
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, lblWarning);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, pnlEvidence);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, tabStripRevisedBudget);
                if (btnSave.Visible)
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, btnSave);
				if (lblNoWPsAffected.Visible)
				{
					ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, lblNoWPsAffected);
					ajaxManager.AjaxSettings.AddAjaxSetting(grdHours, lblNoWPsAffected);
				}    
                break;
            case 1:
                ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, grdCostsSales);
                ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, grdCostsSales);
				ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, grdCostsSales);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, pnlErrors);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, grdCostsSales);
                //Grid must update all controls which become invisible when an error ocurrs
                ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, cmbAmountScale);
				ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, cmbCountry);
                if (pnlTotalsCostsSales.Visible)
                {
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, pnlTotalsCostsSales);
                    ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, pnlTotalsCostsSales);
                    ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, pnlTotalsCostsSales);
                }
                if (lblWarning.Visible)
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, lblWarning);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, pnlEvidence);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, tabStripRevisedBudget);
                if (btnSave.Visible)
                    ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, btnSave);
				if (lblNoWPsAffected.Visible)
				{
					ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, lblNoWPsAffected);
					ajaxManager.AjaxSettings.AddAjaxSetting(grdCostsSales, lblNoWPsAffected);
				}                    
                break;
            case 2:
                ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, grdValidation);
				ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, grdValidation);
                if (pnlTotalsSummary.Visible)
                {
                    ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, pnlTotalsSummary);
					ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, pnlTotalsSummary);
                }
                break;
            default:
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
        }

        //Postback button must update all controls which become invisible when an error ocurrs
        ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, pnlErrors);
        ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, cmbAmountScale);
		ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, cmbCountry);
            
        if (lblWarning.Visible)
            ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, lblWarning);
        ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, pnlEvidence);
        ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, tabStripRevisedBudget);
    }
    /// <summary>
    /// Builds a BudgetOtherCosts object to be sent to the other costs pop-up
    /// </summary>
    /// <param name="dataItem"></param>
    /// <returns></returns>
    private RevisedBudgetOtherCosts BuildRevisedBudgetOtherCosts(GridDataItem dataItem)
    {
        object connectionManager = SessionManager.GetConnectionManager(this);
        int idAssociate = SessionManager.GetCurrentUser(this).IdAssociate;
        //Build other costs object
        RevisedBudgetOtherCosts otherCosts = new RevisedBudgetOtherCosts(connectionManager);
        otherCosts.IdAssociate = idAssociate;
        otherCosts.IdAssociateViewer = idAssociate;
        otherCosts.IdCostCenter = int.Parse(dataItem["IdCostCenter"].Text);
        otherCosts.IdPhase = int.Parse(dataItem["IdPhase"].Text);
        otherCosts.IdProject = int.Parse(dataItem["IdProject"].Text);
        otherCosts.IdWP = int.Parse(dataItem["IdWP"].Text);
        return otherCosts;
    }

    /// <summary>
    /// Removes all RevisedBudgetOtherCosts objects whose keys are taken from budgetList from session
    /// </summary>
    /// <param name="budgetList">List of budget objects containing only the keys which will be used to build RevisedBudgetOtherCosts objects</param>
    private void RemoveRevisedOtherCostsFromSession(List<Budget> budgetList)
    {
        RevisedBudgetOtherCosts otherCosts;
        int idAssociate = SessionManager.GetCurrentUser(this).IdAssociate;
        foreach (Budget budgetKey in budgetList)
        {
            otherCosts = new RevisedBudgetOtherCosts();
            otherCosts.IdAssociate = idAssociate;
            otherCosts.IdCostCenter = budgetKey.IdCostCenter;
            otherCosts.IdPhase = budgetKey.IdPhase;
            otherCosts.IdProject = budgetKey.IdProject;
            otherCosts.IdWP = budgetKey.IdWP;

            SessionManager.RemoveRevisedOtherCosts(this, otherCosts);
        }
    }

    /// <summary>
    /// Removes a BudgetRevisedOtherCosts object built from the given dataItem from the list of BudgetRevisedOtherCosts objects which
    /// is held in the session
    /// </summary>
    /// <param name="dataItem">the item containing information about BudgetRevisedOtherCosts object to be removed from session</param>
    private void RemoveRevisedOtherCostsFromSession(GridDataItem dataItem)
    {
        RevisedBudgetOtherCosts otherCosts = new RevisedBudgetOtherCosts();
        otherCosts = BuildRevisedBudgetOtherCosts(dataItem);
        SessionManager.RemoveRevisedOtherCosts(this, otherCosts);
    }

    private DataRow GetCostCenterParentRow(DataSet ds, int idProject, int idPhase, int idWP)
    {
        foreach (DataRow row in ds.Tables[1].Rows)
        {
            if (((int)row["IdProject"] == idProject) && ((int)row["IdPhase"] == idPhase) && ((int)row["IdWP"] == idWP))
                return row;
        }
        throw new IndException(ApplicationMessages.EXCEPTION_COST_CENTER_PARENT_NOT_FOUND);
    }
    /// <summary>
    /// Makes the currency code column visible or hidden in all 3 grids, depending on the currency representaion mode
    /// </summary>
    private void SetCurencyColumnVisible(int tabIndex)
    {
        //Get the current user from the session
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        IndGrid grid = null;
        switch (tabIndex)
        {
            case 0:
                grid = grdHours;
                break;
            case 1:
                grid = grdCostsSales;
                break;
            case 2:
                grid = grdValidation;
                break;
            default:
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
        }
        if (currentUser.Settings.CurrencyRepresentation == CurrencyRepresentationMode.CostCenter)
        {
            //grid.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = true;

            grdHours.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = true;
            grdCostsSales.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = true;
            grdValidation.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = true;
            GridColumn costCenterColumn = grid.MasterTableView.DetailTables[0].DetailTables[0].GetColumnSafe("CostCenterName");
            if (costCenterColumn != null && (grid == grdHours || grid == grdCostsSales))
            {
                costCenterColumn.ItemStyle.Width = Unit.Pixel(COST_CENTER_WIDTH_CURRENCY_HOURS);
            }
            if (costCenterColumn != null && grid == grdValidation)
            {
                costCenterColumn.ItemStyle.Width = Unit.Pixel(COST_CENTER_WIDTH_CURRENCY_SUMMARY);
            }
        }
        else
        {
            //grid.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = false;

            grdHours.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = false;
            grdCostsSales.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = false;
            grdValidation.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = false;

            GridColumn costCenterColumn = grid.MasterTableView.DetailTables[0].DetailTables[0].GetColumnSafe("CostCenterName");
            if (costCenterColumn != null && (grid == grdHours || grid == grdCostsSales))
            {
                costCenterColumn.ItemStyle.Width = Unit.Pixel(COST_CENTER_WIDTH_NO_CURRENCY_HOURS);
            }
            if (costCenterColumn != null && grid == grdValidation)
            {
                costCenterColumn.ItemStyle.Width = Unit.Pixel(COST_CENTER_WIDTH_NO_CURRENCY_SUMMARY);
            }
        }
    }

    /// <summary>
    /// Inserts the currency representation type in the header of the grids
    /// </summary>
    /// <param name="gridItem"></param>
    private void CreateHeaderText(GridItem gridItem, string gridId)
    {
        if (!(gridItem is GridHeaderItem)
            || (gridItem.OwnerTableView != grdHours.MasterTableView
            && gridItem.OwnerTableView != grdCostsSales.MasterTableView
            && gridItem.OwnerTableView != grdValidation.MasterTableView))
            return;
        //Get the current user from the session
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        //Initialize the string that represents the currebcy representaion mode
        string currencyRepresentationString = String.Empty;
        if (currentUser.Settings.CurrencyRepresentation != CurrencyRepresentationMode.Associate)
            currencyRepresentationString = "Local";
        else
        {
            //Build a currency object that will retrive the currency name
            int idCurrency = currentUser.IdCurrency;
            Currency currencyObj = new Currency(SessionManager.GetConnectionManager(this));
            currencyObj.Id = idCurrency;
            //Retrieve the currency name
            DataRow row = currencyObj.SelectEntity();
            currencyRepresentationString = row["Name"].ToString();
        }
        GridHeaderItem headerItem = gridItem as GridHeaderItem;
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        RevisedBudget revisedBug = new RevisedBudget(SessionManager.GetConnectionManager(this));
        revisedBug.IdProject = currentProject.Id;
        if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            revisedBug.Version = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;
        }
        else
        {
            revisedBug.Version = BudgetVersion;
        }

        bool bIsFake;
        string versionNo = revisedBug.GetVersionNumber(out bIsFake);
        //Update the header text
        headerItem["PhaseName"].Text = "Currency: " + currencyRepresentationString + "<br />" + "Version Number: " + versionNo + (bIsFake == true ? "~" : "");

        //Just for Follow-up
        bool isFromFollowUp = (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS);
        if (isFromFollowUp)
        {
            SetHaderForFollowUp(gridItem, versionNo, gridId);
        }
    }
    private void SetHaderForFollowUp(GridItem gridItem, string versionNo, string gridId)
    {
        int previewVersion = 0;
        int previewVersionMinus = 0;
        previewVersion = int.Parse(versionNo) - 1;
        previewVersionMinus = previewVersion - 1;

        if (gridItem.OwnerTableView == grdHours.MasterTableView)
        {
            GridHeaderItem headerItem = gridItem as GridHeaderItem;
            switch (BudgetVersion)
            {
                case "N":
                    if (previewVersion > 0)
                    {
                        headerItem["NewVal"].Text = "<br />" + EBudgetVersion.InProgress.ToString();
                        headerItem["NewHours"].Text = "<br />" + EBudgetVersion.InProgress.ToString();
                    }
                    else
                    {
                        headerItem["NewVal"].Text = "Valorization<br />" + EBudgetVersion.InProgress.ToString();
                        headerItem["NewHours"].Text = "Hours<br />" + EBudgetVersion.InProgress.ToString();
                    }
                    break;
                case "C":
                    if (previewVersion > 0)
                    {
                        headerItem["NewVal"].Text = "<br />" + EBudgetVersion.Released.ToString();
                        headerItem["NewHours"].Text = "<br />" + EBudgetVersion.Released.ToString();
                    }
                    else
                    {
                        headerItem["NewVal"].Text = "Valorization<br />" + EBudgetVersion.Released.ToString();
                        headerItem["NewHours"].Text = "Hours<br />" + EBudgetVersion.Released.ToString();
                    }
                    break;
                case "P":
                    if (previewVersion > 0)
                    {
                        headerItem["NewVal"].Text = "<br />" + EBudgetVersion.Previous.ToString();
                        headerItem["NewHours"].Text = "<br />" + EBudgetVersion.Previous.ToString();
                    }
                    else
                    {
                        headerItem["NewVal"].Text = "Valorization<br />" + EBudgetVersion.Previous.ToString();
                        headerItem["NewHours"].Text = "Hours<br />" + EBudgetVersion.Previous.ToString();
                    }
                    break;
            }
            if (previewVersion > 0)
            {
                headerItem["CurrentVal"].Text = "<br />" + "Version " + previewVersion.ToString();
                headerItem["CurrentHours"].Text = "<br />" + "Version " + previewVersion.ToString();

            }
            else
            {
                headerItem["CurrentVal"].Text = "&nbsp";
                headerItem["CurrentHours"].Text = "&nbsp";
                headerItem["UpdateHours"].Text = "&nbsp";
                headerItem["UpdateVal"].Text = "&nbsp";
            }
        }
        else if (gridItem.OwnerTableView == grdCostsSales.MasterTableView)
        {
            GridHeaderItem headerItem = gridItem as GridHeaderItem;
            switch (BudgetVersion)
            {
                case "N":
                    if (previewVersion > 0)
                    {
                        headerItem["NewSales"].Text = "<br />" + EBudgetVersion.InProgress.ToString();
                        headerItem["NewCost"].Text = "<br />" + EBudgetVersion.InProgress.ToString();
                    }
                    else
                    {
                        headerItem["NewSales"].Text = "Sales<br />" + EBudgetVersion.InProgress.ToString();
                        headerItem["NewCost"].Text = "Costs<br />" + EBudgetVersion.InProgress.ToString();
                    }
                    break;
                case "C":
                    if (previewVersion > 0)
                    {
                        headerItem["NewSales"].Text = "<br />" + EBudgetVersion.Released.ToString();
                        headerItem["NewCost"].Text = "<br />" + EBudgetVersion.Released.ToString();
                    }
                    else
                    {
                        headerItem["NewSales"].Text = "Sales<br />" + EBudgetVersion.Released.ToString();
                        headerItem["NewCost"].Text = "Costs<br />" + EBudgetVersion.Released.ToString();
                    }
                    break;
                case "P":
                    if (previewVersion > 0)
                    {
                        headerItem["NewSales"].Text = "<br />" + EBudgetVersion.Previous.ToString();
                        headerItem["NewCost"].Text = "<br />" + EBudgetVersion.Previous.ToString();
                    }
                    else
                    {
                        headerItem["NewSales"].Text = "Sales<br />" + EBudgetVersion.Previous.ToString();
                        headerItem["NewCost"].Text = "Costs<br />" + EBudgetVersion.Previous.ToString();
                    }
                    break;
            }
            if (previewVersion > 0)
            {
                headerItem["CurrentSales"].Text = "<br />" + "Version " + previewVersion.ToString();
                headerItem["CurrentCost"].Text = "<br />" + "Version " + previewVersion.ToString();
            }
            else
            {
                headerItem["CurrentSales"].Text = "&nbsp";
                headerItem["CurrentCost"].Text = "&nbsp";
                headerItem["UpdateCost"].Text = "&nbsp";
                headerItem["UpdateSales"].Text = "&nbsp";
            }
        }
    }
    private void UpdateOtherCosts()
    {
        StoreEditedCostCenters(grdCostsSales, (RevisedBudget)null);
        List<RevisedBudgetOtherCosts> otherCostsList = SessionManager.GetSessionValueNoRedirect(this, SessionStrings.REVISED_OTHER_COSTS_LIST) as List<RevisedBudgetOtherCosts>;
        if (otherCostsList == null)
            return;

        RestoreEditedCostCenters(DsCosts);

        foreach (RevisedBudgetOtherCosts otherCost in otherCostsList)
        {
            foreach (DataRow row in DsCosts.Tables[2].Rows)
            {
                if (((int)row["IdProject"] == otherCost.IdProject)
                    && ((int)row["IdPhase"] == otherCost.IdPhase)
                    && ((int)row["IdWP"] == otherCost.IdWP)
                    && ((int)row["IdCostCenter"] == otherCost.IdCostCenter))
                {
                    //decimal otherCostValue = otherCost.UpdateCosts.TE + otherCost.UpdateCosts.ProtoParts + otherCost.UpdateCosts.ProtoTooling + otherCost.UpdateCosts.Trials + otherCost.UpdateCosts.OtherExpenses;
                    decimal otherCostValue = ((otherCost.UpdateCosts.TE == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.UpdateCosts.TE) +
                            ((otherCost.UpdateCosts.ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.UpdateCosts.ProtoParts) +
                            ((otherCost.UpdateCosts.ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.UpdateCosts.ProtoTooling) +
                            ((otherCost.UpdateCosts.Trials == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.UpdateCosts.Trials) +
                            ((otherCost.UpdateCosts.OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.UpdateCosts.OtherExpenses);
                    row["UpdateCost"] = Rounding.Round(Decimal.Divide(otherCostValue, GetScaleMultiplier()));
                }
            }
        }
        
        grdCostsSales.Rebind();
    }

    /// <summary>
    /// Gets the number that will be used to multiply the amounts with
    /// </summary>
    /// <returns>the multiplier</returns>
    private int GetScaleMultiplier()
    {
        int scaleOption = (int)BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);
        int multiplier = 1;
        for (int i = 1; i <= scaleOption; i++)
            multiplier *= 1000;
        return multiplier;
    }

    /// <summary>
    /// Change the status of the budget to open if it is the case
    /// </summary>
    /// <param name="projectId">the project Id</param>
    /// <param name="associateId">the associate Id</param>
    private void OpenBudgetState(int projectId, int associateId)
    {
        //If a error is thrown is should be from Save method and it is catch in the upper method
        string budgetState = GetCurrentBudgetState();
        if (budgetState == ApplicationConstants.BUDGET_STATE_NONE)
        {
            FollowUpRevisedBudget fIBudget = new FollowUpRevisedBudget(SessionManager.GetConnectionManager(this));
            fIBudget.IdProject = projectId;
            fIBudget.IdAssociate = associateId;
            fIBudget.StateCode = ApplicationConstants.BUDGET_STATE_OPEN;
            fIBudget.BudVersion = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE.ToString();
            fIBudget.SetModified();
            fIBudget.Save();
            SessionManager.SetSessionValue(this, SessionStrings.BUDGET_REVISED_STATE, fIBudget.StateCode);

            EvidenceButton.SubmitVisible = true;
        }
    }

    /// <summary>
    /// Saves into session all cost centers that are in editing mode, so 
    /// they can be restored after reloading the datasource
    /// </summary>
    /// <param name="iBudget">The cost center that will not be stored in session beacuse it will be
    /// saved in the database
    /// </param>
    private void StoreEditedCostCenters(IndGrid sender, RevisedBudget budget)
    {
        List<Budget> editingBudgets = new List<Budget>();

        object connManager = SessionManager.GetConnectionManager(this);

        foreach (GridDataItem item in sender.Items)
        {
            if (item.OwnerTableView.Name == sender.MasterTableView.DetailTables[0].DetailTables[0].Name && item.IsInEditMode)
            {
                Hashtable newValues = new Hashtable();
                item.ExtractValues(newValues);
                RevisedBudget newBudget = new RevisedBudget(connManager);
                BuildBudgetKey(newBudget, item);

                if ((budget != null) && (newBudget.IdProject == budget.IdProject)
                    && (newBudget.IdPhase == budget.IdPhase) && (newBudget.IdWP == budget.IdWP)
                    && (newBudget.IdCostCenter == budget.IdCostCenter))
                    continue;

                newBudget.BuildObjectFromHashTable(newValues);
                editingBudgets.Add(newBudget);
            }
        }

        SessionManager.SetSessionValue(this, REVISED_EDITING_COST_CENTERS_LIST, editingBudgets);
    }

    private void StoreEditedCostCenters(IndGrid sender, List<Budget> budgets)
    {
        List<Budget> editingBudgets = new List<Budget>();

        object connManager = SessionManager.GetConnectionManager(this);

        bool foundBudget;
        foreach (GridDataItem item in sender.Items)
        {
            foundBudget = false;
            if (item.OwnerTableView.Name == sender.MasterTableView.DetailTables[0].DetailTables[0].Name && item.IsInEditMode)
            {
                Hashtable newValues = new Hashtable();
                item.ExtractValues(newValues);
                RevisedBudget newBudget = new RevisedBudget(connManager);
                BuildBudgetKey(newBudget, item);

                foreach (Budget budget in budgets)
                {
                    if ((newBudget.IdProject == budget.IdProject)
                        && (newBudget.IdPhase == budget.IdPhase) && (newBudget.IdWP == budget.IdWP)
                        && (newBudget.IdCostCenter == budget.IdCostCenter))
                    {
                        foundBudget = true;
                        break;
                    }
                }
                if (foundBudget)
                    continue;

                newBudget.BuildObjectFromHashTable(newValues);
                editingBudgets.Add(newBudget);
            }
        }

        SessionManager.SetSessionValue(this, REVISED_EDITING_COST_CENTERS_LIST, editingBudgets);
    }

    /// <summary>
    /// Takes IdProject, IdPhase, IdWP and IdCostCenter from the GridDataItem object and assigns them to the corresponding properties
    /// of newBudget object
    /// </summary>
    /// <param name="newBudget"></param>
    /// <param name="item"></param>
    private void BuildBudgetKey(Budget newBudget, GridDataItem item)
    {
        newBudget.IdProject = int.Parse(item["IdProject"].Text);
        newBudget.IdPhase = int.Parse(item["IdPhase"].Text);
        newBudget.IdWP = int.Parse(item["IdWP"].Text);
        newBudget.IdCostCenter = int.Parse(item["IdCostCenter"].Text);
    }

    /// <summary>
    /// Restores the values from the session for the cost centers that are in editing mode
    /// </summary>
    private void RestoreEditedCostCenters(DataSet ds)
    {
        List<Budget> editingCostCentersList = new List<Budget>();
        //Get the list from the session
        editingCostCentersList = SessionManager.GetSessionValueNoRedirect(this, REVISED_EDITING_COST_CENTERS_LIST) as List<Budget>;
        if (editingCostCentersList == null)
            return;

        //Find the correspondig datarow for each cost center in the list and update the correspondig
        //data row from the data source
        foreach (RevisedBudget currentBudget in editingCostCentersList)
        {
            DataRow row = GetDataRow(ds, currentBudget);
            if (row == null)
                continue;

            if (row.Table.Columns.Contains("UpdateHours"))
            {
                if (currentBudget.UpdateHours != ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS)
                {
                    row["UpdateHours"] = currentBudget.UpdateHours;
                }
                else
                {
                    row["UpdateHours"] = DBNull.Value;
                }
            }
            if (row.Table.Columns.Contains("UpdateSales"))
            {
                if (currentBudget.UpdateSales != ApplicationConstants.DECIMAL_NULL_VALUE)
                {
                    row["UpdateSales"] = currentBudget.UpdateSales;
                }
                else
                {
                    row["UpdateSales"] = DBNull.Value;
                }
            }
            if (row.Table.Columns.Contains("UpdateCost"))
            {
                RevisedBudgetOtherCosts otherCostsKey = new RevisedBudgetOtherCosts(SessionManager.GetConnectionManager(this));
                otherCostsKey.IdProject = currentBudget.IdProject;
                otherCostsKey.IdPhase = currentBudget.IdPhase;
                otherCostsKey.IdWP = currentBudget.IdWP;
                otherCostsKey.IdCostCenter = currentBudget.IdCostCenter;
                RevisedBudgetOtherCosts otherCost = SessionManager.GetRevisedOtherCost(this, otherCostsKey);
                if (otherCost != null)
                {
                    row["UpdateCost"] = GetPositiveDecimalValue(otherCost.UpdateCosts.OtherExpenses) +
                        GetPositiveDecimalValue(otherCost.UpdateCosts.ProtoParts) + GetPositiveDecimalValue(otherCost.UpdateCosts.ProtoTooling)
                        + GetPositiveDecimalValue(otherCost.UpdateCosts.TE) + GetPositiveDecimalValue(otherCost.UpdateCosts.Trials);
                }
            }
        }

        //Delete the values from the session
        SessionManager.RemoveValueFromSession(this, REVISED_EDITING_COST_CENTERS_LIST);
    }

    private decimal GetPositiveDecimalValue(decimal value)
    {
        return value == ApplicationConstants.DECIMAL_NULL_VALUE ? 0 : value;
    }

    /// <summary>
    /// Returns the correspondig row for a initial budget from the datasource
    /// </summary>
    /// <param name="iBudget">The intial budget object</param>
    /// <returns>The corresponding data row</returns>
    private DataRow GetDataRow(DataSet ds, RevisedBudget budget)
    {
        foreach (DataRow row in ds.Tables[2].Rows)
        {
            if (((int)row["IdProject"] == budget.IdProject) && ((int)row["IdPhase"] == budget.IdPhase) &&
                ((int)row["IdWP"] == budget.IdWP) && ((int)row["IdCostCenter"] == budget.IdCostCenter))
                return row;
        }
        return null;
    }

    private void FillExchangeRateCache()
    {
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        //Gets the associate currency
        int idAssociateCurrency = currentUser.IdCurrency;

        //Cycle through each row of the WPs table
        foreach (DataRow row in DsHours.Tables[1].Rows)
        {
            //Get the start and end YearMonth
            YearMonth startYearMonth = new YearMonth(row["StartYearMonth"].ToString());
            YearMonth endYearMonth = new YearMonth(row["EndYearMonth"].ToString());
            int idProject = (int)row["IdProject"];
            int idPhase = (int)row["IdPhase"];
            int idWP = (int)row["IdWP"];
            //Create a new list of currencies that will be used to call FillExchangeRateCache
            List<int> currencies = new List<int>();
            //Cycle through each row of the cost center table
            foreach (DataRow ccRow in DsHours.Tables[2].Rows)
            {
                //If the cost center row has as parent the current wp
                if (((int)ccRow["idPhase"] == idPhase) && ((int)ccRow["IdWP"] == idWP))
                {
                    //Add the currency to the currencies list only if it does not exist
                    int idCurrency = (int)ccRow["IdCurrency"];
                    if (!currencies.Contains(idCurrency))
                        currencies.Add(idCurrency);
                }
            }
            //Call FillExchangeRateCache for each currency in the list
            for (int i = 0; i < currencies.Count; i++)
            {
                CurrencyConverter converter = SessionManager.GetCurrencyConverter(this);
                if (converter == null)
                {
                    converter = new CurrencyConverter(SessionManager.GetConnectionManager(this));
                }
                converter.FillExchangeRateCache(startYearMonth, endYearMonth, idAssociateCurrency, currencies[i]);
                SessionManager.SetSessionValue(this, SessionStrings.CURRENCY_CONVERTER, converter);
            }
        }
    }

    /// <summary>
    /// Hides the controls from the screen
    /// </summary>
    protected override void HideChildControls()
    {
        try
        {
            grdHours.Visible = false;
            grdCostsSales.Visible = false;
            grdValidation.Visible = false;
            cmbAmountScale.Visible = false;
            pnlTotalsHours.Visible = false;
            pnlTotalsCostsSales.Visible = false;
            pnlTotalsSummary.Visible = false;
            lblWarning.Visible = false;
            pnlEvidence.Visible = false;
            tabStripRevisedBudget.Visible = false;
            lblNoWPsAffected.Visible = false;
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }       
    }

    /// <summary>
    ///Handles page postback
    /// </summary>
    private void HandlePagePostback()
    {
        CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER);
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        string issuer = Page.Request.Params.Get("__EVENTTARGET");
        string argument = Page.Request.Params.Get("__EVENTARGUMENT");
        if (issuer.Contains("mnuMain") || issuer.Contains("btnRefresh"))
        {
            DsHours = DsCosts = DsValidation = null;
        }
        else
        {
            DsHours = (DataSet)SessionManager.GetSessionValueNoRedirect(this, HOURS_DATASET);
            DsCosts = (DataSet)SessionManager.GetSessionValueNoRedirect(this, COSTS_DATASET);
            DsValidation = (DataSet)SessionManager.GetSessionValueNoRedirect(this, VALIDATION_DATASET);
        }

        if (issuer.Contains("lnkChange"))
        {
            bool isFromFollowUp = (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS);
            if (isFromFollowUp)
                ResponseRedirect("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_REVISED + "&IdAssociate=" + FollowUpIdAssociate.ToString() + "&BudgetType=1&BudgetVersion=" + BudgetVersion);
            else
                ResponseRedirect("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REVISED);
        }

        if (issuer.Contains("btnDoPostBack") && argument.Contains("CostCenter"))
        {
            StoreEditedCostCentersIndexes(tabStripRevisedBudget.SelectedIndex);
            AddCostCenter(argument);
        }

        if (issuer.Contains("btnDoPostBack") && argument.Contains("OtherCosts"))
            UpdateOtherCosts();
        //if the page is from follow up and not all users or direct
        if (FollowUpIdAssociate != ApplicationConstants.INT_NULL_VALUE)
        {
            string budgetState = GetCurrentBudgetState();
            EvidenceButton.BudgetState = budgetState;
            EvidenceButton.IdAssociate = ((FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS ? currentUser.IdAssociate : FollowUpIdAssociate));
            EvidenceButton.IdProject = currentProject.Id;
            EvidenceButton.BudgetType = _budgetType;
            EvidenceButton.BudgetVersion = BudgetVersion;
            //END FOLLOWUP
        }
    }

    /// <summary>
    /// Iterates through the cost centers and saves the ones that are in edit mode in the session
    /// </summary>
    /// <param name="tabIndex"></param>
    private void StoreEditedCostCentersIndexes(int tabIndex)
    {
        //For the summary tab, do nothing
        if (tabIndex == 2)
            return;
        IndGrid sender = null;
        switch (tabIndex)
        {
            case 0:
                sender = grdHours;
                break;
            case 1:
                sender = grdCostsSales;
                break;
            default:
                throw new IndException("Undefined tab");
        }

        CostCenterKeyCollection costCenterKeys = new CostCenterKeyCollection();
        for (int i = 0; i < sender.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = sender.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                for (int k = 0; k < lastTableView.Items.Count; k++)
                {
                    //Here we are at cost center level in the grid
                    GridDataItem item = lastTableView.Items[k];
                    //Store the items that are in edit mode
                    if (item.IsInEditMode)
                    {
                        CostCenterKey key = new CostCenterKey();
                        key.IdPhase = int.Parse(item["IdPhase"].Text);
                        key.IdWP = int.Parse(item["IdWP"].Text);
                        key.IdCostCenter = int.Parse(item["IdCostCenter"].Text);
                        costCenterKeys.Add(key);
                    }
                }
            }
        }
        if (costCenterKeys.Count > 0)
        {
            SessionManager.SetSessionValue(this, SessionStrings.EDITED_COST_CENTERS, costCenterKeys);
        }
    }

    /// <summary>
    /// Iterates through the cost centers and restores their edit mode property after an add or delete operation is done
    /// </summary>
    /// <param name="tabIndex">the tab index (to know on which grid to operate)</param>
    private void RestoreEditedCostCentersIndexes(int tabIndex)
    {
        CostCenterKeyCollection costCenterKeys = (CostCenterKeyCollection)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.EDITED_COST_CENTERS);
        if (costCenterKeys == null)
            return;
        //For the summary tab, do nothing
        if (tabIndex == 2)
            return;
        IndGrid sender = null;
        switch (tabIndex)
        {
            case 0:
                sender = grdHours;
                break;
            case 1:
                sender = grdCostsSales;
                break;
            default:
                throw new IndException("Undefined tab");
        }

        for (int i = 0; i < sender.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = sender.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                for (int k = 0; k < lastTableView.Items.Count; k++)
                {
                    //Here we are at cost center level in the grid
                    GridDataItem item = lastTableView.Items[k];
                    CostCenterKey key = new CostCenterKey();
                    key.IdPhase = int.Parse(item["IdPhase"].Text);
                    key.IdWP = int.Parse(item["IdWP"].Text);
                    key.IdCostCenter = int.Parse(item["IdCostCenter"].Text);
                    //If the current item is in the list, set it in edit mode
                    if (costCenterKeys.Contains(key))
                    {
                        item.Edit = true;
                    }
                    else
                    {
                        item.Edit = false;
                    }
                }
            }
        }
        sender.Rebind();
        SessionManager.RemoveValueFromSession(this, SessionStrings.EDITED_COST_CENTERS);
    }

    /// <summary>
    /// Displays the numeric values from the given GridTableView with grouping and decimal separators
    /// </summary>
    /// <param name="gridTableView"></param>
    private void SetColumnsFormatString(GridTableView tableView)
    {
        //Get the format string for int and decimal data types
        string decimalDataFormatString = conversionUtils.GetDecimalColumnDataFormatString();
        string intDataFormatString = conversionUtils.GetIntColumnDataFormatString();

        //Iterate through the columns collection
        foreach (GridColumn col in tableView.Columns)
        {
            //Look only on the visible columns
            if ((col.Visible == false) || (col.Display == false))
                continue;
            //If column is of decimal type apply the decimal format string
            if ((col is GridBoundColumn) && (col.DataType == typeof(decimal)))
                ((GridBoundColumn)col).DataFormatString = decimalDataFormatString;
            //If column is of int type apply the int format string
            if ((col is GridBoundColumn) && (col.DataType == typeof(Int32)))
                ((GridBoundColumn)col).DataFormatString = intDataFormatString;
        }
    }

    /// <summary>
    /// Reloads data from the database
    /// </summary>
    private void ReloadData()
    {
        LoadHoursData();
        LoadCostsSalesData();
        BuildValidationData();


        if (cmbAmountScale.Text != AmountScaleOption.Unit.ToString())
        {
            RadComboBoxSelectedIndexChangedEventArgs loadEventArgs = new RadComboBoxSelectedIndexChangedEventArgs();
            loadEventArgs.OldText = AmountScaleOption.Unit.ToString();
            loadEventArgs.Text = cmbAmountScale.Text;
            cmbAmountScale_SelectedIndexChanged(cmbAmountScale, loadEventArgs);
        }
        else
        {
            SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
            SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
            SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);
            //Rebind the grid that issued the request

            grdHours.Rebind();
            grdCostsSales.Rebind();
            grdValidation.Rebind();
        }
        RestoreEditedCostCentersIndexes(tabStripRevisedBudget.SelectedIndex);
    }

    private void ReloadGrids(IndGrid issuer)
    {
        LoadHoursData();
        LoadCostsSalesData();
        BuildValidationData();

        if (cmbAmountScale.Text != AmountScaleOption.Unit.ToString())
        {
            RadComboBoxSelectedIndexChangedEventArgs loadEventArgs = new RadComboBoxSelectedIndexChangedEventArgs();
            loadEventArgs.OldText = AmountScaleOption.Unit.ToString();
            loadEventArgs.Text = cmbAmountScale.Text;
            cmbAmountScale_SelectedIndexChanged(cmbAmountScale, loadEventArgs);
        }
        else
        {
            SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
            SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
            SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);
            issuer.Rebind();
        }

    }

    /// <summary>
    /// Sets the enbled state of the submit button, depending on the given argument
    /// </summary>
    /// <param name="isEnabled">states whether submit button is enabled or disabled</param>
    private void SetUnsafeInEditModeControlsEnabledState(bool isEnabled)
    {
        EvidenceButton.SumbitEnabled = isEnabled;
        cmbAmountScale.Enabled = isEnabled;

        //The save button will be enabled when there is at least 1 cc in edit mode (the opposite of all other controls)
        if (btnSave.Visible)
        {
            btnSave.Enabled = !isEnabled;
            if (btnSave.Enabled)
            {
                btnSave.ImageUrl = "~/Images/button_tab_save.png";
                btnSave.ImageUrlOver = "~/Images/button_tab_save.png";
            }
            else
            {
                btnSave.ImageUrl = "~/Images/button_tab_save_disabled.png";
                btnSave.ImageUrlOver = "~/Images/button_tab_save_disabled.png";
            }
        }
    }
    private void SetContextMenu(int tabIndex)
    {
        switch (tabIndex)
        {
            case 0:
                IndBudgetContextMenu1.DataGridName = "grdHours";
                break;
            case 1:
                IndBudgetContextMenu1.DataGridName = "grdCostsSales";
                break;
            case 2:
                IndBudgetContextMenu1.DataGridName = "grdValidation";
                break;
        }
    }

    /// <summary>
    /// Hides the Add cc, edit cc and delete cc from the inactive wps
    /// </summary>
    private void MakeInactiveWPsReadOnly(IndGrid sender)
    {
        bool isWPActive;
        //Specifies if at least 1 wp of a phase is active
        bool isPhaseActive;

        for (int i = 0; i < sender.MasterTableView.Items.Count; i++)
        {
            isPhaseActive = false;
            GridTableView detailTableView = sender.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                //Check if the current wp is active
                if (bool.TryParse(detailTableView.Items[j]["IsActive"].Text, out isWPActive) == false)
                    throw new IndException("Value of 'IsActive' column must be of boolean type.");

                //If the current wp is active, continue to the next wp
                if (isWPActive)
                {
                    isPhaseActive = true;
                    continue;
                }

                //The code below is executed only if the current wp is inactive

                //Hide edit wp button
                detailTableView.Items[j]["EditColumn"].Controls[0].Visible = false;
                //Hide the add cost center button
                if (detailTableView.Items[j]["AddCostCenter"].Controls[1] is IndImageButton)
                {
                    IndImageButton btnAddCC = detailTableView.Items[j]["AddCostCenter"].Controls[1] as IndImageButton;
                    btnAddCC.Visible = false;
                }

                //For each cc, hide the edit and delete buttons
                GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                for (int k = 0; k < lastTableView.Items.Count; k++)
                {
                    if (lastTableView.Items[k]["DeleteColumn"].Controls[1] is IndImageButton)
                    {
                        IndImageButton btnDeleteCC = lastTableView.Items[k]["DeleteColumn"].Controls[1] as IndImageButton;
                        btnDeleteCC.Visible = false;
                    }
                    if (lastTableView.Items[k]["EditColumn"].Controls[0] is ImageButton)
                    {
                        ImageButton btnEditCC = lastTableView.Items[k]["EditColumn"].Controls[0] as ImageButton;
                        btnEditCC.Visible = false;
                    }
                }
            }
            if (!isPhaseActive)
                sender.MasterTableView.Items[i]["EditColumn"].Controls[0].Visible = false;
        }
    }

    private void DisplayTotals(int tabStripIndex)
    {
        //If the totals is null, it means that there was no need to recalculate them and they will remain the same (the values will not change
        //due to viewstate)
        if (totals == null)
            return;

        switch (tabStripIndex)
        {
            case 0:
                lblCurrentHoursTotals.Text = ApplicationUtils.GetIntValueStringRepresentation(totals.CurrentHours);
                lblUpdateHoursTotals.Text = ApplicationUtils.GetIntValueStringRepresentation(totals.UpdateHours);
                lblNewHoursTotals.Text = ApplicationUtils.GetIntValueStringRepresentation(totals.NewHours);
                if (IsAssociateCurrency)
                {
                    lblCurrentValTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.CurrentVal);
                    lblUpdateValTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.UpdateVal);
                    lblNewValTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.NewVal);
                }
                else
                {
                    lblCurrentValTotals.Text = String.Empty;
                    lblUpdateValTotals.Text = String.Empty;
                    lblNewValTotals.Text = String.Empty;
                }
                break;
            case 1:
                if (IsAssociateCurrency)
                {
                    lblCurrentCostsTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.CurrentCosts);
                    lblUpdateCostsTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.UpdateCosts);
                    lblNewCostsTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.NewCosts);
                    lblCurrentSalesTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.CurrentSales);
                    lblUpdateSalesTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.UpdateSales);
                    lblNewSalesTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.NewSales);
                }
                else
                {
                    lblCurrentCostsTotals.Text = String.Empty;
                    lblUpdateCostsTotals.Text = String.Empty;
                    lblNewCostsTotals.Text = String.Empty;
                    lblCurrentSalesTotals.Text = String.Empty;
                    lblUpdateSalesTotals.Text = String.Empty;
                    lblNewSalesTotals.Text = String.Empty;
                }
                break;
            case 2:
                lblTotalHoursTotals.Text = ApplicationUtils.GetIntValueStringRepresentation(totals.TotalHours);
                if (IsAssociateCurrency)
                {
                    lblAverateTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.Averate);
                    lblValHoursTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.ValHours);
                    lblOtherCostsTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.OtherCosts);
                    lblSalesTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.Sales);
                    lblNetCostsTotals.Text = ApplicationUtils.GetDecimalValueStringRepresentation(totals.NetCosts);
                }
                else
                {
                    lblAverateTotals.Text = String.Empty;
                    lblValHoursTotals.Text = String.Empty;
                    lblOtherCostsTotals.Text = String.Empty;
                    lblSalesTotals.Text = String.Empty;
                    lblNetCostsTotals.Text = String.Empty;
                }
                break;
            default:
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
        }
    }

    /// <summary>
    /// The action that takes place when cancel is pressed on a row which is in edit mode
    /// </summary>
    /// <param name="indGrid"></param>
    /// <param name="removeOtherCostsFromSession"></param>
    /// <param name="canceledRows"></param>
    private void DoCancelStoreAction(IndGrid indGrid, bool removeOtherCostsFromSession, List<Budget> canceledRows)
    {
        if (removeOtherCostsFromSession)
            RemoveRevisedOtherCostsFromSession(canceledRows);

        StoreEditedCostCenters(indGrid, canceledRows);

        //Refresh the costs & sales dataset
        LoadHoursData();
        LoadCostsSalesData();
        BuildValidationData();

        SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
        SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
        SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);
    }

    private void SaveHours(GridCommandEventArgs e)
    {
        ConversionUtils conversionUtils = new ConversionUtils();

        bool oneRowSave = true;
        if (!bool.TryParse(e.CommandSource.ToString(), out oneRowSave))
            oneRowSave = true;
        //Get the item
        GridDataItem item = e.Item as GridDataItem;
        Hashtable newValues = new Hashtable();
        //Extract the values entered by the user
        item.ExtractValues(newValues);
        //If the new value is null, convert it to the empty string to avoid multiple null checks
        if (newValues["UpdateHours"] == null)
        {
            newValues["UpdateHours"] = String.Empty;
        }

        ArrayList errors = new ArrayList();
        int updateHour = 0;
        //Check if the update hour is of integer type
        if (!String.IsNullOrEmpty(newValues["UpdateHours"].ToString()) && int.TryParse(conversionUtils.RemoveThousandsFormat(newValues["UpdateHours"].ToString()), out updateHour) == false)
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_NOT_NUMERIC, "Update Hours"));
        if (String.IsNullOrEmpty(newValues["UpdateHours"].ToString()))
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_CANNOT_BE_EMPTY, "Update Hours"));


        decimal currentHours;
        //The only reason why the parse could fail is because currenthours is null. In this case, we will set its value to 0
        if (decimal.TryParse(item["CurrentHours"].Text, out currentHours) == false)
            currentHours = 0;

        if (updateHour + currentHours < 0)
        {
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_SUM_OF_TWO_FIELDS_NOT_POSITIVE, "Current Hours", "Update Hours"));
        }
        //If there are errors the update shouldn't be done
        if (errors.Count != 0)
        {
            if (!oneRowSave)
            {
                StoreEditedCostCenters(grdHours, (RevisedBudget)null);
            }
            throw new IndException(errors);
        }

        //Get the start and end year month values
        DataRow parentRow = GetCostCenterParentRow(DsHours, int.Parse(item["IdProject"].Text), int.Parse(item["IdPhase"].Text), int.Parse(item["IdWP"].Text));
        YearMonth startYearMonth = new YearMonth(parentRow["StartYearMonth"].ToString());
        YearMonth endYearMonth = new YearMonth(parentRow["EndYearMonth"].ToString());

        object connectionManager = SessionManager.GetConnectionManager(this);
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        int idAssociate = currentUser.IdAssociate;
        //Build a RevisedBudgetHours object
        RevisedBudget revisedBudget = new RevisedBudget(connectionManager);
        //Set necessary members for the update procedure
        revisedBudget.IdProject = int.Parse(item["IdProject"].Text);
        revisedBudget.IdPhase = int.Parse(item["IdPhase"].Text);
        revisedBudget.IdWP = int.Parse(item["IdWP"].Text);
        revisedBudget.IdCostCenter = int.Parse(item["IdCostCenter"].Text);
        revisedBudget.IdAssociate = idAssociate;
        revisedBudget.NewHours = (int)(int.Parse(conversionUtils.RemoveThousandsFormat(newValues["UpdateHours"].ToString())) + currentHours);
        revisedBudget.SaveHours = true;
        revisedBudget.SetModified();

        int associateCurrency = SessionManager.GetCurrentUser(this).IdCurrency;
        CurrencyConverter converter = SessionManager.GetCurrencyConverter(this);
        AmountScaleOption scaleOption = BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);

        StoreEditedCostCenters(grdHours, revisedBudget);



        //Check if the wp period has changed in the meanwhile
        WorkPackage currentWP = new WorkPackage(connectionManager);
        currentWP.IdProject = revisedBudget.IdProject;
        currentWP.IdPhase = revisedBudget.IdPhase;
        currentWP.Id = revisedBudget.IdWP;
        currentWP.StartYearMonth = startYearMonth.Value;
        currentWP.EndYearMonth = endYearMonth.Value;

        currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);

        revisedBudget.SaveBudget(startYearMonth, endYearMonth, null, IsAssociateCurrency, associateCurrency, converter, scaleOption, true);

        OpenBudgetState(int.Parse(item["IdProject"].Text), idAssociate);


        //Refresh the hours dataset
        if (oneRowSave)
        {
            LoadHoursData();
            LoadCostsSalesData();
            BuildValidationData();

            e.Item.Edit = false;

            if (cmbAmountScale.Text != AmountScaleOption.Unit.ToString())
            {
                RadComboBoxSelectedIndexChangedEventArgs loadEventArgs = new RadComboBoxSelectedIndexChangedEventArgs();
                loadEventArgs.OldText = AmountScaleOption.Unit.ToString();
                loadEventArgs.Text = cmbAmountScale.Text;
                cmbAmountScale_SelectedIndexChanged(cmbAmountScale, loadEventArgs);
            }
            else
            {
                SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
                SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
                SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);
                grdHours.Rebind();
            }
        }
    }

    private void SaveCostsSales(GridCommandEventArgs e)
    {
        bool oneRowSave = true;
        if (!bool.TryParse(e.CommandSource.ToString(), out oneRowSave))
            oneRowSave = true;
        //Get the item
        GridDataItem item = e.Item as GridDataItem;
        Hashtable newValues = new Hashtable();
        //Extract the values entered by the user

        item.ExtractValues(newValues);
        //If the new value of cost is null, convert it to the empty string to avoid multiple null checks
        if (newValues["UpdateCost"] == null)
        {
            newValues["UpdateCost"] = String.Empty;
        }
        //If the new value of cost is null, convert it to the empty string to avoid multiple null checks
        if (newValues["UpdateSales"] == null)
        {
            newValues["UpdateSales"] = String.Empty;
        }

        ArrayList errors = new ArrayList();
        decimal updateCost;
        decimal updateSales;
        //Check if the update cost is of decimal type
        if (decimal.TryParse(newValues["UpdateCost"].ToString(), out updateCost) == false)
        {
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_NOT_NUMERIC, "Update Cost"));
        }

        if (!String.IsNullOrEmpty(newValues["UpdateSales"].ToString()) && decimal.TryParse(newValues["UpdateSales"].ToString(), out updateSales) == false)
        {
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_NOT_NUMERIC, "Update Sales"));
        }

        decimal currentCosts;
        //The only reason why the parse could fail is because CurrentCost is null. In this case, we will set its value to 0
        if (decimal.TryParse(item["CurrentCost"].Text, out currentCosts) == false)
            currentCosts = 0;

        decimal currentSales;
        //The only reason why the parse could fail is because CurrentSales is null. In this case, we will set its value to 0
        if (decimal.TryParse(item["CurrentSales"].Text, out currentSales) == false)
            currentSales = ApplicationConstants.DECIMAL_NULL_VALUE;

        if (updateCost + currentCosts < 0)
        {
            errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_SUM_OF_TWO_FIELDS_NOT_POSITIVE, "Current Cost", "Update Cost"));
        }
        //If there are errors the update shouldn't be done
        if (errors.Count != 0)
        {
            if (!oneRowSave)
            {
                StoreEditedCostCenters(grdCostsSales, (RevisedBudget)null);
            }
            throw new IndException(errors);
        }

        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        int idAssociate = currentUser.IdAssociate;

        DoActualSaveOperation(item, idAssociate, currentSales, newValues);

        OpenBudgetState(int.Parse(item["IdProject"].Text), idAssociate);

        if (oneRowSave)
        {
            //Refresh the costs & sales dataset
            LoadHoursData();
            LoadCostsSalesData();
            BuildValidationData();

            //Remove BudgetRevisedOtherCosts object from list of BudgetRevisedOtherCosts objects in session
            RemoveRevisedOtherCostsFromSession(item);

            e.Item.Edit = false;

            if (cmbAmountScale.Text != AmountScaleOption.Unit.ToString())
            {
                RadComboBoxSelectedIndexChangedEventArgs loadEventArgs = new RadComboBoxSelectedIndexChangedEventArgs();
                loadEventArgs.OldText = AmountScaleOption.Unit.ToString();
                loadEventArgs.Text = cmbAmountScale.Text;
                cmbAmountScale_SelectedIndexChanged(cmbAmountScale, loadEventArgs);
            }
            else
            {
                SessionManager.SetSessionValue(this, HOURS_DATASET, DsHours);
                SessionManager.SetSessionValue(this, COSTS_DATASET, DsCosts);
                SessionManager.SetSessionValue(this, VALIDATION_DATASET, DsValidation);
                grdCostsSales.Rebind();
            }
        }
    }

    private void DoCancelAction(IndGrid issuer, GridDataItem dataItem, bool removeOtherCostsFromSession)
    {
        bool setMasterItemOutOfEditMode = true;
        bool setDetailItemOutOfEditMode = true;
        bool needsRebind = false;

        List<Budget> canceledRows = new List<Budget>();
        object connectionManager = SessionManager.GetConnectionManager(this);

        if (dataItem.OwnerTableView.Name == issuer.MasterTableView.Name)
        {
            CancelMasterItem(dataItem, connectionManager, canceledRows);
        }
        if (dataItem.OwnerTableView.Name == issuer.MasterTableView.DetailTables[0].Name)
        {
            CancelDetailItem(dataItem, connectionManager, canceledRows);

            foreach (GridDataItem item in dataItem.OwnerTableView.Items)
            {
                if (item != dataItem && item.IsInEditMode)
                {
                    setMasterItemOutOfEditMode = false;
                    break;
                }
            }
            if (setMasterItemOutOfEditMode)
            {
                dataItem.OwnerTableView.ParentItem.Edit = false;
                needsRebind = true;
            }
        }

        setMasterItemOutOfEditMode = true;
        if (dataItem.OwnerTableView.Name == issuer.MasterTableView.DetailTables[0].DetailTables[0].Name)
        {
            Budget budget = new RevisedBudget(connectionManager);
            BuildBudgetKey(budget, dataItem);
            canceledRows.Add(budget);

            foreach (GridDataItem item in dataItem.OwnerTableView.Items)
            {
                if (item != dataItem && item.IsInEditMode)
                {
                    setDetailItemOutOfEditMode = false;
                    break;
                }
            }
            if (setDetailItemOutOfEditMode)
            {
                dataItem.OwnerTableView.ParentItem.Edit = false;
                needsRebind = true;
            }

            foreach (GridDataItem detailItem in dataItem.OwnerTableView.ParentItem.OwnerTableView.Items)
            {
                if (detailItem.IsInEditMode)
                {
                    setMasterItemOutOfEditMode = false;
                    break;
                }
            }
            if (setMasterItemOutOfEditMode)
            {
                dataItem.OwnerTableView.ParentItem.OwnerTableView.ParentItem.Edit = false;
                needsRebind = true;
            }
        }

        DoCancelStoreAction(issuer, removeOtherCostsFromSession, canceledRows);
        if (needsRebind)
        {
            //For an unknown reason (has to do with the internal mechanisms of radgrid), after rebind, the current item remains in edit mode.
            //Therefore we must set its Edit property to false manually before rebinding
            dataItem.Edit = false;
            issuer.Rebind();
        }
        //If there is no item in edit mode, set the submit button enabled
        if (issuer.EditIndexes.Count > 1)
            SetUnsafeInEditModeControlsEnabledState(false);
        else
            SetUnsafeInEditModeControlsEnabledState(true);
    }

    private void CancelDetailItem(GridDataItem dataItem, object connectionManager, List<Budget> canceledRows)
    {
        GridTableView lastTableView = dataItem.ChildItem.NestedTableViews[0];
        for (int k = 0; k < lastTableView.Items.Count; k++)
        {
            if (lastTableView.Items[k].IsInEditMode)
            {
                lastTableView.Items[k].Edit = false;

                Budget budget = new RevisedBudget(connectionManager);
                BuildBudgetKey(budget, lastTableView.Items[k]);
                canceledRows.Add(budget);
            }
        }
    }

    private void CancelMasterItem(GridDataItem dataItem, object connectionManager, List<Budget> canceledRows)
    {
        GridTableView detailTableView = dataItem.ChildItem.NestedTableViews[0];
        for (int j = 0; j < detailTableView.Items.Count; j++)
        {
            detailTableView.Items[j].Edit = false;
            GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
            for (int k = 0; k < lastTableView.Items.Count; k++)
            {
                if (lastTableView.Items[k].IsInEditMode)
                {
                    lastTableView.Items[k].Edit = false;

                    Budget budget = new RevisedBudget(connectionManager);
                    BuildBudgetKey(budget, lastTableView.Items[k]);
                    canceledRows.Add(budget);
                }
            }
        }
    }

    private void DoUpdateAction(IndGrid issuer, GridCommandEventArgs e, bool saveHours)
    {
        GridDataItem dataItem = (GridDataItem)e.Item;
        bool setMasterItemOutOfEditMode = true;
        bool setDetailItemOutOfEditMode = true;

        if (dataItem.OwnerTableView.Name == issuer.MasterTableView.Name)
        {
            UpdateMasterItem(dataItem, saveHours);
        }
        
        if (dataItem.OwnerTableView.Name == issuer.MasterTableView.DetailTables[0].Name)
        {
            UpdateDetailItem(dataItem, saveHours, setMasterItemOutOfEditMode);
        }

        setMasterItemOutOfEditMode = true;
        if (dataItem.OwnerTableView.Name == issuer.MasterTableView.DetailTables[0].DetailTables[0].Name)
        {
            UpdateDetailDetailItem(dataItem, e, saveHours, setMasterItemOutOfEditMode, setDetailItemOutOfEditMode);
        }
        ReloadGrids(issuer);
        issuer.Rebind();
    }

    private void UpdateDetailDetailItem(GridDataItem dataItem, GridCommandEventArgs e, bool saveHours, bool setMasterItemOutOfEditMode, bool setDetailItemOutOfEditMode)
    {
        if (saveHours)
        {
            SaveHours(e);
        }
        else
        {
            SaveCostsSales(e);
        }

        foreach (GridDataItem item in dataItem.OwnerTableView.Items)
        {
            if (item != dataItem && item.IsInEditMode)
            {
                setDetailItemOutOfEditMode = false;
                break;
            }
        }

        if (setDetailItemOutOfEditMode)
        {
            dataItem.OwnerTableView.ParentItem.Edit = false;
        }

        foreach (GridDataItem detailItem in dataItem.OwnerTableView.ParentItem.OwnerTableView.Items)
        {
            if (detailItem.IsInEditMode)
            {
                setMasterItemOutOfEditMode = false;
                break;
            }
        }
        if (setMasterItemOutOfEditMode)
        {
            dataItem.OwnerTableView.ParentItem.OwnerTableView.ParentItem.Edit = false;
        }
    }

    private void UpdateDetailItem(GridDataItem dataItem, bool saveHours, bool setMasterItemOutOfEditMode)
    {
        GridTableView lastTableView = dataItem.ChildItem.NestedTableViews[0];
        for (int k = 0; k < lastTableView.Items.Count; k++)
        {
            if (lastTableView.Items[k].IsInEditMode)
            {
                CommandEventArgs eventArgs = new CommandEventArgs("Update", null);
                GridCommandEventArgs args = new GridCommandEventArgs(lastTableView.Items[k], false, eventArgs);
                if (saveHours)
                {
                    SaveHours(args);
                }
                else
                {
                    SaveCostsSales(args);
                }
                lastTableView.Items[k].Edit = false;
            }
        }
        dataItem.Edit = false;
        foreach (GridDataItem item in dataItem.OwnerTableView.Items)
        {
            if (item != dataItem && item.IsInEditMode)
            {
                setMasterItemOutOfEditMode = false;
                break;
            }
        }
        if (setMasterItemOutOfEditMode)
        {
            dataItem.OwnerTableView.ParentItem.Edit = false;
        }
    }

    private void UpdateMasterItem(GridDataItem dataItem, bool saveHours)
    {
        GridTableView detailTableView = dataItem.ChildItem.NestedTableViews[0];
        for (int j = 0; j < detailTableView.Items.Count; j++)
        {
            GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
            for (int k = 0; k < lastTableView.Items.Count; k++)
            {
                if (lastTableView.Items[k].IsInEditMode)
                {
                    CommandEventArgs eventArgs = new CommandEventArgs("Update", null);
                    GridCommandEventArgs args = new GridCommandEventArgs(lastTableView.Items[k], false, eventArgs);
                    if (saveHours)
                    {
                        SaveHours(args);
                    }
                    else
                    {
                        SaveCostsSales(args);
                    }
                    lastTableView.Items[k].Edit = false;
                }
            }
            detailTableView.Items[j].Edit = false;
        }
    }
    private void AddJavascriptRestrictKeysScript(TextBox txtEdit, string colName)
    {
        txtEdit.Attributes.Add("onKeyPress", "return RestrictKeys(event,'1234567890-','" + txtEdit.ClientID + "')");
    }

    private void DoActualSaveOperation(GridDataItem item, int idAssociate, decimal currentSales, Hashtable newValues)
    {
        //Get the start and end year month values
        DataRow parentRow = GetCostCenterParentRow(DsCosts, int.Parse(item["IdProject"].Text), int.Parse(item["IdPhase"].Text), int.Parse(item["IdWP"].Text));
        YearMonth startYearMonth = new YearMonth(parentRow["StartYearMonth"].ToString());
        YearMonth endYearMonth = new YearMonth(parentRow["EndYearMonth"].ToString());

        object connectionManager = SessionManager.GetConnectionManager(this);

        //Build a RevisedBudgetHours object
        RevisedBudget revisedBudget = new RevisedBudget(connectionManager);
        //Set necessary members for the update procedure
        revisedBudget.IdProject = int.Parse(item["IdProject"].Text);
        revisedBudget.IdPhase = int.Parse(item["IdPhase"].Text);
        revisedBudget.IdWP = int.Parse(item["IdWP"].Text);
        revisedBudget.IdCostCenter = int.Parse(item["IdCostCenter"].Text);
        revisedBudget.IdAssociate = idAssociate;
        if (currentSales == ApplicationConstants.DECIMAL_NULL_VALUE && String.IsNullOrEmpty(newValues["UpdateSales"].ToString()))
            revisedBudget.NewSales = ApplicationConstants.DECIMAL_NULL_VALUE;
        else
            revisedBudget.NewSales = ((currentSales == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : currentSales)
                + decimal.Parse(String.IsNullOrEmpty(newValues["UpdateSales"].ToString()) ? "0" : newValues["UpdateSales"].ToString());
        revisedBudget.SaveHours = false;
        revisedBudget.SetModified();

        StoreEditedCostCenters(grdCostsSales, revisedBudget);


        //Check if the wp period has changed in the meanwhile
        WorkPackage currentWP = new WorkPackage(connectionManager);
        currentWP.IdProject = revisedBudget.IdProject;
        currentWP.IdPhase = revisedBudget.IdPhase;
        currentWP.Id = revisedBudget.IdWP;
        currentWP.StartYearMonth = startYearMonth.Value;
        currentWP.EndYearMonth = endYearMonth.Value;

        currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);

        RevisedBudgetOtherCosts otherCostsKey = new RevisedBudgetOtherCosts(connectionManager);
        otherCostsKey.IdProject = revisedBudget.IdProject;
        otherCostsKey.IdPhase = revisedBudget.IdPhase;
        otherCostsKey.IdWP = revisedBudget.IdWP;
        otherCostsKey.IdCostCenter = revisedBudget.IdCostCenter;
        otherCostsKey.IdAssociate = revisedBudget.IdAssociate;

        int associateCurrency = SessionManager.GetCurrentUser(this).IdCurrency;
        CurrencyConverter converter = SessionManager.GetCurrencyConverter(this);
        AmountScaleOption scaleOption = BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);

        RevisedBudgetOtherCosts currentCost = SessionManager.GetRevisedOtherCost(this, otherCostsKey);
        if (currentCost != null)
            currentCost.SetModified();

        revisedBudget.SaveBudget(startYearMonth, endYearMonth, currentCost, IsAssociateCurrency, associateCurrency, converter, scaleOption, true);
    }

	private void PopulateCountriesCombobox()
	{
		InergyCountry country = new InergyCountry(SessionManager.GetConnectionManager(this));
		//Get the countries dataset
		DataSet dsCountries = country.GetAll();

		cmbCountry.DataSource = dsCountries;
		cmbCountry.DataMember = dsCountries.Tables[0].ToString();
		cmbCountry.DataValueField = "Id";
		cmbCountry.DataTextField = "Name";
		cmbCountry.DataBind();
		cmbCountry.Items.Insert(0, new RadComboBoxItem("All", "-1"));
		cmbCountry.SelectedValue = Request.QueryString["IdCountry"];
	}
    #endregion Private Methods

	public override void CSVExport()
	{
		switch (tabStripRevisedBudget.SelectedIndex)
		{
			case 0:
				grdHours.ExportData(ApplicationConstants.BUDGET_TYPE_REVISED, false);
				break;
			case 1:
				grdCostsSales.ExportData(ApplicationConstants.BUDGET_TYPE_REVISED, false);
				break;
			case 2:
				grdValidation.ExportData(ApplicationConstants.BUDGET_TYPE_REVISED, true);
				break;
			default:
				throw new NotImplementedException(ApplicationMessages.EXCEPTION_UNDEFINED_TAB);
		}
		
		
	}
}
