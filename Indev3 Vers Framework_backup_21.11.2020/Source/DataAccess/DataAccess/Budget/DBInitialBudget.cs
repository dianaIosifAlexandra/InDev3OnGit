using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.Entities;
using System.Data;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBInitialBudget : DBGenericEntity
    {
        public DBInitialBudget(object connectionManager)
            : base(connectionManager)
        {

        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IInitialBudget)
            {
                IInitialBudget iInitialBudget = (IInitialBudget)ent;

                DBStoredProcedure spGetInitialBudget = new DBStoredProcedure();
                spGetInitialBudget.ProcedureName = "bgtGetInitialBudgetEvidence";
                spGetInitialBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdProject));
                spGetInitialBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdAssociate));
                spGetInitialBudget.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdAssociateViewer));
                spGetInitialBudget.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, iInitialBudget.IsAssociateCurrency));
				spGetInitialBudget.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdCountry));
                spGetInitialBudget.AddParameter(new DBParameter("@IdCurrencyDisplay", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdCurrency));
                this.AddStoredProcedure("SelectObject", spGetInitialBudget);

                DBStoredProcedure spInsertInitialBudgetMaster = new DBStoredProcedure();
                spInsertInitialBudgetMaster.ProcedureName = "bgtInsertInitialBudget";
                spInsertInitialBudgetMaster.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdProject));
                this.AddStoredProcedure("InsertIntialBudgetMaster", spInsertInitialBudgetMaster);
                
                DBStoredProcedure spInsertInitialBudget = new DBStoredProcedure();
                spInsertInitialBudget.ProcedureName = "bgtInsertInitialBudgetDetail";
                spInsertInitialBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdProject));
                spInsertInitialBudget.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdPhase));
                spInsertInitialBudget.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdWP));
                spInsertInitialBudget.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdCostCenter));
                spInsertInitialBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdAssociate));
                spInsertInitialBudget.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, iInitialBudget.YearMonth));
                this.AddStoredProcedure("InsertObject", spInsertInitialBudget);

                DBStoredProcedure spUpdateInitialBudget = new DBStoredProcedure();
                spUpdateInitialBudget.ProcedureName = "bgtUpdateInitialBudgetDetail";
                spUpdateInitialBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdProject));
                spUpdateInitialBudget.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdPhase));
                spUpdateInitialBudget.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdWP));
                spUpdateInitialBudget.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdCostCenter));
                spUpdateInitialBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdAssociate));
                spUpdateInitialBudget.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, iInitialBudget.YearMonth));
                if (iInitialBudget.TotalHours != ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS)
                    spUpdateInitialBudget.AddParameter(new DBParameter("@HoursQty", DbType.Int32, ParameterDirection.Input, iInitialBudget.TotalHours));
                else
                    spUpdateInitialBudget.AddParameter(new DBParameter("@HoursQty", DbType.Int32, ParameterDirection.Input, DBNull.Value));
                if (iInitialBudget.ValuedHours != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdateInitialBudget.AddParameter(new DBParameter("@HoursVal", DbType.Decimal, ParameterDirection.Input, iInitialBudget.ValuedHours));
                else
                    spUpdateInitialBudget.AddParameter(new DBParameter("@HoursVal", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                if (iInitialBudget.Sales != ApplicationConstants.DECIMAL_NULL_VALUE)
                    spUpdateInitialBudget.AddParameter(new DBParameter("@SalesVal", DbType.Decimal, ParameterDirection.Input, iInitialBudget.Sales));
                else
                    spUpdateInitialBudget.AddParameter(new DBParameter("@SalesVal", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                this.AddStoredProcedure("UpdateObject", spUpdateInitialBudget);

                DBStoredProcedure spDeleteInitialBudget = new DBStoredProcedure();
                spDeleteInitialBudget.ProcedureName = "bgtDeleteInitialBudgetDetail";
                spDeleteInitialBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdProject));
                spDeleteInitialBudget.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdPhase));
                spDeleteInitialBudget.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdWP));
                spDeleteInitialBudget.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdCostCenter));
                spDeleteInitialBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdAssociate));
                spDeleteInitialBudget.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, iInitialBudget.YearMonth));
                this.AddStoredProcedure("DeleteObject", spDeleteInitialBudget);

                DBStoredProcedure spInitialBudgetCheck = new DBStoredProcedure();
                spInitialBudgetCheck.ProcedureName = "bgtInitialBudgetEvidenceCheck";
                spInitialBudgetCheck.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, iInitialBudget.IdProject));
                this.AddStoredProcedure("InitialBudgetCheck", spInitialBudgetCheck);

            }
        }
    }
}
