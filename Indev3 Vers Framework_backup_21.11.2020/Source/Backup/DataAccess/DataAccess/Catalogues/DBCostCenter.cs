using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBCostCenter : DBGenericEntity
    {
        public DBCostCenter(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ICostCenter)
            {
                ICostCenter CostCenter = (ICostCenter)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertCostCenter";
                spInsert.AddParameter(new DBParameter("@IdDepartment", DbType.Int32, ParameterDirection.Input, CostCenter.IdDepartment));
                spInsert.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, CostCenter.IdInergyLocation));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, CostCenter.Name));
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, CostCenter.Code));
                spInsert.AddParameter(new DBParameter("@IsActive", DbType.Byte, ParameterDirection.Input, CostCenter.IsActive));
    
                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateCostCenter";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, CostCenter.Id));
                spUpdate.AddParameter(new DBParameter("@IdDepartment", DbType.Int32, ParameterDirection.Input, CostCenter.IdDepartment));
                spUpdate.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, CostCenter.IdInergyLocation));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, CostCenter.Name));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, CostCenter.Code));
                spUpdate.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, CostCenter.IsActive));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteCostCenter";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, CostCenter.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectCostCenter";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, CostCenter.Id));
                spSelect.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, CostCenter.IdInergyLocation));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spSelectCurrency = new DBStoredProcedure();
                spSelectCurrency.ProcedureName = "catSelectCostCenterCurrency";
                spSelectCurrency.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, CostCenter.Id));
                this.AddStoredProcedure("SelectCostCenterCurrency", spSelectCurrency);
            }
        }
    }
}
