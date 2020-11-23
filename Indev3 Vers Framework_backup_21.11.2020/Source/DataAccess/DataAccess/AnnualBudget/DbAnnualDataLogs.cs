using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.Entities;
using System.Data;

namespace Inergy.Indev3.DataAccess.AnnualBudget
{
    public class DbAnnualDataLogs : DBGenericEntity
    {
        public DbAnnualDataLogs(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IAnnualDataLogs)
            {
                IAnnualDataLogs dataLogs = (IAnnualDataLogs)ent;

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "abgtSelectAnnualDataLogs";
                if(string.IsNullOrEmpty(dataLogs.CountryCode))
                    spSelect.AddParameter(new DBParameter("@CountryCode", DbType.String, ParameterDirection.Input, DBNull.Value));
                else
                    spSelect.AddParameter(new DBParameter("@CountryCode", DbType.String, ParameterDirection.Input, dataLogs.CountryCode));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spGetDetail = new DBStoredProcedure();
                spGetDetail.ProcedureName = "abgtSelectAnnualDataLogsDetail";                
                spGetDetail.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, dataLogs.IdImport));
                this.AddStoredProcedure("GetAnnualDataLogsDetail", spGetDetail);

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "abgtDeleteAnnualImport";
                spDelete.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, dataLogs.IdImport));
                this.AddStoredProcedure("DeleteObject", spDelete);
            }
        }
    }
}
