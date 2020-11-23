using System;
using System.Collections.Generic;
using System.Text;

using Inergy.Indev3.ApplicationFramework;

using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;

using System.Data;
using System.Data.SqlClient;


namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBWPPreselection : DBGenericEntity
    {
        public DBWPPreselection(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IWPPreselection)
            {
                IWPPreselection wpPreselection = (IWPPreselection)ent;

                DBStoredProcedure spSelectWPUsed = new DBStoredProcedure();
                switch (wpPreselection.BudgetType)
                {
                    case ApplicationConstants.MODULE_INITIAL:
                        spSelectWPUsed.ProcedureName = "bpsSelectInitialBudgetWPUsed";
                        break;
                    case ApplicationConstants.MODULE_REVISED:
                        spSelectWPUsed.ProcedureName = "bpsSelectRevisedBudgetWPUsed";
                        break;
                    case ApplicationConstants.MODULE_REFORECAST:
                        spSelectWPUsed.ProcedureName = "bpsSelectReforecastWPUsed";
                        break;
                }
                spSelectWPUsed.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, wpPreselection.IdProject));
                spSelectWPUsed.AddParameter(new DBParameter("@BudgetVersion", DbType.String, ParameterDirection.Input, wpPreselection.BudgetVersion));
                spSelectWPUsed.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, wpPreselection.IdAssociate));
                spSelectWPUsed.AddParameter(new DBParameter("@ActiveState", DbType.String, ParameterDirection.Input, wpPreselection.ActiveState));
                this.AddStoredProcedure("SelectObject", spSelectWPUsed);

                DBStoredProcedure spSelectWPUnused = new DBStoredProcedure();
                switch (wpPreselection.BudgetType)
                {
                    case ApplicationConstants.MODULE_INITIAL:
                        spSelectWPUnused.ProcedureName = "bpsSelectInitialBudgetWPUnused";
                        break;
                    case ApplicationConstants.MODULE_REVISED:
                        spSelectWPUnused.ProcedureName = "bpsSelectRevisedBudgetWPUnused";
                        break;
                    case ApplicationConstants.MODULE_REFORECAST:
                        spSelectWPUnused.ProcedureName = "bpsSelectReforecastWPUnused";
                        break;
                }
                spSelectWPUnused.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, wpPreselection.IdProject));
                spSelectWPUnused.AddParameter(new DBParameter("@BudgetVersion", DbType.String, ParameterDirection.Input, wpPreselection.BudgetVersion));
                spSelectWPUnused.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, wpPreselection.IdAssociate));
                spSelectWPUnused.AddParameter(new DBParameter("@ActiveState", DbType.String, ParameterDirection.Input, wpPreselection.ActiveState));
                this.AddStoredProcedure("SelectWPUnused", spSelectWPUnused);



                DBStoredProcedure spSelectWPInfo = new DBStoredProcedure();
                switch (wpPreselection.BudgetType)
                {
                    case ApplicationConstants.MODULE_INITIAL:
                        spSelectWPInfo.ProcedureName = "bpsSelectInitialBudgetWPInfo";
                        break;
                    case ApplicationConstants.MODULE_REVISED:
                        spSelectWPInfo.ProcedureName = "bpsSelectRevisedBudgetWPInfo";
                        break;
                    case ApplicationConstants.MODULE_REFORECAST:
                        spSelectWPInfo.ProcedureName = "bpsSelectReforecastWPInfo";
                        break;
                }
                spSelectWPInfo.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, wpPreselection.IdProject));
                spSelectWPInfo.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, wpPreselection.IdPhase));
                spSelectWPInfo.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, wpPreselection.IdWP));
                spSelectWPInfo.AddParameter(new DBParameter("@BudgetVersion", DbType.String, ParameterDirection.Input, wpPreselection.BudgetVersion));
                spSelectWPInfo.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, wpPreselection.IdAssociate));
                if(!string.IsNullOrEmpty(wpPreselection.WPCode))
                    spSelectWPInfo.AddParameter(new DBParameter("@WPCode", DbType.Int32, ParameterDirection.Input, wpPreselection.WPCode));
                else
                    spSelectWPInfo.AddParameter(new DBParameter("@WPCode", DbType.Int32, ParameterDirection.Input, string.Empty));
                this.AddStoredProcedure("SelectWPInfo", spSelectWPInfo);


              
                DBStoredProcedure spDeleteWPInfo = new DBStoredProcedure();
                switch (wpPreselection.BudgetType)
                {
                    case ApplicationConstants.MODULE_INITIAL:
                        spDeleteWPInfo.ProcedureName = "bpsDeleteInitialBudgetWPInfo";
                        break;
                    case ApplicationConstants.MODULE_REVISED:
                        spDeleteWPInfo.ProcedureName = "bpsDeleteRevisedBudgetWPInfo";
                        break;
                    case ApplicationConstants.MODULE_REFORECAST:
                        spDeleteWPInfo.ProcedureName = "bpsDeleteReforecastWPInfo";
                        break;
                }

                spDeleteWPInfo.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, wpPreselection.IdProject));
                spDeleteWPInfo.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, wpPreselection.IdPhase));
                spDeleteWPInfo.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, wpPreselection.IdWP));
                spDeleteWPInfo.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, wpPreselection.IdAssociate));
                spDeleteWPInfo.AddParameter(new DBParameter("@WPCode", DbType.Int32, ParameterDirection.Input, wpPreselection.WPCode));
                this.AddStoredProcedure("DeleteWPInfo", spDeleteWPInfo);


            }
        }
        /// <summary>
        /// Inserts all work selected work packages (wppreselection screen) into temp table ##BUDGET_PRESELECTION_TEMP
        /// </summary>
        /// <param name="commandText"></param>
        public void BulkInsert(string commandText)
        {
            SqlCommand bulkInsertCommand = new SqlCommand();
            bulkInsertCommand.CommandType = CommandType.Text;
            bulkInsertCommand.CommandText = commandText;
            CurrentConnectionManager.ExecuteTextCommand(bulkInsertCommand);
        }
    }
}
