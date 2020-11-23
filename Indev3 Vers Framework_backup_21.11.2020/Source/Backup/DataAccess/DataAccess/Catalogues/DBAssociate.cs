using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBAssociate : DBGenericEntity
    {
        public DBAssociate(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IAssociate)
            {
                IAssociate Associate = (IAssociate)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertAssociate";
                spInsert.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, Associate.IdCountry));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Associate.Name));
                spInsert.AddParameter(new DBParameter("@EmployeeNumber", DbType.String, ParameterDirection.Input, Associate.EmployeeNumber));
                spInsert.AddParameter(new DBParameter("@InergyLogin", DbType.String, ParameterDirection.Input, Associate.InergyLogin));
                spInsert.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, Associate.IsActive));
                spInsert.AddParameter(new DBParameter("@IsSubcontractor", DbType.Boolean, ParameterDirection.Input, Associate.IsSubContractor));
                spInsert.AddParameter(new DBParameter("@PercentageFullTime", DbType.Int32, ParameterDirection.Input, Associate.PercentageFullTime));
               

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateAssociate";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Associate.Id));
                spUpdate.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, Associate.IdCountry));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Associate.Name));
                spUpdate.AddParameter(new DBParameter("@EmployeeNumber", DbType.String, ParameterDirection.Input, Associate.EmployeeNumber));
                spUpdate.AddParameter(new DBParameter("@InergyLogin", DbType.String, ParameterDirection.Input, Associate.InergyLogin));
                spUpdate.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, Associate.IsActive));
                spUpdate.AddParameter(new DBParameter("@IsSubcontractor", DbType.Boolean, ParameterDirection.Input, Associate.IsSubContractor));
                spUpdate.AddParameter(new DBParameter("@PercentageFullTime", DbType.Int32, ParameterDirection.Input, Associate.PercentageFullTime));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteAssociate";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Associate.Id));
                spDelete.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, Associate.IdCountry));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectAssociate";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Associate.Id));
                spSelect.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, Associate.IdCountry));

                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spSelectActiveAssociates = new DBStoredProcedure();
                spSelectActiveAssociates.ProcedureName = "catSelectActiveAssociates";
                spSelectActiveAssociates.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, Associate.IdCountry));

                this.AddStoredProcedure("SelectActiveAssociates", spSelectActiveAssociates);
            }
        }
    }
}
