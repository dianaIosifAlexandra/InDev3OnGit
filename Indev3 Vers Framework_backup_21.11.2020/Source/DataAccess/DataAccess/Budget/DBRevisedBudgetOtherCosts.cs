using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.Entities;
using System.Data;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBRevisedBudgetOtherCosts : DBGenericEntity
    {
        public DBRevisedBudgetOtherCosts(object connectionManager)
            : base(connectionManager)
        {

        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IRevisedBudgetOtherCosts)
            {
                IRevisedBudgetOtherCosts budgetOtherCosts = (IRevisedBudgetOtherCosts)ent;

                DBStoredProcedure spGetBudgetRevisedOtherCosts = new DBStoredProcedure();
                spGetBudgetRevisedOtherCosts.ProcedureName = "bgtGetRevisedBudgetOtherCosts";
                spGetBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdProject));
                spGetBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdPhase));
                spGetBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdWP));
                spGetBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostCenter));
                spGetBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdAssociate));
                spGetBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdAssociateViewer));
                spGetBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, budgetOtherCosts.IsAssociateCurrency));
                this.AddStoredProcedure("SelectObject", spGetBudgetRevisedOtherCosts);

                DBStoredProcedure spInsertBudgetRevisedOtherCosts = new DBStoredProcedure();
                spInsertBudgetRevisedOtherCosts.ProcedureName = "bgtInsertRevisedBudgetOtherCosts";
                spInsertBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdProject));
                spInsertBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdPhase));
                spInsertBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdWP));
                spInsertBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostCenter));
                spInsertBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdAssociate));
                spInsertBudgetRevisedOtherCosts.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.YearMonth));
                spInsertBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdCostType", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostType));
                this.AddStoredProcedure("InsertObject", spInsertBudgetRevisedOtherCosts);

                DBStoredProcedure spUpdateBudgetRevisedOtherCosts = new DBStoredProcedure();
                spUpdateBudgetRevisedOtherCosts.ProcedureName = "bgtUpdateRevisedBudgetOtherCosts";
                spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdProject));
                spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdPhase));
                spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdWP));
                spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostCenter));
                spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdAssociate));
                spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.YearMonth));
                spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@IdCostType", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostType));
                if (budgetOtherCosts.CostVal != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@CostVal", DbType.Decimal, ParameterDirection.Input, budgetOtherCosts.CostVal));
                else
                    spUpdateBudgetRevisedOtherCosts.AddParameter(new DBParameter("@CostVal", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                this.AddStoredProcedure("UpdateObject", spUpdateBudgetRevisedOtherCosts);
            }
        }
    }
}
