using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Upload;

namespace Inergy.Indev3.DataAccess.Upload
{
    public class DBImportDetails: DBGenericEntity
    {
        public DBImportDetails(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IImportDetails)
            {
                IImportDetails importDetails = (IImportDetails)ent;

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "impSelectImportDetails";
                spSelect.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));         
                this.AddStoredProcedure("SelectImportDetails", spSelect);

                DBStoredProcedure spSelectErrors = new DBStoredProcedure();
                spSelectErrors.ProcedureName = "impSelectImportDetailsErrors";
                spSelectErrors.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("SelectImportDetailsErrors", spSelectErrors);

                DBStoredProcedure spUpdateDetail = new DBStoredProcedure();
                spUpdateDetail.ProcedureName = "impUpdateImportDetails";
                spUpdateDetail.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                spUpdateDetail.AddParameter(new DBParameter("@IdRow", DbType.Int32, ParameterDirection.Input, importDetails.IdRow));
                spUpdateDetail.AddParameter(new DBParameter("@CostCenter", DbType.String, ParameterDirection.Input, importDetails.CostCenter));
                spUpdateDetail.AddParameter(new DBParameter("@ProjectCode", DbType.String, ParameterDirection.Input, importDetails.ProjectCode));
                spUpdateDetail.AddParameter(new DBParameter("@WPCode", DbType.String, ParameterDirection.Input, importDetails.WPCode));
                spUpdateDetail.AddParameter(new DBParameter("@AccountNumber", DbType.String, ParameterDirection.Input, importDetails.AccountNumber));
                spUpdateDetail.AddParameter(new DBParameter("@AssociateNumber", DbType.String, ParameterDirection.Input, importDetails.AssociateNumber));
                if (importDetails.Quantity != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdateDetail.AddParameter(new DBParameter("@Quantity", DbType.Decimal, ParameterDirection.Input, importDetails.Quantity));
                else
                    spUpdateDetail.AddParameter(new DBParameter("@Quantity", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                spUpdateDetail.AddParameter(new DBParameter("@UnitQty", DbType.String, ParameterDirection.Input, importDetails.UnitQty));
                if (importDetails.Value != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdateDetail.AddParameter(new DBParameter("@Value", DbType.Decimal, ParameterDirection.Input, importDetails.Value));
                else
                    spUpdateDetail.AddParameter(new DBParameter("@Value", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                spUpdateDetail.AddParameter(new DBParameter("@CurrencyCode", DbType.String, ParameterDirection.Input, importDetails.CurrencyCode));

                this.AddStoredProcedure("UpdateImportDetails", spUpdateDetail);

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "impDeleteImportDetails";
                spDelete.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelectHeaderInformation = new DBStoredProcedure();
                spSelectHeaderInformation.ProcedureName = "impSelectImportDetailsHeader";
                spSelectHeaderInformation.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("SelectImportDetailsHeader", spSelectHeaderInformation);

                DBStoredProcedure spSelectImportDetailsForExport = new DBStoredProcedure();
                spSelectImportDetailsForExport.ProcedureName = "impSelectImportDetailsForExport";
                spSelectImportDetailsForExport.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                this.AddStoredProcedure("SelectImportDetailsForExport", spSelectImportDetailsForExport);

                DBStoredProcedure spDeleteImportRows = new DBStoredProcedure();
                spDeleteImportRows.ProcedureName = "impDeleteImportRows";
                spDeleteImportRows.AddParameter(new DBParameter("@IdImport", DbType.Int32, ParameterDirection.Input, importDetails.IdImport));
                spDeleteImportRows.AddParameter(new DBParameter("@IdRow", DbType.Int32, ParameterDirection.Input, importDetails.IdRow));
                this.AddStoredProcedure("DeleteImportRows", spDeleteImportRows);
            }
        }
    }
}
