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

                DBStoredProcedure spMoveRevisedBudget = new DBStoredProcedure();
                spMoveRevisedBudget.ProcedureName = "bgtMoveRevisedBudget";
                spMoveRevisedBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
                spMoveRevisedBudget.AddParameter(new DBParameter("@IdAssociateLM", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociate));
                spMoveRevisedBudget.AddParameter(new DBParameter("@IdAssociateNM", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociateNM));
                spMoveRevisedBudget.AddParameter(new DBParameter("@IdAssociateMovingBudget", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociateMovingBudget));
                this.AddStoredProcedure("MoveRevisedBudget", spMoveRevisedBudget);

                DBStoredProcedure spMoveRevisedBudgetReleasedVersion = new DBStoredProcedure();
                spMoveRevisedBudgetReleasedVersion.ProcedureName = "bgtMoveRevisedBudgetReleasedVersion";
                spMoveRevisedBudgetReleasedVersion.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdProject));
                spMoveRevisedBudgetReleasedVersion.AddParameter(new DBParameter("@IdAssociateLM", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociate));
                spMoveRevisedBudgetReleasedVersion.AddParameter(new DBParameter("@IdAssociateNM", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociateNM));
                spMoveRevisedBudgetReleasedVersion.AddParameter(new DBParameter("@IdAssociateMovingBudget", DbType.Int32, ParameterDirection.Input, followUpRevisedBudget.IdAssociateMovingBudget));
                this.AddStoredProcedure("MoveRevisedBudgetReleasedVersion", spMoveRevisedBudgetReleasedVersion);

            }
        }
    }
}
