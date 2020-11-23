using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.Entities;
using System.Data;

namespace Inergy.Indev3.DataAccess.AnnualBudget
{
    public class DBAnnualDataStatus : DBGenericEntity
    {
        public DBAnnualDataStatus(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IAnnualDataStatus)
            {
                IAnnualDataStatus dataStatus = (IAnnualDataStatus)ent;

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "abgtSelectAnnualDataStatus";
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }
}
