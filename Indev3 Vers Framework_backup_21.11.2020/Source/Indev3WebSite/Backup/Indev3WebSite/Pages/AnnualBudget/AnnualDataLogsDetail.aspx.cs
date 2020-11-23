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
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Upload;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Telerik.WebControls;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.AnnualBudget;
using System.Collections.Generic;
using System.IO;

public partial class Pages_AnnualBudget_AnnualDataLogsDetail : IndPopUpBasePage
{
    #region Constants
    private const string DS_LOGS = "DsLogs";
    #endregion Constants
    #region Properties
    /// <summary>
    /// The connection manger that will be used
    /// </summary>
    private object CurrentConnectionManager = null;
   
    private int idImport;
    private int IdImport
    {
        get
        {
            try
            {
                return int.Parse(this.Request.QueryString["IdImport"].ToString());
            }
            catch (IndException ex)
            {
                ShowError(ex);
                return ApplicationConstants.INT_NULL_VALUE;
            }
            catch (Exception ex)
            {
                ShowError(new IndException(ex));
                return ApplicationConstants.INT_NULL_VALUE;
            }
        }
        set { idImport = value; }
    }
    
    private bool _CreateNewImportFileButtonEnable = true;
    protected bool CreateNewImportFileButtonEnable
    {
        get
        {
            if (this.Request.QueryString["Validation"] != null)
                return this.Request.QueryString["Validation"].ToString() == "O";
            else
                return _CreateNewImportFileButtonEnable;
        }

    }


    /// <summary>
    /// Shows whether the save (when pressing Update all button was successful)
    /// </summary>
    private bool SaveSuccessful = true;

    private DataSet DsLogs
    {
        get
        {
            return (DataSet)SessionManager.GetSessionValueNoRedirect(this, DS_LOGS);
        }
        set
        {
            SessionManager.SetSessionValue(this, DS_LOGS, value);
        }
    }
    #endregion Properties

