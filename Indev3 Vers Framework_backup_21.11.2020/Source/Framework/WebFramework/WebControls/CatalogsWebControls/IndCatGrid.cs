using System;
using System.Collections.Generic;
using System.Text;
using Telerik.WebControls;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using Inergy.Indev3.ApplicationFramework;
using System.Reflection;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.Entities;
using Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls;
using Inergy.Indev3.BusinessLogic.Catalogues;


namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// DataGrid used by the Indev3 application
    /// </summary>
    [DefaultProperty("Items")]
    [ToolboxBitmap(typeof(Telerik.WebControls.RadGrid))]
    [ToolboxData("<{0}:IndCatGrid runat=\"server\"></{0}:IndCatGrid>")]
    public class IndCatGrid : RadGrid
    {
        #region Constants
        /// <summary>
        /// The minimum width of the grid, so that the pager is displayed correctly
        /// </summary>
        private const int GRID_MIN_WIDTH = 448;
        private const int GRID_MAX_WIDTH = 860;
        #endregion Constants

        #region Members
        /// <summary>
        /// Pager of the grid
        /// </summary>
        IndCatGridPager indPager;
        /// <summary>
        /// Add button of the grid
        /// </summary>
        internal IndImageButton btnAdd;
        /// <summary>
        /// Delete button of the grid
        /// </summary>
        internal IndImageButton btnDelete;
        /// <summary>
        /// A table object for displaying the footer elements of the grid in a user friendly way
        /// </summary>
        private Table tbl;
        /// <summary>
        /// The paging manager object used by the grid
        /// </summary>
        private GridPagingManager PagingManager;

        internal ControlHierarchyManager ControlHierarchyManager;
        /// <summary>
        /// 
        /// </summary>
        //private Dictionary<string, string> columnHeaderHTML = new Dictionary<string, string>();
        private Dictionary<string, string> columnHeaderHTML
        {
            get 
            {
                Dictionary<string, string> stateObj = ViewState["ColumnHeaderHTML"] as Dictionary<string, string>;
                if (stateObj == null)
                    stateObj = new Dictionary<string, string>();
                return stateObj;
            }
            set
            {
                ViewState["ColumnHeaderHTML"] = value;
            }
        }      
        /// <summary>
        /// The type of entity that is displayed
        /// </summary>
        private Type _EntityType;
        public Type EntityType
        {
            get { return _EntityType; }
            set { _EntityType = value; }
        }
        /// <summary>
        /// The current page index of the grid
        /// </summary>
        public int CurrentPage
        {
            get 
            {
                try
                {
                    Dictionary<string, int> currentPageDictionary;
                    //Load into session the dictionary with page numbers
                    if ((currentPageDictionary = (Dictionary<string, int>)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.PAGE_NUMBER_MAPPING)) == null)
                    {
                        SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.PAGE_NUMBER_MAPPING, EntityUtils.GetPageNumberMapping());
                        currentPageDictionary = (Dictionary<string, int>)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.PAGE_NUMBER_MAPPING);
                    }
                    return currentPageDictionary[SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL).ToString()];
                }
                catch (IndException ex)
                {
                    ControlHierarchyManager.ReportError(ex);
                    return ApplicationConstants.INT_NULL_VALUE;
                }
                catch (Exception ex)
                {
                    ControlHierarchyManager.ReportError(new IndException(ex));
                    return ApplicationConstants.INT_NULL_VALUE;
                }
            }
            set 
            {
                try
                {
                    if (Page != null)
                    {
                        //Save the current page index in the session and set the CurrentPageIndex property of the RadGrid (base) object
                        Dictionary<string, int> currentPageDictionary = (Dictionary<string, int>)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.PAGE_NUMBER_MAPPING);
                        string viewControl = SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL).ToString();
                        currentPageDictionary[viewControl] = value;
                    }
                    base.CurrentPageIndex = value;
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
        }

        private GridDataSourcePersistenceMode _DataSourcePersistenceMode = GridDataSourcePersistenceMode.ViewState;
        /// <summary>
        /// The data source persistence mode of the grid
        /// </summary>
        [Category("Extension")]
        public GridDataSourcePersistenceMode DataSourcePersistenceMode
        {
            get
            {
                return _DataSourcePersistenceMode;
            }
            set
            {
                this.MasterTableView.DataSourcePersistenceMode = value;
                _DataSourcePersistenceMode = value;
            }
        }

        private int _GridPageSize;
        /// <summary>
        /// The page size (in rows) of the grid
        /// </summary>
        [Browsable(false)]
        public int GridPageSize
        {
            get
            {
                return _GridPageSize;
            }
            set
            {
                this.PageSize = value;
                _GridPageSize = value;
            }
        }

        /// <summary>
        /// The IndFilterItem object associated with this grid
        /// </summary>
        public IndFilterItem IndFilterItem
        {
            get 
            {
                return (IndFilterItem)SessionManager.GetSessionValueNoRedirect(Page, SessionStrings.FILTER_ITEM);
            }
            set 
            {
                SessionManager.SetSessionValue(Page, SessionStrings.FILTER_ITEM, value); 
            }
        }


        private Permissions _ViewPermission = Permissions.All;
        [Browsable(false)]
        public Permissions ViewPermission
        {
            get { return _ViewPermission; }
            set { _ViewPermission = value; }
        }

        private bool _UserCanEdit = true;
        /// <summary>
        /// Specifies whether the grid allows the user to edit rows or not
        /// </summary>
        [Category("Extension")]
        public bool UserCanEdit
        {
            get { return _UserCanEdit; }
            set { _UserCanEdit = value; }
        }

        private bool _UserCanDelete = true;
        /// <summary>
        /// Specifies whether the grid allows the user to delete rows or not
        /// </summary>
        [Category("Extension")]
        public bool UserCanDelete
        {
            get { return _UserCanDelete; }
            set { _UserCanDelete = value; }
        }

        private bool _UserCanAdd = true;
        /// <summary>
        /// Specifies whether the grid allows the user to add rows or not
        /// </summary>
        [Category("Extension")]
        public bool UserCanAdd
        {
            get { return _UserCanAdd; }
            set { _UserCanAdd = value; }
        }

        private bool _UseAutomaticEntityBinding = false;
        /// <summary>
        /// Specifies whether automatic entity binding (the catalogs mechanism) will be used
        /// </summary>
        [Category("Extension")]
        public bool UseAutomaticEntityBinding
        {
            get { return _UseAutomaticEntityBinding; }
            set { _UseAutomaticEntityBinding = value; }
        }
        public override object DataSource
        {
            get
            {
                return base.DataSource;
            }
            set
            {
                //ViewState["DataSource"] = value;
                base.DataSource = value;
            }
        }

        public string IndFilterExpression
        {
            get
            {
                return (SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.FILTER_EXPRESSION) == null) ?
                    String.Empty : SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.FILTER_EXPRESSION).ToString();
            }
            set
            {
                SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.FILTER_EXPRESSION, value);
                this.MasterTableView.FilterExpression = value;
            }
        }

        private object _VirtualDataSource;
        /// <summary>
        /// A virtual dataset which must be set when _UseAutomaticEntityBinding is set to false. Used such that this grid will always use 
        /// complex data binding
        /// </summary>
        [Browsable(false)]
        public object VirtualDataSource
        {
            get { return _VirtualDataSource; }
            set { _VirtualDataSource = value; }
        }
        #endregion Members

        #region Constructors
        public IndCatGrid()
        {
            if (!DesignMode)
            {
                this.EnableViewState = false;
                this.AllowPaging = true;
                this.PagerStyle.Visible = false;
                this.AllowSorting = true;
                this.MasterTableView.AllowNaturalSort = false;

                this.EnableAJAX = false;
                this.AllowFilteringByColumn = true;

                this.AutoGenerateColumns = false;

                this.ItemCreated += new GridItemEventHandler(GenericGrid_ItemCreated);
                this.NeedDataSource += new GridNeedDataSourceEventHandler(GenericGrid_NeedDataSource);
                this.ColumnCreating += new GridColumnCreatingEventHandler(IndCatGrid_ColumnCreating);

                this.DataSourcePersistenceMode = GridDataSourcePersistenceMode.NoPersistence;

                //Add the add and delete buttons
                if (_UserCanAdd)
                {
                    btnAdd = new IndImageButton();
                    btnAdd.ID = "AddButton";
                    btnAdd.ImageUrl = "~/Images/buttons_new.png";
                    btnAdd.ImageUrlOver = "~/Images/buttons_new_over.png";
                    btnAdd.ToolTip = "Add";
                }

                btnDelete = new IndImageButton();
                btnDelete.ID = "DeleteButton";
                btnDelete.ImageUrl = "~/Images/buttons_delete.png";
                btnDelete.ImageUrlOver = "~/Images/buttons_delete_over.png";
                btnDelete.OnClientClick = "if (CheckBoxesSelected()) {if(!confirm('Are you sure you want to delete the selected entries?'))return false;}else {alert('Select at least one entry');return false;}";
                btnDelete.Click += new ImageClickEventHandler(DeleteButton_Click);
                btnDelete.ToolTip = "Delete";
                btnDelete.Enabled = _UserCanDelete;
            }

            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructors
       
        #region Public Methods
        public void SetPage()
        {
            try
            {
                indPager.SetPage();
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
        public void AddColumnHeaderControl(string columnName, string htmlText)
        {
            try
            {
                Dictionary<string, string> stateObj = columnHeaderHTML;
                if (!(stateObj.ContainsKey(columnName)))
                    stateObj.Add(columnName, htmlText);
                ViewState["ColumnHeaderHTML"] = stateObj;
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
        /// Exports the data in the grid to a csv file
        /// </summary>
        public void ExportData()
        {
            try
            {
                //StringBuilder that will hold the contents of the csv file to be exported
                StringBuilder fileContent = new StringBuilder();
                //List holding visible column names
                List<string> visibleColumnNames = new List<string>();
                //Populate visibleColumnNames with the visible columns in the grid (exclude the ones that are hidden)
                foreach (GridColumn column in this.MasterTableView.Columns)
                {
                    if (column is IndGridBoundColumn && column.Display)
                    {
                        visibleColumnNames.Add(column.UniqueName);
                        //Add the header text to the StringBuilder object that holds the contents of the csv file
                        fileContent.Append("\"" + column.UniqueName + "\";");
                    }
                }
                //Remove the last semicolon in the header
                fileContent.Remove(fileContent.Length - 1, 1);
                //Get the datarows from the grid which obey the filter condition
                DataRow[] rows = (((DataSet)this.DataSource).Tables[0]).Select(this.IndFilterExpression);
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
        /// <summary>
        /// 
        /// </summary>
        /// <param name="e"></param>
        protected override void OnDataBound(EventArgs e)
        {
            try
            {
                base.OnDataBound(e);
                if (!DesignMode)
                {
                    if (PagingManager != null)
                    {
                        CreateFooter(PagingManager);
                    }
                }
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

        protected override void OnInit(EventArgs e)
        {
            try
            {
                if (!DesignMode)
                {
                    base.OnInit(e);
                    CurrentUser currentUser = SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER) as CurrentUser;
                    if ((currentUser == null) || (currentUser.Settings == null))
                        throw new IndException(ApplicationMessages.EXCEPTION_USER_SETTINGS_NOT_EXISTS);
                    this.GridPageSize = currentUser.Settings.NumberOfRecordsPerPage;
                }
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


        protected override void LoadViewState(object savedStateObject)
        {
            try
            {
                base.LoadViewState(savedStateObject);
                //For a completly unknown reason the ViewState["ColumnHeaderHTML"] value is not saved.
                columnHeaderHTML = ViewState["Temp"] as Dictionary<string, string>;
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

        protected override object SaveViewState()
        {
            try
            {
                //For a completly unknown reason the ViewState["ColumnHeaderHTML"] value is not saved.
                ViewState["Temp"] = columnHeaderHTML;
                return base.SaveViewState();
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
        }

        protected override void OnLoad(EventArgs e)
        {
            try
            {
                base.OnLoad(e);

                if (!DesignMode)
                {
                    //Set the skin, pagesize andother properties of the grid
                    this.SkinsPath = "~/Skins/Grid/";
                    this.Skin = ((ApplicationSettings)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.APPLICATION_SETTINGS)).Skin;
                    if ((Page.IsPostBack) && (this.MasterTableView.DataSourcePersistenceMode != GridDataSourcePersistenceMode.NoPersistence))
                    {
                        LoadFromViewState();
                        CreateFooter(PagingManager);
                    }
                }
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

        protected override void OnItemEvent(GridItemEventArgs e)
        {
            try
            {
                base.OnItemEvent(e);
                if (e.EventInfo is GridInitializePagerItem)
                {
                    GridInitializePagerItem info = (GridInitializePagerItem)e.EventInfo;
                    e.Canceled = true;
                    PagingManager = info.PagingManager;
                }
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
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                //This can occur in filtering, for example, when the RadGrid sets its CurrentPageIndex property internally, and the
                //IndCatGrid property CurrentPage has the wrong value
                if (this.CurrentPageIndex != this.CurrentPage)
                {
                    this.CurrentPage = this.CurrentPageIndex;
                    Rebind();
                }

                int gridWidth = CalculateGridWidth();
                if (gridWidth < GRID_MIN_WIDTH)
                {
                    IncreaseColumnWidths(gridWidth);
                }
                if (gridWidth > GRID_MAX_WIDTH)
                {
                    DecreaseColumnWidths(gridWidth);
                }
                if (_UserCanAdd)
                {
                    string editControl = SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL).ToString();
                    btnAdd.OnClientClick = "return OpenAddWindow('" + editControl + "', '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "');";
                }

                //Hide the filter cells that belong to the hidden columns
                HideFilterCells();

                base.OnPreRender(e);
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
        /// Event handler for the Click event of Delete Button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void DeleteButton_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                DeleteSelectedEntities();
                string editControl = SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL).ToString();
                if (!Page.ClientScript.IsClientScriptBlockRegistered(this.Page.GetType(), "ReloadPage"))
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ReloadPage", "window.location.href = window.location.href;", true);
                }
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

        private void IndCatGrid_ColumnCreating(object sender, GridColumnCreatingEventArgs e)
        {
            try
            {
                if (e.Column == null && e.ColumnType == "IndGridBoundColumn")
                {
                    e.Column = new IndGridBoundColumn();
                }
                if (e.Column == null && e.ColumnType == "IndBoolGridBoundColumn")
                {
                    e.Column = new IndBoolGridBoundColumn();
                }
                if (e.Column == null && e.ColumnType == "IndGridTemplateColumn")
                {
                    e.Column = new IndGridTemplateColumn();
                }
                if (e.Column == null && e.ColumnType == "IndGridDeleteColumn")
                {
                    e.Column = new IndGridDeleteColumn();
                    ((GridTemplateColumn)e.Column).AllowFiltering = true;
                    e.Column.Resizable = false;
                    e.Column.HeaderStyle.Width = Unit.Pixel(25);
                }
                if (e.Column == null && e.ColumnType == "IndGridEditColumn")
                {
                    e.Column = new IndGridEditColumn();
                    ((IndGridEditColumn)e.Column).AllowFiltering = true;
                    e.Column.Resizable = false;
                    e.Column.HeaderStyle.Width = Unit.Pixel(25);
                }
                e.Column.Resizable = false;
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
        /// NeedDataSource event handler of the generic grid
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        private void GenericGrid_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            try
            {
                this.MasterTableView.FilterExpression = this.IndFilterExpression;
                if (!_UseAutomaticEntityBinding && _VirtualDataSource == null)
                {
                    return;
                }
                //Clear the columns in the master table
                this.MasterTableView.Columns.Clear();

                //Add the edit column
                AddEditColumn();

                //Add the delete column (checkbox column)
                AddDeleteColumn();

                DataSet sourceDS = new DataSet();

                if (_UseAutomaticEntityBinding)
                {
                    //Instantiate the referenced object
                    IGenericEntity viewEntity = EntityFactory.GetEntityInstance(_EntityType, SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));

                    ((GenericUserControl)this.Parent.Parent).SetViewEntityProperties(viewEntity);
                    //Get all entities in this catalogue
                    sourceDS = viewEntity.GetAll(true);

                    //Creates a new GenericEntity object with the correct instance that will be used to add the logical column
                    object connectionManager = SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER);

                    //Add the logical column
                    EntityFactory.GetEntityInstance(this.EntityType, connectionManager).CreateLogicalKeyColumn(sourceDS.Tables[0]);
                }
                else
                {
                    if (!(_VirtualDataSource is DataSet) && !(_VirtualDataSource is DataTable))
                    {
                        throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_VIRTUAL_DATASOURCE_OF_TYPE_NOT_SUPPORTED, _VirtualDataSource.GetType().ToString()));
                    }
                    if (_VirtualDataSource is DataSet)
                    {
                        sourceDS = (DataSet)_VirtualDataSource;
                    }
                    if (_VirtualDataSource is DataTable)
                    {
                        sourceDS.Tables.Add((DataTable)_VirtualDataSource);
                    }
                }

                //Add the data columns (with data from the db) to the grid
                AddDataColumns(sourceDS);
                
                if (_UseAutomaticEntityBinding)
                {
                    CurrentUser currentUser = SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER) as CurrentUser;
                    if (currentUser.HasEditPermission(ApplicationConstants.MODULE_HOURLY_RATE) && _EntityType == typeof(HourlyRate))
                    {
                        AddColumnHeaderControl("Value", "&nbsp<input type=\"image\" id=\"btnMassAttr\" class=\"IndImageButton\" title=\"Mass Attribution\" src=\"Images/mass_attribution_up.gif\" onclick=\"if (ShowPopUpWithoutPostBack('UserControls/Catalogs/HourlyRate/HRMassAttribution.aspx',520,560, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')){ __doPostBack('" + this.Page.ClientID + "',null);}return false;\"");
                    }

                    //Hide the columns that must not be shown (like Id)
                    HideColumns();
                }


                //Bind the grid to the dataset
                this.DataSource = sourceDS;

                SetDateColumnFormatString();
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

        #region Private Methods
        private void DecreaseColumnWidths(int gridWidth)
        {
            int colMinWidth = 100;
            int widthDiff = gridWidth - GRID_MAX_WIDTH;
            //Calculate the number of visible bound columns
            int noBoundWideColumns = 0;
            foreach (GridColumn column in this.Columns)
            {
                if (column is IndGridBoundColumn && column.Display && column.HeaderStyle.Width.Value > colMinWidth)
                {
                    noBoundWideColumns++;
                }
            }
            //The width in pixels by which the columns must be adjusted
            int colWidthDiff = widthDiff / noBoundWideColumns + 1;
            foreach (GridColumn column in this.Columns)
            {
                if (column is IndGridBoundColumn && column.Display && column.HeaderStyle.Width.Value > colMinWidth)
                {
                    column.HeaderStyle.Width = Unit.Pixel((int)column.HeaderStyle.Width.Value - colWidthDiff);
                    GridFilteringItem filterItem = (GridFilteringItem)this.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                    TableCell filterCell = filterItem[column.UniqueName];
                    if (filterCell.Controls.Count == 2)
                    {
                        TextBox filterTextBox = filterCell.Controls[0] as TextBox;
                        if (filterTextBox != null)
                        {
                            filterTextBox.Width = Unit.Pixel((int)filterTextBox.Width.Value - colWidthDiff);
                        }
                    }
                    if (filterCell.Controls.Count == 3)
                    {
                        if (filterCell.Controls[1] is DropDownList)
                        {
                            DropDownList filterDdl = filterCell.Controls[1] as DropDownList;
                            filterDdl.Width = Unit.Pixel((int)filterDdl.Width.Value - colWidthDiff);
                        }
                        if (filterCell.Controls[1] is IndDatePicker)
                        {
                            IndDatePicker filterDatePicker = filterCell.Controls[1] as IndDatePicker;
                            filterDatePicker.Width = Unit.Pixel((int)filterDatePicker.Width.Value - colWidthDiff);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Resizes the columns in the grid by an equal width
        /// </summary>
        /// <param name="gridWidth">The sum of the widths of the columns of the grid</param>
        private void IncreaseColumnWidths(int gridWidth)
        {
            int widthDiff = GRID_MIN_WIDTH - gridWidth;
            //Calculate the number of visible bound columns
            int noBoundColumns = 0;
            foreach (GridColumn column in this.Columns)
            {
                if (column is IndGridBoundColumn && column.Display)
                {
                    noBoundColumns++;
                }
            }
            if (noBoundColumns > 0)
            {
                //The width in pixels by which the columns must be adjusted
                int colWidthDiff = widthDiff / noBoundColumns + 1;
                foreach (GridColumn column in this.Columns)
                {
                    if (column is IndGridBoundColumn && column.Display)
                    {
                        column.HeaderStyle.Width = Unit.Pixel((int)column.HeaderStyle.Width.Value + colWidthDiff);
                    }
                }
            }
        }

        /// <summary>
        /// Calculates the sum of the widths of the columns of the grid
        /// </summary>
        /// <returns></returns>
        private int CalculateGridWidth()
        {
            int totalWidth = 0;
            foreach (GridColumn column in this.Columns)
            {
                if (column.Display)
                {
                    totalWidth += (int)column.HeaderStyle.Width.Value;
                }
            }
            return totalWidth;
        }

        /// <summary>
        /// Deletes the selected entities from the catalogue
        /// </summary>
        private void DeleteSelectedEntities()
        {
            List<IGenericEntity> entities = new List<IGenericEntity>();
            //For each selected entity in the grid
            foreach (GridItem gridItem in this.MasterTableView.Items)
            {
                if (gridItem is GridDataItem && ((CheckBox)((GridDataItem)gridItem)["DeleteColumn"].Controls[0]).Checked)
                {
                    GridDataItem current = (GridDataItem)gridItem;
                    IGenericEntity deleteEntity = BuildEntityForDeletion(current);

                    //HACK - no other suitable place found for passing also the current associate to the business object below
                    if (deleteEntity.GetType() == typeof(Associate))
                       ((Associate)deleteEntity).IdCurrentAssociate = ((CurrentUser)SessionManager.GetCurrentUser(this.Page)).IdAssociate;

                    deleteEntity.SetDeleted();
                    entities.Add(deleteEntity);
                }
            }
            EntityFactory.GetEntityInstance(_EntityType, SessionManager.GetConnectionManager(this.Page)).Save(entities);
        }


        /// <summary>
        /// Builds the object to be deleted, setting the properties that are in the logical key of the table in the database
        /// </summary>
        /// <param name="current"></param>
        /// <returns></returns>
        private IGenericEntity BuildEntityForDeletion(GridDataItem current)
        {
            IGenericEntity deleteEntity = EntityFactory.GetEntityInstance(_EntityType, SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));

            object[] entityProperties = _EntityType.GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.FlattenHierarchy);
            foreach (PropertyInfo entityProperty in entityProperties)
            {
                object[] logicalKeyAttributes = entityProperty.GetCustomAttributes(typeof(IsInLogicalKeyAttribute), true);
                if (logicalKeyAttributes.Length == 1 && current.OwnerTableView.Columns.FindByUniqueNameSafe(entityProperty.Name) != null)
                {
                    object value = current[entityProperty.Name].Text;
                    entityProperty.SetValue(deleteEntity, Convert.ChangeType(value, entityProperty.PropertyType), null);
                }
            }
            return deleteEntity;
        }

        /// <summary>
        /// 
        /// </summary>
        private void CreateFooter(GridPagingManager pagingManager)
        {
            indPager = new IndCatGridPager(pagingManager, this);
            indPager.ID = "IndPager";
            tbl = new Table();
            tbl.Width = Unit.Percentage(100);
            tbl.CellPadding = 0;
            tbl.CellSpacing = 0;
            TableRow row = new TableRow();
            row.Width = Unit.Percentage(100);
            row.Style.Add(HtmlTextWriterStyle.PaddingBottom, "0");
            row.Style.Add(HtmlTextWriterStyle.PaddingLeft, "0");
            row.Style.Add(HtmlTextWriterStyle.PaddingTop, "0");
            row.Style.Add(HtmlTextWriterStyle.PaddingRight, "0");
            TableCell cellAdd = new TableCell();
            cellAdd.Style.Add(HtmlTextWriterStyle.PaddingBottom, "0");
            cellAdd.Style.Add(HtmlTextWriterStyle.PaddingLeft, "0");
            cellAdd.Style.Add(HtmlTextWriterStyle.PaddingTop, "0");
            cellAdd.Style.Add(HtmlTextWriterStyle.PaddingRight, "0");
            cellAdd.Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            if (_UserCanAdd)
            {
                cellAdd.Controls.Add(btnAdd);
            }
            cellAdd.Width = Unit.Pixel(30);
            TableCell cellDelete = new TableCell();
            cellDelete.Style.Add(HtmlTextWriterStyle.PaddingBottom, "0");
            cellDelete.Style.Add(HtmlTextWriterStyle.PaddingLeft, "0");
            cellDelete.Style.Add(HtmlTextWriterStyle.PaddingTop, "0");
            cellDelete.Style.Add(HtmlTextWriterStyle.PaddingRight, "0");
            cellDelete.Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            btnDelete.Enabled = UserCanDelete;
            if (!_UserCanDelete)
            {
                btnDelete.ImageUrl = "~/Images/buttons_delete_disabled.png";
            }
            cellDelete.Controls.Add(btnDelete);            
            cellDelete.Width = Unit.Pixel(25);
            TableCell cellPager = new TableCell();
            cellPager.HorizontalAlign = HorizontalAlign.Right;
            cellPager.Controls.Add(indPager);
            row.Cells.Add(cellAdd);
            row.Cells.Add(cellDelete);
            row.Cells.Add(cellPager);
            tbl.Rows.Add(row);
            this.MasterTableView.Controls.Add(tbl);
        }



        /// <summary>
        /// 
        /// </summary>
        private void LoadFromViewState()
        {
            this.DataSource = ViewState["DataSource"];
        }

        /// <summary>
        /// Sets the DataFormatString property for the DateTime columns in the grid (time part will not be shown)
        /// </summary>
        private void SetDateColumnFormatString()
        {
            foreach (GridColumn column in this.MasterTableView.Columns)
            {
                if (column is IndGridBoundColumn && column.DataType == typeof(DateTime))
                {
                    ((IndGridBoundColumn)column).DataFormatString = ApplicationConstants.DATE_TIME_FORMAT_STRING;
                }
            }
        }

        /// <summary>
        /// ItemCreated event handler of the generic grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void GenericGrid_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (!DesignMode)
            {
                if (e.Item is GridDataItem)
                {
                    if (_UserCanEdit)
                    {
                        //Add an edit button image to each element of the edit column
                        IndImageButton btnEdit = new IndImageButton();

                        btnEdit.ImageUrl = "~/Images/buttons_editrow.png";
                        btnEdit.ImageUrlOver = "~/Images/buttons_editrow_over.png";
                        btnEdit.ID = "btnEdit" + e.Item.ItemIndex;
                        btnEdit.Attributes.Add("ItemIndex", e.Item.ItemIndex.ToString());
                        btnEdit.ToolTip = "Edit";
                        string editControl = SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL).ToString();
                        btnEdit.OnClientClick = "return OpenEditWindow(this,'" + editControl + "',false, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "');";
                        ((GridDataItem)e.Item)["EditColumn"].Controls.Add(btnEdit);

                    }
                    //Add a checkbox to each element of the delete column
                    CheckBox chkDelete = new CheckBox();
                    chkDelete.ID = "chkBox";
                    chkDelete.Enabled = _UserCanDelete;
                    ((GridDataItem)e.Item)["DeleteColumn"].Controls.Add(chkDelete);
                }
            }
        }

        /// <summary>
        /// Hides the columns who have the IsVisible attribute (in the bound entity) set to false
        /// </summary>
        private void HideColumns()
        {
            PropertyInfo[] entityProperties = GetEntityProperties();
            object[] nameAttributes;
            object[] sortableAttributes;
            //For each property
            foreach (PropertyInfo entityProperty in entityProperties)
            {
                foreach (GridColumn gridColumn in this.MasterTableView.Columns)
                {
                    if (gridColumn.HeaderText == entityProperty.Name)
                    {
                        //Get the ControlName attribute
                        nameAttributes = entityProperty.GetCustomAttributes(typeof(GridColumnPropertyAttribute), true);

                        sortableAttributes = entityProperty.GetCustomAttributes(typeof(SortByAttribute), false);

                        //If this attribute exists for the current property, add it to the hashtable, together with the name of the control which is mapped
                        //to it
                        if (nameAttributes.Length == 1)
                        {

                            GridColumnPropertyAttribute colProperty = (GridColumnPropertyAttribute)nameAttributes[0];
                            if (colProperty.IsVisible == false)
                            {
                                gridColumn.Display = false;
                                gridColumn.HeaderStyle.CssClass = "GridElements_IndGenericGrid_Hide";
                                gridColumn.ItemStyle.CssClass = "GridElements_IndGenericGrid_Hide";
                            }
                            if (!String.IsNullOrEmpty(colProperty.ColumnHeaderName))
                                gridColumn.HeaderText = colProperty.ColumnHeaderName;
                            if (columnHeaderHTML.ContainsKey(gridColumn.UniqueName))
                            {
                                gridColumn.HeaderText += columnHeaderHTML[gridColumn.UniqueName];
                            }


                        }

                        if (gridColumn is IndGridBoundColumn)
                        {
                            if (sortableAttributes.Length > 0)
                            {
                                ((IndGridBoundColumn)gridColumn).AllowSorting = true;
                            }
                            else
                            {
                                ((IndGridBoundColumn)gridColumn).AllowSorting = false;
                            }
                        }
                    }
                    else
                         if (gridColumn is IndGridBoundColumn)
                             ((IndGridBoundColumn)gridColumn).AllowSorting = false;
                }
                
            }
            GridColumn isPMColumn;
            if ((isPMColumn = this.MasterTableView.Columns.FindByUniqueNameSafe("IsProgramManager")) != null)
            {
                isPMColumn.Display = false;
                isPMColumn.HeaderStyle.CssClass = "GridElements_IndGenericGrid_Hide";
                isPMColumn.ItemStyle.CssClass = "GridElements_IndGenericGrid_Hide";
            }
        }

        /// <summary>
        /// Hides the filter cells corresponding to the columns which have the IsVisible attribute (in the bound entity) set to false
        /// </summary>
        private void HideFilterCells()
        {
            foreach (GridColumn column in this.Columns)
            {
                if (column is IndGridBoundColumn && !column.Display)
                {
                    GridFilteringItem filterItem = (GridFilteringItem)this.MasterTableView.GetItems(GridItemType.FilteringItem)[0];
                    TableCell filterCell = filterItem[column.UniqueName];
                    filterCell.CssClass = "GridElements_IndGenericGrid_Hide";
                }
            }
        }

        /// <summary>
        /// Gets an array of PropertyInfo objects containing information about the properties of the entity
        /// </summary>
        /// <returns>An array of PropertyInfo objects containing information about the properties of the entity</returns>
        private PropertyInfo[] GetEntityProperties()
        {
            return _EntityType.GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.FlattenHierarchy);
        }

        private string[] GetDataKeyNames()
        {
            PropertyInfo[] entityProperties = GetEntityProperties();
            object[] logicalKeyAttributes;
            //For each property
            List<string> keys = new List<string>();
            foreach (PropertyInfo entityProperty in entityProperties)
            {
                //Get the ControlName attribute
                logicalKeyAttributes = entityProperty.GetCustomAttributes(typeof(IsInLogicalKeyAttribute), true);
                if (logicalKeyAttributes.Length == 1)
                    keys.Add(entityProperty.Name);
            }
            string[] dataKeys = new string[keys.Count];
            for (int i = 0; i < keys.Count; i++)
                dataKeys[i] = keys[i];
            return dataKeys;
        }

        private void AddEditColumn()
        {
            IndGridEditColumn editColumn = new IndGridEditColumn();
            editColumn.UniqueName = "EditColumn";
            //No filtering on the edit column
            editColumn.AllowFiltering = true;
            //Edit column is not resizable
            editColumn.Resizable = false;
            editColumn.HeaderStyle.Width = Unit.Pixel(25);
            this.MasterTableView.Columns.Add(editColumn);

        }

        private void AddDeleteColumn()
        {
            IndGridDeleteColumn deleteColumn = new IndGridDeleteColumn();
            deleteColumn.UniqueName = "DeleteColumn";
            //No filtering on the delete column
            deleteColumn.AllowFiltering = true;
            //Delete column is not resizable
            deleteColumn.Resizable = false;
            deleteColumn.HeaderStyle.Width = Unit.Pixel(25);
            this.MasterTableView.Columns.Add(deleteColumn);
        }

        private void AddDataColumns(DataSet sourceDS)
        {
            //For each column in the dataset
            foreach (DataColumn dataColumn in sourceDS.Tables[0].Columns)
            {
                //Build a new grid column, bound to the column in the dataset
                IndGridBoundColumn column = new IndGridBoundColumn();
                column.IsBooleanColumn = false;
                if (dataColumn.ExtendedProperties.Count != 0)
                {
                    if (dataColumn.ExtendedProperties.Contains("type"))
                    {
                        if (dataColumn.ExtendedProperties["type"].ToString().ToLower().Contains("bool"))
                        {
                            column = new IndBoolGridBoundColumn();
                        }
                    }
                    //Do not add columns that should not be added in the grid (this is set in DSUtils.ReplaceBooleanColumn() method)
                    if (dataColumn.ExtendedProperties.Contains("AddInGrid"))
                    {
                        if ((bool)dataColumn.ExtendedProperties["AddInGrid"] == false)
                        {
                            continue;
                        }
                    }
                }


                this.MasterTableView.Columns.Add(column);

                if (dataColumn.ColumnName == "LogicalKey")
                {
                    column.Display = false;
                    column.HeaderStyle.CssClass = "GridElements_IndGenericGrid_Hide";
                    column.ItemStyle.CssClass = "GridElements_IndGenericGrid_Hide";
                }

                //Set the column data type, data field and header text
                column.DataType = dataColumn.DataType;
                column.DataField = dataColumn.ColumnName;
                column.HeaderText = dataColumn.ColumnName;
                column.Resizable = false;

            }
        }
        #endregion Private Methods
    }
}
