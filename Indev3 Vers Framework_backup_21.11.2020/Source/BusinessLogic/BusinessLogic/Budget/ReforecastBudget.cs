using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using System.Data;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic.Catalogues;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class ReforecastBudget : Budget, IReforecastBudget
    {

        #region Constants
        //Constants representing the values (coded integers, not the actual strings) which are available for selection in reforecast budget
        //in the Displayed Data combobox
        public const int DATA_VALUE_HOURS = 0;
        public const int DATA_VALUE_VAL_HOURS = 1;
        public const int DATA_VALUE_OTHER_COSTS = 2;
        public const int DATA_VALUE_TE = 3;
        public const int DATA_VALUE_PROTO_PARTS = 4;
        public const int DATA_VALUE_PROTO_TOOLING = 5;
        public const int DATA_VALUE_TRIALS = 6;
        public const int DATA_VALUE_OTHER_EXPENSES = 7;
        public const int DATA_VALUE_SALES = 8;
        public const int DATA_VALUE_GROSS_COSTS = 9;
        public const int DATA_VALUE_NET_COSTS = 10;
        #endregion Constants
        
        #region IReforecastBudget Members
        private string _CostCenterName;
        public string CostCenterName
        {
            get { return _CostCenterName; }
            set { _CostCenterName = value; }
        }
        private decimal _Current;
        public decimal Current
        {
            get { return _Current; }
            set { _Current = value; }
        }
        private decimal _New;
        public decimal New
        {
            get { return _New; }
            set { _New = value; }
        }
        private decimal _Previous;
        public decimal Previous
        {
            get { return _Previous; }
            set { _Previous = value; }
        }
        private decimal _PercentComplete;
        public decimal PercentComplete
        {
            get { return _PercentComplete; }
            set { _PercentComplete = value; }
        }
        
        private string _Version;
        /// <summary>
        /// The version of the budget which will appear in the new column in the reforecast grid
        /// </summary>
        public string Version
        {
            get { return _Version; }
            set { _Version = value; }
        }

        private int _IdCostType;
        /// <summary>
        /// The type of cost of the current displayed costs
        /// </summary>
        public int IdCostType
        {
            get { return _IdCostType; }
            set { _IdCostType = value; }
        }

        private DateTime _ActualDataTimestamp;
        /// <summary>
        /// The timestamp for the actual data of this budget
        /// </summary>
        public DateTime ActualDataTimestamp
        {
            get { return _ActualDataTimestamp; }
            set { _ActualDataTimestamp = value; }
        }

		private bool _ShowOnlyCCsWithSighificantValues;
		/// <summary>
		/// Specifies if Cost Centers with 0/empty on ALL columns should be shown 
		/// </summary>
		public bool ShowOnlyCCsWithSighificantValues
		{
			get { return _ShowOnlyCCsWithSighificantValues; }
			set { _ShowOnlyCCsWithSighificantValues = value; }
		}

		private int _IdCountry;
		/// <summary>
		/// Only the cost centers located in the selected country are displayed
		/// </summary>
		public int IdCountry
		{
			get { return _IdCountry; }
			set { _IdCountry = value; }
		}

        private int _IdCurrency;
        public int IdCurrency
        {
            get { return _IdCurrency; }
            set { _IdCurrency = value; }
        }
        #endregion IReforecastBudget Members

        #region Constructors
        public ReforecastBudget(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBReforecastBudget(connectionManager));
            _Version = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;
        }

        #endregion Constructors

        #region Public Methods
        /// <summary>
        /// Gets the hours information from the database
        /// </summary>
        /// <returns>dataset containing the hours data</returns>
        /// <param name="dataType">the type of data (coded as int) to select from the database (Hours, Valued Hours etc.)</param>
        public DataSet GetData(int dataType)
        {
            //Create the dataset structure (master-detail-detail)
            DataSet resultDS = new DataSet();
            bool bIsFake = false;

            try
            {
                //see if the current version to be displyed does not exist in the database
                GetVersionNumber(out bIsFake);
                if (bIsFake)
                {
                    this.BeginTransaction();
                    this.GetEntity().ExecuteCustomProcedure("CreateNextVersion", this);
                }

                switch (dataType)
                {
                    case DATA_VALUE_HOURS:
                        resultDS = this.GetEntity().GetCustomDataSet("GetHoursData", this);
                        RoundTableValues(resultDS.Tables[0], new string[] { "Progress" });
                        break;
                    case DATA_VALUE_VAL_HOURS:
                        resultDS = this.GetEntity().GetCustomDataSet("GetValHoursData", this);
                        RoundTableValues(resultDS.Tables[0], new string[] { "Progress", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[1], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[2], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        break;
                    case DATA_VALUE_OTHER_COSTS:
                    case DATA_VALUE_TE:
                    case DATA_VALUE_PROTO_PARTS:
                    case DATA_VALUE_PROTO_TOOLING:
                    case DATA_VALUE_TRIALS:
                    case DATA_VALUE_OTHER_EXPENSES:
                        this._IdCostType = GetCostType(dataType);
                        resultDS = this.GetEntity().GetCustomDataSet("GetOtherCostsData", this);
                        RoundTableValues(resultDS.Tables[0], new string[] { "Progress", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[1], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[2], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        break;
                    case DATA_VALUE_SALES:
                        resultDS = this.GetEntity().GetCustomDataSet("GetSalesData", this);
                        RoundTableValues(resultDS.Tables[0], new string[] { "Progress", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[1], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[2], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        break;
                    case DATA_VALUE_GROSS_COSTS:
                        resultDS = this.GetEntity().GetCustomDataSet("GetGrossCostsData", this);
                        RoundTableValues(resultDS.Tables[0], new string[] { "Progress", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[1], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[2], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        break;
                    case DATA_VALUE_NET_COSTS:
                        resultDS = this.GetEntity().GetCustomDataSet("GetNetCostsData", this);
                        RoundTableValues(resultDS.Tables[0], new string[] { "Progress", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[1], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        RoundTableValues(resultDS.Tables[2], new string[] { "Previous", "CurrentPreviousDiff", "Current", "NewCurrentDiff", "New", "NewRevisedDiff", "Revised" });
                        break;
                    default:
                        throw new IndException(ApplicationMessages.EXCEPTION_REFORECAST_DISPLAYED_DATA_OPTION_NOT_AVAILABLE);
                }

                if (resultDS.Tables.Count != 3)
                    throw new IndException(ApplicationMessages.EXCEPTION_NUMBER_OF_DETAIL_TABLES);

                CalculateDateIntervalColumn(resultDS.Tables[0], "DateInterval", "StartYearMonth", "EndYearMonth");
                AddVarStringColumns(resultDS);
                ConvertYMToDate(resultDS.Tables[2], "YearMonth", "Date");
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            finally
            {
                if (bIsFake)
                {
                    this.RollbackTransaction();
                }
            }

            return resultDS;
        }

        /// <summary>
        /// Saves the budgets from budgetList to the database
        /// </summary>
        /// <param name="budgetList">list of ReforecastBudget objects to be saved to the database</param>
        /// <param name="displayedDataType">the type of data to be saved (one of the values in the Constants region)</param>
        /// <param name="amountScaleOption">the amount scale in which the data is represented</param>
        public void SaveAll(List<ReforecastBudget> budgetList, int displayedDataType, AmountScaleOption amountScaleOption)
        {
            //Begin the transaction
            BeginTransaction();
            try
            {
                foreach (ReforecastBudget budget in budgetList)
                {
                    budget.UpdateMasterRecord();
                    budget.ApplyAmountScaleOption(amountScaleOption);
                    budget.UpdateDetail(displayedDataType);
                }
                //Commit the transaction
                CommitTransaction();
            }
            catch (Exception ex)
            {
                //If, for any reason, an exception was thrown, rollback the transaction
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Saves the budgets from budgetList to the database, applying an exchange rate conversion
        /// </summary>
        /// <param name="budgetList">list of ReforecastBudget objects to be saved to the database</param>
        /// <param name="displayedDataType">the type of data to be saved (one of the values in the Constants region)</param>
        /// <param name="amountScaleOption">the amount scale in which the data is represented</param>
        /// <param name="associateCurrency">the currency of the associate saving the budget</param>
        /// <param name="converter">converter object used to exchange values from one currency to another</param>
        public void SaveAll(List<ReforecastBudget> budgetList, int displayedDataType, AmountScaleOption amountScaleOption, int associateCurrency, CurrencyConverter converter)
        {
            //Begin the transaction
            BeginTransaction();
            try
            {
                foreach (ReforecastBudget budget in budgetList)
                {
                    budget.UpdateMasterRecord();
                    budget.ApplyAmountScaleOption(amountScaleOption);
                    if (displayedDataType > DATA_VALUE_HOURS)
                    {
                        budget.ApplyCostCenterCurrency(associateCurrency, converter);
                    }
                    budget.UpdateDetail(displayedDataType);
                }
                //Commit the transaction
                CommitTransaction();
            }
            catch (Exception ex)
            {
                //If, for any reason, an exception was thrown, rollback the transaction
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        public string GetVersionNumber(out bool bIsFake)
        {
            DataSet dsResult;
            string versionNo;
            bIsFake = false;

            try
            {
                dsResult = this.GetEntity().GetCustomDataSet("GetReforecastVersionNo", this);
                if (dsResult.Tables[0].Rows[0]["BudgetVersion"] == DBNull.Value)
                    return null;
                versionNo = dsResult.Tables[0].Rows[0]["BudgetVersion"].ToString();
                //If the version is not the actual one, increase it (happens when the new version was requested but the current version number
                //was returned because the new version did not exist)
                if ((bool)dsResult.Tables[0].Rows[0]["IsVersionActual"] == false)
                {
                    int intVersionNo = int.Parse(versionNo);
                    intVersionNo++;
                    versionNo = intVersionNo.ToString();
                    bIsFake = true;
                }
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
            return versionNo;
        }
        public DataSet GetVersions()
        {
            DataSet dsVersions;

            try
            {
                dsVersions = this.GetEntity().GetCustomDataSet("GetReforecastVersions", this);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
            return dsVersions;
        }

        /// <summary>
        /// Gets the last update time of the actual data
        /// </summary>
        /// <returns></returns>
        public DateTime GetActualDataTimestamp()
        {
            DateTime timestamp;
            try
            {
                object timestampObject = this.GetEntity().ExecuteScalar("GetReforecastActualDataTimestamp", this);
                if (DateTime.TryParse(timestampObject.ToString(), out timestamp) == false)
                {
                    throw new IndException(ApplicationMessages.EXCEPTION_ACTUALDATA_TIMESTAMP_NOT_DATETIME);
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return timestamp;
        }

        /// <summary>
        /// Gets the current YearMonth (as an int) as is the date of the SQL Server
        /// </summary>
        /// <returns></returns>
        public int GetCurrentYearMonth()
        {
            int currentYearMonth;
            DateTime timestamp;
            try
            {
                object timestampObject = this.GetEntity().ExecuteScalar("GetReforecastActualDataTimestamp", this);
                if (DateTime.TryParse(timestampObject.ToString(), out timestamp) == false)
                {
                    throw new IndException(ApplicationMessages.EXCEPTION_ACTUALDATA_TIMESTAMP_NOT_DATETIME);
                }
                currentYearMonth = timestamp.Year * 100 + timestamp.Month;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return currentYearMonth;
        }

        /// <summary>
        /// Apply a given amount scale option to the current object value
        /// </summary>
        /// <param name="scaleOption">The amount scale to be applied</param>
        public override void ApplyAmountScaleOption(AmountScaleOption scaleOption)
        {
            try
            {
                //If the value of New is DECIMAL_NULL_VALUE, do not perform any conversion
                if (_New == ApplicationConstants.DECIMAL_NULL_VALUE)
                    return;

                //Calculate the multiplier
                int multiplier = 1;
                for (int i = 1; i <= (int)scaleOption; i++)
                    multiplier *= 1000;

                _New *= multiplier;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        
        /// <summary>
        /// Adds a cost center to this budget
        /// </summary>
        public void AddCostCenter()
        {
            BeginTransaction();
            try
            {
                this.GetEntity().ExecuteCustomProcedure("InsertReforecastBudget", this);
                CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Delete a cost center from this budget
        /// </summary>
        public void DeleteCostCenter()
        {
            BeginTransaction();
            try
            {
                this.GetEntity().ExecuteCustomProcedure("DeleteCostCenterFromToCompletionBudget", this);
                CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Updates a master record in the database
        /// </summary>
        public void UpdateMasterRecord()
        {
            try
            {
                this.GetEntity().ExecuteCustomProcedure("UpdateMasterRecord", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public object GetLastValidatedVersion()
        {
            object result = null;

            try
            {
                result = this.GetEntity().ExecuteScalar("bgtGetLastValidatedReforecastVersion", this);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
            return result;
        }

        public int Unvalidate()
        {
            int result = 0;
            try
            {
                result = this.GetEntity().ExecuteCustomProcedure("bgtUnvalidateLastReforecastVersion", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return result;
        }

        public bool IsOpen()
        {
            bool result = false;
            try
            {
                result = Convert.ToBoolean(this.GetEntity().ExecuteCustomProcedureWithReturnValue("bgtIsLastToCompletionVersionOpen", this));
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return result;
        }


        #endregion Public Methods

        #region Protected Methods
        /// <summary>
        /// Apply the cost center currency to the current object properties
        /// </summary>
        /// <param name="associateCurrency">the associate currency</param>
        protected override void ApplyCostCenterCurrency(int associateCurrency, CurrencyConverter converter)
        {
            CostCenter currentCostCenter = new CostCenter(this.CurrentConnectionManager);
            currentCostCenter.Id = IdCostCenter;
            int idCurrency = currentCostCenter.GetCostCenterCurrency().Id;

            _New = converter.GetConversionValue(_New, associateCurrency, new YearMonth(YearMonth), idCurrency);
        }
        #endregion Protected Methods

        #region Private Methods
        /// <summary>
        /// Adds a new column to sourceTable which contains the data from yearMonthCol which is represented in YYYYMM format (like in the database)
        /// in the format YYYY/MM
        /// </summary>
        /// <param name="sourceTable">the table on which to perform the transformation</param>
        /// <param name="yearMonthCol">the name of the column containing yearmonth data in the fomat YYYYMM</param>
        /// <param name="dateCol">the name of the column that will contain yearmonth data in the fomat YYYY/MM</param>
        private void ConvertYMToDate(DataTable sourceTable, string yearMonthCol, string dateCol)
        {
            if (!sourceTable.Columns.Contains(yearMonthCol))
                throw new IndException(ApplicationMessages.EXCEPTION_COLUMN_MISSING);
            sourceTable.Columns.Add(new DataColumn(dateCol, typeof(string)));
            foreach (DataRow row in sourceTable.Rows)
            {
                if (row[yearMonthCol] == DBNull.Value)
                    continue;
                YearMonth yearMonth = new YearMonth(row[yearMonthCol].ToString());
                string dateVal = yearMonth.GetMonthRepresentation() + "-" + yearMonth.Year.ToString().Substring(2);
                //string date = row[yearMonthCol].ToString().Insert(4, "/");
                row[dateCol] = dateVal;
            }
        }

       
        /// <summary>
        /// Updates the detail part of the reforecast budget
        /// </summary>
        private void UpdateDetail(int displayedDataType)
        {
            //Different stored procedures must be called, depending on the displayed data type
            switch (displayedDataType)
            {
                case DATA_VALUE_HOURS:
                    this.GetEntity().ExecuteCustomProcedure("UpdateHours", this);
                    break;
                case DATA_VALUE_TE:
                case DATA_VALUE_PROTO_PARTS:
                case DATA_VALUE_PROTO_TOOLING:
                case DATA_VALUE_TRIALS:
                case DATA_VALUE_OTHER_EXPENSES:
                    this._IdCostType = GetCostType(displayedDataType);
                    this.GetEntity().ExecuteCustomProcedure("UpdateOtherCosts", this);
                    break;
                case DATA_VALUE_SALES:
                    this.GetEntity().ExecuteCustomProcedure("UpdateSales", this);
                    break;
                default:
                    throw new IndException(ApplicationMessages.EXCEPTION_UPDATE_NOT_ALLOWED);
            }
        }

        /// <summary>
        /// Gets the cost type id, depending on the displayed data type
        /// </summary>
        /// <param name="displayedDataType">the type of data that is displayed in the reforecast budget</param>
        /// <returns>the IdCostType associated to the type of data displayed</returns>
        private int GetCostType(int displayedDataType)
        {
            switch (displayedDataType)
            {
                case DATA_VALUE_OTHER_COSTS:
                    return ApplicationConstants.INT_NULL_VALUE;
                case DATA_VALUE_TE:
                    return (int)EOtherCostTypes.TE;
                case DATA_VALUE_PROTO_PARTS:
                    return (int)EOtherCostTypes.ProtoParts;
                case DATA_VALUE_PROTO_TOOLING:
                    return (int)EOtherCostTypes.ProtoTooling;
                case DATA_VALUE_TRIALS:
                    return (int)EOtherCostTypes.Trials;
                case DATA_VALUE_OTHER_EXPENSES:
                    return (int)EOtherCostTypes.OtherExpenses;
                default:
                    throw new IndException(ApplicationMessages.EXCEPTION_COST_TYPE_NOT_SUPPORTED);
            }
        }

        /// <summary>
        /// The var columns (difference between the values of different budgets) must always have a sign in front of them (+ or -).
        /// We cannot represent pozitive numbers with '+' in front. For this reason, we create new string columns containing
        /// the numbers with signs in front
        /// </summary>
        /// <param name="resultDS"></param>
        private void AddVarStringColumns(DataSet resultDS)
        {
            resultDS.Tables[0].Columns.Add("CurrentPreviousDiffString", typeof(string));
            resultDS.Tables[0].Columns.Add("NewCurrentDiffString", typeof(string));
            resultDS.Tables[0].Columns.Add("NewRevisedDiffString", typeof(string));

            resultDS.Tables[1].Columns.Add("CurrentPreviousDiffString", typeof(string));
            resultDS.Tables[1].Columns.Add("NewCurrentDiffString", typeof(string));
            resultDS.Tables[1].Columns.Add("NewRevisedDiffString", typeof(string));

            resultDS.Tables[2].Columns.Add("CurrentPreviousDiffString", typeof(string));
            resultDS.Tables[2].Columns.Add("NewCurrentDiffString", typeof(string));

            resultDS.Tables[0].Columns["CurrentPreviousDiffString"].Expression = "IIF([CurrentPreviousDiff] IS NULL, NULL, IIF([CurrentPreviousDiff] > 0, '+' + [CurrentPreviousDiff], [CurrentPreviousDiff]))";
            resultDS.Tables[0].Columns["NewCurrentDiffString"].Expression = "IIF([NewCurrentDiff] IS NULL, NULL, IIF([NewCurrentDiff] > 0, '+' + [NewCurrentDiff], [NewCurrentDiff]))";
            resultDS.Tables[0].Columns["NewRevisedDiffString"].Expression = "IIF([NewRevisedDiff] IS NULL, NULL, IIF([NewRevisedDiff] > 0, '+' + [NewRevisedDiff], [NewRevisedDiff]))";

            resultDS.Tables[1].Columns["CurrentPreviousDiffString"].Expression = "IIF([CurrentPreviousDiff] IS NULL, NULL, IIF([CurrentPreviousDiff] > 0, '+' + [CurrentPreviousDiff], [CurrentPreviousDiff]))";
            resultDS.Tables[1].Columns["NewCurrentDiffString"].Expression = "IIF([NewCurrentDiff] IS NULL, NULL, IIF([NewCurrentDiff] > 0, '+' + [NewCurrentDiff], [NewCurrentDiff]))";
            resultDS.Tables[1].Columns["NewRevisedDiffString"].Expression = "IIF([NewRevisedDiff] IS NULL, NULL, IIF([NewRevisedDiff] > 0, '+' + [NewRevisedDiff], [NewRevisedDiff]))";

            resultDS.Tables[2].Columns["CurrentPreviousDiffString"].Expression = "IIF([CurrentPreviousDiff] IS NULL, NULL, IIF([CurrentPreviousDiff] > 0, '+' + [CurrentPreviousDiff], [CurrentPreviousDiff]))";
            resultDS.Tables[2].Columns["NewCurrentDiffString"].Expression = "IIF([NewCurrentDiff] IS NULL, NULL, IIF([NewCurrentDiff] > 0, '+' + [NewCurrentDiff], [NewCurrentDiff]))";
        }
        #endregion Private Methods
    }

    /// <summary>
    /// Class representing a key that uniquely identifies a cost center object in the reforecast budget. This key is stored in the session
    /// whenever a cost center is deleted from a budget. The old values of this cost center will not be stored after postback because it has
    /// been deleted from the budget (even if it is still displayed in the grid because it has actual or revised data)
    /// </summary>
    public class DeletedReforecastBudgetKey
    {
        public int IdProject;
        public int IdPhase;
        public int IdWP;
        public int IdCostCenter;
    }
}