    #region Event Handlers
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //Verify that the import parameter exits
            if (String.IsNullOrEmpty(this.Request.QueryString["IdImport"].ToString()))
                throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_COULD_NOT_GET_PARAMETER, "IdImport"));
            //Get the Import Id parameter
            idImport = int.Parse(this.Request.QueryString["IdImport"].ToString());

            if (!IsPostBack)
                DsLogs = null;

            //Loads the data       
            LoadEditableGrid();
            LoadHeader();
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

    protected override void OnInit(EventArgs e)
    {
        try
        {
            base.OnInit(e);

            CurrentConnectionManager = SessionManager.GetConnectionManager(this);
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

            //Reload the data only if the save was successful
            if (SaveSuccessful)
            {
                foreach (GridDataItem gridItem in grdImportDetails.MasterTableView.Items)
                {
                    if (gridItem is GridEditableItem)
                    {
                        GridEditableItem item = gridItem as GridEditableItem;
                        item.Edit = true;
                    }
                }

                grdImportDetails.Rebind();
            }

            foreach (GridDataItem gridItem in grdImportDetails.MasterTableView.Items)
            {
                if (gridItem is GridEditableItem)
                {
                    GridEditableItem item = gridItem as GridEditableItem;

                    foreach (GridColumn col in grdImportDetails.Columns)
                    {
                        if (col is GridBoundColumn)
                        {
                            if (col.Display == false)
                            {
                                col.HeaderStyle.CssClass = "GridElements_IndGenericGrid_Hide";
                                col.ItemStyle.CssClass = "GridElements_IndGenericGrid_Hide";
                                continue;
                            }

                            GridBoundColumn boundCol = col as GridBoundColumn;

                            if (item[boundCol.UniqueName].Controls.Count == 0)
                                continue;

                            TextBox txtEdit = item[boundCol.UniqueName].Controls[0] as TextBox;

                            if (txtEdit == null)
                                continue;

                            txtEdit.Width = Unit.Pixel((int)boundCol.ItemStyle.Width.Value - 5);
                            if (boundCol.UniqueName == "Quantity")
                            {
                                txtEdit.Attributes.Add("onKeyPress", "return RestrictKeys(event,'1234567890',\"" + txtEdit.ClientID + "\")");
                            }
                            if (boundCol.UniqueName == "Value")
                            {
                                txtEdit.Attributes.Add("onKeyPress", "return RestrictKeys(event,'1234567890-',\"" + txtEdit.ClientID + "\")");
                            } 
                        }
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
   
    protected void grdErrors_NeedDataSource(object source, Telerik.WebControls.GridNeedDataSourceEventArgs e)
    {
        try
        {
           
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

    protected void grdImportDetails_ItemCommand(object source, Telerik.WebControls.GridCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "UpdateAll")
            {
                //First store modifications made in this page to the dataset
                StoreValuesToDataSet();

                List<AnnualImportDetails> imList = new List<AnnualImportDetails>();

                foreach (DataRow row in DsLogs.Tables[0].Rows)
                {
                    AnnualImportDetails importDetails = new AnnualImportDetails(CurrentConnectionManager);
                    importDetails.IdImport = (int)row["IdImport"];
                    importDetails.IdRow = (int)row["IdRow"];
                    importDetails.CostCenter = (row["CostCenter"] == DBNull.Value) ? string.Empty : row["CostCenter"].ToString();
                    importDetails.ProjectCode = (row["ProjectCode"] == DBNull.Value) ? string.Empty : row["ProjectCode"].ToString();
                    importDetails.WPCode = (row["WPCode"] == DBNull.Value) ? string.Empty : row["WPCode"].ToString();
                    importDetails.AccountNumber = (row["AccountNumber"] == DBNull.Value) ? string.Empty : row["AccountNumber"].ToString();
                    if (row["Quantity"] != DBNull.Value)
                        importDetails.Quantity = (decimal)row["Quantity"];
                    if (row["Value"] != DBNull.Value)
                        importDetails.Value = (decimal)row["Value"];
                    if (row["CurrencyCode"] != DBNull.Value)
                        importDetails.CurrencyCode = row["CurrencyCode"].ToString();
                    if (row["Date"] != DBNull.Value)
                        importDetails.ImportDate = (DateTime)row["Date"];
                    imList.Add(importDetails);
                }

                if (imList.Count > 0)
                {
                    AnnualImportDetails annualImportDetails = new AnnualImportDetails(CurrentConnectionManager);
                    DataSet dsNewCreatedFile = annualImportDetails.UpdateBatchImportDetails(imList);

                    //After saving, remove the previous information from the session so that the old data (from the annual logs)
                    //is loaded from the db
                    DsLogs = null;
                    LoadEditableGrid();

                    CreateNewFile(dsNewCreatedFile);
                }

                if (!Page.ClientScript.IsClientScriptBlockRegistered(this.Page.GetType(), "ButtonUpdateClick"))
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.Page.GetType(), "ButtonUpdateClick", "window.returnValue = 1; window.close();", true);
                }
            }
            //When changing the page, we need to store any possible modifications made to the current page in the underlying datasource of the
            //grid
            if (e.CommandName == "Page")
            {
                StoreValuesToDataSet();
            }
        }
        catch (IndException indExc)
        {
            SaveSuccessful = false;
            ShowError(indExc);
        }
        catch (Exception exc)
        {
            SaveSuccessful = false;
            ShowError(new IndException(exc));
        }
        finally
        {
            if (!ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ResizePopUp"))
            {
                ClientScript.RegisterClientScriptBlock(this.GetType(), "ResizePopUp", "SetPopUpHeight();", true);
            }
        }
    }

    protected void grdImportDetails_ItemCreated(object sender, GridItemEventArgs e)
    {
        try
        {
            if (e.Item is GridPagerItem)
            {
                Label lblChangePageSize = (Label)e.Item.FindControl("ChangePageSizeLabel");
                TextBox txtChangePageSize = (TextBox)e.Item.FindControl("ChangePageSizeTextBox");
                LinkButton lnkChangePageSize = (LinkButton)e.Item.FindControl("ChangePageSizeLinkButton");
                LinkButton lnkGoToPage = (LinkButton)e.Item.FindControl("GoToPageLinkButton");
                TextBox txtChangePage = (TextBox)e.Item.FindControl("GoToPageTextBox");
                //OnKeyDown is used to catch the Enter key and to change the page; OnKeyPress is used for key validation.
                //The reason of using 2 events is to take control on GridPagerItem native events 
                //and to manage both azerty and qwerty keyboards.
                txtChangePage.Attributes.Add("OnKeyDown", "ChangePageRadGrid('" + lnkGoToPage.ClientID + "', event)");
                txtChangePage.Attributes.Add("OnKeyPress", "return RestrictKeys(event,'1234567890','" + txtChangePage.ClientID + "')");

                if (lblChangePageSize != null)
                    lblChangePageSize.Visible = false;

                if (txtChangePageSize != null)
                    txtChangePageSize.Visible = false;

                if (lnkChangePageSize != null)
                    lnkChangePageSize.Visible = false;
            }
        }
        catch (IndException indExc)
        {
            this.ShowError(indExc);
        }
        catch (Exception exc)
        {
            this.ShowError(new IndException(exc));
        }
    }
    #endregion Event Handlers

    #region Private Methods
    /// <summary>
    /// Loads the data
    /// </summary>
    private void LoadEditableGrid()
    {
        if (DsLogs == null)
        {
            AnnualImportDetails impDetails = new AnnualImportDetails(CurrentConnectionManager);
            DsLogs = impDetails.AnnualSelectImportDetailsWithErrors(IdImport, Request.ApplicationPath);
            grdImportDetails.DataSource = DsLogs;
        }
        else
        {
            grdImportDetails.DataSource = DsLogs;
        }
        DsLogs.Tables[0].PrimaryKey = new DataColumn[] { DsLogs.Tables[0].Columns["IdRow"] };
    }

    /// <summary>
    /// Populates the controls from header
    /// </summary>
    private void LoadHeader()
    {
        AnnualImportDetails impDetails = new AnnualImportDetails(CurrentConnectionManager);
        impDetails.IdImport = IdImport;
        DataSet dsHeader = impDetails.SelectHeaderInformation();
        if (dsHeader.Tables.Count != 3)
        {
            this.ShowError(new IndException(ApplicationMessages.EXCEPTION_DATA_SET_CORRUPTED));
            return;
        }
        DataRow sourceRow = dsHeader.Tables[0].Rows[0];

        //Populate the controls
        txtCountry.Text = sourceRow["Country"].ToString();
        txtFileName.Text = sourceRow["FileName"].ToString();
        txtDate.Text = ((DateTime)sourceRow["Date"]).ToShortDateString();
        txtUserName.Text = sourceRow["UserName"].ToString();
        string TotalNoOfRows = sourceRow["Lines"].ToString();
        txtLines.Text = TotalNoOfRows;
       

        DataRow sourceRow1 = dsHeader.Tables[1].Rows[0];
        string NoOfErrors = sourceRow1["NoOfErrors"].ToString();
        txtNoOfErrors.Text = NoOfErrors;

        DataRow sourceRow2 = dsHeader.Tables[2].Rows[0];
        string NoOfRowsOK = sourceRow2["NoOfRowsOk"].ToString();
        txtNoOfRowsOK.Text = NoOfRowsOK;
        int NoOfRowsIgnored = int.Parse(TotalNoOfRows) - int.Parse(NoOfRowsOK);
        txtNoOfRowsIgnored.Text = NoOfRowsIgnored.ToString();

        txtPeriod.Text = sourceRow["Period"].ToString();
    }
    private void CreateNewFile(DataSet dsNewFile)
    {
        AnnualImports imp = new AnnualImports(CurrentConnectionManager);
        imp.IdImport = IdImport;
        DataSet ds = imp.GetAll(true);
        if (ds == null)
            return;

        if (ds.Tables.Count == 0)
            return;

        //if file name is bigger than 4 -- (.extension)
        if (ds.Tables[0].Rows[0]["FileName"].ToString().Length <= 4)
            return;

        string dirUrlProcessed = ConfigurationManager.AppSettings["UploadFolderAnnual"];//@"UploadDirectoriesAnnual\InProcess";
        string dirPathProcessed = Server.MapPath(@"..\..\" + dirUrlProcessed);
        string fileName = ds.Tables[0].Rows[0]["FileName"].ToString().Substring(0, ds.Tables[0].Rows[0]["FileName"].ToString().Length - 4);
        string PathToFile = dirPathProcessed + @"\" + fileName + "_" + DateTime.Now.Year + "_" + DateTime.Now.Month + "_" + DateTime.Now.Day + ".csv";

        string[] filesArr = Directory.GetFiles(dirPathProcessed);
        for (int i = 0; i <= filesArr.Length - 1; i++)
        {

            if (Path.GetExtension(filesArr[i].ToString()) != ".csv")
                continue;
            if (filesArr[i].ToString().Contains(fileName))
                File.Delete(filesArr[i].ToString());
        }

        WriteToFile(PathToFile, dsNewFile);
        if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonUpdateScript"))
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonUpdateScript", "alert('Modifications have been saved! You can retry to process file.');", true);
        }
    }

    private int WriteToFile(string file, DataSet ds)
    {
        int nRowsWritten = 0;

        ArrayList columnsToSkip = new ArrayList();
        columnsToSkip.Add("IdImport");
        columnsToSkip.Add("IdRow");

        nRowsWritten = DSUtils.WriteDataTableToCSVFile(ds.Tables[0], columnsToSkip, file, false);

        return nRowsWritten;

    }
    private void StoreValuesToDataSet()
    {
        if (DsLogs == null)
        {
            AnnualImportDetails impDetails = new AnnualImportDetails(CurrentConnectionManager);
            DsLogs = impDetails.SelectImportDetails(IdImport);
            DsLogs.Tables[0].PrimaryKey = new DataColumn[] { DsLogs.Tables[0].Columns["IdRow"] };
        }
        Hashtable newValues = new Hashtable();
        foreach (GridDataItem item in grdImportDetails.Items)
        {
            if (item.IsInEditMode)
            {
                item.ExtractValues(newValues);
                DataRow row = DsLogs.Tables[0].Rows.Find(item["Row Number"].Text);

                row["CostCenter"] = DSUtils.GetValueToInsertInDataSet(newValues["CostCenter"]);
                row["ProjectCode"] = DSUtils.GetValueToInsertInDataSet(newValues["ProjectCode"]);
                row["WPCode"] = DSUtils.GetValueToInsertInDataSet(newValues["WPCode"]);
                row["AccountNumber"] = DSUtils.GetValueToInsertInDataSet(newValues["AccountNumber"]);
                row["Quantity"] = DSUtils.GetValueToInsertInDataSet(newValues["Quantity"]);
                row["Value"] = DSUtils.GetValueToInsertInDataSet(newValues["Value"]);
                row["CurrencyCode"] = DSUtils.GetValueToInsertInDataSet(newValues["CurrencyCode"]);
                DateTime date;
                if (newValues["Date"] != null && DateTime.TryParse(newValues["Date"].ToString(), out date))
                    row["Date"] = newValues["Date"];
            }
        }
    }
    #endregion Private Methods

}
