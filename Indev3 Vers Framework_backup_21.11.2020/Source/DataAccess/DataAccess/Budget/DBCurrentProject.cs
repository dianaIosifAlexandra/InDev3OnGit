using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBCurrentProject : DBGenericEntity
    {
        public DBCurrentProject(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ICurrentProject)
            {
                ICurrentProject currentProject = (ICurrentProject)ent;
                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "fltProjectSelectorProjects";
                spSelect.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, currentProject.IdAssociate));
                spSelect.AddParameter(new DBParameter("@IdOwner", DbType.Int32, ParameterDirection.Input, currentProject.IdOwner));
                spSelect.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, currentProject.IdProgram));
                spSelect.AddParameter(new DBParameter("@ShowOnly", DbType.String, ParameterDirection.Input, currentProject.ShowOnly));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spUnvalidate = new DBStoredProcedure();
                spUnvalidate.ProcedureName = "bgtRestoreBudgetToInitialState";
                spUnvalidate.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, currentProject.Id));
                this.AddStoredProcedure("bgtRestoreBudgetToInitialState", spUnvalidate);

            }
        }
    }

}
