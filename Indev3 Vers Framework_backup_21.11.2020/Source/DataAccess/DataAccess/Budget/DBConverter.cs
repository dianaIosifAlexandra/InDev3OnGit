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
    public class DBConverter : DBGenericEntity
    {
        public DBConverter(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IConverter)
            {
                IConverter converter = (IConverter)ent;
                DBStoredProcedure spSelectExchangeRate = new DBStoredProcedure();
                spSelectExchangeRate.ProcedureName = "bgtSelectExchangeRateForConverter";
                spSelectExchangeRate.AddParameter(new DBParameter("@Currency", DbType.Int32, ParameterDirection.Input, converter.Currency));
                spSelectExchangeRate.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, converter.YearMonth));
                this.AddStoredProcedure("bgtSelectExchangeRateForConverter", spSelectExchangeRate);
            }
        }
    }
}
