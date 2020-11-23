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
using Telerik.WebControls;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using System.Collections.Generic;
using System.Drawing;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.UI;

public partial class Pages_Budget_ReforecastBudget_ReforecastBudget : IndBasePage
{
    #region Constants
    /// <summary>
    /// The width of the cost center column when the cost center currency column is visible (local currency)
    /// </summary>
    private const int COST_CENTER_WIDTH_CURRENCY = 247;
    /// <summary>
    /// The width of the cost center column when the cost center currency column is not visible (user currency)
    /// </summary>
    private const int COST_CENTER_WIDTH_NO_CURRENCY = 266;
    /// <summary>
    /// Session key for reforecast dataset
    /// </summary>
    private const string REFORECAST_DATASET = "ReforecastDS";
    /// <summary>
    /// Session key for the time when the actual data was last updated
    /// </summary>
    private const string ACTUAL_DATA_TIMESTAMP = "ActualDataTimestamp";
    /// <summary>
    /// Session key for the DeletedReforecastBudgetKey object stored when a cost center is deleted from this budget. When a cost center is deleted,
    /// we restore the values in the grid after postback. In some situations, even if the cost center is deleted from the to completion
    /// budget, it is still displayed in the reforecast grid because it has actual or revised data. In this case, we do not want its values
    /// to be restored since it was deleted. We store its key in session and we do not update during on postback.
    /// </summary>
    private const string DELETED_COST_CENTER_KEY = "DeletedCostCenterKey";
    #endregion Constants

    #region Members
    /// <summary>
    /// Holds the dataset of the reforecast grid
    /// </summary>
    private DataSet DsReforecast = null;
    /// <summary>
    /// Specified whether associate currency is selected for this user (in the user settings) or not
    /// </summary>
    private bool IsAssociateCurrency = true;
    private int followUpIdAssociate = ApplicationConstants.BUDGET_DIRECT_ACCESS;
    public int FollowUpIdAssociate
    {
        get { return ((string.IsNullOrEmpty(this.Request.QueryString["IdAssociate"])) ? ApplicationConstants.BUDGET_DIRECT_ACCESS : Int32.Parse(this.Request.QueryString["IdAssociate"])); }
        set { followUpIdAssociate = value; }
    }

    //property to hold the version of budget from QueryString when page comes from follow up    
    private string _budgetVersion = "N";
    public string BudgetVersion
    {
        get { return (string.IsNullOrEmpty(this.Request.QueryString["BudgetVersion"]) ? _budgetVersion : this.Request.QueryString["BudgetVersion"].ToString()); }
        set { _budgetVersion = value; }
    }
    //hold the codification for Evidence button 1=Revised
    private int _budgetType = 2;

    private ConversionUtils conversionUtils = new ConversionUtils();

    //property marks if grid is readOnly or not
    private bool isGridReadOnly = false;

    private ReforecastBudgetTotals totals;
    #endregion Members

    #region Event Handlers
    /// <summary>
    /// Event handler for the load event of the page
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            LoadComboStateFromQueryString();

            //Empty the session value containing the reforecast dataset, the first time the page loads
            if (!IsPostBack)
            {
                SessionManager.RemoveValueFromSession(this, REFORECAST_DATASET);
                SetUnsafeInEditModeControlsEnabledState(true);
            }

            CurrentUser currentUser = SessionManager.GetCurrentUser(this);
            CurrentProject currentProject = SessionManager.GetCurrentProject(this);
            //Set whether associate currency or cost center currency is used
            if (currentUser.Settings.CurrencyRepresentation != CurrencyRepresentationMode.Associate)
                IsAssociateCurrency = false;

            //Show the correct warning message, depending on whether user currency or local currency is selected
            if (IsAssociateCurrency)
                lblWarning.Text = ApplicationConstants.BUDGET_USER_CURRENCY_WARNING_MESSAGE;
            else
                lblWarning.Text = ApplicationConstants.BUDGET_LOCAL_CURRENCY_WARNING_MESSAGE;

