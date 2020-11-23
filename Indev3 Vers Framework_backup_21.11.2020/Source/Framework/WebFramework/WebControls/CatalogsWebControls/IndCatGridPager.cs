using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using Telerik.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    [DefaultProperty("Items")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.Label))]
    [ToolboxData("<{0}:IndCatGridPager runat=\"server\"></{0}:IndCatGridPager>")]
    internal class IndCatGridPager : WebControl
    {
        private GridPagingManager PagingManager;
        private IndCatGrid owner;
        private int RowCount = 0;
        private int PageCount = 0;
        private Label lblItems = new Label();
        private int PageSize = 0;
        private LinkButton lnkFirst;
        private LinkButton lnkPrev;
        private LinkButton lnkNext;
        private LinkButton lnkLast;
        private HtmlInputText txtCurrentPage;
        private Label lblPageText;
        private Label lblPageTextAfter;

        internal ControlHierarchyManager ControlHierarchyManager;

        public IndCatGridPager(GridPagingManager pagingManager, IndCatGrid ownerGrid)
        {
            try
            {
                ControlHierarchyManager = new ControlHierarchyManager(this);

                this.PagingManager = pagingManager;
                this.owner = ownerGrid;

                if (pagingManager != null)
                {
                    this.RowCount = pagingManager.DataSourceCount;
                }
                this.PageSize = owner.PageSize;

                lblItems.ID = "lblItems";

                CreateControls();
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

        public void SetPage()
        {
            try
            {
                int pageNo;
                if (int.TryParse(txtCurrentPage.Value, out pageNo) == true && pageNo <= PageCount && pageNo > 0)
                {
                    owner.CurrentPage = int.Parse(txtCurrentPage.Value) - 1;
                    owner.Rebind();
                }
                else
                {
                    txtCurrentPage.Value = "" + (PagingManager.CurrentPageIndex + 1);
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

        private void CreateControls()
        {
            this.Controls.Clear();

            if (PageSize != 0)
            {
                PageCount = owner.PageCount;


                SetLblItems();
                SetNavigationButtons();
                RenderControls();
            }
        }

        /// <summary>
        /// Renders all controls in the pager
        /// </summary>
        private void RenderControls()
        {
            Table tblPager = new Table();
            tblPager.Width = Unit.Percentage(100);
            tblPager.CellPadding = 0;
            tblPager.CellSpacing = 0;

            TableRow row = new TableRow();
            row.Style.Add(HtmlTextWriterStyle.PaddingBottom, "0");
            row.Style.Add(HtmlTextWriterStyle.PaddingLeft, "0");
            row.Style.Add(HtmlTextWriterStyle.PaddingTop, "0");
            row.Style.Add(HtmlTextWriterStyle.PaddingRight, "0");

            TableCell cellItems = new TableCell();
            cellItems.Style.Add(HtmlTextWriterStyle.PaddingBottom, "0");
            cellItems.Style.Add(HtmlTextWriterStyle.PaddingLeft, "0");
            cellItems.Style.Add(HtmlTextWriterStyle.PaddingTop, "0");
            cellItems.Style.Add(HtmlTextWriterStyle.PaddingRight, "0");
            cellItems.Width = Unit.Percentage(12);
            cellItems.HorizontalAlign = HorizontalAlign.Left;
            cellItems.Controls.Add(lblItems);

            TableCell cellPager = new TableCell();
            cellPager.Style.Add(HtmlTextWriterStyle.PaddingBottom, "0");
            cellPager.Style.Add(HtmlTextWriterStyle.PaddingLeft, "0");
            cellPager.Style.Add(HtmlTextWriterStyle.PaddingTop, "0");
            cellPager.Style.Add(HtmlTextWriterStyle.PaddingRight, "0");
            cellPager.Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            //cellPager.Width = Unit.Percentage(10);
            cellPager.Controls.Add(lnkFirst);
            cellPager.Controls.Add(lnkPrev);
            cellPager.Controls.Add(lblPageText);
            cellPager.Controls.Add(txtCurrentPage);
            cellPager.Controls.Add(lblPageTextAfter);
            cellPager.Controls.Add(lnkNext);
            cellPager.Controls.Add(lnkLast);

            TableCell cellPageNo = new TableCell();
            cellPageNo.HorizontalAlign = HorizontalAlign.Left;
            cellPageNo.Style.Add(HtmlTextWriterStyle.PaddingBottom, "0");
            cellPageNo.Style.Add(HtmlTextWriterStyle.PaddingLeft, "0");
            cellPageNo.Style.Add(HtmlTextWriterStyle.PaddingTop, "0");
            cellPageNo.Style.Add(HtmlTextWriterStyle.PaddingRight, "0");
            cellPageNo.Style.Add(HtmlTextWriterStyle.TextAlign, "right");
            cellPageNo.Width = Unit.Pixel(180);

            int firstPage = PagingManager.CurrentPageIndex+1;
            int lastPage = (PagingManager.CurrentPageIndex + 10) < PageCount ? PagingManager.CurrentPageIndex + 10 : PageCount;

            if (lastPage - firstPage < 10)
                firstPage = lastPage - 9;
            if (firstPage < 1)
                firstPage = 1;

            if (firstPage > 1)
            {
                LinkButton lnkLastPages = new LinkButton();
                lnkLastPages.CssClass = CSSStrings.GridPagerPageLinkCssClass;
                lnkLastPages.ID = "lnkLastPages";
                lnkLastPages.Text = "...";
                lnkLastPages.Click += new EventHandler(lnkLastPages_Click);
                lnkLastPages.ToolTip = "Previous 10 pages";
                cellPageNo.Controls.Add(lnkLastPages);
                Label lblSpace = new Label();
                lblSpace.Text = "  ";
                lblSpace.ID = "lblSpaceLastPages";
                cellPageNo.Controls.Add(lblSpace);
            }

            

            for (int i = firstPage; i <= lastPage; i++)
            {
                if (i == PagingManager.CurrentPageIndex + 1)
                {
                    Label lblPageNo = new Label();
                    lblPageNo.CssClass = CSSStrings.GridPagerPageLabelCssClass;
                    lblPageNo.ID = "lblPageNo" + i.ToString();
                    lblPageNo.ToolTip = "Page " + i.ToString();
                    Label lblSpace = new Label();
                    lblSpace.Text = "  ";
                    lblSpace.ID = "lblSpace" + i.ToString();
                    lblPageNo.Text = i.ToString();
                    cellPageNo.Controls.Add(lblPageNo);
                    cellPageNo.Controls.Add(lblSpace);
                }
                else
                {
                    LinkButton lnkPageNo = new LinkButton();
                    lnkPageNo.CssClass = CSSStrings.GridPagerPageLinkCssClass;
                    lnkPageNo.ID = "lnkPageNo" + i.ToString();
                    lnkPageNo.ToolTip = "Page " + i.ToString();
                    Label lblSpace = new Label();
                    lblSpace.Text = "  ";
                    lblSpace.ID = "lblSpace" + i.ToString();
                    lnkPageNo.Click += new EventHandler(lnkPageNo_Click);
                    lnkPageNo.Text = i.ToString();
                    cellPageNo.Controls.Add(lnkPageNo);
                    cellPageNo.Controls.Add(lblSpace);
                }
            }

            if (PageCount > lastPage)
            {
                LinkButton lnkNextPages = new LinkButton();
                lnkNextPages.CssClass = CSSStrings.GridPagerPageLinkCssClass;
                lnkNextPages.ID = "lnkNextPages";
                lnkNextPages.Text = "...";
                lnkNextPages.ToolTip = "Next 10 pages";
                lnkNextPages.Click += new EventHandler(lnkNextPages_Click);
                cellPageNo.Controls.Add(lnkNextPages);
            }

            row.Cells.Add(cellItems);
            row.Cells.Add(cellPager);
            row.Cells.Add(cellPageNo);
            tblPager.Rows.Add(row);
            this.Controls.Add(tblPager);
        }

        private void lnkNextPages_Click(object sender, EventArgs e)
        {
            int NewPage = owner.CurrentPage;
            owner.CurrentPage = (NewPage + 10 < PageCount) ? NewPage + 10 : PageCount;
            owner.Rebind();
        }

        private void lnkLastPages_Click(object sender, EventArgs e)
        {
            int NewPage = owner.CurrentPage;
            owner.CurrentPage = (NewPage - 10 > 0) ? NewPage - 10 : 0;
            owner.Rebind();
        }

        private void SetNavigationButtons()
        {
            lnkFirst = new LinkButton();
            lnkFirst.Text = "&nbsp&nbsp<<&nbsp&nbsp";
            lnkFirst.ID = "lnkFirst";
            lnkFirst.Click += new EventHandler(lnkFirst_Click);
            lnkFirst.CssClass = CSSStrings.GridPagerLinkCssClass;
            lnkFirst.ToolTip = "First Page";

            lnkLast = new LinkButton();
            lnkLast.Text = "&nbsp&nbsp>>&nbsp&nbsp";
            lnkLast.ID = "lnkLast";
            lnkLast.ToolTip = "Last Page";
            lnkLast.Click += new EventHandler(lnkLast_Click);
            lnkLast.CssClass = CSSStrings.GridPagerLinkCssClass;

            lnkPrev = new LinkButton();
            lnkPrev.Text = "<&nbsp&nbsp";
            lnkPrev.ID = "lnkPrev";
            lnkPrev.ToolTip = "Previous Page";
            lnkPrev.Click += new EventHandler(lnkPrev_Click);
            lnkPrev.CssClass = CSSStrings.GridPagerLinkCssClass;

            lnkNext = new LinkButton();
            lnkNext.Text = "&nbsp&nbsp>";
            lnkNext.ID = "lnkNext";
            lnkNext.ToolTip = "Next Page";
            lnkNext.Click+=new EventHandler(lnkNext_Click);
            lnkNext.CssClass = CSSStrings.GridPagerLinkCssClass;

            txtCurrentPage = new HtmlInputText();
            txtCurrentPage.ID = "txtPage";
            txtCurrentPage.Size = 1;
            txtCurrentPage.Value = "" + (owner.CurrentPage + 1);
            txtCurrentPage.Style.Add(HtmlTextWriterStyle.Height, "12px");
            txtCurrentPage.Style.Add(HtmlTextWriterStyle.Width, "20px");
            txtCurrentPage.Style.Add(HtmlTextWriterStyle.FontSize, "11px");
            txtCurrentPage.Style.Add(HtmlTextWriterStyle.FontFamily, "Tahoma");

            lblPageText = new Label();
            lblPageText.Text = "Page ";
            lblPageText.CssClass = CSSStrings.GridPagerLabelCssClass;
            lblPageTextAfter = new Label();
            lblPageTextAfter.Text = " of " + PageCount.ToString();
            lblPageTextAfter.CssClass = CSSStrings.GridPagerLabelCssClass;

            SetLinksState();
        }
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);
                txtCurrentPage.Attributes.Add("onkeypress", "ChangePage(\"" + owner.UniqueID + "\", \"Rebind\", \"" + owner.ClientID + "\", event);return RestrictKeys(event,'1234567890','" + txtCurrentPage.ClientID + "')");
                txtCurrentPage.MaxLength = 9;
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

        private void SetLinksState()
        {
            lnkFirst.Enabled = (owner.CurrentPage == 0) ? false : true;
            lnkLast.Enabled = (owner.CurrentPage == PageCount - 1 || PageCount == 0) ? false : true;
            lnkPrev.Enabled = (owner.CurrentPage == 0) ? false : true;
            lnkNext.Enabled = (owner.CurrentPage == PageCount - 1 || PageCount == 0) ? false : true;
        }

        private void lnkPrev_Click(object sender, EventArgs e)
        {
            if (owner.CurrentPage > 0)
            {
                owner.CurrentPage--;
                owner.Rebind();
            }
        }

        private void lnkLast_Click(object sender, EventArgs e)
        {
            if (owner.CurrentPage < PageCount - 1)
            {
                owner.CurrentPage = PageCount - 1;
                owner.Rebind();
            }
        }

        private void lnkFirst_Click(object sender, EventArgs e)
        {
            if (owner.CurrentPage > 0)
            {
                owner.CurrentPage = 0;
                owner.Rebind();
            }
        }
        private void lnkNext_Click(object sender, EventArgs e)
        {
            if (owner.CurrentPage < PageCount - 1)
            {
                owner.CurrentPage++;
                owner.Rebind();
            }
        }

        private void lnkPageNo_Click(object sender, EventArgs e)
        {
            int NewPage = Convert.ToInt32((sender as LinkButton).Text);
            owner.CurrentPage = NewPage - 1;
            owner.Rebind();
        }

        private void SetLblItems()
        {
            lblItems.CssClass = "IndGridPagerLabel";
            lblItems.Text = RowCount.ToString() + " item(s)";
        }
    }
}
