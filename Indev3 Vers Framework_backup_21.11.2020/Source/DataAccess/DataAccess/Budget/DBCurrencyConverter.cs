using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.Entities.Budget;


namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBCurrencyConverter : DBGenericEntity
    {
        public DBCurrencyConverter(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ICurrencyConverter)
            {
                ICurrencyConverter converter = (ICurrencyConverter)ent;
                DBStoredProcedure spFillExchangeRateCache = new DBStoredProcedure();
                spFillExchangeRateCache.ProcedureName = "bgtFillExchangeRateCache";
                spFillExchangeRateCache.AddParameter(new DBParameter("@CurrencyFrom", DbType.Int32, ParameterDirection.Input, converter.CurrencyFrom));
                spFillExchangeRateCache.AddParameter(new DBParameter("@CurrencyTo", DbType.Int32, ParameterDirection.Input, converter.CurrencyTo));
                spFillExchangeRateCache.AddParameter(new DBParameter("@StartYearMonth", DbType.Int32, ParameterDirection.Input, converter.StartYearMonth.Value));
                spFillExchangeRateCache.AddParameter(new DBParameter("@EndYearMonth", DbType.Int32, ParameterDirection.Input, converter.EndYearMonth.Value));
                this.AddStoredProcedure("FillExchangeRateCache", spFillExchangeRateCache);
            }
        }
    }
}
