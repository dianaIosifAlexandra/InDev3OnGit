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
using System.Drawing;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_Budget_Interco_PeriodMassAttribution : IndPopUpBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void btnApply_Click(object sender, EventArgs e)
    {
        try
        {
            ArrayList errorMessages = VerifyRequiredFields();
            if (errorMessages.Count > 0)
            {
                lstValidationSummary.Items.Clear();
                foreach (Label lblError in errorMessages)
                {
                    lstValidationSummary.Items.Add(lblError.Text);
                }
                return;
            }
            else
            {
                tblErrorMessages.Rows[0].Cells[0].Controls.Clear();
            }

            int startYearMonth = (int)IndStartYearMonth.GetValue();
            int endYearMonth = (int)IndEndYearMonth.GetValue();
            Session[SessionStrings.DATE_INTERVAL] = new Pair(startYearMonth, endYearMonth);

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
            if (!Page.ClientScript.IsOnSubmitStatementRegistered(this.Page.GetType(), "ResizePopUp"))
            {
                this.Page.ClientScript.RegisterOnSubmitStatement(this.Page.GetType(), "ResizePopUp", "SetPopUpHeight();");
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
    protected override void RenderChildren(HtmlTextWriter writer)
    {
        try
        {
            IndStartYearMonth.SetComboHeight(Unit.Pixel(90));
            IndEndYearMonth.SetComboHeight(Unit.Pixel(90));
            base.RenderChildren(writer);
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

    private ArrayList VerifyRequiredFields()
    {
        ArrayList labels = new ArrayList();
        int lblCount = 1;
        bool missingDates = false;
        if ((int)IndStartYearMonth.GetValue() == ApplicationConstants.INT_NULL_VALUE)
        {
            Label lbl = new Label();
            lbl.Text = "Start Date is required.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
            missingDates = true;
        }
        if ((int)IndEndYearMonth.GetValue() == ApplicationConstants.INT_NULL_VALUE)
        {
            Label lbl = new Label();
            lbl.Text = "End Date is required.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
            missingDates = true;
        }
        if ((int)IndStartYearMonth.GetValue() > (int)IndEndYearMonth.GetValue() && !missingDates)
        {
            Label lbl = new Label();
            lbl.Text = "End Date must be greater than Start Date.";
            lbl.ID = "lbl" + lblCount.ToString();
            lbl.ForeColor = Color.Yellow;
            lblCount++;
            labels.Add(lbl);
        }
        return labels;
    }
}
