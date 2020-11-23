using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.InitialBudget;
using System.Data;
using Inergy.Indev3.Entities;

namespace Inergy.Indev3.DataAccess.UploadInitialBudget
{
    public class DBImportInitialBudget : DBGenericEntity
    {

        public DBImportInitialBudget(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IUploadInitialBudget)
            {
                IUploadInitialBudget initialBudgetClass = (IUploadInitialBudget)ent;

                DBStoredProcedure spInsertIntoImportTables = new DBStoredProcedure();
                spInsertIntoImportTables.ProcedureName = "impWriteToInitialBudgetImportTable";
                spInsertIntoImportTables.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, initialBudgetClass.FileName));
                spInsertIntoImportTables.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, initialBudgetClass.IdAssociate));
                this.AddStoredProcedure("WriteToInitialBudgetImportTable", spInsertIntoImportTables);

                DBStoredProcedure spInsertIntoBudgetTables = new DBStoredProcedure();
                spInsertIntoBudgetTables.ProcedureName = "impWriteToBudgetTable";
                spInsertIntoBudgetTables.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, initialBudgetClass.IdImport));
                this.AddStoredProcedure("InsertToBudgetTable", spInsertIntoBudgetTables);
            }
        }
    }
}
