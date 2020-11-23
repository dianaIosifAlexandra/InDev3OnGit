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
using System.Drawing;

using Inergy.Indev3.BusinessLogic.Budget;

using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.WebFramework.GenericControls;

using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.UI
{
    public partial class UserControls_Budget_Interco_PeriodMassAttributionDiv : GenericUserControl
    {
        protected void saveButton_Click(object sender, EventArgs e)
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
                    periodMassAttributionDiv.Attributes.Remove("style");
                    periodMassAttributionDiv.Attributes.Add("style", "display:none");
                }

                int startYearMonth = (int)IndStartYearMonth.GetValue();
                int endYearMonth = (int)IndEndYearMonth.GetValue();
                Session[SessionStrings.DATE_INTERVAL] = new Pair(startYearMonth, endYearMonth);
            }
            catch (IndException exc)
            {
                //ShowError(exc);
                return;
            }
            catch (Exception exc)
            {
                //ShowError(new IndException(exc));
                return;
            }
        }

        protected void cancelButton_Click(object sender, EventArgs e)
        {
            try
            {
                    lstValidationSummary.Items.Clear();
            }
            catch (IndException exc)
            {
                return;
            }
            catch (Exception exc)
            {
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
}

