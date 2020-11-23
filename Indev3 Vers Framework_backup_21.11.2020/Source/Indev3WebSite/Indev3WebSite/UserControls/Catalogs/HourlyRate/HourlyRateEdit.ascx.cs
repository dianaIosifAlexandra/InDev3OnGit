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
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework.Common;
using Telerik.WebControls;
using Inergy.Indev3.ApplicationFramework;


public partial class UserControls_HourlyRate_HourlyRateEdit : GenericUserControl
{
    public UserControls_HourlyRate_HourlyRateEdit()
    {
        this.Entity = new HourlyRate();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            AddExtraAjaxReference();
            if (HourlyRateEditControl.EditMode)
            {
                SetInergyLocation();
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

    protected void cmbInergyLocation_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            LoadCostCenterCodeCombo();
            SetCostCenterName();
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

    protected void cmbCostCenter_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            if (!HourlyRateEditControl.EditMode)
            {
                SetInergyLocation();
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

    private void LoadCostCenterCodeCombo()
    {
        CostCenter costCenter = new CostCenter(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
        costCenter.IdInergyLocation = Int32.Parse(cmbInergyLocation.SelectedValue);
        DataSet ds = costCenter.GetAll(true);
        if (ds != null)
        {
            cmbCostCenter.Items.Clear();
            DSUtils.AddEmptyRecord(ds.Tables[0]);
            cmbCostCenter.DataSource = ds;
            cmbCostCenter.DataMember = ds.Tables[0].TableName;
            cmbCostCenter.DataTextField = "Code";
            cmbCostCenter.DataValueField = "Id";
            cmbCostCenter.DataBind();
        }
    }

    private void SetInergyLocation()
    {
        CostCenter costCenter = new CostCenter(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
        costCenter.Id = Int32.Parse(cmbCostCenter.SelectedValue);
        DataSet ds = costCenter.GetAll(true);

        if (ds.Tables[0].Rows.Count > 1 || ds.Tables[0].Rows.Count == 0)
        {
            cmbInergyLocation.SelectedValue = ApplicationConstants.INT_NULL_VALUE.ToString();
            cmbInergyLocation.Text = String.Empty;
            //When SelectedValue property of cmbInergyLocation is set, the SelectedIndexChanged event of cmbInergyLocation is not fired.
            //This is why we have to manually set the currency when the user selects a cost center which causes the cmbInergyLocation combo to
            //change its selected value
            SetCurrency();
            return;
        }

        int idInergyLocation = ApplicationConstants.INT_NULL_VALUE;
        idInergyLocation = (int)ds.Tables[0].Rows[0]["IdInergyLocation"];
        if (idInergyLocation != ApplicationConstants.INT_NULL_VALUE)
        {
            cmbInergyLocation.SelectedValue = idInergyLocation.ToString();
        }
        else
        {
            cmbInergyLocation.SelectedValue = ApplicationConstants.INT_NULL_VALUE.ToString();
            cmbInergyLocation.Text = String.Empty;
        }
        //When SelectedValue property of cmbInergyLocation is set, the SelectedIndexChanged event of cmbInergyLocation is not fired.
        //This is why we have to manually set the currency when the user selects a cost center which causes the cmbInergyLocation combo to
        //change its selected value
        SetCurrency();
    }

    private void SetCurrency()
    {
        if (!HourlyRateEditControl.EditMode)
        {
            DataTable tblInergyLocation = ((DataSet)cmbInergyLocation.DataSource).Tables[0];
            lblCurrencyName.Text = tblInergyLocation.Rows[cmbInergyLocation.SelectedIndex]["CurrencyName"].ToString();
        }
    }

    private void SetCostCenterName()
    {
        if (!HourlyRateEditControl.EditMode)
        {
            lblCostCenterNameTag.Text = String.Empty;
        }
    }

    private void AddExtraAjaxReference()
    {
        HourlyRateEditControl.AjaxManager.AjaxSettings.AddAjaxSetting(cmbCostCenter, cmbInergyLocation);
        HourlyRateEditControl.AjaxManager.AjaxSettings.AddAjaxSetting(cmbCostCenter, lblCurrencyName);
        HourlyRateEditControl.AjaxManager.AjaxSettings.AddAjaxSetting(cmbInergyLocation, cmbCostCenter);
        HourlyRateEditControl.AjaxManager.AjaxSettings.AddAjaxSetting(cmbInergyLocation, lblCostCenterNameTag);
    }
}