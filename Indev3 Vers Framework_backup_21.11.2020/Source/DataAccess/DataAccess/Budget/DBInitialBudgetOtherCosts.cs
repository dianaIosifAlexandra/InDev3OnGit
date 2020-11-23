using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.Entities;
using System.Data;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBInitialBudgetOtherCosts : DBGenericEntity
    {
        public DBInitialBudgetOtherCosts(object connectionManager)
            : base(connectionManager)
        {

        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IInitialBudgetOtherCosts)
            {
                IInitialBudgetOtherCosts budgetOtherCosts = (IInitialBudgetOtherCosts)ent;

                DBStoredProcedure spGetBudgetInitialOtherCosts = new DBStoredProcedure();
                spGetBudgetInitialOtherCosts.ProcedureName = "bgtGetInitialBudgetOtherCost";
                spGetBudgetInitialOtherCosts.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdProject));
                spGetBudgetInitialOtherCosts.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdPhase));
                spGetBudgetInitialOtherCosts.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdWP));
                spGetBudgetInitialOtherCosts.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostCenter));
                spGetBudgetInitialOtherCosts.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdAssociate));
                spGetBudgetInitialOtherCosts.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdAssociateViewer));
                spGetBudgetInitialOtherCosts.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, budgetOtherCosts.IsAssociateCurrency));
                spGetBudgetInitialOtherCosts.AddParameter(new DBParameter("@IdCurrencyDisplay", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCurrency));
                this.AddStoredProcedure("SelectObject", spGetBudgetInitialOtherCosts);

                DBStoredProcedure spInsertInitialBudgetOtherCosts = new DBStoredProcedure();
                spInsertInitialBudgetOtherCosts.ProcedureName = "bgtInsertInitialBudgetOtherCost";
                spInsertInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdProject));
                spInsertInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdPhase));
                spInsertInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdWP));
                spInsertInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostCenter));
                spInsertInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdAssociate));
                spInsertInitialBudgetOtherCosts.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.YearMonth));
                spInsertInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdCostType", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostType));
                this.AddStoredProcedure("InsertObject", spInsertInitialBudgetOtherCosts);

                DBStoredProcedure spUpdateInitialBudgetOtherCosts = new DBStoredProcedure();
                spUpdateInitialBudgetOtherCosts.ProcedureName = "bgtUpdateInitialBudgetOtherCost";
                spUpdateInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdProject));
                spUpdateInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdPhase));
                spUpdateInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdWP));
                spUpdateInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostCenter));
                spUpdateInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdAssociate));
                spUpdateInitialBudgetOtherCosts.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.YearMonth));
                spUpdateInitialBudgetOtherCosts.AddParameter(new DBParameter("@IdCostType", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.IdCostType));
                if (budgetOtherCosts.CostVal != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdateInitialBudgetOtherCosts.AddParameter(new DBParameter("@CostVal", DbType.Int32, ParameterDirection.Input, budgetOtherCosts.CostVal));
                this.AddStoredProcedure("UpdateObject", spUpdateInitialBudgetOtherCosts);
            }
        }
    }
}
