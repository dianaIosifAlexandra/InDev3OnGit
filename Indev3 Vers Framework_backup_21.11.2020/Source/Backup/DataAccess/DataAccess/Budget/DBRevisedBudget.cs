using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.Entities;
using System.Data;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.Budget
{
    /// <summary>
    /// Data access class for Revised Budget functionality
    /// </summary>
    public class DBRevisedBudget : DBGenericEntity
    {
        /// <summary>
        /// Constructor of the class
        /// </summary>
        /// <param name="connectionManager">connection manager object containing the sql connection</param>
        public DBRevisedBudget(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IRevisedBudget)
            {
                IRevisedBudget revisedBudget = (IRevisedBudget)ent;

                DBStoredProcedure spGetRevisedBudgetHours = new DBStoredProcedure();
                spGetRevisedBudgetHours.ProcedureName = "bgtGetRevisedBudgetHours";
                spGetRevisedBudgetHours.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                spGetRevisedBudgetHours.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociate));
                spGetRevisedBudgetHours.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociateViewer));
                spGetRevisedBudgetHours.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, revisedBudget.IsAssociateCurrency));
                spGetRevisedBudgetHours.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, revisedBudget.Version));
				spGetRevisedBudgetHours.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, revisedBudget.IdCountry));
                this.AddStoredProcedure("GetRevisedBudgetHours", spGetRevisedBudgetHours);

                DBStoredProcedure spGetRevisedBudgetCosts = new DBStoredProcedure();
                spGetRevisedBudgetCosts.ProcedureName = "bgtGetRevisedBudgetCostSales";
                spGetRevisedBudgetCosts.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                spGetRevisedBudgetCosts.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociate));
                spGetRevisedBudgetCosts.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociateViewer));
                spGetRevisedBudgetCosts.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, revisedBudget.IsAssociateCurrency));
                spGetRevisedBudgetCosts.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, revisedBudget.Version));
				spGetRevisedBudgetCosts.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, revisedBudget.IdCountry));
                this.AddStoredProcedure("GetRevisedBudgetCosts", spGetRevisedBudgetCosts);

                DBStoredProcedure spInsertRevisedBudgetMaster = new DBStoredProcedure();
                spInsertRevisedBudgetMaster.ProcedureName = "bgtInsertRevisedBudget";
                spInsertRevisedBudgetMaster.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                spInsertRevisedBudgetMaster.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociate));
                this.AddStoredProcedure("InsertRevisedBudgetMaster", spInsertRevisedBudgetMaster);

                DBStoredProcedure spInsertRevisedBudget = new DBStoredProcedure();
                spInsertRevisedBudget.ProcedureName = "bgtInsertRevisedBudgetDetail";
                spInsertRevisedBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                spInsertRevisedBudget.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, revisedBudget.IdPhase));
                spInsertRevisedBudget.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, revisedBudget.IdWP));
                spInsertRevisedBudget.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, revisedBudget.IdCostCenter));
                spInsertRevisedBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociate));
                spInsertRevisedBudget.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, revisedBudget.YearMonth));
                this.AddStoredProcedure("InsertObject", spInsertRevisedBudget);

                DBStoredProcedure spUpdateRevisedBudget = new DBStoredProcedure();
                spUpdateRevisedBudget.ProcedureName = "bgtUpdateRevisedBudgetDetail";
                spUpdateRevisedBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                spUpdateRevisedBudget.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, revisedBudget.IdPhase));
                spUpdateRevisedBudget.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, revisedBudget.IdWP));
                spUpdateRevisedBudget.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, revisedBudget.IdCostCenter));
                spUpdateRevisedBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociate));
                spUpdateRevisedBudget.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, revisedBudget.YearMonth));
                if (revisedBudget.SaveHours)
                {
                    spUpdateRevisedBudget.AddParameter(new DBParameter("@HoursQty", DbType.Int32, ParameterDirection.Input, revisedBudget.NewHours));
                }
                else
                {
                    spUpdateRevisedBudget.AddParameter(new DBParameter("@SalesVal", DbType.Decimal, ParameterDirection.Input, revisedBudget.NewSales == ApplicationConstants.DECIMAL_NULL_VALUE ? (object)DBNull.Value : (object)revisedBudget.NewSales));
                }
                this.AddStoredProcedure("UpdateObject", spUpdateRevisedBudget);

                DBStoredProcedure spDeleteRevisedBudget = new DBStoredProcedure();
                spDeleteRevisedBudget.ProcedureName = "bgtDeleteRevisedBudgetDetail";
                spDeleteRevisedBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                spDeleteRevisedBudget.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, revisedBudget.IdPhase));
                spDeleteRevisedBudget.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, revisedBudget.IdWP));
                spDeleteRevisedBudget.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, revisedBudget.IdCostCenter));
                spDeleteRevisedBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, revisedBudget.IdAssociate));
                spDeleteRevisedBudget.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, revisedBudget.YearMonth));
                this.AddStoredProcedure("DeleteObject", spDeleteRevisedBudget);

                DBStoredProcedure spCheckValidatedInitialBudget = new DBStoredProcedure();
                spCheckValidatedInitialBudget.ProcedureName = "bgtRevisedBudgetCheckForValidatedInitial";
                spCheckValidatedInitialBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                this.AddStoredProcedure("CheckValidatedInitialBudget", spCheckValidatedInitialBudget);

                DBStoredProcedure spGetRevisedVersionNo = new DBStoredProcedure();
                spGetRevisedVersionNo.ProcedureName = "bgtGetRevisedVersionNo";
                spGetRevisedVersionNo.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                spGetRevisedVersionNo.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, revisedBudget.Version));
                this.AddStoredProcedure("GetRevisedVersionNo", spGetRevisedVersionNo);

                DBStoredProcedure spGetRevisedVersions = new DBStoredProcedure();
                spGetRevisedVersions.ProcedureName = "bgtGetRevisedVersions";
                spGetRevisedVersions.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, revisedBudget.IdProject));
                spGetRevisedVersions.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, revisedBudget.Version));
                this.AddStoredProcedure("GetRevisedVersions", spGetRevisedVersions);
            }
        }
    }
}
