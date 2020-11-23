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
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Telerik.WebControls;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.DataAccess;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.BusinessLogic.Common;
using System.Collections.Generic;
using Inergy.Indev3.BusinessLogic.Catalogues;
using System.Drawing;
using Inergy.Indev3.WebFramework.WebControls.Budget;

namespace Inergy.Indev3.UI
{
    public partial class Pages_Budget_InitialBudget_InitialBudget : IndBasePage
    {
        #region Constants
        /// <summary>
        /// The width of the cost center column when the cost center currency column is visible (local currency)
        /// </summary>
        private const int COST_CENTER_WIDTH_CURRENCY = 242;
        /// <summary>
        /// The width of the cost center column when the cost center currency column is not visible (user currency)
        /// </summary>
        private const int COST_CENTER_WIDTH_NO_CURRENCY = 264;
        #endregion Constants

        #region Memebers
        private const string EDITING_COST_CENTERS_LIST = "EditingCostCentersList";


        private DataSet dsBudget = null;
        //private bool isLayoutCollapsed = false;

        private bool isAssociateCurrency = true;

        private int followUpIdAssociate = ApplicationConstants.BUDGET_DIRECT_ACCESS;
        public int FollowUpIdAssociate
        {
            get { return ((string.IsNullOrEmpty(this.Request.QueryString["IdAssociate"])) ? ApplicationConstants.BUDGET_DIRECT_ACCESS : Int32.Parse(this.Request.QueryString["IdAssociate"])); }
            set { followUpIdAssociate = value; }
        }
        //property marks if grid is readOnly or not
        private bool isGridReadOnly = false;

        private bool continueLoading = true;

        private ConversionUtils conversionUtils = new ConversionUtils();

        private InitialBudgetTotals totals;
        #endregion Members

        #region Event Handlers
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                LoadComboStateFromQueryString();

                //If the page is loaded for the first time, remove the other costs values from session which might have remained in the session
                //from a previous visit to this budget
                if (!IsPostBack)
                {
                    SessionManager.RemoveValueFromSession(this, SessionStrings.INITIAL_OTHER_COSTS);
                    SessionManager.RemoveValueFromSession(this, SessionStrings.INITIAL_OTHER_COSTS_LIST);
                    //The first time the page loads, set the unsafe in edit mode controls enabled and the save button disabled
                    SetUnsafeInEditModeControlsEnabledState(true);
                    
                    PopulateCountriesCombobox();
                }
                CurrentUser currentUser = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER) as CurrentUser;
                // Get the current project
                CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;

                //Add the ajax settings for this window
                AddAjaxSettings();

                if (currentUser.Settings.CurrencyRepresentation != CurrencyRepresentationMode.Associate)
                    isAssociateCurrency = false;

                //Show the correct warning message, depending on whether user currency or local currency is selected
                if (isAssociateCurrency)
                {
                    lblWarning.Text = ApplicationConstants.BUDGET_USER_CURRENCY_WARNING_MESSAGE;
                }
                else
                {
                    lblWarning.Text = ApplicationConstants.BUDGET_LOCAL_CURRENCY_WARNING_MESSAGE;
                }

                //isLayoutCollapsed = !((SessionManager.GetSessionValueNoRedirect(this, ALL_EXPANDED) == null) ? true : (bool)SessionManager.GetSessionValueNoRedirect(this, ALL_EXPANDED));

