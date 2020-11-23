using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBHourlyRate : DBGenericEntity
    {
        public DBHourlyRate(object connectionManager)
            : base(connectionManager)
        {
        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IHourlyRate)
            {
                IHourlyRate HourlyRate = (IHourlyRate)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertHourlyRate";
                spInsert.AddParameter(new DBParameter("YearMonth", DbType.Int32, ParameterDirection.Input, 
                    (HourlyRate.YearMonth == ApplicationConstants.INT_NULL_VALUE) ? (object)DBNull.Value : (object)HourlyRate.YearMonth));
                //spInsert.AddParameter(new DBParameter("IdCurrency", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCurrency));
                spInsert.AddParameter(new DBParameter("IdCostCenter", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCostCenter));
                spInsert.AddParameter(new DBParameter("Value", DbType.Decimal, ParameterDirection.Input, HourlyRate.Value));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateHourlyRate";
                spUpdate.AddParameter(new DBParameter("YearMonth", DbType.Int32, ParameterDirection.Input,
                    (HourlyRate.YearMonth == ApplicationConstants.INT_NULL_VALUE) ? (object)DBNull.Value : (object)HourlyRate.YearMonth));
                //spUpdate.AddParameter(new DBParameter("IdCurrency", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCurrency));
                spUpdate.AddParameter(new DBParameter("IdCostCenter", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCostCenter));
                spUpdate.AddParameter(new DBParameter("Value", DbType.Decimal, ParameterDirection.Input, HourlyRate.Value));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteHourlyRate";
                spDelete.AddParameter(new DBParameter("YearMonth", DbType.Int32, ParameterDirection.Input,
                    (HourlyRate.YearMonth == ApplicationConstants.INT_NULL_VALUE) ? (object)DBNull.Value : (object)HourlyRate.YearMonth));
                //spDelete.AddParameter(new DBParameter("IdCurrency", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCurrency));
                spDelete.AddParameter(new DBParameter("IdCostCenter", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCostCenter));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectHourlyRate";
                spSelect.AddParameter(new DBParameter("YearMonth", DbType.Int32, ParameterDirection.Input,
                    (HourlyRate.YearMonth == ApplicationConstants.INT_NULL_VALUE) ? (object)DBNull.Value : (object)HourlyRate.YearMonth));
                //spSelect.AddParameter(new DBParameter("IdCurrency", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCurrency));
                spSelect.AddParameter(new DBParameter("IdCostCenter", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCostCenter));
                spSelect.AddParameter(new DBParameter("IdCountry", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCountry));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spMassAttribution = new DBStoredProcedure();
                spMassAttribution.ProcedureName = "catMassInsertOrUpdateHourlyRate";
                spMassAttribution.AddParameter(new DBParameter("IdInergyLocation", DbType.Int32, ParameterDirection.Input, HourlyRate.IdInergyLocation));
                //spMassAttribution.AddParameter(new DBParameter("IdCurrency", DbType.Int32, ParameterDirection.Input, HourlyRate.IdCurrency));
                spMassAttribution.AddParameter(new DBParameter("StartYearMonth", DbType.Int32, ParameterDirection.Input,
                    (HourlyRate.StartYearMonth == ApplicationConstants.INT_NULL_VALUE) ? (object)DBNull.Value : (object)HourlyRate.StartYearMonth));
                spMassAttribution.AddParameter(new DBParameter("EndYearMonth", DbType.Int32, ParameterDirection.Input,
                    (HourlyRate.EndYearMonth == ApplicationConstants.INT_NULL_VALUE) ? (object)DBNull.Value : (object)HourlyRate.EndYearMonth));
                spMassAttribution.AddParameter(new DBParameter("Value", DbType.Decimal, ParameterDirection.Input, HourlyRate.Value));
                this.AddStoredProcedure("MassAttribution", spMassAttribution);
            }
        }
    }
}
