using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Upload;
using System.Data;
using Inergy.Indev3.Entities;

namespace Inergy.Indev3.DataAccess.Upload
{
    public class DBImports : DBGenericEntity
    {
        public DBImports(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IImports)
            {
                IImports importsClass = (IImports)ent;
                DBStoredProcedure spInsertIntoImportTables = new DBStoredProcedure();
                spInsertIntoImportTables.ProcedureName = "impWriteToImportTable";
                spInsertIntoImportTables.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, importsClass.FileName));
                spInsertIntoImportTables.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, importsClass.IdAssociate));
                this.AddStoredProcedure("InsertToImportsTable", spInsertIntoImportTables);

                DBStoredProcedure spInsertIntoActualTables = new DBStoredProcedure();
                spInsertIntoActualTables.ProcedureName = "impWriteToActualTable";
                spInsertIntoActualTables.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, importsClass.IdAssociate));
                spInsertIntoActualTables.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importsClass.IdImport));
                this.AddStoredProcedure("InsertToActualTable", spInsertIntoActualTables);

                DBStoredProcedure spInsertIntoLogTables = new DBStoredProcedure();
                spInsertIntoLogTables.ProcedureName = "impWriteToLogTables";
                spInsertIntoLogTables.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importsClass.IdImport));
                spInsertIntoLogTables.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, importsClass.IdAssociate));               
                this.AddStoredProcedure("InsertToLogTable", spInsertIntoLogTables);

                DBStoredProcedure spCheckFileAlreadyUploaded = new DBStoredProcedure();
                spCheckFileAlreadyUploaded.ProcedureName = "impCheckFileAlreadyUploaded";
                spCheckFileAlreadyUploaded.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, importsClass.FileName));
                this.AddStoredProcedure("CheckFileAlreadyUploaded", spCheckFileAlreadyUploaded);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "impSelectImports";
                spSelect.AddParameter(new DBParameter("@IdImport",DbType.Int32,ParameterDirection.Input, importsClass.IdImport));
                this.AddStoredProcedure("SelectObject",spSelect);

                DBStoredProcedure spUploadErrorsToLogTables = new DBStoredProcedure();
                spUploadErrorsToLogTables.ProcedureName = "impUploadErrorsToLogTables";
                spUploadErrorsToLogTables.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, importsClass.FileName));
                spUploadErrorsToLogTables.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, importsClass.IdAssociate));
                spUploadErrorsToLogTables.AddParameter(new DBParameter("@Message", DbType.Int32, ParameterDirection.Input, importsClass.Message));
                spUploadErrorsToLogTables.AddParameter(new DBParameter("@IdSource", DbType.Int32, ParameterDirection.Input, importsClass.IdSource));
                this.AddStoredProcedure("UploadErrorsToLogTables", spUploadErrorsToLogTables);

                DBStoredProcedure spProcessErrorToLogTable = new DBStoredProcedure();
                spProcessErrorToLogTable.ProcedureName = "impProcessErrorToLogTable";
                spProcessErrorToLogTable.AddParameter(new DBParameter("@IdImport", DbType.String, ParameterDirection.Input, importsClass.IdImport));
                spProcessErrorToLogTable.AddParameter(new DBParameter("@Message", DbType.Int32, ParameterDirection.Input, importsClass.Message));
                this.AddStoredProcedure("ProcessErrorToLogTable", spProcessErrorToLogTable);

                DBStoredProcedure spWriteKeyrowsMissingToLogTable = new DBStoredProcedure();
                spWriteKeyrowsMissingToLogTable.ProcedureName = "impWriteKeyrowsMissingToLogTable";
                spWriteKeyrowsMissingToLogTable.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importsClass.IdImport));
                spWriteKeyrowsMissingToLogTable.AddParameter(new DBParameter("@IdRow", DbType.Int32, ParameterDirection.Input, importsClass.IdRow));
                spWriteKeyrowsMissingToLogTable.AddParameter(new DBParameter("@Message", DbType.String, ParameterDirection.Input, importsClass.Message));
                this.AddStoredProcedure("WriteKeyrowsMissingToLogTable", spWriteKeyrowsMissingToLogTable);

                DBStoredProcedure spGetNonExistingAssociateNumbers = new DBStoredProcedure();
                spGetNonExistingAssociateNumbers.ProcedureName = "impGetNonExistingAssociateNumbers";
                spGetNonExistingAssociateNumbers.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importsClass.IdImport));
                this.AddStoredProcedure("GetNonExistingAssociateNumbers", spGetNonExistingAssociateNumbers);

                DBStoredProcedure spCheckChronologicalOrder = new DBStoredProcedure();
                spCheckChronologicalOrder.ProcedureName = "impCheckFileImportChronologicalOrder";
                spCheckChronologicalOrder.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, importsClass.FileName));
                this.AddStoredProcedure("CheckFileImportChronologicalOrder", spCheckChronologicalOrder);

                DBStoredProcedure spChronologicalErrorsToLogTables = new DBStoredProcedure();
                spChronologicalErrorsToLogTables.ProcedureName = "impChronologicalErrorsToLogTables";
                spChronologicalErrorsToLogTables.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, importsClass.FileName));
                spChronologicalErrorsToLogTables.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, importsClass.IdAssociate));
                spChronologicalErrorsToLogTables.AddParameter(new DBParameter("@Message", DbType.Int32, ParameterDirection.Input, importsClass.Message));
                spChronologicalErrorsToLogTables.AddParameter(new DBParameter("@IdSource", DbType.Int32, ParameterDirection.Input, importsClass.IdSource));
                this.AddStoredProcedure("ChronologicalErrorsToLogTables", spChronologicalErrorsToLogTables);
            }
        }
    }
}
