using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework;
using System.Web.UI.Design;
using Telerik.WebControls;
using System.Reflection;
using System.Data;
using Inergy.Indev3.WebFramework.WebControls;
using System.Web.UI.HtmlControls;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.BusinessLogic.Catalogues;
using System.Diagnostics;

namespace Inergy.Indev3.WebFramework.GenericControls
{
    /// <summary>
    /// Generic web control used to view a catalogue
    /// </summary>
    [ToolboxData("<{0}:GenericViewControl runat=server></{0}:GenericViewControl>")]
    [Designer(typeof(ContainerControlDesigner))]
    [ParseChildren(false)]
    public class GenericViewControl : WebControl, INamingContainer
    {
        #region Members
        /// <summary>
        /// The RadGrid used for viewing the catalogue
        /// </summary>
        private IndCatGrid GenericGrid;
        private CurrentUser _currentUser;
        private GenericUserControl _ParentGenericUserControl
        {
            get
            {
                if (!DesignMode)
                {
                    Debug.Assert(this.Parent != null, "Parent for GenericViewControl must not be null.");
                    Debug.Assert(this.Parent is GenericUserControl, "Parent for GenericViewControl must be of type GenericUserControl. Now is: " + this.Parent.GetType().ToString() + "!");

                    return (GenericUserControl)this.Parent;
                }
                else
                    return null;
            }
        }
        
        private Type _EntityType;
        /// <summary>
        /// The type of entity associated with this control
        /// </summary>
        [Browsable(false)]
        public Type EntityType
        {
            get { return _EntityType; }
            set
            {
                _EntityType = value;
            }
        }
        private Permissions _ViewPermission;
        /// <summary>
        /// The permission of the current user to view this entity
        /// </summary>
        public Permissions ViewPermission
        {
            get { return _ViewPermission; }
            set { _ViewPermission = value; }
        }

        private Permissions _AddPermission;
        /// <summary>
        /// The permission of the current user to add a new entity
        /// </summary>
        public Permissions AddPermission
        {
            get { return _AddPermission; }
            set { _AddPermission = value; }
        }

        private Permissions _EditPermission;
        /// <summary>
        /// The permission of the current user to edit this entity
        /// </summary>
        public Permissions EditPermission
        {
            get { return _EditPermission; }
            set { _EditPermission = value; }
        }

        private Permissions _DeletePermission;
        /// <summary>
        /// The permission of the current user to delete this entity
        /// </summary>
        public Permissions DeletePermission
        {
            get { return _DeletePermission; }
            set { _DeletePermission = value; }
        }

        private bool _DataSourcePersistent = true;
        /// <summary>
        /// Specify if the NeedDataSourceEvent is fired evrey time
        /// </summary>
        public bool DataSourcePersistent
        {
            get { return _DataSourcePersistent; }
            set { _DataSourcePersistent = value; }
        }

        #endregion

        public GenericViewControl()
        {
            this.EnableViewState = false;
        }

        #region Private Methods

        /// <summary>
        /// Applies the permissions depending on the current user
        /// </summary>
        private void ApplyPermissions()
        {
            //this.Parent should always be GenericUserControl
            Debug.Assert(this.Parent is GenericUserControl, ApplicationMessages.EXCEPTION_CONTROL_NOT_PLACED_CORRECT);

            //Code for setting permissions is in OnInit method
            //Enable/Diasble each item
            foreach (GridDataItem item in GenericGrid.Items)
            {
				GridColumn gridColumn = GenericGrid.Columns.FindByDataFieldSafe("IdCountry");
                if (item["EditColumn"].Controls.Count > 0)
                {
                    if (!(item["EditColumn"].Controls[0] is ImageButton))
                        throw new IndException(ApplicationMessages.EXCEPTION_EDITCOLUMN_NOT_CONTAIN_IMAGEBUTTON);
                    //Get the column controls and set them disabled if it is the case
                    IndImageButton btnEdit = item["EditColumn"].Controls[0] as IndImageButton;
                    if (GenericGrid.Columns.FindByUniqueNameSafe("IsProgramManager") != null && _EditPermission == Permissions.Restricted)
                    {
                        btnEdit.Enabled = bool.Parse(item["IsProgramManager"].Text);
                    }
                    else
                    {
						//Set the corresponding permissions
						if (gridColumn != null && _EditPermission == Permissions.Restricted) 
						{
							btnEdit.Enabled = (_currentUser.IdCountry == int.Parse(item["IdCountry"].Text));
						}
						else
						{
							btnEdit.Enabled = (_EditPermission == Permissions.None) ? false : true;
                        }
                        
                    }
                    //If the edit button is disabled (because the user does not have the right to edit), set its image to the disabled image
                    if (!btnEdit.Enabled)
                    {
                        btnEdit.ImageUrl = "~/Images/buttons_editrow_disabled.png";
                    }
                }
                if (item["DeleteColumn"].Controls.Count > 0)
                {
                    //This column should always have a CheckBox
                    if (!(item["DeleteColumn"].Controls[0] is CheckBox))
                        throw new IndException(ApplicationMessages.EXCEPTION_DELETECOLUMN_NOT_CONTAIN_CHECKBOX);
                    CheckBox chkDelete = item["DeleteColumn"].Controls[0] as CheckBox;
						//Set the corresponding permissions
						if (gridColumn != null && _DeletePermission == Permissions.Restricted) 
						{
							chkDelete.Enabled = (_currentUser.IdCountry == int.Parse(item["IdCountry"].Text));
						}
						else
						{                    
							chkDelete.Enabled = (_DeletePermission == Permissions.None) ? false : true;
						}
                }
            }
            GenericGrid.btnAdd.Enabled = (_AddPermission == Permissions.None) ? false : true;
            //If the add button is disabled (because the user does not have the right to add), set its image to the disabled image
            if (!GenericGrid.btnAdd.Enabled)
            {
                GenericGrid.btnAdd.ImageUrl = "~/Images/buttons_new_disabled.png";
            }
            GenericGrid.btnDelete.Enabled = (_DeletePermission == Permissions.None) ? false : true;
            //If the delete button is disabled (because the user does not have the right to delete), set its image to the disabled image
            if (!GenericGrid.btnDelete.Enabled)
            {
                GenericGrid.btnDelete.ImageUrl = "~/Images/buttons_delete_disabled.png";
            }
        }
        #endregion

