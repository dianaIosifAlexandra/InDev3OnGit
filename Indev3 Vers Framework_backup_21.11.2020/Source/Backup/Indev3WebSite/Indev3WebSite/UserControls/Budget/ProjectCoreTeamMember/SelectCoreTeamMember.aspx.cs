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
using Inergy.Indev3.BusinessLogic.Catalogues;
using Telerik.WebControls;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


public partial class UserControls_Budget_ProjectCoreTeamMember_SelectCoreTeamMember : IndPopUpBasePage
{
    #region Event Handlers

    PageStatePersister _pers;
    protected override PageStatePersister PageStatePersister
    {
        get
        {
            if (_pers == null)
            {
                _pers = new SessionPageStatePersister(this);
            }
            return _pers;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            btnSave.Click += new ImageClickEventHandler(btnSave_Click);
            if (!IsPostBack)
            {
                PopulateControls();
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

    private void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                SaveAssociate();
                if (!ClientScript.IsClientScriptBlockRegistered(Page.GetType(), "ClosePopUp"))
                {
                    ClientScript.RegisterClientScriptBlock(Page.GetType(), "ClosePopUp", "window.returnValue=1;self.close();", true);
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

    protected void cmbCt_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            Associate associate = new Associate(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            associate.IdCountry = int.Parse(cmbCt.SelectedValue);
            DataSet associateDataSet = associate.SelectActiveAssociates();

            DSUtils.AddEmptyRecord(associateDataSet.Tables[0]);
            cmbAs.DataSource = associateDataSet;
            cmbAs.DataMember = associateDataSet.Tables[0].TableName;
            cmbAs.DataTextField = "Name";
            cmbAs.DataValueField = "Id";
            cmbAs.DataBind();
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
            if (!ClientScript.IsOnSubmitStatementRegistered(this.GetType(), "ResizePopUp"))
            {
                Page.ClientScript.RegisterOnSubmitStatement(this.GetType(), "ResizePopUp", "SetPopUpHeight();");
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

    protected override void RenderChildren(HtmlTextWriter writer)
    {
        try
        {
            if (cmbAs.Items.Count >= 3)
                cmbAs.Height = Unit.Pixel(70);
            else
                cmbAs.Height = Unit.Empty;

            if (cmbCt.Items.Count >= 4)
                cmbCt.Height = Unit.Pixel(90);
            else
                cmbCt.Height = Unit.Empty;
            base.RenderChildren(writer);
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
    #endregion Event Handlers

    #region Private Methods
    private void SaveAssociate()
    {
        DataTable associateTable = ((DataSet)cmbAs.DataSource).Tables[0];
        DataRow associateRow = associateTable.Rows[cmbAs.SelectedIndex];
        Associate associate = new Associate(associateRow, SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
        SessionManager.SetSessionValue(this, SessionStrings.CORE_TEAM_ASSOCIATE, associate);
    }

    private void PopulateControls()
    {
        Country country = new Country(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
        DataSet countryDataSet = country.GetAll();
        DSUtils.AddEmptyRecord(countryDataSet.Tables[0]);
        cmbCt.DataSource = countryDataSet;
        cmbCt.DataMember = countryDataSet.Tables[0].TableName;
        cmbCt.DataTextField = "Name";
        cmbCt.DataValueField = "Id";
        cmbCt.DataBind();

        Associate associate = new Associate(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
        DataSet associateDataSet = associate.SelectActiveAssociates();
        DSUtils.AddEmptyRecord(associateDataSet.Tables[0]);
        cmbAs.DataSource = associateDataSet;
        cmbAs.DataMember = associateDataSet.Tables[0].TableName;
        cmbAs.DataTextField = "Name";
        cmbAs.DataValueField = "Id";
        cmbAs.DataBind();
    }
    #endregion Private Methods
}
