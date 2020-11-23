using System;
using System.Collections.Generic;
using System.Text;
using Telerik.WebControls;
using System.Web.UI.WebControls;
using System.Web.UI;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.BusinessLogic;
using System.Reflection;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    public class IndGridBoundColumn : GridBoundColumn
    {
        #region Constants
        private const int CELL_PADDING = 8;
        #endregion Constants

        #region Members
        public bool IsBooleanColumn;
        private string lastFilterValue = String.Empty;
        public TableCell Cell;
        internal ControlHierarchyManager ControlHierarchyManager;
        #endregion Members

        #region Event Handlers
        public override void Initialize()
        {
            ControlHierarchyManager = new ControlHierarchyManager(this.Owner.OwnerGrid);
            base.Initialize();
        }
        protected override void SetupFilterControls(TableCell cell)
        {
            try
            {
                if (!this.Display)
                    return;
                base.SetupFilterControls(cell);
                this.Cell = cell;

                Image img = (Image)cell.Controls[1];
                cell.Controls.RemoveAt(1);
                IndImageButton btnImg = new IndImageButton();
                btnImg.ImageUrl = img.ImageUrl;
                btnImg.Height = btnImg.Width = Unit.Pixel(0);

                TextBox txtFilter = cell.Controls[0] as TextBox;
                string onKeyPress = txtFilter.Attributes["onKeyPress"];
                onKeyPress = "return RestrictSpecialKeys(event,'%',\"" + txtFilter.ClientID + "\")" + ((onKeyPress == null) ? String.Empty : onKeyPress);

                txtFilter.Attributes["onKeyPress"] = onKeyPress;

                if (GetColumnDataType() == typeof(bool))
                {
                    if (txtFilter != null)
                        txtFilter.Visible = false;
                    AddBooleanFilter(cell);
                }
                if (GetColumnDataType() == typeof(DateTime))
                {
                    if (txtFilter != null)
                        txtFilter.Visible = false;
                    AddDateFilter(cell);
                }

                //Set the maxlength property of the filter controls
                SetFilterControlsMaxLength(cell, txtFilter);

                //Apply on key press filtering
                SetOnKeyPressFiltering(cell, txtFilter);

                cell.Controls.Add(btnImg);
                //Applies css class to this column, depending on its position in the grid
                ApplyColumnCSSClass();
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



        protected override void SetCurrentFilterValueToControl(TableCell cell)
        {
            try
            {
                //SetCurrentFilterValueFromFilterExpression();
                if (((IndCatGrid)this.Owner.OwnerGrid).IndFilterItem != null)
                {
                    IndFilterItem indFilterItem = ((IndCatGrid)this.Owner.OwnerGrid).IndFilterItem;
                    if (indFilterItem.FilterValues.ContainsKey(this.UniqueName))
                    {
                        this.CurrentFilterValue = indFilterItem.FilterValues[this.UniqueName].ToString();
                    }
                }
                base.SetCurrentFilterValueToControl(cell);

                if (cell.Controls.Count > 2)
                {
                    if (cell.Controls[1] is DropDownList)
                    {
                        DropDownList ddlBoolFilter = cell.Controls[1] as DropDownList;
                        if (this.CurrentFilterValue != String.Empty)
                            ddlBoolFilter.SelectedValue = this.CurrentFilterValue;
                    }

                    if (cell.Controls[1] is IndDatePicker)
                    {
                        IndDatePicker datePicker = cell.Controls[1] as IndDatePicker;
                        if (!String.IsNullOrEmpty(this.CurrentFilterValue))
                            datePicker.SelectedDate = DateTime.Parse(this.CurrentFilterValue);
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

        protected override string GetCurrentFilterValueFromControl(TableCell cell)
        {
            try
            {
                if (cell.Controls.Count > 2)
                {
                    if (cell.Controls[1] is DropDownList)
                    {
                        DropDownList ddlBoolFilter = cell.Controls[1] as DropDownList;
                        return (ddlBoolFilter.SelectedValue == "All") ? String.Empty : ddlBoolFilter.SelectedValue;
                    }
                    if (cell.Controls[1] is IndDatePicker)
                    {
                        IndDatePicker datePicker = cell.Controls[1] as IndDatePicker;
                        return (datePicker.SelectedDate == null) ? String.Empty : ((DateTime)datePicker.SelectedDate).ToShortDateString();
                    }
                }
                return base.GetCurrentFilterValueFromControl(cell);
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
        #endregion Event Handlers

        #region Private Methods

        private void SetOnKeyPressFiltering(TableCell cell, TextBox txtFilter)
        {
            TableCell editCell = null;
            //If the parent of cell is null or it is not of GridFilteringItem type, return
            if (cell.Parent == null || !(cell.Parent is GridFilteringItem))
                return;
            //If the parent table of this GridFilteringItem does not contain a column named "EditColumn", return
            if (((GridFilteringItem)cell.Parent).OwnerTableView.Columns.FindByUniqueNameSafe("EditColumn") == null)
                return;
            
            //Get the cell in the header of the edit column (where the "apply filter" button is
            editCell = ((GridFilteringItem)cell.Parent)["EditColumn"];
            
            IndImageButton filterButton = (IndImageButton)editCell.Controls[editCell.Controls.Count - 1];

            if (txtFilter.Visible)
            {
                txtFilter.Attributes.Add("onkeydown", "doFilter('" + filterButton.ClientID + "', event)");
            }
            if (GetColumnDataType() == typeof(bool))
            {
                DropDownList filterDdl = (DropDownList)cell.Controls[cell.Controls.Count - 1];
                filterDdl.Attributes.Add("onkeydown", "doFilter('" + filterButton.ClientID + "', event)");
            }
        }

        /// <summary>
        /// Adds a RadDatePicker control to the header of this column
        /// </summary>
        /// <param name="cell"></param>
        private void AddDateFilter(TableCell cell)
        {
            IndDatePicker datePicker = new IndDatePicker();
            datePicker.ID = "pk" + this.UniqueName;
            datePicker.Width = Unit.Pixel(80);
            cell.Controls.Add(datePicker);
        }

        /// <summary>
        /// Applys the columns css class 
        /// </summary>
        private void ApplyColumnCSSClass()
        {
            if (GetIndex() % 2 == 1)
            {
                this.ItemStyle.CssClass = "IndEvenColumn";
            }
            else
            {
                this.ItemStyle.CssClass = "IndOddColumn";
            }
        }

        /// <summary>
        /// Adds the All.Yes/No dropdownlist to the cell filter
        /// </summary>
        /// <param name="cell">The cell where the filter should be added</param>
        private void AddBooleanFilter(TableCell cell)
        {
            DropDownList cmbBoolValues = new DropDownList();
            cmbBoolValues.CssClass = "FilterComboBox";
            cmbBoolValues.ID = "cmbBool" + this.UniqueName;
            cmbBoolValues.Items.Add("All");
            cmbBoolValues.Items.Add("Yes");
            cmbBoolValues.Items.Add("No");

            cell.Controls.Add(cmbBoolValues);
        }

        /// <summary>
        /// Gets the index of the current column (taking into account only the visible columns, not the hidden ones)
        /// </summary>
        /// <returns>the index of the current column (taking into account only the visible columns, not the hidden ones)</returns>
        private int GetIndex()
        {
            int index = this.Owner.Columns.IndexOf(this);
            int visibleIndex = 0;
            foreach (GridColumn column in this.Owner.Columns)
            {
                if (column is IndGridBoundColumn && column.Display)
                {
                    if (this.Owner.Columns.IndexOf(column) < index)
                    {
                        visibleIndex++;
                    }
                }
            }
            return visibleIndex;
        }

        private void SetFilterTextBoxMaxLength(TextBox txtFilter)
        {
            Type entityType = ((IndCatGrid)this.Owner.OwnerGrid).EntityType;
            if (entityType != null)
            {
                PropertyInfo[] propertyInfos = entityType.GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.DeclaredOnly);
                foreach (PropertyInfo propertyInfo in propertyInfos)
                {
                    object[] columnPropertyAttribute = propertyInfo.GetCustomAttributes(typeof(GridColumnPropertyAttribute), false);

                    if (columnPropertyAttribute.Length <= 0)
                        continue;
                    string colHeaderName = ((GridColumnPropertyAttribute)columnPropertyAttribute[0]).ColumnHeaderName;

                    if  ((colHeaderName == this.HeaderText) ||
                        (this.HeaderText.Contains((colHeaderName==null)?"":colHeaderName)) && (this.HeaderText.Contains("<input")))
                        
                    {
                        object[] propertyValidationAttributes = propertyInfo.GetCustomAttributes(typeof(PropertyValidationAttribute), false);
                        if (propertyValidationAttributes.Length > 0)
                        {
                            int maxLength = ((PropertyValidationAttribute)propertyValidationAttributes[0]).MaxLength;
                            int maxValue = ((PropertyValidationAttribute)propertyValidationAttributes[0]).MaxValue;
                            if (maxValue != int.MinValue)
                            {
                                txtFilter.MaxLength = maxValue.ToString().Length;
                            }
                            if (maxLength != int.MinValue)
                            {
                                txtFilter.MaxLength = maxLength;
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Gets the datatype of this column
        /// </summary>
        /// <returns></returns>
        private Type GetColumnDataType()
        {
            if (this.IsBooleanColumn)
                return typeof(bool);

            if (this.DataType == typeof(DateTime))
                return typeof(DateTime);

            if (this.DataType == typeof(int))
                return typeof(int);

            return typeof(string);

        }
        
        /// <summary>
        /// Sets the maxlength property of the filtering controls, depending on the object attributes (reflection)
        /// </summary>
        /// <param name="cell"></param>
        /// <param name="txtFilter"></param>
        private void SetFilterControlsMaxLength(TableCell cell, TextBox txtFilter)
        {
            if (this.Display && txtFilter.Visible)
            {
                SetVisibleFilterControlsMaxLength(cell, txtFilter);
            }
            else
            {
                if (GetColumnDataType() == typeof(bool))
                {
                    HeaderStyle.Width = Unit.Pixel(50);
                }
                if (GetColumnDataType() == typeof(DateTime))
                {
                    HeaderStyle.Width = Unit.Pixel(85);
                }
            }
        }

        /// <summary>
        /// Set max length for filter controls that are visible and displayed
        /// </summary>
        /// <param name="cell"></param>
        /// <param name="txtFilter"></param>
        private void SetVisibleFilterControlsMaxLength(TableCell cell, TextBox txtFilter)
        {
            //HACK: MaxLength for the filter textbox for year month columns. If the type Yearmonth will be created, this code will be changed
            if ((this.HeaderText.Contains("Year") && this.HeaderText.Contains("Month"))
                || (this.HeaderText.Contains("Start") && this.HeaderText.Contains("Date"))
                || (this.HeaderText.Contains("End") && this.HeaderText.Contains("Date")) 
                || (this.HeaderText.Contains("Period")))
            {
                txtFilter.MaxLength = 7;
            }
            else
            {
                SetFilterTextBoxMaxLength(txtFilter);
            }
            //HACK: MaxLength for the filter textbox for year month columns. If the type Yearmonth will be created, this code will be changed
            if (this.HeaderText.Contains("Last") && this.HeaderText.Contains("Update"))
            {
                txtFilter.MaxLength = 8;
            }
            if (txtFilter.MaxLength > 0 && txtFilter.MaxLength <= 3)
            {
                txtFilter.Width = Unit.Pixel(34);
            }
            if (txtFilter.MaxLength > 3 && txtFilter.MaxLength <= 18)
            {
                txtFilter.Width = Unit.Pixel(7 * txtFilter.MaxLength);
            }
            if ((txtFilter.MaxLength > 18) || (txtFilter.MaxLength == 0))
            {
                txtFilter.Width = Unit.Pixel(108);
            }
            cell.Width = txtFilter.Width;


            HeaderStyle.Width = Unit.Pixel((int)txtFilter.Width.Value + CELL_PADDING);
        }
        #endregion Private Methods
    }

    public class IndBoolGridBoundColumn : IndGridBoundColumn
    {
        public IndBoolGridBoundColumn()
        {
            IsBooleanColumn = true;
        }
    }
}
