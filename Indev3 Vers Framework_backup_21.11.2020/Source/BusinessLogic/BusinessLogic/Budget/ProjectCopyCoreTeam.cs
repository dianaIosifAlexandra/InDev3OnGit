using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Data;

namespace Inergy.Indev3.BusinessLogic.Budget
{
	public class ProjectCopyCoreTeam : GenericEntity, IProjectCopyCoreTeam
	{
		#region Members
		private int _idProject = ApplicationConstants.INT_NULL_VALUE;
		public int IdProject
		{
			get { return _idProject; }
			set { _idProject = value; }
		}
		private int _idTargetProject = ApplicationConstants.INT_NULL_VALUE;
		public int IdTargetProject
		{
			get { return _idTargetProject; }
			set { _idTargetProject = value; }
		}
		private int _idAssociate = ApplicationConstants.INT_NULL_VALUE;
		public int IdAssociate
		{
			get { return _idAssociate; }
			set { _idAssociate = value; }
		}
		#endregion
		
		#region Constructor
		public ProjectCopyCoreTeam(object connectionManager)
            : base(connectionManager)
        {
			SetEntity(new DBProjectCopyCoreTeam(connectionManager));
            _idProject = ApplicationConstants.INT_NULL_VALUE;
            _idTargetProject = ApplicationConstants.INT_NULL_VALUE;
            _idAssociate = ApplicationConstants.INT_NULL_VALUE;
        }
        #endregion
   
	#region Public Methods
		public int CopyProjectCoreTeam()
		{
			int result = ApplicationConstants.INT_NULL_VALUE;
			try
			{
				BeginTransaction();
				result = this.GetEntity().ExecuteCustomProcedureWithReturnValue("CopyProjectCoreTeam", this);
				CommitTransaction();
			}
			catch (Exception ex)
			{
				RollbackTransaction();
				throw new IndException(ex);
			}
			return result;
		}

		public DataSet GetTargetProjects()
		{
			DataSet dsTargetProjects;
			try
			{
				dsTargetProjects = this.GetEntity().GetCustomDataSet("GetCopyTeamTargetProjectsForPM", this);
			}
			catch (Exception ex)
			{
				throw new IndException(ex);
			}
			return dsTargetProjects;
		}
	#endregion
	}
}