            //TEST TO SEE IF USER ENTER DIRECT OR FROM FOLLOW UP PAGE
            if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
            {
                btnPreselection.OnClientClick = "try { window.location = '" + ResolveUrl("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST) + "'; } catch(e) {}  return false;";
                ((Template)this.Master).SetBackButtonNavigateUrl(ResolveUrl("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST));
                btnPreselection.ToolTip = "Preselection Screen";
            }
            else
            {
                btnPreselection.OnClientClick = "try { window.location = '" + ResolveUrl("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST + "&IdAssociate=" + FollowUpIdAssociate.ToString() + "&BudgetType=2&BudgetVersion=" + BudgetVersion) + "'; } catch(e) {} return false;";
                ((Template)this.Master).SetBackButtonNavigateUrl(ResolveUrl("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST + "&IdAssociate=" + FollowUpIdAssociate.ToString() + "&BudgetType=2&BudgetVersion=" + BudgetVersion));
                btnPreselection.ToolTip = "Follow-up Screen";
            }

            //If the page is loaded for the first time, populate displayed data combobox and disable cmbAmountScale (page loads with hours as
            //data to display and amount scale does not apply to hours)
            if (!IsPostBack)
            {
                PopulateDisplayedDataCombobox();
                PopulateCountriesCombobox();
            }

            cmbAmountScale.Enabled = (int.Parse(cmbDisplayedData.SelectedValue) > ReforecastBudget.DATA_VALUE_HOURS);

            //Get the reforecast dataset from session
            DsReforecast = (DataSet)SessionManager.GetSessionValueNoRedirect(this, REFORECAST_DATASET);

            if (DsReforecast == null)
            {
                LoadData(false, false);

                AmountScaleOption amountScale = BudgetUtils.GetAmountScaleOptionFromText(Request.QueryString["AmountScale"]);
                if (amountScale != AmountScaleOption.Unit)
                {
                    AmountScaleConvert(AmountScaleOption.Unit, amountScale);
                }

                totals = new ReforecastBudgetTotals();
                totals.BuildTotals(DsReforecast.Tables[1]);

                //Set the reforecast data source value in session
                SessionManager.SetSessionValue(this, REFORECAST_DATASET, DsReforecast);
            }
            if (IsPostBack)
            {
                HandlePagePostback();
            }

            SetCurrencyColumnVisible();
            SetAddDeleteColumnsVisible();
            SetCostCenterColumnWidth();
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
        if (String.IsNullOrEmpty(Request.QueryString["DisplayedData"]))
            throw new IndException("Could not get displayed data type from querystring");
        if (String.IsNullOrEmpty(Request.QueryString["AmountScale"]))
            throw new IndException("Could not get amount scale from querystring");

        cmbDisplayedData.SelectedValue = Request.QueryString["DisplayedData"];
        cmbAmountScale.SelectedValue = Request.QueryString["AmountScale"];
		cmbShowCCsWithSignificantValues.SelectedValue = Request.QueryString["ShowCCsWithValues"];
    }

    /// <summary>
    /// Event handler for the itemcreated event of the grid
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void grdReforecast_ItemCreated(object sender, GridItemEventArgs e)
    {
        try
        {
            if (e.Item.OwnerTableView.Name != grd.MasterTableView.Name)
            {
                GridDataItem item = e.Item as GridDataItem;
                
                if ((e.Item.IsInEditMode) && (item["New"] != null))
                {
                    SetDetailItemCellEvents(item);
                }
            }
            else
            {
                GridDataItem item = e.Item as GridDataItem;

                if ((e.Item.IsInEditMode) && (item["Progress"] != null) && (item["Progress"].Controls.Count == 1))
                {
                    TextBox txtProgress = item["Progress"].Controls[0] as TextBox;
                    if (txtProgress != null)
                    {
                        txtProgress.Attributes.Add("onKeyPress", "return TxtKeyPress('1234567890', '" + txtProgress.ClientID + "');");

                        txtProgress.Attributes.Add("onchange", "txtChg(); return RestrictRangeValues(this,0,100);");
                    }
                }
                if (item != null)
                {
                    IndImageButton btnAddCostCenter = item["AddCostCenter"].Controls[1] as IndImageButton;
                    if (btnAddCostCenter != null)
                    {
                        btnAddCostCenter.OnClientClick = "needToConfirm=false; if (ShowPopUpWithoutPostBack('../../../UserControls/Budget/CostCenterFilter/CostCenterFilter.aspx',0,400, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')){" + this.ClientScript.GetPostBackEventReference(btnDoPostBack, btnAddCostCenter.ClientID) + "};return false;";
                    }
                }
            }

            //Set styles of edit textboxes in the current record in the grid
            SetEditItemsStyle(e);

            //Add the top-left header text in the grid (the text which shows whether associate or cost center currency is used and what budget is 
            //shown)
            CreateHeaderText(e.Item);
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
    /// Event handler for the NeedDataSource event of the grid
    /// </summary>
    /// <param name="source"></param>
    /// <param name="e"></param>
    protected void grdReforecast_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        try
        {
            //In case an exception was caught when loding data, the dataset will be null
            if (DsReforecast == null)
                return;

            grd.MasterTableView.DataSource = DsReforecast.Tables[0];
            grd.MasterTableView.DetailTables[0].DataSource = DsReforecast.Tables[1];
            grd.MasterTableView.DetailTables[0].DetailTables[0].DataSource = DsReforecast.Tables[2];

            //Set the format strings for the detail tables
            SetColumnsFormatString(grd.MasterTableView);
            SetColumnsFormatString(grd.MasterTableView.DetailTables[0]);
            SetColumnsFormatString(grd.MasterTableView.DetailTables[0].DetailTables[0]);
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

    /// <summary>
    /// Event handler for the PreRender event of the page
    /// </summary>
    /// <param name="e"></param>
    protected override void OnPreRender(EventArgs e)
    {
        
        try
        {
            DisplayTotals();

            bool isGridEditable = IsGridEditable(cmbDisplayedData.SelectedValue);
            bool isFromFollowUp = (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS);

            //Save button should be visible if the grid is editable and if the budget is not viewed from follow-up
            btnSave.Visible = isGridEditable && !isFromFollowUp;

            //Add ajax to the page
            AddAjaxSettings();

            
            SetGridEditRows(isGridEditable);
           
            
            if (btnSave.Visible)
            {
                btnSave.OnClientClick = btnSave.OnClientClick + ";document.getElementById('IsDirty').value='';";
            }
            
            //FOLLOWUP           
            //set visibility for buttons and grid readonly
            SetButtonsVisibility();


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
                    budgetState == ApplicationConstants.BUDGET_STATE_VALIDATED )
                {
                    isSubmitted = true;
                }
            }

            foreach (GridItem gridItem in grd.Items)
            {
                GridDataItem item = gridItem as GridDataItem;
				bool isPhaseItem = (gridItem.ItemIndexHierarchical.IndexOf(":") == -1);
                if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].DetailTables[0].Name)
                {
                    if (!item.IsInEditMode && isGridEditable)
                    {
                        if (item.OwnerTableView.ParentItem["New"].Controls.Count > 0)
                        {
                            Label txt = new Label();
                            txt.Width = Unit.Percentage(100);
                           // txt.Height = Unit.Pixel(0);
                            txt.ID = item.OwnerTableView.ParentItem["New"].Controls[0].ID + "_AD";
                            txt.Text = ((GridTableCell)item["New"]).Text;
                            ((GridTableCell)item["New"]).Controls.Add(txt);
                        }


                    }
                }
                if (isSubmitted)
                {
                    foreach (TableCell cell in gridItem.Cells)
                    {
						cell.BackColor = isPhaseItem ? colorSubmittedForPhase : colorSubmitted;
                    }
                }
                if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].Name)
                {
                    if (item["New"].Controls.Count > 0 && item["New"].Controls[0] is TextBox)
                    {
                        ((TextBox)item["New"].Controls[0]).Enabled = item.Expanded;
                    }
                }
                if (isSubmitted)
                {
                    grd.MasterTableView.BackColor = colorSubmitted;
                }
            }

            base.OnPreRender(e);

            SetExpandImageStyle();

            MarkActualDataCells();
            MakeInactiveWPsReadOnly(isGridEditable);

            if (isGridReadOnly)
            {
                MakeGridReadOnly();
            }
            //If the grid is not read-only, make the previous months with respect to the current month not editable
            //(disable the textboxes in the new column)
            else
            {
                DisablePreviousMonths();
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

    /// <summary>
    /// Event handler for the SelectedIndexChanged event of amount scale combobox
    /// </summary>
    /// <param name="o"></param>
    /// <param name="e"></param>
    protected void cmbAmountScale_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            AmountScaleOption oldAmountScale = BudgetUtils.GetAmountScaleOptionFromText(e.OldText);
            AmountScaleOption newAmountScale = BudgetUtils.GetAmountScaleOptionFromText(e.Text);
            if (newAmountScale < oldAmountScale)
            {
                LoadData(false, false);
                oldAmountScale = AmountScaleOption.Unit;
            }
            AmountScaleConvert(oldAmountScale, newAmountScale);

            //Set the reforecast data source value in session
            SessionManager.SetSessionValue(this, REFORECAST_DATASET, DsReforecast);

            totals = new ReforecastBudgetTotals();
            totals.BuildTotals(DsReforecast.Tables[1]);
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

    /// <summary>
    /// Event handler for the SelectedIndexChanged event of cmbDisplayedData
    /// </summary>
    /// <param name="o"></param>
    /// <param name="e"></param>
    protected void cmbDisplayedData_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        
        try
        {
            int selectedValue;
            if (int.TryParse(cmbDisplayedData.SelectedValue, out selectedValue) == false)
            {
                this.ShowError(new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE));
                return;
            }
            //The amount scale combobox does not change anything for hours, so it should be disabled
            cmbAmountScale.Enabled = (selectedValue > ReforecastBudget.DATA_VALUE_HOURS);

            LoadData(false, false);

            AmountScaleOption amountScale = BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);
            if (amountScale != AmountScaleOption.Unit)
            {
                AmountScaleConvert(AmountScaleOption.Unit, amountScale);
            }

            grd.Rebind();
            
            //Set the reforecast data source value in session
            SessionManager.SetSessionValue(this, REFORECAST_DATASET, DsReforecast);
            
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

	/// <summary>
	/// Event handler for the SelectedIndexChanged event of cmbShowCCsWithSignificantValues
	/// </summary>
	/// <param name="sender"></param>
	/// <param name="e"></param>
	protected void cmbShowCCsWithSignificantValues_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
	{
		try
		{
			LoadData(false, false);

			AmountScaleOption amountScale = BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);
			if (amountScale != AmountScaleOption.Unit)
			{
				AmountScaleConvert(AmountScaleOption.Unit, amountScale);
			}

			grd.Rebind();

			//Set the reforecast data source value in session
			SessionManager.SetSessionValue(this, REFORECAST_DATASET, DsReforecast);

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

	/// <summary>
	/// Event handler for the SelectedIndexChanged event of cmbCountry
	/// </summary>
	/// <param name="sender"></param>
	/// <param name="e"></param>
	protected void cmbCountry_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
	{
		try
		{
			LoadData(false, false);

			AmountScaleOption amountScale = BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);
			if (amountScale != AmountScaleOption.Unit)
			{
				AmountScaleConvert(AmountScaleOption.Unit, amountScale);
			}

			grd.Rebind();

			//Set the reforecast data source value in session
			SessionManager.SetSessionValue(this, REFORECAST_DATASET, DsReforecast);

			SetUnsafeInEditModeControlsEnabledState(true);

			totals = new ReforecastBudgetTotals();
			totals.BuildTotals(DsReforecast.Tables[1]);
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
	
    /// <summary>
    /// Event handler for the Click event of btnSave
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            SaveBudget();
            CurrentUser currentUser = SessionManager.GetCurrentUser(this);
            CurrentProject currentProject = SessionManager.GetCurrentProject(this);
            if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
            {
                //FOLLOW UP
                OpenBudgetState(currentProject.Id, currentUser.IdAssociate);
            }

            ReloadData(false, false);

            SetUnsafeInEditModeControlsEnabledState(true);

            //Clear dirty after save
            ClientScript.RegisterStartupScript(this.GetType(), "ClearDirty", "ClearDirty();", true);
        }
        catch (IndException indExc)
        {
            //If an error ocurres on save, store the old values in the grid in the session so that they are not lost on postback
            grd.SaveOldValues();
            ShowError(indExc);
            return;
        }
        catch (Exception exc)
        {
            //If an error ocurres on save, store the old values in the grid in the session so that they are not lost on postback
            grd.SaveOldValues();
            ShowError(new IndException(exc));
            return;
        }
    }

    /// <summary>
    /// Event handler for the click event of btnDeleteCostCenter. Deletes a cost center from to completion budget
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDeleteCostCenter_Click(object sender, EventArgs e)
    {
        try
        {
            GridDataItem item = ((Control)sender).Parent.Parent as GridDataItem;

            object connManager = SessionManager.GetConnectionManager(this);
            CurrentUser currentUser = SessionManager.GetCurrentUser(this);

            ReforecastBudget reforecastBudget = new ReforecastBudget(connManager);
            reforecastBudget.IdProject = int.Parse(item["IdProject"].Text);
            reforecastBudget.IdPhase = int.Parse(item["IdPhase"].Text);
            reforecastBudget.IdWP = int.Parse(item["IdWP"].Text);
            reforecastBudget.IdCostCenter = int.Parse(item["IdCostCenter"].Text);
            reforecastBudget.IdAssociate = currentUser.IdAssociate;

            GridDataItem parentItem = item.OwnerTableView.ParentItem;

            int startYearMonth = int.Parse(parentItem["StartYearMonth"].Text);
            int endYearMonth = int.Parse(parentItem["EndYearMonth"].Text);

            //Check if the wp period has changed in the meanwhile
            WorkPackage currentWP = new WorkPackage(connManager);
            currentWP.IdProject = reforecastBudget.IdProject;
            currentWP.IdPhase = reforecastBudget.IdPhase;
            currentWP.Id = reforecastBudget.IdWP;
            currentWP.StartYearMonth = startYearMonth;
            currentWP.EndYearMonth = endYearMonth;

            currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);

            reforecastBudget.DeleteCostCenter();
            OpenBudgetState(int.Parse(item["IdProject"].Text), currentUser.IdAssociate);


            DeletedReforecastBudgetKey key = new DeletedReforecastBudgetKey();
            key.IdProject = reforecastBudget.IdProject;
            key.IdPhase = reforecastBudget.IdPhase;
            key.IdWP = reforecastBudget.IdWP;
            key.IdCostCenter = reforecastBudget.IdCostCenter;

            //Save the deleted budget key into session, so that its old values are not stored after postback
            SessionManager.SetSessionValue(this, DELETED_COST_CENTER_KEY, key);
            
            //Reload the data from the db
            ReloadData(true, false);
            
            //Remove the deleted budget key from session
            SessionManager.RemoveValueFromSession(this, DELETED_COST_CENTER_KEY);

            if (hdnReforecast.Value == "1")
            {
                SetUnsafeInEditModeControlsEnabledState(false);
            }
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
    #endregion Event Handlers

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

    /// <summary>
    /// Hides the controls in the page, when an error ocurrs
    /// </summary>
    protected override void HideChildControls()
    {
        try
        {
            grd.Visible = false;
            cmbAmountScale.Visible = false;
            lblWarning.Visible = false;
            btnSave.Visible = false;
            pnlEvidence.Visible = false;
            lblDisplayedData.Visible = false;
            cmbDisplayedData.Visible = false;
            pnlTotals.Visible = false;
			lblAffectedWPsWarning.Visible = false;
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

	public override void CSVExport()
	{
		grd.ExportData(ApplicationConstants.BUDGET_TYPE_TOCOMPLETION, false);
	}

    #region Private Methods
    /// <summary>
    /// Sets javascript events for cells in the given item
    /// </summary>
    /// <param name="item"></param>
    private void SetDetailItemCellEvents(GridDataItem item)
    {
        int selectedDataType;
        //If the selected value of the displayed data combobox is not an int, show warning message
        if (int.TryParse(cmbDisplayedData.SelectedValue, out selectedDataType) == false)
        {
            this.ShowError(new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE));
            return;
        }

        TextBox txtNew = item["New"].Controls[0] as TextBox;
        if (txtNew == null)
            return;

        if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].Name)
            txtNew.Attributes.Add("onchange", "txtChg();DistributeValues(this,"+selectedDataType+")");

        
        if (selectedDataType != ReforecastBudget.DATA_VALUE_SALES)
        {
            txtNew.Attributes.Add("onKeyPress", "return TxtKeyPress('1234567890', '" + txtNew.ClientID + "');");
        }
        else
        {
            txtNew.Attributes.Add("onKeyPress", "return TxtKeyPress('1234567890-', '" + txtNew.ClientID + "');");
        }

        if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].DetailTables[0].Name)
            txtNew.Attributes.Add("onchange", "txtChg();RecalcSum(this)");
    }
    /// <summary>
    /// get the validated status of the whole budget
    /// </summary>
    /// <returns></returns>
    private bool GetBudgetIsValidState_Completion()
    {
        CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
        FollowUpCompletionBudget followUpCompletionBudget = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
        followUpCompletionBudget.IdProject = currentProject.Id;
        followUpCompletionBudget.BudVersion = BudgetVersion;
        bool isValid = followUpCompletionBudget.GetCompletionBudgetValidState("GetCompletionScalarValidState");
        return isValid;
    }
    /// <summary>
    /// get the state of the budget for the currrent project
    /// </summary>
    /// <returns></returns>
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
        FollowUpCompletionBudget followUpCompletionBudget = new FollowUpCompletionBudget(conMan);
        followUpCompletionBudget.IdProject = currentProject.Id;
        followUpCompletionBudget.BudVersion = BudgetVersion;
        followUpCompletionBudget.IdAssociate = ((FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS ? user.IdAssociate : FollowUpIdAssociate));

        budgetState = followUpCompletionBudget.GetCompletionBudgetStateForEvidence("GetCompletionBudgetStateForEvidence");

        if (string.IsNullOrEmpty(budgetState))
        {
            budgetState = ApplicationConstants.BUDGET_STATE_NONE;
        }
        return budgetState;
    }
    /// <summary>
    /// sets visibility for submit, approve, reject buttons;also sets the grid readonly state
    /// </summary>
    private void SetButtonsVisibility()
    {
        // Get the current project
        CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
        //Get the current logged user
        CurrentUser user = (CurrentUser)SessionManager.GetSessionValueRedirect(this.Page, SessionStrings.CURRENT_USER);
       
        //check to see the budget valid state
        bool isBudgetValid = GetBudgetIsValidState_Completion();
        //if budget is validated set grid and buttons readonly
        if (isBudgetValid)
        {
            SetButtonsAndGridReadOnly();
            return;
        }

        //if page comes from followup for all users
        if (FollowUpIdAssociate == ApplicationConstants.INT_NULL_VALUE)
        {
            SetButtonsAndGridReadOnly();
            return;
        }


        //get the current budget state
        string budgetState = GetCurrentBudgetState();

        //if from follow up
        if(FollowUpIdAssociate!=ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            if (user.ProgramManagerProjects.ContainsKey(currentProject.Id) ||
                (user.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR) ||
                (user.UserRole.Id == ApplicationConstants.ROLE_TECHNICAL_ADMINISTATOR))
            {
                SetVisibleButtonsForPM(budgetState);
            }
            
            EvidenceButton.SubmitVisible = false;
            //if it comes from followup grid set readonly no matter the state
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
    }

    private void SetGridReadOnly()
    {
        isGridReadOnly = true;
        btnSave.Visible = false;
    }

    private void SetButtonsAndGridReadOnly()
    {
        EvidenceButton.SubmitVisible = false;
        EvidenceButton.RejectVisible = false;
        EvidenceButton.ApprovedVisible = false;        
        SetGridReadOnly();
    }
    /// <summary>
    /// Loads data from the database
    /// </summary>
    /// <param name="restoreOldValues">states whether after loading the data from the database, the old values from the grid should be
    /// restored. For example, if the user modifies some values in the grid and, without saving them, adds a cost center to this budget,
    /// after postback the values he has entered will be lost. To avoid this, we restore them so that they are correctly displayed</param>
    private void LoadData(bool restoreOldValues, bool rebind)
    {
        
        ReforecastBudget budget = new ReforecastBudget(SessionManager.GetConnectionManager(this));
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        //Get the timestamp of the latest actual data and store it in session
        DateTime actualDataTimestamp = budget.GetActualDataTimestamp();
        SessionManager.SetSessionValue(this, ACTUAL_DATA_TIMESTAMP, actualDataTimestamp);

        int idAssociate = ApplicationConstants.INT_NULL_VALUE;
        //If FollowUpIdAssociate is ApplicationConstants.BUDGET_DIRECT_ACCESS then the screen does not come from FollowUp&Validation
        if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            idAssociate = currentUser.IdAssociate;
        }
        else
        {
            idAssociate = FollowUpIdAssociate;
            budget.Version = BudgetVersion;
        }

        budget.IdAssociate = idAssociate;
        budget.IdAssociateViewer = currentUser.IdAssociate;

        budget.IsAssociateCurrency = IsAssociateCurrency;
		budget.ShowOnlyCCsWithSighificantValues = (cmbShowCCsWithSignificantValues.SelectedValue == "Filtered");

		int idCountry;
		if (int.TryParse(cmbCountry.SelectedValue, out idCountry) == false)
		{
			throw new IndException(ApplicationMessages.EXCEPTION_BUDGET_COUNTRY_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
		}		
		budget.IdCountry = idCountry;
		
        int reforecastType;
        if (int.TryParse(cmbDisplayedData.SelectedValue, out reforecastType) == false)
        {
            throw new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
        }

        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        budget.IdProject = currentProject.Id;

        DsReforecast = budget.GetData(reforecastType);
        
        DsReforecast.Tables[0].PrimaryKey = new DataColumn[] { DsReforecast.Tables[0].Columns["IdPhase"], DsReforecast.Tables[0].Columns["IdWP"] };
        DsReforecast.Tables[1].PrimaryKey = new DataColumn[] { DsReforecast.Tables[1].Columns["IdPhase"], DsReforecast.Tables[1].Columns["IdWP"], DsReforecast.Tables[1].Columns["IdCostCenter"] };
        DsReforecast.Tables[2].PrimaryKey = new DataColumn[] { DsReforecast.Tables[2].Columns["IdPhase"], DsReforecast.Tables[2].Columns["IdWP"], DsReforecast.Tables[2].Columns["IdCostCenter"], DsReforecast.Tables[2].Columns["YearMonth"] };
        
        if (restoreOldValues)
        {
            SessionManager.SetSessionValue(this, REFORECAST_DATASET, DsReforecast);
            grd.SaveOldValues();
        }
        if (rebind)
            grd.Rebind();

        totals = new ReforecastBudgetTotals();
        totals.BuildTotals(DsReforecast.Tables[1]);
    }
    /// <summary>
    /// Sets the rows the correct rows in edit mode (the rows from new generation that do not contain actual data)
    /// <param name="isGridEditable">specifies if the grid should contain rows that are in edit mode (depending on the type of data selected
    /// in the displayed data combobox)</param>
    /// </summary>
    private void SetGridEditRows(bool isGridEditable)
    {
        foreach (GridDataItem item in grd.Items)
        {
            //If the item is in the 3rd level
            if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].DetailTables[0].Name)
            {
                bool isNewActual;
                if (bool.TryParse(item["IsNewActual"].Text, out isNewActual) && isNewActual)
                {
                    //If the new value is from actual data, then the item is not in edit mode
                    item.Edit = false;
                }
                else
                {
                    //Else the item is in edit mode if the grid is editable
                    item.Edit = isGridEditable;
                }
                continue;
            }
            
            //This code is executed only for the items in the 1st and 2nd level
            item.Edit = isGridEditable;
        }

        //Rebind the grid to set the rows in edit mode
        grd.Rebind();
    }

