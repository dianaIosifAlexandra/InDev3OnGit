using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.RevisedBudget;
using System.Data;
using Inergy.Indev3.Entities;


namespace Inergy.Indev3.DataAccess.UploadRevisedBudget
{
    public class DBImportRevisedBudget: DBGenericEntity
    {

        public DBImportRevisedBudget(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IUploadRevisedBudget)
            {
                IUploadRevisedBudget revisedBudget = (IUploadRevisedBudget)ent;

                DBStoredProcedure spInsertIntoImportTables = new DBStoredProcedure();
                spInsertIntoImportTables.ProcedureName = "impWriteToRevisedBudgetImportTable";
                spInsertIntoImportTables.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, revisedBudget.FileName));
                spInsertIntoImportTables.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociate));
                this.AddStoredProcedure("WriteToRevisedBudgetImportTable", spInsertIntoImportTables);

                DBStoredProcedure spInsertIntoBudgetTables = new DBStoredProcedure();
                spInsertIntoBudgetTables.ProcedureName = "impWriteToBudgetRevisedTable";
                spInsertIntoBudgetTables.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, revisedBudget.IdImport));
                spInsertIntoBudgetTables.AddParameter(new DBParameter("@ForceDeleteExistingOpenBudget", DbType.Byte, ParameterDirection.Input, revisedBudget.SkipExistRevisedBudgetError));
                this.AddStoredProcedure("InsertToBudgetTable", spInsertIntoBudgetTables);
            }
        }
    }
}
