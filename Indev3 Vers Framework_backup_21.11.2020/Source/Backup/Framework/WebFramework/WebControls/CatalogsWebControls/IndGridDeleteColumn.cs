using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using Telerik.WebControls;
using System.Web.UI.WebControls;
using Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// Column used by the application for selecting entities to be deleted. It also has the "Clear Filtes" button in the header
    /// </summary>
    public class IndGridDeleteColumn : GridTemplateColumn
    {
        internal ControlHierarchyManager ControlHierarchyManager;

        #region Event Handlers
        public override void Initialize()
        {
            ControlHierarchyManager = new ControlHierarchyManager(this.Owner.OwnerGrid);
            base.Initialize();
        }
        /// <summary>
        /// Set up the filter controls. Make the existing ones invisible, and add the clear filter image button
        /// </summary>
        /// <param name="cell"></param>
        protected override void SetupFilterControls(TableCell cell)
        {
            try
            {
                base.SetupFilterControls(cell);
                this.ItemStyle.CssClass = "IndGridDeleteColumn";
                //Beacuse of a bug of Telerik we can not remove the controls, so we make them invisible
                foreach (Control c in cell.Controls)
                {
                    c.Visible = false;
                }
                IndImageButton clearFilterButton = new IndImageButton();
                clearFilterButton.ID = "btnCancelFilter";
                clearFilterButton.ImageUrl = "~/Images/buttons_clear_filter.png";
                clearFilterButton.ImageUrlOver = "~/Images/buttons_clear_filter_over.png";
                clearFilterButton.Click += new System.Web.UI.ImageClickEventHandler(clearFilterButton_Click);
                clearFilterButton.ToolTip = "Clear Filter";
                cell.Controls.Add(clearFilterButton);
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
        /// Event handler for the click event of Clear Filter button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void clearFilterButton_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                //For each data bound and displayed column in the grid, clear its filter
                foreach (GridColumn c in this.Owner.Columns)
                {
                    IndGridBoundColumn col = c as IndGridBoundColumn;
                    if (col != null && col.Display)
                    {
                        col.CurrentFilterFunction = GridKnownFunction.NoFilter;
                        col.CurrentFilterValue = String.Empty;
                    }
                }

                IndCatGrid parentGrid = (IndCatGrid)this.Owner.OwnerGrid;


                parentGrid.IndFilterExpression = String.Empty;
                parentGrid.IndFilterItem = new IndFilterItem();

                parentGrid.Rebind();
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
    }
}
