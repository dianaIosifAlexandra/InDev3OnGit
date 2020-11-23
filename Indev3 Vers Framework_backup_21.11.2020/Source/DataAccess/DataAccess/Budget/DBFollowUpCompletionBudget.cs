using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.Entities.Budget;
using System.Data;

namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBFollowUpCompletionBudget : DBGenericEntity
    {
        public DBFollowUpCompletionBudget(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IFollowUpCompletionBudget)
            {
                IFollowUpCompletionBudget followUpCompletionBudget = (IFollowUpCompletionBudget)ent;
                DBStoredProcedure spGetFollowUpCompletionBudget = new DBStoredProcedure();
                spGetFollowUpCompletionBudget.ProcedureName = "bgtGetCompletionBudgetStates";
                spGetFollowUpCompletionBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spGetFollowUpCompletionBudget.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpCompletionBudget.BudVersion));
                this.AddStoredProcedure("SelectObject", spGetFollowUpCompletionBudget);

                DBStoredProcedure spUpdateFollowUpCompletionBudget = new DBStoredProcedure();
                spUpdateFollowUpCompletionBudget.ProcedureName = "bgtUpdateCompletionBudgetStates";
                spUpdateFollowUpCompletionBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spUpdateFollowUpCompletionBudget.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpCompletionBudget.BudVersion));
                spUpdateFollowUpCompletionBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociate));
                spUpdateFollowUpCompletionBudget.AddParameter(new DBParameter("@State", DbType.String, ParameterDirection.Input, followUpCompletionBudget.StateCode));
                this.AddStoredProcedure("UpdateObject", spUpdateFollowUpCompletionBudget);

                DBStoredProcedure spDeleteFollowUpCompletionBudget = new DBStoredProcedure();
                spDeleteFollowUpCompletionBudget.ProcedureName = "bgtDeleteCompletionBudgetStates";
                spDeleteFollowUpCompletionBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spDeleteFollowUpCompletionBudget.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpCompletionBudget.BudVersion));
                spDeleteFollowUpCompletionBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociate));
                this.AddStoredProcedure("DeleteObject", spDeleteFollowUpCompletionBudget);

                DBStoredProcedure spValidateCompletionBudget = new DBStoredProcedure();
                spValidateCompletionBudget.ProcedureName = "bgtValidateCompletionBudget";
                spValidateCompletionBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spValidateCompletionBudget.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpCompletionBudget.BudVersion));
                this.AddStoredProcedure("ValidateCompletionBudget", spValidateCompletionBudget);


                DBStoredProcedure spGetCompletionBudgetStateForEvidence = new DBStoredProcedure();
                spGetCompletionBudgetStateForEvidence.ProcedureName = "bgtGetCompletionBudgetStateForEvidence";
                spGetCompletionBudgetStateForEvidence.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spGetCompletionBudgetStateForEvidence.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpCompletionBudget.BudVersion));
                spGetCompletionBudgetStateForEvidence.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociate));
                this.AddStoredProcedure("GetCompletionBudgetStateForEvidence", spGetCompletionBudgetStateForEvidence);

                DBStoredProcedure spGetCompletionScalarValidState = new DBStoredProcedure();
                spGetCompletionScalarValidState.ProcedureName = "bgtGetRevisedScalarValidState";
                spGetCompletionScalarValidState.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spGetCompletionScalarValidState.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpCompletionBudget.BudVersion));
                this.AddStoredProcedure("GetCompletionScalarValidState", spGetCompletionScalarValidState);

                DBStoredProcedure spGetCompletionBudgetValidState = new DBStoredProcedure();
                spGetCompletionBudgetValidState.ProcedureName = "bgtGetInitialBudget_IsValidated";
                spGetCompletionBudgetValidState.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spGetCompletionBudgetValidState.AddParameter(new DBParameter("@BudVersion", DbType.String, ParameterDirection.Input, followUpCompletionBudget.BudVersion));
                this.AddStoredProcedure("GetCompletionBudgetValidState", spGetCompletionBudgetValidState);

				DBStoredProcedure spMoveCompletionBudget = new DBStoredProcedure();
                spMoveCompletionBudget.ProcedureName = "bgtMoveToCompletionBudget";
                spMoveCompletionBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spMoveCompletionBudget.AddParameter(new DBParameter("@IdAssociateLM", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociate));
                spMoveCompletionBudget.AddParameter(new DBParameter("@IdAssociateNM", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociateNM));
                spMoveCompletionBudget.AddParameter(new DBParameter("@IdAssociateMovingBudget", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociateMovingBudget));
                this.AddStoredProcedure("MoveCompletionBudget", spMoveCompletionBudget);

                DBStoredProcedure spMoveCompletionBudgetReleasedVersion = new DBStoredProcedure();
                spMoveCompletionBudgetReleasedVersion.ProcedureName = "bgtMoveToCompletionBudgetReleasedVersion";
                spMoveCompletionBudgetReleasedVersion.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdProject));
                spMoveCompletionBudgetReleasedVersion.AddParameter(new DBParameter("@IdAssociateLM", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociate));
                spMoveCompletionBudgetReleasedVersion.AddParameter(new DBParameter("@IdAssociateNM", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociateNM));
                spMoveCompletionBudgetReleasedVersion.AddParameter(new DBParameter("@IdAssociateMovingBudget", DbType.Int32, ParameterDirection.Input, followUpCompletionBudget.IdAssociateMovingBudget));
                this.AddStoredProcedure("MoveCompletionBudgetReleasedVersion", spMoveCompletionBudgetReleasedVersion);

            }
        }
    }
}
