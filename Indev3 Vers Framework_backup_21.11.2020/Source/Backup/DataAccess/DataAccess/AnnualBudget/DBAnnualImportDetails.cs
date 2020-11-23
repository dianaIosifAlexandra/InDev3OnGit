using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.Entities;
using System.Data;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.AnnualBudget
{
    public class DBAnnualImportDetails : DBGenericEntity
    {
        public DBAnnualImportDetails(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IAnnualImportDetails)
            {
                IAnnualImportDetails importDetails = (IAnnualImportDetails)ent;

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "impSelectAnnualImportDetails";
                spSelect.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("SelectAnnualImportDetails", spSelect);

                DBStoredProcedure spUpdateDetail = new DBStoredProcedure();
                spUpdateDetail.ProcedureName = "impUpdateAnnualImportDetails";
                spUpdateDetail.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                spUpdateDetail.AddParameter(new DBParameter("@IdRow", DbType.Int32, ParameterDirection.Input, importDetails.IdRow));
                spUpdateDetail.AddParameter(new DBParameter("@CostCenter", DbType.String, ParameterDirection.Input, importDetails.CostCenter));
                spUpdateDetail.AddParameter(new DBParameter("@ProjectCode", DbType.String, ParameterDirection.Input, importDetails.ProjectCode));
                spUpdateDetail.AddParameter(new DBParameter("@WPCode", DbType.String, ParameterDirection.Input, importDetails.WPCode));
                spUpdateDetail.AddParameter(new DBParameter("@AccountNumber", DbType.String, ParameterDirection.Input, importDetails.AccountNumber));
                if (importDetails.Quantity != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdateDetail.AddParameter(new DBParameter("@Quantity", DbType.Decimal, ParameterDirection.Input, importDetails.Quantity));
                else
                    spUpdateDetail.AddParameter(new DBParameter("@Quantity", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                if (importDetails.Value != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdateDetail.AddParameter(new DBParameter("@Value", DbType.Decimal, ParameterDirection.Input, importDetails.Value));
                else
                    spUpdateDetail.AddParameter(new DBParameter("@Value", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                spUpdateDetail.AddParameter(new DBParameter("@CurrencyCode", DbType.String, ParameterDirection.Input, importDetails.CurrencyCode));
                spUpdateDetail.AddParameter(new DBParameter("@Date", DbType.DateTime, ParameterDirection.Input, importDetails.ImportDate));
                this.AddStoredProcedure("UpdateAnnualImportDetails", spUpdateDetail);

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "impDeleteAnnualImportDetails";
                spDelete.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelectAnnualImportDetailsForExport = new DBStoredProcedure();
                spSelectAnnualImportDetailsForExport.ProcedureName = "impSelectAnnualImportDetailsForExport";
                spSelectAnnualImportDetailsForExport.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("SelectAnnualImportDetailsForExport", spSelectAnnualImportDetailsForExport);

                DBStoredProcedure spSelectAnnualImportDetailsErrors = new DBStoredProcedure();
                spSelectAnnualImportDetailsErrors.ProcedureName = "impSelectAnnualImportDetailsErrors";
                spSelectAnnualImportDetailsErrors.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("SelectAnnualImportDetailsErrors", spSelectAnnualImportDetailsErrors);

                DBStoredProcedure spSelectAnnualImportDetailsHeader = new DBStoredProcedure();
                spSelectAnnualImportDetailsHeader.ProcedureName = "impSelectAnnualImportDetailsHeader";
                spSelectAnnualImportDetailsHeader.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("SelectAnnualImportDetailsHeader", spSelectAnnualImportDetailsHeader);
            }
        }
    }
}
