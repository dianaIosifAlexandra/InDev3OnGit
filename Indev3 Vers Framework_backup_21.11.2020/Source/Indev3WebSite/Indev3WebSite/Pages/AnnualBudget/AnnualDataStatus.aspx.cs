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
using Inergy.Indev3.BusinessLogic.AnnualBudget;
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;
using Inergy.Indev3.BusinessLogic.Upload;
using Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.DataAccess.AnnualBudget;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework;

public partial class Pages_AnnualBudget_AnnualDataStatus : IndBasePage
{
    #region Members
    CurrentUser currentUser = null;
    #endregion

    #region Properties
    /// <summary>
    /// The connection manger used by this page
    /// </summary>
    private object ConnectionManager = null;
    /// <summary>
    /// The grid data source
    /// </summary>
    private DataSet SourceDS;
    #endregion Properties

    protected void Page_Init(object sender, EventArgs e)
    {
        try
        {
            currentUser = SessionManager.GetCurrentUser(this);
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
            base.OnPreRender(e);
            pnlDataStatus.Attributes.Add("style", "Height: auto;");
            if (currentUser.UserRole.Id != ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR)
            {
                grdDataStatus.Columns[grdDataStatus.Columns.Count - 1].Visible = false;
            }

            if (IsPostBack)
			{
				int nrColumns = grdDataStatus.Columns.Count;
				for (int i = 1; i < nrColumns; i++)
				{
					grdDataStatus.Columns.RemoveAt(1);
				}
				grdDataStatus.Rebind();
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

    protected void grdDataStatus_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        try
        {
            if (ConnectionManager == null)
                ConnectionManager = SessionManager.GetConnectionManager(this);
            AnnualDataStatus dataStatus = new AnnualDataStatus(ConnectionManager);
            //Get the dataset
            SourceDS = dataStatus.GetAll(true);
            //Binds the grid


            foreach (DataColumn column in SourceDS.Tables[0].Columns)
            {
                if ((column.ColumnName == "IdCountry") || (column.ColumnName == "Country"))
                    continue;
                GridTemplateColumn templateColumn = new GridTemplateColumn();

                if (column.ColumnName == "IdImport")
                {
                    templateColumn.UniqueName = "RemoveLastUpload";
                    templateColumn.HeaderText = string.Empty;
                    DynamicTemplateField buttonTemplate = new DynamicTemplateField();
                    templateColumn.ItemTemplate = buttonTemplate;
                    templateColumn.ItemStyle.Width = Unit.Pixel(400);
                    templateColumn.ItemStyle.Height = Unit.Pixel(20);
                }
                else
                {
                    templateColumn.UniqueName = "colYear" + column.ColumnName;
                    templateColumn.ItemTemplate = new ImageYesNoTemplate(column.ColumnName);
                    templateColumn.HeaderText = column.ColumnName;
                    templateColumn.ItemStyle.Width = Unit.Pixel(50);
                    templateColumn.ItemStyle.Height = Unit.Pixel(20);
                }
                grdDataStatus.Columns.Add(templateColumn);
            }

            grdDataStatus.DataSource = SourceDS;
            grdDataStatus.DataMember = SourceDS.Tables[0].TableName;
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



    public class DynamicTemplateField : ITemplate
    {

        public void InstantiateIn(Control container)
        {
            //define the control to be added , i take text box as your need
            //<asp:LinkButton runat="server" ID="lnkRemoveLastUpload"  OnClick="lnkRemoveLastUpload_Click" OnClientClick="if (!confirm('Are you sure you want to remove this upload?')) {return false;} else {return true;}"/> 
            LinkButton lnkb = new LinkButton();
            lnkb.ID = "lnkRemoveLastUpload";
            lnkb.DataBinding += new EventHandler(lnkb_DataBinding);
            //lnkb.Click += new EventHandler(((Pages_AnnualBudget_AnnualDataStatus)container.Page).lnkRemoveLastUpload_Click);

            //AddHandler link.Click, AddressOf LinkButtonTest_Click
            container.Controls.Add(lnkb);
        }

        private void lnkb_DataBinding(object sender, EventArgs e)
        {
            LinkButton lnkb = (LinkButton)sender;
            if (lnkb != null)
            {
                GridDataItem container = (GridDataItem)lnkb.NamingContainer;
                if (!(((DataRowView)container.DataItem)["IdImport"] is Int32))
                    return;
                int idImport = (int)((DataRowView)container.DataItem)["IdImport"];
                //find the year for which is the export. Start with before last column. Last column is IdImport
                DataColumnCollection columns = ((DataRowView)container.DataItem).DataView.Table.Columns;
                int year = 0;
                for (int col = columns.Count - 1; col > 1; col--)
                {
                    if (((DataRowView)container.DataItem)[col] is bool && (bool)((DataRowView)container.DataItem)[col] == true)
                    {
                        year = int.Parse(columns[col].ColumnName);
                        break;
                    }
                }

                lnkb.Text = string.Format("Remove last upload ({0})", year);
                lnkb.CommandArgument = string.Format("{0},{1}", year, idImport);
                lnkb.OnClientClick = "if (!confirm('Are you sure you want to remove this upload?')) {SetHiddenField(false, ''); return false;} else {SetHiddenField(true,'" + lnkb.CommandArgument + "'); return true;}";
            }
        }

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (currentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR)
            {
                //check if RemoveAnnualBudget button has been hit
                if (!string.IsNullOrEmpty(hdnRemoveAnnualBudget.Value))
                {
                    string[] pars = hdnRemoveAnnualBudget.Value.Split(",".ToCharArray());
                    if (pars.Length == 2)
                    {
                        int year = int.Parse(pars[0]);
                        int idImport = int.Parse(pars[1]);
                        ConnectionManager = SessionManager.GetConnectionManager(this);
                        DBAnnualImports dbImport = new DBAnnualImports(ConnectionManager);
                        AnnualImports import = new AnnualImports(ConnectionManager);
                        import.IdImport = idImport;
                        object rez = dbImport.ExecuteScalar("impRemoveAnnualImport", import);
                    }
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
}

