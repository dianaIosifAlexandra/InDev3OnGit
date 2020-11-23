using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.DataAccess;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// Class that holds
    /// </summary>
    internal class ExchangeRateCache
    {
        #region Members
        private object connectionManager;
        //These are properties created to hold the Currency and YearMonth for the object budgetExchangeRate
        private List<BudgetExchangeRate> exchangeRatesCache = new List<BudgetExchangeRate>();
        #endregion Members

        #region Constructors
        public ExchangeRateCache(object connectionManager)
        {
            this.connectionManager = connectionManager;
        }
        #endregion Constructors

        #region Internal Methods
        /// <summary>
        /// Returns the exchange Rate value from the cache. If it does not exist it gets it from the database
        /// and inset it into cache
        /// </summary>
        /// <param name="exchangeRate">The exchange rate containing the logical key</param>
        /// <returns>The exchange rate value</returns>
        internal decimal GetExchangeRate(BudgetExchangeRate exchangeRate)
        {
            //Search the cache to see if the exchange rate exists in cache
            foreach (BudgetExchangeRate currentExchangeRate in exchangeRatesCache)
            {
                //If it is found return the value from the cache
                if (currentExchangeRate.CompareWithObject(exchangeRate))
                {
                    //the object exists in cache but we don't know yet in what order
                    if (currentExchangeRate.CurrencyFrom == exchangeRate.CurrencyFrom)
                        return currentExchangeRate.ExchangeRateValue;
                    else
                        return Decimal.Divide(1, currentExchangeRate.ExchangeRateValue);
                }
            }
            //If the code reaches this point, it means that the exchange rate doesn't exists in the cache
            //so it should be load from the dabase
            decimal exRateValue = (new ExchangeRateReader(this.connectionManager)).GetExchangeRate(exchangeRate);
            //After received from the database insert into the cache before return it
            exchangeRate.ExchangeRateValue = exRateValue;
            this.InsertExchangeRateToCache(exchangeRate);
            //Return the exchange Rate value
            return exRateValue;
        }

        /// <summary>
        /// Adds a given exchange rate into cache
        /// </summary>
        /// <param name="exRate">The exchange rate object</param>
        internal void InsertExchangeRateToCache(BudgetExchangeRate exRate)
        {
            bool found = false;
            //Insert the budget exchange rate into the cache only if it is not already in the cache
            foreach (BudgetExchangeRate rate in exchangeRatesCache)
            {
                if (exRate.CompareWithObject(rate))
                {
                    found = true;
                    break;
                }
            }
            if (!found)
            {
                exchangeRatesCache.Add(exRate);
            }
        }
        #endregion Internal Methods
    }
}
