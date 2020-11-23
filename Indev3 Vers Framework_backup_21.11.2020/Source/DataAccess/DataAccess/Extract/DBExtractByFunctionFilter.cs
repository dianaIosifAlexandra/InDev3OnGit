using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Extract;

namespace Inergy.Indev3.DataAccess.Extract
{
    public class DBExtractByFunctionFilter : DBGenericEntity
    {
        public DBExtractByFunctionFilter(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IExtractByFunctionFilter)
            {
                IExtractByFunctionFilter extractByFunctionFilter = (IExtractByFunctionFilter)ent;

                DBStoredProcedure spSelectRegion = new DBStoredProcedure();
                spSelectRegion.ProcedureName = "extSelectExtractByFunctionFilterRegions";
                spSelectRegion.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdRegion));
                this.AddStoredProcedure("SelectRegion", spSelectRegion);

                DBStoredProcedure spSelectCountriesForRegion = new DBStoredProcedure();
                spSelectCountriesForRegion.ProcedureName = "extSelectExtractByFunctionFilterCountriesForRegion";
                spSelectCountriesForRegion.AddParameter(new DBParameter("@IdRegion", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdRegion));
                this.AddStoredProcedure("SelectCountriesForRegion", spSelectCountriesForRegion);

                DBStoredProcedure spSelectCountry = new DBStoredProcedure();
                spSelectCountry.ProcedureName = "extSelectExtractByFunctionFilterCountries";
                spSelectCountry.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdCountry));
                this.AddStoredProcedure("SelectCountry", spSelectCountry);

                DBStoredProcedure spSelectInergyLocation = new DBStoredProcedure();
                spSelectInergyLocation.ProcedureName = "extSelectExtractByFunctionFilterInergyLocations";
                spSelectInergyLocation.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdCountry));
                this.AddStoredProcedure("SelectInergyLocation", spSelectInergyLocation);

                DBStoredProcedure spSelectFunction = new DBStoredProcedure();
                spSelectFunction.ProcedureName = "extSelectExtractByFunctionFilterFunctions";
                spSelectFunction.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdFunction));
                this.AddStoredProcedure("SelectFunction", spSelectFunction);

                DBStoredProcedure spSelectDepartmentsForFunction = new DBStoredProcedure();
                spSelectDepartmentsForFunction.ProcedureName = "extSelectExtractByFunctionFilterDepartmentsForFunction";
                spSelectDepartmentsForFunction.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdFunction));
                this.AddStoredProcedure("SelectDepartmentsForFunction", spSelectDepartmentsForFunction);

                DBStoredProcedure spSelectInitial = new DBStoredProcedure();
                spSelectInitial.ProcedureName = "extExtractByFunctionInitialData";
                spSelectInitial.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.Year));
                spSelectInitial.AddParameter(new DBParameter("@IdRegion", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdRegion));
                spSelectInitial.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdCountry));
                spSelectInitial.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdInergyLocation));
                spSelectInitial.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdFunction));
                spSelectInitial.AddParameter(new DBParameter("@IdDepartment", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdDepartment));
                spSelectInitial.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extractByFunctionFilter.ActiveStatus));
                spSelectInitial.AddParameter(new DBParameter("@CostTypeCategory", DbType.String, ParameterDirection.Input, extractByFunctionFilter.CostTypeCategory));
                spSelectInitial.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extractByFunctionFilter.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractInitialData", spSelectInitial);

                DBStoredProcedure spSelectReforcast = new DBStoredProcedure();
                spSelectReforcast.ProcedureName = "extExtractByFunctionReforcastData";
                spSelectReforcast.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.Year));
                spSelectReforcast.AddParameter(new DBParameter("@IdRegion", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdRegion));
                spSelectReforcast.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdCountry));
                spSelectReforcast.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdInergyLocation));
                spSelectReforcast.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdFunction));
                spSelectReforcast.AddParameter(new DBParameter("@IdDepartment", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdDepartment));
                spSelectReforcast.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extractByFunctionFilter.ActiveStatus));
                spSelectReforcast.AddParameter(new DBParameter("@CostTypeCategory", DbType.String, ParameterDirection.Input, extractByFunctionFilter.CostTypeCategory));
                spSelectReforcast.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extractByFunctionFilter.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractReforcastData", spSelectReforcast);

                DBStoredProcedure spSelectRevised = new DBStoredProcedure();
                spSelectRevised.ProcedureName = "extExtractByFunctionRevisedData";
                spSelectRevised.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.Year));
                spSelectRevised.AddParameter(new DBParameter("@IdRegion", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdRegion));
                spSelectRevised.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdCountry));
                spSelectRevised.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdInergyLocation));
                spSelectRevised.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdFunction));
                spSelectRevised.AddParameter(new DBParameter("@IdDepartment", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdDepartment));
                spSelectRevised.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extractByFunctionFilter.ActiveStatus));
                spSelectRevised.AddParameter(new DBParameter("@CostTypeCategory", DbType.String, ParameterDirection.Input, extractByFunctionFilter.CostTypeCategory));
                spSelectRevised.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extractByFunctionFilter.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractRevisedData", spSelectRevised);

                DBStoredProcedure spSelectActual = new DBStoredProcedure();
                spSelectActual.ProcedureName = "extExtractByFunctionActualData";
                spSelectActual.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.Year));
                spSelectActual.AddParameter(new DBParameter("@IdRegion", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdRegion));
                spSelectActual.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdCountry));
                spSelectActual.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdInergyLocation));
                spSelectActual.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdFunction));
                spSelectActual.AddParameter(new DBParameter("@IdDepartment", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdDepartment));
                spSelectActual.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extractByFunctionFilter.ActiveStatus));
                spSelectActual.AddParameter(new DBParameter("@CostTypeCategory", DbType.String, ParameterDirection.Input, extractByFunctionFilter.CostTypeCategory));
                spSelectActual.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extractByFunctionFilter.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractActualData", spSelectActual);

                DBStoredProcedure spSelectAnnualBudget = new DBStoredProcedure();
                spSelectAnnualBudget.ProcedureName = "extExtractByFunctionAnnualBudgetData";
                spSelectAnnualBudget.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.Year));
                spSelectAnnualBudget.AddParameter(new DBParameter("@IdRegion", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdRegion));
                spSelectAnnualBudget.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdCountry));
                spSelectAnnualBudget.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdInergyLocation));
                spSelectAnnualBudget.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdFunction));
                spSelectAnnualBudget.AddParameter(new DBParameter("@IdDepartment", DbType.Int32, ParameterDirection.Input, extractByFunctionFilter.IdDepartment));
                spSelectAnnualBudget.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extractByFunctionFilter.ActiveStatus));
                spSelectAnnualBudget.AddParameter(new DBParameter("@CostTypeCategory", DbType.String, ParameterDirection.Input, extractByFunctionFilter.CostTypeCategory));
                spSelectAnnualBudget.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extractByFunctionFilter.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractAnnualBudgetData", spSelectAnnualBudget);
            }
        }
    }
}
