using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;
using System.Data;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBReforecastBudget : DBGenericEntity
    {
        /// <summary>
        /// Constructor of the class
        /// </summary>
        /// <param name="connectionManager">connection manager object containing the sql connection</param>
        public DBReforecastBudget(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IReforecastBudget)
            {
                IReforecastBudget reforecastBudget = (IReforecastBudget)ent;

                DBStoredProcedure spGetHoursData = new DBStoredProcedure();
                spGetHoursData.ProcedureName = "bgtGetToCompletionBudgetHoursEvidence";
                spGetHoursData.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spGetHoursData.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spGetHoursData.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociateViewer));
                spGetHoursData.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, reforecastBudget.Version));
				spGetHoursData.AddParameter(new DBParameter("@ShowOnlyCCsWithSignificantValues", DbType.Boolean, ParameterDirection.Input, reforecastBudget.ShowOnlyCCsWithSighificantValues));
				spGetHoursData.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCountry));
                this.AddStoredProcedure("GetHoursData", spGetHoursData);

                DBStoredProcedure spGetSalesData = new DBStoredProcedure();
                spGetSalesData.ProcedureName = "bgtGetToCompletionBudgetSalesEvidence";
                spGetSalesData.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spGetSalesData.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spGetSalesData.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociateViewer));
                spGetSalesData.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, reforecastBudget.IsAssociateCurrency));
                spGetSalesData.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, reforecastBudget.Version));
				spGetSalesData.AddParameter(new DBParameter("@ShowOnlyCCsWithSignificantValues", DbType.Boolean, ParameterDirection.Input, reforecastBudget.ShowOnlyCCsWithSighificantValues));
				spGetSalesData.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCountry));
                this.AddStoredProcedure("GetSalesData", spGetSalesData);

                DBStoredProcedure spGetValHoursData = new DBStoredProcedure();
                spGetValHoursData.ProcedureName = "bgtGetToCompletionBudgetValHoursEvidence";
                spGetValHoursData.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spGetValHoursData.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spGetValHoursData.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociateViewer));
                spGetValHoursData.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, reforecastBudget.IsAssociateCurrency));
                spGetValHoursData.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, reforecastBudget.Version));
				spGetValHoursData.AddParameter(new DBParameter("@ShowOnlyCCsWithSignificantValues", DbType.Boolean, ParameterDirection.Input, reforecastBudget.ShowOnlyCCsWithSighificantValues));
				spGetValHoursData.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCountry));
                this.AddStoredProcedure("GetValHoursData", spGetValHoursData);

                DBStoredProcedure spGetOtherCostsData = new DBStoredProcedure();
                spGetOtherCostsData.ProcedureName = "bgtGetToCompletionBudgetOtherCostsEvidence";
                spGetOtherCostsData.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spGetOtherCostsData.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spGetOtherCostsData.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociateViewer));
                spGetOtherCostsData.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, reforecastBudget.IsAssociateCurrency));
                spGetOtherCostsData.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, reforecastBudget.Version));
                spGetOtherCostsData.AddParameter(new DBParameter("@IdCostType", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCostType));
				spGetOtherCostsData.AddParameter(new DBParameter("@ShowOnlyCCsWithSignificantValues", DbType.Boolean, ParameterDirection.Input, reforecastBudget.ShowOnlyCCsWithSighificantValues));
				spGetOtherCostsData.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCountry));
                this.AddStoredProcedure("GetOtherCostsData", spGetOtherCostsData);

                DBStoredProcedure spGetGrossCostsData = new DBStoredProcedure();
                spGetGrossCostsData.ProcedureName = "bgtGetToCompletionBudgetGrossCostsEvidence";
                spGetGrossCostsData.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spGetGrossCostsData.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spGetGrossCostsData.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociateViewer));
                spGetGrossCostsData.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, reforecastBudget.IsAssociateCurrency));
                spGetGrossCostsData.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, reforecastBudget.Version));
				spGetGrossCostsData.AddParameter(new DBParameter("@ShowOnlyCCsWithSignificantValues", DbType.Boolean, ParameterDirection.Input, reforecastBudget.ShowOnlyCCsWithSighificantValues));
				spGetGrossCostsData.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCountry));
                this.AddStoredProcedure("GetGrossCostsData", spGetGrossCostsData);

                DBStoredProcedure spGetNetCostsData = new DBStoredProcedure();
                spGetNetCostsData.ProcedureName = "bgtGetToCompletionBudgetNetCostsEvidence";
                spGetNetCostsData.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spGetNetCostsData.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spGetNetCostsData.AddParameter(new DBParameter("@IdAssociateViewer", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociateViewer));
                spGetNetCostsData.AddParameter(new DBParameter("@IsAssociateCurrency", DbType.Boolean, ParameterDirection.Input, reforecastBudget.IsAssociateCurrency));
                spGetNetCostsData.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, reforecastBudget.Version));
				spGetNetCostsData.AddParameter(new DBParameter("@ShowOnlyCCsWithSignificantValues", DbType.Boolean, ParameterDirection.Input, reforecastBudget.ShowOnlyCCsWithSighificantValues));
				spGetNetCostsData.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCountry));
                this.AddStoredProcedure("GetNetCostsData", spGetNetCostsData);

                DBStoredProcedure spUpdateMasterRecord = new DBStoredProcedure();
                spUpdateMasterRecord.ProcedureName = "bgtUpdateToCompletionBudgetProgress";
                spUpdateMasterRecord.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spUpdateMasterRecord.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spUpdateMasterRecord.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdPhase));
                spUpdateMasterRecord.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdWP));
                if (reforecastBudget.PercentComplete != ApplicationConstants.DECIMAL_NULL_VALUE)
                {
                    spUpdateMasterRecord.AddParameter(new DBParameter("@Percentage", DbType.Decimal, ParameterDirection.Input, reforecastBudget.PercentComplete));
                }
                else
                {
                    spUpdateMasterRecord.AddParameter(new DBParameter("@Percentage", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                }
                this.AddStoredProcedure("UpdateMasterRecord", spUpdateMasterRecord);

                DBStoredProcedure spUpdateHours = new DBStoredProcedure();
                spUpdateHours.ProcedureName = "bgtUpdateToCompletionBudgetHours";
                spUpdateHours.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spUpdateHours.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spUpdateHours.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdPhase));
                spUpdateHours.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdWP));
                spUpdateHours.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCostCenter));
                spUpdateHours.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, reforecastBudget.YearMonth));
                if (reforecastBudget.New != ApplicationConstants.DECIMAL_NULL_VALUE)
                {
                    spUpdateHours.AddParameter(new DBParameter("@Hours", DbType.Int32, ParameterDirection.Input, reforecastBudget.New));
                }
                else
                {
                    spUpdateHours.AddParameter(new DBParameter("@Hours", DbType.Int32, ParameterDirection.Input, DBNull.Value));
                }
                spUpdateHours.AddParameter(new DBParameter("@ActualDataTimestamp", DbType.DateTime, ParameterDirection.Input, reforecastBudget.ActualDataTimestamp));
                this.AddStoredProcedure("UpdateHours", spUpdateHours);

                DBStoredProcedure spUpdateOtherCosts = new DBStoredProcedure();
                spUpdateOtherCosts.ProcedureName = "bgtUpdateToCompletionOtherCosts";
                spUpdateOtherCosts.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spUpdateOtherCosts.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spUpdateOtherCosts.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdPhase));
                spUpdateOtherCosts.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdWP));
                spUpdateOtherCosts.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCostCenter));
                spUpdateOtherCosts.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, reforecastBudget.YearMonth));
                if (reforecastBudget.New != ApplicationConstants.DECIMAL_NULL_VALUE)
                {
                    spUpdateOtherCosts.AddParameter(new DBParameter("@CostVal", DbType.Decimal, ParameterDirection.Input, reforecastBudget.New));
                }
                else
                {
                    spUpdateOtherCosts.AddParameter(new DBParameter("@CostVal", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                }
                spUpdateOtherCosts.AddParameter(new DBParameter("@IdCostType", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCostType));
                spUpdateOtherCosts.AddParameter(new DBParameter("@ActualDataTimestamp", DbType.DateTime, ParameterDirection.Input, reforecastBudget.ActualDataTimestamp));
                this.AddStoredProcedure("UpdateOtherCosts", spUpdateOtherCosts);

                DBStoredProcedure spUpdateSales = new DBStoredProcedure();
                spUpdateSales.ProcedureName = "bgtUpdateToCompletionBudgetSales";
                spUpdateSales.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spUpdateSales.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spUpdateSales.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdPhase));
                spUpdateSales.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdWP));
                spUpdateSales.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCostCenter));
                spUpdateSales.AddParameter(new DBParameter("@YearMonth", DbType.Int32, ParameterDirection.Input, reforecastBudget.YearMonth));
                if (reforecastBudget.New != ApplicationConstants.DECIMAL_NULL_VALUE)
                {
                    spUpdateSales.AddParameter(new DBParameter("@Sales", DbType.Decimal, ParameterDirection.Input, reforecastBudget.New));
                }
                else
                {
                    spUpdateSales.AddParameter(new DBParameter("@Sales", DbType.Decimal, ParameterDirection.Input, DBNull.Value));
                }
                spUpdateSales.AddParameter(new DBParameter("@ActualDataTimestamp", DbType.DateTime, ParameterDirection.Input, reforecastBudget.ActualDataTimestamp));
                this.AddStoredProcedure("UpdateSales", spUpdateSales);

                DBStoredProcedure spGetReforecastVersionNo = new DBStoredProcedure();
                spGetReforecastVersionNo.ProcedureName = "bgtGetReforecastVersionNo";
                spGetReforecastVersionNo.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spGetReforecastVersionNo.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, reforecastBudget.Version));
                this.AddStoredProcedure("GetReforecastVersionNo", spGetReforecastVersionNo);

                DBStoredProcedure spGetReforecastVersions = new DBStoredProcedure();
                spGetReforecastVersions.ProcedureName = "bgtGetReforecastVersions";
                spGetReforecastVersions.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spGetReforecastVersions.AddParameter(new DBParameter("@Version", DbType.String, ParameterDirection.Input, reforecastBudget.Version));
                this.AddStoredProcedure("GetReforecastVersions", spGetReforecastVersions);

                DBStoredProcedure spGetReforecastActualDataTimestamp = new DBStoredProcedure();
                spGetReforecastActualDataTimestamp.ProcedureName = "bgtGetToCompletionActualDataTimestamp";
                this.AddStoredProcedure("GetReforecastActualDataTimestamp", spGetReforecastActualDataTimestamp);

                DBStoredProcedure spInsertReforecastBudget = new DBStoredProcedure();
                spInsertReforecastBudget.ProcedureName = "bgtInsertToCompletionBudget";
                spInsertReforecastBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spInsertReforecastBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spInsertReforecastBudget.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdPhase));
                spInsertReforecastBudget.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdWP));
                spInsertReforecastBudget.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCostCenter));
                this.AddStoredProcedure("InsertReforecastBudget", spInsertReforecastBudget);

                DBStoredProcedure spDeleteReforecastBudget = new DBStoredProcedure();
                spDeleteReforecastBudget.ProcedureName = "bgtDeleteCostCenterFromToCompletionBudget";
                spDeleteReforecastBudget.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdAssociate));
                spDeleteReforecastBudget.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                spDeleteReforecastBudget.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdPhase));
                spDeleteReforecastBudget.AddParameter(new DBParameter("@IdWP", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdWP));
                spDeleteReforecastBudget.AddParameter(new DBParameter("@IdCostCenter", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdCostCenter));
                this.AddStoredProcedure("DeleteCostCenterFromToCompletionBudget", spDeleteReforecastBudget);

                DBStoredProcedure spCreateNextVersion = new DBStoredProcedure();
                spCreateNextVersion.ProcedureName = "bgtToCompletionBudgetCreateNewVersion";
                spCreateNextVersion.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, reforecastBudget.IdProject));
                this.AddStoredProcedure("CreateNextVersion", spCreateNextVersion);

            }
        }
    }
}
