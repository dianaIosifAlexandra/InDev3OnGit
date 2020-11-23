using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class ReforecastBudgetTotals
    {
        #region Members
        private decimal _Previous;

        public decimal Previous
        {
            get { return _Previous; }
            set { _Previous = value; }
        }

        private decimal _CurrentPreviousDiff;

        public decimal CurrentPreviousDiff
        {
            get { return _CurrentPreviousDiff; }
            set { _CurrentPreviousDiff = value; }
        }

        private decimal _Current;

        public decimal Current
        {
            get { return _Current; }
            set { _Current = value; }
        }

        private decimal _NewCurrentDiff;

        public decimal NewCurrentDiff
        {
            get { return _NewCurrentDiff; }
            set { _NewCurrentDiff = value; }
        }

        private decimal _New;

        public decimal New
        {
            get { return _New; }
            set { _New = value; }
        }

        private decimal _NewRevisedDiff;

        public decimal NewRevisedDiff
        {
            get { return _NewRevisedDiff; }
            set { _NewRevisedDiff = value; }
        }

        private decimal _Revised;

        public decimal Revised
        {
            get { return _Revised; }
            set { _Revised = value; }
        }
        #endregion Members

        #region Public Methods
        /// <summary>
        /// Builds the totals from the given datatable
        /// </summary>
        /// <param name="tbl">table containing the information to be summed up</param>
        public void BuildTotals(DataTable tbl)
        {
            try
            {
                _Previous = 0;
                _CurrentPreviousDiff = 0;
                _Current = 0;
                _NewCurrentDiff = 0;
                _New = 0;
                _NewRevisedDiff = 0;
                _Revised = 0;

                bool isPreviousNull = true;
                bool isCurrentPreviousDiffNull = true;
                bool isCurrentNull = true;
                bool isNewCurrentDiffNull = true;
                bool isNewNull = true;
                bool isNewRevisedDiffNull = true;
                bool isRevisedNull = true;

                foreach (DataRow row in tbl.Rows)
                {
                    if (row["Previous"] != DBNull.Value)
                    {
                        _Previous += DSUtils.GetDataRowValue(row["Previous"]);
                        isPreviousNull = false;
                    }
                    if (row["CurrentPreviousDiff"] != DBNull.Value)
                    {
                        _CurrentPreviousDiff += DSUtils.GetDataRowValue(row["CurrentPreviousDiff"]);
                        isCurrentPreviousDiffNull = false;
                    }
                    if (row["Current"] != DBNull.Value)
                    {
                        _Current += DSUtils.GetDataRowValue(row["Current"]);
                        isCurrentNull = false;
                    }
                    if (row["NewCurrentDiff"] != DBNull.Value)
                    {
                        _NewCurrentDiff += DSUtils.GetDataRowValue(row["NewCurrentDiff"]);
                        isNewCurrentDiffNull = false;
                    }
                    if (row["New"] != DBNull.Value)
                    {
                        _New += DSUtils.GetDataRowValue(row["New"]);
                        isNewNull = false;
                    }
                    if (row["NewRevisedDiff"] != DBNull.Value)
                    {
                        _NewRevisedDiff += DSUtils.GetDataRowValue(row["NewRevisedDiff"]);
                        isNewRevisedDiffNull = false;
                    }
                    if (row["Revised"] != DBNull.Value)
                    {
                        _Revised += DSUtils.GetDataRowValue(row["Revised"]);
                        isRevisedNull = false;
                    }
                }

                if (isPreviousNull)
                    _Previous = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isCurrentPreviousDiffNull)
                    _CurrentPreviousDiff = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isCurrentNull)
                    _Current = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isNewCurrentDiffNull)
                    _NewCurrentDiff = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isNewNull)
                    _New = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isNewRevisedDiffNull)
                    _NewRevisedDiff = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isRevisedNull)
                {
                    _Revised = ApplicationConstants.DECIMAL_NULL_VALUE;
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion Public Methods
    }
}
