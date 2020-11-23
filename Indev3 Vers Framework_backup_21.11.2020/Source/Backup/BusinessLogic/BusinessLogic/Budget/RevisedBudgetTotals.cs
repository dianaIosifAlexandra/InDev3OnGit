using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// Contains all columns in all 3 grids of revised budget. Here, the totals will be held for revised budget.
    /// </summary>
    public class RevisedBudgetTotals
    {
        #region Members
        private int _CurrentHours;

        public int CurrentHours
        {
            get { return _CurrentHours; }
            set { _CurrentHours = value; }
        }

        private int _UpdateHours;

        public int UpdateHours
        {
            get { return _UpdateHours; }
            set { _UpdateHours = value; }
        }

        private int _NewHours;

        public int NewHours
        {
            get { return _NewHours; }
            set { _NewHours = value; }
        }

        private decimal _CurrentVal;

        public decimal CurrentVal
        {
            get { return _CurrentVal; }
            set { _CurrentVal = value; }
        }

        private decimal _UpdateVal;

        public decimal UpdateVal
        {
            get { return _UpdateVal; }
            set { _UpdateVal = value; }
        }

        private decimal _NewVal;

        public decimal NewVal
        {
            get { return _NewVal; }
            set { _NewVal = value; }
        }

        private decimal _CurrentCosts;

        public decimal CurrentCosts
        {
            get { return _CurrentCosts; }
            set { _CurrentCosts = value; }
        }

        private decimal _UpdateCosts;

        public decimal UpdateCosts
        {
            get { return _UpdateCosts; }
            set { _UpdateCosts = value; }
        }

        private decimal _NewCosts;

        public decimal NewCosts
        {
            get { return _NewCosts; }
            set { _NewCosts = value; }
        }

        private decimal _CurrentSales;

        public decimal CurrentSales
        {
            get { return _CurrentSales; }
            set { _CurrentSales = value; }
        }

        private decimal _UpdateSales;

        public decimal UpdateSales
        {
            get { return _UpdateSales; }
            set { _UpdateSales = value; }
        }

        private decimal _NewSales;

        public decimal NewSales
        {
            get { return _NewSales; }
            set { _NewSales = value; }
        }

        private int _TotalHours;

        public int TotalHours
        {
            get { return _TotalHours; }
            set { _TotalHours = value; }
        }

        private decimal _Averate;

        public decimal Averate
        {
            get { return _Averate; }
            set { _Averate = value; }
        }

        private decimal _ValHours;

        public decimal ValHours
        {
            get { return _ValHours; }
            set { _ValHours = value; }
        }

        private decimal _OtherCosts;

        public decimal OtherCosts
        {
            get { return _OtherCosts; }
            set { _OtherCosts = value; }
        }

        private decimal _Sales;

        public decimal Sales
        {
            get { return _Sales; }
            set { _Sales = value; }
        }

        private decimal _NetCosts;

        public decimal NetCosts
        {
            get { return _NetCosts; }
            set { _NetCosts = value; }
        }
        #endregion Members

        #region Public Methods
        /// <summary>
        /// Builds the totals for the hours tab
        /// </summary>
        /// <param name="tblHours">the phases table from the hours dataset</param>
        public void BuildHoursTotal(DataTable tblHours)
        {
            try
            {
                _CurrentHours = 0;
                _UpdateHours = 0;
                _NewHours = 0;
                _CurrentVal = 0;
                _UpdateVal = 0;
                _NewVal = 0;

                bool isCurrentHoursNull = true;
                bool isUpdateHoursNull = true;
                bool isNewHoursNull = true;
                bool isCurrentValNull = true;
                bool isUpdateValNull = true;
                bool isNewValNull = true;

                foreach (DataRow row in tblHours.Rows)
                {
                    if (row["CurrentHours"] != DBNull.Value)
                    {
                        _CurrentHours += (int)row["CurrentHours"];
                        isCurrentHoursNull = false;
                    }

                    if (row["UpdateHours"] != DBNull.Value)
                    {
                        _UpdateHours += (int)row["UpdateHours"];
                        isUpdateHoursNull = false;
                    }

                    if (row["NewHours"] != DBNull.Value)
                    {
                        _NewHours += (int)row["NewHours"];
                        isNewHoursNull = false;
                    }

                    if (row["CurrentVal"] != DBNull.Value)
                    {
                        _CurrentVal += (decimal)row["CurrentVal"];
                        isCurrentValNull = false;
                    }

                    if (row["UpdateVal"] != DBNull.Value)
                    {
                        _UpdateVal += (decimal)row["UpdateVal"];
                        isUpdateValNull = false;
                    }

                    if (row["NewVal"] != DBNull.Value)
                    {
                        _NewVal += (decimal)row["NewVal"];
                        isNewValNull = false;
                    }
                }

                if (isCurrentHoursNull)
                    _CurrentHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;

                if (isUpdateHoursNull)
                    _UpdateHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;

                if (isNewHoursNull)
                    _NewHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;

                if (isCurrentValNull)
                    _CurrentVal = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isUpdateValNull)
                    _UpdateVal = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isNewValNull)
                    _NewVal = ApplicationConstants.DECIMAL_NULL_VALUE;

            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Builds the totals for the costs tab
        /// </summary>
        /// <param name="tblCosts">the phases table from the costs dataset</param>
        public void BuildCostsTotal(DataTable tblCosts)
        {
            try
            {
                _CurrentCosts = 0;
                _UpdateCosts = 0;
                _NewCosts = 0;
                _CurrentSales = 0;
                _UpdateSales = 0;
                _NewSales = 0;

                bool isCurrentCostsNull = true;
                bool isUpdateCostsNull = true;
                bool isNewCostsNull = true;
                bool isCurrentSalesNull = true;
                bool isUpdateSalesNull = true;
                bool isNewSalesNull = true;

                foreach (DataRow row in tblCosts.Rows)
                {
                    if (row["CurrentCost"] != DBNull.Value)
                    {
                        _CurrentCosts += (decimal)row["CurrentCost"];
                        isCurrentCostsNull = false;
                    }

                    if (row["UpdateCost"] != DBNull.Value)
                    {
                        _UpdateCosts += (decimal)row["UpdateCost"];
                        isUpdateCostsNull = false;
                    }

                    if (row["NewCost"] != DBNull.Value)
                    {
                        _NewCosts += (decimal)row["NewCost"];
                        isNewCostsNull = false;
                    }

                    if (row["CurrentSales"] != DBNull.Value)
                    {
                        _CurrentSales += (decimal)row["CurrentSales"];
                        isCurrentSalesNull = false;
                    }

                    if (row["UpdateSales"] != DBNull.Value)
                    {
                        _UpdateSales += (decimal)row["UpdateSales"];
                        isUpdateSalesNull = false;
                    }

                    if (row["NewSales"] != DBNull.Value)
                    {
                        _NewSales += (decimal)row["NewSales"];
                        isNewSalesNull = false;
                    }
                }

                if (isCurrentCostsNull)
                    _CurrentCosts = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isUpdateCostsNull)
                    _UpdateCosts = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isNewCostsNull)
                    _NewCosts = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isCurrentSalesNull)
                    _CurrentSales = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isUpdateSalesNull)
                    _UpdateSales = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isNewSalesNull)
                    _NewSales = ApplicationConstants.DECIMAL_NULL_VALUE;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Builds the totals for the costs tab
        /// </summary>
        /// <param name="tblSummary">the phases table from the summary dataset</param>
        public void BuildSummaryTotal(DataTable tblSummary)
        {
            try
            {
                _TotalHours = 0;
                _Averate = 0;
                _ValHours = 0;
                _OtherCosts = 0;
                _Sales = 0;
                _NetCosts = 0;

                bool isTotalHoursNull = true;
                bool isValHoursNull = true;
                bool isOtherCostsNull = true;
                bool isSalesNull = true;
                bool isNetCostsNull = true;

                foreach (DataRow row in tblSummary.Rows)
                {
                    if (row["TotHours"] != DBNull.Value)
                    {
                        _TotalHours += (int)row["TotHours"];
                        isTotalHoursNull = false;
                    }

                    if (row["ValHours"] != DBNull.Value)
                    {
                        _ValHours += (decimal)row["ValHours"];
                        isValHoursNull = false;
                    }

                    if (row["OtherCost"] != DBNull.Value)
                    {
                        _OtherCosts += (decimal)row["OtherCost"];
                        isOtherCostsNull = false;
                    }

                    if (row["Sales"] != DBNull.Value)
                    {
                        _Sales += (decimal)row["Sales"];
                        isSalesNull = false;
                    }

                    if (row["NetCost"] != DBNull.Value)
                    {
                        _NetCosts += (decimal)row["NetCost"];
                        isNetCostsNull = false;
                    }
                }

                if (isTotalHoursNull)
                    _TotalHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;

                if (isValHoursNull)
                    _ValHours = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isOtherCostsNull)
                    _OtherCosts = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isSalesNull)
                    _Sales = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isNetCostsNull)
                    _NetCosts = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isValHoursNull || isTotalHoursNull)
                {
                    _Averate = ApplicationConstants.DECIMAL_NULL_VALUE;
                }
                else
                {
                    if (_TotalHours == 0)
                    {
                        _Averate = ApplicationConstants.DECIMAL_NULL_VALUE;
                    }
                    else
                    {
                        _Averate = Rounding.Round(Decimal.Divide(_ValHours, _TotalHours));
                    }
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
