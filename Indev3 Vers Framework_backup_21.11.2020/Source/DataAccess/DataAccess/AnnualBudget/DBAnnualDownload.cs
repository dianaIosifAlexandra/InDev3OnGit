using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using System.Data;
using Inergy.Indev3.Entities.AnnualBudget;

namespace Inergy.Indev3.DataAccess.AnnualBudget
{
    public class DBAnnualDownload: DBGenericEntity
    {
        public DBAnnualDownload(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IAnnualDownload)
            {
                IAnnualDownload extract = (IAnnualDownload)ent;
                DBStoredProcedure spSelectData = new DBStoredProcedure();
                spSelectData.ProcedureName = "abgtExtractFromReforcastAndActualData";
                spSelectData.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, extract.IdCountry));
                spSelectData.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, extract.IdInergyLocation));
                spSelectData.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extract.Year));
                this.AddStoredProcedure("ExtractFromReforcastAndActualData", spSelectData);
            }
        }
    
    }
}