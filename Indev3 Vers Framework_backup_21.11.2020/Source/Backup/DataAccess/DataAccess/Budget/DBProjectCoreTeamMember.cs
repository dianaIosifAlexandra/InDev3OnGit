using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;
using System.Data;


namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBProjectCoreTeamMember : DBGenericEntity
    {
        public DBProjectCoreTeamMember(object connectionManager)
            : base(connectionManager)
        {

        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IProjectCoreTeamMember)
            {
                IProjectCoreTeamMember projectCoreTeamMember = (IProjectCoreTeamMember)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "bgtInsertProjectCoreTeam";
                spInsert.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdProject));
                spInsert.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdAssociate));
                spInsert.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdFunction));
                spInsert.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, projectCoreTeamMember.IsActive));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "bgtUpdateProjectCoreTeam";
                spUpdate.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdProject));
                spUpdate.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdAssociate));
                spUpdate.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdFunction));
                spUpdate.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, projectCoreTeamMember.IsActive));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "bgtDeleteProjectCoreTeam";
                spDelete.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdProject));
                spDelete.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdAssociate));
                spDelete.AddParameter(new DBParameter("@IdFunction", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdFunction));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "bgtSelectProjectCoreTeam";
                spSelect.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdProject));
                spSelect.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdAssociate));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spSelectOpenBudgets = new DBStoredProcedure();
                spSelectOpenBudgets.ProcedureName = "bgtProjectCoreTeamSelectOpenBudgets";
                spSelectOpenBudgets.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdProject));
                spSelectOpenBudgets.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdAssociate));
                this.AddStoredProcedure("GetOpenBudgets", spSelectOpenBudgets);

				DBStoredProcedure spIsAssociatePMOnProject = new DBStoredProcedure();
				spIsAssociatePMOnProject.ProcedureName = "bgtIsAssociatePMOnProject";
				spIsAssociatePMOnProject.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdProject));
				spIsAssociatePMOnProject.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectCoreTeamMember.IdAssociate));
				this.AddStoredProcedure("IsAssociatePMOnProject", spIsAssociatePMOnProject);
            }
        }

    }
}
