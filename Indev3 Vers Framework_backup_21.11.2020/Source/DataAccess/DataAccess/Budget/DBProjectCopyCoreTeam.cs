using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;
using System.Data;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.Budget
{
	public class DBProjectCopyCoreTeam : DBGenericEntity
	{
		#region Constructor
	    /// <summary>
        /// Constructor of the class
        /// </summary>
        /// <param name="connectionManager">connection manager object containing the sql connection</param>
		public DBProjectCopyCoreTeam(object connectionManager)
            : base(connectionManager)
        {
        }
		#endregion
	
	protected override void InitializeObject(IGenericEntity ent)
	{
		if (ent is IProjectCopyCoreTeam)
		{
			IProjectCopyCoreTeam projectCopyCoreTeam = (IProjectCopyCoreTeam)ent;

			DBStoredProcedure spCopyProjectCoreTeam = new DBStoredProcedure();
			spCopyProjectCoreTeam.ProcedureName = "bgtCopyProjectCoreTeam";
			spCopyProjectCoreTeam.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectCopyCoreTeam.IdProject));
			spCopyProjectCoreTeam.AddParameter(new DBParameter("@IdTargetProject", DbType.Int32, ParameterDirection.Input, projectCopyCoreTeam.IdTargetProject));
			this.AddStoredProcedure("CopyProjectCoreTeam", spCopyProjectCoreTeam);

			DBStoredProcedure spGetProjectsForPM = new DBStoredProcedure();
			spGetProjectsForPM.ProcedureName = "bgtGetCopyTeamTargetProjectsForPM";
			spGetProjectsForPM.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, projectCopyCoreTeam.IdProject));
			spGetProjectsForPM.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, projectCopyCoreTeam.IdAssociate));
			this.AddStoredProcedure("GetCopyTeamTargetProjectsForPM", spGetProjectsForPM);

		}
	}
	}
}
