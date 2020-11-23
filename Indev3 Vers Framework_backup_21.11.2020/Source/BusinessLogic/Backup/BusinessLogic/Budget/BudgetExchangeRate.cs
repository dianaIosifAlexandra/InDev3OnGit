using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    internal class BudgetExchangeRate
    {
        public YearMonth YearMonth;
        public int CurrencyFrom;
        public int CurrencyTo;
        public decimal ExchangeRateValue;

        /// <summary>
        /// Compares the current object with another object
        /// </summary>
        /// <param name="secondExchangeRate">The object to compare with</param>
        /// <returns></returns>
        internal bool CompareWithObject(BudgetExchangeRate secondExchangeRate)
        {
            //All fields except ExchangeRateValue should be the same (no matter in what order)
            if (this.YearMonth.GetMonthsDiffrence(secondExchangeRate.YearMonth) != 0)
                return false;
            if ((this.CurrencyFrom == secondExchangeRate.CurrencyFrom) && (this.CurrencyTo == secondExchangeRate.CurrencyTo))
                return true;
            if ((this.CurrencyFrom == secondExchangeRate.CurrencyTo) && (this.CurrencyTo == secondExchangeRate.CurrencyFrom))
                return true;

            return false;
        }
    }
}
