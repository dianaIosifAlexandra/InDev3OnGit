using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.DataAccess.Budget;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// Represents the Project Selector Filter entity
    /// </summary>
    public class ProjectSelectorFilter : GenericEntity, IProjectSelectorFilter
    {
        #region IProjectSelectorFilter Members

        private int _IdProject;
        public int IdProject
        {
            get
            {
                return _IdProject;
            }
            set
            {
                _IdProject = value;
            }
        }
        private string _ProjectName;
        public string ProjectName
        {
            get
            {
                return _ProjectName;
            }
            set
            {
                _ProjectName = value;
            }
        }
        private int _IdOwner;
        public int IdOwner
        {
            get
            {
                return _IdOwner;
            }
            set
            {
                _IdOwner = value;
            }
        }
        private int _IdAssociate;
        public int IdAssociate
        {
            get
            {
                return _IdAssociate;
            }
            set
            {
                _IdAssociate = value;
            }
        }
        private int _IdProgram;
        public int IdProgram
        {
            get
            {
                return _IdProgram;
            }
            set
            {
                _IdProgram = value;
            }
        }
        private string _ShowOnly;
        public string ShowOnly
        {
            get
            {
                return _ShowOnly;
            }
            set
            {
                _ShowOnly = value;
            }
        }
		private string _ProjectFunctionWPCodeSuffix;
		public string ProjectFunctionWPCodeSuffix
		{
			get { 
					return _ProjectFunctionWPCodeSuffix; 
				}
			set { 
					_ProjectFunctionWPCodeSuffix = value; 
				}
		}
		private string _OrderBy;
		public string OrderBy
		{
			get
			{
				return _OrderBy;
			}
			set
			{
				_OrderBy = value;
			}
		}
        #endregion

        #region Constructors
        public ProjectSelectorFilter(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBProjectSelectorFilter(connectionManager));
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
            _IdOwner = ApplicationConstants.INT_NULL_VALUE;
            _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
            _IdProgram = ApplicationConstants.INT_NULL_VALUE;
            _ShowOnly = ApplicationConstants.SHOW_ONLY_ACTIVE_PROJECTS;
            _OrderBy = ApplicationConstants.ORDER_BY_CODE;
        }

        public ProjectSelectorFilter(DataRow row, object connectionManager)
            : this(connectionManager)
        {
            try
            {
                Row2Object(row);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public ProjectSelectorFilter(int idProgram, int idProject, object connectionManager)
            : this(connectionManager)
        {
            try
            {
                SetEntity(new DBProjectSelectorFilter(connectionManager));
                _IdProject = idProject;
                _IdProgram = idProgram;

                if (idProject != ApplicationConstants.INT_NULL_VALUE)
                {
                    DataSet dsProject = SelectProcedure("SelectProject");
                    this.ProjectName = dsProject.Tables[0].Rows[0]["ProjectName"].ToString();
                    this.IdProgram = (int)dsProject.Tables[0].Rows[0]["IdProgram"];
                    this.IdOwner = (int)dsProject.Tables[0].Rows[0]["IdOwner"];
                }
                else if (idProgram != ApplicationConstants.INT_NULL_VALUE)
                {
                    DataSet dsProgram = SelectProcedure("SelectProgram");
                    this.IdOwner = (int)dsProgram.Tables[0].Rows[0]["IdOwner"];
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

		public ProjectSelectorFilter(int idProgram, int idProject, int idAssociate, object connectionManager)
			: this(connectionManager)
		{
			try
			{
				SetEntity(new DBProjectSelectorFilter(connectionManager));
				_IdProject = idProject;
				_IdProgram = idProgram;
				_IdAssociate = idAssociate;

				if (idProject != ApplicationConstants.INT_NULL_VALUE)
				{
					DataSet dsProject = SelectProcedure("SelectProjectWithWPCodeSuffix");
					this.ProjectName = dsProject.Tables[0].Rows[0]["ProjectName"].ToString();
					this.IdProgram = (int)dsProject.Tables[0].Rows[0]["IdProgram"];
					this.IdOwner = (int)dsProject.Tables[0].Rows[0]["IdOwner"];
					this.ProjectFunctionWPCodeSuffix = dsProject.Tables[0].Rows[0]["ProjectFunctionWPCodeSuffix"].ToString();
				}
				else if (idProgram != ApplicationConstants.INT_NULL_VALUE)
				{
					DataSet dsProgram = SelectProcedure("SelectProgram");
					this.IdOwner = (int)dsProgram.Tables[0].Rows[0]["IdOwner"];
				}
			}
			catch (Exception ex)
			{
				throw new IndException(ex);
			}
		}
        #endregion

        #region Public Methods
        public DataSet SelectProcedure(string spName)
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet(spName.ToString(), this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }
        #endregion

        #region Protected Methods
        protected override void Row2Object(DataRow row)
        {
            this.IdProject = (int)row["ProjectId"];
            this.IdProgram = (row["ProgramId"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["ProgramId"];
            this.IdOwner = (row["OwnerId"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["OwnerId"];
            this.ProjectName = (row["ProjectName"] == DBNull.Value) ? null : row["ProjectName"].ToString();
        }
        #endregion Protected Methods
    }
}
