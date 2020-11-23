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

public partial class Pages_AnnualBudget_AnnualDataStatus : IndBasePage
{
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

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            base.OnPreRender(e);
            pnlDataStatus.Attributes.Add("style", "Height: auto;");

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
                templateColumn.UniqueName = "colYear" + column.ColumnName;
                templateColumn.ItemTemplate = new ImageYesNoTemplate(column.ColumnName);
                templateColumn.HeaderText = column.ColumnName;
                templateColumn.ItemStyle.Width = Unit.Pixel(50);
                templateColumn.ItemStyle.Height = Unit.Pixel(20);
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
}
