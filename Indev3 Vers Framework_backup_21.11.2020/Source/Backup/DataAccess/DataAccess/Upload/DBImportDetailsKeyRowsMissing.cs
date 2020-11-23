
using System.Data;
using Inergy.Indev3.Entities.Upload;
using Inergy.Indev3.Entities;


namespace Inergy.Indev3.DataAccess.Upload
{
    public class DBImportDetailsKeyRowsMissing : DBGenericEntity
    {
        public DBImportDetailsKeyRowsMissing(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IImportDetailsKeyRowsMissing)
            {
                IImportDetailsKeyRowsMissing importDetailsKeyRowsMissing = (IImportDetailsKeyRowsMissing)ent;

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "impSelectImportDetailsKeyRowsMissing";
                spSelect.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetailsKeyRowsMissing.IdImport));
                this.AddStoredProcedure("SelectImportDetailsKeyRowsMissing", spSelect);

                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "impWriteKeysRowsMissingFromPreviousImport";
                spInsert.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetailsKeyRowsMissing.IdImport));
                this.AddStoredProcedure("InsertImportDetailsKeyRowsMissing", spInsert);
            }
        }
    }
}
