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
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework;
using System.Drawing;

using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;

public partial class UserControls_Catalogs_HourlyRate_HRMassAttribution : IndPopUpBasePage
{  
    protected DataSet LstDataSource
    {
        get
        {
            return (DataSet)ViewState["LstDataSource"];
        }
        set
        {
            ViewState["LstDataSource"] = value;            
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!Page.IsPostBack)
                PopulateControls();
            RadAjaxManager ajaxManager = GetAjaxMgr();
            ajaxManager.EnableAJAX = true;
            ajaxManager.AjaxSettings.AddAjaxSetting(lstInergyLogins, lblCurrencyName);
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


    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            ArrayList errorMessages = VerifyRequiredFields();
            //If there are errors, report them and return
            if (errorMessages.Count > 0)
            {
                lstValidationSummary.Items.Clear();
                foreach (Label lblError in errorMessages)
                {
                    lstValidationSummary.Items.Add(lblError.Text);
                }
                return;
            }
            int[] indices = lstInergyLogins.GetSelectedIndices();
            ArrayList inergyLoginIds = new ArrayList();
            for (int i = 0; i < indices.Length; i++)
            {
                inergyLoginIds.Add(int.Parse(lstInergyLogins.Items[indices[i]].Value));
            }
            int startYearMonth = (int)dtStartDate.GetValue();
            int endYearMonth = (int)dtEndDate.GetValue();
            //int idCurrency = int.Parse(cmbCurrency.SelectedValue);
            //decimal hrValue = decimal.Parse(txtHourlyRate.TextWithPromptAndLiterals);
            string txtHRate = txtHourlyRate.Text;
            if (txtHRate.Contains(","))
            {
                txtHRate = txtHRate.Replace(",", ".");
            }
            decimal hrValue = decimal.Parse(txtHRate);

            int updatedCCCount = HourlyRate.MassFill(inergyLoginIds, startYearMonth, endYearMonth, hrValue, SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
            if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonClickScript"))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonClickScript", "setTimeout(\"alert('" + updatedCCCount + " cost centers have been updated!'); window.returnValue = 1; window.close();\", '100');", true);
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


    protected void lstInergyLogins_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            FillCurrencyLabel();
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

    #region Private Methods
    private RadAjaxManager GetAjaxMgr()
    {
        RadAjaxManager ajaxManager = this.FindControl("Aj") as RadAjaxManager;
        //If the control is not fount the method returns null
        return ajaxManager;
    }

    private void PopulateControls()
    {
        #region Inergy Locations List
        InergyLocation inergyLocation = new InergyLocation(SessionManager.GetSessionValueNoRedirect((IndPopUpBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
        DataSet dsInergyLocations = inergyLocation.GetAll();
        lstInergyLogins.DataSource = dsInergyLocations;
        lstInergyLogins.DataMember = dsInergyLocations.Tables[0].ToString();
        lstInergyLogins.DataValueField = "Id";
        lstInergyLogins.DataTextField = "Name";
        lstInergyLogins.DataBind();
        LstDataSource = dsInergyLocations;
        #endregion Inergy Locations List

        #region Currency Combo
        //Currency currency = new Currency(SessionManager.GetSessionValueNoRedirect((IndPopUpBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
        //DataSet dsCurrencies = currency.GetAll();
        //cmbCurrency.DataSource = dsCurrencies;
        //cmbCurrency.DataMember = dsCurrencies.Tables[0].ToString();
        //cmbCurrency.DataValueField = "Id";
        //cmbCurrency.DataTextField = "Name";
        //cmbCurrency.DataBind();
        #endregion Currency Combo
    }

    private ArrayList VerifyRequiredFields()
    {
        ArrayList labels = new ArrayList();
        int lblCount = 1;
        if (lstInergyLogins.GetSelectedIndices().Length == 0)
        {
            Label lbl = new Label();
            lbl.Text = "At least one Inergy Location is required.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
        }
        bool missingDates = false;
        if ((int)dtStartDate.GetValue() == ApplicationConstants.INT_NULL_VALUE)
        {
            Label lbl = new Label();
            lbl.Text = "Start Period is required.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
            missingDates = true;
        }
        if ((int)dtEndDate.GetValue() == ApplicationConstants.INT_NULL_VALUE)
        {
            Label lbl = new Label();
            lbl.Text = "End Period is required.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
            missingDates = true;
        }
        if ((int)dtEndDate.GetValue() < (int)dtStartDate.GetValue() && !missingDates) 
        {
            Label lbl = new Label();
            lbl.Text = "End Period sould be greater than Start Period.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
        }
        if (lblCurrencyName.Text == ApplicationConstants.HOURLY_RATE_MASS_MULTIPLE_CURRENCY)
        {
            Label lbl = new Label();
            lbl.Text = ApplicationConstants.HOURLY_RATE_MASS_MULTIPLE_CURRENCY + " selected.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
        }
        if (txtHourlyRate.Text == String.Empty)
        {
            Label lbl = new Label();
            lbl.Text = "Hourly Rate is required.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
        }
        else
        {
            decimal val;
            decimal.TryParse(txtHourlyRate.Text, out val);
            if (val < 0)
            {
                Label lbl = new Label();
                lbl.Text = "Hourly Rate must be positive numeric or zero.";
                lbl.ID = "lbl" + lblCount.ToString();
                lbl.ForeColor = Color.Yellow;
                lblCount++;
                labels.Add(lbl);
            }
        }
        return labels;
    }
    
    private void FillCurrencyLabel()
    {
        int[] indices = lstInergyLogins.GetSelectedIndices();
        DataTable dt = new DataTable();
        
        dt = LstDataSource.Tables[0];
        //get first currencty
        DataRow drFirst = dt.Rows[int.Parse(indices[0].ToString())];
        string firstCurrency = GetInergyCurrency(drFirst);

        if (indices.Length > 1)
        {
            for (int i = 1; i < indices.Length; i++)
            {
                DataRow dr = dt.Rows[int.Parse(indices[i].ToString())];
                string currency = GetInergyCurrency(dr);
                if (currency == firstCurrency)
                {
                    lblCurrencyName.Text = firstCurrency;
                }
                else
                {
                    lblCurrencyName.Text = ApplicationConstants.HOURLY_RATE_MASS_MULTIPLE_CURRENCY;
                    break;
                }

            }
        }
        else
        {
            lblCurrencyName.Text = firstCurrency;
        }

       
    }

    private string GetInergyCurrency(DataRow selectedRow)
    {
        InergyLocation inergyLocation = new InergyLocation(selectedRow, SessionManager.GetSessionValueNoRedirect((IndPopUpBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
        return inergyLocation.CurrencyName.ToString();

    }
    #endregion Private Methods
}
