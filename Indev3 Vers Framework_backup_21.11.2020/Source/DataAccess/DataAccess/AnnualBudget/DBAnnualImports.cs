using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.AnnualBudget;
using System.Data;

namespace Inergy.Indev3.DataAccess.AnnualBudget
{
    public class DBAnnualImports : DBGenericEntity
    {
        public DBAnnualImports(object connectionManager)
            : base(connectionManager)
        {
        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IAnnualImports)
            {
                IAnnualImports annualImports = (IAnnualImports)ent;

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "impSelectAnnualImports";
                spSelect.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input,annualImports.IdImport));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spLogErrorsToDatabase = new DBStoredProcedure();
                spLogErrorsToDatabase.ProcedureName = "impAnnualUploadErrorsToLogTables";
                spLogErrorsToDatabase.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, annualImports.FileName));
                spLogErrorsToDatabase.AddParameter(new DBParameter("@Message", DbType.String, ParameterDirection.Input, annualImports.Message));
                spLogErrorsToDatabase.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, annualImports.IdAssociate));
                this.AddStoredProcedure("AnnualUploadErrorsToLogTables", spLogErrorsToDatabase);

                DBStoredProcedure spProcessErrorsToDatabase = new DBStoredProcedure();
                spProcessErrorsToDatabase.ProcedureName = "impAnnualProcessErrorsToLogTables";
                spProcessErrorsToDatabase.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, annualImports.FileName));
                spProcessErrorsToDatabase.AddParameter(new DBParameter("@Message", DbType.String, ParameterDirection.Input, annualImports.Message));
                spProcessErrorsToDatabase.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, annualImports.IdImport));
                this.AddStoredProcedure("AnnualProcessErrorsToLogTables", spProcessErrorsToDatabase);

                DBStoredProcedure spSelectAnnualImportDetailsHeader = new DBStoredProcedure();
                spSelectAnnualImportDetailsHeader.ProcedureName = "impSelectAnnualImportDetailsHeader";
                spSelectAnnualImportDetailsHeader.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, annualImports.IdImport));
                this.AddStoredProcedure("SelectAnnualImportDetailsHeader", spSelectAnnualImportDetailsHeader);

                DBStoredProcedure spRemove = new DBStoredProcedure();
                spRemove.ProcedureName = "impRemoveAnnualImport";
                spRemove.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, annualImports.IdImport));
                this.AddStoredProcedure("impRemoveAnnualImport", spRemove);

            }
        }
    }
}
