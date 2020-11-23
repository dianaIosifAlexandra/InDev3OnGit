using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.Entities.Budget;
using System.Data;

namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBFollowUpRevisedBudget:DBGenericEntity
    {
        public DBFollowUpRevisedBudget(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IFollowUpRevisedBudget)
            {
                IFollowUpRevisedBudget followUpRevisedBudget = (IFollowUpRevisedBudget)ent;
                DBStoredProcedure spGetFollowUpRevisedBudget = new DBStoredProcedure();
                spGetFollowUpRevisedBudget.ProcedureName = "bgtGetRevisedBudgetStates";
                spGetFollowUpRevisedBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
                spGetFollowUpRevisedBudget.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpRevisedBudget.BudVersion));
                this.AddStoredProcedure("SelectObject", spGetFollowUpRevisedBudget);

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "bgtUpdateRevisedBudgetStates";
                spUpdate.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
                spUpdate.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpRevisedBudget.BudVersion));
                spUpdate.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociate));
                spUpdate.AddParameter(new DBParameter("@State", DbType.String, ParameterDirection.Input, followUpRevisedBudget.StateCode));
                this.AddStoredProcedure("UpdateObject", spUpdate);

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "bgtDeleteRevisedBudgetStates";
                spDelete.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
                spDelete.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpRevisedBudget.BudVersion));
                spDelete.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociate));
                this.AddStoredProcedure("DeleteObject", spDelete);

                
                DBStoredProcedure spGetRevisedBudgetStateForEvidence = new DBStoredProcedure();
                spGetRevisedBudgetStateForEvidence.ProcedureName = "bgtGetRevisedBudgetStateForEvidence";
                spGetRevisedBudgetStateForEvidence.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
                spGetRevisedBudgetStateForEvidence.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpRevisedBudget.BudVersion));
                spGetRevisedBudgetStateForEvidence.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociate));
                this.AddStoredProcedure("GetRevisedBudgetStateForEvidence", spGetRevisedBudgetStateForEvidence);

                DBStoredProcedure spGetRevisedScalarValidState = new DBStoredProcedure();
                spGetRevisedScalarValidState.ProcedureName = "bgtGetRevisedScalarValidState";
                spGetRevisedScalarValidState.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
                spGetRevisedScalarValidState.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpRevisedBudget.BudVersion));
                this.AddStoredProcedure("GetRevisedScalarValidState", spGetRevisedScalarValidState);

                DBStoredProcedure spValidateRevisedBudget = new DBStoredProcedure();
                spValidateRevisedBudget.ProcedureName = "bgtValidateRevisedBudget";
                spValidateRevisedBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
                spValidateRevisedBudget.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpRevisedBudget.BudVersion));
                this.AddStoredProcedure("ValidateRevisedBudget", spValidateRevisedBudget);

				DBStoredProcedure spCopyRevisedBudget = new DBStoredProcedure();
				spCopyRevisedBudget.ProcedureName = "bgtCopyRevisedBudget";
				spCopyRevisedBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
				spCopyRevisedBudget.AddParameter(new DBParameter("@IdAssociateLM", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociate));
				spCopyRevisedBudget.AddParameter(new DBParameter("@IdAssociateNM", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociateNM));
				this.AddStoredProcedure("CopyRevisedBudget", spCopyRevisedBudget);

            }
        }
    }
}
