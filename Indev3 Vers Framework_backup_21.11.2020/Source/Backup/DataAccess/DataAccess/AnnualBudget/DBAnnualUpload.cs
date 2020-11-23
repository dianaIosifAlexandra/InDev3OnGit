using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.AnnualBudget;
using System.Data;

namespace Inergy.Indev3.DataAccess.AnnualBudget
{
    public class DBAnnualUpload : DBGenericEntity
    {
        public DBAnnualUpload(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IAnnualUpload)
            {
                IAnnualUpload annualUpload = (IAnnualUpload)ent;
                DBStoredProcedure spWriteToAnnualImportTable = new DBStoredProcedure();
                spWriteToAnnualImportTable.ProcedureName = "impWriteToAnnualImportTable";
                spWriteToAnnualImportTable.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, annualUpload.FileName));
                spWriteToAnnualImportTable.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, annualUpload.IdAssociate));
                this.AddStoredProcedure("WriteToAnnualImportTable", spWriteToAnnualImportTable);

                DBStoredProcedure spWriteToAnnualTable = new DBStoredProcedure();
                spWriteToAnnualTable.ProcedureName = "impWriteToAnnualTable";
                spWriteToAnnualTable.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, annualUpload.FileName));
                spWriteToAnnualTable.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, annualUpload.IdImport));
                this.AddStoredProcedure("WriteToAnnualTable", spWriteToAnnualTable);

                DBStoredProcedure spCheckFileAlreadyUploaded = new DBStoredProcedure();
                spCheckFileAlreadyUploaded.ProcedureName = "impCheckAnnualFileAlreadyUploaded";
                spCheckFileAlreadyUploaded.AddParameter(new DBParameter("@fileName", DbType.String, ParameterDirection.Input, annualUpload.FileName));
                this.AddStoredProcedure("CheckAnnualFileAlreadyUploaded", spCheckFileAlreadyUploaded);
                
            }
        }
    }
}
