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
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Telerik.WebControls;
using Inergy.Indev3.ApplicationFramework.Timing_Interco;
using Inergy.Indev3.BusinessLogic.Authorization;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Collections.Generic;
using Inergy.Indev3.WebFramework.WebControls;


public partial class Pages_Budget_WPPreselection_WPPreselection : IndBasePage
{
    #region Constants
    /// <summary>
    /// Session string for holding the unused wp dataset
    /// </summary>
    private const string DS_UNUSED_WP = "DsUnusedWp";
    /// <summary>
    /// Session string for holding the selected wp dataset
    /// </summary>
    private const string DS_SELECTED_WP = "DsSelectedWP";
    /// <summary>
    /// Session string for holding the budget state
    /// </summary>
    private const string BUDGET_STATE = "BudgetState";
    /// <summary>
    /// Used for storing a list of the checked WPs
    /// </summary>
    private const string CHECKED_WPS = "CheckedWPs";
    /// <summary>
    /// Values of the cmbActive combobox
    /// </summary>
    private const string SHOW_ACTIVE = "A";
    private const string SHOW_INACTIVE = "I";
    private const string SHOW_ALL = "L";
    private const string EDITING_COST_CENTERS_LIST = "EditingCostCentersList";
    #endregion Constants

    #region Members
    /// <summary>
    /// If true, the wp preselection page cannot be viewed (this may be the case when the user accesses revised budget without having an initial
    /// budget defined yet)
    /// </summary>
    private bool AccessDenied;
    /// <summary>
    /// Holds the error message that will be shown to the user, if this page cannot be viewed (for various reasons)
    /// </summary>
    private string ErrorMessage;
    /// <summary>
    /// The state of the budget which will be viewed when clicking the "Next" button
    /// </summary>
    private string BudgetState
    {
        get
        {
            return SessionManager.GetSessionValueNoRedirect(this, BUDGET_STATE).ToString();
        }
        set
        {
            SessionManager.SetSessionValue(this, BUDGET_STATE, value);
        }
    }
    #endregion Members

    #region Event Handlers
    /// <summary>
    /// Load event handler of page
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //Delete the values from the session
            SessionManager.SetSessionValue(this, EDITING_COST_CENTERS_LIST, null);

            string issuer = Page.Request.Params.Get("__EVENTTARGET");
            string argument = Page.Request.Params.Get("__EVENTARGUMENT");
            if (!IsPostBack || issuer.Contains("lnkChange"))
            {
                if (HttpContext.Current.Request.QueryString.Keys.Count == 0)
                {
                    this.ShowError(new IndException(ApplicationMessages.EXCEPTION_COULD_NOT_GET_CATALOGUE_CODE_PARAMETER));
                    return;
                }

                //Get the budget code
                string codeParam = HttpContext.Current.Request.QueryString.Keys[0];
                string budgetCode = HttpContext.Current.Request.QueryString[codeParam];

                if (budgetCode == ApplicationConstants.MODULE_INITIAL)
                    cmbActive.Visible = false;
                else
                    cmbActive.Visible = true;

                bool isFromFollowUp = IsFromFollowUp();

                CurrentUser currentUser = SessionManager.GetCurrentUser(this);
                CurrentProject currentProject = SessionManager.GetCurrentProject(this);

                //The code of the budget for which the rights will be checked. If coming from follow up, the rights to view the follow-up budget
                //will be checked, otherwise the rights to view the selected budget will be checked.
                string checkRightsBudgetCode;

                checkRightsBudgetCode = isFromFollowUp ? ApplicationConstants.MODULE_FOLLOW_UP : budgetCode;

                if (!currentUser.HasViewPermission(checkRightsBudgetCode, currentProject.Id))
                {
                    AccessDenied = true;
                    grdPreselection.Visible = false;
                    pnlBudgetLayout.Visible = false;
                    ErrorMessage = ApplicationMessages.EXCEPTION_USER_IS_NOT_IN_CORETEAM;
                    return;
                }

                switch (budgetCode)
                {
                    case ApplicationConstants.MODULE_REVISED:
                        GridAndPanelSettings(ApplicationConstants.MODULE_REVISED);
                        break;
                    case ApplicationConstants.MODULE_REFORECAST:
                        radioAllCollapsed.Checked = true;
                        radioAllExpanded.Checked = false;
                        GridAndPanelSettings(ApplicationConstants.MODULE_REFORECAST);
                        break;
                    case ApplicationConstants.MODULE_INITIAL:
                        InitialGridAndPanelSettings();
                        break;
                }

                //If everything is OK so far, populate the unused wp listbox
                if (!AccessDenied)
                {
                    LoadUnusedWP();
                }
            }

            if (IsPostBack)
                HandlePagePostBack(issuer, argument);

