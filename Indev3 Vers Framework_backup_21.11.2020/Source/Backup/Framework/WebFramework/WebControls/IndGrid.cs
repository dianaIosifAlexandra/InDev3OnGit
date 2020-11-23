using System;
using System.Collections.Generic;
using System.Text;

using System.ComponentModel;
using System.Drawing;
using System.Web.UI;

using System.Web.UI.WebControls;

using Telerik.WebControls;

using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Collections;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.WebFramework.WebControls
{
    [DefaultProperty("Items")]
    [ToolboxBitmap(typeof(Telerik.WebControls.RadGrid))]
    [ToolboxData("<{0}:IndGrid runat=\"server\"></{0}:IndGrid>")]
    public class IndGrid : RadGrid
    {
		DataTable exportDataTable = new DataTable();
    
        #region Members
        private BudgetPreselectionLayout layout;
        
        /// <summary>
        /// Specify if the budget layout was applied
        /// </summary>
        private bool windowLayoutInitialized
        {
            get
            {
                if (Page.Session["WindowLayoutInitialized"] == null)
                    return false;
                return (bool)Page.Session["WindowLayoutInitialized"];
            }
            set
            {
                Page.Session["WindowLayoutInitialized"] = value;
            }
        }

        private const string EXPAND_STATE_SESSION_STRING = "ExpandedItemState";

        private Hashtable _ExpandedStates;
        /// <summary>
        /// Holds the expanded state for each data grid item
        /// </summary>
        public Hashtable ExpandedStates
        {
            get
            {
                if (this._ExpandedStates == null)
                {
                    _ExpandedStates = Page.Session[EXPAND_STATE_SESSION_STRING] as Hashtable;
                    if (_ExpandedStates == null)
                    {
                        _ExpandedStates = new Hashtable();
                        Page.Session[EXPAND_STATE_SESSION_STRING] = _ExpandedStates;
                    }
                }
                return this._ExpandedStates;
            }
        }

        internal ControlHierarchyManager ControlHierarchyManager;
        #endregion Members

        #region Constructors
        public IndGrid()
        {
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructors

        #region Public Methods
        public virtual void SaveOldValues()
        {

        }

		public void ExportData(string budgetType, bool isValidationGrid)
		{
			try
			{
				switch(budgetType)
				{
					case ApplicationConstants.BUDGET_TYPE_REVISED:
						FillExportDataTableRevised(isValidationGrid);
						break;
					case ApplicationConstants.BUDGET_TYPE_TOCOMPLETION:
						FillExportDataTableReforecast();
						break;							
				}
				
				//StringBuilder that will hold the contents of the csv file to be exported
				StringBuilder fileContent = new StringBuilder();
				//List holding column names
				List<string> columnNames = new List<string>();
				foreach (DataColumn column in exportDataTable.Columns)
				{
					columnNames.Add(column.ColumnName);
					//Add the header text to the StringBuilder object that holds the contents of the csv file
					fileContent.Append("\"" + column.ColumnName + "\";");
				}
				//Remove the last semicolon in the header
				fileContent.Remove(fileContent.Length - 1, 1);
				//Get the datarows from the grid which obey the filter condition
				DataRow[] rows = exportDataTable.Select();
				
				if (rows.Length > 0)
				{
					//Append the actual grid contents to the StringBuilder
					fileContent.Append(DSUtils.BuildCSVExport(rows, columnNames, true));
				}
				//Download the file
				DownloadUtils.DownloadFile(ApplicationConstants.DEFAULT_BUDGET_EXPORT_FILE_NAME, fileContent.ToString());
			}
			catch (IndException ex)
			{
				ControlHierarchyManager.ReportError(ex);
				return;
			}
			catch (Exception ex)
			{
				ControlHierarchyManager.ReportError(new IndException(ex));
				return;
			}
		}

        #endregion Public Methods

        #region Event Handlers
        protected override void OnLoad(EventArgs e)
        {
            try
            {
                base.OnLoad(e);
                //Get the referer page of this page
                string referer = Page.Request.Headers["Referer"];

                if (!Page.IsPostBack && !String.IsNullOrEmpty(referer))
                {
                    windowLayoutInitialized = false;
                    this._ExpandedStates = null;
                    Page.Session[EXPAND_STATE_SESSION_STRING] = null;

                    layout = (BudgetPreselectionLayout)SessionManager.GetSessionValueRedirect(this.Page, SessionStrings.BUDGET_LAYOUT);
                    if (layout == null)
                    {
                        throw new IndException(ApplicationMessages.EXCEPTION_BUDGET_LAYOUT_MISSING);
                    }
                    if (layout.IsViewAllFromFollowUp)
                    {
                        this.MasterTableView.HierarchyDefaultExpanded = true;
                        this.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = false;
                    }
                    else
                    {
                        if (Page.Request.Url.ToString().Contains("InitialBudget.aspx"))
                        {
                            this.MasterTableView.HierarchyDefaultExpanded = layout.AllExpandedInitial;
                            this.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = layout.AllExpandedInitial;
                        }
                        if (Page.Request.Url.ToString().Contains("RevisedBudget.aspx"))
                        {
                            this.MasterTableView.HierarchyDefaultExpanded = layout.AllExpandedRevised;
                            this.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = layout.AllExpandedRevised;
                        }
                        if (Page.Request.Url.ToString().Contains("ReforecastBudget.aspx"))
                        {
                            this.MasterTableView.HierarchyDefaultExpanded = layout.AllExpandedReforecast;
                            this.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = layout.AllExpandedReforecast;
                        }
                    }
                    this.Rebind();
                }
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return;
            }
            catch (Exception exc)
            {
                ControlHierarchyManager.ReportError(new IndException(exc));
                return;
            }
        }

        protected override void OnDataBound(EventArgs e)
        {
            try
            {
                base.OnDataBound(e);
                if (!windowLayoutInitialized)
                {
                    windowLayoutInitialized = true;

                    if (layout == null)
                        return;

                    if (Page.Request.Url.ToString().Contains("InitialBudget.aspx"))
                    {
                        if (!layout.AllExpandedInitial)
                            return;
                    }
                    if (Page.Request.Url.ToString().Contains("RevisedBudget.aspx"))
                    {
                        if (!layout.AllExpandedRevised)
                            return;
                    }
                    if (Page.Request.Url.ToString().Contains("ReforecastBudget.aspx"))
                    {
                        if (!layout.AllExpandedReforecast)
                            return;
                    }

                    foreach (GridDataItem gridItem in this.Items)
                    {
                        this.ExpandedStates.Add(gridItem.ItemIndexHierarchical, true);
                    }
                }

                //Expand all items using our custom storage
                string[] indexes = new string[this.ExpandedStates.Keys.Count];
                this.ExpandedStates.Keys.CopyTo(indexes, 0);

                ArrayList arr = new ArrayList(indexes);
                //Sort so we can guarantee that a parent item is expanded before any of 
                //its children
                arr.Sort();

                foreach (string key in arr)
                {
                    bool value = (bool)this.ExpandedStates[key];
                    try
                    {
                        if (value)
                        {
                            this.Items[key].Expanded = true;
                        }
                        else
                        {
                            this.Items[key].Expanded = false;
                        }
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        //This exception ocurrs when the given key (hierarchical index) is not contained in the Items collection of the grid (when a 
                        //cost center is deleted, for example).
                        //this.ExpandedStates.Remove(key);
                    }
                }
            }
            catch (IndException indExc)
            {
                ControlHierarchyManager.ReportError(indExc);
                return;
            }
            catch (Exception exc)
            {
                ControlHierarchyManager.ReportError(new IndException(exc));
                return;
            }
        }

        protected override void OnItemCommand(GridCommandEventArgs e)
        {
            try
            {
                base.OnItemCommand(e);
                //save the expanded/selected state in the session
                if (e.CommandName == RadGrid.ExpandCollapseCommandName)
                {
                    SaveOldValues();
                    //Is the item about to be expanded or collapsed
                    if (!e.Item.Expanded)
                    {
                        //Save its unique index among all the items in the hierarchy
                        this.ExpandedStates[e.Item.ItemIndexHierarchical] = true;
                    }
                    else //collapsed
                    {
                        this.ExpandedStates[e.Item.ItemIndexHierarchical] = false;

                        GridEditCommandColumn editColumn = GetEditCommandColumn((GridDataItem)e.Item);
                        if (editColumn != null && e.Item.IsInEditMode)
                        {
                            SetItemOutOfEditMode(e.Item);
                            Rebind();
                        }
                        //this.ClearExpandedChildren(e.Item.ItemIndexHierarchical);
                    }
                }
            }
            catch (IndException indExc)
            {
                ControlHierarchyManager.ReportError(indExc);
                return;
            }
            catch (Exception exc)
            {
                ControlHierarchyManager.ReportError(new IndException(exc));
                return;
            }
        }

        private void SetItemOutOfEditMode(GridItem gridItem)
        {
            if (gridItem.OwnerTableView.Name == MasterTableView.DetailTables[0].DetailTables[0].Name)
                return;

            if (gridItem.OwnerTableView.Name == MasterTableView.Name)
            {
                gridItem.Edit = false;
            }

            if (gridItem.OwnerTableView.Name == MasterTableView.DetailTables[0].Name)
            {
                bool setMasterItemOutOfEditMode = true;
                gridItem.Edit = false;
                foreach (GridDataItem item in gridItem.OwnerTableView.Items)
                {
                    if (item != gridItem && item.IsInEditMode)
                    {
                        setMasterItemOutOfEditMode = false;
                        break;
                    }
                }
                if (setMasterItemOutOfEditMode)
                    gridItem.OwnerTableView.ParentItem.Edit = false;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);

                //For each dataitem in the grid, show or hide its expand/collaspe image, depending on whether it has child items
                foreach (GridDataItem dataItem in this.Items)
                {
                    //If the item is in the last detail table, do nothing
                    if (dataItem.OwnerTableView.Name == MasterTableView.DetailTables[0].DetailTables[0].Name)
                        continue;

                    AdjustNoChildItems(dataItem);
                    HideEditCommandColumn(dataItem);
                    DisableEditCommandColumnWhenItemCollapsed(dataItem);
                }
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
            }
            catch (Exception exc)
            {
                ControlHierarchyManager.ReportError(new IndException(exc));
                return;
            }
        }

        protected override void OnEditCommand(GridCommandEventArgs e)
        {
            try
            {
                //If the user selects to edit a row which has child items, put all child items in edit mode
                GridDataItem dataItem = (GridDataItem)e.Item;
                if (dataItem.OwnerTableView.Name == MasterTableView.Name)
                {
                    GridTableView detailTableView = dataItem.ChildItem.NestedTableViews[0];
                    for (int j = 0; j < detailTableView.Items.Count; j++)
                    {
                        if (detailTableView.GetColumnSafe("IsActive") != null)
                        {
                            bool isWPActive;
                            //Check if the current wp is active
                            if (bool.TryParse(detailTableView.Items[j]["IsActive"].Text, out isWPActive) == false)
                                throw new IndException("Value of 'IsActive' column must be of boolean type.");

                            if (isWPActive)
                            {
                                GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                                if (lastTableView.Items.Count > 0)
                                {
                                    detailTableView.Items[j].Edit = true;
                                }
                                for (int k = 0; k < lastTableView.Items.Count; k++)
                                {
                                    lastTableView.Items[k].Edit = true;
                                }
                            }
                        }
                    }
                }
                if (dataItem.OwnerTableView.Name == MasterTableView.DetailTables[0].Name)
                {
                    GridTableView lastTableView = dataItem.ChildItem.NestedTableViews[0];
                    for (int k = 0; k < lastTableView.Items.Count; k++)
                    {
                        lastTableView.Items[k].Edit = true;
                    }
                    if (!dataItem.OwnerTableView.ParentItem.IsInEditMode)
                    {
                        dataItem.OwnerTableView.ParentItem.Edit = true;
                    }
                }

                //If the user puts in edit mode an item with parent items, the parent items must be put in edit mode as well,
                //in which case the grid needs to rebind
                if (dataItem.OwnerTableView.Name == MasterTableView.DetailTables[0].DetailTables[0].Name)
                {
                    if (!dataItem.OwnerTableView.ParentItem.IsInEditMode)
                    {
                        dataItem.OwnerTableView.ParentItem.Edit = true;
                    }
                    if (!dataItem.OwnerTableView.ParentItem.OwnerTableView.ParentItem.IsInEditMode)
                    {
                        dataItem.OwnerTableView.ParentItem.OwnerTableView.ParentItem.Edit = true;
                    }
                }
                base.OnEditCommand(e);
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
            }
            catch (Exception exc)
            {
                ControlHierarchyManager.ReportError(new IndException(exc));
                return;
            }
        }

        #endregion Event Handlers

        #region Private Methods
        /// <summary>
        /// Hides the expand/collaspe image of the given data item, if the item does not have any child items
        /// </summary>
        /// <param name="dataItem"></param>
        private void AdjustNoChildItems(GridDataItem dataItem)
        {
            if (HasChildItems(dataItem))
                return;
            
            TableCell cell = dataItem["ExpandColumn"];
            ImageButton expandCollapseButton = (ImageButton)cell.Controls[0];

            expandCollapseButton.Visible = false;
            dataItem.ChildItem.Visible = false;
        }

        /// <summary>
        /// Checks whether the given dataItem has child items by searching in the underlying datasource
        /// </summary>
        /// <param name="dataItem">the dataitem whose child items are searched for</param>
        /// <returns>true if the given dataItem has child items, false otherwise</returns>
        private bool HasChildItems(GridDataItem dataItem)
        {
            GridTableView ownerTableView = dataItem.OwnerTableView;
            if (ownerTableView.Name == this.MasterTableView.DetailTables[0].DetailTables[0].Name)
                return false;

            //Holds the values of the master item which will be searched for in the detail table
            List<int> masterValues = new List<int>();
            //Holds the keys in the detail table which will be searched for the master values
            List<string> detailKeys = new List<string>();

            //Populate the masterValues and detailKeys lists
            for (int i = 0; i < ownerTableView.DetailTables[0].ParentTableRelation.Count; i++)
            {
                masterValues.Add(int.Parse(dataItem[ownerTableView.DetailTables[0].ParentTableRelation[i].MasterKeyField].Text));
                detailKeys.Add(ownerTableView.DetailTables[0].ParentTableRelation[i].DetailKeyField);
            }

            //Gets the datatable of the child elements of nestedViewItem in which we will search for child elements of nestedViewItem
            DataTable tblChild = (DataTable)ownerTableView.DetailTables[0].DataSource;

            //If for some reason (the way the internal mechanism of radgrid works) the underlying dataTable in null, we return
            //true, meaning that for the given item, no action (hiding the expand/collapse item) will be taken. This has been tested
            //and it works in every situation
            if (tblChild == null)
                return true;

            bool found = false;

            //Search through the rows in the underlying datatable for the keys in the detail table whose values must match those
            //in masterValues
            foreach (DataRow row in tblChild.Rows)
            {
                found = true;
                for (int i = 0; i < masterValues.Count; i++)
                {
                    //If there is at least one key that does not have the master value, go to the next row
                    if ((int)row[detailKeys[i]] != masterValues[i])
                    {
                        found = false;
                        break;
                    }
                }
                //If at least one detail row was found in the detail table, break from the foreach loop
                if (found)
                    break;
            }

            return found;
        }

        /// <summary>
        /// Checks if the given dataItem has detail-most child items (i.e.: if a phase has any cc's or if a wp has any cc's)
        /// </summary>
        /// <param name="dataItem"></param>
        /// <returns></returns>
        private bool HasDetailMostChildItems(GridDataItem dataItem)
        {
            GridTableView ownerTableView = dataItem.OwnerTableView;
            if (ownerTableView.Name == MasterTableView.DetailTables[0].DetailTables[0].Name)
                return false;

            int idPhase = int.Parse(dataItem["IdPhase"].Text);

            DataTable tblChild = (DataTable)MasterTableView.DetailTables[0].DetailTables[0].DataSource;
            //If for some reason (the way the internal mechanism of radgrid works) the underlying dataTable in null, we return
            //true, meaning that for the given item, no action (hiding the expand/collapse item) will be taken. This has been tested
            //and it works in every situation
            if (tblChild == null)
                return true;

            foreach (DataRow row in tblChild.Rows)
                if ((int)row["IdPhase"] == idPhase)
                    return true;
            return false;
        }

        /// <summary>
        /// Makes all children colapsed. This method is not used for now beacause there is no request for this
        /// </summary>
        /// <param name="parentHierarchicalIndex">The master item index</param>
        private void ClearExpandedChildren(string parentHierarchicalIndex)
        {
            string[] indexes = new string[this.ExpandedStates.Keys.Count];
            this.ExpandedStates.Keys.CopyTo(indexes, 0);
            foreach (string index in indexes)
            {
                //all indexes of child items
                if (index.StartsWith(parentHierarchicalIndex + "_") ||
                    index.StartsWith(parentHierarchicalIndex + ":"))
                {
                    this.ExpandedStates[index] = false;
                }
            }
        }

        /// <summary>
        /// Hides the edit column of this data item if there are no detail items to edit
        /// </summary>
        /// <param name="dataItem"></param>
        private void HideEditCommandColumn(GridDataItem dataItem)
        {
            if (dataItem.OwnerTableView.Name == MasterTableView.DetailTables[0].DetailTables[0].Name)
                return;

            GridEditCommandColumn editColumn = GetEditCommandColumn(dataItem);
            if (editColumn == null)
                return;

            if (dataItem.OwnerTableView.Name == MasterTableView.Name)
            {
                if (!HasDetailMostChildItems(dataItem))
                {
                    if (dataItem.IsInEditMode)
                        dataItem.Edit = false;
                    dataItem[editColumn].Controls[0].Visible = false;
                }
            }
            if (dataItem.OwnerTableView.Name == MasterTableView.DetailTables[0].Name)
            {
                if (!HasChildItems(dataItem))
                {
                    if (dataItem.IsInEditMode)
                        dataItem.Edit = false;
                    dataItem[editColumn].Controls[0].Visible = false;
                }
            }
        }

        private GridEditCommandColumn GetEditCommandColumn(GridDataItem dataItem)
        {
            foreach (GridColumn column in dataItem.OwnerTableView.Columns)
                if (column is GridEditCommandColumn)
                    return (GridEditCommandColumn)column;
            return null;
        }

        private void DisableEditCommandColumnWhenItemCollapsed(GridDataItem dataItem)
        {
            if (dataItem.OwnerTableView.Name == MasterTableView.DetailTables[0].DetailTables[0].Name)
                return;

            GridEditCommandColumn editColumn = GetEditCommandColumn(dataItem);
            if (editColumn == null)
                return;

            if (dataItem.OwnerTableView.Name == MasterTableView.Name)
            {
                if (!dataItem.Expanded)
                {
                    ((ImageButton)dataItem[editColumn].Controls[0]).Enabled = false;
                    return;
                }

                bool disableEditCommandMasterItem = true;
                foreach (GridDataItem detailItem in dataItem.ChildItem.NestedTableViews[0].Items)
                {
                    if (detailItem.Expanded)
                    {
                        disableEditCommandMasterItem = false;
                        break;
                    }
                }
                ((ImageButton)dataItem[editColumn].Controls[0]).Enabled = !disableEditCommandMasterItem;
            }

            if (dataItem.OwnerTableView.Name == MasterTableView.DetailTables[0].Name)
            {
                ((ImageButton)dataItem[editColumn].Controls[0]).Enabled = dataItem.Expanded;
            }
        }

		private string GetTableCellValue(GridDataItem gridDataItem, string colName)
		{
			if (gridDataItem[colName] == null)
				return String.Empty;

			if (((GridEditableItem)gridDataItem)[colName].Controls.Count == 1)
			{
				return ((TextBox)((GridEditableItem)gridDataItem)[colName].Controls[0]).Text;
			}
			else if (((GridEditableItem)gridDataItem)[colName].Controls.Count == 3) //special case from Revised Budget - Costs & Sales tab
			{
				return ((IndFormatedLabel)((GridEditableItem)gridDataItem)[colName].Controls[1]).Text;
			}

			return gridDataItem[colName].Text.Equals("&nbsp;") ? String.Empty : gridDataItem[colName].Text;
		}
		
		private string Strip(string text)
		{
			return System.Text.RegularExpressions.Regex.Replace(text, @"<(.|\n)*?>", " ");
		}

		private void FillExportDataTableReforecast()
		{
			object[] arr = new object[10];
			DataRow row;

			GridTableView masterTableView = this.MasterTableView;

			exportDataTable.Columns.Clear();
			exportDataTable.Columns.Add(" ", typeof(String));
			exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("Progress").HeaderText), typeof(String));
			exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("DateInterval").HeaderText), typeof(String));
			exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("Previous").HeaderText), typeof(String));
			exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("CurrentPreviousDiffString").HeaderText), typeof(String));
			exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("Current").HeaderText), typeof(String));
			exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("NewCurrentDiffString").HeaderText) + " ", typeof(String));
			exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("New").HeaderText), typeof(String));
			exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("NewRevisedDiffString").HeaderText) + "  ", typeof(String));
			exportDataTable.Columns.Add("Revised", typeof(String));
			
			for (int i = 0; i < masterTableView.Items.Count; i++)
			{
				GridDataItem masterItem = masterTableView.Items[i];
				arr[0] = GetTableCellValue(masterItem, "PhaseWPName");
				arr[1] = GetTableCellValue(masterItem, "Progress");
				arr[2] = GetTableCellValue(masterItem, "DateInterval");
				arr[3] = GetTableCellValue(masterItem, "Previous");
				arr[4] = GetTableCellValue(masterItem, "CurrentPreviousDiff");
				arr[5] = GetTableCellValue(masterItem, "Current");
				arr[6] = GetTableCellValue(masterItem, "NewCurrentDiff");
				arr[7] = GetTableCellValue(masterItem, "New");
				arr[8] = GetTableCellValue(masterItem, "NewRevisedDiff");
				arr[9] = GetTableCellValue(masterItem, "Revised");

				row = exportDataTable.NewRow();
				row.ItemArray = arr;
				exportDataTable.Rows.Add(row); 
				
				
				GridTableView detailTableView = masterTableView.Items[i].ChildItem.NestedTableViews[0];
                for (int j = 0; j < detailTableView.Items.Count; j++)
                {
					GridDataItem detailItem = detailTableView.Items[j];
					arr[0] = String.Concat("   (", GetTableCellValue(detailItem, "CurrencyCode"), ") ", GetTableCellValue(detailItem, "CostCenterName"));
					arr[1] = String.Empty;
					arr[2] = String.Empty;
					arr[3] = GetTableCellValue(detailItem, "Previous");
					arr[4] = GetTableCellValue(detailItem, "CurrentPreviousDiff");
					arr[5] = GetTableCellValue(detailItem, "Current");
					arr[6] = GetTableCellValue(detailItem, "NewCurrentDiff");
					arr[7] = GetTableCellValue(detailItem, "New");
					arr[8] = GetTableCellValue(detailItem, "NewRevisedDiff");
					arr[9] = String.Empty;

					row = exportDataTable.NewRow();
					row.ItemArray = arr;
					exportDataTable.Rows.Add(row); 
					
					
					GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                    for (int k = 0; k < lastTableView.Items.Count; k++)
                    {
						GridDataItem detailDetailItem = lastTableView.Items[k];
						arr[0] = String.Empty;
						arr[1] = String.Empty;
						arr[2] = GetTableCellValue(detailDetailItem, "Date");
						arr[3] = GetTableCellValue(detailDetailItem, "Previous");
						arr[4] = GetTableCellValue(detailDetailItem, "CurrentPreviousDiff");
						arr[5] = GetTableCellValue(detailDetailItem, "Current");
						arr[6] = GetTableCellValue(detailDetailItem, "NewCurrentDiff");
						arr[7] = GetTableCellValue(detailDetailItem, "New");
						arr[8] = GetTableCellValue(detailDetailItem, "NewRevisedDiff");
						arr[9] = String.Empty;

						row = exportDataTable.NewRow();
						row.ItemArray = arr;
						exportDataTable.Rows.Add(row); 
                    }
                }
			}
		}

		private void FillExportDataTableRevised(bool isValidationGrid)
		{
			object[] arr = new object[8];
			DataRow row;

			GridTableView masterTableView = this.MasterTableView;

			if (!isValidationGrid)
			{
				exportDataTable.Columns.Clear();
				exportDataTable.Columns.Add(" ", typeof(String));
				exportDataTable.Columns.Add("  ", typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns[4].HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns[5].HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns[6].HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns[7].HeaderText) + " ", typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns[8].HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns[9].HeaderText) + " ", typeof(String));
				
				for (int i = 0; i < masterTableView.Items.Count; i++)
				{
					GridDataItem masterItem = masterTableView.Items[i];
					arr[0] = GetTableCellValue(masterItem, "PhaseName");
					arr[1] = String.Empty;
					arr[2] = GetTableCellValue(masterItem, masterTableView.Columns[4].UniqueName);
					arr[3] = GetTableCellValue(masterItem, masterTableView.Columns[5].UniqueName);
					arr[4] = GetTableCellValue(masterItem, masterTableView.Columns[6].UniqueName);
					arr[5] = GetTableCellValue(masterItem, masterTableView.Columns[7].UniqueName);
					arr[6] = GetTableCellValue(masterItem, masterTableView.Columns[8].UniqueName);
					arr[7] = GetTableCellValue(masterItem, masterTableView.Columns[9].UniqueName);

					row = exportDataTable.NewRow();
					row.ItemArray = arr;
					exportDataTable.Rows.Add(row);


					GridTableView detailTableView = masterTableView.Items[i].ChildItem.NestedTableViews[0];
					for (int j = 0; j < detailTableView.Items.Count; j++)
					{
						GridDataItem detailItem = detailTableView.Items[j];
						arr[0] = String.Concat("   ", GetTableCellValue(detailItem, detailTableView.Columns[4].UniqueName));
						arr[1] = GetTableCellValue(detailItem, detailTableView.Columns[8].UniqueName);
						arr[2] = GetTableCellValue(detailItem, detailTableView.Columns[9].UniqueName);
						arr[3] = GetTableCellValue(detailItem, detailTableView.Columns[10].UniqueName);
						arr[4] = GetTableCellValue(detailItem, detailTableView.Columns[11].UniqueName);
						arr[5] = GetTableCellValue(detailItem, detailTableView.Columns[12].UniqueName);
						arr[6] = GetTableCellValue(detailItem, detailTableView.Columns[13].UniqueName);
						arr[7] = GetTableCellValue(detailItem, detailTableView.Columns[14].UniqueName);

						row = exportDataTable.NewRow();
						row.ItemArray = arr;
						exportDataTable.Rows.Add(row);


						GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
						for (int k = 0; k < lastTableView.Items.Count; k++)
						{
							GridDataItem detailDetailItem = lastTableView.Items[k];
							arr[0] = String.Concat("      (", GetTableCellValue(detailDetailItem, "CurrencyCode"), ") ", GetTableCellValue(detailDetailItem, "CostCenterName"));
							arr[1] = String.Empty;
							arr[2] = GetTableCellValue(detailDetailItem, lastTableView.Columns[8].UniqueName);
							arr[3] = GetTableCellValue(detailDetailItem, lastTableView.Columns[9].UniqueName);
							arr[4] = GetTableCellValue(detailDetailItem, lastTableView.Columns[10].UniqueName);
							arr[5] = GetTableCellValue(detailDetailItem, lastTableView.Columns[11].UniqueName);
							arr[6] = GetTableCellValue(detailDetailItem, lastTableView.Columns[12].UniqueName);
							arr[7] = GetTableCellValue(detailDetailItem, lastTableView.Columns[13].UniqueName);

							row = exportDataTable.NewRow();
							row.ItemArray = arr;
							exportDataTable.Rows.Add(row);
						}
					}
				}
			}
			else
			{
				exportDataTable.Columns.Clear();
				exportDataTable.Columns.Add(" ", typeof(String));
				exportDataTable.Columns.Add("  ", typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("TotHours").HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("Averate").HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("ValHours").HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("OtherCost").HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("Sales").HeaderText), typeof(String));
				exportDataTable.Columns.Add(Strip(masterTableView.Columns.FindByUniqueName("NetCost").HeaderText) + " ", typeof(String));

				for (int i = 0; i < masterTableView.Items.Count; i++)
				{
					GridDataItem masterItem = masterTableView.Items[i];
					arr[0] = GetTableCellValue(masterItem, "PhaseName");
					arr[1] = String.Empty;
					arr[2] = GetTableCellValue(masterItem, "TotHours");
					arr[3] = GetTableCellValue(masterItem, "Averate");
					arr[4] = GetTableCellValue(masterItem, "ValHours");
					arr[5] = GetTableCellValue(masterItem, "OtherCost");
					arr[6] = GetTableCellValue(masterItem, "Sales");
					arr[7] = GetTableCellValue(masterItem, "NetCost");

					row = exportDataTable.NewRow();
					row.ItemArray = arr;
					exportDataTable.Rows.Add(row);


					GridTableView detailTableView = masterTableView.Items[i].ChildItem.NestedTableViews[0];
					for (int j = 0; j < detailTableView.Items.Count; j++)
					{
						GridDataItem detailItem = detailTableView.Items[j];
						arr[0] = GetTableCellValue(detailItem, "WPName");
						arr[1] = GetTableCellValue(detailItem, "DateInterval");
						arr[2] = GetTableCellValue(detailItem, "TotHours");
						arr[3] = GetTableCellValue(detailItem, "Averate");
						arr[4] = GetTableCellValue(detailItem, "ValHours");
						arr[5] = GetTableCellValue(detailItem, "OtherCost");
						arr[6] = GetTableCellValue(detailItem, "Sales");
						arr[7] = GetTableCellValue(detailItem, "NetCost");

						row = exportDataTable.NewRow();
						row.ItemArray = arr;
						exportDataTable.Rows.Add(row);


						GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
						for (int k = 0; k < lastTableView.Items.Count; k++)
						{
							GridDataItem detailDetailItem = lastTableView.Items[k];
							arr[0] = String.Concat("      (", GetTableCellValue(detailDetailItem, "CurrencyCode"), ") ", GetTableCellValue(detailDetailItem, "CostCenterName"));
							arr[1] = String.Empty;
							arr[2] = GetTableCellValue(detailDetailItem, "TotHours");
							arr[3] = GetTableCellValue(detailDetailItem, "Averate");
							arr[4] = GetTableCellValue(detailDetailItem, "ValHours");
							arr[5] = GetTableCellValue(detailDetailItem, "OtherCost");
							arr[6] = GetTableCellValue(detailDetailItem, "Sales");
							arr[7] = GetTableCellValue(detailDetailItem, "NetCost");

							row = exportDataTable.NewRow();
							row.ItemArray = arr;
							exportDataTable.Rows.Add(row);
						}
					}
				}
			}
		}

        #endregion Private Methods
    }
}
