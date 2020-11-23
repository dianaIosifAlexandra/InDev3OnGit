using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;

namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBProjectSelectorFilter : DBGenericEntity
    {
        public DBProjectSelectorFilter(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IProjectSelectorFilter)
            {
                IProjectSelectorFilter projectSelectorFilter = (IProjectSelectorFilter)ent;

                DBStoredProcedure spSelectOwners = new DBStoredProcedure();
                spSelectOwners.ProcedureName = "fltProjectSelectorOwners";
                spSelectOwners.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdAssociate));
                spSelectOwners.AddParameter(new DBParameter("@IdOwner", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdOwner));
                spSelectOwners.AddParameter(new DBParameter("@ShowOnly", DbType.String, ParameterDirection.Input, projectSelectorFilter.ShowOnly));
                this.AddStoredProcedure("SelectOwners", spSelectOwners);

                DBStoredProcedure spSelectPrograms = new DBStoredProcedure();
                spSelectPrograms.ProcedureName = "fltProjectSelectorPrograms";
                spSelectPrograms.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdAssociate));
                spSelectPrograms.AddParameter(new DBParameter("@IdOwner", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdOwner));
                spSelectPrograms.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdProgram));
                spSelectPrograms.AddParameter(new DBParameter("@ShowOnly", DbType.String, ParameterDirection.Input, projectSelectorFilter.ShowOnly));
                this.AddStoredProcedure("SelectPrograms", spSelectPrograms);

                DBStoredProcedure spSelectProjects = new DBStoredProcedure();
                spSelectProjects.ProcedureName = "fltProjectSelectorProjects";
                spSelectProjects.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdAssociate));
                spSelectProjects.AddParameter(new DBParameter("@IdOwner", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdOwner));
                spSelectProjects.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdProgram));
                spSelectProjects.AddParameter(new DBParameter("@ShowOnly", DbType.String, ParameterDirection.Input, projectSelectorFilter.ShowOnly));
				spSelectProjects.AddParameter(new DBParameter("@OrderBy", DbType.String, ParameterDirection.Input, projectSelectorFilter.OrderBy));
                this.AddStoredProcedure("SelectProjects", spSelectProjects);

                DBStoredProcedure spSelectProject = new DBStoredProcedure();
                spSelectProject.ProcedureName = "fltProjectSelectorSelectProject";
                spSelectProject.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdProject));
                this.AddStoredProcedure("SelectProject", spSelectProject);

				DBStoredProcedure spSelectProjectWithWPCodeSuffix = new DBStoredProcedure();
				spSelectProjectWithWPCodeSuffix.ProcedureName = "fltProjectSelectorSelectProjectWithWPCodeSuffix";
				spSelectProjectWithWPCodeSuffix.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdProject));
				spSelectProjectWithWPCodeSuffix.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdAssociate));
				this.AddStoredProcedure("SelectProjectWithWPCodeSuffix", spSelectProjectWithWPCodeSuffix);

                DBStoredProcedure spSelectProgram = new DBStoredProcedure();
                spSelectProgram.ProcedureName = "fltProjectSelectorSelectProgram";
                spSelectProgram.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, projectSelectorFilter.IdProgram));
                this.AddStoredProcedure("SelectProgram", spSelectProgram);
            }
        }
    }
}
