using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Upload;
using Inergy.Indev3.Entities;
using System.Data;

namespace Inergy.Indev3.DataAccess.Upload
{
    public class DBDataLogs : DBGenericEntity 
    {
        public DBDataLogs(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IDataLogs)
            {
                IDataLogs dataLogs = (IDataLogs)ent;

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "impSelectDataLogs";
                if(!string.IsNullOrEmpty(dataLogs.CountryCode))
                    spSelect.AddParameter(new DBParameter("@CountryCode", DbType.String, ParameterDirection.Input, dataLogs.CountryCode));
                else
                    spSelect.AddParameter(new DBParameter("@CountryCode", DbType.String, ParameterDirection.Input, DBNull.Value));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spGetDetail = new DBStoredProcedure();
                spGetDetail.ProcedureName = "impSelectDataLogsDetail";
                spGetDetail.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, dataLogs.IdImport));
                this.AddStoredProcedure("GetDataLogsDetail", spGetDetail);

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "impDeleteImport";
                spDelete.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, dataLogs.IdImport));
                this.AddStoredProcedure("DeleteObject", spDelete);
            }
        }
    }
}
