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
using System.IO;
using System.Collections.Generic;

public partial class Pages_Upload_DataLogsDetail : IndPopUpBasePage
{
    #region Constants
    private const string DS_LOGS = "DsLogs";
    private const string SELECTED_ITEMS = "SelectedLogItems";
    #endregion Constants

    #region Properties
    /// <summary>
    /// The connection manger that will be used
    /// </summary>
    private object CurrentConnectionManager = null;
    /// <summary>
    /// The grid data source
    /// </summary>   

    private int idImport = ApplicationConstants.INT_NULL_VALUE;
    private int IdImport
    {
        get
        {
            try
            {
                if (this.Request.QueryString["IdImport"] != null)
                    return int.Parse(this.Request.QueryString["IdImport"].ToString());
                else
                    return idImport;
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
    private int idSource = ApplicationConstants.INT_NULL_VALUE;
    public int IdSource
    {
        get
        {
            return idSource;
        }
        set { idSource = value; }
    }
    bool errorGridLoadSuccesfull = true;
    private bool ErrorGridLoadSuccesfull
    {
        get { return errorGridLoadSuccesfull; }
        set { errorGridLoadSuccesfull = value; }
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

    private bool _UserCanDelete = true;
    protected bool UserCanDelete
    {
        get 
        {
            return _UserCanDelete;
        }
    }
    #endregion Properties

    #region Event Handlers
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {                          
            if (IdImport == ApplicationConstants.INT_NULL_VALUE)
            {
                throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_COULD_NOT_GET_PARAMETER, "IdImport"));
            }
            else
            {
                //The first time the page loads, remove the information from DsLogs (session) such that data from a previous log is not shown
                //instead of correct data
                if (!IsPostBack)
                    DsLogs = null;

                //Loads the data       
                LoadEditableGrid();
                LoadHeader();
               
                CurrentUser usr = SessionManager.GetCurrentUser(this);

                //Get the moduleCode from the parent Ascx
                string moduleCode = ApplicationConstants.MODULE_DATA_LOGS;

                _UserCanDelete = usr.GetPermission(moduleCode, Operations.ManageLogs) == Permissions.All;                
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
                            if (boundCol.UniqueName == "UnitQty")
                            {
                                txtEdit.Attributes.Add("onKeyPress", "return RestrictKeys(event,'1234567890',\"" + txtEdit.ClientID + "\")");
                            }
                            if (boundCol.UniqueName == "Year")
                            {
                                txtEdit.Attributes.Add("onKeyPress", "return RestrictKeys(event,'1234567890',\"" + txtEdit.ClientID + "\")");
                            }
                            if (boundCol.UniqueName == "Month")
                            {
                                txtEdit.Attributes.Add("onKeyPress", "return RestrictKeys(event,'1234567890',\"" + txtEdit.ClientID + "\")");
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

    protected void grdImportDetails_ItemCommand(object source, Telerik.WebControls.GridCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "UpdateAll")
            {
                List<ImportDetails> imList = new List<ImportDetails>();
                //First store modifications made in this page to the dataset
                StoreValuesToDataSet();

                //populate list for modified or deleted rows
                PopulateImportDetailsList(imList);

                //send modifications to the DB image of the import
               ImportDetails importDetails = new ImportDetails(CurrentConnectionManager);
               DataSet dsNewCreatedFile = importDetails.UpdateBatchImportDetails(imList, IdImport);

                //create new file with current state of import
                bool result = CreateNewFile(dsNewCreatedFile);

                if (result)
                {
                    if (!Page.ClientScript.IsClientScriptBlockRegistered(this.Page.GetType(), "ButtonUpdateClick"))
                    {
                        Page.ClientScript.RegisterClientScriptBlock(this.Page.GetType(), "ButtonUpdateClick", "window.returnValue = 1; window.close();", true);
                    }
                }
                else
                {
                    //After saving, if something went wrong re-load the grid
                    DsLogs = null;
                    LoadEditableGrid();         
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
            else if (e.Item is GridCommandItem)
            {
                Inergy.Indev3.WebFramework.WebControls.IndImageButton btnDelete = (Inergy.Indev3.WebFramework.WebControls.IndImageButton)e.Item.FindControl("btnDelete");
                if (btnDelete != null && (!UserCanDelete || this.Request.QueryString["Validation"].ToString() == "OO")) //OO is the code for Cost Centers which haven't Hourly Rate. This is not a blocking error
                {
                    btnDelete.ImageUrl = "~/Images/buttons_delete_disabled.png";
                }
            }
        }
        catch (IndException indExc)
        {
            ShowError(indExc);
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        try
        {
            //store the changed values from grid to dataset
            StoreValuesToDataSet();
            
            GridTableView grdTableVw = grdImportDetails.MasterTableView;
            GridDataItemCollection itemCollection = grdTableVw.Items;
            foreach (GridItem gridItem in itemCollection)
            {
                if (!(gridItem is GridEditableItem))
                    continue;
                GridEditableItem item = gridItem as GridEditableItem;

                HtmlInputCheckBox chkSelected = item["DeleteCol"].FindControl("chkDeleteCol") as HtmlInputCheckBox;
                if (chkSelected == null)
                    continue;
                if (!chkSelected.Checked)
                    continue;
                int idRow = ApplicationConstants.INT_NULL_VALUE;
                if (int.TryParse(item["RowNumber"].Text, out idRow))
                {

                    DataRow[] dr = DsLogs.Tables[0].Select("IdImport=" + IdImport + " and IdRow=" + idRow);                    
                    dr[0].Delete();
                }

            }            
        }
        catch (Exception ex)
        {
            ShowError(new IndException(ex));
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
            ImportDetails impDetails = new ImportDetails(CurrentConnectionManager);
            DsLogs = impDetails.SelectImportDetailsWithErrors(IdImport,Request.ApplicationPath);
            
            //Accept changes so that all rows in the dataset have RowState Unchanged
            DsLogs.AcceptChanges();
            
            grdImportDetails.DataSource = DsLogs;
        }
        else
        {
            grdImportDetails.DataSource = DsLogs;
        }
        DsLogs.Tables[0].PrimaryKey = new DataColumn[] { DsLogs.Tables[0].Columns["IdRow"] };
    }

    private void LoadHeader()
    {
        ImportDetails impDetails = new ImportDetails(CurrentConnectionManager);
        impDetails.IdImport = IdImport;
        DataSet dsHeader = impDetails.SelectHeaderInformation();
        if (dsHeader.Tables.Count != 3)
        {
            throw new IndException(ApplicationMessages.EXCEPTION_DATA_SET_CORRUPTED);
        }
        DataRow sourceRow = dsHeader.Tables[0].Rows[0];

        txtCountry.Text = sourceRow["Country"].ToString();
        txtFileName.Text = sourceRow["FileName"].ToString();
        txtDate.Text = ((DateTime)sourceRow["Date"]).ToShortDateString();
        txtUserName.Text = sourceRow["UserName"].ToString();
        string TotalNoOfRows = sourceRow["Lines"].ToString();
        txtLines.Text = TotalNoOfRows;
        //set IDSource to be used in new file name
        IdSource = Int32.Parse(sourceRow["IdSource"].ToString());

        DataRow sourceRow1 = dsHeader.Tables[1].Rows[0];
        string NoOfErrors = sourceRow1["NoOfErrors"].ToString();
        txtNoOfErrors.Text = NoOfErrors;

        DataRow sourceRow2 = dsHeader.Tables[2].Rows[0];
        string NoOfRowsOK = sourceRow2["NoOfRowsOk"].ToString();
        txtNoOfRowsOK.Text = NoOfRowsOK;
        int NoOfRowsIgnored = int.Parse(TotalNoOfRows) - int.Parse(NoOfRowsOK);
        txtNoOfRowsIgnored.Text = NoOfRowsIgnored.ToString();

        YearMonth yearMonth = new YearMonth(sourceRow["Period"].ToString());

        if (yearMonth.Value == ApplicationConstants.YEAR_MONTH_SQL_MIN_VALUE)
        {
            txtPeriod.Text = ApplicationConstants.NOT_AVAILABLE;
        }
        else
        {
            txtPeriod.Text = yearMonth.GetMonthRepresentation() + " - " + yearMonth.Year;
        }
    }


    private bool CreateNewFile(DataSet dsNewFile)
    {
        if (dsNewFile == null)
            throw new IndException("Data Set NULL");
        if (dsNewFile.Tables[0].Rows.Count == 0)
        {
            if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "CannotDelete"))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CannotDelete", "setTimeout(\"alert('The file could not be created because is empty!')\",100);", true);
            }
            return false;
        }
        //throw new IndException("There is no more room on the disc");       
        Imports imp = new Imports(CurrentConnectionManager);
        imp.IdImport = IdImport;
        DataSet ds = imp.GetAll(true);

        if (ds == null)
        {
            throw new IndException("DataSet null!");          
        }

        if (ds.Tables.Count == 0)
        {
           throw new IndException("No tables in dataset");
        }

        //if file name is bigger than 4 -- (.extension)
        if (ds.Tables[0].Rows[0]["FileName"].ToString().Length <= 4)
            return false;

        string dirUrlProcessed = ConfigurationManager.AppSettings["UploadFolder"];
        string dirPathProcessed = Server.MapPath("../../" + dirUrlProcessed);
        string fileName = ds.Tables[0].Rows[0]["FileName"].ToString().Substring(0, ds.Tables[0].Rows[0]["FileName"].ToString().Length - 4);
        string PathToFile = dirPathProcessed + @"\" + fileName + "_" + IdSource.ToString() + "_" + DateTime.Now.Year + "_" + DateTime.Now.Month + "_" + DateTime.Now.Day + ".csv";

        string[] filesArr = Directory.GetFiles(dirPathProcessed);
        for (int i = 0; i <= filesArr.Length - 1; i++)
        {
            if (Path.GetExtension(filesArr[i].ToString()).ToLower() != ".csv")
                continue;
            if (filesArr[i].ToString().Contains(fileName))
                File.Delete(filesArr[i].ToString());
        }
        WriteToFile(PathToFile, dsNewFile);
        if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonUpdateScript"))
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonUpdateScript", "alert('Modifications have been saved! You can retry to process file.');", true);
        }
        return true;
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
            ImportDetails impDetails = new ImportDetails(CurrentConnectionManager);
            DsLogs = impDetails.SelectImportDetailsWithErrors(IdImport, Request.ApplicationPath);
            DsLogs.Tables[0].PrimaryKey = new DataColumn[] { DsLogs.Tables[0].Columns["IdRow"] };
        }
        Hashtable newValues = new Hashtable();       
        foreach (GridDataItem item in grdImportDetails.Items)
        {
            if (item.IsInEditMode)
            {

                if (IsItemModified(item))
                {
                    item.ExtractValues(newValues);
                    DataRow row = DsLogs.Tables[0].Rows.Find(item["RowNumber"].Text);

                    if (row.RowState != DataRowState.Deleted)
                    {
                        row["CostCenter"] = DSUtils.GetValueToInsertInDataSet(newValues["CostCenter"]);
                        row["ProjectCode"] = DSUtils.GetValueToInsertInDataSet(newValues["ProjectCode"]);
                        row["WPCode"] = DSUtils.GetValueToInsertInDataSet(newValues["WPCode"]);
                        row["AccountNumber"] = DSUtils.GetValueToInsertInDataSet(newValues["AccountNumber"]);
                        row["AssociateNumber"] = DSUtils.GetValueToInsertInDataSet(newValues["AssociateNumber"]);
                        row["Quantity"] = DSUtils.GetValueToInsertInDataSet(newValues["Quantity"]);
                        row["UnitQty"] = DSUtils.GetValueToInsertInDataSet(newValues["UnitQty"]);
                        row["Value"] = DSUtils.GetValueToInsertInDataSet(newValues["Value"]);
                        row["CurrencyCode"] = DSUtils.GetValueToInsertInDataSet(newValues["CurrencyCode"]);
                    }
                }
            }
        }
    }

    /// <summary>
    /// Returns true if the data in this item was modified by the user since the last postback, false otherwise
    /// </summary>
    /// <param name="item"></param>
    /// <returns></returns>
    private bool IsItemModified(GridDataItem item)
    {
        //Get the new values hashtable
        Hashtable newValues = new Hashtable();
        item.ExtractValues(newValues);

        //Get the saved old values hashtable
        Hashtable savedOldValues = (Hashtable)item.SavedOldValues;

        foreach (string key in newValues.Keys)
        {
            //Null case treated here
            if (newValues[key] == null && savedOldValues[key] == null)
                continue;

            if ((newValues[key] == null && savedOldValues[key] != null) ||
                (newValues[key] != null && savedOldValues[key] == null))
                return true;

            if (newValues[key].ToString() != savedOldValues[key].ToString())
                return true;
        }
        return false;
    }

    private void PopulateImportDetailsList(List<ImportDetails> imList)
    {

        DataView dw = DsLogs.Tables[0].DefaultView;
        dw.RowStateFilter = DataViewRowState.Deleted | DataViewRowState.ModifiedCurrent;

        //Traverse the unserlying datasource because the grid contains in its items collection only the items from the current page
        foreach (DataRowView row in dw)
        {
            ImportDetails importDetails = new ImportDetails(CurrentConnectionManager);

            switch (row.Row.RowState)
            {
                case DataRowState.Modified:
                    importDetails.IdImport = (int)row.Row["IdImport"];
                    importDetails.IdRow = (int)row.Row["IdRow"];
                    importDetails.CostCenter = (row.Row["CostCenter"] == DBNull.Value) ? string.Empty : row.Row["CostCenter"].ToString();
                    importDetails.ProjectCode = (row.Row["ProjectCode"] == DBNull.Value) ? string.Empty : row.Row["ProjectCode"].ToString();
                    importDetails.WPCode = (row.Row["WPCode"] == DBNull.Value) ? string.Empty : row.Row["WPCode"].ToString();
                    importDetails.AccountNumber = (row.Row["AccountNumber"] == DBNull.Value) ? string.Empty : row.Row["AccountNumber"].ToString();
                    importDetails.AssociateNumber = (row.Row["AssociateNumber"] == DBNull.Value) ? string.Empty : row.Row["AssociateNumber"].ToString();
                    importDetails.Quantity = (row.Row["Quantity"] == DBNull.Value) ? ApplicationConstants.DECIMAL_NULL_VALUE : (decimal)row.Row["Quantity"];
                    importDetails.Value = (row.Row["Value"] == DBNull.Value) ? ApplicationConstants.DECIMAL_NULL_VALUE : (decimal)row.Row["Value"];
                    importDetails.CurrencyCode = (row.Row["CurrencyCode"] == DBNull.Value) ? string.Empty : row.Row["CurrencyCode"].ToString();
                    importDetails.SetModified();
                    imList.Add(importDetails);
                    break;
                case DataRowState.Deleted:
                    importDetails.IdImport = IdImport;
                    importDetails.IdRow = (int)row.Row["IdRow", DataRowVersion.Original];
                    importDetails.SetDeleted();
                    imList.Add(importDetails);
                    break;
                default:
                    ShowError(new IndException("Unexpected row state"));
                    break;
            }
        }
    }
    #endregion Private Methods

}
