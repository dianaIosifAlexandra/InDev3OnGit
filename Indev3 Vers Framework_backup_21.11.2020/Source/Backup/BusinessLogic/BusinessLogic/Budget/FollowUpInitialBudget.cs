using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// Represents the follow up initial budget entity
    /// </summary>
    public class FollowUpInitialBudget : GenericEntity, IFollowUpInitialBudget
    {
        #region Members


        private int _IdProject = ApplicationConstants.INT_NULL_VALUE;
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

        private int _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
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

        private string _StateCode;
        public string StateCode
        {
            get
            {
                return _StateCode;
            }
            set
            {
                _StateCode = value;
            }
        }

        private DateTime _StateDate;
        public DateTime StateDate
        {
            get
            {
                return _StateDate;
            }
            set
            {
                _StateDate = value;
            }
        }

        private bool _IsValidated;
        public bool IsValidated
        {
            get
            {
                return _IsValidated;
            }
            set
            {
                _IsValidated = value;
            }
        }

        private string _Description;
        public string Description
        {
            get
            {
                return _Description;
            }
            set
            {
                _Description = value;
            }
        }

        private string _BudgetState;
        public string BudgetState
        {
            get { return _BudgetState; }
            set { _BudgetState = value; }
        }
        #endregion

        #region Constructors
        public FollowUpInitialBudget(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBFollowUpInitialBudget(connectionManager));
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
            _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
            _StateCode = string.Empty;
            _StateDate = DateTime.MinValue;
            _IsValidated = false;
            _Description = string.Empty;
            _BudgetState = string.Empty;

        }
        
        #endregion

        #region Public Mehtods
        public DataSet GetInitialBudgetStateForEvidence(string spName)
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
        
        public void ValidateInitialBudget(string spName)
        {           
            try
            {
                BeginTransaction();
                this.GetEntity().ExecuteCustomProcedure(spName, this);
                CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        public bool GetInitialBudgetValidState(string spName)
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

        public void DeleteBudgetRows(int IdProject, int IdAssociate)
        {    
            try
            {
                BeginTransaction();

                this.IdProject = IdProject;
                this.IdAssociate = IdAssociate;
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
        #endregion
    }        
}
