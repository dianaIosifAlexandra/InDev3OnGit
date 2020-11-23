using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;

using Telerik.WebControls;
using System.Collections;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls.Budget
{
    /// <summary>
    /// Budget grids context menu class
    /// </summary>
    [ToolboxBitmap(typeof(Telerik.WebControls.RadMenu))]
    [ToolboxData("<{0}:IndBudgetContextMenu runat=\"server\"></{0}:IndBudgetContexMenu>")]
    public class IndBudgetContextMenu : RadMenu
    {
        #region Constants
        private const string EXPAND_MASTER = "EXP_MASTER";
        private const string COLLAPSE_MASTER = "COL_MASTER";
        private const string EXPAND_DETAIL = "EXP_DETAIL";
        private const string COLLAPSE_DETAIL = "COL_DETAIL";
        #endregion Constants

        #region Members
        internal ControlHierarchyManager ControlHierarchyManager;
        // object set to a datagrid on wich context menu will operate
        private string _DataGridName = "";

        /// <summary>
        /// Get set property DataGrid of context menu
        /// </summary>
        public string DataGridName
        {
            get { return _DataGridName; }
            set
            {
                _DataGridName = value;
            }
        }

        public IndGrid DataGrid
        {
            get
            {
                IndGrid grd;
                try
                {
                    grd = GetDataGrid(this.Page.Controls);
                }
                catch (IndException ex)
                {
                    ControlHierarchyManager.ReportError(ex);
                    return null;
                }
                catch (Exception ex)
                {
                    ControlHierarchyManager.ReportError(new IndException(ex));
                    return null;
                }
                return grd;
            }
        }

        private string _MasterTableName;
        /// <summary>
        /// The name of the master table (which will appear in the menu)
        /// </summary>
        public string MasterTableName
        {
            get { return _MasterTableName; }
            set { _MasterTableName = value; }
        }

        private string _DetailTableName;
        /// <summary>
        /// The name of the detail table (which will appear in the menu)
        /// </summary>
        public string DetailTableName
        {
            get { return _DetailTableName; }
            set { _DetailTableName = value; }
        }
        #endregion Members

        #region Constructors
        /// <summary>
        /// IndBudgetContextMenu class constructor
        /// </summary>
        public IndBudgetContextMenu()
        {
            try
            {
                ControlHierarchyManager = new ControlHierarchyManager(this);
                //set context menu skin name
                this.Skin = "Default";
                //set context menu skin path
                this.SkinsPath = "~/Skins/Menu";
                //set menu to became context menu
                this.IsContext = true;
                //set context menu item click event
                this.ItemClick += new RadMenuEventHandler(gridContextMenu_ItemClick);
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
        #endregion Constructors

        #region Event Handlers
        protected override void OnLoad(EventArgs e)
        {
            try
            {
                base.OnLoad(e);
                //add context menu items
                AddItems();
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

        /// <summary>
        /// event to make context menu actions
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gridContextMenu_ItemClick(object sender, RadMenuEventArgs e)
        {
            try
            {
                IndGrid dataGrid = this.DataGrid;

                //find what context menu item was click
                switch (e.Item.Value)
                {
                    case EXPAND_MASTER:
                        ExpandMaster(dataGrid);
                        break;

                    case COLLAPSE_MASTER:
                        CollapseMaster(dataGrid);
                        break;

                    case EXPAND_DETAIL:
                        ExpandDetail(dataGrid);
                        break;

                    case COLLAPSE_DETAIL:
                        CollapseDetail(dataGrid);
                        break;
                }
                dataGrid.Rebind();
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

        /// <summary>
        /// Collapses the detail level of the given grid
        /// </summary>
        /// <param name="dataGrid"></param>
        private void CollapseDetail(IndGrid dataGrid)
        {
            dataGrid.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = false;
            foreach (GridDataItem item in dataGrid.Items)
            {
                if (item.OwnerTableView.Name != dataGrid.MasterTableView.DetailTables[0].DetailTables[0].Name && GetEditCommandColumn(item) != null)
                {
                    item.Edit = false;
                }
            }
            dataGrid.Rebind();

            //collapse all workpackages action
            foreach (GridDataItem masterItem in dataGrid.MasterTableView.Items)
                foreach (GridDataItem item in masterItem.ChildItem.NestedTableViews[0].Items)
                    dataGrid.ExpandedStates[item.ItemIndexHierarchical] = false;
        }

        /// <summary>
        /// Expands the detail level of the given grid
        /// </summary>
        /// <param name="dataGrid"></param>
        private void ExpandDetail(IndGrid dataGrid)
        {
            dataGrid.MasterTableView.HierarchyDefaultExpanded = true;
            dataGrid.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = true;
            dataGrid.Rebind();

            //expand all workpackages action
            foreach (GridDataItem masterItem in dataGrid.MasterTableView.Items)
            {
                dataGrid.ExpandedStates[masterItem.ItemIndexHierarchical] = true;
                foreach (GridDataItem item in masterItem.ChildItem.NestedTableViews[0].Items)
                {
                    dataGrid.ExpandedStates[item.ItemIndexHierarchical] = true;
                }
            }
        }

        /// <summary>
        /// Collapses the master level of the given grid
        /// </summary>
        /// <param name="dataGrid"></param>
        private void CollapseMaster(IndGrid dataGrid)
        {
            dataGrid.MasterTableView.HierarchyDefaultExpanded = false;
            dataGrid.MasterTableView.DetailTables[0].HierarchyDefaultExpanded = false;
            foreach (GridDataItem item in dataGrid.Items)
            {
                if (item.OwnerTableView.Name == dataGrid.MasterTableView.Name && GetEditCommandColumn(item) != null)
                {
                    item.Edit = false;
                }
            }
            dataGrid.Rebind();

            //collapse all phases action
            foreach (GridDataItem masterItem in dataGrid.MasterTableView.Items)
            {
                dataGrid.ExpandedStates[masterItem.ItemIndexHierarchical] = false;
                foreach (GridDataItem item in masterItem.ChildItem.NestedTableViews[0].Items)
                {
                    dataGrid.ExpandedStates[item.ItemIndexHierarchical] = false;
                }
            }
        }

        /// <summary>
        /// Expands the master level of the given grid
        /// </summary>
        /// <param name="dataGrid"></param>
        private void ExpandMaster(IndGrid dataGrid)
        {
            dataGrid.MasterTableView.HierarchyDefaultExpanded = true;
            dataGrid.Rebind();

            //expand all phases action
            foreach (GridDataItem item in dataGrid.MasterTableView.Items)
                dataGrid.ExpandedStates[item.ItemIndexHierarchical] = true;
        }

        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);
                if (!String.IsNullOrEmpty(_DataGridName))
                    this.ContextMenuElementID = DataGrid.ClientID;
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
        #endregion Event Handlers

        #region Private Members
        /// <summary>
        /// add context menu items
        /// </summary>
        private void AddItems()
        {
            //remove items
            if (this.Items.Count == 0)
            {
                //add expand all phases item
                RadMenuItem mnuItem = new RadMenuItem("Expand all " + _MasterTableName);
                mnuItem.Value = EXPAND_MASTER;
                this.Items.Add(mnuItem);
                
                //add collapse all phases item
                mnuItem = new RadMenuItem("Collapse all " + _MasterTableName);
                mnuItem.Value = COLLAPSE_MASTER;
                this.Items.Add(mnuItem);
                //add a separator
                mnuItem = new RadMenuItem("");
                mnuItem.IsSeparator = true;
                this.Items.Add(mnuItem);
                
                //add expand all workpackages item
                mnuItem = new RadMenuItem("Expand all " + _DetailTableName);
                mnuItem.Value = EXPAND_DETAIL;
                this.Items.Add(mnuItem);

                //add collapse all workpackages item
                mnuItem = new RadMenuItem("Collapse all " + _DetailTableName);
                mnuItem.Value = COLLAPSE_DETAIL;
                this.Items.Add(mnuItem);
            }
        }
        /// <summary>
        /// Take a controls collection and parse controls tree to find DataGrid
        /// </summary>
        /// <param name="controls"></param>
        /// <returns></returns>
        private IndGrid GetDataGrid(ControlCollection controls)
        {
            //control to store desired RadDataGrid
            Control dataGrid = null;
            foreach (Control c in controls)
            {
                //if current control is a container parse child controls
                if (c.Controls.Count > 0)
                {
                    //call this function recursive for each childcontrol 
                    dataGrid = GetDataGrid(c.Controls);
                    //if desired datagrid is found then exit
                    if (dataGrid != null) break;
                }
                //find desired DataGrid in current control collection
                dataGrid = c.FindControl(this._DataGridName);
                //if desired datagrid is found then exit
                if (dataGrid != null) break;
            }

            if ((dataGrid != null) && !(dataGrid is IndGrid))
            {
                throw new IndException("IndBudgetContextMenu can only be applied to an object of type IndGrid. Type of current object is " + dataGrid.GetType());
            }
            //return desired datagrid
            return (IndGrid)dataGrid;
        }

        private GridEditCommandColumn GetEditCommandColumn(GridDataItem dataItem)
        {
            foreach (GridColumn column in dataItem.OwnerTableView.Columns)
                if (column is GridEditCommandColumn)
                    return (GridEditCommandColumn)column;
            return null;
        }
        #endregion Private Members
    }
}
