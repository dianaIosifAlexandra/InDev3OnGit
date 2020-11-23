using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Upload;
using Inergy.Indev3.Entities;
using System.Data;

namespace Inergy.Indev3.DataAccess.Upload
{
    public class DBDataStatus : DBGenericEntity 
    {
        public DBDataStatus(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IDataStatus)
            {
                IDataStatus dataStatus = (IDataStatus)ent;

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "impSelectDataStatus";
                spSelect.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, dataStatus.Year));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }
}
