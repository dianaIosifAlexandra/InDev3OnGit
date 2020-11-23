using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBDepartment : DBGenericEntity
    {
        public DBDepartment(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IDepartment)
            {
                IDepartment Department = (IDepartment)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertDepartment";
                spInsert.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, Department.IdFunction));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Department.Name));
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, Department.Rank));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateDepartment";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Department.Id));
                spUpdate.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, Department.IdFunction));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Department.Name));
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, Department.Rank));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteDepartment";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Department.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectDepartment";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Department.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }
}
