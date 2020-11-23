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
using Inergy.Indev3.BusinessLogic.Upload;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;

public partial class Pages_Upload_DataStatus : IndBasePage
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

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                LoadYearCombo();

                //Loads the data for the screen
                LoadDataStatus();
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

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            base.OnPreRender(e);
            pnlDataStatus.Attributes.Add("style", "Height: auto;");

            for (int i = 0; i < grdDataStatus.MasterTableView.Items.Count; i++)
                if (grdDataStatus.MasterTableView.Items[i] is GridDataItem)
                {
                    //Get the image based on the columns values
                    GridDataItem item = grdDataStatus.MasterTableView.Items[i] as GridDataItem;
                    SetItemImageValues(item["January"] as GridTableCell);
                    SetItemImageValues(item["February"] as GridTableCell);
                    SetItemImageValues(item["March"] as GridTableCell);
                    SetItemImageValues(item["April"] as GridTableCell);
                    SetItemImageValues(item["May"] as GridTableCell);
                    SetItemImageValues(item["June"] as GridTableCell);
                    SetItemImageValues(item["July"] as GridTableCell);
                    SetItemImageValues(item["August"] as GridTableCell);
                    SetItemImageValues(item["October"] as GridTableCell);
                    SetItemImageValues(item["November"] as GridTableCell);
                    SetItemImageValues(item["September"] as GridTableCell);
                    SetItemImageValues(item["December"] as GridTableCell);
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

    protected void cmbYear_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            
            //Reload the grid
            LoadDataStatus();
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

    private void LoadYearCombo()
    {
        //Set the combo data source
        cmbYear.DataSource = PeriodUtils.GetYears();
        cmbYear.DataBind();
        cmbYear.SelectedIndex = cmbYear.Items.Count - 1 - ApplicationConstants.YEAR_AHEAD_TO_INCLUDE   ; /*select curent year*/
    }

    /// <summary>
    /// Geths the datasource for the grid and binds it
    /// </summary>
    private void LoadDataStatus()
    {
        //Get the connection manger
        ConnectionManager = SessionManager.GetConnectionManager(this);

        DataStatus dataStatus = new DataStatus(ConnectionManager);
        //Use the year selected in the combo
        dataStatus.Year = int.Parse(cmbYear.Items[cmbYear.SelectedIndex].Text);
        //Get the dataset
        SourceDS = dataStatus.GetAll(true);
        //Binds the grid
        grdDataStatus.DataSource = SourceDS;
        grdDataStatus.DataMember = SourceDS.Tables[0].TableName;
        grdDataStatus.Rebind();
    }

    /// <summary>
    /// Get the images for a cell
    /// </summary>
    /// <param name="cell">The given cell</param>
    private void SetItemImageValues(GridTableCell cell)
    {
        Image imgControl = cell.Controls[1] as Image;
        if (!String.IsNullOrEmpty(imgControl.DescriptionUrl))
        {
            //Get the cell value from the DescriptionUrl property
            bool cellValue = (imgControl.DescriptionUrl == "0") ? false : true;
            //Get the image path
            string imgUrl = "~/Images/";
            if (cellValue)
                imgUrl += "PastilleGreen.gif";
            else
                imgUrl += "PastilleRed.gif";

            if (imgControl == null)
                return;
            //Set the image
            imgControl.ImageUrl = imgUrl;
        }
    }
}
