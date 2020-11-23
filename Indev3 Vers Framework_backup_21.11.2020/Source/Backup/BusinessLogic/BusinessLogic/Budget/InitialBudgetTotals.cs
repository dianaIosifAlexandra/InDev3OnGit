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
    /// This class holds the total amounts for initial budget
    /// </summary>
    public class InitialBudgetTotals
    {
        #region Members
        private int _TotalHours;
        /// <summary>
        /// Holds the total for the Total Hours Property
        /// </summary>
        public int TotalHours
        {
            get { return _TotalHours; }
            set { _TotalHours = value; }
        }

        private decimal _Avertate;
        /// <summary>
        /// Holds the total for the Avertate Property
        /// </summary>
        public decimal Avertate
        {
            get { return _Avertate; }
            set { _Avertate = value; }
        }

        private decimal _ValHours;
        /// <summary>
        /// Holds the total for the Value Hours Property
        /// </summary>
        public decimal ValHours
        {
            get { return _ValHours; }
            set { _ValHours = value; }
        }

        private decimal _OtherCosts;
        /// <summary>
        /// Holds the total for the Other Costs Property
        /// </summary>
        public decimal OtherCosts
        {
            get { return _OtherCosts; }
            set { _OtherCosts = value; }
        }

        private decimal _Sales;
        /// <summary>
        /// Holds the total for the Sales Property
        /// </summary>
        public decimal Sales
        {
            get { return _Sales; }
            set { _Sales = value; }
        }

        private decimal _NetCosts;
        /// <summary>
        /// Holds the total for the Net Costs Property
        /// </summary>
        public decimal NetCosts
        {
            get { return _NetCosts; }
            set { _NetCosts = value; }
        }
        #endregion Members

        #region Constructors
        /// <summary>
        /// Constructs the object using a given table
        /// </summary>
        /// <param name="table">the Master table that contains the values at the phases level </param>
        public InitialBudgetTotals(DataTable table)
        {
            try
            {
                //Initialize the properties values
                _TotalHours = 0;
                _Avertate = 0;
                _ValHours = 0;
                _OtherCosts = 0;
                _Sales = 0;
                _NetCosts = 0;

                bool isHoursNull = true;
                bool isValHoursNull = true;
                bool isOtherCostsNull = true;
                bool isSalesNull = true;
                bool isNetCostsNull = true;

                //Cycle through each row of the data table
                foreach (DataRow row in table.Rows)
                {
                    if (row["TotalHours"] != DBNull.Value)
                    {
                        _TotalHours += (int)row["TotalHours"];
                        isHoursNull = false;
                    }
                    
                    if (row["ValuedHours"] != DBNull.Value)
                    {
                        _ValHours += (decimal)row["ValuedHours"];
                        isValHoursNull = false;
                    }
                    if (row["OtherCosts"] != DBNull.Value)
                    {
                        _OtherCosts += (decimal)row["OtherCosts"];
                        isOtherCostsNull = false;
                    }
                    if (row["Sales"] != DBNull.Value)
                    {
                        _Sales += (decimal)row["Sales"];
                        isSalesNull = false;
                    }
                    if (row["NetCosts"] != DBNull.Value)
                    {
                        _NetCosts += (decimal)row["NetCosts"];
                        isNetCostsNull = false;
                    }
                }

                if (isHoursNull)
                    _TotalHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;

                if (isValHoursNull)
                    _ValHours = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isOtherCostsNull)
                    _OtherCosts = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isSalesNull)
                    _Sales = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isNetCostsNull)
                    _NetCosts = ApplicationConstants.DECIMAL_NULL_VALUE;

                if (isValHoursNull || isHoursNull)
                {
                    _Avertate = ApplicationConstants.DECIMAL_NULL_VALUE;
                }
                else
                {
                    if (_TotalHours == 0)
                    {
                        _Avertate = ApplicationConstants.DECIMAL_NULL_VALUE;
                    }
                    else
                    {
                        _Avertate = Rounding.Round(Decimal.Divide(_ValHours, _TotalHours));
                    }
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion Constructors
    }
}
