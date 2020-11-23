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
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using System.Collections.Generic;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.UI
{
    public partial class Pages_Budget_FollowUpBudget_FollowUpBudget : IndBasePage
    {
        #region Members
        private const string SELECTED_ITEMS = "SelectedBudgetItems";
        private bool _buttonValid = false;       
        private DataSet dsFollowInitBud = null;
        #endregion

        #region Properties
        //holds the state of the Validation Button
        private bool ButtonValid
        {
            get { return _buttonValid; }
            set { _buttonValid = value; }
        }
       
        //holds the Id of the Project
        private int _projectId;
        public int ProjectId
        {
            get { return _projectId; }
            set { _projectId = value; }
        }
        
        private string CmbTypeSelectedValue
        {
            get { return (cmbType.SelectedItem == null) ? string.Empty : cmbType.SelectedItem.Text; }
        }

        private string CmbVersionSelectedValue
        {
            get { return (cmbVersions.SelectedItem == null) ? string.Empty : cmbVersions.SelectedItem.Text; }
        }

        private CurrentUser currentUser
        {
            get {               
                    return SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER) as CurrentUser;
                }
        }

        private CurrentProject currentProject
        {
            get {
                    return SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
                }
        }

        #endregion

        #region Event Handlers
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                ProjectId = currentProject.Id;

                Permissions ViewPermission = currentUser.GetPermission(ApplicationConstants.MODULE_FOLLOW_UP, Operations.View, ProjectId);
                if (ViewPermission == Permissions.None)
                {
                    HideChildControls();
                    throw new IndException(ApplicationMessages.EXCEPTION_NO_PERMISSION_TO_VIEW_PAGE);
                }

                grdFollowUpBudget.Visible = true;
                AddAjaxSettings();

                string issuer = (string.IsNullOrEmpty(Page.Request.Params.Get("__EVENTTARGET")) ? string.Empty : Page.Request.Params.Get("__EVENTTARGET"));
                if (!Page.IsPostBack)
                {
                    //load the two combobox controls
                    LoadDropDownControls();
                    //set the project name
                    lblProjectName.Text = currentProject.Name;

                    //Load the cmb values from the query string before loading the grid
                    if ((HttpContext.Current.Request.QueryString["BudgetVersion"] != null) && (HttpContext.Current.Request.QueryString["BudgetType"] != null))
                    {
                        SelectComboValuesFromQueryString();
                    }
                  
                    LoadGrid();
                }
                else
                {
                    if (issuer.Contains("lnkChange"))
                    {
                        ResponseRedirect(Request.Url.ToString());
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
       
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                //set the enable state of valid button
                btnValidate.Enabled = ButtonValid;
                if (!ButtonValid)
                {
                    btnValidate.ImageUrl = "~/Images/button_tab_validateall_dis.png";
                    btnValidate.ImageUrlOver = "~/Images/button_tab_validateall_dis.png";
                }
                else
                {
                    btnValidate.ImageUrl = "~/Images/button_tab_validateall.png";
                    btnValidate.ImageUrlOver = "~/Images/button_tab_validateall.png";
                }
                btnValidate.OnClientClick = "if(!confirm('" + ApplicationMessages.BUDGET_PM_VALIDATE + "')) return false;";

                //set the navigation hyperlink buttons on grid
                SetGridHyperlinkUrl();
                foreach (GridColumn column in grdFollowUpBudget.MasterTableView.Columns)
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

        protected void btnValidate_Click(object sender, EventArgs e)
        {
            try
            {
                ValidateBudget();
            }
            catch (IndException ex)
            {
                HideChildControls();
                ShowError(ex);
                return;
            }
            catch (Exception ex)
            {
                HideChildControls();
                ShowError(new IndException(ex));
                return;
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                switch (cmbType.SelectedItem.Text)
                {
                    case ApplicationConstants.BUDGET_TYPE_INITIAL:
                        DeleteBudgetRows_Initial();
                        break;
                    case ApplicationConstants.BUDGET_TYPE_REVISED:
                        DeleteBudgetRows_Revised();
                        break;
                    case ApplicationConstants.BUDGET_TYPE_TOCOMPLETION:
                        DeleteBudgetRows_ToCompletion();
                        break;
                    default:
                        DeleteBudgetRows_Initial();
                        break;
                }
                LoadGrid();
            }
            catch (IndException ex)
            {
                HideChildControls();
                ShowError(ex);
                return;
            }
            catch (Exception ex)
            {
                HideChildControls();
                ShowError(new IndException(ex));
                return;
            }
        }

		protected void grdFollowUpBudget_PreRender(object sender, EventArgs e)
		{
			foreach (GridColumn col in grdFollowUpBudget.MasterTableView.Columns)
			{
				if (col.UniqueName == "CopyCol")
				{
					col.Visible = IsCopyBudgetButtonEnable();
				}
			}

		} 
		
        protected void grdFollowUpBudget_ItemCreated(object sender, GridItemEventArgs e)
        {
            try
            {
                string budgetVersion = ReturnBudgetVersionFromCombo();
                if (!IsDeleteButtonEnable())
                {
                    if (e.Item is GridFooterItem)
                    {
                        GridFooterItem commandItem = e.Item as GridFooterItem;
                        IndImageButton button = commandItem.FindControl("btnDelete") as IndImageButton;
                        button.Enabled = false;

                        button.ImageUrl = ResolveUrl("~/Images/buttons_delete_disabled.png");
                    }
                    if (e.Item is GridItem)
                    {
                        GridItem itm = e.Item as GridItem;
                        CheckBox ck = itm.FindControl("chkDeleteCol") as CheckBox;
                        if (ck != null)
                            ck.Enabled = false;
                    }
                }
                if (e.Item is GridFooterItem)
                {
                    GridFooterItem commandItem = e.Item as GridFooterItem;
                    LinkButton navigateAll = commandItem.FindControl("btnNavigateAll") as LinkButton;
                    if (IsBATAOrPM(currentUser) || IsFunctionalManager(currentUser))
                    {

                        switch (CmbTypeSelectedValue)
                        {
                            case ApplicationConstants.BUDGET_TYPE_INITIAL:
                                navigateAll.PostBackUrl = "~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_INITIAL + "&IdAssociate=" + ApplicationConstants.INT_NULL_VALUE + "&BudgetVersion=" + budgetVersion + "&IsFromFollowUp=1";
                                break;
                            case ApplicationConstants.BUDGET_TYPE_REVISED:
								navigateAll.PostBackUrl = "~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REVISED + "&IdAssociate=" + ApplicationConstants.INT_NULL_VALUE + "&BudgetVersion=" + budgetVersion + "&IsFromFollowUp=1";
                                break;
                            case ApplicationConstants.BUDGET_TYPE_TOCOMPLETION:
								navigateAll.PostBackUrl = "~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST + "&IdAssociate=" + ApplicationConstants.INT_NULL_VALUE + "&BudgetVersion=" + budgetVersion + "&IsFromFollowUp=1";
                                break;
                            default:
                                navigateAll.PostBackUrl = "~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_INITIAL + "&IdAssociate=" + ApplicationConstants.INT_NULL_VALUE;
                                break;
                        }
                        navigateAll.PostBackUrl += "&BudgetType=" + (cmbType.SelectedIndex - 1);
                    }
                    else
                        navigateAll.Visible = false;
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

        protected void cmbType_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                if (cmbType.SelectedItem.Text == ApplicationConstants.BUDGET_TYPE_INITIAL)
                    LoadVersionCombo(true);
                else
                    LoadVersionCombo(false);

                LoadGrid();
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

       

        protected void cmbVersions_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                cmbVersionsChanged();
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
        /// Hides the controls from the screen
        /// </summary>
        protected override void HideChildControls()
        {
            this.grdFollowUpBudget.Visible = false;
            lblProject.Visible = false;
            lblProjectName.Visible = false;
            lblType.Visible = false;
            cmbType.Visible = false;
            lblVersions.Visible = false;
            cmbVersions.Visible = false;
            btnValidate.Visible = false;
        }
        #endregion Event Handlers

        #region Private Methods
        /// <summary>
        /// Applys the columns css class
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
            int index = grdFollowUpBudget.Columns.IndexOf(currentColumn);
            int visibleIndex = 0;
            foreach (GridColumn column in grdFollowUpBudget.Columns)
            {
                if (column is GridColumn && column.Display)
                {
                    if (grdFollowUpBudget.Columns.IndexOf(column) < index)
                    {
                        visibleIndex++;
                    }
                }
            }
            return visibleIndex;
        }
        private void AddAjaxSettings()
        {
            //get the ajax manager from the page
            RadAjaxManager ajaxManager = GetAjaxManager();
            ajaxManager.EnableAJAX = false; 
        }

        private void SetGridHyperlinkUrl()
        {
            string budgetVersion = ReturnBudgetVersionFromCombo();
            GridDataItemCollection itemCollection = grdFollowUpBudget.Items;
            foreach (GridItem gridItem in itemCollection)
            {
                if (gridItem is GridEditableItem)
                {
                    GridEditableItem item = gridItem as GridEditableItem;

                    HyperLink gridHyperlink = item["NavigateCol"].FindControl("btnNavigate") as HyperLink;
					HyperLink copyBudget = item["CopyCol"].FindControl("btnCopyBudget") as HyperLink;
                    int idAssociate = ApplicationConstants.INT_NULL_VALUE;
                    int.TryParse(item["IdAssociate"].Text, out idAssociate);
                    string cmbTypeSelectedValue = CmbTypeSelectedValue;
                    switch (cmbTypeSelectedValue)
                    {
                        case ApplicationConstants.BUDGET_TYPE_INITIAL:
							gridHyperlink.NavigateUrl = "~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_INITIAL + "&IdAssociate=" + idAssociate + "&BudgetVersion=" + budgetVersion + "&IsFromFollowUp=1"; 
                            break;
                        case ApplicationConstants.BUDGET_TYPE_REVISED:
							gridHyperlink.NavigateUrl = "~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REVISED + "&IdAssociate=" + idAssociate + "&BudgetVersion=" + budgetVersion + "&IsFromFollowUp=1";
							copyBudget.NavigateUrl = "~/Pages/Budget/CopyBudget/CopyBudget.aspx?Code=" + ApplicationConstants.MODULE_REVISED + "&IdAssociate=" + idAssociate + "&BudgetVersion=" + budgetVersion;
                            break;
                        case ApplicationConstants.BUDGET_TYPE_TOCOMPLETION:
							gridHyperlink.NavigateUrl = "~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST + "&IdAssociate=" + idAssociate + "&BudgetVersion=" + budgetVersion + "&IsFromFollowUp=1";
							copyBudget.NavigateUrl = "~/Pages/Budget/CopyBudget/CopyBudget.aspx?Code=" + ApplicationConstants.MODULE_REFORECAST + "&IdAssociate=" + idAssociate + "&BudgetVersion=" + budgetVersion;
                            break;
                        default:
                            gridHyperlink.NavigateUrl = "~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=" + ApplicationConstants.MODULE_INITIAL + "&IdAssociate=" + idAssociate;
                            break;
                    }
                    gridHyperlink.NavigateUrl += "&BudgetType=" + (cmbType.SelectedIndex-1);
					copyBudget.NavigateUrl += "&BudgetType=" + (cmbType.SelectedIndex - 1);
                }
                
            }
            
        }

        private bool IsDeleteButtonEnable()
        {
            bool returnState = false;
            //enable Delete button only for Project Manager of the project
            if (!IsBATAOrPM(currentUser))
            {
                return false;               
            }

            string budgetVersionText = CmbVersionSelectedValue;
            if ((budgetVersionText == ApplicationConstants.BUDGET_VERSION_IN_PROGRESS) && !IsValidated())
            {
                returnState = true;
            }
            return returnState;
        }
        
        private bool IsCopyBudgetButtonEnable()
        {
			bool returnState = false;
			
        	if (!IsBA(currentUser)) 
        	{
        		return false;
        	}

			string budgetTypeText = CmbTypeSelectedValue;
			string budgetVersionText = CmbVersionSelectedValue;
			if (budgetTypeText != ApplicationConstants.BUDGET_TYPE_INITIAL && 
				budgetVersionText == ApplicationConstants.BUDGET_VERSION_IN_PROGRESS)
			{
				returnState = true;
			}
			return returnState;
        }

        private bool IsValidated()
        {
            bool isValidated = false;
            switch (CmbTypeSelectedValue)
            {
                case ApplicationConstants.BUDGET_TYPE_INITIAL:
                    isValidated = GetBudgetIsValidState_Initial();
                    break;
                case ApplicationConstants.BUDGET_TYPE_REVISED:
                    isValidated = GetBudgetIsValidState_Revised();
                    break;
                case ApplicationConstants.BUDGET_TYPE_TOCOMPLETION:
                    isValidated = GetBudgetIsValidState_ToCompletion();
                    break;
                //default:                    
                    //throw new IndException("Unknown budget type: " + CmbTypeSelectedValue);
                   
            }
            return isValidated;
        }

        private bool GetBudgetIsValidState_Initial()
        {
            FollowUpInitialBudget followUpInitBud = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpInitBud.IdProject = ProjectId;
            return followUpInitBud.GetInitialBudgetValidState("GetInitialBudgetValidState");
        }

        private bool GetBudgetIsValidState_Revised()
        {
            FollowUpRevisedBudget followUpRevisedBudget = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpRevisedBudget.IdProject = ProjectId;
            followUpRevisedBudget.BudVersion = ReturnBudgetVersionFromCombo();
            return followUpRevisedBudget.GetRevisedBudgetValidState("GetRevisedScalarValidState");
        }

        private bool GetBudgetIsValidState_ToCompletion()
        {
            FollowUpCompletionBudget followUpCompletionBudget = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpCompletionBudget.IdProject = ProjectId;
            followUpCompletionBudget.BudVersion = ReturnBudgetVersionFromCombo();
            return followUpCompletionBudget.GetCompletionBudgetValidState("GetCompletionScalarValidState");
        }

        private void ValidateBudget()
        {
            switch (CmbTypeSelectedValue)
            {
                case ApplicationConstants.BUDGET_TYPE_INITIAL:
                    ValidateInitialBudget();
                    break;
                case ApplicationConstants.BUDGET_TYPE_REVISED:
                    ValidateRevisedBudget();
                    break;
                case ApplicationConstants.BUDGET_TYPE_TOCOMPLETION:
                    ValidateToCompletionBudget();
                    break;
                default:
                    throw new NotSupportedException("ValidateBudget: Unknown budget type " + CmbTypeSelectedValue + ".");
            }


            //Disable validate button
            ButtonValid = false;
            LoadGrid();
        }

        private void ValidateInitialBudget()
        {
            FollowUpInitialBudget followUpInitBud = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpInitBud.IdProject = ProjectId;
            followUpInitBud.ValidateInitialBudget("ValidateInitialBudget");            
        }

        private void ValidateRevisedBudget()
        {
            object conMan = SessionManager.GetConnectionManager(this);
            FollowUpRevisedBudget followUpRevisedBudget = new FollowUpRevisedBudget(conMan);
            followUpRevisedBudget.IdProject = ProjectId;
            followUpRevisedBudget.BudVersion = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;

            followUpRevisedBudget.ValidateRevisedBudget("ValidateRevisedBudget");
            cmbVersions.FindItemByText(EBudgetVersion.Released.ToString()).Selected=true;

        }

        private void ValidateToCompletionBudget()
        {
            object conMan = SessionManager.GetConnectionManager(this);
            FollowUpCompletionBudget followUpCompletion = new FollowUpCompletionBudget(conMan);
            followUpCompletion.IdProject = ProjectId;
            followUpCompletion.BudVersion = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;

            followUpCompletion.ValidateCompletionBudget("ValidateCompletionBudget");
            cmbVersions.FindItemByText(EBudgetVersion.Released.ToString()).Selected = true;
        }

        private void GetSelectedCheckboxes()
        {
            GridTableView grdTableVw = grdFollowUpBudget.MasterTableView;
            GridDataItemCollection itemCollection = grdTableVw.Items;
            Dictionary<int, bool> selectedItems = new Dictionary<int, bool>();
            foreach (GridItem gridItem in itemCollection)
            {
                if (!(gridItem is GridEditableItem))
                    continue;
                GridEditableItem item = gridItem as GridEditableItem;

                //CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                CheckBox chkSelected = item["SelectBudgetCol"].FindControl("chkDeleteCol") as CheckBox;
                if (chkSelected == null)
                    continue;
                if (!chkSelected.Checked)
                    continue;
                int idAssociate = ApplicationConstants.INT_NULL_VALUE;
                if (int.TryParse(item["IdAssociate"].Text, out idAssociate))
                    selectedItems.Add(idAssociate, true);
            }
            SessionManager.SetSessionValue(this, SELECTED_ITEMS, selectedItems);
        }

        private void RestoreSelectedItems()
        {
            Dictionary<int, bool> selectedItems = SessionManager.GetSessionValueNoRedirect(this, SELECTED_ITEMS) as Dictionary<int, bool>;
            if (selectedItems == null)
                return;

            foreach (KeyValuePair<int, bool> pair in selectedItems)
            {
                int idAssociate = pair.Key;
                GridTableView grdTableVw = grdFollowUpBudget.MasterTableView;
                GridDataItemCollection itemCollection = grdTableVw.Items;
                foreach (GridItem gridItem in itemCollection)
                {
                    if (!(gridItem is GridEditableItem))
                        continue;
                    GridEditableItem item = gridItem as GridEditableItem;

                    //CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                    CheckBox chkSelected = item["SelectBudgetCol"].FindControl("chkDeleteCol") as CheckBox;
                    if (chkSelected == null)
                        continue;
                    int currentAssociate = ApplicationConstants.INT_NULL_VALUE;
                    if (int.TryParse(item["IdAssociate"].Text, out currentAssociate))
                        if (currentAssociate == idAssociate)
                            chkSelected.Checked = true;
                }
            }
        }

        private string ReturnBudgetVersionFromCombo()
        {           
            string result = string.Empty;
            switch (CmbVersionSelectedValue)
            {
                case ApplicationConstants.BUDGET_VERSION_IN_PROGRESS:
                    result = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;
                    break;
                case ApplicationConstants.BUDGET_VERSION_PREVIOUS:
                    result = ApplicationConstants.BUDGET_VERSION_PREVIOUS_CODE;
                    break;
                case ApplicationConstants.BUDGET_VERSION_RELEASED:
                    result = ApplicationConstants.BUDGET_VERSION_RELEASED_CODE;
                    break;
            }
            return result;
        }

        private void LoadDropDownControls()
        {
            LoadTypeCombo();
            LoadVersionCombo(false);
        }
        private void LoadTypeCombo()
        {
            cmbType.Items.Clear();
            cmbType.Items.Add(new RadComboBoxItem("", "0"));
            cmbType.DataSource = Enum.GetValues(typeof(EBudgetType));
            cmbType.DataBind();
            cmbType.SelectedIndex = 0;
        }

        private void LoadVersionCombo(bool forInitialBudget)
        {
            cmbVersions.Items.Clear();
            if (!forInitialBudget)
            {
                cmbVersions.DataSource = Enum.GetValues(typeof(EBudgetVersion));
                cmbVersions.Visible = true;
                lblVersions.Visible = true;
            }
            else
            {
                ArrayList source = new ArrayList();
                source.Add(EBudgetVersion.InProgress.ToString());
                cmbVersions.DataSource = source;
                cmbVersions.Visible = false;
                lblVersions.Visible = false;
            }
            cmbVersions.DataBind();

            cmbVersions.SelectedIndex = 0;
        }

        private void LoadGrid()
        {
            switch (CmbTypeSelectedValue)
            {
                case ApplicationConstants.BUDGET_TYPE_INITIAL:
                    LoadGrid_Initial();
                    break;
                case ApplicationConstants.BUDGET_TYPE_REVISED:
                    LoadGrid_Revised();
                    break;
                case ApplicationConstants.BUDGET_TYPE_TOCOMPLETION:
                    LoadGrid_ToCompletion();
                    break;
                default:
                    LoadGridNull();
                    break;
            }

        }

        private void LoadGrid_Initial()
        {
            FollowUpInitialBudget flpInitBud = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

            flpInitBud.IdProject = ProjectId;
            dsFollowInitBud = flpInitBud.GetAll(true);

            if (dsFollowInitBud != null)
            {
                if (dsFollowInitBud.Tables[0].Rows.Count > 0)
                {
                    grdFollowUpBudget.DataSource = dsFollowInitBud.Tables[0];
                    grdFollowUpBudget.DataBind();
                    //Set Validation enable state only for PM
                    if (IsBATAOrPM(currentUser))
                    {
                        ButtonValid = IsBudgetValidateable(dsFollowInitBud);
                    }
                }
                else
                {
                    LoadGridNull();
                    throw new IndException(string.Format(ApplicationMessages.EXCEPTION_BUDGET_INTIAL_MISSING_FOR_VERSION, cmbVersions.SelectedItem.Text, cmbType.SelectedItem.Text));

                }
            }
            else
            {
                throw new IndException(string.Format(ApplicationMessages.EXCEPTION_BUDGET_INTIAL_MISSING_FOR_VERSION, cmbVersions.SelectedItem.Text, cmbType.SelectedItem.Text));
            }
        }



        private void LoadGrid_Revised()
        {
            DataSet dsRevisedBudget = null;
            FollowUpRevisedBudget flpRevisedBudget = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

            string budgetVersion = ReturnBudgetVersionFromCombo();
            flpRevisedBudget.BudVersion = budgetVersion;
            flpRevisedBudget.IdProject = currentProject.Id;
            dsRevisedBudget = flpRevisedBudget.GetAll(true);

            if (dsRevisedBudget != null)
            {
                if (dsRevisedBudget.Tables[0].Rows.Count > 0)
                {
                    grdFollowUpBudget.DataSource = dsRevisedBudget.Tables[0];
                    grdFollowUpBudget.DataBind();

                    //Set Validation enable state only for PM
                    if (IsBATAOrPM(currentUser))
                    {
                        ButtonValid = IsBudgetValidateable(dsRevisedBudget);
                    }
                }
                else
                {
                    LoadGridNull();
                    ButtonValid = false;
                    throw (new IndException(string.Format(ApplicationMessages.EXCEPTION_BUDGET_REVISED_MISSING_FOR_VERSION, cmbVersions.SelectedItem.Text, cmbType.SelectedItem.Text)));                  
                }
            }
        }


        private void LoadGrid_ToCompletion()
        {
            DataSet dsCompletionBudget = null;
            FollowUpCompletionBudget flpCompletionBudget = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

            string budgetVersion = ReturnBudgetVersionFromCombo();
            flpCompletionBudget.BudVersion = budgetVersion;
            flpCompletionBudget.IdProject = currentProject.Id;
            dsCompletionBudget = flpCompletionBudget.GetAll(true);

            if (dsCompletionBudget != null)
            {
                if (dsCompletionBudget.Tables[0].Rows.Count > 0)
                {
                    grdFollowUpBudget.DataSource = dsCompletionBudget.Tables[0];
                    grdFollowUpBudget.DataBind();

                    //Set Validation enable state only for PM
                    if (IsBATAOrPM(currentUser))
                    {
                        ButtonValid = IsBudgetValidateable(dsCompletionBudget);
                    }
                }
                else
                {
                    LoadGridNull();
                    ButtonValid = false;
                    throw new IndException(string.Format(ApplicationMessages.EXCEPTION_BUDGET_COMPLETION_MISSING_FOR_VERSION, cmbVersions.SelectedItem.Text, cmbType.SelectedItem.Text));                   

                }
            }
        }

        /// <summary>
        /// Returns a value indicating whether this budget can be validated or not
        /// </summary>
        /// <param name="dsCompletionBudget">the dataset of the grid which we will iterate through</param>
        /// <returns>A value indicating whether this budget can be validated or not</returns>
        private bool IsBudgetValidateable(DataSet dsBudget)
        {
            //Shows whether there is at least one user with budget having status Waiting for approval or approved
            bool existsSubmittedBudget = false;
            //Shows whether there is at least one user with budget having status Open
            bool existsOpenBudget = false;
            foreach (DataRow row in dsBudget.Tables[0].Rows)
            {
                if (((row["StateCode"].ToString() == ApplicationConstants.BUDGET_STATE_WAITING_APPROVAL) ||
                    (row["StateCode"].ToString() == ApplicationConstants.BUDGET_STATE_APPROVED)))
                {
                    existsSubmittedBudget = true;
                }
                if (row["StateCode"].ToString() == ApplicationConstants.BUDGET_STATE_OPEN)
                {
                    existsOpenBudget = true;
                }
            }
            return existsSubmittedBudget && !existsOpenBudget;
        }

        private void DeleteBudgetRows_Initial()
        {           
            GridTableView grdTableVw = grdFollowUpBudget.MasterTableView;
            GridDataItemCollection itemCollection = grdTableVw.Items;
            foreach (GridItem gridItem in itemCollection)
            {
                if (!(gridItem is GridEditableItem))
                    continue;
                GridEditableItem item = gridItem as GridEditableItem;

                CheckBox chkSelected = item["SelectBudgetCol"].FindControl("chkDeleteCol") as CheckBox;
                if (chkSelected == null)
                    continue;
                if (!chkSelected.Checked)
                    continue;
                int idAssociate = ApplicationConstants.INT_NULL_VALUE;
                int.TryParse(item["IdAssociate"].Text, out idAssociate);
                
                FollowUpInitialBudget flpInitBudget = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
                flpInitBudget.DeleteBudgetRows(currentProject.Id, idAssociate);
             

            }
        }

        private void DeleteBudgetRows_Revised()
        {            
            GridTableView grdTableVw = grdFollowUpBudget.MasterTableView;
            GridDataItemCollection itemCollection = grdTableVw.Items;
            foreach (GridItem gridItem in itemCollection)
            {
                if (!(gridItem is GridEditableItem))
                    continue;
                GridEditableItem item = gridItem as GridEditableItem;

                CheckBox chkSelected = item["SelectBudgetCol"].FindControl("chkDeleteCol") as CheckBox;
                if (chkSelected == null)
                    continue;
                if (!chkSelected.Checked)
                    continue;
                int idAssociate = ApplicationConstants.INT_NULL_VALUE;
                int.TryParse(item["IdAssociate"].Text, out idAssociate);

                FollowUpRevisedBudget followUpRevisedBudget = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
                followUpRevisedBudget.DeleteBudgetRows(currentProject.Id, idAssociate, ReturnBudgetVersionFromCombo());
            }
        }

        private void DeleteBudgetRows_ToCompletion()
        {
            GridTableView grdTableVw = grdFollowUpBudget.MasterTableView;
            GridDataItemCollection itemCollection = grdTableVw.Items;
            foreach (GridItem gridItem in itemCollection)
            {
                if (!(gridItem is GridEditableItem))
                    continue;
                GridEditableItem item = gridItem as GridEditableItem;

                CheckBox chkSelected = item["SelectBudgetCol"].FindControl("chkDeleteCol") as CheckBox;
                if (chkSelected == null)
                    continue;
                if (!chkSelected.Checked)
                    continue;
                int idAssociate = ApplicationConstants.INT_NULL_VALUE;
                int.TryParse(item["IdAssociate"].Text, out idAssociate);

                FollowUpCompletionBudget followUpCompletionBudget = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
                followUpCompletionBudget.DeleteBudgetRows(currentProject.Id, idAssociate, ReturnBudgetVersionFromCombo());
               
            }
        }
    

        private void LoadGridNull()
        {
            grdFollowUpBudget.Visible = false;
        }

        private bool IsBATAOrPM(CurrentUser currentUser)
        {
            return (currentUser.ProgramManagerProjects.ContainsKey(currentProject.Id) ||
                    currentUser.UserRole.Id == ApplicationConstants.ROLE_TECHNICAL_ADMINISTATOR ||
                    currentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR);
        }

        private bool IsFunctionalManager(CurrentUser currentUser)
        {
            return (currentUser.UserRole.Id == ApplicationConstants.ROLE_FUNCTIONAL_MANAGER);
        }

		private bool IsBA(CurrentUser currentUser)
		{
			if (currentUser == null)
			{
				return false;
			}
			return (currentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR);
		}
		
        #endregion

        #region Events

        private void cmbVersionsChanged()
        {
            if (CmbTypeSelectedValue == ApplicationConstants.BUDGET_TYPE_INITIAL && CmbTypeSelectedValue != ApplicationConstants.BUDGET_VERSION_IN_PROGRESS)
            {
                LoadGridNull();
                throw new IndException(string.Format(ApplicationMessages.EXCEPTION_BUDGET_INTIAL_MISSING_FOR_VERSION, CmbVersionSelectedValue, CmbTypeSelectedValue));                
            }
            LoadGrid();

        }

        private void SelectComboValuesFromQueryString()
        {
            string budgetType = HttpContext.Current.Request.QueryString["BudgetType"];
            int selectedIndex = (int.Parse(budgetType) > 3) ? 3 : int.Parse(budgetType) + 1;
            cmbType.SelectedIndex = selectedIndex;

            string budgetVersion = HttpContext.Current.Request.QueryString["BudgetVersion"];
            switch (budgetVersion)
            {
                case ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE:
                    cmbVersions.SelectedIndex = (int)EBudgetVersion.InProgress;
                    break;
                case ApplicationConstants.BUDGET_VERSION_RELEASED_CODE:
                    cmbVersions.SelectedIndex = (int)EBudgetVersion.Released;
                    break;
                case ApplicationConstants.BUDGET_VERSION_PREVIOUS_CODE:
                    cmbVersions.SelectedIndex = (int)EBudgetVersion.Previous;
                    break;
            }
            //if initial
            if (budgetType == "0")
            {
                cmbVersions.Visible = false;
                lblVersions.Visible = false;
            }
        }
        #endregion Private Methods
    }
}