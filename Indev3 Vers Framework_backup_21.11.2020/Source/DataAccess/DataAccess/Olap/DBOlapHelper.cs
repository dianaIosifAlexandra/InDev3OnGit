using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Olap;
using System.Data;

namespace Inergy.Indev3.DataAccess.Olap
{
    public class DBOlapHelper : DBGenericEntity
    {
        public DBOlapHelper(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IOlapHelper)
            {
                IOlapHelper olapHelper = (IOlapHelper)ent;
                DBStoredProcedure spUpdateEndYear = new DBStoredProcedure();
                spUpdateEndYear.ProcedureName = "olapUpdateOlapPeriods";
                this.AddStoredProcedure("UpdateOlapPeriods", spUpdateEndYear);
            }
        }
    }
}
