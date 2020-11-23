using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBProject : DBGenericEntity
    {
        public DBProject(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IProject)
            {
                IProject Project = (IProject)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertProject";
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, Project.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Project.Name));
                spInsert.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, Project.IdProgram));
                spInsert.AddParameter(new DBParameter("@IdProjectType", DbType.Int32, ParameterDirection.Input, Project.IdProjectType));
                spInsert.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, Project.IsActive));
                spInsert.AddParameter(new DBParameter("@UseWorkPackageTemplate", DbType.Boolean, ParameterDirection.Input, Project.UseWorkPackageTemplate));
                spInsert.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, Project.IdAssociate));


                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateProject";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Project.Id));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, Project.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Project.Name));
                spUpdate.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, Project.IdProgram));
                spUpdate.AddParameter(new DBParameter("@IdProjectType", DbType.Int32, ParameterDirection.Input, Project.IdProjectType));
                spUpdate.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, Project.IsActive));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteProject";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Project.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectProject";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Project.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }

}
