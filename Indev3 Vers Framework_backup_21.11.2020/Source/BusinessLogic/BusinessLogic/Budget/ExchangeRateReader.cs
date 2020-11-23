using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    internal class ExchangeRateReader : GenericEntity, IExchangeRateReader
    {
        //These are properties created to hold the Currency and YearMonth for the object budgetExchangeRate

        #region Properties Declaration

        private int _CurrencyFrom;
        public int CurrencyFrom
        {
            get { return _CurrencyFrom; }
            set { _CurrencyFrom = value; }
        }
        private int _CurrencyTo;
        public int CurrencyTo
        {
            get { return _CurrencyTo; }
            set { _CurrencyTo = value; }
        }
        private YearMonth _YearMonth;
        public YearMonth YearMonth
        {
            get { return _YearMonth; }
            set { _YearMonth = value; }
        }

        #endregion Properties Declaration

        #region Declaration Of private Variables

        //This is used to hold the newly returned Exchange Rate from the DataBase
        private decimal ExchangeRate;
        #endregion

        #region Constructors

        public ExchangeRateReader(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBExchangeRateReader(connectionManager));
            _CurrencyFrom = ApplicationConstants.INT_NULL_VALUE;
            _CurrencyTo = ApplicationConstants.INT_NULL_VALUE;
        }

        public ExchangeRateReader(DataRow row, object connectionManager)
            : this(connectionManager)
        {
            throw new NotSupportedException("BudgetExchangeRate: Constructor is not supported"); 
        }

        #endregion

        protected override void Row2Object(DataRow row)
        {
            throw new NotSupportedException("BudgetExchangeRate: Row2Object is not supported"); 
        }

        /// <summary>
        /// This method returns the exchange rate from the base based on to parameters: Currency and 
        /// YearMonth; To be known that inside stored procedure two other rules for selecting this ExchangeRate
        /// are used. For more information look after Stored Procedure bgtSelectExchangeRateForConverter
        /// </summary>
        /// <param name="exchangeRate"></param>
        /// <returns></returns>
        internal decimal GetExchangeRate(BudgetExchangeRate exchangeRate)
        {
            _CurrencyFrom = exchangeRate.CurrencyFrom;
            _CurrencyTo = exchangeRate.CurrencyTo;
            _YearMonth = exchangeRate.YearMonth;

            DBExchangeRateReader dbc = new DBExchangeRateReader(this.CurrentConnectionManager);
            //If for a random reason the specified cast cannot be made, an IndException is thrown
            try
            {
                object returnedER = dbc.ExecuteScalar("bgtSelectExchangeRateForConverter", this);
                //TODO: Modifiy error message - use names instead of ids
                if (returnedER == DBNull.Value)
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_EXCHANGE_RATE_NOT_FOUND, exchangeRate.CurrencyFrom.ToString(), exchangeRate.CurrencyTo.ToString()));
                ExchangeRate = (decimal)returnedER;
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
            return ExchangeRate;
        }
    }
}
