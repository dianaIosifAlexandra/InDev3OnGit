using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.AnnualBudget;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.Entities;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls;
using Telerik.WebControls;

public partial class UserControls_AnnualBudget_DataLogs : GenericUserControl
{
    #region Properties
    private object CurrentConnectionManager = null;  
    #endregion Properties

    #region Events Handlers
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //Set the view and edit control for DataLogs in session
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL, ApplicationConstants.MODULE_ANNUAL_LOGS);
            SessionManager.SetSessionValue((IndBasePage)this.Page, SessionStrings.EDIT_CONTROL, ApplicationConstants.MODULE_ANNUAL_LOGS);            

            //Set grid properties
            grdLogs.EntityType = typeof(AnnualDataLogs);
            grdLogs.UseAutomaticEntityBinding = true;
            grdLogs.DataSourcePersistenceMode = GridDataSourcePersistenceMode.NoPersistence;
        }
        catch (IndException ex)
        {
            ReportControlError(ex);
            return;
        }
    }

    protected override void OnInit(EventArgs e)
    {
        try
        {
            base.OnInit(e);

            //Get the connection manger from the session
            CurrentConnectionManager = SessionManager.GetConnectionManager(this.Page);            

            //Initiaize grid events
            grdLogs.PreRender += new EventHandler(grdLogs_PreRender);
           
        }
        catch (IndException ex)
        {
            ReportControlError(ex);
            return;
        }
        catch (Exception ex)
        {
            ReportControlError(new IndException(ex));
            return;
        }
    }

    private void AddTrafficLightColumnToGrid()
    {
        //Add the comun containing pictures with the traffic light
        IndGridTemplateColumn col = new IndGridTemplateColumn();
        col.UniqueName = "colValidation";
        col.ItemTemplate = new ImageTemplate("Validation");
        col.HeaderText = "";

        //insert it instead of the original Validation column
        GridColumn validationColumn = grdLogs.MasterTableView.GetColumn("Validation");
        int pos = grdLogs.Columns.IndexOf(validationColumn);
        grdLogs.Columns.Insert(pos, col);
        grdLogs.Rebind();
    }

    private void grdLogs_PreRender(object sender, EventArgs e)
    {
        try
        {
            AddTrafficLightColumnToGrid();
            SetViewDetailColumn();
            //Add the import id as the tooltip to the file name column
            foreach (GridDataItem item in grdLogs.MasterTableView.Items)
            {
                item["FileName"].ToolTip = item["IdImport"].Text;
            }
        }
        catch (IndException ex)
        {
            ReportControlError(ex);
            return;
        }
        catch (Exception ex)
        {
            ReportControlError(new IndException(ex));
            return;
        }
    }
    
    #endregion Event Handlers

    #region Private Methods
    private void SetViewDetailColumn()
    {
        //Change the value in the EditColumn for all items
        foreach (GridEditableItem item in grdLogs.Items)
        {
            //Get the cell that contains the Editcolumn
            GridTableCell cell = item["EditColumn"] as GridTableCell;
            if (cell == null)
                return;
            //Clear the cell controls
            cell.Controls.Clear();

            //Get the import id from the IdImport column
            int idImport = int.Parse(item["IdImport"].Text);           
            string validation = item["Validation"].Text;

            //Construct a new link
            LinkButton lnkDetail = new LinkButton();
            lnkDetail.Text = "See Detail";
            //Disable the link if the import was succesfull
            if (validation.ToUpper() == "G")
            {
                lnkDetail.Enabled = false;
                item["DeleteColumn"].Enabled = false;
            }
            else
            {
                bool doReload = true;
                if (validation.ToUpper() == "R")
                    doReload = false;

                //Assingn link properties
                lnkDetail.OnClientClick = "ShowPopUpWithReload('" + ResolveUrl("~/Pages/AnnualBudget/AnnualDataLogsDetail.aspx?IdImport=" + idImport.ToString()) + "&Validation=" + validation + "',0,1024, '" + ResolveUrl("~/Pages/AnnualBudget/AnnualUpload.aspx") + "','" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "','" + doReload.ToString() + "','"+ this.Page.Form.ClientID + "');return false;";
            }

            //Add the link object in the cell
            cell.Controls.Add(lnkDetail);
        }
    }

    public override void SetViewEntityProperties(IGenericEntity entity)
    {
        CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER);
        if (currentUser.GetPermission(ApplicationConstants.MODULE_ANNUAL_LOGS, Operations.View) == Permissions.Restricted)
        {
            base.SetViewEntityProperties(entity);
            ((AnnualDataLogs)entity).CountryCode = ((CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER)).CountryCode;
        }

        base.SetViewEntityProperties(entity);
    }
    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);
        Dictionary<string, int> currentPageDictionary;

        if ((currentPageDictionary = (Dictionary<string, int>)SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.PAGE_NUMBER_MAPPING)) != null)
        {
            grdLogs.CurrentPage = currentPageDictionary[SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.VIEW_CONTROL).ToString()];
        }

        //Get the moduleCode from the parent Ascx
        string moduleCode = ApplicationConstants.MODULE_ANNUAL_LOGS;


        //Get the current user from session
        CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER);

        grdLogs.UserCanDelete = currentUser.GetPermission(moduleCode, Operations.Delete) == Permissions.All;
    }
    #endregion Private Methods
}
