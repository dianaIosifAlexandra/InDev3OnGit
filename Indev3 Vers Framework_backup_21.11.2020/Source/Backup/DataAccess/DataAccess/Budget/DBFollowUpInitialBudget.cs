using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.Entities.Budget;
using System.Data;

namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBFollowUpInitialBudget : DBGenericEntity
    {
        public DBFollowUpInitialBudget(object connectionManager)
            : base(connectionManager)
        {
        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IFollowUpInitialBudget)
            {
                IFollowUpInitialBudget followUpInitialBudget = (IFollowUpInitialBudget)ent;
                DBStoredProcedure spGetFollowUpInitialBudget = new DBStoredProcedure();
                spGetFollowUpInitialBudget.ProcedureName = "bgtGetInitialBudgetStates";
                spGetFollowUpInitialBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdProject));               
                this.AddStoredProcedure("SelectObject", spGetFollowUpInitialBudget);

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "bgtUpdateInitialBudgetStates";
                spUpdate.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdProject));
                spUpdate.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdAssociate));
                spUpdate.AddParameter(new DBParameter("@State", DbType.String, ParameterDirection.Input, followUpInitialBudget.StateCode));
                this.AddStoredProcedure("UpdateObject", spUpdate);

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "bgtDeleteInitialBudgetStates";
                spDelete.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdProject));
                spDelete.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdAssociate));
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spValidateInitialBudget = new DBStoredProcedure();
                spValidateInitialBudget.ProcedureName = "bgtValidateInitialBudget";
                spValidateInitialBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdProject));
                this.AddStoredProcedure("ValidateInitialBudget", spValidateInitialBudget);

                DBStoredProcedure spGetInitialBudgetStateForEvidence = new DBStoredProcedure();
                spGetInitialBudgetStateForEvidence.ProcedureName = "bgtGetInitialBudgetStateForEvidence";
                spGetInitialBudgetStateForEvidence.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdProject));
                spGetInitialBudgetStateForEvidence.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdAssociate));
                this.AddStoredProcedure("GetInitialBudgetStateForEvidence", spGetInitialBudgetStateForEvidence);

                DBStoredProcedure spGetInitialBudgetValidState = new DBStoredProcedure();
                spGetInitialBudgetValidState.ProcedureName = "bgtGetInitialBudget_IsValidated";
                spGetInitialBudgetValidState.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, followUpInitialBudget.IdProject));
                this.AddStoredProcedure("GetInitialBudgetValidState", spGetInitialBudgetValidState);
            }
        }
    }
}
