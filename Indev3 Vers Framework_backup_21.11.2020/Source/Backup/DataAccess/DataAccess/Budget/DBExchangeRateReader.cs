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
    public class DBExchangeRateReader : DBGenericEntity
    {
        public DBExchangeRateReader(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IExchangeRateReader)
            {
                IExchangeRateReader converter = (IExchangeRateReader)ent;
                DBStoredProcedure spSelectExchangeRate = new DBStoredProcedure();
                spSelectExchangeRate.ProcedureName = "bgtSelectExchangeRateForConverter";
                spSelectExchangeRate.AddParameter(new DBParameter("@CurrencyFrom", DbType.Int32, ParameterDirection.Input, converter.CurrencyFrom));
                spSelectExchangeRate.AddParameter(new DBParameter("@CurrencyTo", DbType.Int32, ParameterDirection.Input, converter.CurrencyTo));
                spSelectExchangeRate.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, converter.YearMonth.Value));
                this.AddStoredProcedure("bgtSelectExchangeRateForConverter", spSelectExchangeRate);
            }
        }
    }
}
