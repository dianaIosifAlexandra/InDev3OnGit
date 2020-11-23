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
using Telerik.WebControls;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.ApplicationFramework;
using System.Drawing;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic.Catalogues;
using System.Collections.Generic;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.Entities;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework.Timing_Interco;
using Inergy.Indev3.Entities.Budget;


public partial class UserControls_Budget_Interco_TimingAndInterco : IndBasePage
{
   
    private ArrayList hiddenColumns = new ArrayList();
    private DataSet dsPeriod = null;
    private DataSet dsInterco = null;
    private DataSet dsUnaffectedWP = null;
    private DataSet dsCountries = null;

    private const string PERIOD_DATASET = "PeriodDS";
    private const string INTERCO_DATASET = "IntercoDS";
    private const string UNAFFECTED_WP_DATASET = "UnaffectedDS";
    private const string SELECTED_ITEMS = "SelectedIntercoItems";
    private const string EDITED_WPS_PERIOD = "EditedWPsPeriod";
    private const string EDITED_WPS_INTERCO = "EditedWPsInterco";

    private bool IsPopUp;

    private bool ShouldStoreWPSelection = true;

    private Permissions ViewPermission;
    private Permissions EditPermission;
    private Permissions DeletePermission;

    #region Page Events
    protected override void OnPreInit(EventArgs e)
    {
        try
        {
            IsPopUp = false;
            if (HttpContext.Current.Request.QueryString["PopUp"] != null)
            {
                this.MasterPageFile = "~/PopUp.master";
                IsPopUp = true;
            }
            base.OnPreInit(e);
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


    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!ClientScript.IsStartupScriptRegistered(this.GetType(), "RestoreCheckBoxes"))
                ClientScript.RegisterStartupScript(this.GetType(), "RestoreCheckBoxes", "RestoreCheckBoxes();", true);
            CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER);

            int idProject = SessionManager.GetCurrentProject(this).Id;
            ViewPermission = currentUser.GetPermission(ApplicationConstants.MODULE_TIMING_INTERCO, Operations.View, idProject);
            EditPermission = currentUser.GetPermission(ApplicationConstants.MODULE_TIMING_INTERCO, Operations.Edit, idProject);
            DeletePermission = currentUser.GetPermission(ApplicationConstants.MODULE_TIMING_INTERCO, Operations.Delete, idProject);

            if (ViewPermission == Permissions.None)
            {
                HideChildControls();
                throw new IndException(ApplicationMessages.EXCEPTION_NO_PERMISSION_TO_VIEW_PAGE);
            }

            if (EditPermission == Permissions.None)
            {
                lstUnaffectedWP.Enabled = false;
                btnAddCountry.Enabled = false;
                btnAddCountry.ImageUrl = "~/Images/button_tab_add_down_disabled.png";
                btnAddCountry.ImageUrlOver = "~/Images/button_tab_add_down_disabled.png";
                btnAddWP.Enabled = false;
                btnAddWP.ImageUrl = "~/Images/button_tab_add_toright_disabled.png";
                btnAddWP.ImageUrlOver = "~/Images/button_tab_add_toright_disabled.png";
                cmbCountries.Enabled = false;
                btnSave.Enabled = false;
                btnSave.ImageUrl = "~/Images/button_tab_save_disabled.png";
                btnSave.ImageUrlOver = "~/Images/button_tab_save_disabled.png";
            }
            else
            {
                lstUnaffectedWP.Enabled = true;
                btnAddCountry.Enabled = true;
                btnAddCountry.ImageUrl = "~/Images/button_tab_add_down.png";
                btnAddCountry.ImageUrlOver = "~/Images/button_tab_add_down.png";
                btnAddWP.Enabled = true;
                btnAddWP.ImageUrl = "~/Images/button_tab_add_toright.png";
                btnAddWP.ImageUrlOver = "~/Images/button_tab_add_toright.png";
                cmbCountries.Enabled = true;
                btnSave.Enabled = true;
                btnSave.ImageUrl = "~/Images/button_tab_save.png";
                btnSave.ImageUrlOver = "~/Images/button_tab_save.png";
                btnAddCountry.ToolTip = "Add Country";
                btnAddWP.ToolTip = "Add Work Package";
                btnSave.ToolTip = "Save";
            }

            RadAjaxManager ajaxManager = GetAjaxManager();

