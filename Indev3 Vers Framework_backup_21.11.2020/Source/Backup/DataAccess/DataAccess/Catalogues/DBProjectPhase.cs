using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBProjectPhase : DBGenericEntity
    {
        public DBProjectPhase(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IProjectPhase)
            {
                IProjectPhase ProjectPhase = (IProjectPhase)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertProjectPhase";
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, ProjectPhase.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, ProjectPhase.Name));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateProjectPhase";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, ProjectPhase.Id));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, ProjectPhase.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, ProjectPhase.Name));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteProjectPhase";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, ProjectPhase.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectProjectPhase";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, ProjectPhase.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }

}
