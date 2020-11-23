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
    public class DBTimingAndInterco : DBGenericEntity
    {
        public DBTimingAndInterco(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ITimingAndInterco)
            {
                ITimingAndInterco timingAndInterco = (ITimingAndInterco)ent;

                DBStoredProcedure spGetPeriodAfectation = new DBStoredProcedure();
                spGetPeriodAfectation.ProcedureName = "bgtGetAffectedWPTiming";
                spGetPeriodAfectation.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdProject));
                this.AddStoredProcedure("GetAffectedWPTiming", spGetPeriodAfectation);

                DBStoredProcedure spGetWPTiming = new DBStoredProcedure();
                spGetWPTiming.ProcedureName = "bgtGetWPTiming";
                spGetWPTiming.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdProject));
                spGetWPTiming.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdPhase));
                spGetWPTiming.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdWP));
                spGetWPTiming.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdAssociate));
                this.AddStoredProcedure("GetWPTiming", spGetWPTiming);

                DBStoredProcedure spGetWPInterco = new DBStoredProcedure();
                spGetWPInterco.ProcedureName = "bgtGetAffectedWPInterco";
                spGetWPInterco.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdProject));
                this.AddStoredProcedure("GetAffectedWPInterco", spGetWPInterco);

                DBStoredProcedure spGetUnaffectedWP = new DBStoredProcedure();
                spGetUnaffectedWP.ProcedureName = "bgtGetUnaffectedWP";
                spGetUnaffectedWP.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdProject));
                this.AddStoredProcedure("GetUnaffectedWP", spGetUnaffectedWP);

                DBStoredProcedure spGetWPIntercoCountries = new DBStoredProcedure();
                spGetWPIntercoCountries.ProcedureName = "bgtGetWPIntercoCountries";
                spGetWPIntercoCountries.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdProject));
                this.AddStoredProcedure("GetWPIntercoCountries", spGetWPIntercoCountries);

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "bgtUpdateWPTiming";
                spUpdate.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdProject));
                spUpdate.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdPhase));
                spUpdate.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdWP));
                spUpdate.AddParameter(new DBParameter("@StartYearMonth", DbType.Int32, ParameterDirection.Input, timingAndInterco.StartYearMonth));
                spUpdate.AddParameter(new DBParameter("@EndYearMonth", DbType.Int32, ParameterDirection.Input, timingAndInterco.EndYearMonth));
                spUpdate.AddParameter(new DBParameter("@LastUserUpdate", DbType.Int32, ParameterDirection.Input, timingAndInterco.LastUserUpdate));
                if (string.IsNullOrEmpty(timingAndInterco.WPCode))
                    spUpdate.AddParameter(new DBParameter("@WPCode", DbType.String, ParameterDirection.Input, DBNull.Value));
                else
                    spUpdate.AddParameter(new DBParameter("@WPCode", DbType.String, ParameterDirection.Input, timingAndInterco.WPCode));
                this.AddStoredProcedure("UpdateObject", spUpdate);

                DBStoredProcedure sdDelete = new DBStoredProcedure();
                sdDelete.ProcedureName = "bgtDeleteWPTimingAndInterco";
                sdDelete.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdProject));
                sdDelete.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdPhase));
                sdDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, timingAndInterco.IdWP));
                this.AddStoredProcedure("DeleteObject", sdDelete);
            }
        }
    }

    public class DBIntercoCountry : DBGenericEntity
    {
        public DBIntercoCountry(object connectionManager)
            : base(connectionManager)
        {

        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IIntercoCountry)
            {
                IIntercoCountry country = (IIntercoCountry)ent;

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "bgtUpdateWPInterco";
                spUpdate.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, country.IdProject));
                spUpdate.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, country.IdPhase));
                spUpdate.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, country.IdWP));
                spUpdate.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, country.IdCountry));
                if (country.Percent != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdate.AddParameter(new DBParameter("@Percent", DbType.Decimal, ParameterDirection.Input, country.Percent));
                else
                    spUpdate.AddParameter(new DBParameter("@Percent", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                if(string.IsNullOrEmpty(country.WPCode))
                    spUpdate.AddParameter(new DBParameter("@WPCode", DbType.String, ParameterDirection.Input, DBNull.Value));
                else
                    spUpdate.AddParameter(new DBParameter("@WPCode", DbType.String, ParameterDirection.Input, country.WPCode));
                this.AddStoredProcedure("UpdateObject", spUpdate);

                DBStoredProcedure spDeleteLayout = new DBStoredProcedure();
                spDeleteLayout.ProcedureName = "bgtDeleteIntercoCountryLayout";
                spDeleteLayout.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, country.IdProject));
                this.AddStoredProcedure("DeleteCountryLayout", spDeleteLayout);

                DBStoredProcedure spInsertLayout = new DBStoredProcedure();
                spInsertLayout.ProcedureName = "bgtInsertIntercoCountryLayout";
                spInsertLayout.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, country.IdProject));
                spInsertLayout.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, country.IdCountry));
                spInsertLayout.AddParameter(new DBParameter("@Position", DbType.Int32, ParameterDirection.Input, country.Position));
                this.AddStoredProcedure("InsertCountryLayout", spInsertLayout);
            }

        }
    }
}