        #region Event Handlers
        /// <summary>
        /// Override the OnLoad method and initialize the grid.
        /// </summary>
        /// <param name="e"></param>
        protected override void OnLoad(EventArgs e)
        {
            try
            {               
                base.OnLoad(e);

                //Get the moduleCode from the parent Ascx
                string moduleCode = _ParentGenericUserControl.ModuleCode;


                //Get the current user from session
                _currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect(_ParentGenericUserControl.ParentPage, SessionStrings.CURRENT_USER);

                //The exception to the rule. ProjectCoreTeamMember is the only entity used with GenericViewControl for which the id of the project
                //is relevant
                if (EntityType == typeof(ProjectCoreTeamMember) ) //|| (EntityType == typeof(WorkPackage)))
                {
                    int idProject = SessionManager.GetCurrentProject(this.Page).Id;
                    //Get the permisions from the current logged user
                    this.ViewPermission = _currentUser.GetPermission(moduleCode, Operations.View, idProject);
                    this.AddPermission = _currentUser.GetPermission(moduleCode, Operations.Add, idProject);
                    this.EditPermission = _currentUser.GetPermission(moduleCode, Operations.Edit, idProject);
                    this.DeletePermission = _currentUser.GetPermission(moduleCode, Operations.Delete, idProject);
                }
                else
                {
                    //Get the permisions from the current logged user
                    this.ViewPermission = _currentUser.GetPermission(moduleCode, Operations.View);
                    this.AddPermission = _currentUser.GetPermission(moduleCode, Operations.Add);
                    this.EditPermission = _currentUser.GetPermission(moduleCode, Operations.Edit);
                    this.DeletePermission = _currentUser.GetPermission(moduleCode, Operations.Delete);
                }

                GenericGrid = new IndCatGrid();

                if (this.ViewPermission == Permissions.None)
                {
                    GenericGrid.Visible = false;
                    throw new IndException(ApplicationMessages.EXCEPTION_NO_PERMISSION_TO_VIEW_PAGE);
                }

                GenericGrid.EntityType = _EntityType;
                GenericGrid.ViewPermission = ViewPermission;
                GenericGrid.UseAutomaticEntityBinding = true;
                GenericGrid.MasterTableView.TableLayout = GridTableLayout.Fixed;


                if (!_DataSourcePersistent)
                    GenericGrid.DataSourcePersistenceMode = GridDataSourcePersistenceMode.NoPersistence;
                GenericGrid.ID = "grd";

                Dictionary<string, int> currentPageDictionary;

                if ((currentPageDictionary = (Dictionary<string, int>)SessionManager.GetSessionValueNoRedirect(_ParentGenericUserControl.ParentPage, SessionStrings.PAGE_NUMBER_MAPPING)) != null)
                {
                    GenericGrid.CurrentPage = currentPageDictionary[SessionManager.GetSessionValueRedirect(_ParentGenericUserControl.ParentPage, SessionStrings.VIEW_CONTROL).ToString()];
                }

                //Get the ajax manger placed on the masterpage
                RadAjaxManager ajaxManager = ((IndBasePage)this.Page).GetAjaxManager();
                //This web control will refresh itself, without refreshing the whole page
                ajaxManager.AjaxSettings.AddAjaxSetting(this, this);

                Panel pnlErrors = (Panel)this.Page.Master.FindControl("pnlErrors");
                ajaxManager.AjaxSettings.AddAjaxSetting(this, pnlErrors);
            }
            catch (IndException ex)
            {
                _ParentGenericUserControl.ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }

        /// <summary>
        /// Overriden method in which we add our grid to the child controls of the control
        /// </summary>
        protected override void CreateChildControls()
        {
            try
            {
                base.CreateChildControls();
                GenericGrid.ClientSettings.ClientEvents.OnGridCreated = "GridCreated";
                this.Controls.Add(GenericGrid);
                if (GenericGrid.Columns.Count > 0 && SessionManager.GetSessionValueNoRedirect(this.Page, "Filter") != null)
                {
                    CatalogFilter cfilter = (CatalogFilter)SessionManager.GetSessionValueNoRedirect(this.Page, "Filter");
                    if (this.Page.Request.QueryString["Code"] != null && this.Page.Request.QueryString["Code"] == cfilter.Code)
                    {
                        foreach (Telerik.WebControls.GridColumn col in cfilter.Columns)
                        {
                            SetColumn(col);
                        }
                        GenericGrid.MasterTableView.FilterExpression = cfilter.WhereClause;
                        GenericGrid.Rebind();
                    }
                    else
                    {
                        SessionManager.RemoveValueFromSession(this.Page, "Filter");
                    }
                }
            }
            catch(IndException ex)
            {
                _ParentGenericUserControl.ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }

        private void SetColumn(GridColumn c)
        {
            IndGridBoundColumn col = c as IndGridBoundColumn;
            if (col != null && col.Display)
            {

                if (col.Cell.Controls.Count > 2)
                {

                    if (col.Cell.Controls[1] is DropDownList)
                    {
                        DropDownList d = (DropDownList)col.Cell.Controls[1];
                        GridColumn column = GenericGrid.MasterTableView.GetColumnSafe(col.UniqueName);
                        column.CurrentFilterValue = ((d.SelectedValue == "All") ? String.Empty : d.SelectedValue);
                    }

                    if (col.Cell.Controls[1] is IndDatePicker)
                    {
                        IndDatePicker datePicker = (IndDatePicker)col.Cell.Controls[1];
                        GridColumn column = GenericGrid.MasterTableView.GetColumnSafe(col.UniqueName);
                        column.CurrentFilterValue = (datePicker.SelectedDate != null) ? ((DateTime)datePicker.SelectedDate).ToShortDateString() : null;
                    }

                }
                else
                {
                    int ind = -1;
                    if (col.Cell.Controls.Count > 0 && col.Cell.Controls[0] is TextBox)
                    {
                        ind = 0;
                    }
                    else if (col.Cell.Controls.Count > 1 && col.Cell.Controls[1] is TextBox)
                    {
                        ind = 1;
                    }
                    if (ind >= 0)
                    {
                        GridColumn column = GenericGrid.MasterTableView.GetColumnSafe(col.UniqueName);
                        if (column != null) column.CurrentFilterValue = ((TextBox)col.Cell.Controls[ind]).Text.Trim();
                    }

                }
            }
        }

        private bool IsColumnNumeric(IndGridBoundColumn col)
        {
            return col.DataType == typeof(int) || col.DataType == typeof(decimal);
        }

        protected override void OnInit(EventArgs e)
        {
            try
            {
                base.OnInit(e);
                if (SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.ENTITY_MAPPING) == null)
                {
                    SessionManager.SetSessionValue(this.Page, SessionStrings.ENTITY_MAPPING, EntityUtils.CreateCatalogueMapping());
                }
            }
            catch (IndException ex)
            {
                _ParentGenericUserControl.ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }
        /// <summary>
        /// Override the OnPreRender method that raises the PreRender event
        /// </summary>
        /// <param name="e"></param>
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);
                ApplyPermissions();
            }
            catch (IndException ex)
            {
                _ParentGenericUserControl.ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }
        #endregion Event Handlers

        #region Public Methods
        public void AddColumnHeaderControl(string columnName, string htmlText)
        {
            try
            {
                GenericGrid.AddColumnHeaderControl(columnName, htmlText);
            }
            catch (IndException ex)
            {
                _ParentGenericUserControl.ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }
        public void ExportData()
        {
            try
            {
                GenericGrid.ExportData();
            }
            catch (IndException ex)
            {
                _ParentGenericUserControl.ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }
        #endregion Public Methods
    }
}
