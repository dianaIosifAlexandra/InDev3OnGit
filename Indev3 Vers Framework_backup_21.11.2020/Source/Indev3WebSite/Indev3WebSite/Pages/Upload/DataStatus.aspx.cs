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
using Inergy.Indev3.DataAccess.Upload;
using Inergy.Indev3.BusinessLogic.Authorization;

public partial class Pages_Upload_DataStatus : IndBasePage
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
            string lastUploadMonthS = string.Empty;
            int lastUploadMonth = 0;
            if (currentUser.UserRole.Id != ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR)
            {
                grdDataStatus.Columns[grdDataStatus.Columns.Count - 1].Visible =false ;
            }


            for (int i = 0; i < grdDataStatus.MasterTableView.Items.Count; i++)
                if (grdDataStatus.MasterTableView.Items[i] is GridDataItem)
                {
                    lastUploadMonthS = string.Empty;
                    lastUploadMonth = 0;
                    //Get the image based on the columns values
                    GridDataItem item = grdDataStatus.MasterTableView.Items[i] as GridDataItem;
                    SetItemImageValues(item["January"] as GridTableCell, 1, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["February"] as GridTableCell, 2, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["March"] as GridTableCell, 3, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["April"] as GridTableCell, 4, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["May"] as GridTableCell, 5, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["June"] as GridTableCell, 6, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["July"] as GridTableCell, 7, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["August"] as GridTableCell, 8, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["September"] as GridTableCell, 9, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["October"] as GridTableCell, 10, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["November"] as GridTableCell, 11, ref lastUploadMonth, ref lastUploadMonthS);
                    SetItemImageValues(item["December"] as GridTableCell, 12, ref lastUploadMonth, ref lastUploadMonthS);
                    if (currentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR)
                    {
                        int year = int.Parse(cmbYear.Items[cmbYear.SelectedIndex].Text);
                        if (year >= 2019)//DateTime.Now.Year)
                        {
                            int idImport = int.Parse(((DataSet)grdDataStatus.DataSource).Tables[0].Rows[i]["IdImport"].ToString());
                            SetItemRemoveLastUpload(item["RemoveLastUpload"] as GridTableCell, year, lastUploadMonth, lastUploadMonthS, idImport);
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

    protected void cmbYear_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
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
    private void SetItemImageValues(GridTableCell cell, int currentMonth, ref int lastUploadedMonth, ref string lastUploadedMonthS)
    {
        Image imgControl = cell.Controls[1] as Image;
        if (!String.IsNullOrEmpty(imgControl.DescriptionUrl))
        {
            //Get the cell value from the DescriptionUrl property
            bool cellValue = (imgControl.DescriptionUrl == "0") ? false : true;
            //Get the image path
            string imgUrl = "~/Images/";
            if (cellValue)
            {
                imgUrl += "PastilleGreen.gif";
                lastUploadedMonth = currentMonth;
                switch (lastUploadedMonth)
                {
                    case 1:
                        lastUploadedMonthS = "Jan";
                        break;
                    case 2:
                        lastUploadedMonthS = "Feb";
                        break;
                    case 3:
                        lastUploadedMonthS = "Mar";
                        break;
                    case 4:
                        lastUploadedMonthS = "Apr";
                        break;
                    case 5:
                        lastUploadedMonthS = "May";
                        break;
                    case 6:
                        lastUploadedMonthS = "Jun";
                        break;
                    case 7:
                        lastUploadedMonthS = "Jul";
                        break;
                    case 8:
                        lastUploadedMonthS = "Aug";
                        break;
                    case 9:
                        lastUploadedMonthS = "Sep";
                        break;
                    case 10:
                        lastUploadedMonthS = "Oct";
                        break;
                    case 11:
                        lastUploadedMonthS = "Nov";
                        break;
                    case 12:
                        lastUploadedMonthS = "Dec";
                        break;
                }
            }
            else
                imgUrl += "PastilleRed.gif";

            if (imgControl == null)
                return;
            //Set the image
            imgControl.ImageUrl = imgUrl;
        }
    }

    private void SetItemRemoveLastUpload(GridTableCell cell, int year, int lastUploadedMonth, string lastUpoadedMonthS, int idImport)
    {
        if (lastUploadedMonth == 0) return;
        LinkButton linkControl = cell.Controls[1] as LinkButton;
        if (linkControl != null)
        {
            linkControl.Text = string.Format("Remove last upload ({0} {1})", lastUpoadedMonthS, year);
            linkControl.CommandArgument = string.Format("{0},{1},{2}", lastUploadedMonth, year, idImport);
        }

    }

    protected void lnkRemoveLastUpload_Click(Object sender, EventArgs e)
    {
        LinkButton source = sender as LinkButton;
        if (source != null)
        {
            try
            {

                string arg = source.CommandArgument;
                if (!string.IsNullOrEmpty(arg))
                {
                    string[] pars = arg.Split(",".ToCharArray());
                    if (pars.Length == 3)
                    {
                        int month = int.Parse(pars[0]);
                        int year = int.Parse(pars[1]);
                        int idImport = int.Parse(pars[2]);
                        ConnectionManager = SessionManager.GetConnectionManager(this);
                        DBImports dbImport = new DBImports(ConnectionManager);
                        Imports import = new Imports(ConnectionManager);
                        import.IdImport = idImport;
                        object rez = dbImport.ExecuteScalar("impRemoveActualImport", import);
                        LoadDataStatus();
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

}


