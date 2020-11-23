using System;
using System.Collections.Generic;
using System.Text;
using Telerik.WebControls;
using System.Web.UI.WebControls;
using System.Web.UI;
using Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework.Utils;

namespace Inergy.Indev3.WebFramework.WebControls
{
    public class IndGridEditColumn : GridTemplateColumn
    {
        internal ControlHierarchyManager ControlHierarchyManager;

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
                base.SetupFilterControls(cell);
                this.ItemStyle.CssClass = "IndGridEditColumn";
                //Beacuse of a bug of Telerik we can not remove the controls, so we make them invisible
                foreach (Control c in cell.Controls)
                {
                    c.Visible = false;
                }
                IndImageButton filterButton = new IndImageButton();
                filterButton.ID = "btnApplyFilter";
                filterButton.ImageUrl = "~/Images/buttons_filter.png";
                filterButton.ImageUrlOver = "~/Images/buttons_filter_over.png";
                filterButton.Click += new System.Web.UI.ImageClickEventHandler(filterButton_Click);
                filterButton.ToolTip = "Apply Filter";
                cell.Controls.Add(filterButton);
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

        private void filterButton_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                //StringBuilder filterExpression = new StringBuilder();
                ((IndCatGrid)this.Owner.OwnerGrid).IndFilterItem = new IndFilterItem();

                foreach (GridColumn c in this.Owner.Columns)
                {
                    IndGridBoundColumn col = c as IndGridBoundColumn;
                    string comparerStart;
                    string comparerEnd;
                    GridKnownFunction function;
                    if (col != null && col.Display)
                    {
                        SetFilterParameters(col, out comparerStart, out comparerEnd, out function);
                        //col.CurrentFilterValue = 

                        if (col.Cell.Controls.Count > 2)
                        {
                            FilterSpecialColumn(col, ((IndCatGrid)this.Owner.OwnerGrid).IndFilterItem, comparerStart, comparerEnd, function);
                        }
                        else
                        {
                            TextBox t = (TextBox)col.Cell.Controls[0];
                            decimal value;
                            if (IsColumnNumeric(col) && decimal.TryParse(t.Text, out value) == false)
                            {
                                col.CurrentFilterValue = String.Empty;
                                continue;
                            }
                            FilterCommonColumn(col, t.Text.Replace("'", "''"), ((IndCatGrid)this.Owner.OwnerGrid).IndFilterItem, comparerStart, comparerEnd, function);
                        }
                    }
                }

                IndCatGrid parentGrid = (IndCatGrid)this.Owner.OwnerGrid;

                if (parentGrid.IndFilterItem.FilterExpression.Length > 0)
                {
                    parentGrid.IndFilterItem.FilterExpression.Append(")");
                }
                parentGrid.IndFilterExpression = parentGrid.IndFilterItem.FilterExpression.ToString();

                CatalogFilter cfilter = new CatalogFilter();
                if (this.Owner.Page.Request != null && this.Owner.Page.Request["Code"] != null)
                {
                    cfilter.Code = this.Owner.Page.Request.QueryString["Code"];
                    cfilter.WhereClause = parentGrid.IndFilterExpression;
                    cfilter.CopyColumnsFrom(this.Owner.Columns);
                    SessionManager.SetSessionValue(this.Owner.Page, "Filter", cfilter);
                }
               
                this.Owner.OwnerGrid.Rebind();
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

        private void FilterCommonColumn(IndGridBoundColumn col, string value, IndFilterItem filterItem, string comparerStart, string comparerEnd, GridKnownFunction function)
        {
            if (String.IsNullOrEmpty(value))
            {
                col.CurrentFilterFunction = function;
                col.CurrentFilterValue = value;
                return;
            }
            if (filterItem.FilterExpression.Length == 0)
            {
                filterItem.FilterExpression.Append("([" + col.UniqueName + "] " + comparerStart + value + comparerEnd);
            }
            else
            {
                filterItem.FilterExpression.Append(" AND [" + col.UniqueName + "] " + comparerStart + value + comparerEnd);
            }
            col.CurrentFilterFunction = function;
            col.CurrentFilterValue = value.Replace("''","'");
            filterItem.FilterValues.Add(col.UniqueName, value.Replace("''", "'"));
        }