            //Add on client click event to btnAddWP to check if at least 1 work package has been selected from the listbox
            btnAddWP.OnClientClick = "return VerifySelectedItems('" + lstNotSelectedWPs.ClientID + "');";
        }
        catch (IndException ex)
        {
            btnNext.Visible = false;
            ShowError(ex);
            return;
        }
        catch (Exception ex)
        {
            btnNext.Visible = false;
            ShowError(new IndException(ex));
            return;
        }
    }

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            base.OnPreRender(e);
            if (!AccessDenied)
            {
                if (!IsPostBack)
                    LoadBudgetLayout();
                
                //Hide the expand/collapse column
                grdPreselection.MasterTableView.GetColumn("ExpandColumn").Visible = false;
                foreach (GridDataItem dataItem in grdPreselection.MasterTableView.Items)
                    dataItem["ExpandColumn"].Visible = false;

                SetWPSelectable(BudgetState);

                HideNextButton();
            }
            else
            {
                string codeParam = HttpContext.Current.Request.QueryString.Keys[0];
                string budgetCode = HttpContext.Current.Request.QueryString[codeParam];
                if (budgetCode == ApplicationConstants.MODULE_REVISED || budgetCode == ApplicationConstants.MODULE_INITIAL || budgetCode == ApplicationConstants.MODULE_REFORECAST)
                {
                    throw new IndException(ErrorMessage);
                }
            }

            //If coming from follow-up and if the user has the required access, go directly to the budget screen
            if (IsFromFollowUp() && !AccessDenied)
            {
                btnNext_Click(null, null);
            }
        }
        catch (IndException ex)
        {
            btnNext.Visible = false;
            ShowError(ex);
            return;
        }
        catch (Exception ex)
        {
            btnNext.Visible = false;
            ShowError(new IndException(ex));
            return;
        }
    }

    protected void grdPreselection_NeedDataSource(object source, Telerik.WebControls.GridNeedDataSourceEventArgs e)
    {
        try
        {
            if (!AccessDenied)
            {
                //Load the data into the grid
                LoadData(false);
            }
        }
        catch (IndException ex)
        {
            btnNext.Visible = false;
            ShowError(ex);
            return;
        }
        catch (Exception ex)
        {
            btnNext.Visible = false;
            ShowError(new IndException(ex));
            return;
        }
    }
    
    protected void btnNext_Click(object sender, EventArgs e)
    {
        try
        {
            SaveBudgetLayoutToSession();
            BulkInsertWP();

            OpenBudgetWindow();
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
   
    protected void SelectWP_Click(object sender, EventArgs e)
    {
        try
        {
            SaveBudgetLayoutToSession();
            BulkInsertWP();
            StoreCheckedWPs();
            if (!ClientScript.IsStartupScriptRegistered(this.GetType(), "OpenIntercoPopUp"))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "OpenIntercoPopUp", "ShowPopUpWithoutPostBack('../Interco/TimingAndInterco.aspx?PopUp=1', 0, 1000, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "'); " + ClientScript.GetPostBackEventReference(btnDoPostback, "RefreshInterco"), true);
            }
        }
        catch (IndException ex)
        {
            btnNext.Visible = false;
            ShowError(ex);
            return;
        }
        catch (Exception ex)
        {
            btnNext.Visible = false;
            ShowError(new IndException(ex));
            return;
        }
    }

    protected void grdPreselection_ItemCreated(object sender, GridItemEventArgs e)
    {
        try
        {
            if (e.Item.OwnerTableView.Name != grdPreselection.MasterTableView.Name)
            {
                //Workaround to resolve expand colapse: 
                //See: http://www.telerik.com/community/forums/thread/b311D-etakd.aspx
                if (e.Item is GridHeaderItem)
                {
                    ((GridHeaderItem)e.Item).Display = false;
                }
            }
            if (e.Item.OwnerTableView.Name == grdPreselection.MasterTableView.Name && e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                CheckBox chkSelectWP = dataItem["SelectPhaseCol"].Controls[1] as CheckBox;
                if (chkSelectWP != null)
                {
                    chkSelectWP.Attributes.Add("onclick", "SelectChildCheckBoxes('" + grdPreselection.ClientID + "', '" + chkSelectWP.ClientID + "');");
                }
            }
			if (IsFromFollowUp())
			{
				if (e.Item is GridFooterItem)
				{
					GridFooterItem commandItem = e.Item as GridFooterItem;
					IndImageButton btnDeleteWP = commandItem.FindControl("btnDeleteWP") as IndImageButton;
					if (btnDeleteWP != null)
						btnDeleteWP.Visible = false;
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

    protected void btnAddWP_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            StoreCheckedWPs();
            AddWPToPreselection();
            RestoreCheckedWPs();
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
    protected void btnDeleteWP_Click(object sender, EventArgs e)
    {
        try
        {
            CheckWPBudgetInfo();
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

    protected void cmbActive_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            LoadData(true);
            LoadUnusedWP();
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
    /// <summary>
    /// Loads the Work Package data in the grid
    /// </summary>
    private void LoadData(bool rebind)
    {
        bool isFromFollowup = IsFromFollowUp();

        //Get the currently selected project
        CurrentProject currentProject = (CurrentProject)SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT);
        //Get affected work packages
        WPPreselection wpPreselection = new WPPreselection(SessionManager.GetSessionValueRedirect(this, SessionStrings.CONNECTION_MANAGER));
        wpPreselection.IdProject = currentProject.Id;
        
        
        CurrentUser currentUser = (CurrentUser)SessionManager.GetCurrentUser(this);
        if (!isFromFollowup)
        {
            wpPreselection.IdAssociate = currentUser.IdAssociate;
        }
        else
        {
            int idAssociate;
            if (int.TryParse(HttpContext.Current.Request.QueryString["IdAssociate"], out idAssociate) == false)
                throw new IndException("The IdAssociate value in the QueryString is not numeric.");
            
            wpPreselection.IdAssociate = idAssociate;
        }

        string budgetType = GetBudgetType();
        string budgetVersion = String.Empty;
        if (!String.IsNullOrEmpty(budgetType) && budgetType != ApplicationConstants.MODULE_INITIAL && isFromFollowup)
        {
            budgetVersion = GetBudgetVersion();
        }
        else
        {
            //The default budget version is open ("N")
            budgetVersion = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;
        }

        wpPreselection.BudgetType = budgetType;
        wpPreselection.BudgetVersion = budgetVersion;


        if (!isFromFollowup)
        {
            if (cmbActive.Visible)
            {
                wpPreselection.ActiveState = cmbActive.SelectedValue;
            }
            else
            {
                wpPreselection.ActiveState = SHOW_ACTIVE;
            }
        }
        else
        {
            switch (budgetVersion)
            {
                case ApplicationConstants.BUDGET_VERSION_PREVIOUS_CODE:
                case ApplicationConstants.BUDGET_VERSION_RELEASED_CODE:
                case ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE:
                    wpPreselection.ActiveState = SHOW_ACTIVE;
                    break;
                default:
                    throw new IndException("Budget Version " + budgetVersion + " does not exist.");
            }
        }

        DataSet dsPreselectedWP;
        wpPreselection.IsFromFollowUp = IsFromFollowUp();
        dsPreselectedWP = wpPreselection.GetAll(true);

        GrdPreselectionDataBind(dsPreselectedWP, rebind, true);
    }

    /// <summary>
    /// Handles the page postback, depending on the given issuer and argument
    /// </summary>
    /// <param name="issuer"></param>
    /// <param name="argument"></param>
    private void HandlePagePostBack(string issuer, string argument)
    {
        if (issuer.Contains("lnkChange"))
        {
            grdPreselection.Rebind();
        }

        if (issuer.Contains("btnDoPostback") && argument == "DeleteWP")
        {
            RemoveWPFromPreselection();
        }

        if (issuer.Contains("btnDoPostback") && argument == "RefreshInterco")
        {
            RefreshIntercoInformation();
        }
    }

    /// <summary>
    /// Gets the budget type from the query string (only when coming from follow-up)
    /// </summary>
    /// <returns></returns>
    private string GetBudgetType()
    {
        if (String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["Code"]))
        {
            this.ShowError(new IndException("Budget Type is missing"));
            return null;
        }
        string budgetType = HttpContext.Current.Request.QueryString["Code"];
        if (budgetType != ApplicationConstants.MODULE_INITIAL
            && budgetType != ApplicationConstants.MODULE_REVISED
            && budgetType != ApplicationConstants.MODULE_REFORECAST)
        {
            throw new IndException("Unrecognized budget type");
        }
        return budgetType;
    }

    /// <summary>
    /// Gets the budget version from the query string (only when coming from follow-up)
    /// </summary>
    /// <returns></returns>
    private string GetBudgetVersion()
    {
        if (String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["BudgetVersion"]))
        {
            throw new IndException("Budget Version is missing");
        }
        string budgetVersion = HttpContext.Current.Request.QueryString["BudgetVersion"];
        if (budgetVersion != ApplicationConstants.BUDGET_VERSION_PREVIOUS_CODE
            && budgetVersion != ApplicationConstants.BUDGET_VERSION_RELEASED_CODE
            && budgetVersion != ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE)
        {
            throw new IndException("Unrecognized budget version");
        }
        return budgetVersion;
    }

    /// <summary>
    /// Inserts the selected work packages into the temp table #BUDGET_PRESELECTION_TEMP in the database
    /// </summary>
    private void BulkInsertWP()
    {
        WPPreselection preselection = new WPPreselection(SessionManager.GetSessionValueRedirect(this, SessionStrings.CONNECTION_MANAGER));
        CurrentProject currentProject = (CurrentProject)SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT);
        WPList wpList = new WPList();

        for (int i = 0; i < grdPreselection.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = grdPreselection.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridDataItem item = detailTableView.Items[j];

                IntercoLogicalKey intercoKey = new IntercoLogicalKey();
                intercoKey.IdWP = int.Parse(item["IdWP"].Text);
                intercoKey.IdPhase = int.Parse(item["IdPhase"].Text);
                intercoKey.IdProject = currentProject.Id;
                wpList.Add(intercoKey);
            }
        }
        preselection.BulkInsertWP(wpList);
    }

    /// <summary>
    /// Checks if the work packages from the latest revised budget are contained in the current selection of work packages
    /// </summary>
    /// <param name="dataTable">datatable containing the latest revised budget work packages</param>
    private bool CheckRevisedWP(DataTable dataTable)
    {
        foreach (DataRow row in dataTable.Rows)
        {
            if (!FindRevisedWP(row))
            {
                return false;
            }
        }
        return true;
    }

    /// <summary>
    /// Searches for a work package in the current selection of work packages
    /// </summary>
    /// <param name="row">row containing information about a work package</param>
    /// <returns>true if the work package is found in the current work package selection, false otherwise</returns>
    private bool FindRevisedWP(DataRow row)
    {
        int idPhase = (int)row["IdPhase"];
        int idWP = (int)row["IdWP"];
        bool found = false;
        for (int i = 0; i < grdPreselection.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = grdPreselection.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridDataItem item = detailTableView.Items[j];

                if (idPhase == int.Parse(item["IdPhase"].Text) && idWP == int.Parse(item["IdWP"].Text))
                {
                    found = true;
                    break;
                }
            }
            if (found)
            {
                break;
            }
        }
        return found;
    }

    /// <summary>
    /// Saves the expanded/collapsed info into the session
    /// </summary>
    private void SaveBudgetLayoutToSession()
    {
        BudgetPreselectionLayout preselectionLayout = (BudgetPreselectionLayout)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.BUDGET_LAYOUT);
        if (preselectionLayout == null)
            preselectionLayout = new BudgetPreselectionLayout();

        //Get the budget code
        string codeParam = HttpContext.Current.Request.QueryString.Keys[0];
        string budgetCode = HttpContext.Current.Request.QueryString[codeParam];

        if (IsViewAllFromFollowUp())
            preselectionLayout.IsViewAllFromFollowUp = true;
        else
            preselectionLayout.IsViewAllFromFollowUp = false;

        switch (budgetCode)
        {
            case ApplicationConstants.MODULE_INITIAL:
                preselectionLayout.AllExpandedInitial = radioAllExpanded.Checked;
                break;
            case ApplicationConstants.MODULE_REVISED:
                preselectionLayout.AllExpandedRevised = radioAllExpanded.Checked;
                break;
            case ApplicationConstants.MODULE_REFORECAST:
                preselectionLayout.AllExpandedReforecast = radioAllExpanded.Checked;
                break;
            default:
                throw new NotImplementedException("Catalogue code " + budgetCode + " is undefined.");
        }

        SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.BUDGET_LAYOUT, preselectionLayout);
    }

    /// <summary>
    /// Opens the correct budget window, depending on the query string parameter
    /// <param name="showRevisedWarning">if true, a warning message is showed before opening revised budget</param>
    /// </summary>
    private void OpenBudgetWindow()
    {
        //If there are no query string parameters
        if (HttpContext.Current.Request.QueryString.Keys.Count == 0)
        {
            this.ShowError(new IndException(ApplicationMessages.EXCEPTION_COULD_NOT_GET_CATALOGUE_CODE_PARAMETER));
            return;
        }
        //Get the budget code
        string codeParam = HttpContext.Current.Request.QueryString.Keys[0];
        string budgetCode = HttpContext.Current.Request.QueryString[codeParam];


        string additionalParameters = String.Empty;

        //Open the corresponding web page
        int idProject = SessionManager.GetCurrentProject(this).Id;

        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        AmountScaleOption amountScale = AmountScaleOption.Unit;
        if (currentUser != null && currentUser.Settings != null)
            amountScale = currentUser.Settings.AmountScaleOption;

        switch (budgetCode)
        {
            case ApplicationConstants.MODULE_INITIAL:
                //IdAssociate must be transmited
                ResponseRedirect("~/Pages/Budget/InitialBudget/InitialBudget.aspx?IdAssociate=" + ((string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["IdAssociate"])) ? string.Empty : HttpContext.Current.Request.QueryString["IdAssociate"].ToString()) + "&AmountScale=" + amountScale.ToString() + "&IdCountry=-1");
                break;
            case ApplicationConstants.MODULE_REVISED:
                SessionManager.SetSessionValue(this, "RevisedSelectedTab", 0);

                ResponseRedirect("~/Pages/Budget/RevisedBudget/RevisedBudget.aspx?IdAssociate=" + ((string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["IdAssociate"])) ? string.Empty : HttpContext.Current.Request.QueryString["IdAssociate"].ToString()) + "&BudgetVersion=" + ((string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["BudgetVersion"])) ? string.Empty : HttpContext.Current.Request.QueryString["BudgetVersion"].ToString()) + "&AmountScale=" + amountScale + "&IdCountry=-1");
                break;
            case ApplicationConstants.MODULE_REFORECAST:
				ResponseRedirect("~/Pages/Budget/ReforecastBudget/ReforecastBudget.aspx?IdAssociate=" + ((string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["IdAssociate"])) ? string.Empty : HttpContext.Current.Request.QueryString["IdAssociate"].ToString()) + "&BudgetVersion=" + ((string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["BudgetVersion"])) ? string.Empty : HttpContext.Current.Request.QueryString["BudgetVersion"].ToString()) + "&DisplayedData=0&AmountScale=Unit&ShowCCsWithValues=All&IdCountry=-1");
                break;
            case ApplicationConstants.MODULE_FOLLOW_UP:
                break;
            default:
                throw new NotImplementedException("Catalogue code " + budgetCode + " is undefined.");
        }

    }

    private void GridAndPanelSettings(string code)
    {
        bool isFromFollowUp = IsFromFollowUp();
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        RevisedBudget revisedBudget = new RevisedBudget(SessionManager.GetConnectionManager(this.Page));
        BudgetState = string.Empty;
        int idProject = SessionManager.GetCurrentProject(this.Page).Id;
        revisedBudget.IdProject = idProject;
        int existsValidatedInitialBudget = revisedBudget.GetEntity().ExecuteCustomProcedureWithReturnValue("CheckValidatedInitialBudget", revisedBudget);
        if (existsValidatedInitialBudget == 0)
        {
            AccessDenied = true;
            grdPreselection.Visible = false;
            pnlBudgetLayout.Visible = false;
            ErrorMessage = ApplicationMessages.EXCEPTION_INITIAL_BUDGET_VALIDATED_DOES_NOT_EXIST;
            return;
        }
        if (existsValidatedInitialBudget == 1)
        {
            //Only check the budget state if not coming from follow-up
            if (!isFromFollowUp)
            {
                switch (code)
                {
                    case ApplicationConstants.MODULE_REVISED:
                        FollowUpRevisedBudget followUpRevisedBudget = new FollowUpRevisedBudget(SessionManager.GetConnectionManager(this.Page));
                        followUpRevisedBudget.BudVersion = "N";
                        followUpRevisedBudget.IdProject = idProject;
                        followUpRevisedBudget.IdAssociate = currentUser.IdAssociate;
                        BudgetState = followUpRevisedBudget.GetRevisedBudgetStateForEvidence("GetRevisedBudgetStateForEvidence");
                        break;
                    case ApplicationConstants.MODULE_REFORECAST:
                        FollowUpCompletionBudget followUpToCompletionBudget = new FollowUpCompletionBudget(SessionManager.GetConnectionManager(this.Page));
                        followUpToCompletionBudget.BudVersion = "N";
                        followUpToCompletionBudget.IdProject = idProject;
                        followUpToCompletionBudget.IdAssociate = currentUser.IdAssociate;
                        BudgetState = followUpToCompletionBudget.GetCompletionBudgetStateForEvidence("GetCompletionBudgetStateForEvidence");
                        break;
                }
                if (BudgetState == ApplicationConstants.BUDGET_STATE_WAITING_APPROVAL)
                {
                    AccessDenied = true;
                    grdPreselection.Visible = false;
                    pnlBudgetLayout.Visible = false;
                    ErrorMessage = ApplicationMessages.EXCEPTION_BUDGET_WAITING_FOR_APPROVAL_STATE;
                    return;
                }
                else
                {
                    AccessDenied = false;
                    grdPreselection.Visible = true;
                    pnlBudgetLayout.Visible = true;
                }
            }
        }
    }

    private void InitialGridAndPanelSettings()
    {
        bool isFromFollowUp = IsFromFollowUp();

        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        InitialBudget currentBudget = new InitialBudget(SessionManager.GetConnectionManager(this));
        currentBudget.IdProject = SessionManager.GetCurrentProject(this.Page).Id;
        BudgetState = string.Empty;

        FollowUpInitialBudget followUpInitBud = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
        followUpInitBud.IdProject = currentProject.Id;
        bool isValidated = followUpInitBud.GetInitialBudgetValidState("GetInitialBudgetValidState");

        if (!isFromFollowUp)
        {
            if (isValidated)
            {
                AccessDenied = true;
                grdPreselection.Visible = false;
                pnlBudgetLayout.Visible = false;
                ErrorMessage = ApplicationMessages.EXCEPTION_INITIAL_BUDGET_VALIDATED;
                return;
            }
            else
            {
                followUpInitBud.IdProject = currentProject.Id;
                followUpInitBud.IdAssociate = currentUser.IdAssociate;
                DataSet dsState = followUpInitBud.GetInitialBudgetStateForEvidence("GetInitialBudgetStateForEvidence");
                if (dsState.Tables.Count == 1 && dsState.Tables[0].Rows.Count == 1)
                {
                    BudgetState = dsState.Tables[0].Rows[0]["StateCode"].ToString();
                }

                if (BudgetState == ApplicationConstants.BUDGET_STATE_WAITING_APPROVAL)
                {
                    AccessDenied = true;
                    grdPreselection.Visible = false;
                    pnlBudgetLayout.Visible = false;
                    ErrorMessage = ApplicationMessages.EXCEPTION_BUDGET_WAITING_FOR_APPROVAL_STATE;
                    return;
                }

                AccessDenied = false;
                grdPreselection.Visible = true;
                pnlBudgetLayout.Visible = true;
            }
        }

        currentBudget.CheckStartConditions();
        AccessDenied = false;
        grdPreselection.Visible = true;
        pnlBudgetLayout.Visible = true;
    }

    /// <summary>
    /// Populates the unused wp listbox only if not coming from followup (no need to populate the listbox when coming from follow-up
    /// because this page will not be displayed anyway)
    /// </summary>
    private void LoadUnusedWP()
    {
        //Do not populate the Unused WP Listbox if coming from follow-up
        if (IsFromFollowUp())
            return;
        
        //Get the currently selected project
        CurrentProject currentProject = (CurrentProject)SessionManager.GetSessionValueRedirect((IndBasePage)this, SessionStrings.CURRENT_PROJECT);
        //Get affected work packages
        WPPreselection wpPreselection = new WPPreselection(SessionManager.GetSessionValueRedirect(this, SessionStrings.CONNECTION_MANAGER));
        wpPreselection.IdProject = currentProject.Id;

		CurrentUser currentUser = (CurrentUser)SessionManager.GetCurrentUser(this);

		if (!IsFromFollowUp())
		{
			wpPreselection.IdAssociate = currentUser.IdAssociate;
		}
		else
		{
			int idAssociate;
			if (int.TryParse(HttpContext.Current.Request.QueryString["IdAssociate"], out idAssociate) == false)
				throw new IndException("The IdAssociate value in the QueryString is not numeric.");

			wpPreselection.IdAssociate = idAssociate;
		}

        string budgetType = GetBudgetType();

        wpPreselection.BudgetType = budgetType;
        wpPreselection.BudgetVersion = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;

        if (cmbActive.Visible)
            wpPreselection.ActiveState = cmbActive.SelectedValue;
        else
            wpPreselection.ActiveState = SHOW_ACTIVE;

        DataSet dsUnusedWP = wpPreselection.GetUnusedWP();

        LstUnusedWPDataBind(dsUnusedWP, true);
    }

    /// <summary>
    /// Binds the preselection grid to the given dataset. After binding, the grid is rebound if rebind is true
    /// and the dataset is stored into session if storeDs is true
    /// </summary>
    /// <param name="dsPreselectedWP">The dataset to which preselection grid is bound</param>
    /// <param name="rebind">Specifies if after binding, the grid is rebound</param>
    /// <param name="storeDs">Specifies if after binding, dsPreselectedWP is stored into session</param>
    private void GrdPreselectionDataBind(DataSet dsPreselectedWP, bool rebind, bool storeDs)
    {
        dsPreselectedWP.Tables[0].DefaultView.Sort = "PhaseName";
        dsPreselectedWP.Tables[1].DefaultView.Sort = "WPName";

        grdPreselection.MasterTableView.DataSource = dsPreselectedWP.Tables[0].DefaultView;
        grdPreselection.MasterTableView.DetailTables[0].DataSource = dsPreselectedWP.Tables[1].DefaultView;

        if (rebind)
            grdPreselection.Rebind();

        if (storeDs)
            SessionManager.SetSessionValue(this, DS_SELECTED_WP, dsPreselectedWP);
    }

    /// <summary>
    /// Binds the unused wp listbox to the given dataset. After binding, the dataset is stored into session if storeDs is true
    /// </summary>
    /// <param name="dsUnusedWP">The dataset to which unused wp listbox is bound</param>
    /// <param name="storeDs">Specifies if after binding, dsUnusedWP is stored into session</param>
    private void LstUnusedWPDataBind(DataSet dsUnusedWP, bool storeDs)
    {
        dsUnusedWP.Tables[0].DefaultView.Sort = "WPName";
        lstNotSelectedWPs.DataSource = dsUnusedWP.Tables[0].DefaultView;
        lstNotSelectedWPs.DataMember = dsUnusedWP.Tables[0].TableName;
        lstNotSelectedWPs.DataValueField = "UniqueKey";
        lstNotSelectedWPs.DataTextField = "WPName";
        lstNotSelectedWPs.DataBind();

        if (storeDs)
            SessionManager.SetSessionValue(this, DS_UNUSED_WP, dsUnusedWP);
    }

    private void AddWPToPreselection()
    {
        if (IsFromFollowUp())
            return;

        DataSet dsUnusedWP = (DataSet)SessionManager.GetSessionValueRedirect(this, DS_UNUSED_WP);
        DataSet dsSelectedWP = (DataSet)SessionManager.GetSessionValueRedirect(this, DS_SELECTED_WP);

        WPList selectedItems = new WPList();
        foreach (ListItem item in lstNotSelectedWPs.Items)
        {
            if (item.Selected)
            {
                for (int i = 0; i < dsUnusedWP.Tables[0].Rows.Count; i++)
                {
                    DataRow row = dsUnusedWP.Tables[0].Rows[i];
                    if (row.RowState != DataRowState.Deleted)
                    {
                        if (row["UniqueKey"].ToString() == item.Value)
                        {
                            IntercoLogicalKey key = new IntercoLogicalKey();
                            key.IdProject = (int)row["IdProject"];
                            key.IdPhase = (int)row["IdPhase"];
                            key.IdWP = (int)row["IDWP"];
                            selectedItems.Add(key);
                            row.Delete();
                        }
                    }
                }
            }
        }

        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        object connectionManager = SessionManager.GetConnectionManager(this);
        
        WPPreselection wpPreselection = new WPPreselection(connectionManager);
        wpPreselection.IdAssociate = currentUser.IdAssociate;
        wpPreselection.BudgetType = GetBudgetType();
        wpPreselection.BudgetVersion = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;
       
        DataTable newData = wpPreselection.GetPreselectionData(selectedItems);

        if (newData != null)
        {
            foreach (DataRow row in newData.Rows)
            {
                dsSelectedWP.Tables[1].ImportRow(row);

                bool found = false;
                foreach (DataRow masterRow in dsSelectedWP.Tables[0].Rows)
                {
                    if (masterRow.RowState != DataRowState.Deleted)
                    {
                        if ((int)row["IdPhase"] == (int)masterRow["IdPhase"])
                        {
                            found = true;
                            break;
                        }
                    }
                }

                if (!found) //Add a new master row
                {
                    DataRow newRow = dsSelectedWP.Tables[0].NewRow();
                    newRow["IdPhase"] = row["IdPhase"];
                    newRow["PhaseName"] = row["PhaseName"];
                    dsSelectedWP.Tables[0].Rows.Add(newRow);
                }
            }
        }

        LstUnusedWPDataBind(dsUnusedWP, true);
        GrdPreselectionDataBind(dsSelectedWP, true, true);
    }

    private void RemoveWPFromPreselection()
    {
        DataSet dsUnusedWP = (DataSet)SessionManager.GetSessionValueRedirect(this, DS_UNUSED_WP);
        DataSet dsSelectedWP = (DataSet)SessionManager.GetSessionValueRedirect(this, DS_SELECTED_WP);

        bool isWPActive;
        bool hasBudget;

        for (int i = 0; i < grdPreselection.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = grdPreselection.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridDataItem item = detailTableView.Items[j];
                //Check if the checkbox for the current item is selected
                CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                if (chkSelected == null)
                    continue;
                if (!chkSelected.Checked)
                    continue;

                if (bool.TryParse(item["IsActive"].Text, out isWPActive) == false)
                    throw new IndException("Value of 'IsActive' column must be of boolean type.");

                if (bool.TryParse(item["HasBudget"].Text, out hasBudget) == false)
                    throw new IndException("Value of 'HasBudget' column must be of boolean type.");

                //Get the key for the current item
                int currentWPId = int.Parse(item["IdWP"].Text);
                int currentPhaseId = int.Parse(item["IdPhase"].Text);
                string currentWPCode = string.Empty;
                LinkButton lnk = item["selectWPColumn"].FindControl("selectWP") as LinkButton;
                if (lnk != null)
                    currentWPCode = lnk.Text.Substring(0, 3);
                //Search the found key in the timing tab
                for (int k = 0; k < dsSelectedWP.Tables[1].Rows.Count; k++)
                {
                    DataRow row = dsSelectedWP.Tables[1].Rows[k];
                    if (row.RowState != DataRowState.Deleted)
                    {
                        int wpId = (int)row["IdWP"];
                        int phaseId = (int)row["IdPhase"];
                        {
                            //If the key is found, update the columns
                            if ((currentWPId == wpId) && (currentPhaseId == phaseId))
                            {
                                //Delete the budget information of the current wp only if the wp is active 
                                if (isWPActive && hasBudget)
                                {
                                    DeleteWPInfo(wpId, phaseId,currentWPCode);
                                }
                                SetWPUnused(row, dsUnusedWP);
                                row.Delete();
                                CheckMasterRow(phaseId, dsSelectedWP);
                            }
                        }
                    }
                }
            }
        }
        LstUnusedWPDataBind(dsUnusedWP, true);
        GrdPreselectionDataBind(dsSelectedWP, true, true);
    }
    
    /// <summary>
    /// Deletes from the db the budget information of the wp given by wpId and phaseId
    /// </summary>
    /// <param name="wpId"></param>
    /// <param name="phaseId"></param>
    private void DeleteWPInfo(int wpId, int phaseId, string wpCode)
    {
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);

        object connectionManager = SessionManager.GetConnectionManager(this);
        WPPreselection wpPreselection = new WPPreselection(connectionManager);
        wpPreselection.IdProject = currentProject.Id;
        wpPreselection.IdAssociate = currentUser.IdAssociate;
        wpPreselection.IdPhase = phaseId;
        wpPreselection.IdWP = wpId;
        wpPreselection.WPCode = wpCode;
        wpPreselection.BudgetType = GetBudgetType();

        wpPreselection.DeleteWPInfo();
    }

    /// <summary>
    /// Check if the master row has any details left. If not, delete the master row also
    /// </summary>
    /// <param name="phaseId">The Id of the phase which we are looking for</param>
    /// <param name="dsPeriod">The dataset in which we are searching</param>
    private void CheckMasterRow(int phaseId, DataSet dsSelectedWP)
    {
        //first check if there are any rows in the detail table that have the same phaseId
        foreach (DataRow row in dsSelectedWP.Tables[1].Rows)
        {
            //If any record is found then the function returns (nothing should happen)
            if ((row.RowState != DataRowState.Deleted) && ((int)row["IdPhase"] == phaseId))
                return;
        }
        //If the code reaches here than the master record doesn't have any detail rows
        DataRow masterRow = null;
        foreach (DataRow parentRow in dsSelectedWP.Tables[0].Rows)
        {
            if ((parentRow.RowState != DataRowState.Deleted) && ((int)parentRow["IdPhase"] == phaseId))
            {
                masterRow = parentRow;
                break;
            }
        }
        //Delete the master row if it is found. (Note: the master row should always be found if 
        //code reaches here
        if (masterRow != null)
            masterRow.Delete();
    }

    /// <summary>
    /// Sets the given wp (whose information is in row) as unused (copies the info into dsUnusedWP)
    /// </summary>
    /// <param name="row"></param>
    private void SetWPUnused(DataRow row, DataSet dsUnusedWP)
    {
        DataRow newRow = dsUnusedWP.Tables[0].NewRow();
        newRow["IdProject"] = row["IdProject"];
        newRow["IdWP"] = row["IdWP"];
        newRow["IdPhase"] = row["IdPhase"];
        newRow["WPName"] = row["WPName"];

        //Add the datarow to the list datasource
        dsUnusedWP.Tables[0].Rows.Add(newRow);
    }

    /// <summary>
    /// Marks all wps that do not have interco information with a different color in the grid
    /// </summary>
    /// <returns>the number of wps that do not have interco information</returns>
    private int MarkMissingInterco()
    {
        //The number of wps that do not have interco information
        int numberNoIntercoItems = 0;
        for (int i = 0; i < grdPreselection.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = grdPreselection.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridDataItem item = detailTableView.Items[j];
                //If item["HasPeriodAndInterco"] is null, throw exception
                if (item["HasPeriodAndInterco"] == null)
                    throw new IndException("Value of 'HasPeriodAndInterco' column must be of boolean type.");
                
                //Get whether the current item has interco
                bool hasPeriodOrInterco;
                //If item["HasPeriodAndInterco"].Text cannot be converted to bool, throw exception
                if (bool.TryParse(item["HasPeriodAndInterco"].Text, out hasPeriodOrInterco) == false)
                    throw new IndException("Value of 'HasPeriodAndInterco' column must be of boolean type.");

                //If this item does not have interco, set its back color and increase numberNoIntercoItems
                if (!hasPeriodOrInterco)
                {
                    item.Style.Add(HtmlTextWriterStyle.BackgroundColor, "#d3d3d3 !important");
                    numberNoIntercoItems++;
                }
            }
        }
        return numberNoIntercoItems;
    }

    /// <summary>
    /// Sets the work packages selectable or not (enabling or disabling the correspondiong checkboxes), depending on business rules
    /// </summary>
    /// <param name="budgetState"></param>
    private void SetWPSelectable(string budgetState)
    {
        bool wpSelectable = (BudgetState == ApplicationConstants.BUDGET_STATE_OPEN);
        for (int i = 0; i < grdPreselection.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = grdPreselection.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridDataItem item = detailTableView.Items[j];
                //Check if the checkbox for the current item is selected
                CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                if (chkSelected == null)
                    continue;
                
                //Make the work packages that have budget not selectable, if the budget state is open
                bool hasBudget;
                if (bool.TryParse(item["HasBudget"].Text, out hasBudget) == false)
                    throw new IndException("HasBudget column is not of bool type");
                if (hasBudget)
                {
                    chkSelected.Enabled = wpSelectable;
                }
                else
                {
                    chkSelected.Enabled = true;
                }

                //Make the work packages that have actual or revised data not selectable
                bool hasActualOrRevisedData;
                if (bool.TryParse(item["HasActualOrRevisedData"].Text, out hasActualOrRevisedData) == false)
                    throw new IndException("HasActualOrRevisedData column is not of bool type");
                if (hasActualOrRevisedData)
                {
                    chkSelected.Enabled = false;
                }
                else
                {
                    chkSelected.Enabled = true;
                }
            }
        }
    }

    /// <summary>
    /// Returns a value indicating whether this page has been requested from the follow-up budget or not
    /// </summary>
    /// <returns></returns>
    private bool IsFromFollowUp()
    {
        bool isFromFollowup = false;
        if (HttpContext.Current.Request.QueryString["IdAssociate"] != null)
        {
            isFromFollowup = true;
        }
        return isFromFollowup;
    }

    private bool IsViewAllFromFollowUp()
    {
        bool isViewALL = false;
        if (IsFromFollowUp() && int.Parse(HttpContext.Current.Request.QueryString["IdAssociate"].ToString()) 
            == ApplicationConstants.INT_NULL_VALUE)
            isViewALL = true;
        return isViewALL;
    }

    private void CheckWPBudgetInfo()
    {
        //The number of work packages with budget information
        int wpBudgetInfoNo = 0;
        //Search for work packages with budget information
        for (int i = 0; i < grdPreselection.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = grdPreselection.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridDataItem item = detailTableView.Items[j];
                //Check if the checkbox for the current item is selected
                CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                if (chkSelected == null)
                    continue;
                if (!chkSelected.Checked)
                    continue;

                bool hasBudget;
                if (bool.TryParse(item["HasBudget"].Text, out hasBudget) == false)
                    throw new IndException("Value of 'HasBudget' column must be of boolean type.");

                bool isActive;
                if (bool.TryParse(item["IsActive"].Text, out isActive) == false)
                    throw new IndException("Value of 'IsActive' column must be of boolean type.");

                //Increment the number of work packages with budget information, only if the respective wp is active
                if (hasBudget && isActive)
                    wpBudgetInfoNo++;
            }
        }

        string deleteWPScript = String.Empty;
        //If at least 1 wp has budget information (for the ones selected for removal), show a warning and postback with "DeleteWP" as argument
        //The wp's will be removed at postback
        if (wpBudgetInfoNo > 0)
        {
            deleteWPScript = "if (confirm('In the current selection there are " + wpBudgetInfoNo + " Work Package(s) that have budget information. This information will be deleted from the InProgress version. Are you sure you want to continue?')) { " + ClientScript.GetPostBackEventReference(btnDoPostback, "DeleteWP") + " }";
            if (!ClientScript.IsStartupScriptRegistered(typeof(IndBasePage), "WPBudgetInfoWarning"))
            {
                ClientScript.RegisterStartupScript(typeof(IndBasePage), "WPBudgetInfoWarning", deleteWPScript, true);
            }
        }
        //Else simply remove the wp's
        else
        {
            RemoveWPFromPreselection();
        }
    }

    /// <summary>
    /// Loads the budget layout from session and checks the expanded/collapsed radio
    /// </summary>
    private void LoadBudgetLayout()
    {
        BudgetPreselectionLayout budgetLayout = (BudgetPreselectionLayout)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.BUDGET_LAYOUT);
        //If the budget layout is not null
        if (budgetLayout != null)
        {
            //Get the budget code
            string codeParam = HttpContext.Current.Request.QueryString.Keys[0];
            string budgetCode = HttpContext.Current.Request.QueryString[codeParam];

            switch (budgetCode)
            {
                 case ApplicationConstants.MODULE_INITIAL:                  
                    radioAllCollapsed.Checked = !budgetLayout.AllExpandedInitial;
                    radioAllExpanded.Checked = budgetLayout.AllExpandedInitial;
                    break;
                case ApplicationConstants.MODULE_REVISED:
                    radioAllCollapsed.Checked = !budgetLayout.AllExpandedRevised;
                    radioAllExpanded.Checked = budgetLayout.AllExpandedRevised;
                    break;
                case ApplicationConstants.MODULE_REFORECAST:
                    radioAllCollapsed.Checked = !budgetLayout.AllExpandedReforecast;
                    radioAllExpanded.Checked = budgetLayout.AllExpandedReforecast;
                    break;
                default:
                    throw new NotImplementedException("Catalogue code " + budgetCode + " is undefined.");
            }
        }
    }

    private void RefreshIntercoInformation()
    {
        DataSet dsSelectedWP = (DataSet)SessionManager.GetSessionValueRedirect(this, DS_SELECTED_WP);
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);
        CurrentUser currentUser = SessionManager.GetCurrentUser(this);
        object connectionManager = SessionManager.GetConnectionManager(this);

        foreach (DataRow row in dsSelectedWP.Tables[1].Rows)
        {
            if (row.RowState != DataRowState.Deleted)
            {
                WPPreselection wpPreselection = new WPPreselection(connectionManager);
                wpPreselection.IdProject = currentProject.Id;
                wpPreselection.IdAssociate = currentUser.IdAssociate;
                wpPreselection.IdPhase = (int)row["IdPhase"];
                wpPreselection.IdWP = (int)row["IdWP"];
                wpPreselection.BudgetType = GetBudgetType();
                wpPreselection.BudgetVersion = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;

                DataTable dtDetails = wpPreselection.GetPreselectionData();
                
                row["PhaseName"] = dtDetails.Rows[0]["PhaseName"];
                row["WPName"] = dtDetails.Rows[0]["WPName"];
                row["StartYearMonth"] = dtDetails.Rows[0]["StartYearMonth"];
                row["EndYearMonth"] = dtDetails.Rows[0]["EndYearMonth"];
                row["HasPeriodAndInterco"] = dtDetails.Rows[0]["HasPeriodAndInterco"];
                row["HasBudget"] = dtDetails.Rows[0]["HasBudget"];
            }
        }

        GrdPreselectionDataBind(dsSelectedWP, true, true);

        RestoreCheckedWPs();
    }

    /// <summary>
    /// Stores the checked WPs (in the grid) into session
    /// </summary>
    private void StoreCheckedWPs()
    {
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);

        WPList keys = new WPList();
        for (int i = 0; i < grdPreselection.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = grdPreselection.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridDataItem item = detailTableView.Items[j];
                //Check if the checkbox for the current item is selected
                CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                if (chkSelected == null)
                    continue;
                if (!chkSelected.Checked)
                    continue;

                IntercoLogicalKey key = new IntercoLogicalKey();
                key.IdProject = currentProject.Id;
                key.IdPhase = int.Parse(item["IdPhase"].Text);
                key.IdWP = int.Parse(item["IdWP"].Text);

                keys.Add(key);
            }
        }
        SessionManager.SetSessionValue(this, CHECKED_WPS, keys);
    }

    /// <summary>
    /// Restores the checked WPs (in the grid) from the session
    /// </summary>
    private void RestoreCheckedWPs()
    {
        CurrentProject currentProject = SessionManager.GetCurrentProject(this);

        WPList keys = (WPList)SessionManager.GetSessionValueNoRedirect(this, CHECKED_WPS);
        if (keys == null)
            return;
        
        for (int i = 0; i < grdPreselection.MasterTableView.Items.Count; i++)
        {
            GridTableView detailTableView = grdPreselection.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
            for (int j = 0; j < detailTableView.Items.Count; j++)
            {
                GridDataItem item = detailTableView.Items[j];
                //Check if the checkbox for the current item is selected
                CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                if (chkSelected == null)
                    continue;

                //This ensures that a disabled checkbox will never get checked
                if (!chkSelected.Enabled)
                    continue;

                IntercoLogicalKey key = new IntercoLogicalKey();
                key.IdProject = currentProject.Id;
                key.IdPhase = int.Parse(item["IdPhase"].Text);
                key.IdWP = int.Parse(item["IdWP"].Text);

                if (keys.Contains(key))
                    chkSelected.Checked = true;
                else
                    chkSelected.Checked = false;
            }
        }
        SessionManager.RemoveValueFromSession(this, CHECKED_WPS);
    }

    /// <summary>
    /// Hides the "Next" button so that the user cannot view the budget, depending on given business rules
    /// </summary>
    private void HideNextButton()
    {
        //If there is at least one wp that does not have interco information, or the grid does not have any item (wp), hide the next button
        if (MarkMissingInterco() > 0 || grdPreselection.Items.Count == 0)
        {
            btnNext.Visible = false;
        }
        else
        {
            btnNext.Visible = true;
        }
    }
    #endregion Private Methods
}
