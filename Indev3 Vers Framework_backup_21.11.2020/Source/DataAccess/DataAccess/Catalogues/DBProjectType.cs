using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBProjectType : DBGenericEntity
    {
        public DBProjectType(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IProjectType)
            {
                IProjectType ProjectType = (IProjectType)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertProjectType";
                spInsert.AddParameter(new DBParameter("@Type", DbType.String, ParameterDirection.Input, ProjectType.Type));
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, ProjectType.Rank));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateProjectType";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, ProjectType.Id));
                spUpdate.AddParameter(new DBParameter("@Type", DbType.String, ParameterDirection.Input, ProjectType.Type));
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, ProjectType.Rank));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteProjectType";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, ProjectType.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectProjectType";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, ProjectType.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }

}
