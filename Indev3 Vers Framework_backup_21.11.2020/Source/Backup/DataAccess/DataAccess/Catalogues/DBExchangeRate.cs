using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBExchangeRate : DBGenericEntity
    {
        public DBExchangeRate(object connectionManager)
            : base(connectionManager)
        {
        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IExchangeRate)
            {
                IExchangeRate ExchangeRate = (IExchangeRate)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertExchangeRate";
                spInsert.AddParameter(new DBParameter("Year", DbType.Int32, ParameterDirection.Input, ExchangeRate.Year));
                spInsert.AddParameter(new DBParameter("Month", DbType.Int32, ParameterDirection.Input, ExchangeRate.Month));
                spInsert.AddParameter(new DBParameter("IdCurrencyTo", DbType.Int32, ParameterDirection.Input, ExchangeRate.IdCurrencyTo));
                spInsert.AddParameter(new DBParameter("ConversionRate", DbType.Decimal, ParameterDirection.Input, ExchangeRate.ConversionRate));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateExchangeRate";
                spUpdate.AddParameter(new DBParameter("Id", DbType.Int32, ParameterDirection.Input, ExchangeRate.Id));
                spUpdate.AddParameter(new DBParameter("Year", DbType.Int32, ParameterDirection.Input, ExchangeRate.Year));
                spUpdate.AddParameter(new DBParameter("Month", DbType.Int32, ParameterDirection.Input, ExchangeRate.Month));
                spUpdate.AddParameter(new DBParameter("IdCurrencyTo", DbType.Int32, ParameterDirection.Input, ExchangeRate.IdCurrencyTo));
                spUpdate.AddParameter(new DBParameter("ConversionRate", DbType.Decimal, ParameterDirection.Input, ExchangeRate.ConversionRate));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteExchangeRate";
                spDelete.AddParameter(new DBParameter("Id", DbType.Int32, ParameterDirection.Input, ExchangeRate.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectExchangeRate";
                spSelect.AddParameter(new DBParameter("Id", DbType.Int32, ParameterDirection.Input, ExchangeRate.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }
}


