using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class FollowUpCompletionBudget : GenericEntity, IFollowUpCompletionBudget
    {
        #region Members
        private int _idProject = ApplicationConstants.INT_NULL_VALUE;
        public int IdProject
        {
            get { return _idProject; }
            set { _idProject = value; }
        }
        private int _idGeneration = ApplicationConstants.INT_NULL_VALUE;
        public int IdGeneration
        {
            get { return _idGeneration; }
            set { _idGeneration = value; }
        }

        private int _idAssociate = ApplicationConstants.INT_NULL_VALUE;
        public int IdAssociate
        {
            get { return _idAssociate; }
            set { _idAssociate = value; }
        }

        private string _stateCode = string.Empty;
        public string StateCode
        {
            get { return _stateCode; }
            set { _stateCode = value; }
        }

        private DateTime _stateDate;
        public DateTime StateDate
        {
            get { return _stateDate; }
            set { _stateDate = value; }
        }

        private string _budVersion = string.Empty;
        public string BudVersion
        {
            get { return _budVersion; }
            set { _budVersion = value; }
        }

        private int _yearMonthActualData;
        public int YearMonthActualData
        {
            get { return _yearMonthActualData; }
            set { _yearMonthActualData = value; }
        }

		private int _idAssociateNM = ApplicationConstants.INT_NULL_VALUE;
		public int IdAssociateNM
		{
			get { return _idAssociateNM; }
			set { _idAssociateNM = value; }
		}

        private int _idAssociateMovingBudget = ApplicationConstants.INT_NULL_VALUE;
        public int IdAssociateMovingBudget
        {
            get { return _idAssociateMovingBudget; }
            set { _idAssociateMovingBudget = value; }
        }
        #endregion

        #region Constructor


        public FollowUpCompletionBudget(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBFollowUpCompletionBudget(connectionManager));
            _idProject = ApplicationConstants.INT_NULL_VALUE;
            _idGeneration = ApplicationConstants.INT_NULL_VALUE;
            _idAssociate = ApplicationConstants.INT_NULL_VALUE;
            _stateCode = string.Empty;
            _stateDate = DateTime.MinValue;
            _budVersion = string.Empty;
            _yearMonthActualData = ApplicationConstants.INT_NULL_VALUE;
        }
        #endregion

        #region Public Methods
        public bool GetCompletionBudgetValidState(string spName)
        {
            try
            {
                object budgetState = this.GetEntity().ExecuteScalar(spName, this);
                if (budgetState == DBNull.Value || budgetState == null)
                    return false;
                else
                    return (bool)budgetState;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public string GetCompletionBudgetStateForEvidence(string spName)
        {
            try
            {
                object budgetState = this.GetEntity().ExecuteScalar(spName, this);
                if (budgetState == DBNull.Value || budgetState == null)
                    return ApplicationConstants.BUDGET_STATE_NONE;
                else
                    return budgetState.ToString();
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public void ValidateCompletionBudget(string spName)
        {            
            try
            {
                BeginTransaction();
                this.GetEntity().ExecuteScalar(spName, this);
                CommitTransaction();
            }
            catch (Exception exc)
            {
                RollbackTransaction();
                throw new IndException(exc);
            }
        }

        public void DeleteBudgetRows(int ProjectId, int AssociateId, string BudgetVersion)
        {            
            try
            {
                BeginTransaction();
                this.IdProject = ProjectId;
                this.IdAssociate = AssociateId;
                this.BudVersion = BudgetVersion;
                this.SetDeleted();
                this.Save();

                CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

		public int MoveCompletionBudget(int ProjectId, int IdAssociateLM, int IdAssociateNM, int IdAssociateMovingBudget)
		{
			int result = ApplicationConstants.INT_NULL_VALUE;
			try
			{
				BeginTransaction();
				this.IdProject = ProjectId;
				this.IdAssociate = IdAssociateLM;
				this.IdAssociateNM = IdAssociateNM;
                this.IdAssociateMovingBudget = IdAssociateMovingBudget;
				result = this.GetEntity().ExecuteCustomProcedureWithReturnValue("MoveCompletionBudget", this);
				CommitTransaction();
			}
			catch (Exception ex)
			{
				RollbackTransaction();
				throw new IndException(ex);
			}
			return result;
		}

        public int MoveCompletionBudgetReleasedVersion(int ProjectId, int IdAssociateLM, int IdAssociateNM, int IdAssociateMovingBudget)
        {
            int result = ApplicationConstants.INT_NULL_VALUE;
            try
            {
                BeginTransaction();
                this.IdProject = ProjectId;
                this.IdAssociate = IdAssociateLM;
                this.IdAssociateNM = IdAssociateNM;
                this.IdAssociateMovingBudget = IdAssociateMovingBudget;
                result = this.GetEntity().ExecuteCustomProcedureWithReturnValue("MoveCompletionBudgetReleasedVersion", this);
                CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
            return result;
        }

        #endregion Public Methods
    }
}
