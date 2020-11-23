using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Extract;
using System.Data;

namespace Inergy.Indev3.DataAccess.Extract
{
    public class DBExtract : DBGenericEntity
    {
        public DBExtract(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IExtract)
            {
                IExtract extract = (IExtract)ent;
                DBStoredProcedure spSelectProjectReforcast = new DBStoredProcedure();
                spSelectProjectReforcast.ProcedureName = "extExtractProjectReforcastData";
                spSelectProjectReforcast.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, extract.IdProject));
                spSelectProjectReforcast.AddParameter(new DBParameter("@IdGeneration", DbType.Int32, ParameterDirection.Input, extract.IdGeneration));
                spSelectProjectReforcast.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProjectReforcast.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProjectReforcastData", spSelectProjectReforcast);

                DBStoredProcedure spSelectProgramReforcast = new DBStoredProcedure();
                spSelectProgramReforcast.ProcedureName = "extExtractProgramReforcastData";
                spSelectProgramReforcast.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, extract.IdProgram));
                spSelectProgramReforcast.AddParameter(new DBParameter("@IdGeneration", DbType.Int32, ParameterDirection.Input, extract.IdGeneration));
                spSelectProgramReforcast.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProgramReforcast.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProgramReforcastData", spSelectProgramReforcast);

                DBStoredProcedure spSelectProjectRevised = new DBStoredProcedure();
                spSelectProjectRevised.ProcedureName = "extExtractProjectRevisedData";
                spSelectProjectRevised.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, extract.IdProject));
                spSelectProjectRevised.AddParameter(new DBParameter("@IdGeneration", DbType.Int32, ParameterDirection.Input, extract.IdGeneration));
                spSelectProjectRevised.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProjectRevised.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProjectRevisedData", spSelectProjectRevised);

                DBStoredProcedure spSelectProgramRevised = new DBStoredProcedure();
                spSelectProgramRevised.ProcedureName = "extExtractProgramRevisedData";
                spSelectProgramRevised.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, extract.IdProgram));
                spSelectProgramRevised.AddParameter(new DBParameter("@IdGeneration", DbType.Int32, ParameterDirection.Input, extract.IdGeneration));
                spSelectProgramRevised.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProgramRevised.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProgramRevisedData", spSelectProgramRevised);

                DBStoredProcedure spSelectProjectInitial = new DBStoredProcedure();
                spSelectProjectInitial.ProcedureName = "extExtractProjectInitialData";
                spSelectProjectInitial.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, extract.IdProject));
                spSelectProjectInitial.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProjectInitial.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProjectInitialData", spSelectProjectInitial);

                DBStoredProcedure spSelectProgramInitial = new DBStoredProcedure();
                spSelectProgramInitial.ProcedureName = "extExtractProgramInitialData";
                spSelectProgramInitial.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, extract.IdProgram));
                spSelectProgramInitial.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProgramInitial.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProgramInitialData", spSelectProgramInitial);

                DBStoredProcedure spSelectProjectActual = new DBStoredProcedure();
                spSelectProjectActual.ProcedureName = "extExtractProjectActualData";
                spSelectProjectActual.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, extract.IdProject));
                spSelectProjectActual.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProjectActual.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProjectActualData", spSelectProjectActual);

                DBStoredProcedure spSelectProgramActual = new DBStoredProcedure();
                spSelectProgramActual.ProcedureName = "extExtractProgramActualData";
                spSelectProgramActual.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, extract.IdProgram));
                spSelectProgramActual.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProgramActual.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProgramActualData", spSelectProgramActual);

                DBStoredProcedure spSelectProjectAnnual = new DBStoredProcedure();
                spSelectProjectAnnual.ProcedureName = "extExtractProjectAnnualData";
                spSelectProjectAnnual.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, extract.IdProject));
                spSelectProjectAnnual.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extract.Year));
                spSelectProjectAnnual.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProjectAnnual.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProjectAnnualData", spSelectProjectAnnual);

                DBStoredProcedure spSelectProgramAnnual = new DBStoredProcedure();
                spSelectProgramAnnual.ProcedureName = "extExtractProgramAnnualData";
                spSelectProgramAnnual.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, extract.IdProgram));
                spSelectProgramAnnual.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extract.Year));
                spSelectProgramAnnual.AddParameter(new DBParameter("@WPActiveStatus", DbType.String, ParameterDirection.Input, extract.ActiveStatus));
                spSelectProgramAnnual.AddParameter(new DBParameter("@IdCurrencyAssociate", DbType.String, ParameterDirection.Input, extract.IdCurrencyAssociate));
                this.AddStoredProcedure("ExtractProgramAnnualData", spSelectProgramAnnual);
            }
        }
    }
}
