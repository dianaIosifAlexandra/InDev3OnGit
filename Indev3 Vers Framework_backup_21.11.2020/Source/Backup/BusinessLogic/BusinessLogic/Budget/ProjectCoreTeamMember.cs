using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Catalogues;


namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// ProjectCoreTeam entity class
    /// </summary>
    public class ProjectCoreTeamMember : GenericEntity, IProjectCoreTeamMember
    {
        #region IProjectCoreTeam Members

        /// <summary>
        /// The name of the core team member
        /// </summary>
        private string _CoreTeamMemberName;
        [GridColumnProperty("Member Name")]
        [PropertyValidation(true, 50)]
        [DesignerName("Member Name")]
        public string CoreTeamMemberName
        {
            get { return _CoreTeamMemberName; }
            set { _CoreTeamMemberName = value; }
        }

        /// <summary>
        /// The employee number of the core team member
        /// </summary>
        private string _EmployeeNumber;
        [GridColumnProperty("Employee Number")]
        [PropertyValidation(false, 50)]
        [DesignerName("Employee Number")]
        public string EmployeeNumber
        {
            get { return _EmployeeNumber; }
            set { _EmployeeNumber = value; }
        }


        /// <summary>`
        /// The name of the project core team member function
        /// </summary>
        private string _FunctionName;
        [GridColumnProperty("Function")]
        [PropertyValidation(true, 30)]
        public string FunctionName
        {
            get { return _FunctionName; }
            set { _FunctionName = value; }
        }

        /// <summary>
        /// The id of the associate that is the core team member
        /// </summary>
        private int _IdAssociate;
        [GridColumnProperty(false)]
        [PropertyValidation(true)]
        [IsInLogicalKey()]
        public int IdAssociate
        {
            get { return _IdAssociate; }
            set { _IdAssociate = value; }
        }

        private int _Country;
        [GridColumnProperty("Country")]
        [PropertyValidation(true, 30)]        
        public int Country
        {
            get { return _Country; }
            set { _Country = value; }
        }

        /// <summary>
        /// The id of the function of the core team member
        /// </summary>
        private int _IdFunction;
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(ProjectFunction))]
        [PropertyValidation(true)]
        [IsInLogicalKey()]
        [DesignerName("Function")]
        public int IdFunction
        {
            get { return _IdFunction; }
            set { _IdFunction = value; }
        }

        /// <summary>
        /// The id of the project of the core team member
        /// </summary>
        private int _IdProject;
        [GridColumnProperty(false)]
        [PropertyValidation(true)]
        [IsInLogicalKey()]
        public int IdProject
        {
            get { return _IdProject; }
            set { _IdProject = value; }
        }

        /// <summary>
        /// Shows whether the core team member is active
        /// </summary>
        private bool _IsActive;
        [GridColumnProperty("Active")]
        public bool IsActive
        {
            get { return _IsActive; }
            set { _IsActive = value; }
        }

        private DateTime _LastUpdateDate;
        [GridColumnProperty("Last Update")]
        public DateTime LastUpdateDate
        {
            get { return _LastUpdateDate; }
            set { _LastUpdateDate = value; }
        }

        private string _ProjectName;
        [GridColumnProperty(false)]
        public string ProjectName
        {
            get { return _ProjectName; }
            set { _ProjectName = value; }
        }

        #endregion IProjectCoreTeam Members

        #region Constructors
        public ProjectCoreTeamMember()
            : this(null)
        {
        }
        public ProjectCoreTeamMember(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBProjectCoreTeamMember(connectionManager));
            _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
            _IdFunction = ApplicationConstants.INT_NULL_VALUE;
            _IsActive = true;
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
        }

        /// <summary>
        /// This constructor takes a datarow from the database and builds this object with the data from
        /// the datarow
        /// </summary>
        /// <param name="row">the row with data used to populate this object</param>
        public ProjectCoreTeamMember(DataRow row, object connectionManager)
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

        #endregion Constructors

        #region Protected Methods
        /// <summary>
        /// Populates this objectwith data from row
        /// </summary>
        /// <param name="row">the row with data used to populate this object</param>
        protected override void Row2Object(DataRow row)
        {
            this.CoreTeamMemberName = row["CoreTeamMemberName"].ToString();
            this.EmployeeNumber = row["EmployeeNumber"].ToString();
            this.FunctionName = row["FunctionName"].ToString();
            this.IdAssociate = (int)row["IdAssociate"];
            this.IdFunction = (int)row["IdFunction"];
            this.IdProject = (int)row["IdProject"];
            this.IsActive = (bool)row["IsActive"];
            this.LastUpdateDate = (DateTime)row["LastUpdateDate"];
            this.ProjectName = row["ProjectName"].ToString();
        }

        /// <summary>
        /// Replace the boolean column IsActive with strngs (instead of True/False, Yes/No will be displayed)
        /// </summary>
        /// <param name="ds"></param>
        /// <returns>the dataset with the IsActive column modified</returns>
        protected override DataSet PostGetEntities(DataSet ds)
        {
            DSUtils.ReplaceBooleanColumn("IsActive", ds, 0);
            return ds;
        }

        #endregion Protected Methods

        #region Public Methods

        public override void FillEditParameters(Dictionary<string, object> editParameters)
        {
            try
            {
                base.FillEditParameters(editParameters);
                if (editParameters.ContainsKey("IdProject"))
                {
                    _IdProject = int.Parse(editParameters["IdProject"].ToString());
                }
                if (editParameters.ContainsKey("IdFunction"))
                {
                    _IdFunction = int.Parse(editParameters["IdFunction"].ToString());
                }
                if (editParameters.ContainsKey("IdAssociate"))
                {
                    _IdAssociate = int.Parse(editParameters["IdAssociate"].ToString());
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public DataSet GetOpenBudgets()
        {
            DataSet dsOpenBudgets;
            try
            {
                dsOpenBudgets = this.GetEntity().GetCustomDataSet("GetOpenBudgets", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dsOpenBudgets;
        }

		public bool IsAssociatePMOnProject()
		{
			object result;
			result = this.GetEntity().ExecuteScalar("IsAssociatePMOnProject", this);

			return Convert.ToBoolean(result);
		}
        #endregion Public Methods
    }
}
