using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class CurrencyConverter : GenericEntity, ICurrencyConverter
    {
        #region Properties

        private ExchangeRateCache ExchangeRateCache;

        private int _CurrencyFrom;
        public int CurrencyFrom
        {
            get
            { return _CurrencyFrom; }
            set
            { _CurrencyFrom = value; }
        }
        private int _CurrencyTo;
        public int CurrencyTo
        {
            get
            { return _CurrencyTo; }
            set
            { _CurrencyTo = value; }
        }
        private YearMonth _StartYearMonth;
        public YearMonth StartYearMonth
        {
            get
            { return _StartYearMonth; }
            set
            { _StartYearMonth = value; }
        }
        private YearMonth _EndYearMonth;
        public YearMonth EndYearMonth
        {
            get
            { return _EndYearMonth; }
            set
            { _EndYearMonth = value; }
        }

        #endregion Properties
                           
        #region Constructors
        public CurrencyConverter(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBCurrencyConverter(connectionManager));

            ExchangeRateCache = new ExchangeRateCache(connectionManager);
        }
        #endregion Constructors

        #region Public Methods
        /// <summary>
        /// Fills the cache with Exchange Rates for the given parameters
        /// </summary>
        /// <param name="startYearMonth">The start yearmonth</param>
        /// <param name="endYearMonth">The endyearmonth</param>
        /// <param name="currencyFrom">The CurrencyFrom</param>
        /// <param name="currencyTo">The CurrencyTo</param>
        public void FillExchangeRateCache(YearMonth startYearMonth, YearMonth endYearMonth, int currencyFrom, int currencyTo)
        {
            try
            {
                this._StartYearMonth = startYearMonth;
                this._EndYearMonth = endYearMonth;
                this._CurrencyFrom = currencyFrom;
                this._CurrencyTo = currencyTo;

                //TODO: Unit test this method
                DataTable tableExchangeRates = (this.GetEntity().GetCustomDataSet("FillExchangeRateCache", this)).Tables[0];

                foreach (DataRow row in tableExchangeRates.Rows)
                {
                    //Gets the exchange rate from the datarow
                    BudgetExchangeRate exchangeRate = new BudgetExchangeRate();
                    exchangeRate.CurrencyFrom = currencyFrom;
                    exchangeRate.CurrencyTo = currencyTo;
                    exchangeRate.YearMonth = new YearMonth((int)row["YearMonth"]);
                    exchangeRate.ExchangeRateValue = (decimal)row["ExchangeRateValue"];
                    //Add the exchange rate to cache
                    ExchangeRateCache.InsertExchangeRateToCache(exchangeRate);
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion Public Methods

        #region Internal Methods
        /// <summary>
        /// Get the new value expressed in the new currency
        /// </summary>
        /// <param name="originalValue">the giveen amount expressd in the currencyFrom currency</param>
        /// <param name="currencyFrom">The currency for the received amount of money</param>
        /// <param name="yearmonth">The yearmonth that will be used the get the new value</param>
        /// <param name="currencyTo">The currency that will be used to return the new amount of money</param>
        /// <returns>the new amount of money expressed in the currencyTo currency</returns>
        internal decimal GetConversionValue(decimal originalValue, int currencyFrom, YearMonth yearmonth, int currencyTo)
        {
            if (originalValue == 0)
                return 0;

            if (originalValue == ApplicationConstants.DECIMAL_NULL_VALUE)
                return ApplicationConstants.DECIMAL_NULL_VALUE;

            //Constructs a new exhcange rate object with the given logical key
            BudgetExchangeRate exchangeRate = new BudgetExchangeRate();
            exchangeRate.CurrencyFrom = currencyFrom;
            exchangeRate.CurrencyTo = currencyTo;
            exchangeRate.YearMonth = yearmonth;

            //Get the currency rate
            decimal currencyRate = this.ExchangeRateCache.GetExchangeRate(exchangeRate);

            //Get the converted value
            decimal  convertedValue = Decimal.Multiply(originalValue, currencyRate);

            //return the converted value
            return convertedValue;
        }
        #endregion Internal Methods

    }
}