        private void FilterSpecialColumn(IndGridBoundColumn col, IndFilterItem filterItem, string comparerStart, string comparerEnd, GridKnownFunction function)
        {
            if (col.Cell.Controls[1] is DropDownList)
            {
                DropDownList d = (DropDownList)col.Cell.Controls[1];
                if (filterItem.FilterExpression.Length == 0)
                {
                    filterItem.FilterExpression.Append("([" + col.UniqueName + "] " + comparerStart + ((d.SelectedValue == "All") ? String.Empty : d.SelectedValue) + comparerEnd);
                }
                else
                {
                    filterItem.FilterExpression.Append(" AND [" + col.UniqueName + "] " + comparerStart + ((d.SelectedValue == "All") ? String.Empty : d.SelectedValue) + comparerEnd);
                }
                col.CurrentFilterFunction = function;
                col.CurrentFilterValue = ((d.SelectedValue == "All") ? String.Empty : d.SelectedValue);
                filterItem.FilterValues.Add(col.UniqueName, (d.SelectedValue == "All") ? String.Empty : d.SelectedValue);
            }

            if (col.Cell.Controls[1] is IndDatePicker)
            {
                IndDatePicker datePicker = (IndDatePicker)col.Cell.Controls[1];
                if (datePicker.SelectedDate != null)
                {
                    if (filterItem.FilterExpression.Length == 0)
                    {
                        filterItem.FilterExpression.Append("([" + col.UniqueName + "] >= '" + ((DateTime)datePicker.SelectedDate).ToShortDateString() + " 00:00:00.000' AND " +
                            "[" + col.UniqueName + "] <= '" + ((DateTime)datePicker.SelectedDate).ToShortDateString() + " 23:59:59.999'");
                    }
                    else
                    {
                        filterItem.FilterExpression.Append(" AND [" + col.UniqueName + "] >= '" + ((DateTime)datePicker.SelectedDate).ToShortDateString() + " 00:00:00.000' AND " +
                            "[" + col.UniqueName + "] <= '" + ((DateTime)datePicker.SelectedDate).ToShortDateString() + " 23:59:59.999'");
                    }
                }
                col.CurrentFilterFunction = function;
                col.CurrentFilterValue = (datePicker.SelectedDate != null) ? ((DateTime)datePicker.SelectedDate).ToShortDateString() : null;
                filterItem.FilterValues.Add(col.UniqueName, (datePicker.SelectedDate != null) ? ((DateTime)datePicker.SelectedDate).ToShortDateString() : String.Empty);
            }
        }

        private void SetFilterParameters(IndGridBoundColumn col, out string comparerStart, out string comparerEnd, out GridKnownFunction function)
        {
            comparerStart = String.Empty;
            comparerEnd = String.Empty;
            function = GridKnownFunction.NoFilter;
            if (IsColumnNumeric(col))
            {
                comparerStart = "= ";
                comparerEnd = String.Empty;
                function = GridKnownFunction.EqualTo;
            }
            if (col.DataType == typeof(string))
            {
                comparerStart = "LIKE '%";
                comparerEnd = "%'";
                function = GridKnownFunction.Contains;
            }
            if (col.DataType == typeof(DateTime))
            {
                //comparerStart = "= '";
                //comparerEnd = "'";
                function = GridKnownFunction.Between;
            }
        }

        private bool IsColumnNumeric(IndGridBoundColumn col)
        {
            return col.DataType == typeof(int) || col.DataType == typeof(decimal);
        }
        #endregion Private Methods
    }
}