                if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
                {
                    btnPreselection.OnClientClick = "try{window.location = '" + ResolveUrl("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_INITIAL) + "';} catch(e) {} return false;";
                    ((Template)this.Master).SetBackButtonNavigateUrl(ResolveUrl("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_INITIAL));
                    btnPreselection.ToolTip = "Preselection Screen";
                }
                else
                {
                    btnPreselection.OnClientClick = "try{window.location = '" + ResolveUrl("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_INITIAL + "&IdAssociate=" + FollowUpIdAssociate.ToString()) + "&BudgetType=0&BudgetVersion=N';} catch(e) {} return false;";
                    ((Template)this.Master).SetBackButtonNavigateUrl(ResolveUrl("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_INITIAL + "&IdAssociate=" + FollowUpIdAssociate.ToString()) + "&BudgetType=0&BudgetVersion=N");
                    btnPreselection.ToolTip = "Follow-up Screen";
                    btnSave.Visible = false;
                }

                if (IsPostBack)
                    HandlePagePostback();
                else
                {
                    //set visibility for buttons and grid readonly
                    SetButtonsVisibility();
                }

                if (dsBudget == null)
                {
                    LoadBudgetDS(false, true);
                }

                AddCurencyColumn();


                //If the default value for the amount scale is diffrent than unit, call selected index changed
                if (!IsPostBack && cmbAmountScale.Text != AmountScaleOption.Unit.ToString())
                {
                    //When the page loads for the first time, remove the edited cost centers from the last visit to the page
                    SessionManager.RemoveValueFromSession(this, SessionStrings.EDITED_COST_CENTERS);
                    RadComboBoxSelectedIndexChangedEventArgs loadEventArgs = new RadComboBoxSelectedIndexChangedEventArgs();
                    loadEventArgs.OldText = AmountScaleOption.Unit.ToString();
                    loadEventArgs.Text = currentUser.Settings.AmountScaleOption.ToString();
                    cmbAmountScale_SelectedIndexChanged(cmbAmountScale, loadEventArgs);
                }
            }
            catch (IndException exc)
            {
                HideChildControls();
                continueLoading = false;
                ShowError(exc);
                return;
            }
            catch (Exception exc)
            {
                HideChildControls();
                continueLoading = false;
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

        /// <summary>
        /// Hides the controls from the screen
        /// </summary>
        protected override void HideChildControls()
        {
            try
            {
                grdInitialBudget.Visible = false;
                cmbAmountScale.Visible = false;
                pnlTotals.Visible = false;
                lblWarning.Visible = false;
                pnlEvidence.Visible = false;
                btnSave.Visible = false;
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

        protected void grdInitialBudget_EditCommand(object source, GridCommandEventArgs e)
        {
            try
            {
                StoreEditedCostCenters((InitialBudget)null);

                SetUnsafeInEditModeControlsEnabledState(false);

                RestoreEditedCostCenters();

                //The grid needs to rebind such that all rows that should now be in edit mode are set in edit mode
                grdInitialBudget.Rebind();
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

        protected void grdInitialBudget_NeedDataSource(object source, Telerik.WebControls.GridNeedDataSourceEventArgs e)
        {
            try
            {
                if (!continueLoading)
                    return;
                if (dsBudget == null)
                    return;
                //Get the master and detail views for the grid
                GridTableView masterTableView = grdInitialBudget.MasterTableView;
                GridTableView firstDetailTableView = grdInitialBudget.MasterTableView.DetailTables[0];
                GridTableView secondDetailTableView = grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0];

                //Gets each table in the Initial Budget screen
                masterTableView.DataSource = dsBudget.Tables[0];
                firstDetailTableView.DataSource = dsBudget.Tables[1];
                secondDetailTableView.DataSource = dsBudget.Tables[2];

                //Set the format strings for each table
                SetColumnsFormatString(masterTableView);
                SetColumnsFormatString(firstDetailTableView);
                SetColumnsFormatString(secondDetailTableView);
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

        protected void grdInitialBudget_UpdateCommand(object source, GridCommandEventArgs e)
        {
            bool operationFailed = false;
            try
            {
                DoUpdateAction(e);
            }
            catch (IndException exc)
            {
                operationFailed = true;                
                e.Canceled = true;
                ShowError(exc); 
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
                if (grdInitialBudget.EditIndexes.Count > 1)
                    SetUnsafeInEditModeControlsEnabledState(false);
                else
                    SetUnsafeInEditModeControlsEnabledState(true);
            }
            try
            {
                if (operationFailed)
                {
                    if (e.Item.OwnerTableView.Name != grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].Name)
                    {
                        StoreEditedCostCenters((InitialBudget)null);
                        LoadBudgetDS(true, true);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError(new IndException(ex));
            }
        }

        protected void grdInitialBudget_CancelCommand(object source, GridCommandEventArgs e)
        {
            try
            {
                DoCancelAction((GridDataItem)e.Item);
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

        protected void cmbAmountScale_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                if (o != null)
                    StoreEditedCostCenters((InitialBudget)null);
                //Gets the oldvalue
                AmountScaleOption oldValue = BudgetUtils.GetAmountScaleOptionFromText(e.OldText);
                AmountScaleOption newValue = BudgetUtils.GetAmountScaleOptionFromText(e.Text);

                InitialBudget iBudget = new InitialBudget(SessionManager.GetConnectionManager(this));


                if (newValue < oldValue)
                {
                    List<InitialBudget> editingCostCentersList = new List<InitialBudget>();
                    //Get the list from the session
                    editingCostCentersList = SessionManager.GetSessionValueNoRedirect(this, EDITING_COST_CENTERS_LIST) as List<InitialBudget>;
                    if (editingCostCentersList != null)
                    {
                        iBudget.ApplyAmountScaleOptionToHT(oldValue, newValue, editingCostCentersList);
                        iBudget.ApplyAmountScaleOptionToHT(newValue, AmountScaleOption.Unit, editingCostCentersList);
                        SessionManager.SetSessionValue(this, EDITING_COST_CENTERS_LIST, editingCostCentersList);
                    }

                    LoadBudgetDS(false, false);

                    oldValue = AmountScaleOption.Unit;

                }

                RestoreEditedCostCenters();
 
                iBudget.ApplyAmountScaleOptionToDataSource(oldValue, newValue, dsBudget.Tables[0]);
                iBudget.ApplyAmountScaleOptionToDataSource(oldValue, newValue, dsBudget.Tables[1]);
                iBudget.ApplyAmountScaleOptionToDataSource(oldValue, newValue, dsBudget.Tables[2]);
                grdInitialBudget.Rebind();

                //Update the InitialBudgetTotals object and store it into session
                totals = new InitialBudgetTotals(dsBudget.Tables[0]);
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
				LoadBudgetDS(false, false);
				grdInitialBudget.Rebind();

				//Update the InitialBudgetTotals object and store it into session
				totals = new InitialBudgetTotals(dsBudget.Tables[0]);

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

        protected void grdInitialBudget_ItemCreated(object sender, GridItemEventArgs e)
        {
            try
            {
                //TODO: Copy code from revised budget from grdHours_ItemCreated
                if (Page.IsPostBack)
                {
                    if ((e.Item is GridEditableItem) && (e.Item is GridDataItem))
                    {
                        GridEditableItem item = e.Item as GridEditableItem;
                        foreach (GridColumn col in item.OwnerTableView.Columns)
                        {
                            if ((item[col] != null) && (item[col].Controls.Count != 0))
                                if (item[col].Controls[0] is TextBox)
                                {
                                    TextBox txtEdit = (TextBox)item[col].Controls[0];
                                    txtEdit.CssClass = CSSStrings.BudgetEditTextBoxCssClass;
                                    AddJavascriptRestrictKeysScript(txtEdit, col.UniqueName);
                                }
                        }
                    }
                }
                if (e.Item is GridEditableItem)
                {
                    GridEditableItem item = e.Item as GridEditableItem;
                    if (item.OwnerTableView.Name == "WPTableView")
                    {
                        IndImageButton btnAddCostCenter = item["colAddCostCenter"].Controls[1] as IndImageButton;
                        btnAddCostCenter.OnClientClick = "if (ShowPopUpWithoutPostBack('../../../UserControls/Budget/CostCenterFilter/CostCenterFilter.aspx',0,400, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')){" + this.ClientScript.GetPostBackEventReference(btnDoPostback, btnAddCostCenter.ClientID) + "};return false;";

                    }
                    if (item.OwnerTableView.Name == "CostCenterTableView")
                    {
                        IndImageButton btnDelete = item["DeleteColumn"].Controls[1] as IndImageButton;
                        btnDelete.OnClientClick = "needToConfirm=false;" + btnDelete.OnClientClick;

                        LinkButton btnOtherCosts = item["OtherCosts"].Controls[1] as LinkButton;
                        if (btnOtherCosts != null)
                            btnOtherCosts.OnClientClick = "needToConfirm=false;" + btnOtherCosts.OnClientClick;


                    }
                }

                //Create the currency representation mode in grid header
                CreateHeaderText(e.Item);
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

        protected void lnkOtherCosts_Click(object sender, EventArgs e)
        {
            try
            {
                GridTableCell owningCell = (GridTableCell)(((LinkButton)sender).Parent);
                GridDataItem item = (GridDataItem)owningCell.Parent;

                int projectId = ApplicationConstants.INT_NULL_VALUE;
                int wpId = ApplicationConstants.INT_NULL_VALUE;
                int phaseId = ApplicationConstants.INT_NULL_VALUE;
                int costCenterId = ApplicationConstants.INT_NULL_VALUE;
                int.TryParse(item.SavedOldValues["IdProject"].ToString(), out projectId);
                int.TryParse(item.SavedOldValues["IdWP"].ToString(), out wpId);
                int.TryParse(item.SavedOldValues["IdPhase"].ToString(), out phaseId);
                int.TryParse(item.SavedOldValues["IdCostCenter"].ToString(), out costCenterId);

                Hashtable newValues = new Hashtable();
                item.ExtractValues(newValues);
                InsertOldValuesInList(newValues, item);
                
                SessionManager.SetSessionValue(this, ApplicationConstants.INITIAL_BUDGET_DATASET, dsBudget);

                InitialBudgetOtherCosts otherCosts = new InitialBudgetOtherCosts(SessionManager.GetConnectionManager(this));
                otherCosts.IdProject = projectId;
                otherCosts.IdPhase = phaseId;
                otherCosts.IdWP = wpId;
                otherCosts.IdCostCenter = costCenterId;
                otherCosts.IdAssociate = SessionManager.GetCurrentUser(this).IdAssociate;
                otherCosts.IdAssociateViewer = SessionManager.GetCurrentUser(this).IdAssociate;
                SessionManager.SetSessionValue(this, SessionStrings.INITIAL_OTHER_COSTS, otherCosts);

                if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "OpenOtherCostsWindow"))
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "OpenOtherCostsWindow",
                        "if (ShowPopUpWithoutPostBack('OtherCosts.aspx?IsAssociateCurrency=" + (isAssociateCurrency ? 1 : 0) + "&AmountScaleOption=" +
                        cmbAmountScale.Text + "',0,350, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')){" + this.ClientScript.GetPostBackEventReference(btnDoPostback, ((Control)sender).ClientID) + "} ", true);
                }
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

        protected void btnDeleteWP_Click(object sender, EventArgs e)
        {
            bool currentItemInEditMode = false;
            try
            {
                GridDataItem item = ((Control)sender).Parent.Parent as GridDataItem;

                object connManager = SessionManager.GetConnectionManager(this);

                int projectId = ApplicationConstants.INT_NULL_VALUE;
                int wpId = ApplicationConstants.INT_NULL_VALUE;
                int phaseId = ApplicationConstants.INT_NULL_VALUE;
                int costCenterId = ApplicationConstants.INT_NULL_VALUE;
                int associateId = SessionManager.GetCurrentUser(this).IdAssociate;

                if (item.IsInEditMode)
                {
                    int.TryParse(item.SavedOldValues["IdProject"].ToString(), out projectId);
                    int.TryParse(item.SavedOldValues["IdWP"].ToString(), out wpId);
                    int.TryParse(item.SavedOldValues["IdPhase"].ToString(), out phaseId);
                    int.TryParse(item.SavedOldValues["IdCostCenter"].ToString(), out costCenterId);

                    currentItemInEditMode = true;
                }
                else
                {
                    int.TryParse(item["IdProject"].Text, out projectId);
                    int.TryParse(item["IdWP"].Text, out wpId);
                    int.TryParse(item["IdPhase"].Text, out phaseId);
                    int.TryParse(item["IdCostCenter"].Text, out costCenterId);
                }

                InitialBudget iBudget = new InitialBudget(connManager);
                iBudget.IdProject = projectId;
                iBudget.IdPhase = phaseId;
                iBudget.IdWP = wpId;
                iBudget.IdCostCenter = costCenterId;
                iBudget.IdAssociate = associateId;
                iBudget.SetDeleted();

                StoreEditedCostCentersIndexes();
                StoreEditedCostCenters(iBudget);

                //When a cost center is deleted, remove its corresponding other costs from session
                InitialBudgetOtherCosts otherCosts = new InitialBudgetOtherCosts(SessionManager.GetConnectionManager(this));
                otherCosts = BuildInitialBudgetOtherCosts(item);
                SessionManager.RemoveInitialBudgetOtherCosts(this, otherCosts);

                //Get the start and end year month values
                DataRow parentRow = GetCostCenterParentRow(projectId, phaseId, wpId);
                YearMonth startYearMonth = new YearMonth(parentRow["StartYearMonth"].ToString());
                YearMonth endYearMonth = new YearMonth(parentRow["EndYearMonth"].ToString());


                //Check if the wp period has changed in the meanwhile
                WorkPackage currentWP = new WorkPackage(connManager);
                currentWP.IdProject = projectId;
                currentWP.IdPhase = phaseId;
                currentWP.Id = wpId;
                currentWP.StartYearMonth = startYearMonth.Value;
                currentWP.EndYearMonth = endYearMonth.Value;

                currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);

                iBudget.UpdateBudget(startYearMonth, endYearMonth, null, false);

                //Set the item out of edit mode (if the item is deleted while in edit mode, some problems appear if the following line is not added)
                item.Edit = false;

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

            try
            {
                LoadBudgetDS(true, true);
                RestoreEditedCostCentersIndexes();

                //If there is no item in edit mode or if the item that was in edit mode was deleted, set the submit button enabled
                if (grdInitialBudget.EditIndexes.Count == 0 || (grdInitialBudget.EditIndexes.Count == 1 && currentItemInEditMode))
                    SetUnsafeInEditModeControlsEnabledState(true);
                else
                    SetUnsafeInEditModeControlsEnabledState(false);
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

        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                DisplayTotals();
                
                if (IsPostBack)
                {
                    string issuer = Page.Request.Params.Get("__EVENTTARGET");
                }
                SetButtonsVisibility();

                MakeInactiveWPsReadOnly();

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

                foreach (GridItem item in grdInitialBudget.Items)
                {
					bool isPhaseItem = (item.ItemIndexHierarchical.IndexOf(":") == -1);
                    if (item is GridEditableItem && isGridReadOnly)
                    {
                        foreach (TableCell cell in item.Cells)
                            cell.Enabled = false;
                        ((GridDataItem)item)["ExpandColumn"].Enabled = true;
                    }
                    if (item.OwnerTableView.Name == grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].Name)
                    {
                        ((IndImageButton)((GridDataItem)item)["DeleteColumn"].Controls[1]).Enabled = !item.IsInEditMode;
                        (((GridDataItem)item)["CurrencyCode"]).Enabled = true;
                    }

                    if (isSubmitted)
                    {
                        foreach (TableCell cell in item.Cells)
                        {
                            cell.BackColor = isPhaseItem ? colorSubmittedForPhase : colorSubmitted;
                        }
						grdInitialBudget.MasterTableView.BackColor = colorSubmitted;
                    }
                }
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

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                //Get all items, no matter on what level
                foreach (GridItem gridItem in grdInitialBudget.Items)
                {
                    //Ignore the items that are not on the last table view
                    if (gridItem.OwnerTableView.Name != "CostCenterTableView")
                        continue;
                    if (!(gridItem is GridDataItem))
                        continue;
                    GridDataItem item = gridItem as GridDataItem;
                    CommandEventArgs eventArgs = new CommandEventArgs("Update", null);
                    GridCommandEventArgs args = new GridCommandEventArgs(gridItem, null, eventArgs);
                    if (item.Edit)
                    {
                        try
                        {
                            DoUpdateAction(args);
                            item.Edit = false;
                        }
                        catch (IndException indExc)
                        {
                            StoreEditedCostCenters((InitialBudget)null);
                            LoadBudgetDS(true, true);
                            this.ShowError(indExc);
                            return;
                        }
                    }
                }
                //If there is no item in edit mode, set the submit button enabled
                if (grdInitialBudget.EditIndexes.Count == 0)
                    SetUnsafeInEditModeControlsEnabledState(true);

                //For some reason, if we do not set the datasource of the grid to null, even when the grid rebinds in LoadBudgetDS method,
                //the values for Averate and Net Cost are refreshed only for the first row that is saved. We must explicitly set
                //the datasource of the grid to null to avoid this
                grdInitialBudget.DataSource = null;
                grdInitialBudget.MasterTableView.DataSource = null;
                grdInitialBudget.MasterTableView.DetailTables[0].DataSource = null;
                grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].DataSource = null;
                
                LoadBudgetDS(true, true);
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
        #endregion Event Handlers

        #region Private Methods
        /// <summary>
        /// Method that handles the postback of the page
        /// </summary>
        private void HandlePagePostback()
        {
            CurrentUser currentUser = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER) as CurrentUser;
            // Get the current project
            CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;

            string issuer = Page.Request.Params.Get("__EVENTTARGET");
            string argument = Page.Request.Params.Get("__EVENTARGUMENT");
            if (issuer.Contains("mnuMain") || issuer.Contains("btnRefresh"))
                dsBudget = null;
            else
                dsBudget = SessionManager.GetSessionValueNoRedirect(this, ApplicationConstants.INITIAL_BUDGET_DATASET) as DataSet;

            if (issuer.Contains("btnDoPostback") && argument.Contains("CostCenter"))
            {
                StoreEditedCostCentersIndexes();
                AddCostCenter(argument);
            }
            if (issuer.Contains("btnDoPostback") && argument.Contains("OtherCosts"))
                UpdateOtherCosts();
            //If the user changes the current project, the page will redirect to Preselection
            if (issuer.Contains("lnkChange"))
            {
                bool isFromFollowUp = (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS);
                if (isFromFollowUp)
                {
                    ResponseRedirect("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + ApplicationConstants.MODULE_INITIAL + "&IdAssociate=" + FollowUpIdAssociate.ToString() + "&BudgetType=0&BudgetVersion=N");
                }
                else
                {
                    ResponseRedirect("~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_INITIAL);
                }
            }

            //Check to see if the Valorization column is changed
            //if the page is from follow up and not all users or direct
            if (FollowUpIdAssociate != ApplicationConstants.INT_NULL_VALUE)
            {
                string budgetState = GetCurrentBudgetState();
                EvidenceButton.BudgetState = budgetState;
                EvidenceButton.IdAssociate = ((FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS ? currentUser.IdAssociate : FollowUpIdAssociate));
                EvidenceButton.IdProject = currentProject.Id;
            }
        }
        /// <summary>
        /// Adds the ajax settings for this window
        /// </summary>
        private void AddAjaxSettings()
        {
            //get the ajax manager from the IndBasePage
            RadAjaxManager ajaxManager = GetAjaxManager();

            //get the errors pannel
            Panel phErrors = (Panel)Master.FindControl("pnlErrors");

            //add ajax settings
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, grdInitialBudget);
			ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, grdInitialBudget);
            ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, phErrors);

            //The grid is ajaxified
            ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, grdInitialBudget);

            //The postback button must refresh all controls that will become invisible when an error ocurrs
            ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostback, cmbAmountScale);
			ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostback, cmbCountry);
            if (pnlTotals.Visible)
            {
                ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostback, pnlTotals);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, pnlTotals);
                ajaxManager.AjaxSettings.AddAjaxSetting(cmbAmountScale, pnlTotals);
				ajaxManager.AjaxSettings.AddAjaxSetting(cmbCountry, pnlTotals);
            }
            if (lblWarning.Visible)
            {
                ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostback, lblWarning);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, lblWarning);
            }
			if (lblNoWPsAffected.Visible)
			{
				ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostback, lblNoWPsAffected);
				ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, lblNoWPsAffected);
			}

            ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostback, pnlEvidence);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostback, grdInitialBudget);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnDoPostback, phErrors);

            //The grid must refresh all controls that will become invisible when an error ocurrs
            ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, cmbAmountScale);
			ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, cmbCountry);
            ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, pnlEvidence);

            if (btnSave.Visible)
            {
                ajaxManager.AjaxSettings.AddAjaxSetting(grdInitialBudget, btnSave);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, grdInitialBudget);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, phErrors);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, cmbAmountScale);
				ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, cmbCountry);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, pnlEvidence);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, btnSave);
            }

            if (pnlTotals.Visible && btnSave.Visible)
            {
                ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, pnlTotals);
            }
        }

        /// <summary>
        /// Saves the Budget corresponding to a grid item
        /// </summary>
        /// <param name="e"></param>
        private bool SaveBudget(GridCommandEventArgs e, bool oneRowSave)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (item == null)
                return false;

            object connManager = SessionManager.GetConnectionManager(this);

            int associateId = SessionManager.GetCurrentUser(this).IdAssociate;


            //Extract the new values in a hashtable
            Hashtable newValues = new Hashtable();
            item.ExtractValues(newValues);
            InsertOldValuesInList(newValues, item);
            //Build the InitialBudget object with the new values
            InitialBudget iBudget = new InitialBudget(connManager, newValues, true, true);

            iBudget.IdAssociate = associateId;
            iBudget.SetModified();

            //Get the start and end year month values
            DataRow parentRow = GetCostCenterParentRow(iBudget.IdProject, iBudget.IdPhase, iBudget.IdWP);
            YearMonth startYearMonth = new YearMonth(parentRow["StartYearMonth"].ToString());
            YearMonth endYearMonth = new YearMonth(parentRow["EndYearMonth"].ToString());

            InitialBudgetOtherCosts otherCostsKey = new InitialBudgetOtherCosts(connManager);
            otherCostsKey.IdProject = iBudget.IdProject;
            otherCostsKey.IdPhase = iBudget.IdPhase;
            otherCostsKey.IdWP = iBudget.IdWP;
            otherCostsKey.IdCostCenter = iBudget.IdCostCenter;
            otherCostsKey.IdAssociate = associateId;

            StoreEditedCostCenters(iBudget);

            //Check if the wp period has changed in the meanwhile
            WorkPackage currentWP = new WorkPackage(connManager);
            currentWP.IdProject = iBudget.IdProject;
            currentWP.IdPhase = iBudget.IdPhase;
            currentWP.Id = iBudget.IdWP;
            currentWP.StartYearMonth = startYearMonth.Value;
            currentWP.EndYearMonth = endYearMonth.Value;

            currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);


            OpenBudgetState(iBudget.IdCostCenter, associateId);

            AmountScaleOption scaleOption = BudgetUtils.GetAmountScaleOptionFromText(cmbAmountScale.Text);

            int associateCurrency = SessionManager.GetCurrentUser(this).IdCurrency;
            CurrencyConverter converter = SessionManager.GetCurrencyConverter(this);

            //Get the other costs object from session
            InitialBudgetOtherCosts currentCost = SessionManager.GetOtherCost(this, otherCostsKey);
            if (currentCost != null)
            {
                currentCost.SetModified();
            }

            iBudget.UpdateBudget(startYearMonth, endYearMonth, currentCost, isAssociateCurrency, associateCurrency, converter, scaleOption, true);

            if (oneRowSave)
                LoadBudgetDS(false, true);

            return true;
        }

        /// <summary>
        /// Load the budget dataset
        /// </summary>
        private void LoadBudgetDS(bool rebind, bool restoreCC)
        {
            //Get the current user from the session
            CurrentUser currentUser = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER) as CurrentUser;

            //Get the connection manager from the session
            ConnectionManager conMan = SessionManager.GetSessionValueRedirect(this, SessionStrings.CONNECTION_MANAGER) as ConnectionManager;

            //Load the data source from the database


            int idAssociate = ApplicationConstants.INT_NULL_VALUE;
            //If FollowUpIdAssociate is ApplicationConstants.BUDGET_DIRECT_ACCESS then the screen does not come from FollowUp&Validation
            if (FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
            {
                idAssociate = currentUser.IdAssociate;
            }
            else
            {
                idAssociate = FollowUpIdAssociate;
            }

			int idCountry;
			if (int.TryParse(cmbCountry.SelectedValue, out idCountry) == false)
			{
				throw new IndException(ApplicationMessages.EXCEPTION_BUDGET_COUNTRY_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE);
			}

            CurrentProject currentProject = SessionManager.GetCurrentProject(this);
            dsBudget = (new InitialBudget(conMan)).GetInitialBudgetDataSource(idAssociate, currentUser.IdAssociate, conMan, isAssociateCurrency, currentProject.Id, idCountry);

            if (!IsPostBack)
            {
                //Fill exchange rate only the first time when the dataset is loaded
                FillExchangeRateCache();
            }

            InitialBudget iBudget = new InitialBudget(conMan);

            //Apply the needed datasource transformation
            iBudget.ApplyDataSourceTransformations(dsBudget, isAssociateCurrency, currentUser, SessionManager.GetCurrencyConverter(this), 0);

            //Restores values from the currently cost centers that are in edit mode
            if (restoreCC)
                RestoreEditedCostCenters();

            if (cmbAmountScale.Text != AmountScaleOption.Unit.ToString() && cmbAmountScale.Text != String.Empty)
            {
                RadComboBoxSelectedIndexChangedEventArgs loadEventArgs = new RadComboBoxSelectedIndexChangedEventArgs();
                loadEventArgs.OldText = AmountScaleOption.Unit.ToString();
                loadEventArgs.Text = cmbAmountScale.Text;
                cmbAmountScale_SelectedIndexChanged(null, loadEventArgs);
            }

            if (rebind)
                grdInitialBudget.Rebind();

            //Update the InitialBudgetTotals object
            totals = new InitialBudgetTotals(dsBudget.Tables[0]);
            SessionManager.SetSessionValue(this, ApplicationConstants.INITIAL_BUDGET_DATASET, dsBudget);
        }

        /// <summary>
        /// Restores the values from the session for the cost centers that are in editing mode
        /// </summary>
        private void RestoreEditedCostCenters()
        {
            List<Budget> editingCostCentersList = new List<Budget>();
            //Get the list from the session
            editingCostCentersList = SessionManager.GetSessionValueNoRedirect(this, EDITING_COST_CENTERS_LIST) as List<Budget>;
            if (editingCostCentersList == null)
                return;

            //Find the correspondig datarow for each cost center in the list and update the correspondig
            //data row from the data source
            foreach (InitialBudget currentBudget in editingCostCentersList)
            {
                DataRow row = GetDataRow(currentBudget);
                if (row == null)
                    continue;

                if (currentBudget.TotalHours == ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS)
                    row["TotalHours"] = DBNull.Value;
                else
                    row["TotalHours"] = currentBudget.TotalHours;

                if (currentBudget.Sales == ApplicationConstants.DECIMAL_NULL_VALUE)
                    row["Sales"] = DBNull.Value;
                else
                    row["Sales"] = currentBudget.Sales;

                if (currentBudget.ValuedHours == ApplicationConstants.DECIMAL_NULL_VALUE)
                    row["ValuedHours"] = DBNull.Value;
                else
                    row["ValuedHours"] = currentBudget.ValuedHours;
                
                InitialBudgetOtherCosts otherCostsKey = new InitialBudgetOtherCosts(SessionManager.GetConnectionManager(this));
                otherCostsKey.IdProject = currentBudget.IdProject;
                otherCostsKey.IdPhase = currentBudget.IdPhase;
                otherCostsKey.IdWP = currentBudget.IdWP;
                otherCostsKey.IdCostCenter = currentBudget.IdCostCenter;
                int associateId = SessionManager.GetCurrentUser(this).IdAssociate;
                otherCostsKey.IdAssociate = associateId;
                InitialBudgetOtherCosts otherCost = SessionManager.GetOtherCost(this, otherCostsKey);
                if (otherCost != null)
                    row["OtherCosts"] = otherCost.TotalValue;
            }

            //Delete the values from the session
            SessionManager.SetSessionValue(this, EDITING_COST_CENTERS_LIST, null);
        }

        /// <summary>
        /// Return the budget state for current or query string associate id
        /// </summary>
        /// <returns></returns>
        private string GetCurrentBudgetState()
        {
            //Submit button visible for CTM only in Open state
            //Approve button visible for PM only in Waiting for approval state
            //Reject button visible for PM in Waiting for approval and Approved states         


            string budgetState = String.Empty;
            //Get the connection manager from the session
            ConnectionManager conMan = SessionManager.GetSessionValueRedirect(this, SessionStrings.CONNECTION_MANAGER) as ConnectionManager;
            // Get the current project
            CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
            //Get the current logged user
            CurrentUser user = (CurrentUser)SessionManager.GetSessionValueRedirect(this.Page, SessionStrings.CURRENT_USER);

            //get the dataset from database
            FollowUpInitialBudget flpInitBudget = new FollowUpInitialBudget(conMan);
            flpInitBudget.IdProject = currentProject.Id;
            flpInitBudget.IdAssociate = ((FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS ? user.IdAssociate : FollowUpIdAssociate));
            //DataSet dsButtons = flpInitBudget.GetAll(true);
            DataSet dsButtons = flpInitBudget.GetInitialBudgetStateForEvidence("GetInitialBudgetStateForEvidence");
            if (dsButtons != null)
            {
                if (dsButtons.Tables[0].Rows.Count > 0)
                {
                    budgetState = dsButtons.Tables[0].Rows[0]["StateCode"].ToString();
                }
                else
                {
                    budgetState = ApplicationConstants.BUDGET_STATE_NONE;
                }
            }
            else
            {
                throw new IndException("This associate is not in CORETEAM");
            }
            return budgetState;
        }

        /// <summary>
        /// get the validated status of the whole budget
        /// </summary>
        /// <returns></returns>
        private bool GetBudgetIsValidState_Initial()
        {
            CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
            FollowUpInitialBudget followUpInitBud = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpInitBud.IdProject = currentProject.Id;
            return followUpInitBud.GetInitialBudgetValidState("GetInitialBudgetValidState");
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
            bool isBudgetValid = GetBudgetIsValidState_Initial();
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
            if (FollowUpIdAssociate != ApplicationConstants.BUDGET_DIRECT_ACCESS)
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

        /// <summary>
        /// Sets the grid in readonly mode
        /// </summary>
        /// <param name="e">The argument that contains a GridItem</param>
        private void SetGridReadOnly()
        {
            //grdInitialBudget.Enabled = false;
            isGridReadOnly = true;
            //When the grid is made readonly, the save all button becomes invisible
            btnSave.Visible = false;
        }

        private void SetButtonsAndGridReadOnly()
        {
            EvidenceButton.SubmitVisible = false;
            EvidenceButton.RejectVisible = false;
            EvidenceButton.ApprovedVisible = false;
            SetGridReadOnly();
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
        }

        /// <summary>
        /// Gets the row from the datasource that corresponds to the parent of a cost center
        /// </summary>
        /// <param name="IdProject">The Cost Center Project Id</param>
        /// <param name="idPhase">The cost center Phase Id</param>
        /// <param name="idWP">The Cost Center WP Id</param>
        /// <returns>The parent datarow</returns>
        private DataRow GetCostCenterParentRow(int IdProject, int idPhase, int idWP)
        {
            foreach (DataRow row in dsBudget.Tables[1].Rows)
            {
                if (((int)row["IdProject"] == IdProject) && ((int)row["IdPhase"] == idPhase) && ((int)row["IdWP"] == idWP))
                    return row;
            }
            throw new IndException(ApplicationMessages.EXCEPTION_COST_CENTER_PARENT_NOT_FOUND);
        }

        /// <summary>
        /// Returns the correspondig row for a initial budget from the datasource
        /// </summary>
        /// <param name="iBudget">The intial budget object</param>
        /// <returns>The corresponding data row</returns>
        private DataRow GetDataRow(InitialBudget iBudget)
        {
            foreach (DataRow row in dsBudget.Tables[2].Rows)
            {
                if (((int)row["IdProject"] == iBudget.IdProject) && ((int)row["IdPhase"] == iBudget.IdPhase) &&
                    ((int)row["IdWP"] == iBudget.IdWP) && ((int)row["IdCostCenter"] == iBudget.IdCostCenter))
                    return row;
            }
            return null;
        }

        /// <summary>
        /// Removes the InitialBudgetOtherCosts object built from the given dataItem from the list that is held in the session
        /// </summary>
        /// <param name="dataItem">the item containing information about InitialBudgetOtherCosts object to be removed from session</param>
        private void RemoveInitialBudgetOtherCostsFromSession(GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (item == null)
                return;

            InitialBudgetOtherCosts otherCosts = new InitialBudgetOtherCosts(SessionManager.GetConnectionManager(this));
            otherCosts = BuildInitialBudgetOtherCosts(item);
            SessionManager.RemoveInitialBudgetOtherCosts(this, otherCosts);
        }

        private void RemoveInitialBudgetOtherCostsFromSession(List<Budget> canceledRows)
        {
            int idAssociate = SessionManager.GetCurrentUser(this).IdAssociate;
            foreach (Budget budget in canceledRows)
            {
                InitialBudgetOtherCosts otherCosts = new InitialBudgetOtherCosts(SessionManager.GetConnectionManager(this));
                otherCosts.IdAssociate = idAssociate;
                otherCosts.IdCostCenter = budget.IdCostCenter;
                otherCosts.IdPhase = budget.IdPhase;
                otherCosts.IdProject = budget.IdProject;
                otherCosts.IdWP = budget.IdWP;

                SessionManager.RemoveInitialBudgetOtherCosts(this, otherCosts);
            }
        }

        /// <summary>
        /// Builds a BudgetOtherCosts object to be sent to the other costs pop-up
        /// </summary>
        /// <param name="dataItem"></param>
        /// <returns></returns>
        private InitialBudgetOtherCosts BuildInitialBudgetOtherCosts(GridDataItem dataItem)
        {
            object connectionManager = SessionManager.GetConnectionManager(this);
            int idAssociate = SessionManager.GetCurrentUser(this).IdAssociate;
            //Build other costs object
            InitialBudgetOtherCosts otherCosts = new InitialBudgetOtherCosts(connectionManager);
            otherCosts.IdAssociate = idAssociate;
            otherCosts.IdCostCenter = int.Parse(GetDataItemValue(dataItem, "IdCostCenter"));
            otherCosts.IdPhase = int.Parse(GetDataItemValue(dataItem, "IdPhase"));
            otherCosts.IdProject = int.Parse(GetDataItemValue(dataItem, "IdProject"));
            otherCosts.IdWP = int.Parse(GetDataItemValue(dataItem, "IdWP"));
            return otherCosts;
        }

        /// <summary>
        /// Gets the value of a GridDataItem at the specified key
        /// </summary>
        /// <param name="dataItem"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        private string GetDataItemValue(GridDataItem dataItem, string key)
        {
            if (dataItem.SavedOldValues[key] == null || String.IsNullOrEmpty(dataItem.SavedOldValues[key].ToString()))
                return dataItem[key].Text;
            else
                return dataItem.SavedOldValues[key].ToString();
        }

        /// <summary>
        /// Add the currency column in fron of the cost center
        /// </summary>
        private void AddCurencyColumn()
        {
            //Get the current user from the session
            CurrentUser currentUser = SessionManager.GetCurrentUser(this);
            //Initialize the string that represents the currebcy representaion mode
            if (currentUser.Settings.CurrencyRepresentation == CurrencyRepresentationMode.CostCenter)
            {
                grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = true;
                grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CostCenterName").ItemStyle.Width = Unit.Pixel(COST_CENTER_WIDTH_CURRENCY);
            }
            else
            {
                grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CurrencyCode").Visible = false;
                grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].GetColumn("CostCenterName").ItemStyle.Width = Unit.Pixel(COST_CENTER_WIDTH_NO_CURRENCY);
            }
        }

        /// <summary>
        /// Create header text - set the currency representation mode and the type of budget
        /// </summary>
        /// <param name="gridItem"></param>
        private void CreateHeaderText(GridItem gridItem)
        {
            if (!(gridItem is GridHeaderItem) || (gridItem.OwnerTableView != grdInitialBudget.MasterTableView))
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
            //Update the header text
            headerItem["PhaseName"].Text = "Currency: " + currencyRepresentationString + "<br>" + headerItem["PhaseName"].Text;
        }

        /// <summary>
        /// Saves into session all cost centers that are in editing mode, so 
        /// they can be restored after reloading the datasource
        /// </summary>
        /// <param name="iBudget">The cost center that will not be stored in session beacuse it will be
        /// saved in the database
        /// </param>
        private void StoreEditedCostCenters(InitialBudget iBudget)
        {
            List<Budget> editingBudgets = new List<Budget>();

            object connManager = SessionManager.GetConnectionManager(this);


            foreach (GridDataItem item in grdInitialBudget.Items)
            {
                if (item.OwnerTableView.Name == grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].Name && item.IsInEditMode)
                {
                    Hashtable newValues = new Hashtable();
                    item.ExtractValues(newValues);
                    InsertOldValuesInList(newValues, item);
                    //Get only the key to use it for comparison. We don't take the values beacuse if one value is incorrect, an error
                    //is displayed wich is not corect beacuse the user just pressed cancel
                    InitialBudget newIBudget = new InitialBudget(connManager, newValues);

                    if ((iBudget != null) && (newIBudget.IdProject == iBudget.IdProject)
                        && (newIBudget.IdPhase == iBudget.IdPhase) && (newIBudget.IdWP == iBudget.IdWP)
                        && (newIBudget.IdCostCenter == iBudget.IdCostCenter))
                        continue;


                    //If it's ok, get also the values
                    newIBudget = new InitialBudget(connManager, newValues, true, false);
                    editingBudgets.Add(newIBudget);
                }
            }
            SessionManager.SetSessionValue(this, EDITING_COST_CENTERS_LIST, editingBudgets);
        }

        private void StoreEditedCostCenters(List<Budget> budgets)
        {
            List<Budget> editingBudgets = new List<Budget>();

            object connManager = SessionManager.GetConnectionManager(this);

            bool foundBudget;
            foreach (GridDataItem item in grdInitialBudget.Items)
            {
                foundBudget = false;
                if (item.OwnerTableView.Name == grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].Name && item.IsInEditMode)
                {
                    Hashtable newValues = new Hashtable();
                    item.ExtractValues(newValues);
                    InsertOldValuesInList(newValues, item);

                    InitialBudget newBudget = new InitialBudget(connManager, newValues);

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

                    newBudget = new InitialBudget(connManager, newValues, true, false);
                    editingBudgets.Add(newBudget);
                }
            }

            SessionManager.SetSessionValue(this, EDITING_COST_CENTERS_LIST, editingBudgets);
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
                FollowUpInitialBudget fIBudget = new FollowUpInitialBudget(SessionManager.GetConnectionManager(this));
                fIBudget.IdProject = projectId;
                fIBudget.IdAssociate = associateId;
                fIBudget.StateCode = ApplicationConstants.BUDGET_STATE_OPEN;
                fIBudget.SetModified();
                fIBudget.Save();
                EvidenceButton.SubmitVisible = true;
            }
        }

        /// <summary>
        /// Sets the format string for columns in the given table
        /// </summary>
        /// <param name="tableView"></param>
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
        /// Update the other costs cells with the values from the session
        /// </summary>
        private void UpdateOtherCosts()
        {
            StoreEditedCostCenters((InitialBudget)null);
            List<InitialBudgetOtherCosts> otherCostsList = SessionManager.GetSessionValueNoRedirect(this, SessionStrings.INITIAL_OTHER_COSTS_LIST) as List<InitialBudgetOtherCosts>;
            if (otherCostsList == null)
                return;

            RestoreEditedCostCenters();

            foreach (InitialBudgetOtherCosts otherCost in otherCostsList)
            {
                foreach (DataRow row in dsBudget.Tables[2].Rows)
                {
                    if (((int)row["IdProject"] == otherCost.IdProject) && ((int)row["IdPhase"] == otherCost.IdPhase) && ((int)row["IdWP"] == otherCost.IdWP) && ((int)row["IdCostCenter"] == otherCost.IdCostCenter))
                    {
                        decimal otherCostValue = ((otherCost.TE == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.TE) +
                            ((otherCost.ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.ProtoParts) +
                            ((otherCost.ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.ProtoTooling) +
                            ((otherCost.Trials == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.Trials) +
                            ((otherCost.OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : otherCost.OtherExpenses);
                        row["OtherCosts"] = Rounding.Round(decimal.Divide(otherCostValue, GetScaleMultiplier()));
                    }
                }
            }
            grdInitialBudget.Rebind();
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
        /// Adds a cost center
        /// </summary>
        private void AddCostCenter(string buttonId)
        {
            bool isWPActive;

            StoreEditedCostCenters((InitialBudget)null);

            string MassAttribution = (SessionManager.GetSessionValueNoRedirect(this, SessionStrings.ADD_CC_TO_TARGET) == null) ? 
                                            ApplicationConstants.ADD_CC_TO_CURRENT_WP :
                                            (string)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.ADD_CC_TO_TARGET);
            bool useMassAttribution = (MassAttribution == ApplicationConstants.ADD_CC_TO_CURRENT_WP ? false : true);
            int rowToUpdate = 0;
            int updatedRows = 0;
            lblNoWPsAffected.Text = String.Empty;
            //Search for the cost center that caused the postback
            for (int i = 0; i < grdInitialBudget.MasterTableView.Items.Count; i++)
            {
                GridTableView detailTableView = grdInitialBudget.MasterTableView.Items[i].ChildItem.NestedTableViews[0];

                for (int j = 0; j < detailTableView.Items.Count; j++)
                {
                    // Get the current project
                    CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
                    string ProjectFunctionWPCodeSuffix = currentProject.ProjectFunctionWPCodeSuffix;

                    DataRow drCurrentWP = dsBudget.Tables[1].Rows[rowToUpdate];
                    string currentWPCode = drCurrentWP["WPCode"].ToString();
                    string currentWPCodeSuffix = currentWPCode.Substring(currentWPCode.Length - 2, 2);

                    //Check if the current wp is active
                    if (bool.TryParse(detailTableView.Items[j]["IsActive"].Text, out isWPActive) == false)
                        throw new IndException("Value of 'IsActive' column must be of boolean type.");
                    //Check if WP Code Suffix is not empty
                    if (MassAttribution == ApplicationConstants.ADD_CC_TO_MY_WPS && ProjectFunctionWPCodeSuffix == String.Empty)
                        throw new IndException("Current project function has no WP Code Suffix defined.");
                    GridDataItem item = detailTableView.Items[j];
                    //Get the button fro the current item and see if it is the one that caused the postback
                    IndImageButton currentButton = item["colAddCostCenter"].Controls[1] as IndImageButton;
                    if (currentButton == null)
                        return;

                    //Add cost center to the current wp only if it is active
                    bool addCC = false;
                    if (((currentButton.ClientID == buttonId) || (useMassAttribution)) && isWPActive)
                    {
                        if (MassAttribution != ApplicationConstants.ADD_CC_TO_MY_WPS)
                            addCC = true;
                        else
                            addCC = (ProjectFunctionWPCodeSuffix.IndexOf(currentWPCodeSuffix) > -1);
                    }

                    if (addCC)
                    {
                         //Get the logical key from the found item
                        int wpId = ApplicationConstants.INT_NULL_VALUE;
                        int phaseId = ApplicationConstants.INT_NULL_VALUE;
                        int projectId = ApplicationConstants.INT_NULL_VALUE;
                        int.TryParse(item["IdWP"].Text, out wpId);
                        int.TryParse(item["IdPhase"].Text, out phaseId);
                        int.TryParse(item["IdProject"].Text, out projectId);

                        //Get the start and end year month values
                        YearMonth startYearMonth = new YearMonth(item["StartYearMonth"].Text);
                        YearMonth endYearMonth = new YearMonth(item["EndYearMonth"].Text);

                        //Get the cost center from the session
                        CostCenterFilter costCenter = SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_COSTCENTER) as CostCenterFilter;
                        if (costCenter == null)
                            break;
                        //Create a new row that will be inserted in the database
                        DataRow row = dsBudget.Tables[2].NewRow();
                        //Initialize the values for the current row
                        row["IdProject"] = projectId;
                        row["IdPhase"] = phaseId;
                        row["IdWP"] = wpId;
                        row["IdCostCenter"] = costCenter.IdCostCenter;
                        row["CostCenterName"] = costCenter.NameCostCenter;
                        row["TotalHours"] = 0;
                        row["Averate"] = 0;
                        row["ValuedHours"] = 0;
                        row["OtherCosts"] = 0;
                        row["Sales"] = 0;
                        row["NetCosts"] = 0;
                        FillCostCenterCurrency(row, costCenter.IdCostCenter);


                        //Get the connection manager from the session
                        ConnectionManager conMan = SessionManager.GetSessionValueRedirect(this, SessionStrings.CONNECTION_MANAGER) as ConnectionManager;
                        //Get the current logged user
                        CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect(this.Page, SessionStrings.CURRENT_USER);

                        int associateId = SessionManager.GetCurrentUser(this).IdAssociate;
                        InitialBudget iBudget = new InitialBudget(SessionManager.GetConnectionManager(this), row, associateId);
                        iBudget.SetNew();
                        try
                        {
                            //Check if the wp period has changed in the meanwhile
                            WorkPackage currentWP = new WorkPackage(conMan);
                            currentWP.IdProject = projectId;
                            currentWP.IdPhase = phaseId;
                            currentWP.Id = wpId;
                            currentWP.StartYearMonth = startYearMonth.Value;
                            currentWP.EndYearMonth = endYearMonth.Value;

                            currentWP.GetEntity().ExecuteCustomProcedure("CheckWPPeriod", currentWP);

                            #region Create InitialBudgetOtherCosts object
                            //A InitialBudgetOthercost object must be inserted so it will exist when update is called
                            InitialBudgetOtherCosts otherCost = new InitialBudgetOtherCosts(SessionManager.GetConnectionManager(this));
                            otherCost.IdProject = projectId;
                            otherCost.IdPhase = phaseId;
                            otherCost.IdWP = wpId;
                            otherCost.IdCostCenter = costCenter.IdCostCenter;
                            otherCost.IdAssociate = associateId;
                            otherCost.SetNew();
                            #endregion Create InitialBudgetOtherCosts object

                            bool evidenceButtonVisible;

                            iBudget.InsertBudget(currentProject, currentUser, FollowUpIdAssociate, otherCost, startYearMonth, endYearMonth, out evidenceButtonVisible);

                            EvidenceButton.SubmitVisible = evidenceButtonVisible;

                            if (!useMassAttribution)
                            {
                                LoadBudgetDS(true, true);
                                RestoreEditedCostCentersIndexes();
                            }
                        }
                        catch (IndException indExc)
                        {
                            ShowError(indExc);
                            if (!useMassAttribution)
                            {
                                return;
                            }
                        }
                        catch (Exception exc)
                        {
                            ShowError(new IndException(exc));
                            if (!useMassAttribution)
                            {
                                return;
                            }
                        }
                        if (!useMassAttribution)
                        {
                            return;
                        }
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
                LoadBudgetDS(true, true);
                RestoreEditedCostCentersIndexes();
            }
            if (grdInitialBudget.EditIndexes.Count == 0)
                SetUnsafeInEditModeControlsEnabledState(true);
            else
                SetUnsafeInEditModeControlsEnabledState(false);
        }

        /// <summary>
        /// Sets the currency in a given datarow for a given cost center
        /// </summary>
        /// <param name="row">The datarow to be updated</param>
        /// <param name="idCostCenter">The Cost Center Id</param>
        private void FillCostCenterCurrency(DataRow row, int idCostCenter)
        {
            CostCenter costCenter = new CostCenter(SessionManager.GetConnectionManager(this));
            costCenter.Id = idCostCenter;
            Currency currency = costCenter.GetCostCenterCurrency();
            row["IdCurrency"] = currency.Id;
            row["CurrencyCode"] = currency.Code;
        }

        /// <summary>
        /// Fills the exchange rate cache for the loaded dataset
        /// </summary>
        private void FillExchangeRateCache()
        {
            CurrentUser currentUser = SessionManager.GetCurrentUser(this);
            //Gets the associate currency
            int idAssociateCurrency = currentUser.IdCurrency;

            //Cycle through each row of the WPs table
            foreach (DataRow row in dsBudget.Tables[1].Rows)
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
                foreach (DataRow ccRow in dsBudget.Tables[2].Rows)
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
                        converter = new CurrencyConverter(SessionManager.GetConnectionManager(this));
                    converter.FillExchangeRateCache(startYearMonth, endYearMonth, idAssociateCurrency, currencies[i]);
                    SessionManager.SetSessionValue(this, SessionStrings.CURRENCY_CONVERTER, converter);
                }
            }
        }

        

        /// <summary>
        /// Checks to see if the valorization column was changed
        /// </summary>
        private void CheckValorizationColumn()
        {
            //Search throw each detail item
            for (int i = 0; i < grdInitialBudget.MasterTableView.Items.Count; i++)
            {
                GridTableView detailTableView = grdInitialBudget.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
                for (int j = 0; j < detailTableView.Items.Count; j++)
                {
                    GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                    for (int k = 0; k < lastTableView.Items.Count; k++)
                    {
                        GridDataItem item = lastTableView.Items[k];
                        //Only check those that are in editMode
                        if (item.IsInEditMode)
                        {
                            Hashtable newValues = new Hashtable();
                            item.ExtractValues(newValues);
                        }
                    }
                }
            }
        }
        /// <summary>
        /// Iterates through the cost centers and saves the ones that are in edit mode in the session
        /// </summary>
        private void StoreEditedCostCentersIndexes()
        {
            CostCenterKeyCollection costCenterKeys = new CostCenterKeyCollection();
            for (int i = 0; i < grdInitialBudget.MasterTableView.Items.Count; i++)
            {
                GridTableView detailTableView = grdInitialBudget.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
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
                            key.IdPhase = int.Parse(item.SavedOldValues["IdPhase"].ToString());
                            key.IdWP = int.Parse(item.SavedOldValues["IdWP"].ToString());
                            key.IdCostCenter = int.Parse(item.SavedOldValues["IdCostCenter"].ToString());
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
        private void RestoreEditedCostCentersIndexes()
        {
            CostCenterKeyCollection costCenterKeys = (CostCenterKeyCollection)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.EDITED_COST_CENTERS);
            if (costCenterKeys == null)
                return;

            for (int i = 0; i < grdInitialBudget.MasterTableView.Items.Count; i++)
            {
                GridTableView detailTableView = grdInitialBudget.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
                for (int j = 0; j < detailTableView.Items.Count; j++)
                {
                    GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                    for (int k = 0; k < lastTableView.Items.Count; k++)
                    {
                        //Here we are at cost center level in the grid
                        GridDataItem item = lastTableView.Items[k];
                        CostCenterKey key = new CostCenterKey();
                        if (item.IsInEditMode)
                        {
                            key.IdPhase = int.Parse(item.SavedOldValues["IdPhase"].ToString());
                            key.IdWP = int.Parse(item.SavedOldValues["IdWP"].ToString());
                            key.IdCostCenter = int.Parse(item.SavedOldValues["IdCostCenter"].ToString());
                        }
                        else
                        {
                            key.IdPhase = int.Parse(item["IdPhase"].Text);
                            key.IdWP = int.Parse(item["IdWP"].Text);
                            key.IdCostCenter = int.Parse(item["IdCostCenter"].Text);
                        }
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
            grdInitialBudget.Rebind();
            SessionManager.RemoveValueFromSession(this, SessionStrings.EDITED_COST_CENTERS);
        }

        /// <summary>
        /// Sets the enbled state of the amount scale combobox, submit button and totals button depending on the given argument. These
        /// controls should not be enabled when there is at least one cc in edit mode, as it is not safe
        /// </summary>
        /// <param name="isEnabled">states whether controls are enabled or disabled</param>
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

        private void InsertOldValuesInList(Hashtable newValues, GridDataItem item)
        {
            newValues["IdProject"] = item.SavedOldValues["IdProject"];
            newValues["IdPhase"] = item.SavedOldValues["IdPhase"];
            newValues["IdWP"] = item.SavedOldValues["IdWP"];
            newValues["IdCostCenter"] = item.SavedOldValues["IdCostCenter"];
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
            foreach (DataRow row in dsBudget.Tables[2].Rows)
            {
                if (((int)row["IdProject"] == projectId) && ((int)row["IdPhase"] == phaseId) &&
                    ((int)row["IdWP"] == wpId) && ((int)row["IdCostCenter"] == costCenterId))
                    return row;
            }
            return null;
        }

        /// <summary>
        /// Hides the Add cc, edit cc and delete cc from the inactive wps
        /// </summary>
        private void MakeInactiveWPsReadOnly()
        {
            bool isWPActive;
            //Specifies if at least 1 wp of a phase is active
            bool isPhaseActive;

            for (int i = 0; i < grdInitialBudget.MasterTableView.Items.Count; i++)
            {
                isPhaseActive = false;
                GridTableView detailTableView = grdInitialBudget.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
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
                    if (detailTableView.Items[j]["colAddCostCenter"].Controls[1] is IndImageButton)
                    {
                        IndImageButton btnAddCC = detailTableView.Items[j]["colAddCostCenter"].Controls[1] as IndImageButton;
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
                        if (lastTableView.Items[k]["EditCostCenter"].Controls[0] is ImageButton)
                        {
                            ImageButton btnEditCC = lastTableView.Items[k]["EditCostCenter"].Controls[0] as ImageButton;
                            btnEditCC.Visible = false;
                        }
                    }
                }
                if (!isPhaseActive)
                    grdInitialBudget.MasterTableView.Items[i]["EditColumn"].Controls[0].Visible = false;
            }
        }

        private void DisplayTotals()
        {
            //If the totals is null, it means that there was no need to recalculate them and they will remain the same (the values will not change
            //due to viewstate)
            if (totals == null)
                return;

            lblTotalHoursTotals.Text = (totals.TotalHours == ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS) ? String.Empty : totals.TotalHours.ToString();

            if (isAssociateCurrency)
            {
                lblAverateTotals.Text = (totals.Avertate == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(totals.Avertate).ToString();
                lblValHoursTotals.Text = (totals.ValHours == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(totals.ValHours).ToString();
                lblOtherCostsTotals.Text = (totals.OtherCosts == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(totals.OtherCosts).ToString();
                lblSalesTotals.Text = (totals.Sales == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(totals.Sales).ToString();
                lblNetCostsTotals.Text = (totals.NetCosts == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(totals.NetCosts).ToString();
            }
            else
            {
                lblAverateTotals.Text = String.Empty;
                lblValHoursTotals.Text = String.Empty;
                lblOtherCostsTotals.Text = String.Empty;
                lblSalesTotals.Text = String.Empty;
                lblNetCostsTotals.Text = String.Empty;
            }
        }

        private void DoCancelAction(GridDataItem dataItem)
        {
            if (dataItem == null)
                return;

            bool setMasterItemOutOfEditMode = true;
            bool setDetailItemOutOfEditMode = true;
            bool needsRebind = false;

            Hashtable newValues = new Hashtable();

            List<Budget> canceledRows = new List<Budget>();
            object connectionManager = SessionManager.GetConnectionManager(this);

            if (dataItem.OwnerTableView.Name == grdInitialBudget.MasterTableView.Name)
            {
                CancelMasterItem(dataItem, connectionManager, canceledRows, newValues);
            }
            if (dataItem.OwnerTableView.Name == grdInitialBudget.MasterTableView.DetailTables[0].Name)
            {
                needsRebind = CancelDetailItem(dataItem, connectionManager, canceledRows, newValues, setMasterItemOutOfEditMode);
            }

            setMasterItemOutOfEditMode = true;
            if (dataItem.OwnerTableView.Name == grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].Name)
            {
                needsRebind = CancelDetailDetailItem(dataItem, connectionManager, canceledRows, newValues, setMasterItemOutOfEditMode, setDetailItemOutOfEditMode);
            }

            DoCancelStoreAction(canceledRows);
            
            if (needsRebind)
            {
                //For an unknown reason (has to do with the internal mechanisms of radgrid), after rebind, the current item remains in edit mode.
                //Therefore we must set its Edit property to false manually before rebinding
                dataItem.Edit = false;
                grdInitialBudget.Rebind();
            }

            //If there is no item in edit mode, set the submit button enabled
            if (grdInitialBudget.EditIndexes.Count > 1)
                SetUnsafeInEditModeControlsEnabledState(false);
            else
                SetUnsafeInEditModeControlsEnabledState(true);
        }

        private bool CancelDetailDetailItem(GridDataItem dataItem, object connectionManager, List<Budget> canceledRows, Hashtable newValues, bool setMasterItemOutOfEditMode, bool setDetailItemOutOfEditMode)
        {
            bool needsRebind = false;

            dataItem.ExtractValues(newValues);
            InsertOldValuesInList(newValues, dataItem);

            Budget budget = new InitialBudget(connectionManager, newValues);
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

            return needsRebind;
        }

        private bool CancelDetailItem(GridDataItem dataItem, object connectionManager, List<Budget> canceledRows, Hashtable newValues, bool setMasterItemOutOfEditMode)
        {
            bool needsRebind = false;

            GridTableView lastTableView = dataItem.ChildItem.NestedTableViews[0];
            for (int k = 0; k < lastTableView.Items.Count; k++)
            {
                if (lastTableView.Items[k].IsInEditMode)
                {
                    lastTableView.Items[k].Edit = false;

                    lastTableView.Items[k].ExtractValues(newValues);
                    InsertOldValuesInList(newValues, lastTableView.Items[k]);

                    Budget budget = new InitialBudget(connectionManager, newValues);
                    canceledRows.Add(budget);
                }
            }
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
            return needsRebind;
        }

        private void CancelMasterItem(GridDataItem dataItem, object connectionManager, List<Budget> canceledRows, Hashtable newValues)
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

                        lastTableView.Items[k].ExtractValues(newValues);
                        InsertOldValuesInList(newValues, lastTableView.Items[k]);

                        Budget budget = new InitialBudget(connectionManager, newValues);
                        canceledRows.Add(budget);
                    }
                }
            }
        }

        private void DoCancelStoreAction(List<Budget> canceledRows)
        {
            StoreEditedCostCenters(canceledRows);

            //Remove the stored value of the other costs for this cost center from session
            RemoveInitialBudgetOtherCostsFromSession(canceledRows);

            LoadBudgetDS(false, true);
        }

        private void DoUpdateAction(GridCommandEventArgs e)
        {
            GridDataItem dataItem = (GridDataItem)e.Item;
            bool setMasterItemOutOfEditMode = true;
            bool setDetailItemOutOfEditMode = true;

            List<Budget> canceledRows = new List<Budget>();
            object connectionManager = SessionManager.GetConnectionManager(this);

            if (dataItem.OwnerTableView.Name == grdInitialBudget.MasterTableView.Name)
            {
                UpdateMasterItem(dataItem, connectionManager, canceledRows);
            }
            if (dataItem.OwnerTableView.Name == grdInitialBudget.MasterTableView.DetailTables[0].Name)
            {
                UpdateDetailItem(dataItem, connectionManager, canceledRows, setMasterItemOutOfEditMode);
            }

            setMasterItemOutOfEditMode = true;
            if (dataItem.OwnerTableView.Name == grdInitialBudget.MasterTableView.DetailTables[0].DetailTables[0].Name)
            {
                UpdateDetailDetailItem(dataItem, e, connectionManager, canceledRows, setMasterItemOutOfEditMode, setDetailItemOutOfEditMode);
            }

            RemoveInitialBudgetOtherCostsFromSession(canceledRows);

            e.Item.Edit = false;
           
            LoadBudgetDS(true, true);
        }

        private void UpdateDetailDetailItem(GridDataItem dataItem, GridCommandEventArgs e, object connectionManager, List<Budget> canceledRows, bool setMasterItemOutOfEditMode, bool setDetailItemOutOfEditMode)
        {
            Hashtable newValues = new Hashtable();

            SaveBudget(e, false);

            dataItem.ExtractValues(newValues);
            InsertOldValuesInList(newValues, dataItem);

            Budget budget = new InitialBudget(connectionManager, newValues);
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

        private void UpdateDetailItem(GridDataItem dataItem, object connectionManager, List<Budget> canceledRows, bool setMasterItemOutOfEditMode)
        {
            Hashtable newValues = new Hashtable();

            GridTableView lastTableView = dataItem.ChildItem.NestedTableViews[0];
            for (int k = 0; k < lastTableView.Items.Count; k++)
            {
                if (lastTableView.Items[k].IsInEditMode)
                {
                    CommandEventArgs eventArgs = new CommandEventArgs("Update", null);
                    GridCommandEventArgs args = new GridCommandEventArgs(lastTableView.Items[k], false, eventArgs);
                    SaveBudget(args, false);
                    lastTableView.Items[k].Edit = false;

                    lastTableView.Items[k].ExtractValues(newValues);
                    InsertOldValuesInList(newValues, lastTableView.Items[k]);

                    Budget budget = new InitialBudget(connectionManager, newValues);
                    canceledRows.Add(budget);
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

        private void UpdateMasterItem(GridDataItem dataItem, object connectionManager, List<Budget> canceledRows)
        {
            Hashtable newValues = new Hashtable();

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
                        SaveBudget(args, false);
                        lastTableView.Items[k].Edit = false;

                        lastTableView.Items[k].ExtractValues(newValues);
                        InsertOldValuesInList(newValues, lastTableView.Items[k]);

                        Budget budget = new InitialBudget(connectionManager, newValues);
                        canceledRows.Add(budget);
                    }
                }
                detailTableView.Items[j].Edit = false;
            }
        }

        private void AddJavascriptRestrictKeysScript(TextBox txtEdit, string colName)
        {
            if (colName != "Sales")
                txtEdit.Attributes.Add("onKeyPress", "return RestrictKeys(event,'1234567890','" + txtEdit.ClientID + "')");
            else
                txtEdit.Attributes.Add("onKeyPress", "return RestrictKeys(event,'1234567890-','" + txtEdit.ClientID + "')");
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
}
