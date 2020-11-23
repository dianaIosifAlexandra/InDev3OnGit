using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;



namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBWorkPackageTemplate : DBGenericEntity
    {
        public DBWorkPackageTemplate(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IWorkPackageTemplate)
            {
                IWorkPackageTemplate WorkPackageTemplate = (IWorkPackageTemplate)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertWorkPackageTemplate";
                WorkPackageTemplate.LastUpdate = DateTime.Today;
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, WorkPackageTemplate.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, WorkPackageTemplate.Name));
                spInsert.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.IdPhase));
                spInsert.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, WorkPackageTemplate.IsActive));
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.Rank));
                spInsert.AddParameter(new DBParameter("@LastUserUpdate", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.IdLastUserUpdate));


                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateWorkPackageTemplate";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.Id));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, WorkPackageTemplate.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, WorkPackageTemplate.Name));
                spUpdate.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.IdPhase));
                spUpdate.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, WorkPackageTemplate.IsActive));
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.Rank));
                spUpdate.AddParameter(new DBParameter("@LastUserUpdate", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.IdLastUserUpdate));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteWorkPackageTemplate";
                spDelete.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.IdPhase));
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectWorkPackageTemplate";
                spSelect.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.IdPhase));
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, WorkPackageTemplate.Id));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spGetWorkPackageTemplateNewKeys = new DBStoredProcedure();
                spGetWorkPackageTemplateNewKeys.ProcedureName = "catSelectWorkPackageTemplateNewKeys";
                spGetWorkPackageTemplateNewKeys.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, WorkPackageTemplate.Code));
                this.AddStoredProcedure("GetWorkPackageTemplateNewKeys", spGetWorkPackageTemplateNewKeys);
            }
        }
    }

}