            Panel phErrors = (Panel)Master.FindControl("pnlErrors");
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSave, phErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnAddWP, lstUnaffectedWP);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnAddWP, tabPeriod);

            ajaxManager.AjaxSettings.AddAjaxSetting(btnNext, MultiPageContainer);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnNext, tabStripInterco);

            ajaxManager.AjaxSettings.AddAjaxSetting(btnBack, tabStripInterco);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnBack, tabPeriod);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnBack, MultiPageContainer);
            ajaxManager.AjaxSettings.AddAjaxSetting(grdInterco, hdnIsDirty);
            ajaxManager.AjaxSettings.AddAjaxSetting(grdPeriod, hdnIsDirty);

            ajaxManager.AjaxSettings.AddAjaxSetting(PeriodMassAttr.FindControl("saveButton"), PeriodMassAttr.FindControl("tableErrorMessages"));
            ajaxManager.AjaxSettings.AddAjaxSetting(PeriodMassAttr.FindControl("saveButton"), grdPeriod);
            ajaxManager.AjaxSettings.AddAjaxSetting(PeriodMassAttr.FindControl("cancelButton"), PeriodMassAttr.FindControl("tableErrorMessages"));
            ajaxManager.AjaxSettings.AddAjaxSetting(PeriodMassAttr.FindControl("closeButton"), PeriodMassAttr.FindControl("tableErrorMessages"));

            ajaxManager.AjaxSettings.AddAjaxSetting(PeriodMassAttr, this);

            btnAddWP.Attributes.Add("OnClick", "return VerifySelectedItems('" + lstUnaffectedWP.ClientID + "');");

            hiddenColumns.Add("IdProject");
            hiddenColumns.Add("IdPhase");
            hiddenColumns.Add("IdWP");

            bool refreshUnaffectedWP = false;
            //If the control that caused the postback is the mainmenu or the refresh button, reload the data from the DB
            if (IsPostBack)
            {
                string issuer = Page.Request.Params.Get("__EVENTTARGET");
                if (issuer.Contains("mnuMain") || issuer.Contains("btnRefresh") || issuer.Contains("lnkChange") || issuer.Contains("btnDoPostback"))
                {
                    dsUnaffectedWP = null;
                    dsPeriod = null;
                    dsInterco = null;
                    SessionManager.RemoveValueFromSession(this, UNAFFECTED_WP_DATASET);
                    SessionManager.RemoveValueFromSession(this, PERIOD_DATASET);
                    SessionManager.RemoveValueFromSession(this, INTERCO_DATASET);
                    refreshUnaffectedWP = true;
                }
                else
                {
                    dsUnaffectedWP = SessionManager.GetSessionValueNoRedirect(this, UNAFFECTED_WP_DATASET) as DataSet;
                    dsPeriod = SessionManager.GetSessionValueNoRedirect(this, PERIOD_DATASET) as DataSet;
                    dsInterco = SessionManager.GetSessionValueNoRedirect(this, INTERCO_DATASET) as DataSet;
                }
                if (Page.Request.Params.Get("__EVENTARGUMENT") == "ColumnsReorder")
                    ReorderColumns();
            }

            TimingAndInterco interco = new TimingAndInterco(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            CurrentProject currentProject = SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;

            if (dsUnaffectedWP == null)
            {
                interco.IdProject = currentProject.Id;
                dsUnaffectedWP = interco.GetUnnaffectedWP();
                SessionManager.SetSessionValue(this, UNAFFECTED_WP_DATASET, dsUnaffectedWP);
            }

            if (dsInterco == null)
            {
                dsInterco = interco.GetAffectedWPInterco();
                DataColumn isChangedCol = new DataColumn("IsChanged", typeof(bool));
                isChangedCol.DefaultValue = false;
                dsInterco.Tables[1].Columns.Add(isChangedCol);
                SessionManager.SetSessionValue(this, INTERCO_DATASET, dsInterco);
            }

            if (dsPeriod == null)
            {
                dsPeriod = interco.GetAffectedWPTiming();
                DataColumn isChangedCol = new DataColumn("IsChanged", typeof(bool));
                isChangedCol.DefaultValue = false;
                dsPeriod.Tables[1].Columns.Add(isChangedCol);
                SessionManager.SetSessionValue(this, PERIOD_DATASET, dsPeriod);
            }

            if ((!IsPostBack) || (refreshUnaffectedWP))
            {
                FillUnaffectedWP();
                grdPeriod.Rebind();
                grdInterco.Rebind();
            }
        }
        catch (IndException exc)
        {
            ShowError(exc);
            HideChildControls();
            PageLoadSucceeded = false;
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            HideChildControls();
            PageLoadSucceeded = false;
            return;
        }
    }

    protected override void HideChildControls()
    {
        tabStripInterco.Visible = false;
        lstUnaffectedWP.Visible = false;
        grdPeriod.Visible = false;
        grdInterco.Visible = false;

        btnAddCountry.Visible = false;
        btnAddWP.Visible = false;
        btnBack.Visible = false;
        btnNext.Visible = false;
        btnSave.Visible = false;

        cmbCountries.Visible = false;

        lblUnaffected.Visible = false;
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            grdPeriod.Visible = false;
            tabStripInterco.SelectedIndex = 1;
            tabInterco.Selected = true;
            FillCountryCombo();
            grdInterco.Visible = true;

            RemoveRowsFromEditMode(grdPeriod);
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

    protected void btnBack_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            grdInterco.Visible = false;
            grdPeriod.Visible = true;
            tabStripInterco.SelectedIndex = 0;
            tabPeriod.Selected = true;

            RemoveRowsFromEditMode(grdInterco);
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

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            //Create the new country layout. This should be created even there are no modifications made to the WPs
            CurrentProject project = SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;

            GridTableView detailTableView = grdInterco.MasterTableView.DetailTables[0];
            TIList intercos = CreateIntercosList();

            if (intercos == null)
                return;


            //Validate each interco that has not been deleted
            foreach (TimingAndInterco interco in intercos)
            {
                if (interco.State != EntityState.Deleted) 
                {
                   ValidateInterco(interco);
                }
            }

            //Create a list of countries that will hold the Interco Layout
            CreateCountriesLayout(detailTableView, project);


            //Save all intercos.
            TimingAndInterco.SaveAll(intercos);

            //If succeeded show a confirmation message
            if (!this.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "IntercoSaveMessage"))
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "IntercoSaveMessage", "alert('Timing and Interco modifications have been saved');", true);

            if (!IsPopUp)
            {
                Control refreshButton = Page.Controls[0].Controls[1].Controls[2].Controls[3];
                if (!Page.ClientScript.IsClientScriptBlockRegistered("RefreshInterco"))
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "RefreshInterco", Page.ClientScript.GetPostBackEventReference(refreshButton, null), true);
            }
            else
            {
                if (!Page.ClientScript.IsClientScriptBlockRegistered("RefreshInterco"))
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "RefreshInterco", Page.ClientScript.GetPostBackEventReference(btnDoPostback, this.ToString()), true);
            }

            //Remove the values from the session so that they can be refreshed.
            SessionManager.RemoveValueFromSession(this, UNAFFECTED_WP_DATASET);
            SessionManager.RemoveValueFromSession(this, PERIOD_DATASET);
            SessionManager.RemoveValueFromSession(this, INTERCO_DATASET);
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

    protected void tabStripInterco_TabClick(object sender, TabStripEventArgs e)
    {
        try
        {
            ShouldStoreWPSelection = false;
            if (e.Tab.Index == 1) //The Interco TAB
            {
                grdPeriod.Visible = false;
                grdInterco.Visible = true;
                FillCountryCombo();

                RemoveRowsFromEditMode(grdPeriod);
            }
            else
            {
                grdPeriod.Visible = true;
                grdInterco.Visible = false;

                RemoveRowsFromEditMode(grdInterco);
            }
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
    /// Used to add Ajax Settings after the controls are rendered
    /// </summary>
    /// <param name="e"></param>
    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            if (!PageLoadSucceeded)
                return;

            base.OnPreRender(e);
            //This method has been choosed to add ajax settings beacuse this is where the value
            //visible has been set

            RadAjaxManager ajaxManager = GetAjaxManager();
            Panel phErrors = (Panel)Master.FindControl("pnlErrors");

            if (grdPeriod.Visible) //The Interco TAB
            {
                ajaxManager.AjaxSettings.AddAjaxSetting(grdPeriod, grdPeriod);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdPeriod, phErrors);
                ajaxManager.AjaxSettings.AddAjaxSetting(this, grdPeriod);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnAddWP, grdPeriod);
            }
            else
            {
                ajaxManager.AjaxSettings.AddAjaxSetting(grdInterco, phErrors);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdInterco, grdInterco);
                ajaxManager.AjaxSettings.AddAjaxSetting(this, grdInterco);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnAddCountry, cmbCountries);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnAddCountry, grdInterco);
                ajaxManager.AjaxSettings.AddAjaxSetting(btnAddWP, grdInterco);
                ajaxManager.AjaxSettings.AddAjaxSetting(tabInterco, cmbCountries);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdInterco, cmbCountries);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdInterco, btnAddCountry);
                ajaxManager.AjaxSettings.AddAjaxSetting(grdInterco, btnSave);
            }
            ajaxManager.AjaxSettings.AddAjaxSetting(this, hdnIsDirty);
            RemoveOldColumns();
            //After removing old columns, grdInterco should rebind but cannot rebind here because if the user did a mass 
            //attribution operation on grdInterco, it will be handled in the grdInterco_PreRender event which occurs after
            //this event and the rebind operation of grdInterco resets the checked/unchecked state of the checkboxes which are verified
            //when applying mass attribution. The rebind operation which should take place here, will be done in grdInterco_PreRender event handler
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

    protected override void Render(HtmlTextWriter writer)
    {
        try
        {
            ClientScript.RegisterForEventValidation(btnDoPostback.UniqueID, this.ToString());
            base.Render(writer);
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

    protected void btnAddWP_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            switch (tabStripInterco.SelectedIndex)
            {
                case 0:
                    StoreEditedCostCentersPeriod(null);
                    break;
                case 1:
                    StoreEditedCostCentersInterco(null);
                    break;
            }


            List<IntercoLogicalKey> selectedItems = new List<IntercoLogicalKey>();

            RemoveWPsFromUnaffectedWPs(selectedItems);
            
            TimingAndInterco interco = new TimingAndInterco(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            
            CurrentUser currentUser = SessionManager.GetCurrentUser(this);
            interco.IdAssociate = currentUser.IdAssociate;

            DataTable newData = interco.GetWPTiming(selectedItems);
            if (newData != null)
            {
                //Add the isChangedColumn
                DataColumn isChangedCol = new DataColumn("IsChanged", typeof(bool));
                isChangedCol.DefaultValue = false;
                newData.Columns.Add(isChangedCol);

                foreach (DataRow row in newData.Rows)
                {
                    //Add the row to dsPeriod
                    dsPeriod.Tables[1].ImportRow(row);
                    
                    //If the row that was imported appeared in the datatable with deleted state, it will be removed
                    RemoveDeletedRow(row, dsPeriod.Tables[1]);
                    
                    //Add the row to dsInterco
                    DataRow newIntercoRow = dsInterco.Tables[1].NewRow();
                    newIntercoRow["IdProject"] = (int)row["IdProject"];
                    newIntercoRow["IdPhase"] = (int)row["IdPhase"];
                    newIntercoRow["IdWP"] = (int)row["IdWP"];
                    newIntercoRow["PhaseCode"] = row["PhaseCode"].ToString();
                    newIntercoRow["WPCode"] = row["WPCode"].ToString();
                    newIntercoRow["IsChanged"] = false;
                    newIntercoRow["HasBudget"] = false;
                    dsInterco.Tables[1].Rows.Add(newIntercoRow);

                    //If the row that was added appeared in the datatable with deleted state, it will be removed
                    RemoveDeletedRow(newIntercoRow, dsInterco.Tables[1]);

                    bool found = false;
                    foreach (DataRow masterRow in dsPeriod.Tables[0].Rows)
                    {
                        if (masterRow.RowState != DataRowState.Deleted)
                        {
                            if ((int)row["IdPhase"] == (int)masterRow["IdPhase"])
                                found = true;
                        }
                    }
                    if (!found) //Add a new master row
                    {
                        DataRow newRow = dsPeriod.Tables[0].NewRow();
                        newRow["IdProject"] = (int)row["IdProject"];
                        newRow["IdPhase"] = (int)row["IdPhase"];
                        newRow["PhaseCode"] = row["PhaseCode"].ToString();
                        dsPeriod.Tables[0].Rows.Add(newRow);
                        dsInterco.Tables[0].ImportRow(newRow);
                        dsPeriod.Tables[0].DefaultView.Sort = "PhaseCode";
                        dsInterco.Tables[0].DefaultView.Sort = "PhaseCode";

                    }
                }
            }
            SessionManager.SetSessionValue(this, PERIOD_DATASET, dsPeriod);
            SessionManager.SetSessionValue(this, INTERCO_DATASET, dsInterco);
            SessionManager.SetSessionValue(this, UNAFFECTED_WP_DATASET, dsUnaffectedWP);

            grdPeriod.Rebind();
            grdInterco.Rebind();
            FillUnaffectedWP();

            if (grdInterco.EditItems.Count > 0)
                SetUnsafeInEditModeControlsEnabledState(false);
            else
                SetUnsafeInEditModeControlsEnabledState(true);
        }
        catch (IndException exc)
        {
            dsPeriod.RejectChanges();
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            dsPeriod.RejectChanges();
            ShowError(new IndException(exc));
            return;
        }
    }

    private void RemoveWPsFromUnaffectedWPs(List<IntercoLogicalKey> selectedItems)
    {
        foreach (ListItem item in lstUnaffectedWP.Items)
        {
            if (item.Selected)
            {
                for (int i = 0; i < dsUnaffectedWP.Tables[0].Rows.Count; i++)
                {
                    DataRow row = dsUnaffectedWP.Tables[0].Rows[i];
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
    }

    protected void btnDeleteWP_Click(object sender, EventArgs e)
    {
        string listWPWithBudgetData = string.Empty;
        try
        {
            StoreEditedCostCentersPeriod(null);

            //Get the master and detail views
            GridTableView masterTableView = grdPeriod.MasterTableView;
            GridTableView detailTableView = grdPeriod.MasterTableView.DetailTables[0];

            //Cycle through the items hierarchy
            foreach (GridNestedViewItem nestedViewItem in masterTableView.GetItems(GridItemType.NestedView))
            {
                if (nestedViewItem.NestedTableViews.Length > 0)
                {
                    GridTableView itemCollection = nestedViewItem.NestedTableViews[0];
                    foreach (GridItem gridItem in itemCollection.Items)
                    {
                        if (gridItem is GridEditableItem)
                        {
                            GridEditableItem item = gridItem as GridEditableItem;
                            //Check if the checkbox for the current item is selected
                            CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                            if (chkSelected == null)
                                continue;
                            if (!chkSelected.Checked)
                                continue;
                            //Get the key for the current item
                            int currentWPId = (int)item.GetDataKeyValue("IdWP");
                            int currentPhaseId = (int)item.GetDataKeyValue("IdPhase");
                            //Get the hasBudget flag for row
                            bool hasBudget = false;                            
                            if (item.IsInEditMode)
                            {
                                bool.TryParse(item.SavedOldValues["HasBudget"].ToString(), out hasBudget);
                            }
                            else
                            {
                                bool.TryParse(item["HasBudget"].Text, out hasBudget);
                            }
                            string currentWPCode = item["WPCode"].Text;

                            //delete row only if there is no budget data
                            if (!hasBudget)
                            {
                                //Set the item out of edit mode before deleting it
                                item.Edit = false;

                                DeleteWPPeriod(currentPhaseId, currentWPId);

                                SessionManager.SetSessionValue(this, PERIOD_DATASET, dsPeriod);
                                SessionManager.SetSessionValue(this, INTERCO_DATASET, dsInterco);

                                //Set the dirty flag when deleting a wp
                                hdnIsDirty.Value = "1";
                            }
                            else
                                listWPWithBudgetData+=" " + currentWPCode + ",";
                        }
                    }
                }
            }
            FillUnaffectedWP();
            grdPeriod.Rebind();
            grdInterco.Rebind();
            if (listWPWithBudgetData.Length > 1)
                ShowError(new IndException(string.Format(ApplicationMessages.EXCEPTION_WP_CANNOT_BE_REMOVED, listWPWithBudgetData.Substring(0,listWPWithBudgetData.Length - 1))));
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

    
    #endregion Page Events

    #region TAB Period Events

    protected void grdPeriod_NeedDataSource(object source, Telerik.WebControls.GridNeedDataSourceEventArgs e)
    {
        try
        {
            if (!PageLoadSucceeded)
                return;

            //Get the current project        
            GridTableView masterTableView = grdPeriod.MasterTableView;
            GridTableView detailTableView = grdPeriod.MasterTableView.DetailTables[0];

            foreach (GridColumn gridColumn in masterTableView.Columns)
            {
                if (gridColumn is GridBoundColumn)
                {
                    GridBoundColumn boundColumn = gridColumn as GridBoundColumn;
                    if (((boundColumn.UniqueName == "StartYearMonth") || (boundColumn.UniqueName == "EndYearMonth")))
                    {
                        if (EditPermission != Permissions.None)
                        {
                            boundColumn.FooterText += "&nbsp<input type=\"image\" TITLE=\"Fill for selected WPs\" id=\"btnMassAttr" + boundColumn.UniqueName
                                + "\" class=\"IndImageButton\" src=\"../../../Images/mass_attribution.gif\" onclick=\";if (CheckBoxesSelectedInterco('"
                                + boundColumn.Owner.OwnerGrid.ClientID
                                + "')){openDiv(); __doPostBack('" + this.ClientID + "','periodCol_" + boundColumn.UniqueName + "');}\"";

                            boundColumn.HeaderText += "&nbsp<input type=\"image\" TITLE=\"Fill for selected WPs\" id=\"btnMassAttr" + boundColumn.UniqueName
                                + "\" class=\"IndImageButton\" src=\"../../../Images/mass_attribution_up.gif\" onclick=\";if (CheckBoxesSelectedInterco('"
                                + boundColumn.Owner.OwnerGrid.ClientID
                                + "')){openDiv(); __doPostBack('" + this.ClientID + "','periodCol_" + boundColumn.UniqueName + "');}\"";
                        }
                        else
                        {
                            boundColumn.FooterText = String.Empty;
                        }
                        boundColumn.FooterStyle.CssClass = "CenteredFooterCell";
                    }
                }
            }

            masterTableView.DataSource = dsPeriod.Tables[0].DefaultView;
            detailTableView.DataSource = dsPeriod.Tables[1].DefaultView;
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
    /// Event used for the mass attribution functionality
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void grdPeriod_PreRender(object sender, EventArgs e)
    {
        try
        {
            if (!PageLoadSucceeded)
                return;

            
            string issuerArg = Page.Request.Params.Get("__EVENTARGUMENT");
            string issuerTrg = Page.Request.Params.Get("__EVENTTARGET");
            //If the postback was not issued by a Mass Attribute button on the PeriodGrid
            if ((issuerArg == null) || ((!issuerArg.StartsWith("periodCol_")) && (!issuerTrg.EndsWith("saveButton"))))
            {
                RestoreEditedCostCentersPeriod();
                return;
            }

            Pair datePair = (SessionManager.GetSessionValueNoRedirect(this, SessionStrings.DATE_INTERVAL) == null) ? null : (Pair)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.DATE_INTERVAL);

            if (datePair == null)
            {
                RestoreEditedCostCentersPeriod();
                return;
            }
            //We don't need to find out the column name because the mass attribution will update all columns

            //Get the master and detail views
            GridTableView masterTableView = grdPeriod.MasterTableView;
            GridTableView detailTableView = grdPeriod.MasterTableView.DetailTables[0];

            //Cycle through the items hierarchy
            foreach (GridNestedViewItem nestedViewItem in masterTableView.GetItems(GridItemType.NestedView))
            {
                if (nestedViewItem.NestedTableViews.Length > 0)
                {
                    GridTableView itemCollection = nestedViewItem.NestedTableViews[0];
                    foreach (GridItem gridItem in itemCollection.Items)
                    {
                        if (gridItem is GridEditableItem)
                        {
                            GridEditableItem item = gridItem as GridEditableItem;
                            //Check if the checkbox for the current item is selected
                            CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                            if (chkSelected == null)
                                continue;
                            if (!chkSelected.Checked)
                                continue;
                            //Get the key for the current item
                            int currentWPId = (int)item.GetDataKeyValue("IdWP");
                            int currentPhaseId = (int)item.GetDataKeyValue("IdPhase");

                            //Search the found key in the datasource
                            foreach (DataRow row in dsPeriod.Tables[1].Rows)
                            {
                                if (row.RowState != DataRowState.Deleted)
                                {
                                    int wpId = (int)row["IdWP"];
                                    int phaseId = (int)row["IdPhase"];
                                    {
                                        //If the key is found, update the columns
                                        if ((currentWPId == wpId) && (currentPhaseId == phaseId))
                                        {
                                            row["StartYearMonth"] = (int)datePair.First;
                                            row["EndYearMonth"] = (int)datePair.Second;
                                            row["IsChanged"] = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ClientScript.RegisterStartupScript(typeof(Page), "SymbolError", "{var div = document.getElementById(\"ctl00_ph_PeriodMassAttr_periodMassAttributionDiv\"); closeDiv(null, div);}", true);

            //Store the new dataset in session
            SessionManager.SetSessionValue(this, PERIOD_DATASET, dsPeriod);
            //Clear the dates pair from the session
            SessionManager.RemoveValueFromSession(this, SessionStrings.DATE_INTERVAL);

            //Rebind the grid
            masterTableView.DataSource = dsPeriod.Tables[0];
            detailTableView.DataSource = dsPeriod.Tables[1];
            grdPeriod.Rebind();

            hdnIsDirty.Value = "1";

            RestoreEditedCostCentersPeriod();
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
        finally
        {
            //This code (hiding the expand collapse columns and disabling checkboxes for wp's with budget info) must be executed no matter what.
            HideGridExpandColumn(grdPeriod);            
        }
    }

    protected void grdPeriod_UpdateCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            if (e.Item is GridEditableItem)
            {
                GridEditableItem item = e.Item as GridEditableItem;

                object connectionManager = SessionManager.GetConnectionManager(this);
                int idProject = SessionManager.GetCurrentProject(this).Id;

                TimingAndInterco key = new TimingAndInterco(connectionManager);
                key.IdProject = idProject;
                key.IdPhase = int.Parse(item.SavedOldValues["IdPhase"].ToString());
                key.IdWP = int.Parse(item.SavedOldValues["IdWP"].ToString());

                StoreEditedCostCentersPeriod(key);

                Hashtable newValues = new Hashtable();
                item.ExtractValues(newValues);

                ////The dates can contain null values
                int startYearMonth = (newValues["StartYearMonth"].ToString() == String.Empty) ? ApplicationConstants.INT_NULL_VALUE : int.Parse(newValues["StartYearMonth"].ToString());
                int endYearMonth = (newValues["EndYearMonth"].ToString() == String.Empty) ? ApplicationConstants.INT_NULL_VALUE : int.Parse(newValues["EndYearMonth"].ToString());

                ArrayList errors = new ArrayList();

                if ((startYearMonth == ApplicationConstants.INT_NULL_VALUE) || (endYearMonth == ApplicationConstants.INT_NULL_VALUE))
                    errors.Add(ApplicationMessages.EXCEPTION_SELECT_STARTYM_AND_ENDYM);

                if ((startYearMonth > endYearMonth) && (startYearMonth != ApplicationConstants.INT_NULL_VALUE) && (endYearMonth != ApplicationConstants.INT_NULL_VALUE))
                    errors.Add(ApplicationMessages.EXCEPTION_ENDYM_MUST_BE_GREATER_THEN_STARTYM);
                //If there are errors the update shouldn't be done
                if (errors.Count != 0)
                {
                    this.ShowError(errors);
                    e.Canceled = true;
                    return;
                }

                //The ids are mandatory
                int wpId = (int)item.GetDataKeyValue("IdWP");
                int phaseId = (int)item.GetDataKeyValue("IdPhase");

                foreach (DataRow row in dsPeriod.Tables[1].Rows)
                {
                    if (row.RowState != DataRowState.Deleted)
                    {
                        int rowWpId = (int)row["IdWP"];
                        int rowPhaseId = (int)row["IdPhase"];

                        if ((rowWpId == wpId) && (rowPhaseId == phaseId))
                        {
                            row["StartYearMonth"] = startYearMonth;
                            row["EndYearMonth"] = endYearMonth;
                            row["IsChanged"] = true;
                        }
                    }
                }
                SessionManager.SetSessionValue(this, PERIOD_DATASET, dsPeriod);
                hdnIsDirty.Value = "1";
            }
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
    
    protected void grdPeriod_ItemCreated(object sender, GridItemEventArgs e)
    {
        try
        {
            if (!PageLoadSucceeded)
                return;


            foreach (TableCell cell in e.Item.Cells)
                cell.HorizontalAlign = HorizontalAlign.Center;

            if (e.Item is GridFooterItem)
            {
                foreach (GridTableCell cell in ((GridFooterItem)e.Item).Cells)
                    cell.CssClass = "CenteredFooterCell";
            }

            //Apply delete permissions to period grid
            ApplyPeriodDeletePermissions(e.Item);
            //Apply edit permissions to period grid
            ApplyPeriodEditPermissions(e.Item);

            if (e.Item.OwnerTableView.Name == grdPeriod.MasterTableView.Name && e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                CheckBox chkSelectWP = dataItem["SelectPhaseCol"].Controls[1] as CheckBox;
                if (chkSelectWP != null)
                {
                    chkSelectWP.Attributes.Add("onclick", "SelectChildCheckBoxes('" + grdPeriod.ClientID + "', '" + chkSelectWP.ClientID + "');");
                }
            }

            if (e.Item.OwnerTableView.Name == grdPeriod.MasterTableView.DetailTables[0].Name && e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                CheckBox chkSelectWP = dataItem["SelectWPCol"].Controls[1] as CheckBox;

                if (chkSelectWP != null)
                {
                    chkSelectWP.Attributes.Add("onclick", "StoreCheckValue(this);");
                }
            }
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
    
    #endregion Grid Period Events

    #region TAB Interco Events

    protected void grdInterco_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        try
        {
            if (!PageLoadSucceeded)
                return;

            GridTableView masterTableView = grdInterco.MasterTableView;
            GridTableView detailTableView = grdInterco.MasterTableView.DetailTables[0];

            for (int colIndex = TimingAndInterco.FirstCountryColumn; colIndex < dsInterco.Tables[1].Columns.Count; colIndex++)
            {
                DataColumn dataColumn = dsInterco.Tables[1].Columns[colIndex];
                if (dataColumn.ColumnName == "IsChanged")
                    continue;
                GridBoundColumn boundColumn;
                if ((boundColumn = GetBoundColumn(masterTableView, dataColumn.ColumnName)) == null)
                {
                    boundColumn = new GridBoundColumn();

                    detailTableView.Columns.Add(boundColumn);
                    masterTableView.Columns.Add(boundColumn);

                    boundColumn.HeaderStyle.Width = Unit.Pixel(90);
                    boundColumn.ItemStyle.Width = Unit.Pixel(90);
                    boundColumn.Resizable = false;
                    boundColumn.Reorderable = true;
                    boundColumn.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;

                    //Set the column data type, data field and header text
                    boundColumn.DataType = dataColumn.DataType;
                    boundColumn.ItemStyle.CssClass = "CenteredCell";
                    boundColumn.HeaderStyle.CssClass = "CenteredHeaderCell";
                    boundColumn.FooterStyle.CssClass = "CenteredFooterCell";
                    boundColumn.DataField = dataColumn.ColumnName;
                    boundColumn.HeaderText = dataColumn.Caption;
                    boundColumn.UniqueName = dataColumn.ColumnName;
                }
                if (EditPermission != Permissions.None)
                {
                    boundColumn.FooterText += "&nbsp<input type=\"image\" TITLE=\"Fill for selected WPs\" id=\"btnMassAttr" + boundColumn.UniqueName + "\" class=\"IndImageButton\" src=\"../../../Images/mass_attribution.gif\" onclick=\"if (CheckBoxesSelectedInterco('" + boundColumn.Owner.OwnerGrid.ClientID + "')){if (ShowPopUpWithoutPostBack('IntercoMassAttribution.aspx',160,250, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) {__doPostBack('" + this.ClientID + "','intercoCol_" + boundColumn.UniqueName + "');}} return false\"";

                }
                else
                {
                    boundColumn.FooterText = String.Empty;
                }

            }

            masterTableView.DataSource = dsInterco.Tables[0].DefaultView;
            detailTableView.DataSource = dsInterco.Tables[1].DefaultView;
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
    /// Event used for the mass attribution functionality
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void grdInterco_PreRender(object sender, EventArgs e)
    {
        try
        {
            if (!PageLoadSucceeded)
                return;

            grdInterco.MasterTableView.GetColumn("ExpandColumn").HeaderStyle.CssClass = "GridHeaderNoReorder";
            foreach (GridColumn col in grdInterco.MasterTableView.Columns)
            {
                if (!col.Reorderable)
                {
                    col.HeaderStyle.CssClass = "GridHeaderNoReorder";
                }
            }           

            string issuerArg = Page.Request.Params.Get("__EVENTARGUMENT");
            //If the postback was not issued by a Mass Attribute button on the IntercoGrid
            if ((issuerArg == null) || (!issuerArg.StartsWith("intercoCol_")))
            {
                string issuer = Page.Request.Params.Get("__EVENTTARGET");
                if ((issuer != null) && (!issuer.Contains("UpdateButton")))
                    //Rebind grdInterco to make sure the old country columns are not displayed
                    grdInterco.Rebind();

                //Hide the expand/collapse column
                HideGridExpandColumn(grdInterco);

                RestoreEditedCostCentersInterco();
                return;
            }

            HandleIntercoMassAttribution(issuerArg);
            hdnIsDirty.Value = "1";

            RestoreEditedCostCentersInterco();
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

    protected void grdInterco_UpdateCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            if (e.Item is GridEditableItem)
            {
                GridEditableItem item = e.Item as GridEditableItem;

                object connectionManager = SessionManager.GetConnectionManager(this);
                int idProject = SessionManager.GetCurrentProject(this).Id;

                TimingAndInterco key = new TimingAndInterco(connectionManager);
                key.IdProject = idProject;
                key.IdPhase = int.Parse(item.SavedOldValues["IdPhase"].ToString());
                key.IdWP = int.Parse(item.SavedOldValues["IdWP"].ToString());

                StoreEditedCostCentersInterco(key);

                Hashtable newValues = new Hashtable();
                item.ExtractValues(newValues);

                bool result = UpdateWP(item, newValues, e);

                if (result)
                {
                    SessionManager.SetSessionValue(this, PERIOD_DATASET, dsPeriod);
                    hdnIsDirty.Value = "1";

                    if (grdInterco.EditItems.Count > 1)
                    {
                        SetUnsafeInEditModeControlsEnabledState(false);
                    }
                    else
                    {
                        SetUnsafeInEditModeControlsEnabledState(true);
                    }
                }
            }
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

    protected void grdInterco_ItemCreated(object sender, GridItemEventArgs e)
    {
        try
        {
            if (!PageLoadSucceeded)
                return;

            foreach (TableCell cell in e.Item.Cells)
                cell.HorizontalAlign = HorizontalAlign.Center;

            if (e.Item is GridFooterItem)
            {
                foreach (GridTableCell cell in ((GridFooterItem)e.Item).Cells)
                    cell.CssClass = "CenteredFooterCell";
            }


            if (e.Item is GridEditableItem && e.Item.Edit & dsInterco != null)
            {

                GridEditableItem item = e.Item as GridEditableItem;
                for (int i = TimingAndInterco.FirstCountryColumn; i < dsInterco.Tables[1].Columns.Count; i++)
                {
                    string columnName = dsInterco.Tables[1].Columns[i].ColumnName;
                    if (columnName == "IsChanged")
                        continue;
                    TableCell cell = item[columnName] as TableCell;
                    TextBox editText = item[columnName].Controls[0] as TextBox;
                    editText.Attributes.Add("onKeyPress", "return RestrictKeysByName(event,'1234567890.',\"" + editText.ClientID.Replace("_", "$") + "\")");
                    editText.CssClass = "IntercoEditTextBox";
                }
            }
            ApplyIntercoGridPermissions(e);

            if (e.Item.OwnerTableView.Name == grdInterco.MasterTableView.Name && e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                CheckBox chkSelectWP = dataItem["SelectPhaseCol"].Controls[1] as CheckBox;
                if (chkSelectWP != null)
                {
                    chkSelectWP.Attributes.Add("onclick", "SelectChildCheckBoxes('" + grdInterco.ClientID + "', '" + chkSelectWP.ClientID + "');");
                }
            }

            if (e.Item.OwnerTableView.Name == grdInterco.MasterTableView.DetailTables[0].Name && e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                CheckBox chkSelectWP = dataItem["SelectWPCol"].Controls[1] as CheckBox;
                if (chkSelectWP != null)
                {
                    chkSelectWP.Attributes.Add("onclick", "StoreCheckValue(this);");
                }
            }
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

 

    protected void btnAddCountry_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (!String.IsNullOrEmpty(cmbCountries.Text))
            {
                string countryName = cmbCountries.Text;
                int countryId = int.Parse(cmbCountries.SelectedValue);

                GridTableView masterTableView = grdInterco.MasterTableView;
                GridTableView detailTableView = grdInterco.MasterTableView.DetailTables[0];

                DataColumn countryCol = new DataColumn(countryId.ToString(), typeof(decimal));
                DataColumn countryColCopy = new DataColumn(countryId.ToString(), typeof(decimal));
                countryCol.Caption = countryColCopy.Caption = countryName;
                dsInterco.Tables[1].Columns.Add(countryCol);
                dsInterco.Tables[0].Columns.Add(countryColCopy);
                dsInterco.Tables[1].Columns["Total"].Expression += "+IsNull([" + countryCol.ColumnName + "],0)";
                SessionManager.SetSessionValue(this, INTERCO_DATASET, dsInterco);

                GridBoundColumn boundColumn = new GridBoundColumn();
                detailTableView.Columns.Add(boundColumn);
                masterTableView.Columns.Add(boundColumn);

                //Add the new country at the last position in the grid
                boundColumn.OrderIndex = detailTableView.RenderColumns.Length;


                boundColumn.HeaderStyle.Width = Unit.Pixel(90);
                boundColumn.ItemStyle.Width = Unit.Pixel(90);
                boundColumn.ItemStyle.CssClass = "CenteredCell";
                boundColumn.HeaderStyle.CssClass = "CenteredHeaderCell";
                boundColumn.FooterStyle.CssClass = "CenteredFooterCell";
                boundColumn.Resizable = false;
                boundColumn.Reorderable = true;
                boundColumn.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;

                //Set the column data type, data field and header text
                boundColumn.DataType = countryCol.DataType;
                boundColumn.DataField = countryCol.ColumnName;
                boundColumn.HeaderText = countryCol.Caption;
                boundColumn.UniqueName = countryCol.ColumnName;

                boundColumn.FooterText += "&nbsp<input type=\"image\" id=\"btnMassAttr" + boundColumn.UniqueName + "\" class=\"IndImageButton\" src=\"../../../Images/mass_attribution.gif\" onclick=\"if (CheckBoxesSelectedInterco('" + boundColumn.Owner.OwnerGrid.ClientID + "')){if (ShowPopUpWithoutPostBack('IntercoMassAttribution.aspx',160,250, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) {__doPostBack('" + this.ClientID + "','intercoCol_" + boundColumn.UniqueName + "');}} return false\"";
                foreach (DataRow row in dsInterco.Tables[1].Rows)
                {
                    ConversionUtils conversionUtils = new ConversionUtils();
                    row[countryId.ToString()] = conversionUtils.GetDecimalStringFromObject(0);
                }
                grdInterco.Rebind();

                #region Remove country from the countries combo
                FillCountryCombo();
                #endregion Remove country from the countries combo

            }
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

    protected void btnDeleteWPInterco_Click(object sender, EventArgs e)
    {
        string listWPWithBudgetData = string.Empty;
        try
        {
            StoreEditedCostCentersInterco(null);
            
            //Get the master and detail views
            GridTableView masterTableView = grdInterco.MasterTableView;
            GridTableView detailTableView = grdInterco.MasterTableView.DetailTables[0];

            //Cycle through the items hierarchy
            foreach (GridNestedViewItem nestedViewItem in masterTableView.GetItems(GridItemType.NestedView))
            {
                if (nestedViewItem.NestedTableViews.Length > 0)
                {
                    GridTableView itemCollection = nestedViewItem.NestedTableViews[0];
                    foreach (GridItem gridItem in itemCollection.Items)
                    {
                        if (gridItem is GridEditableItem)
                        {
                            GridEditableItem item = gridItem as GridEditableItem;
                            //Check if the checkbox for the current item is selected
                            CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                            if (chkSelected == null)
                                continue;
                            if (!chkSelected.Checked)
                                continue;
                            //Get the key for the current item
                            int currentWPId = (int)item.GetDataKeyValue("IdWP");
                            int currentPhaseId = (int)item.GetDataKeyValue("IdPhase");

                            //Get the hasBudget flag for row
                            bool hasBudget = false;
                            if (item.IsInEditMode)
                            {
                                bool.TryParse(item.SavedOldValues["HasBudget"].ToString(), out hasBudget);
                            }
                            else
                            {
                                bool.TryParse(item["HasBudget"].Text, out hasBudget);
                            }
                            string currentWPCode = item["WPCode"].Text;
                            //delete row only if there is no budget data
                            if (!hasBudget)
                            {
                                //Set the item out of edit mode before deleting it
                                item.Edit = false;

                                DeleteWPInterco(currentPhaseId, currentWPId);
                                
                                SessionManager.SetSessionValue(this, PERIOD_DATASET, dsPeriod);
                                SessionManager.SetSessionValue(this, INTERCO_DATASET, dsInterco);

                                //Set the dirty flag when deleting a wp
                                hdnIsDirty.Value = "1";
                            }
                            else
                                listWPWithBudgetData += " " + currentWPCode + ",";
                        }
                    }
                }
            }
            FillUnaffectedWP();
            grdPeriod.Rebind();
            grdInterco.Rebind();

            if (grdInterco.EditItems.Count > 0)
                SetUnsafeInEditModeControlsEnabledState(false);
            else
                SetUnsafeInEditModeControlsEnabledState(true);

            if (listWPWithBudgetData.Length > 1)
                ShowError(new IndException(string.Format(ApplicationMessages.EXCEPTION_WP_CANNOT_BE_REMOVED, listWPWithBudgetData.Substring(0, listWPWithBudgetData.Length - 1))));
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

    protected void btnDoPostback_Click(object sender, EventArgs e)
    {
        ResponseRedirect(Request.Url.ToString());
    }

    protected void grdPeriod_EditCommand(object source, GridCommandEventArgs e)
    {
        try 
        {
            StoreEditedCostCentersPeriod(null);
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

    protected void grdInterco_EditCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            StoreEditedCostCentersInterco(null);
            SetUnsafeInEditModeControlsEnabledState(false);
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

    protected void grdPeriod_CancelCommand(object source, GridCommandEventArgs e)
    {
        try 
        {
            GridDataItem item = (GridDataItem)e.Item;

            object connectionManager = SessionManager.GetConnectionManager(this);
            int idProject = SessionManager.GetCurrentProject(this).Id;

            TimingAndInterco key = new TimingAndInterco(connectionManager);
            key.IdProject = idProject;
            key.IdPhase = int.Parse(item.SavedOldValues["IdPhase"].ToString());
            key.IdWP = int.Parse(item.SavedOldValues["IdWP"].ToString());

            StoreEditedCostCentersPeriod(key);
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

    protected void grdInterco_CancelCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            GridDataItem item = (GridDataItem)e.Item;

            object connectionManager = SessionManager.GetConnectionManager(this);
            int idProject = SessionManager.GetCurrentProject(this).Id;

            TimingAndInterco key = new TimingAndInterco(connectionManager);
            key.IdProject = idProject;
            key.IdPhase = int.Parse(item.SavedOldValues["IdPhase"].ToString());
            key.IdWP = int.Parse(item.SavedOldValues["IdWP"].ToString());

            StoreEditedCostCentersInterco(key);

            if (grdInterco.EditItems.Count > 1)
            {
                SetUnsafeInEditModeControlsEnabledState(false);
            }
            else
            {
                SetUnsafeInEditModeControlsEnabledState(true);
            }
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
    #endregion TAB Interco Events


    #region Private Methods
    private void ApplyIntercoGridPermissions(GridItemEventArgs e)
    {
        if (e.Item is GridFooterItem && e.Item.OwnerTableView == grdInterco.MasterTableView)
        {
            if (DeletePermission == Permissions.None)
            {
                IndImageButton btnDelete = ((GridFooterItem)e.Item)["SelectPhaseCol"].Controls[1] as IndImageButton;
                if (btnDelete != null)
                {
                    btnDelete.Enabled = false;
                    btnDelete.ImageUrl = "~/Images/buttons_delete_disabled.png";
                    btnDelete.ToolTip = String.Empty;
                }
            }
        }
        if (e.Item is GridDataItem && e.Item.OwnerTableView.ParentItem != null && e.Item.OwnerTableView.ParentItem.OwnerTableView == grdInterco.MasterTableView)
        {
            if (EditPermission == Permissions.None)
            {
                ((GridDataItem)e.Item)["EditInterco"].Enabled = false;
                ImageButton btnEdit = ((GridDataItem)e.Item)["EditInterco"].Controls[0] as ImageButton;
                if (btnEdit != null)
                    btnEdit.ImageUrl = "~/Images/Edit_disabled.gif";
                CheckBox chkSelect = ((GridDataItem)e.Item)["SelectWPCol"].Controls[1] as CheckBox;
                if (chkSelect != null)
                {
                    chkSelect.Enabled = false;
                }
            }
        }
        if (e.Item is GridDataItem && e.Item.OwnerTableView == grdInterco.MasterTableView)
        {
            if (EditPermission == Permissions.None)
            {
                CheckBox chkSelect = ((GridDataItem)e.Item)["SelectPhaseCol"].Controls[1] as CheckBox;
                if (chkSelect != null)
                {
                    chkSelect.Enabled = false;
                }
            }
        }
    }

    private void ReorderColumns()
    {
        foreach (GridColumn masterCol in grdInterco.MasterTableView.Columns)
        {
            GridTableView detailTable = grdInterco.MasterTableView.DetailTables[0];
            GridColumn col = FindDetailColumn(masterCol.UniqueName, detailTable);
            if (col != null)
                col.OrderIndex = masterCol.OrderIndex;
        }
    }

    private GridColumn FindDetailColumn(string columnName, GridTableView detailTable)
    {
        foreach (GridColumn col in detailTable.Columns)
            if (col.UniqueName == columnName)
                return col;
        return null;
    }

    private void FillCountryCombo()
    {
        InergyCountry country = new InergyCountry(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
        dsCountries = country.GetAll();
        ArrayList deletedRows = new ArrayList();
        if (dsInterco != null)
        {
            for (int i = TimingAndInterco.FirstCountryColumn; i < dsInterco.Tables[1].Columns.Count; i++)
            {
                DataColumn countryCol = dsInterco.Tables[1].Columns[i];
                if (countryCol.ColumnName == "IsChanged")
                    continue;
                int countryId = int.Parse(countryCol.ColumnName);
                foreach (DataRow countryRow in dsCountries.Tables[0].Rows)
                {
                    if ((int)countryRow["Id"] == countryId)
                        deletedRows.Add(countryRow);
                }
            }
            foreach (DataRow deletedRow in deletedRows)
                dsCountries.Tables[0].Rows.Remove(deletedRow);
            DSUtils.AddEmptyRecord(dsCountries.Tables[0], "Id");
        }
        cmbCountries.DataSource = dsCountries;
        cmbCountries.DataMember = dsCountries.Tables[0].ToString();
        cmbCountries.DataValueField = "Id";
        cmbCountries.DataTextField = "Name";
        cmbCountries.DataBind();
    }

    private void FillUnaffectedWP()
    {
        dsUnaffectedWP.Tables[0].DefaultView.Sort = "WPCode";
        lstUnaffectedWP.DataSource = dsUnaffectedWP.Tables[0].DefaultView;
        lstUnaffectedWP.DataValueField = "UniqueKey";
        lstUnaffectedWP.DataTextField = "WPCode";
        lstUnaffectedWP.DataBind();
    }
   
    private GridBoundColumn GetBoundColumn(GridTableView tableView, string columnName)
    {
        foreach (GridColumn col in tableView.Columns)
        {
            if (col is GridBoundColumn)
            {
                GridBoundColumn boundCol = col as GridBoundColumn;
                if (boundCol.DataField == columnName)
                    return boundCol;
            }
        }
        return null;
    }

    private void ValidateInterco(TimingAndInterco interco)
    {
        decimal intercoSum = 0;
        //Creates the percentage sum for the current interco
        if (interco.IntercoCountries != null)
            foreach (IntercoCountry intercoCountry in interco.IntercoCountries)
            {
                intercoSum += (intercoCountry.Percent == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : intercoCountry.Percent;
            }

        if ((intercoSum == 0) && (interco.StartYearMonth == ApplicationConstants.INT_NULL_VALUE || interco.EndYearMonth == ApplicationConstants.INT_NULL_VALUE))
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_PERIOD_INTERCO_INFO_MISSING, interco.WPName));
        }

        //Interco sum is invalid
        if ((intercoSum>0)&&(intercoSum != 100))
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_PERCENT_SUM_IS_INVALID, interco.WPName));
        }

        //Only the interco information is present
        if ((interco.StartYearMonth == ApplicationConstants.INT_NULL_VALUE || interco.EndYearMonth == ApplicationConstants.INT_NULL_VALUE) && (intercoSum == 100))
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_PERIOD_INFO_MISSING, interco.WPName));
        }

        //Period is invalid
        if ((interco.StartYearMonth == ApplicationConstants.INT_NULL_VALUE) || (interco.EndYearMonth == ApplicationConstants.INT_NULL_VALUE))
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_PERIOD_INFO_MISSING, interco.WPName));
        }

        //Only period information is present
        if ((interco.StartYearMonth != ApplicationConstants.INT_NULL_VALUE && interco.EndYearMonth != ApplicationConstants.INT_NULL_VALUE) && (intercoSum == 0))
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_INTERCO_INFO_MISSING, interco.WPName));           
        }
    }

    private void SetRowUnaffected(int wpId, int phaseId, DataRow deletedRow)
    {
        //Construct a new datarow
        dsUnaffectedWP.AcceptChanges();
        DataRow row = dsUnaffectedWP.Tables[0].NewRow();
        row["IdProject"] = (int)deletedRow["IdProject"];
        row["IdWP"] = wpId;
        row["IdPhase"] = phaseId;
        row["PhaseCode"] = deletedRow["PhaseCode"].ToString();
        row["WPCode"] = deletedRow["WPCode"].ToString();

        //Add the datarow to the list datasource
        dsUnaffectedWP.Tables[0].Rows.Add(row);

        //Put the dataset into session
        SessionManager.SetSessionValue(this, UNAFFECTED_WP_DATASET, dsUnaffectedWP);

        lstUnaffectedWP.DataBind();
    }
    /// <summary>
    /// Check if the master row has any details left. If not, delete the master row also
    /// </summary>
    /// <param name="phaseId">The PhaseId</param>
    /// <param name="dsInterco">The data set</param>
    private void CheckMasterRow(int phaseId, DataSet ds)
    {
        //first check if there are any rows in the detail table that have the same phaseId
        foreach (DataRow row in ds.Tables[1].Rows)
        {
            //If any record is found then the function returns (nothing should happen)
            if ((row.RowState != DataRowState.Deleted) && ((int)row["IdPhase"] == phaseId))
                return;
        }
        //If the code reaches here than the master record doesn't have any detail rows
        DataRow masterRow = null;
        foreach (DataRow parentRow in ds.Tables[0].Rows)
        {
            if ((parentRow.RowState != DataRowState.Deleted) && ((int)parentRow["IdPhase"] == phaseId))
                masterRow = parentRow;
        }
        //Delete the master row if it is found. (Note: the master row should always be found if 
        //code reaches here
        if (masterRow != null)
            masterRow.Delete();
    }

    private void CreateCountriesLayout(GridTableView detailTableView, CurrentProject project)
    {
        int FirstContryRenderPosition = 9;

        List<IntercoCountry> countriesLayout = new List<IntercoCountry>();

        //Cycle each country column in the detail view
        for (int i = FirstContryRenderPosition; i < detailTableView.RenderColumns.Length; i++)
        {
            string columnName = detailTableView.RenderColumns[i].UniqueName;

            if (columnName == "IsChanged")
                continue;

            int idCountry = int.Parse(columnName);
            bool found = false;
            //Verify that the current country has a value associated in the DataSet. If it does not,
            //the country should not be added`
            foreach (DataRow row in dsInterco.Tables[1].Rows)
            {
                if (row.RowState == DataRowState.Deleted)
                    continue;
                if ((row[columnName] != DBNull.Value) && ((decimal)row[columnName] > 0))
                    found = true;
            }
            //Case country has interco affectation associated on at least one WP
            if (found)
            {
                //Create the object and add it to the list
                IntercoCountry country = new IntercoCountry(SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
                country.IdCountry = idCountry;
                country.Position = i - detailTableView.RenderColumns[FirstContryRenderPosition].OrderIndex;
                country.IdProject = project.Id;
                countriesLayout.Add(country);
            }
        }

        TimingAndInterco.CreateCountryLayout(project.Id, countriesLayout, SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
    }

    private TIList CreateIntercosList()
    {
        TIList intercos = new TIList();

        //Add each not-deleted WP in the intercos list and set modify if is the case
        foreach (DataRow row in dsPeriod.Tables[1].Rows)
        {
            if (row.RowState == DataRowState.Deleted)
                continue;

            TimingAndInterco interco = new TimingAndInterco(row, SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            if ((bool)row["IsChanged"])
                interco.SetModified();
            interco.LastUserUpdate = ((CurrentUser)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_USER)).IdAssociate;
            intercos.Add(interco);
        }

        //Construct the deleted WP
        DataTable tblDeletedWPTiming = dsPeriod.Tables[1].GetChanges(DataRowState.Deleted);
        if (tblDeletedWPTiming != null)
        {
            foreach (DataRow row in tblDeletedWPTiming.Rows)
            {
                //Reject the changes so the row can be inspected
                row.RejectChanges();
                TimingAndInterco interco = new TimingAndInterco(row, SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
                interco.SetDeleted();
                //Add the deleted interco to the intercos list with the deleted flag associated
                intercos.Add(interco);
            }
        }

        //If no WP exist in the list return
        if (intercos.Count == 0)
            return null;

        //Search the Interco data set to complete the list of Interco objects
        foreach (DataRow row in dsInterco.Tables[1].Rows)
        {
            if (row.RowState == DataRowState.Deleted)
                continue;

            TimingAndInterco currentInterco = null;
            IntercoLogicalKey key = TimingAndInterco.GetKey(row);
            //Find the corresponding interco object - and keep it in the CurrentInterco. CurrentInterco is always found
            foreach (TimingAndInterco interco in intercos)
            {
                if (IntercoLogicalKey.AreKeysEqual(key, TimingAndInterco.GetKey(interco)))
                    currentInterco = interco;
            }
            //Set the modify flag if this is the case
            if ((bool)row["IsChanged"])
                currentInterco.SetModified();
            //Create the list of countries for the current interco
            currentInterco.AddCountries(row);
        }

        return intercos;
    }

    /// <summary>
    /// Removes the old country columns that are no longer used
    /// </summary>
    private void RemoveOldColumns()
    {
        GridTableView masterTableView = grdInterco.MasterTableView;
        GridTableView detailTableView = grdInterco.MasterTableView.DetailTables[0];
        List<GridColumn> oldMasterColumns = new List<GridColumn>();
        List<GridColumn> oldDetailColumns = new List<GridColumn>();
        //Get the columns that are in the master table and are not in the dataset
        foreach (GridColumn column in masterTableView.Columns)
        {
            if (!(column is GridBoundColumn))
                continue;
            //Add column to list if it's the case
            if (!dsInterco.Tables[0].Columns.Contains(column.UniqueName))
                oldMasterColumns.Add(column);
        }
        //Get the columns that are in the detail table and are not in the dataset
        foreach (GridColumn column in detailTableView.Columns)
        {
            if (!(column is GridBoundColumn))
                continue;
            //Add column to list if it's the case
            if (!dsInterco.Tables[1].Columns.Contains(column.UniqueName))
                oldDetailColumns.Add(column);
        }
        //Remove the old columns from both master and detail views
        foreach (GridColumn column in oldMasterColumns)
            masterTableView.Columns.Remove(column);
        foreach (GridColumn column in oldDetailColumns)
            detailTableView.Columns.Remove(column);
    }

    /// <summary>
    /// Applies delete permissions for the period grid
    /// </summary>
    /// <param name="gridItem"></param>
    private void ApplyPeriodDeletePermissions(GridItem gridItem)
    {
        if (gridItem is GridFooterItem && gridItem.OwnerTableView == grdPeriod.MasterTableView)
        {
            if (DeletePermission == Permissions.None)
            {
                IndImageButton btnDelete = ((GridFooterItem)gridItem)["SelectPhaseCol"].Controls[1] as IndImageButton;
                if (btnDelete != null)
                {
                    btnDelete.Enabled = false;
                    btnDelete.ImageUrl = "~/Images/buttons_delete_disabled.png";
                    btnDelete.ToolTip = String.Empty;
                }
            }
        }
    }

    /// <summary>
    /// Applies edit permissions to period grid
    /// </summary>
    /// <param name="gridItem"></param>
    private void ApplyPeriodEditPermissions(GridItem gridItem)
    {
        if (gridItem is GridDataItem && gridItem.OwnerTableView.ParentItem != null && gridItem.OwnerTableView.ParentItem.OwnerTableView == grdPeriod.MasterTableView)
        {
            if (EditPermission == Permissions.None)
            {
                ((GridDataItem)gridItem)["EditPeriod"].Enabled = false;

                ImageButton btnEdit = ((GridDataItem)gridItem)["EditPeriod"].Controls[0] as ImageButton;
                if (btnEdit != null)
                    btnEdit.ImageUrl = "~/Images/Edit_disabled.gif";

                CheckBox chkSelect = ((GridDataItem)gridItem)["SelectWPCol"].Controls[1] as CheckBox;
                if (chkSelect != null)
                {
                    chkSelect.Enabled = false;
                }
            }
        }
        if (gridItem is GridDataItem && gridItem.OwnerTableView == grdPeriod.MasterTableView)
        {
            if (EditPermission == Permissions.None)
            {
                CheckBox chkSelect = ((GridDataItem)gridItem)["SelectPhaseCol"].Controls[1] as CheckBox;
                if (chkSelect != null)
                {
                    chkSelect.Enabled = false;
                }
            }
        }
    }

    /// <summary>
    /// Stores the checked WP into session
    /// </summary>
    private void StoreWPSelection()
    {
        if (!ShouldStoreWPSelection)
            return;

        GridTableView masterTableView;
        GridTableView detailTableView;
        //Get the master and detail views
        masterTableView = (grdPeriod.Visible)? grdPeriod.MasterTableView:grdInterco.MasterTableView;
        detailTableView = (grdInterco.Visible) ? grdPeriod.MasterTableView.DetailTables[0] : grdInterco.MasterTableView.DetailTables[0]; 
        
        ArrayList selectedItems = new ArrayList();
        
        //Cycle through the items hierarchy
        foreach (GridNestedViewItem nestedViewItem in masterTableView.GetItems(GridItemType.NestedView))
        {
            if (nestedViewItem.NestedTableViews.Length > 0)
            {
                GridTableView itemCollection = nestedViewItem.NestedTableViews[0];
                foreach (GridItem gridItem in itemCollection.Items)
                {
                    if (gridItem is GridEditableItem)
                    {
                        GridEditableItem item = gridItem as GridEditableItem;
                        //Check if the checkbox for the current item is selected
                        CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                        if (chkSelected == null)
                            continue;
                        if (chkSelected.Checked)
                            selectedItems.Add(chkSelected.ClientID);
                    }
                }
            }
        }
        SessionManager.SetSessionValue(this, SELECTED_ITEMS, selectedItems);
    }
    private void RestoreWPSelection()
    {
        GridTableView masterTableView;
        GridTableView detailTableView;
        //Get the master and detail views
        masterTableView = (grdPeriod.Visible) ? grdPeriod.MasterTableView : grdInterco.MasterTableView;
        detailTableView = (grdInterco.Visible) ? grdPeriod.MasterTableView.DetailTables[0] : grdInterco.MasterTableView.DetailTables[0];

        ArrayList selectedItems = SessionManager.GetSessionValueNoRedirect(this, SELECTED_ITEMS) as ArrayList;
        if (selectedItems == null)
            return;

        //Cycle through the items hierarchy
        foreach (GridNestedViewItem nestedViewItem in masterTableView.GetItems(GridItemType.NestedView))
        {
            if (nestedViewItem.NestedTableViews.Length > 0)
            {
                GridTableView itemCollection = nestedViewItem.NestedTableViews[0];
                foreach (GridItem gridItem in itemCollection.Items)
                {
                    if (gridItem is GridEditableItem)
                    {
                        GridEditableItem item = gridItem as GridEditableItem;
                        //Check if the checkbox for the current item is selected
                        CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                        foreach (string chkId in selectedItems)
                        {
                            if (chkId == chkSelected.ClientID)
                                chkSelected.Checked = true;
                        }
                    }
                }
            }
        }
        SessionManager.SetSessionValue(this, SELECTED_ITEMS, selectedItems);
    }

    /// <summary>
    /// Hides the expand/collapse column for the given grid
    /// </summary>
    /// <param name="sender"></param>
    private void HideGridExpandColumn(RadGrid sender)
    {
        //Hide the expand/collapse column
        GridColumn expandColumn = sender.MasterTableView.GetColumn("ExpandColumn");
        expandColumn.ItemStyle.Width = Unit.Pixel(0);
        expandColumn.HeaderStyle.Width = Unit.Pixel(0);
        expandColumn.FooterStyle.Width = Unit.Pixel(0);
        
        foreach (GridDataItem dataItem in sender.MasterTableView.Items)
            dataItem["ExpandColumn"].Controls[0].Visible = false;
    }

    private void HandleIntercoMassAttribution(string issuerArg)
    {
        decimal percent = (SessionManager.GetSessionValueNoRedirect(this, SessionStrings.PERCENT) == null) ? ApplicationConstants.DECIMAL_NULL_VALUE : (decimal)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.PERCENT);

        if (percent == ApplicationConstants.DECIMAL_NULL_VALUE)
        {
            //Hide the expand/collapse column
            HideGridExpandColumn(grdInterco);

            return;
        }

        string columnName = issuerArg.Replace("intercoCol_", "");

        GridTableView masterTableView = grdInterco.MasterTableView;
        GridTableView detailTableView = grdInterco.MasterTableView.DetailTables[0];

        ConversionUtils conversionUtils = new ConversionUtils();

        foreach (GridNestedViewItem nestedViewItem in masterTableView.GetItems(GridItemType.NestedView))
        {
            if (nestedViewItem.NestedTableViews.Length > 0)
            {
                GridTableView itemCollection = nestedViewItem.NestedTableViews[0];
                foreach (GridItem gridItem in itemCollection.Items)
                {
                    if (gridItem is GridEditableItem)
                    {
                        GridEditableItem item = gridItem as GridEditableItem;
                        CheckBox chkSelected = item["SelectWPCol"].FindControl("chkWPCol") as CheckBox;
                        if (chkSelected == null)
                            continue;

                        if (!chkSelected.Checked)
                            continue;
                        int currentWPId = (int)item.GetDataKeyValue("IdWP");
                        int currentPhaseId = (int)item.GetDataKeyValue("IdPhase");

                        foreach (DataRow row in dsInterco.Tables[1].Rows)
                        {
                            if (row.RowState != DataRowState.Deleted)
                            {
                                int wpId = (int)row["IdWP"];
                                int phaseId = (int)row["IdPhase"];
                                if ((currentWPId == wpId) && (currentPhaseId == phaseId))
                                {
                                    row[columnName] = conversionUtils.GetDecimalStringFromObject(Decimal.Round(percent, 2, MidpointRounding.AwayFromZero));
                                    row["IsChanged"] = true;
                                }
                            }
                        }
                    }
                }
            }
        }

        SessionManager.SetSessionValue(this, INTERCO_DATASET, dsInterco);
        SessionManager.RemoveValueFromSession(this, SessionStrings.PERCENT);

        masterTableView.DataSource = dsInterco.Tables[0];
        detailTableView.DataSource = dsInterco.Tables[1];
        grdInterco.Rebind();

        //Hide the expand/collapse column
        HideGridExpandColumn(grdInterco);
    }

    private void SetUnsafeInEditModeControlsEnabledState(bool enabled)
    {
        if (enabled)
        {
            cmbCountries.Enabled = true;
            
            btnAddCountry.Enabled = true;
            btnAddCountry.ImageUrl = "~/Images/button_tab_add_down.png";
            btnAddCountry.ImageUrlOver = "~/Images/button_tab_add_down.png";

            btnSave.Enabled = true;
            btnSave.ImageUrl = "~/Images/button_tab_save.png";
            btnSave.ImageUrlOver = "~/Images/button_tab_save.png";
        }
        else
        {
            cmbCountries.Enabled = false;

            btnAddCountry.Enabled = false;
            btnAddCountry.ImageUrl = "~/Images/button_tab_add_down_disabled.png";
            btnAddCountry.ImageUrlOver = "~/Images/button_tab_add_down_disabled.png";

            btnSave.Enabled = false;
            btnSave.ImageUrl = "~/Images/button_tab_save_disabled.png";
            btnSave.ImageUrlOver = "~/Images/button_tab_save_disabled.png";
        }
    }

    private void RemoveDeletedRow(DataRow row, DataTable table)
    {
        foreach (DataRow deletedRow in table.Rows)
        {
            //If the row is deleted
            if (deletedRow.RowState == DataRowState.Deleted)
            {
                deletedRow.RejectChanges();
                //Find the row with the same key as the one that has just been added and remove it from the table
                if (deletedRow["IdProject"].ToString() == row["IdProject"].ToString() &&
                    deletedRow["IdPhase"].ToString() == row["IdPhase"].ToString() &&
                    deletedRow["IdWP"].ToString() == row["IdWP"].ToString())
                {
                    table.Rows.Remove(deletedRow);
                    return;
                }
                //Set the row back to its deleted state
                deletedRow.Delete();
            }
        }
    }

    private void RemoveRowsFromEditMode(RadGrid grid)
    {
        bool rebind = false;
        foreach (GridItem item in grid.EditItems)
        {
            if (item.IsInEditMode)
            {
                rebind = true;
                item.Edit = false;
            }
        }
        if (rebind)
            grid.Rebind();
    }

    private void DeleteWPPeriod(int currentPhaseId, int currentWPId)
    {
        //Search the found key in the timing tab
        for (int i = 0; i < dsPeriod.Tables[1].Rows.Count; i++)
        {
            DataRow row = dsPeriod.Tables[1].Rows[i];
            if (row.RowState != DataRowState.Deleted)
            {
                if (row.RowState != DataRowState.Deleted)
                {
                    int wpId = (int)row["IdWP"];
                    int phaseId = (int)row["IdPhase"];
                    {
                        //If the key is found, update the columns
                        if ((currentWPId == wpId) && (currentPhaseId == phaseId))
                        {
                            SetRowUnaffected(wpId, phaseId, row);
                            row.Delete();
                            CheckMasterRow(phaseId, dsPeriod);
                        }
                    }
                }
            }
        }

        //Search the found key in the interco tab
        for (int i = 0; i < dsInterco.Tables[1].Rows.Count; i++)
        {
            DataRow row = dsInterco.Tables[1].Rows[i];
            if (row.RowState != DataRowState.Deleted)
            {
                int wpId = (int)row["IdWP"];
                int phaseId = (int)row["IdPhase"];
                {
                    //If the key is found, update the columns
                    if ((currentWPId == wpId) && (currentPhaseId == phaseId))
                    {
                        //The WP is already unaffected from the Period TAB
                        row.Delete();
                        CheckMasterRow(phaseId, dsInterco);
                    }
                }
            }
        }
    }
    private void DeleteWPInterco(int currentPhaseId, int currentWPId)
    {
        //Search the found key in the timing tab
        for (int i = 0; i < dsInterco.Tables[1].Rows.Count; i++)
        {
            DataRow row = dsInterco.Tables[1].Rows[i];
            if (row.RowState != DataRowState.Deleted)
            {
                int wpId = (int)row["IdWP"];
                int phaseId = (int)row["IdPhase"];
                {
                    //If the key is found, update the columns
                    if ((currentWPId == wpId) && (currentPhaseId == phaseId))
                    {
                        SetRowUnaffected(wpId, phaseId, row);
                        row.Delete();
                        CheckMasterRow(phaseId, dsInterco);
                    }
                }
            }
        }

        //Search the found key in the interco tab
        for (int i = 0; i < dsPeriod.Tables[1].Rows.Count; i++)
        {
            DataRow row = dsPeriod.Tables[1].Rows[i];
            if (row.RowState != DataRowState.Deleted)
            {
                int wpId = (int)row["IdWP"];
                int phaseId = (int)row["IdPhase"];
                {
                    //If the key is found, update the columns
                    if ((currentWPId == wpId) && (currentPhaseId == phaseId))
                    {
                        //The WP is already unaffected from the Period TAB
                        //SetRowUnaffected(wpId, phaseId, row);
                        row.Delete();
                        CheckMasterRow(phaseId, dsPeriod);
                    }
                }
            }
        }
    }

    private bool UpdateWP(GridEditableItem item, Hashtable newValues, GridCommandEventArgs e)
    {
        //The ids are mandatory
        int wpId = (int)item.GetDataKeyValue("IdWP");
        int phaseId = (int)item.GetDataKeyValue("IdPhase");

        foreach (DataRow row in dsInterco.Tables[1].Rows)
        {
            if (row.RowState != DataRowState.Deleted)
            {
                int rowWpId = (int)row["IdWP"];
                int rowPhaseId = (int)row["IdPhase"];
                string wpName = row["WPCode"].ToString();
                if ((rowWpId == wpId) && (rowPhaseId == phaseId))
                {
                    decimal percentSum = 0;
                    ArrayList errors = new ArrayList();
                    Hashtable rowValues = new Hashtable();
                    for (int i = TimingAndInterco.FirstCountryColumn; i < dsInterco.Tables[1].Columns.Count; i++)
                    {
                        string columnName = dsInterco.Tables[1].Columns[i].ColumnName;
                        string columnCaption = dsInterco.Tables[1].Columns[i].Caption;

                        if (columnName != "IsChanged")
                        {
                            #region Validate row
                            decimal countryPercent;
                            if (newValues[columnName] == null || decimal.TryParse(newValues[columnName].ToString(), out countryPercent) == false)
                            {
                                errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_PERCENT_COUNTRY_IS_INVALID, wpName, columnCaption));
                                continue;
                            }
                            if ((countryPercent < 0) || (countryPercent > 100))
                            {
                                errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_PERCENT_COUNTRY_IS_INVALID, wpName, columnCaption));
                                continue;
                            }
                            //Add to the sum of percents, the percent of the current country, rounded to 2 decimals
                            percentSum += Decimal.Round(countryPercent, 2, MidpointRounding.AwayFromZero);
                            #endregion Validate row

                            rowValues.Add(columnName, (newValues[columnName] == null) ? (object)DBNull.Value : (object)Decimal.Round(countryPercent, 2, MidpointRounding.AwayFromZero));
                        }
                    }
                    if (percentSum > 100)
                        errors.Add(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_PERCENT_SUM_GREATER_THAN_MAXIMUM, wpName));
                    if (errors.Count != 0)
                    {
                        this.ShowError(errors);
                        e.Canceled = true;

                        SetUnsafeInEditModeControlsEnabledState(false);

                        //Restore the rounded values of the percents to the current row
                        foreach (DictionaryEntry entry in rowValues)
                        {
                            ConversionUtils conversionUtils = new ConversionUtils();
                            ((TextBox)item[entry.Key.ToString()].Controls[0]).Text = conversionUtils.GetDecimalStringFromObject(entry.Value);
                        }

                        return false;
                    }
                    else
                    {
                        foreach (DictionaryEntry entry in rowValues)
                        {
                            ConversionUtils conversionUtils = new ConversionUtils();
                            row[entry.Key.ToString()] = conversionUtils.GetDecimalStringFromObject(entry.Value);
                        }
                        row["IsChanged"] = true;
                    }
                }
            }
        }
        return true;
    }

    private void StoreEditedCostCentersInterco(TimingAndInterco key)
    {
        List<TimingAndInterco> editingIntercos = new List<TimingAndInterco>();

        object connManager = SessionManager.GetConnectionManager(this);

        foreach (GridDataItem item in grdInterco.Items)
        {
            if (item.OwnerTableView.Name == grdInterco.MasterTableView.DetailTables[0].Name && item.IsInEditMode)
            {

                //Get only the key to use it for comparison. We don't take the values beacuse if one value is incorrect, an error
                //is displayed wich is not corect beacuse the user just pressed cancel
                TimingAndInterco newKey = new TimingAndInterco(connManager);

                if ((key != null) && (SessionManager.GetCurrentProject(this).Id == key.IdProject)
                    && (int.Parse(item.SavedOldValues["IdPhase"].ToString()) == key.IdPhase)
                    && (int.Parse(item.SavedOldValues["IdWP"].ToString()) == key.IdWP))
                    continue;


                //If it's ok, get also the values
                newKey = new TimingAndInterco(connManager);
                newKey.IntercoCountries = new List<IIntercoCountry>();

                newKey.IdProject = SessionManager.GetCurrentProject(this).Id;
                newKey.IdPhase = int.Parse(item.SavedOldValues["IdPhase"].ToString());
                newKey.IdWP = int.Parse(item.SavedOldValues["IdWP"].ToString());

                Hashtable newValues = new Hashtable();
                item.ExtractValues(newValues);

                for (int i = TimingAndInterco.FirstCountryColumn; i < dsInterco.Tables[0].Columns.Count; i++)
                {
                    IIntercoCountry country = new IntercoCountry(connManager);
                    country.IdCountry = int.Parse(dsInterco.Tables[0].Columns[i].ColumnName);
                    
                    decimal percent;
                    if (newValues[dsInterco.Tables[0].Columns[i].ColumnName] == null || decimal.TryParse(newValues[dsInterco.Tables[0].Columns[i].ColumnName].ToString(), out percent) == false)
                        country.Percent = ApplicationConstants.DECIMAL_NULL_VALUE;
                    else
                        country.Percent = percent;
                    
                    newKey.IntercoCountries.Add(country);
                }

                editingIntercos.Add(newKey);
            }
        }
        SessionManager.SetSessionValue(this, EDITED_WPS_INTERCO, editingIntercos);
    }

    /// <summary>
    /// Restores the values from the session for the cost centers that are in editing mode
    /// </summary>
    private void RestoreEditedCostCentersInterco()
    {
        List<TimingAndInterco> editingIntercos = new List<TimingAndInterco>();
        //Get the list from the session
        editingIntercos = SessionManager.GetSessionValueNoRedirect(this, EDITED_WPS_INTERCO) as List<TimingAndInterco>;
        if (editingIntercos == null)
            return;

        //Find the correspondig datarow for each cost center in the list and update the correspondig
        //data row from the data source
        foreach (TimingAndInterco interco in editingIntercos)
        {
            GridDataItem dataItem = GetDataItem(interco, grdInterco);

            if (dataItem != null && dataItem.IsInEditMode)
            {
                for (int i = TimingAndInterco.FirstCountryColumn; i < dsInterco.Tables[0].Columns.Count; i++)
                {
                    int idCountry = int.Parse(dsInterco.Tables[0].Columns[i].ColumnName);
                    IIntercoCountry intercoCountry = null;
                    foreach (IIntercoCountry country in interco.IntercoCountries)
                    {
                        if (country.IdCountry == idCountry)
                        {
                            intercoCountry = country;
                            break;
                        }
                    }
                    if (intercoCountry != null)
                    {
                        ((TextBox)dataItem[idCountry.ToString()].Controls[0]).Text = (intercoCountry.Percent == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : intercoCountry.Percent.ToString();
                    }
                }

            }
        }

        //Delete the values from the session
        SessionManager.SetSessionValue(this, EDITED_WPS_INTERCO, null);
    }

    private GridDataItem GetDataItem(TimingAndInterco interco, RadGrid grid)
    {
        foreach (GridDataItem item in grid.Items)
        {
            if (item.OwnerTableView.Name == grid.MasterTableView.DetailTables[0].Name)
            {
                if (item.IsInEditMode)
                {
                    if (int.Parse(item.SavedOldValues["IdPhase"].ToString()) == interco.IdPhase
                        && int.Parse(item.SavedOldValues["IdWP"].ToString()) == interco.IdWP)
                        return item;
                }
            }
        }
        return null;
    }

    private void StoreEditedCostCentersPeriod(TimingAndInterco key)
    {
        List<TimingAndInterco> editingIntercos = new List<TimingAndInterco>();

        object connManager = SessionManager.GetConnectionManager(this);

        foreach (GridDataItem item in grdPeriod.Items)
        {
            if (item.OwnerTableView.Name == grdPeriod.MasterTableView.DetailTables[0].Name && item.IsInEditMode)
            {

                //Get only the key to use it for comparison. We don't take the values beacuse if one value is incorrect, an error
                //is displayed wich is not corect beacuse the user just pressed cancel
                TimingAndInterco newKey = new TimingAndInterco(connManager);

                if ((key != null) && (SessionManager.GetCurrentProject(this).Id == key.IdProject)
                    && (int.Parse(item.SavedOldValues["IdPhase"].ToString()) == key.IdPhase)
                    && (int.Parse(item.SavedOldValues["IdWP"].ToString()) == key.IdWP))
                    continue;


                //If it's ok, get also the values
                newKey = new TimingAndInterco(connManager);

                newKey.IdProject = SessionManager.GetCurrentProject(this).Id;
                newKey.IdPhase = int.Parse(item.SavedOldValues["IdPhase"].ToString());
                newKey.IdWP = int.Parse(item.SavedOldValues["IdWP"].ToString());

                Hashtable newValues = new Hashtable();
                item.ExtractValues(newValues);

                newKey.StartYearMonth = int.Parse(newValues["StartYearMonth"].ToString());
                newKey.EndYearMonth = int.Parse(newValues["EndYearMonth"].ToString());

                editingIntercos.Add(newKey);
            }
        }
        SessionManager.SetSessionValue(this, EDITED_WPS_PERIOD, editingIntercos);
    }

    private void RestoreEditedCostCentersPeriod()
    {
        List<TimingAndInterco> editingIntercos = new List<TimingAndInterco>();
        //Get the list from the session
        editingIntercos = SessionManager.GetSessionValueNoRedirect(this, EDITED_WPS_PERIOD) as List<TimingAndInterco>;
        if (editingIntercos == null)
            return;

        //Find the correspondig datarow for each cost center in the list and update the correspondig
        //data row from the data source
        foreach (TimingAndInterco interco in editingIntercos)
        {
            GridDataItem dataItem = GetDataItem(interco, grdPeriod);

            if (dataItem != null && dataItem.IsInEditMode)
            {
                ((IndYearMonth)dataItem["StartYearMonth"].Controls[1]).SetValue(interco.StartYearMonth.ToString());
                ((IndYearMonth)dataItem["EndYearMonth"].Controls[1]).SetValue(interco.EndYearMonth.ToString());
            }
        }

        //Delete the values from the session
        SessionManager.SetSessionValue(this, EDITED_WPS_PERIOD, null);
    }
    #endregion Private Methods
}
