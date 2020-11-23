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
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;

public partial class Pages_Budget_RevisedBudget_OtherCosts : IndPopUpBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {            
            //If the page is not posted back, populate the controls on it with other costs data
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
                RevisedBudgetOtherCosts otherCosts = (RevisedBudgetOtherCosts)SessionManager.GetSessionValueRedirect(this, SessionStrings.REVISED_OTHER_COSTS);
                //If other costs is null, the redirect does not take place immediately
                if (otherCosts != null)
                {
                    //initialize controls to empty string before loading from database
                    InitializePopupControls();
                    RevisedBudgetOtherCosts existingOtherCosts = SessionManager.GetRevisedOtherCost(this, otherCosts);
                    if (existingOtherCosts == null)
                    {
                        otherCosts.IsAssociateCurrency = this.Request.QueryString["IsAssociateCurrency"] == "1" ? true : false;
                        DataSet dsOtherCosts = otherCosts.GetAll(true);
                        PopulateControls(dsOtherCosts.Tables[0]);
                    }
                    else
                    {
                        PopulateControls(existingOtherCosts);
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

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            base.OnPreRender(e);
            //Set the ValueToCompare property of the compare validators in the page depending on the current values of costs
            SetCompareValidatorsValues();
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                //Build the object from the screen values
                RevisedBudgetOtherCosts otherCosts = SessionManager.GetSessionValueRedirect(this, SessionStrings.REVISED_OTHER_COSTS) as RevisedBudgetOtherCosts;
                int multiplier = GetMultiplier();

                if (otherCosts != null)
                {
                    UpdateCurrentCosts(otherCosts, multiplier);
                    UpdateUpdateCosts(otherCosts, multiplier);
                    UpdateNewCosts(otherCosts, multiplier);

                    //Add object to session
                    SessionManager.AddRevisedOtherCosts(this, otherCosts);

                    //Close the page
                    if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonClickScript"))
                    {
                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonClickScript", "window.returnValue = 1; window.close();", true);
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

    private void PopulateControls(RevisedBudgetOtherCosts otherCosts)
    {
        int multiplier = GetMultiplier();
        lblCurrentTE.Text = (otherCosts.CurrentCosts.TE == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty :  Rounding.Round(Decimal.Divide(otherCosts.CurrentCosts.TE, multiplier)).ToString();
        lblCurrentProtoParts.Text = (otherCosts.CurrentCosts.ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.CurrentCosts.ProtoParts, multiplier)).ToString();
        lblCurrentProtoTooling.Text = (otherCosts.CurrentCosts.ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.CurrentCosts.ProtoTooling, multiplier)).ToString();
        lblCurrentTrials.Text = (otherCosts.CurrentCosts.Trials == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.CurrentCosts.Trials, multiplier)).ToString();
        lblCurrentOtherExpenses.Text = (otherCosts.CurrentCosts.OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.CurrentCosts.OtherExpenses, multiplier)).ToString();

        txtUpdateTE.Text = (otherCosts.UpdateCosts.TE == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.UpdateCosts.TE, multiplier)).ToString();
        txtUpdateProtoParts.Text = (otherCosts.UpdateCosts.ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.UpdateCosts.ProtoParts, multiplier)).ToString();
        txtUpdateProtoTooling.Text = (otherCosts.UpdateCosts.ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.UpdateCosts.ProtoTooling, multiplier)).ToString();
        txtUpdateTrials.Text = (otherCosts.UpdateCosts.Trials == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.UpdateCosts.Trials, multiplier)).ToString();
        txtUpdateOtherExpenses.Text = (otherCosts.UpdateCosts.OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.UpdateCosts.OtherExpenses, multiplier)).ToString();

        lblNewTE.Text = (otherCosts.NewCosts.TE == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.NewCosts.TE, multiplier)).ToString();
        lblNewProtoParts.Text = (otherCosts.NewCosts.ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.NewCosts.ProtoParts, multiplier)).ToString();
        lblNewProtoTooling.Text = (otherCosts.NewCosts.ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.NewCosts.ProtoTooling, multiplier)).ToString();
        lblNewTrials.Text = (otherCosts.NewCosts.Trials == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.NewCosts.Trials, multiplier)).ToString();
        lblNewOtherExpenses.Text = (otherCosts.NewCosts.OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : Rounding.Round(Decimal.Divide(otherCosts.NewCosts.OtherExpenses, multiplier)).ToString();
    }

    private void PopulateControls(DataTable tblOtherCosts)
    {
        int multiplier = GetMultiplier();
        lblCurrentTE.Text = (tblOtherCosts.Rows[0]["CurrentCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[0]["CurrentCost"], multiplier)).ToString();
        lblCurrentProtoParts.Text = (tblOtherCosts.Rows[1]["CurrentCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[1]["CurrentCost"], multiplier)).ToString();
        lblCurrentProtoTooling.Text = (tblOtherCosts.Rows[2]["CurrentCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[2]["CurrentCost"], multiplier)).ToString();
        lblCurrentTrials.Text = (tblOtherCosts.Rows[3]["CurrentCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[3]["CurrentCost"], multiplier)).ToString();
        lblCurrentOtherExpenses.Text = (tblOtherCosts.Rows[4]["CurrentCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[4]["CurrentCost"], multiplier)).ToString();

        txtUpdateTE.Text = (tblOtherCosts.Rows[0]["UpdateCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[0]["UpdateCost"], multiplier)).ToString();
        txtUpdateProtoParts.Text = (tblOtherCosts.Rows[1]["UpdateCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[1]["UpdateCost"], multiplier)).ToString();
        txtUpdateProtoTooling.Text = (tblOtherCosts.Rows[2]["UpdateCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[2]["UpdateCost"], multiplier)).ToString();
        txtUpdateTrials.Text = (tblOtherCosts.Rows[3]["UpdateCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[3]["UpdateCost"], multiplier)).ToString();
        txtUpdateOtherExpenses.Text = (tblOtherCosts.Rows[4]["UpdateCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[4]["UpdateCost"], multiplier)).ToString();

        lblNewTE.Text = (tblOtherCosts.Rows[0]["NewCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[0]["NewCost"], multiplier)).ToString();
        lblNewProtoParts.Text = (tblOtherCosts.Rows[1]["NewCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[1]["NewCost"], multiplier)).ToString();
        lblNewProtoTooling.Text = (tblOtherCosts.Rows[2]["NewCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[2]["NewCost"], multiplier)).ToString();
        lblNewTrials.Text = (tblOtherCosts.Rows[3]["NewCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[3]["NewCost"], multiplier)).ToString();
        lblNewOtherExpenses.Text = (tblOtherCosts.Rows[4]["NewCost"] == DBNull.Value) ? String.Empty : Rounding.Round(Decimal.Divide((decimal)tblOtherCosts.Rows[4]["NewCost"], multiplier)).ToString();
    }

    private int GetMultiplier()
    {
        if (String.IsNullOrEmpty(this.Request.QueryString["AmountScaleOption"]))
        {
            throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_COULD_NOT_GET_PARAMETER, "AmountScaleOption"));
        }
        AmountScaleOption amountScaleOption = BudgetUtils.GetAmountScaleOptionFromText(this.Request.QueryString["AmountScaleOption"]);
        int multiplier = 1;
        for (int i = 1; i <= (int)amountScaleOption; i++)
            multiplier *= 1000;
        return multiplier;
    }
    
    private void UpdateCurrentCosts(RevisedBudgetOtherCosts otherCosts, int multiplier)
    {
        otherCosts.CurrentCosts.TE = (lblCurrentTE.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(lblCurrentTE.Text)), multiplier);
        otherCosts.CurrentCosts.ProtoParts = (lblCurrentProtoParts.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(lblCurrentProtoParts.Text)), multiplier);
        otherCosts.CurrentCosts.ProtoTooling = (lblCurrentProtoTooling.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(lblCurrentProtoTooling.Text)), multiplier);
        otherCosts.CurrentCosts.Trials = (lblCurrentTrials.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(lblCurrentTrials.Text)), multiplier);
        otherCosts.CurrentCosts.OtherExpenses = (lblCurrentOtherExpenses.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(lblCurrentOtherExpenses.Text)), multiplier);
    }

    private void UpdateUpdateCosts(RevisedBudgetOtherCosts otherCosts, int multiplier)
    {
        otherCosts.UpdateCosts.TE = (txtUpdateTE.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(txtUpdateTE.Text)), multiplier);
        otherCosts.UpdateCosts.ProtoParts = (txtUpdateProtoParts.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(txtUpdateProtoParts.Text)), multiplier);
        otherCosts.UpdateCosts.ProtoTooling = (txtUpdateProtoTooling.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(txtUpdateProtoTooling.Text)), multiplier);
        otherCosts.UpdateCosts.Trials = (txtUpdateTrials.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(txtUpdateTrials.Text)), multiplier);
        otherCosts.UpdateCosts.OtherExpenses = (txtUpdateOtherExpenses.Text == String.Empty) ? ApplicationConstants.DECIMAL_NULL_VALUE : Decimal.Multiply(Rounding.Round(decimal.Parse(txtUpdateOtherExpenses.Text)), multiplier);
    }

    private void UpdateNewCosts(RevisedBudgetOtherCosts otherCosts, int multiplier)
    {
        if (otherCosts.CurrentCosts.TE == ApplicationConstants.DECIMAL_NULL_VALUE && otherCosts.UpdateCosts.TE == ApplicationConstants.DECIMAL_NULL_VALUE)
        {
            otherCosts.NewCosts.TE = ApplicationConstants.DECIMAL_NULL_VALUE;
        }
        else
        {
            otherCosts.NewCosts.TE = ApplicationUtils.GetDecimalValueForSum(otherCosts.CurrentCosts.TE) +
                    ApplicationUtils.GetDecimalValueForSum(otherCosts.UpdateCosts.TE);
        }

        if (otherCosts.CurrentCosts.ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE && otherCosts.UpdateCosts.ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE)
        {
            otherCosts.NewCosts.ProtoParts = ApplicationConstants.DECIMAL_NULL_VALUE;
        }
        else
        {
            otherCosts.NewCosts.ProtoParts = ApplicationUtils.GetDecimalValueForSum(otherCosts.CurrentCosts.ProtoParts) +
                ApplicationUtils.GetDecimalValueForSum(otherCosts.UpdateCosts.ProtoParts);
        }

        if (otherCosts.CurrentCosts.ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE && otherCosts.UpdateCosts.ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE)
        {
            otherCosts.NewCosts.ProtoTooling = ApplicationConstants.DECIMAL_NULL_VALUE;
        }
        else
        {
            otherCosts.NewCosts.ProtoTooling = ApplicationUtils.GetDecimalValueForSum(otherCosts.CurrentCosts.ProtoTooling) +
                ApplicationUtils.GetDecimalValueForSum(otherCosts.UpdateCosts.ProtoTooling);
        }

        if (otherCosts.CurrentCosts.Trials == ApplicationConstants.DECIMAL_NULL_VALUE && otherCosts.UpdateCosts.Trials == ApplicationConstants.DECIMAL_NULL_VALUE)
        {
            otherCosts.NewCosts.Trials = ApplicationConstants.DECIMAL_NULL_VALUE;
        }
        else
        {
            otherCosts.NewCosts.Trials = ApplicationUtils.GetDecimalValueForSum(otherCosts.CurrentCosts.Trials) +
                ApplicationUtils.GetDecimalValueForSum(otherCosts.UpdateCosts.Trials);
        }

        if (otherCosts.CurrentCosts.OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE && otherCosts.UpdateCosts.OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE)
        {
            otherCosts.NewCosts.OtherExpenses = ApplicationConstants.DECIMAL_NULL_VALUE;
        }
        else
        {
            otherCosts.NewCosts.OtherExpenses = ApplicationUtils.GetDecimalValueForSum(otherCosts.CurrentCosts.OtherExpenses) +
                ApplicationUtils.GetDecimalValueForSum(otherCosts.UpdateCosts.OtherExpenses);
        }
    }

    private void SetCompareValidatorsValues()
    {
        decimal currentTE;
        decimal currentProtoParts;
        decimal currentProtoTooling;
        decimal currentTrials;
        decimal currentOtherExpenses;
        if (decimal.TryParse(lblCurrentTE.Text, out currentTE) == false)
        {
            cmpTE.ValueToCompare = "0";
        }
        else 
        {
            cmpTE.ValueToCompare = Decimal.Multiply(currentTE, -1).ToString();
        }
        if (decimal.TryParse(lblCurrentProtoParts.Text, out currentProtoParts) == false)
        {
            cmpProtoParts.ValueToCompare = "0";
        }
        else 
        {
            cmpProtoParts.ValueToCompare = Decimal.Multiply(currentProtoParts, -1).ToString();
        }
        if (decimal.TryParse(lblCurrentProtoTooling.Text, out currentProtoTooling) == false)
        {
            cmpProtoTooling.ValueToCompare = "0";
        }
        else 
        {
            cmpProtoTooling.ValueToCompare = Decimal.Multiply(currentProtoTooling, -1).ToString();
        }
        if (decimal.TryParse(lblCurrentTrials.Text, out currentTrials) == false)
        {
            cmpTrials.ValueToCompare = "0";
        }
        else 
        {
            cmpTrials.ValueToCompare = Decimal.Multiply(currentTrials, -1).ToString();
        }
        if (decimal.TryParse(lblCurrentOtherExpenses.Text, out currentOtherExpenses) == false)
        {
            cmpOtherExpenses.ValueToCompare = "0";
        }
        else 
        {
            cmpOtherExpenses.ValueToCompare = Decimal.Multiply(currentOtherExpenses, -1).ToString();
        }
    }

    private void InitializePopupControls()
    {
        lblCurrentTE.Text = string.Empty;
        lblCurrentProtoParts.Text = string.Empty;
        lblCurrentProtoTooling.Text = string.Empty;
        lblCurrentTrials.Text = string.Empty;
        lblCurrentOtherExpenses.Text = string.Empty;

        txtUpdateTE.Text = string.Empty;
        txtUpdateProtoParts.Text = string.Empty;
        txtUpdateProtoTooling.Text = string.Empty;
        txtUpdateTrials.Text = string.Empty;
        txtUpdateOtherExpenses.Text = string.Empty;

        lblNewTE.Text = string.Empty;
        lblNewProtoParts.Text = string.Empty;
        lblNewProtoTooling.Text = string.Empty;
        lblNewTrials.Text = string.Empty;
        lblNewOtherExpenses.Text = string.Empty;
    }
}
