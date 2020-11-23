using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Telerik.WebControls;
using System.Collections;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Budget;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;

namespace Inergy.Indev3.WebFramework.WebControls.Budget
{
    /// <summary>
    /// Grid used by the Reforecast Budget
    /// </summary>
    [DefaultProperty("Items")]
    [ToolboxBitmap(typeof(Telerik.WebControls.RadGrid))]
    [ToolboxData("<{0}:IndReforecastGrid runat=\"server\"></{0}:IndReforecastGrid>")]
    public class IndReforecastGrid : IndGrid
    {
        /// <summary>
        /// Session key for reforecast dataset
        /// </summary>
        private const string REFORECAST_DATASET = "ReforecastDS";
        /// <summary>
        /// Session key for the DeletedReforecastBudgetKey object stored when a cost center is deleted from this budget. When a cost center is deleted,
        /// we restore the values in the grid after postback. In some situations, even if the cost center is deleted from the to completion
        /// budget, it is still displayed in the reforecast grid because it has actual or revised data. In this case, we do not want its values
        /// to be restored since it was deleted. We store its key in session and we do not update during on postback.
        /// </summary>
        private const string DELETED_COST_CENTER_KEY = "DeletedCostCenterKey";

        public override void SaveOldValues()
        {
            DataSet reforecastDS = (DataSet)SessionManager.GetSessionValueNoRedirect(this.Page, REFORECAST_DATASET);
            if (reforecastDS == null)
                return;
            //Search through each detail item
            for (int i = 0; i < this.MasterTableView.Items.Count; i++)
            {
                GridDataItem masterItem = this.MasterTableView.Items[i];
                Hashtable masterData = new Hashtable();
                masterItem.ExtractValues(masterData);
                DataRow masterRow = reforecastDS.Tables[0].Rows.Find(new object[] { masterItem["IdPhase"].Text, masterItem["IdWP"].Text });
                if (masterRow != null)
                {
                    masterRow["Progress"] = GetGridItemValue(masterData["Progress"]);
                }

                GridTableView detailTableView = this.MasterTableView.Items[i].ChildItem.NestedTableViews[0];
                for (int j = 0; j < detailTableView.Items.Count; j++)
                {
                    GridDataItem detailItem = detailTableView.Items[j];
                    Hashtable detailData = new Hashtable();

                    //If a DeletedReforecastBudgetKey object has been stored in the session
                    DeletedReforecastBudgetKey key = (DeletedReforecastBudgetKey)SessionManager.GetSessionValueNoRedirect(this.Page, DELETED_COST_CENTER_KEY);
                    if (key != null)
                    {
                        //If the stored budget key is the same one as the current budget, do not save the old values of this budget since
                        //this budget has been deleted
                        if (key.IdProject == int.Parse(detailItem["IdProject"].Text) && key.IdPhase == int.Parse(detailItem["IdPhase"].Text)
                            && key.IdWP == int.Parse(detailItem["IdWP"].Text) && key.IdCostCenter == int.Parse(detailItem["IdCostCenter"].Text))
                            continue;
                    }

                    detailItem.ExtractValues(detailData);
                    DataRow detailRow = reforecastDS.Tables[1].Rows.Find(new object[] { detailItem["IdPhase"].Text, detailItem["IdWP"].Text, detailItem["IdCostCenter"].Text });
                    if (detailRow != null)
                    {
                        detailRow["New"] = GetGridItemValue(detailData["New"]);
                    }

                    GridTableView lastTableView = detailTableView.Items[j].ChildItem.NestedTableViews[0];
                    for (int k = 0; k < lastTableView.Items.Count; k++)
                    {
                        GridDataItem detailDetailItem = lastTableView.Items[k];
                        if (lastTableView.Items[k].IsInEditMode)
                        {
                            Hashtable detailDetailData = new Hashtable();
                            detailDetailItem.ExtractValues(detailDetailData);
                            DataRow detailDetailRow = reforecastDS.Tables[2].Rows.Find(new object[] { detailDetailItem["IdPhase"].Text, detailDetailItem["IdWP"].Text, detailDetailItem["IdCostCenter"].Text, detailDetailItem["YearMonth"].Text });
                            if (detailDetailRow != null)
                            {
                                detailDetailRow["New"] = GetGridItemValue(detailDetailData["New"]);
                            }
                        }

                    }
                }
            }
            SessionManager.SetSessionValue(this.Page, REFORECAST_DATASET, reforecastDS);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="gridItemValue"></param>
        /// <returns></returns>
        private object GetGridItemValue(object gridItemValue)
        {
            if (gridItemValue == null)
                return DBNull.Value;
            decimal result;
            if (decimal.TryParse(gridItemValue.ToString(), out result) == false)
                return DBNull.Value;
            return result;
        }
    }
}