    /// <summary>
    /// Sets the style of the grid, for the cells that contain actual data
    /// </summary>
    private void MarkActualDataCells()
    {
        foreach (GridDataItem item in grd.Items)
        {
            //If the item is in the 3rd level
            if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].DetailTables[0].Name)
            {
                bool isNewActual;
                bool isPreviousActual;
                bool isCurrentActual;
                if (bool.TryParse(item["IsNewActual"].Text, out isNewActual) && isNewActual)
                {
                    item["New"].BackColor = IndConstants.ColorActual;
                }
                if (bool.TryParse(item["IsPreviousActual"].Text, out isPreviousActual) && isPreviousActual)
                {
                    item["Previous"].BackColor = IndConstants.ColorActual;
                    item["CurrentPreviousDiffString"].BackColor = IndConstants.ColorActual;
                }
                if (bool.TryParse(item["IsCurrentActual"].Text, out isCurrentActual) && isCurrentActual)
                {
                    item["Current"].BackColor = IndConstants.ColorActual;
                    item["NewCurrentDiffString"].BackColor = IndConstants.ColorActual;
                }
            }
        }
    }
    /// <summary>
    /// Adds ajax support to the page
    /// </summary>
    private void AddAjaxSettings()
    {
        RadAjaxManager ajaxManager = GetAjaxManager();
        Panel pnlErrors = (Panel)Master.FindControl("pnlErrors");
        
        ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, pnlMain);
        ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, pnlErrors);
        ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, cmbDisplayedData);
        ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, lblDisplayedData);

        ajaxManager.AjaxSettings.AddAjaxSetting(grd, pnlEvidence);

        if (lblWarning.Visible && btnSave.Visible)
        {
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, lblWarning);
        }
		if (lblAffectedWPsWarning.Visible)
		{
			ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, lblAffectedWPsWarning);
			ajaxManager.AjaxSettings.AddAjaxSetting(grd, lblAffectedWPsWarning);
		}

        ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, pnlErrors);
        ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostBack, grd);

        ajaxManager.AjaxSettings.AddAjaxSetting(grd, grd);

        if (btnSave.Visible)
        {
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, pnlEvidence);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, grd);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, pnlErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, cmbAmountScale);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, btnSave);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, cmbDisplayedData);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, lblDisplayedData);
			ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, cmbShowCCsWithSignificantValues);
			ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, cmbCountry);
            if (pnlTotals.Visible)
                ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, pnlTotals);
        }
    }

    /// <summary>
    /// Handles postbacks to this page
    /// </summary>
    private void HandlePagePostback()
    {
        CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER);
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        string issuer = Page.Request.Params.Get("__EVENTTARGET");
        string argument = Page.Request.Params.Get("__EVENTARGUMENT");
        if (issuer.Contains("mnuMain") || issuer.Contains("btnRefresh") || issuer.Contains("lnkChange"))
        {
            SessionManager.RemoveValueFromSession(this, REFORECAST_DATASET);
        }
        //If the user changes the current project, the page will redirect to Preselection
        if (issuer.Contains("lnkChange"))
        {
            bool isFromFollowUp = (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS);
            if (isFromFollowUp)
                ResponseRedirect("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST + "&IdAssociate=" + FollowUpIdAssociate.ToString() + "&BudgetType=2&BudgetVersion=" + BudgetVersion);
            else
                ResponseRedirect("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST);
        }

        if (issuer.Contains("btnDoPostBack") && argument.Contains("CostCenter"))
        {
            AddCostCenter(argument);
        }
          //if the page is from follow up and not all users or direct
        if (FollowUpIdAssociate != ApplicationConstants.INT_NULL_VALUE)
        {
            string budgetState = GetCurrentBudgetState();

            EvidenceButton.BudgetState = budgetState;
            EvidenceButton.IdAssociate = ((FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS ? currentUser.IdAssociate : FollowUpIdAssociate));
            EvidenceButton.IdProject = currentProject.Id;
            EvidenceButton.BudgetType = _budgetType;
            EvidenceButton.BudgetVersion = BudgetVersion;
        }
    }

    private void AddCostCenter(string issuer)
    {
        bool isWPActive;

        string MassAttribution = (SessionManager.GetSessionValueNoRedirect(this, SessionStrings.ADD_CC_TO_TARGET) == null) ?
                                        ApplicationConstants.ADD_CC_TO_CURRENT_WP :
                                        (string)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.ADD_CC_TO_TARGET);
        bool useMassAttribution = (MassAttribution == ApplicationConstants.ADD_CC_TO_CURRENT_WP ? false : true);

		int updatedRows = 0;
		lblAffectedWPsWarning.Text = String.Empty;
        //Find the detail table where the cost center must be inserted
        for (int i = 0; i < grd.MasterTableView.Items.Count; i++)
        {
            GridDataItem item = grd.MasterTableView.Items[i];

            // Get the current project
            CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
            string ProjectFunctionWPCodeSuffix = currentProject.ProjectFunctionWPCodeSuffix;

            DataRow drCurrentWP = DsReforecast.Tables[0].Rows[i];
            string currentWPCode = drCurrentWP["PhaseWPCode"].ToString();
            string currentWPCodeSuffix = currentWPCode.Substring(currentWPCode.Length - 2, 2);

            //Check if the current wp is active
            if (bool.TryParse(item["IsActive"].Text, out isWPActive) == false)
                throw new IndException("Value of 'IsActive' column must be of boolean type.");
            //Check if WP Code Suffix is not empty
            if (MassAttribution == ApplicationConstants.ADD_CC_TO_MY_WPS && ProjectFunctionWPCodeSuffix == String.Empty)
                throw new IndException("Current project function has no WP Code Suffix defined.");

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

            if(addCC)
            {
                //Get the selected cost center from session
                CostCenterFilter costCenter = SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_COSTCENTER) as CostCenterFilter;
                if (costCenter == null)
                    return;
                int idAssociate = SessionManager.GetCurrentUser(this).IdAssociate;
                object connectionManager = SessionManager.GetConnectionManager(this);
                //Build an RevisedBudgetHours object
                ReforecastBudget reforecastBudget = new ReforecastBudget(connectionManager);
                //Set the necessary fields for insert
                reforecastBudget.IdProject = int.Parse(item["IdProject"].Text);
                reforecastBudget.IdPhase = int.Parse(item["IdPhase"].Text);
                reforecastBudget.IdWP = int.Parse(item["IdWP"].Text);
                reforecastBudget.IdCostCenter = costCenter.IdCostCenter;
                reforecastBudget.IdAssociate = idAssociate;

                int startYearMonth = int.Parse(item["StartYearMonth"].Text);
                int endYearMonth = int.Parse(item["EndYearMonth"].Text);

                try
                {
                    //Check if the wp period has changed in the meanwhile
                    WorkPackage currentWP = new WorkPackage(connectionManager);
                    currentWP.IdProject = reforecastBudget.IdProject;
                    currentWP.IdPhase = reforecastBudget.IdPhase;
                    currentWP.Id = reforecastBudget.IdWP;
                    currentWP.StartYearMonth = startYearMonth;
                    currentWP.EndYearMonth = endYearMonth;

                    currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);

                    //Insert into the database
                    reforecastBudget.AddCostCenter();
                    OpenBudgetState(int.Parse(item["IdProject"].Text), idAssociate);

                    if (!useMassAttribution)
                    {
                        ReloadData(true, true);
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
                {
					if (cmbShowCCsWithSignificantValues.SelectedValue == "Filtered")
					{
						lblAffectedWPsWarning.Text = "The newly added CC is not currently visible. To display it, please select the \"Display all CCs\" option.";
					}					
                    return;
                }
                
                updatedRows++;
            }
        }
		if (MassAttribution == ApplicationConstants.ADD_CC_TO_MY_WPS && updatedRows == 0)
		{
			lblAffectedWPsWarning.Text = "No Work Packages qualify for the criteria \"My WPs\"";
			return;
		}

        if (useMassAttribution)
        {
            ReloadData(true, true);
			if (cmbShowCCsWithSignificantValues.SelectedValue == "Filtered")
			{
				lblAffectedWPsWarning.Text = "The newly added CC is not currently visible. To display it, please select the \"Display all CCs\" option.";
			}
        }
    }


    /// <summary>
    /// Reloads data from the database
    /// </summary>
    /// <param name="restoreOldValues">states whether after loading the data from the database, the old values from the grid should be
    /// restored. For example, if the user modifies some values in the grid and, without saving them, adds a cost center to this budget,
    /// after postback the values he has entered will be lost. To avoid this, we restore them so that they are correctly displayed</param>
    private void ReloadData(bool restoreOldValues, bool rebind)
    {
        LoadData(restoreOldValues, rebind);

        if (cmbAmountScale.Text != AmountScaleOption.Unit.ToString())
        {
            AmountScaleConvert(AmountScaleOption.Unit, BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text));
        }
        SessionManager.SetSessionValue(this, REFORECAST_DATASET, DsReforecast);
    }

    /// <summary>
    /// Applies the Amount scale conversion to the data source of the grid (DsReforecast)
    /// </summary>
    /// <param name="oldAmountScale">the amount scale from which values are converted</param>
    /// <param name="newAmountScale">the amount scale to which values are converted</param>
    private void AmountScaleConvert(AmountScaleOption oldAmountScale, AmountScaleOption newAmountScale)
    {
        ReforecastBudget budget = new ReforecastBudget(SessionManager.GetConnectionManager(this));
        //Apply amount scale conversion for totals and months tables (master table does not contain data that needs to be converted)
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsReforecast.Tables[0]);
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsReforecast.Tables[1]);
        budget.ApplyAmountScaleOptionToDataSource(oldAmountScale, newAmountScale, DsReforecast.Tables[2]);
    }
    /// <summary>
    /// Adds into the top-left header of the grid the type of currency used to view the budget
    /// </summary>
    /// <param name="gridItem"></param>
    private void CreateHeaderText(GridItem gridItem)
    {
        //If the item is not GridHeaderItem or not from the mastertableview, do nothing
        if (!(gridItem is GridHeaderItem) || (gridItem.OwnerTableView != grd.MasterTableView))
            return;
        //Get the current user from the session
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        //Initialize the string that represents the currebcy representaion mode
        string currencyRepresentationString = String.Empty;
        //Depending on the user settings, establish the type of currency used
        if (currentUser.Settings.CurrencyRepresentation != CurrencyRepresentationMode.Associate)
        {
            currencyRepresentationString = "Local";
        }
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
        ReforecastBudget reforecastBug = new ReforecastBudget(SessionManager.GetConnectionManager(this));
        reforecastBug.IdProject = currentProject.Id;
        if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
        {
            reforecastBug.Version = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;
        }
        else
        {
            reforecastBug.Version = BudgetVersion;
        }

        bool bIsFake;
        string versionNo = reforecastBug.GetVersionNumber(out bIsFake);
        //Update the header text
        headerItem["PhaseWPName"].Text = "Currency: " + currencyRepresentationString + "<br />" + "Version Number: " + versionNo + (bIsFake==true?"~":"");


        //Just for Follow-up
        bool isFromFollowUp = (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS);
        if (isFromFollowUp)
        {
            SetHaderForFollowUp(gridItem, versionNo);
        }
    }

    private void SetHaderForFollowUp(GridItem gridItem,  string versionNo)
    {

        GridHeaderItem headerItem = gridItem as GridHeaderItem;
        switch (BudgetVersion)
        {
            case "N":
                headerItem["New"].Text = "<br />" +  EBudgetVersion.InProgress.ToString();
                break;
            case "C":
                headerItem["New"].Text = "<br />" + EBudgetVersion.Released.ToString();
                break;
            case "P":
                headerItem["New"].Text = "<br />" + EBudgetVersion.Previous.ToString();
                break;
        }
        int previewVersion = 0;
        int previewVersionMinus = 0;
        previewVersion = int.Parse(versionNo) - 1;
        previewVersionMinus = previewVersion - 1;
        ArrayList arrColumns = new ArrayList();

        if (previewVersion > 0)
        {
            headerItem["Current"].Text = "<br />" + "Version " + previewVersion.ToString();
        }
        else
        {
            headerItem["Current"].Text = "&nbsp";
            headerItem["NewCurrentDiffString"].Text = "&nbsp";
        }
        if (previewVersionMinus > 0)
        {
            headerItem["Previous"].Text = "<br />" + "Version " + previewVersionMinus.ToString();
        }
        else
        {
            headerItem["Previous"].Text = "&nbsp";
            headerItem["CurrentPreviousDiffString"].Text = "&nbsp";
        }
    }
    

    /// <summary>
    /// Populates the displayed data combobox with values, the first time the page loads
    /// </summary>
    private void PopulateDisplayedDataCombobox()
    {
        //Build a list of ReforecastDataType object containing the data displayed in the displayed data combobox
        List<ReforecastDataType> reforecastTypeList = new List<ReforecastDataType>();
        reforecastTypeList.Add(new ReforecastDataType("Hours", ReforecastBudget.DATA_VALUE_HOURS));
        reforecastTypeList.Add(new ReforecastDataType("Valued Hours (read-only)", ReforecastBudget.DATA_VALUE_VAL_HOURS));
        reforecastTypeList.Add(new ReforecastDataType("On Project Costs (read-only)", ReforecastBudget.DATA_VALUE_OTHER_COSTS));
        reforecastTypeList.Add(new ReforecastDataType(" - T&E", ReforecastBudget.DATA_VALUE_TE));
        reforecastTypeList.Add(new ReforecastDataType(" - Proto parts", ReforecastBudget.DATA_VALUE_PROTO_PARTS));
        reforecastTypeList.Add(new ReforecastDataType(" - Proto tooling", ReforecastBudget.DATA_VALUE_PROTO_TOOLING));
        reforecastTypeList.Add(new ReforecastDataType(" - Trials", ReforecastBudget.DATA_VALUE_TRIALS));
        reforecastTypeList.Add(new ReforecastDataType(" - Other expenses", ReforecastBudget.DATA_VALUE_OTHER_EXPENSES));
        reforecastTypeList.Add(new ReforecastDataType("Sales", ReforecastBudget.DATA_VALUE_SALES));
        reforecastTypeList.Add(new ReforecastDataType("Gross costs (read-only)", ReforecastBudget.DATA_VALUE_GROSS_COSTS));
        reforecastTypeList.Add(new ReforecastDataType("Net costs (read-only)", ReforecastBudget.DATA_VALUE_NET_COSTS));

        //Bind the combobox to the list
        cmbDisplayedData.DataSource = reforecastTypeList;
        cmbDisplayedData.DataTextField = "DataTextField";
        cmbDisplayedData.DataValueField = "DataValueField";
        cmbDisplayedData.DataBind();
    }

    /// <summary>
    /// Given the selected value of the displayed data combobox, returns a value which represents whether the grid is editable or not.
    /// </summary>
    /// <param name="selectedValue"></param>
    /// <returns></returns>
    private bool IsGridEditable(string selectedValue)
    {
        //The first time the page loads, hours will be selected and the grid will be editable
        int selectedDataType;
        //If the selected value of the displayed data combobox is not an int, show warning message
        if (int.TryParse(cmbDisplayedData.SelectedValue, out selectedDataType) == false)
        {
            throw new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
        }
        bool isGridEditable = false;
        //Grid will be readonly, depending on the type of data displayed
        switch (selectedDataType)
        {
            case ReforecastBudget.DATA_VALUE_HOURS:
            case ReforecastBudget.DATA_VALUE_TE:
            case ReforecastBudget.DATA_VALUE_PROTO_PARTS:
            case ReforecastBudget.DATA_VALUE_PROTO_TOOLING:
            case ReforecastBudget.DATA_VALUE_TRIALS:
            case ReforecastBudget.DATA_VALUE_OTHER_EXPENSES:
            case ReforecastBudget.DATA_VALUE_SALES:
                isGridEditable = true;
                break;
            case ReforecastBudget.DATA_VALUE_VAL_HOURS:
            case ReforecastBudget.DATA_VALUE_OTHER_COSTS:
            case ReforecastBudget.DATA_VALUE_GROSS_COSTS:
            case ReforecastBudget.DATA_VALUE_NET_COSTS:
                isGridEditable = false;
                break;
            default:
                throw new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_OPTION_NOT_AVAILABLE);
        }
        return isGridEditable;
    }

    /// <summary>
    /// Saves the to completion budget into the database
    /// </summary>
    private void SaveBudget()
    {
        bool isWPActive;

        object connectionManager = SessionManager.GetConnectionManager(this);

        DateTime actualDataTimestamp = (DateTime)SessionManager.GetSessionValueNoRedirect(this, ACTUAL_DATA_TIMESTAMP);
        List<ReforecastBudget> budgetList = new List<ReforecastBudget>();
        //Search through each detail item
        for (int i = 0; i < grd.MasterTableView.Items.Count; i++)
        {
            //Check if the current wp is active
            if (bool.TryParse(grd.MasterTableView.Items[i]["IsActive"].Text, out isWPActive) == false)
                throw new IndException("Value of 'IsActive' column must be of boolean type.");

            //If the current WP is not active, do not save it and go to the next wp
            if (!isWPActive)
                continue;

            GridTableView detailTableView = grd.MasterTableView.Items[i].ChildItem.NestedTableViews[0];

            decimal progress = ApplicationConstants.DECIMAL_NULL_VALUE;
            Hashtable newValues = new Hashtable();
            grd.MasterTableView.Items[i].ExtractValues(newValues);
            if (newValues["Progress"] != null && decimal.TryParse(newValues["Progress"].ToString(), out progress) == false)
            {
                throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_REFORECAST_MASTER_FIELD_NOT_NUMERIC, "'Progress'", grd.MasterTableView.Items[i]["PhaseWPName"].Text));
            }

            if (detailTableView.Items.Count == 0)
            {
                ReforecastBudget reforecastBudget = BuildBudgetForUpdatingMasterRecord(grd.MasterTableView.Items[i]);
                reforecastBudget.PercentComplete = progress;
                reforecastBudget.UpdateMasterRecord();
                
                continue;
            }
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];

                if (lastTableView.Items.Count == 0)
                {
                    ReforecastBudget reforecastBudget = BuildBudgetForUpdatingMasterRecord(detailTableView.Items[j]);
                    reforecastBudget.PercentComplete = progress;
                    reforecastBudget.UpdateMasterRecord();

                    continue;
                }

                for (int k = 0; k < lastTableView.Items.Count; k++)
                {
                    GridDataItem item = lastTableView.Items[k];
                    //Save only the items that are in edit mode (the items that are from to completion budget)
                    if (item.IsInEditMode)
                    {
                        ReforecastBudget reforecastBudget = BuildBudgetForSave(item);

                        int startYearMonth = int.Parse(grd.MasterTableView.Items[i]["StartYearMonth"].Text);
                        int endYearMonth = int.Parse(grd.MasterTableView.Items[i]["EndYearMonth"].Text);

                        //Check if the wp period has changed in the meanwhile
                        WorkPackage currentWP = new WorkPackage(connectionManager);
                        currentWP.IdProject = reforecastBudget.IdProject;
                        currentWP.IdPhase = reforecastBudget.IdPhase;
                        currentWP.Id = reforecastBudget.IdWP;
                        currentWP.StartYearMonth = startYearMonth;
                        currentWP.EndYearMonth = endYearMonth;

                        currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);


                        reforecastBudget.PercentComplete = progress;
                        reforecastBudget.ActualDataTimestamp = actualDataTimestamp;
                        budgetList.Add(reforecastBudget);
                    }
                }
            }
        }
        //If there is at least one budget to save, save the budgets
        if (budgetList.Count > 0)
        {
            int selectedValue;
            if (int.TryParse(cmbDisplayedData.SelectedValue, out selectedValue) == false)
            {
                throw new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
            }
            AmountScaleOption amountScaleOption = BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);
            if (!IsAssociateCurrency)
            {
                (new ReforecastBudget(SessionManager.GetConnectionManager(this))).SaveAll(budgetList, selectedValue, amountScaleOption);
            }
            else
            {
                int associateCurrency = SessionManager.GetCurrentUser(this).IdCurrency;
                CurrencyConverter converter = SessionManager.GetCurrencyConverter(this);
                (new ReforecastBudget(SessionManager.GetConnectionManager(this))).SaveAll(budgetList, selectedValue, amountScaleOption, associateCurrency, converter);
            }
        }
    }

    private ReforecastBudget BuildBudgetForUpdatingMasterRecord(GridDataItem item)
    {
        object connectionManager = SessionManager.GetConnectionManager(this);
        ReforecastBudget budget = new ReforecastBudget(connectionManager);
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        budget.IdProject = currentProject.Id;
        budget.IdAssociate = currentUser.IdAssociate;
        //Check that all data in the grid is of the correct type
        int idPhase;
        int idWP;

        idPhase = int.Parse(item["IdPhase"].Text);
        idWP = int.Parse(item["IdWP"].Text);

        budget.IdPhase = idPhase;
        budget.IdWP = idWP;

        return budget;
    }

    /// <summary>
    /// Builds a ReforecastBudget object from the given GridDataItem, in order to be saved to the database
    /// </summary>
    /// <param name="item">item containing data about the budget</param>
    /// <returns>ReforecastBudget object with data from item</returns>
	private ReforecastBudget BuildBudgetForSave(GridDataItem item)
    {
        object connectionManager = SessionManager.GetConnectionManager(this);
        ReforecastBudget budget = new ReforecastBudget(connectionManager);
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        budget.IdProject = currentProject.Id;
        budget.IdAssociate = currentUser.IdAssociate;
        //Check that all data in the grid is of the correct type
        int idPhase;

        GridDataItem parentItem = item.OwnerTableView.ParentItem;
        
        if (int.TryParse(item["IdPhase"].Text, out idPhase) == false)
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_REFORECAST_DETAIL_FIELD_NOT_NUMERIC, "IdPhase", "positive", parentItem["CostCenterName"].Text, item["Date"].Text));
        }
        int idWP;
        if (int.TryParse(item["IdWP"].Text, out idWP) == false)
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_REFORECAST_DETAIL_FIELD_NOT_NUMERIC, "IdWP", "positive", parentItem["CostCenterName"].Text, item["Date"].Text));
        }
        int idCostCenter;
        if (int.TryParse(item["IdCostCenter"].Text, out idCostCenter) == false)
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_REFORECAST_DETAIL_FIELD_NOT_NUMERIC, "IdCostCenter", "positive", parentItem["CostCenterName"].Text, item["Date"].Text));
        }
        int yearMonth;
        if (int.TryParse(item["YearMonth"].Text, out yearMonth) == false)
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_REFORECAST_DETAIL_FIELD_NOT_NUMERIC, "YearMonth", "positive", parentItem["CostCenterName"].Text, item["Date"].Text));
        }
        Hashtable newValues = new Hashtable();
        item.ExtractValues(newValues);
        decimal newValue = ApplicationConstants.DECIMAL_NULL_VALUE;

        int selectedDataType = ReforecastBudget.DATA_VALUE_HOURS;
        //If the selected value of the displayed data combobox is not an int, show warning message
        if (int.TryParse(cmbDisplayedData.SelectedValue, out selectedDataType) == false)
        {
            throw new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
        }

        if (newValues["New"] != null)
        {
            if (decimal.TryParse(newValues["New"].ToString(), out newValue) == false)
            {
                if (selectedDataType != ReforecastBudget.DATA_VALUE_SALES)
                {
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_REFORECAST_DETAIL_FIELD_NOT_NUMERIC, "'New' version", "positive", parentItem["CostCenterName"].Text, item["Date"].Text));
                }
                else
                {
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_REFORECAST_DETAIL_FIELD_NOT_NUMERIC, "'New' version", String.Empty, parentItem["CostCenterName"].Text, item["Date"].Text));
                }
            }
            else
            {
                switch (selectedDataType)
                {
                    case ReforecastBudget.DATA_VALUE_HOURS:
                    case ReforecastBudget.DATA_VALUE_OTHER_EXPENSES:
                    case ReforecastBudget.DATA_VALUE_PROTO_TOOLING:
                    case ReforecastBudget.DATA_VALUE_PROTO_PARTS:
                    case ReforecastBudget.DATA_VALUE_TE:
                    case ReforecastBudget.DATA_VALUE_TRIALS:
                        if (newValue < 0)
                            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_REFORECAST_DETAIL_FIELD_NOT_NUMERIC, "'New' version", "positive", parentItem["CostCenterName"].Text, item["Date"].Text));
                        break;
                    case ReforecastBudget.DATA_VALUE_SALES:
                        break;
                    default:
                        throw new IndException("Unsupported type of displayed data for save operation!");
                }
            }
        }


        //Build the budget
        budget.IdPhase = idPhase;
        budget.IdWP = idWP;
        budget.IdCostCenter = idCostCenter;
        budget.IsAssociateCurrency = IsAssociateCurrency;
        budget.YearMonth = yearMonth;
        budget.New = newValue;
        //Set budget state to modified
        budget.SetModified();

        return budget;
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
            FollowUpCompletionBudget fCBudget = new FollowUpCompletionBudget(SessionManager.GetConnectionManager(this));
            fCBudget.IdProject = projectId;
            fCBudget.IdAssociate = associateId;
            fCBudget.StateCode = ApplicationConstants.BUDGET_STATE_OPEN;
            fCBudget.BudVersion = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE.ToString();
            fCBudget.SetModified();
            fCBudget.Save();
            //SessionManager.SetSessionValue(this, SessionStrings.BUDGET_REVISED_STATE, fCBudget.StateCode);

            EvidenceButton.SubmitVisible = true;
        }
    }

    /// <summary>
    /// Displays the numeric values from the given GridTableView with grouping and decimal separators
    /// </summary>
    /// <param name="gridTableView"></param>
    private void SetColumnsFormatString(GridTableView tableView)
    {
        int selectedValue;

        if (int.TryParse(cmbDisplayedData.SelectedValue, out selectedValue) == false)
        {
            throw new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
        }
        
        //The data separator used will depend on whether int or decimal data is displayed
        string dataFormatString = (selectedValue > ReforecastBudget.DATA_VALUE_HOURS) ? conversionUtils.GetDecimalColumnDataFormatString() : conversionUtils.GetIntColumnDataFormatString();

        //Iterate through the columns collection
        foreach (GridColumn col in tableView.Columns)
        {
            //Look only on the visible columns
            if ((col.Visible == false) || (col.Display == false))
                continue;
            //Set the data format string only for columns which are of decimal type (even if int data is displayed, 
            //the data type of the columns is set to decimal)
            if (col is GridBoundColumn && col.DataType == typeof(decimal))
            {
                ((GridBoundColumn)col).DataFormatString = dataFormatString;
            }
        }
    }

    /// <summary>
    /// Sets styles of the edit textboxes in the current record in the grid
    /// </summary>
    /// <param name="e"></param>
    private void SetEditItemsStyle(GridItemEventArgs e)
    {
        //For items that are in edit mode, set the css class to the textboxes that allow the user to enter data
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
                            if (e.Item.OwnerTableView.Name == grd.MasterTableView.Name)
                            {
                                txtEdit.CssClass = CSSStrings.ReforecastBudgetPercentEditTextBoxCssClass;
                            }
                            else
                            {
                                txtEdit.CssClass = CSSStrings.ReforecastBudgetEditTextBoxCssClass;
                            }
                        }
                    }
                }
            }
        }
    }

    
    /// <summary>
    /// Sets the add cost center and delete cost center columns visible or not, depending on whether the grid is readonly or not
    /// </summary>
    private void SetAddDeleteColumnsVisible()
    {
        bool isGridEditable = IsGridEditable(cmbDisplayedData.SelectedValue);

        GridColumn addCostCenterColumn = grd.MasterTableView.GetColumn("AddCostCenter");
        addCostCenterColumn.Visible = isGridEditable;

        GridColumn phaseWpColumn = grd.MasterTableView.GetColumn("PhaseWPName");
        phaseWpColumn.ItemStyle.Width = isGridEditable ? Unit.Pixel(COST_CENTER_WIDTH_CURRENCY) : Unit.Pixel(COST_CENTER_WIDTH_NO_CURRENCY);
        phaseWpColumn.HeaderStyle.Width = isGridEditable ? Unit.Pixel(COST_CENTER_WIDTH_CURRENCY) : Unit.Pixel(COST_CENTER_WIDTH_NO_CURRENCY);

        GridColumn deleteCostCenterColumn = grd.MasterTableView.DetailTables[0].GetColumn("DeleteCostCenter");
        deleteCostCenterColumn.Visible = isGridEditable;
    }

    /// <summary>
    /// Sets the currency column of the cost center visible, depending on the type of currency used to view this budget
    /// </summary>
    private void SetCurrencyColumnVisible()
    {
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        if (currentUser.Settings.CurrencyRepresentation == CurrencyRepresentationMode.CostCenter)
        {
            grd.MasterTableView.DetailTables[0].GetColumn("CurrencyCode").Visible = true;
        }
        else
        {
            grd.MasterTableView.DetailTables[0].GetColumn("CurrencyCode").Visible = false;
        }
    }


    /// <summary>
    /// Sets the width of the cost center name column, depending on whether currency column and delete cc column are visible
    /// </summary>
    private void SetCostCenterColumnWidth()
    {
        bool isCurrencyColumnVisible = grd.MasterTableView.DetailTables[0].GetColumn("CurrencyCode").Visible;
        bool isDeleteCCColumnVisible = grd.MasterTableView.DetailTables[0].GetColumn("DeleteCostCenter").Visible;

        GridColumn costCenterColumn = grd.MasterTableView.DetailTables[0].GetColumn("CostCenterName");

        if (isCurrencyColumnVisible && isDeleteCCColumnVisible)
        {
            costCenterColumn.ItemStyle.Width = Unit.Pixel(238);
            return;
        }
        if (isCurrencyColumnVisible && !isDeleteCCColumnVisible)
        {
            costCenterColumn.ItemStyle.Width = Unit.Pixel(258);
            return;
        }
        if (!isCurrencyColumnVisible && isDeleteCCColumnVisible)
        {
            costCenterColumn.ItemStyle.Width = Unit.Pixel(268);
            return;
        }
        if (!isCurrencyColumnVisible && !isDeleteCCColumnVisible)
        {
            costCenterColumn.ItemStyle.Width = Unit.Pixel(288);
            return;
        }
    }

    /// <summary>
    /// Hides the Add cc, and disables the edit boxes for the cost centers of the inactive wps (only if the grid is editable)
    /// </summary>
    private void MakeInactiveWPsReadOnly(bool isGridEditable)
    {
        if (isGridEditable)
        {
            bool isWPActive;
            for (int i = 0; i < grd.MasterTableView.Items.Count; i++)
            {
                //Check if the current wp is active
                if (bool.TryParse(grd.MasterTableView.Items[i]["IsActive"].Text, out isWPActive) == false)
                    throw new IndException("Value of 'IsActive' column must be of boolean type.");

                //If the current wp is active, continue to the next wp
                if (isWPActive)
                    continue;

                //The code below is executed only if the current wp is inactive

                if (grd.MasterTableView.Items[i]["Progress"].Controls[0] is TextBox)
                {
                    TextBox txtProgress = grd.MasterTableView.Items[i]["Progress"].Controls[0] as TextBox;
                    txtProgress.Enabled = false;
                }

                //Hide the add cost center button
                if (grd.MasterTableView.Items[i]["AddCostCenter"].Controls[1] is IndImageButton)
                {
                    IndImageButton btnAddCC = grd.MasterTableView.Items[i]["AddCostCenter"].Controls[1] as IndImageButton;
                    btnAddCC.Visible = false;
                }

                GridTableView detailTableView = grd.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
                for (int j = 0; j < detailTableView.Items.Count; j++)
                {
                    //Hide the delete cc button
                    if (detailTableView.Items[j]["DeleteCostCenter"].Controls[1] is IndImageButton)
                    {
                        IndImageButton btnDeleteCC = detailTableView.Items[j]["DeleteCostCenter"].Controls[1] as IndImageButton;
                        btnDeleteCC.Visible = false;
                    }

                    //Make the edit textboxes disabled
                    if (detailTableView.Items[j]["New"].Controls[0] is TextBox)
                    {
                        TextBox txtNewTotal = detailTableView.Items[j]["New"].Controls[0] as TextBox;
                        txtNewTotal.Enabled = false;
                    }

                    //For each cc, hide the edit and delete buttons
                    GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                    for (int k = 0; k < lastTableView.Items.Count; k++)
                    {
                        if (lastTableView.Items[k]["New"].Controls[0] is TextBox)
                        {
                            TextBox txtNew = lastTableView.Items[k]["New"].Controls[0] as TextBox;
                            txtNew.Enabled = false;
                        }
                    }
                }
            }
        }
    }
    /// <summary>
    /// Sets the enbled state of the amount scale combobox, submit button and totals button depending on the given argument. These
    /// controls should not be enabled when there is at least one cc in edit mode, as it is not safe
    /// </summary>
    /// <param name="isEnabled">states whether controls are enabled or disabled</param>
    private void SetUnsafeInEditModeControlsEnabledState(bool isEnabled)
    {
        EvidenceButton.SumbitEnabled = isEnabled;
        
        //If we are trying to make the Amount Scale Combobox enabled, special care must be taken because this combobox can never be enabled
        //when hours is selected in displaye data combobox
        if (isEnabled)
        {
            if (IsPostBack)
            {
                int displayedData = int.Parse(cmbDisplayedData.SelectedValue);
                if (displayedData != ReforecastBudget.DATA_VALUE_HOURS)
                {
                    cmbAmountScale.Enabled = isEnabled;
                }
                else
                {
                    //do nothing if we are trying to make the Amount Scale Combobox enabled and hours are being viewed
                }
            }
            else
            {
                //do nothing with cmbAmountScale if the page is loaded for the first time
            }
        }
        else
        {
            cmbAmountScale.Enabled = isEnabled;
        }
        
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

    private void DisplayTotals()
    {
        //If the totals is null, it means that there was no need to recalculate them and they will remain the same (the values will not change
        //due to viewstate)
        if (totals == null)
            return;

        if (IsAssociateCurrency || cmbDisplayedData.SelectedValue == ReforecastBudget.DATA_VALUE_HOURS.ToString())
        {
            lblPreviousTotals.Text = (totals.Previous == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : totals.Previous.ToString();
            lblCurrentPreviousDiffTotals.Text = SetTotalsLabelValueWithSign(totals.CurrentPreviousDiff);
            lblCurrentTotals.Text = (totals.Current == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : totals.Current.ToString();
            lblNewCurrentDiffTotals.Text = SetTotalsLabelValueWithSign(totals.NewCurrentDiff);
            lblNewTotals.Text = (totals.New == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : totals.New.ToString();
            lblNewRevisedDiffTotals.Text = SetTotalsLabelValueWithSign(totals.NewRevisedDiff);
            lblRevisedTotals.Text = (totals.Revised == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : totals.Revised.ToString();
        }
        else
        {
            lblPreviousTotals.Text = String.Empty;
            lblCurrentPreviousDiffTotals.Text = String.Empty;
            lblCurrentTotals.Text = String.Empty;
            lblNewCurrentDiffTotals.Text = String.Empty;
            lblNewTotals.Text = String.Empty;
            lblNewRevisedDiffTotals.Text = String.Empty;
            lblRevisedTotals.Text = String.Empty;
        }
    }

    private string SetTotalsLabelValueWithSign(decimal value)
    {
        if (value == ApplicationConstants.DECIMAL_NULL_VALUE)
            return String.Empty;

        if (value > 0)
            return "+" + value.ToString();

        return value.ToString();
    }

    /// <summary>
    /// Disables the textboxes in the new column for the months which have passed (in the past)
    /// </summary>
    private void DisablePreviousMonths()
    {
        object connectionManager = SessionManager.GetConnectionManager(this);
        int currentYearMonth = (new ReforecastBudget(connectionManager)).GetCurrentYearMonth();

        int startYearMonth = 190001;
        int endYearMonth = 207601;

        foreach (GridDataItem item in grd.Items)
        {
            if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].Name)
            {
                if (item.IsInEditMode)
                {
                    startYearMonth = int.Parse(item.OwnerTableView.ParentItem["StartYearMonth"].Text);
                    endYearMonth = int.Parse(item.OwnerTableView.ParentItem["EndYearMonth"].Text);
                    if (endYearMonth < currentYearMonth)
                        ((TextBox)item["New"].Controls[0]).Enabled = false;
                }
            }
            if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].DetailTables[0].Name)
            {
                if (item.IsInEditMode)
                {
                    int yearMonth = int.Parse(item["YearMonth"].Text);
                    if (yearMonth < currentYearMonth  || yearMonth < startYearMonth || yearMonth > endYearMonth)
                        ((TextBox)item["New"].Controls[0]).Enabled = false;
                    else
                        ((TextBox)item["New"].Controls[0]).Enabled = true;
                }
            }
        }
    }

    private void MakeGridReadOnly()
    {
        foreach (GridItem item in grd.Items)
        {
            if (item is GridEditableItem)
            {
                foreach (TableCell cell in item.Cells)
                    cell.Enabled = false;
                ((GridDataItem)item)["ExpandColumn"].Enabled = true;
            }
            if (item.OwnerTableView.Name == grd.MasterTableView.DetailTables[0].Name)
            {
                (((GridDataItem)item)["CurrencyCode"]).Enabled = true;
            }
        }
    }

    private void SetExpandImageStyle()
    {
        foreach (GridItem item in grd.Items)
        {
            if (((GridDataItem)item)["ExpandColumn"].Controls.Count > 0)
            {
                GridImageButton expandImage = ((GridDataItem)item)["ExpandColumn"].Controls[0] as GridImageButton;
                if (expandImage != null)
                {
                    expandImage.Style.Add(HtmlTextWriterStyle.Cursor, "pointer!important");
                }
            }
        }
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
}

