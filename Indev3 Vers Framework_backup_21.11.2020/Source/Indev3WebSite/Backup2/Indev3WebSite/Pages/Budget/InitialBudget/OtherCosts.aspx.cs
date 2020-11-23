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
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class Pages_Budget_InitialBudget_OtherCosts : IndPopUpBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                if (String.IsNullOrEmpty(this.Request.QueryString["IsAssociateCurrency"]))
                {
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_COULD_NOT_GET_PARAMETER, "IsAssociateCurrency"));
                }
                if (this.Request.QueryString["IsAssociateCurrency"] != "0" && this.Request.QueryString["IsAssociateCurrency"] != "1")
                {
                    throw new IndException(ApplicationMessages.EXCEPTION_WRONG_ASSOCIATE_CURRENCY_PARAMETER);
                }
                if (String.IsNullOrEmpty(this.Request.QueryString["AmountScaleOption"]))
                {
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_COULD_NOT_GET_PARAMETER, "AmountScaleOption"));
                }

                InitialBudgetOtherCosts otherCosts = SessionManager.GetSessionValueRedirect(this, SessionStrings.INITIAL_OTHER_COSTS) as InitialBudgetOtherCosts;
                //If other costs is null, the redirect does not take place immediately
                if (otherCosts != null)
                {
                    //initialize controls to empty string before loading from database
                    InitializePopupControls();
                    InitialBudgetOtherCosts existingOtherCosts = SessionManager.GetOtherCost(this, otherCosts);
                    if (existingOtherCosts == null)
                    {
                        otherCosts.IsAssociateCurrency = this.Request.QueryString["IsAssociateCurrency"] == "1" ? true : false;
                        DataSet ds = otherCosts.GetAll(true);
                        LoadValues(ds);
                    }
                    else
                    {
                        LoadValues(existingOtherCosts);
                    }
                }
            }
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
    }

    protected void btnApply_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            #region Build Object
            //Gets the amount scale
            AmountScaleOption scaleOption = BudgetUtils.GetAmountScaleOptionFromText(this.Request.QueryString["AmountScaleOption"]);
            
            int multiplier = 1;
            //Find out the number that will be used to multiply the values with
            for (int i = 1; i <= (int)scaleOption; i++)
                multiplier *= 1000;

            //Build the object from the screen values
            InitialBudgetOtherCosts otherCosts = SessionManager.GetSessionValueNoRedirect(this, SessionStrings.INITIAL_OTHER_COSTS) as InitialBudgetOtherCosts;
            otherCosts.TE = (txtTE.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : decimal.Parse(txtTE.Text) * multiplier;
            otherCosts.ProtoParts = (txtProtoParts.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : decimal.Parse(txtProtoParts.Text) * multiplier;
            otherCosts.ProtoTooling = (txtProtoTooling.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : decimal.Parse(txtProtoTooling.Text) * multiplier;
            otherCosts.Trials = (txtTrials.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : decimal.Parse(txtTrials.Text) * multiplier;
            otherCosts.OtherExpenses = (txtOtherExpenses.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : decimal.Parse(txtOtherExpenses.Text) * multiplier;
            //Add object to session
            SessionManager.AddOtherCosts(this, otherCosts);
            #endregion Buidl Object

            //Close the page
            if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonClickScript"))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonClickScript", "window.returnValue = 1; window.close();", true);
            }
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
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
                ClientScript.RegisterOnSubmitStatement(this.GetType(), "ResizePopUp", "SetPopUpHeight(); if(Page_IsValid) this.disabled=true;");
            }
        }
        catch (IndException exc)
        {
            ShowError(exc);
            return;
        }
        catch (Exception exc)
        {
            ShowError(new IndException(exc));
            return;
        }
    }


    private int GetMultiplier()
    {
        if (String.IsNullOrEmpty(this.Request.QueryString["AmountScaleOption"]))
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_COULD_NOT_GET_PARAMETER, "AmountScaleOption"));
        }
        AmountScaleOption scaleOption = BudgetUtils.GetAmountScaleOptionFromText(this.Request.QueryString["AmountScaleOption"]);

        int multiplier = 1;
        for (int i = 1; i <= (int)scaleOption; i++)
            multiplier *= 1000;
        return multiplier;
    }

    private void LoadValues(InitialBudgetOtherCosts otherCosts)
    {
        int multiplier = GetMultiplier();
        txtTE.Text = (otherCosts.TE == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(decimal.Divide(otherCosts.TE, multiplier)).ToString();
        txtProtoParts.Text = (otherCosts.ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(decimal.Divide(otherCosts.ProtoParts, multiplier)).ToString();
        txtProtoTooling.Text = (otherCosts.ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(decimal.Divide(otherCosts.ProtoTooling, multiplier)).ToString();
        txtTrials.Text = (otherCosts.Trials == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(decimal.Divide(otherCosts.Trials, multiplier)).ToString();
        txtOtherExpenses.Text = (otherCosts.OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(decimal.Divide(otherCosts.OtherExpenses, multiplier)).ToString();
    }

    private void LoadValues(DataSet ds)
    {
        int multiplier = GetMultiplier();
        DataTable tbl = ds.Tables[0];
        if (tbl.Rows.Count == 0)
            return;
        foreach (DataRow row in tbl.Rows)
        {
            decimal value = (row["OtherCostVal"] == DBNull.Value) ? ApplicationConstants.DECIMAL_NULL_VALUE : (decimal)row["OtherCostVal"];
            value = Rounding.Round(value);
            switch (row["IdOtherCost"].ToString())
            {
                case "1":
                    if (value != ApplicationConstants.DECIMAL_NULL_VALUE)
                        txtTE.Text = Rounding.Round(decimal.Divide(value,multiplier)).ToString();
                    break;
                case "2":
                    if (value != ApplicationConstants.DECIMAL_NULL_VALUE)
                        txtProtoParts.Text = Rounding.Round(decimal.Divide(value,multiplier)).ToString();
                    break;
                case "3":
                    if (value != ApplicationConstants.DECIMAL_NULL_VALUE)
                        txtProtoTooling.Text = Rounding.Round(decimal.Divide(value,multiplier)).ToString();
                    break;
                case "4":
                    if (value != ApplicationConstants.DECIMAL_NULL_VALUE)
                        txtTrials.Text = Rounding.Round(decimal.Divide(value,multiplier)).ToString();
                    break;
                case "5":
                    if (value != ApplicationConstants.DECIMAL_NULL_VALUE)
                        txtOtherExpenses.Text = Rounding.Round(decimal.Divide(value, multiplier)).ToString();
                    break;
            }
        }
    }

    private void InitializePopupControls()
    {
         txtTE.Text = string.Empty;
        txtProtoParts.Text = string.Empty;
        txtProtoTooling.Text = string.Empty;
        txtTrials.Text = string.Empty;
        txtOtherExpenses.Text = string.Empty;
    }
    
}
