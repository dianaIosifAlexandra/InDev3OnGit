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
    public class DBCostCenterFilter : DBGenericEntity
    {
        public DBCostCenterFilter(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ICostCenterFilter)
            {
                ICostCenterFilter costCenterFilter = (ICostCenterFilter)ent;
                DBStoredProcedure spSelectCountry = new DBStoredProcedure();
                spSelectCountry.ProcedureName = "fltCostCenterFilterCountries";
                spSelectCountry.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, costCenterFilter.IdCountry));
                this.AddStoredProcedure("SelectCountry", spSelectCountry);

                DBStoredProcedure spSelectInergyLocation = new DBStoredProcedure();
                spSelectInergyLocation.ProcedureName = "fltCostCenterFilterInergyLocations";
                spSelectInergyLocation.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, costCenterFilter.IdCountry));
                this.AddStoredProcedure("SelectInergyLocation", spSelectInergyLocation);

                DBStoredProcedure spSelectFunction = new DBStoredProcedure();
                spSelectFunction.ProcedureName = "fltCostCenterFilterFunctions";
                this.AddStoredProcedure("SelectFunction", spSelectFunction);

                DBStoredProcedure spSelectCostCenter = new DBStoredProcedure();
                spSelectCostCenter.ProcedureName = "fltCostCenterFilterCostCenters";
                spSelectCostCenter.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, costCenterFilter.IdCountry));
                spSelectCostCenter.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, costCenterFilter.IdInergyLocation));
                spSelectCostCenter.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, costCenterFilter.IdFunction));
                this.AddStoredProcedure("SelectCostCenter", spSelectCostCenter);
            }
        }
    }

}
