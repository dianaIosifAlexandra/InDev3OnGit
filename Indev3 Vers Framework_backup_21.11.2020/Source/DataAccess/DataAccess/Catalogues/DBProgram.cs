using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBProgram : DBGenericEntity
    {
        public DBProgram(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IProgram)
            {
                IProgram Program = (IProgram)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertProgram";
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, Program.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Program.Name));
                spInsert.AddParameter(new DBParameter("@IdOwner", DbType.Int32, ParameterDirection.Input, Program.IdOwner));
                spInsert.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, Program.IsActive));
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, Program.Rank));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateProgram";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Program.Id));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, Program.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Program.Name));
                spUpdate.AddParameter(new DBParameter("@IdOwner", DbType.Int32, ParameterDirection.Input, Program.IdOwner));
                spUpdate.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, Program.IsActive));
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, Program.Rank));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteProgram";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Program.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectProgram";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Program.Id));
                spSelect.AddParameter(new DBParameter("@OnlyActive", DbType.Boolean, ParameterDirection.Input, Program.OnlyActive));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }

}
