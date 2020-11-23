using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Text;

using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Timing_Interco;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Catalogues;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class InitialBudget : Budget, IInitialBudget
    {
        #region Properties
        private int _TotalHours;
        /// <summary>
        /// Represent the total hours
        /// </summary>
        public int TotalHours
        {
          get { return _TotalHours; }
          set { _TotalHours = value; }
        }

        private decimal _ValuedHours;
        /// <summary>
        /// Represent the valued hours for the budget
        /// </summary>
        public decimal ValuedHours
        {
            get { return _ValuedHours; }
            set { _ValuedHours = value; }
        }

        private decimal _Sales;
        /// <summary>
        /// Represent the sales for the budget
        /// </summary>
        public decimal Sales
        {
            get { return _Sales; }
            set { _Sales = value; }
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
        #endregion Properties

        #region Constructors
        public InitialBudget(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBInitialBudget(connectionManager));
        }

        /// <summary>
        /// Builds an initial budget object with data from the given Hashtable
        /// </summary>
        /// <param name="connectionManager"></param>
        /// <param name="values"></param>
        /// <param name="includeKey"></param>
        /// <param name="throwExceptionOnInvalidData">spercifies whether when finding invalid data, an exception will be thrown or not</param>
        public InitialBudget(object connectionManager, Hashtable values, bool includeKey, bool throwExceptionOnInvalidData)
            : base(connectionManager)
        {
            SetEntity(new DBInitialBudget(connectionManager));
            try
            {
                if (includeKey)
                {

                    this.IdProject = int.Parse(values["IdProject"].ToString());
                    this.IdPhase = int.Parse(values["IdPhase"].ToString());
                    this.IdWP = int.Parse(values["IdWP"].ToString());
                    this.IdCostCenter = int.Parse(values["IdCostCenter"].ToString());

                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex.Message + " " + ApplicationMessages.EXCEPTION_COULD_NOT_GET_KEY_VALUE_FOR_INITIAL);
            }
            try
            {
                if (throwExceptionOnInvalidData)
                {
                    InitializeWithExceptionOnError(values);
                }
                else
                {
                    InitializeWithoutExceptionOnError(values);
                }
            }
            catch (IndException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw new IndException(ApplicationMessages.EXCEPTION_INCORRECT_VALUES + " " + ex.Message);
            }
        }

        private void InitializeWithoutExceptionOnError(Hashtable values)
        {
            if (values["TotalHours"] != null)
            {
                //Verify that the values are of permitted type/range   
                if (int.TryParse(conversionUtils.RemoveThousandsFormat(values["TotalHours"].ToString()), out this._TotalHours) == false)
                    this._TotalHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;
            }
            else
            {
                this._TotalHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;
            }

            if (values["ValuedHours"] != null)
            {
                if (decimal.TryParse(conversionUtils.RemoveThousandsFormat(values["ValuedHours"].ToString()), out this._ValuedHours) == false)
                    this._ValuedHours = ApplicationConstants.DECIMAL_NULL_VALUE;
            }
            else
            {
                this._ValuedHours = ApplicationConstants.DECIMAL_NULL_VALUE;
            }

            if (values["Sales"] != null)
            {
                if (decimal.TryParse(conversionUtils.RemoveThousandsFormat(values["Sales"].ToString()), out this._Sales) == false)
                    this._Sales = ApplicationConstants.DECIMAL_NULL_VALUE;
            }
            else
            {
                this._Sales = ApplicationConstants.DECIMAL_NULL_VALUE;
            }
        }

        private void InitializeWithExceptionOnError(Hashtable values)
        {
            if (values["TotalHours"] != null)
            {
                //Verify that the values are of permitted type/range   
                if (int.TryParse(conversionUtils.RemoveThousandsFormat(values["TotalHours"].ToString()), out this._TotalHours) == false)
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_NOT_NUMERIC, "Total Hours"));

                if (this._TotalHours < 0)
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_MUST_BE_POSITIVE, "Total Hours"));
            }
            else
            {
                this._TotalHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;
            }

            if (values["ValuedHours"] != null)
            {
                if (decimal.TryParse(conversionUtils.RemoveThousandsFormat(values["ValuedHours"].ToString()), out this._ValuedHours) == false)
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_NOT_NUMERIC, "Valued Hours"));

                if (this._ValuedHours < 0)
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_MUST_BE_POSITIVE, "Valued Hours"));
            }
            else
            {
                this._ValuedHours = ApplicationConstants.DECIMAL_NULL_VALUE;
            }

            if (values["Sales"] != null)
            {
                if (decimal.TryParse(conversionUtils.RemoveThousandsFormat(values["Sales"].ToString()), out this._Sales) == false)
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FIELD_NOT_NUMERIC, "Sales"));
            }
            else
            {
                this._Sales = ApplicationConstants.DECIMAL_NULL_VALUE;
            }
        }
        /// <summary>
        /// Constructor used to construct a initial budget object only setting the primary key properties
        /// </summary>
        /// <param name="connectionManager"></param>
        /// <param name="values"></param>
        public InitialBudget(object connectionManager, Hashtable values)
            : base(connectionManager)
        {
            SetEntity(new DBInitialBudget(connectionManager));
            try
            {
                this.IdProject = int.Parse(values["IdProject"].ToString());
                this.IdPhase = int.Parse(values["IdPhase"].ToString());
                this.IdWP = int.Parse(values["IdWP"].ToString());
                this.IdCostCenter = int.Parse(values["IdCostCenter"].ToString());
            }
            catch (Exception ex)
            {
                throw new IndException(ex.Message + " " + ApplicationMessages.EXCEPTION_COULD_NOT_GET_KEY_VALUE_FOR_INITIAL);
            }
        }

        public InitialBudget(object connectionManager, DataRow row, int idAssociate)
            : this(connectionManager)
        {
            try
            {
                Row2Object(row);
                this.IdAssociate = idAssociate;
                this.IdAssociateViewer = idAssociate;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion Constructors

        #region Public Methods
        /// <summary>
        /// Saves the budget
        /// </summary>
        /// <param name="currentProject">The current project used</param>
        /// <param name="currentUser">The current logged user</param>
        /// <param name="FollowUpIdAssociate">The associate id if this is called from the follow up</param>
        /// <param name="otherCost">The other cost object associated with this budget</param>
        /// <param name="startYearMonth">The StartYearMonth</param>
        /// <param name="endYearMonth">the EndYearMonth</param>
        /// <param name="evidenceButtonVisible">Specify if the Submit button should be visible after this operation</param>
        public void InsertBudget(CurrentProject currentProject, CurrentUser currentUser, int FollowUpIdAssociate, InitialBudgetOtherCosts otherCost, YearMonth startYearMonth, YearMonth endYearMonth, out bool evidenceButtonVisible)
        {
            BeginTransaction();

            //Initialize the out paramter
            evidenceButtonVisible = false;

            try
            {
                //TODO: Call this method only if this is the case
                InsertMasterRecord();

                //Constructs a new FollowUpInitialBudget object
                FollowUpInitialBudget fIBudget = new FollowUpInitialBudget(this.CurrentConnectionManager);

                //Get the current budget state
                #region Get Current Budget State

                string budgetState = String.Empty;
                //Initialize the follow up buget object
                fIBudget.IdProject = currentProject.Id;
                fIBudget.IdAssociate = ((FollowUpIdAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS ? currentUser.IdAssociate : FollowUpIdAssociate));

                //Get the budget state
                DataSet dsButtons = fIBudget.GetInitialBudgetStateForEvidence("GetInitialBudgetStateForEvidence");
                //Find out the budget state from the dataset
                if (dsButtons != null)
                {
                    if (dsButtons.Tables[0].Rows.Count > 0)
                    {
                        budgetState = dsButtons.Tables[0].Rows[0]["StateCode"].ToString();
                    }
                    else
                    {
                        budgetState = ApplicationConstants.BUDGET_STATE_NONE;
                    }
                }
                else
                {
                    //Do not rollback here, exception will be caught later in this method
                    throw new IndException("This associate is not in CORETEAM");
                }
                #endregion Get Current Budget State
                //If the budget state is NONE than save it to OPEN
                if (budgetState == ApplicationConstants.BUDGET_STATE_NONE)
                {
                    fIBudget.StateCode = ApplicationConstants.BUDGET_STATE_OPEN;
                    fIBudget.SetModified();
                    fIBudget.Save();

                    evidenceButtonVisible = true;
                }
                

                //Splits the budget into details and save them
                SaveSplitted(startYearMonth, endYearMonth, otherCost);

                CommitTransaction();
            }
            catch (Exception exc)
            {
                RollbackTransaction();
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Updates the budget (transactions enabled)
        /// </summary>
        /// <param name="startYearMonth"></param>
        /// <param name="endYearMonth"></param>
        /// <param name="otherCosts"></param>
        /// <param name="isAssociateCurrency"></param>
        /// <param name="associateCurrency"></param>
        /// <param name="converter"></param>
        /// <param name="scaleOption"></param>
        public void UpdateBudget(YearMonth startYearMonth, YearMonth endYearMonth, InitialBudgetOtherCosts otherCosts, bool isAssociateCurrency, int associateCurrency, CurrencyConverter converter, AmountScaleOption scaleOption, bool insertMasterRecord)
        {
            BeginTransaction();

            try
            {
                if (insertMasterRecord)
                    InsertMasterRecord();

                SaveSplitted(startYearMonth, endYearMonth, otherCosts, isAssociateCurrency, associateCurrency, converter, scaleOption);

                CommitTransaction();
            }
            catch (Exception exc)
            {
                RollbackTransaction();
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Updates the budget (transactions enabled)
        /// </summary>
        /// <param name="startYearMonth"></param>
        /// <param name="endYearMonth"></param>
        /// <param name="otherCosts"></param>
        public void UpdateBudget(YearMonth startYearMonth, YearMonth endYearMonth, InitialBudgetOtherCosts otherCosts, bool insertMasterRecord)
        {
            BeginTransaction();

            try
            {
                if (insertMasterRecord)
                    InsertMasterRecord();

                SaveSplitted(startYearMonth, endYearMonth, otherCosts);

                CommitTransaction();
            }
            catch (Exception exc)
            {
                RollbackTransaction();
                throw new IndException(exc);
            }
        }

        public bool CheckStartConditions()
        {
            try
            {
                int result = this.GetEntity().ExecuteCustomProcedureWithReturnValue("InitialBudgetCheck", this);
                return (result == 1) ? true : false;
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }
        /// <summary>
        /// Creates the datasource for the InitialBudget
        /// </summary>
        /// <param name="wpList">The list on WP that the method should retreive data for</param>
        /// <param name="idAssociate">The associate for which the data is retrieved</param>
        /// <param name="idAssociateViewer">The associate currently viewing the budget</param>
        /// <returns>The source DataSet (of type Master-Detail-Detail) </returns>
        public DataSet GetInitialBudgetDataSource(int idAssociate, int idAssociateViewer, object connectionManager, bool isAssociateCurrency, int idProject, int idCountry)
        {
            //Create the DataSet
            DataSet resultDS = new DataSet();
            try
            {
                //First create the Master Table

                InitialBudget baseBudget = new InitialBudget(connectionManager);
                baseBudget.IdAssociate = idAssociate;
                baseBudget.IdAssociateViewer = idAssociateViewer;
                baseBudget.IsAssociateCurrency = isAssociateCurrency;
                baseBudget.IdProject = idProject;
                baseBudget.IdCountry = idCountry;

                resultDS = baseBudget.GetAll(true);

                //The data set should return exactly 3 tables
                if (resultDS.Tables.Count != 3)
                    throw new IndException(ApplicationMessages.EXCEPTION_NUMBER_OF_DETAIL_TABLES);

                //Calculate the DateIntervalColumn
                CalculateDateIntervalColumn(resultDS.Tables[1], "DateInterval", "StartYearMonth", "EndYearMonth");
                RoundTableValues(resultDS.Tables[0], new string[] { "Averate", "ValuedHours", "OtherCosts", "Sales", "NetCosts" });
                RoundTableValues(resultDS.Tables[1], new string[] { "Averate", "ValuedHours", "OtherCosts", "Sales", "NetCosts" });
                RoundTableValues(resultDS.Tables[2], new string[] { "Averate", "ValuedHours", "OtherCosts", "Sales", "NetCosts" });
                //UpdateParentTableValues(tblPhases,tblWP, new string[] { "IdPhase"}, 0);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
            //Return the data source
            return resultDS;
        }

        /// <summary>
        /// Save the Initial Budget object by splitting it into several object accordin to
        /// startYearMonth and endYearMonth values.
        /// </summary>
        /// <param name="startYearMonth">The startYearMonth value</param>
        /// <param name="endYearMonth">The endYearMonth value</param>
        private void SaveSplitted(YearMonth startYearMonth, YearMonth endYearMonth, InitialBudgetOtherCosts otherCosts, bool isAssociateCurrency, int associateCurrency, CurrencyConverter converter, AmountScaleOption scaleOption)
        {
            try
            {
                //Get the months difference
                int monthsNo = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;
                int[] totalHours = Rounding.Divide(this.TotalHours, monthsNo);
                decimal[] sales = Rounding.Divide(this.Sales, monthsNo);
                decimal[] valHours = new decimal[monthsNo];
                if (this.ValuedHours != ApplicationConstants.DECIMAL_NULL_VALUE)
                    valHours = Rounding.Divide(this.ValuedHours, monthsNo);
                else
                    for (int i = 0; i < monthsNo; i++)
                        valHours[i] = ApplicationConstants.DECIMAL_NULL_VALUE;
                int[] detailsIds = new int[monthsNo];
                //Iterate through each month and construct the InitialBudget object
                for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
                {
                    //construct a new initial budget object
                    InitialBudget newBudget = new InitialBudget(this.CurrentConnectionManager);
                    newBudget.IdProject = this.IdProject;
                    newBudget.IdPhase = this.IdPhase;
                    newBudget.IdWP = this.IdWP;
                    newBudget.IdCostCenter = this.IdCostCenter;
                    newBudget.IdAssociate = this.IdAssociate;
                    newBudget.YearMonth = currentYearMonth.Value;
                    newBudget.TotalHours = totalHours[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                    newBudget.ValuedHours = valHours[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                    newBudget.Sales = sales[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                    if (this.State == EntityState.New)
                        newBudget.SetNew();
                    if (this.State == EntityState.Modified)
                        newBudget.SetModified();
                    if (this.State == EntityState.Deleted)
                        newBudget.SetDeleted();

                    //Apply the cost center currency if this is the case
                    if (isAssociateCurrency)
                        newBudget.ApplyCostCenterCurrency(associateCurrency, converter);
                    //Apply the amount scale
                    newBudget.ApplyAmountScaleOption(scaleOption);

                    //Saves the new budget
                    if (this.State == EntityState.New)
                        IdDetail = newBudget.Save();
                    else
                        newBudget.Save();
                }

                //Insert Other cost object
                if (otherCosts != null)
                {
                    otherCosts.SaveSplitted(startYearMonth, endYearMonth, isAssociateCurrency, this.IdCostCenter, associateCurrency, converter);
                }
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Save the Initial Budget object by splitting it into several object accordin to
        /// startYearMonth and endYearMonth values.
        /// </summary>
        /// <param name="startYearMonth">The startYearMonth value</param>
        /// <param name="endYearMonth">The endYearMonth value</param>
        private void SaveSplitted(YearMonth startYearMonth, YearMonth endYearMonth, InitialBudgetOtherCosts otherCosts)
        {
            try
            {
                //Get the months difference
                int monthsNo = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;
                int[] totalHours = Rounding.Divide(this.TotalHours, monthsNo);
                decimal[] sales = Rounding.Divide(this.Sales, monthsNo);
                decimal[] valHours = Rounding.Divide(this.ValuedHours, monthsNo);
                int[] detailsIds = new int[monthsNo];
                //Iterate through each month and construct the InitialBudget object
                for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
                {
                    //construct a new initial budget object
                    InitialBudget newBudget = new InitialBudget(this.CurrentConnectionManager);
                    newBudget.IdProject = this.IdProject;
                    newBudget.IdPhase = this.IdPhase;
                    newBudget.IdWP = this.IdWP;
                    newBudget.IdCostCenter = this.IdCostCenter;
                    newBudget.IdAssociate = this.IdAssociate;
                    newBudget.YearMonth = currentYearMonth.Value;
                    newBudget.TotalHours = totalHours[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                    newBudget.ValuedHours = valHours[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                    newBudget.Sales = sales[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                    if (this.State == EntityState.New)
                        newBudget.SetNew();
                    if (this.State == EntityState.Modified)
                        newBudget.SetModified();
                    if (this.State == EntityState.Deleted)
                        newBudget.SetDeleted();

                    //Saves the new budget
                    if (this.State == EntityState.New)
                        IdDetail = newBudget.Save();
                    else
                        newBudget.Save();
                }

                //Insert Other cost object
                if (otherCosts != null)
                {
                    otherCosts.SaveSplitted(startYearMonth, endYearMonth);
                }
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Inserts (if it is the case) a master record in the master table
        /// OBS: The current object must have the IdProject set
        /// </summary>
        private void InsertMasterRecord()
        {
            if (this.IdProject == ApplicationConstants.INT_NULL_VALUE)
                throw new IndException(ApplicationMessages.EXCEPTION_INITIAL_BUDGET_INCOMPLETE_PROPERTIES);

            try
            {
                this.GetEntity().ExecuteCustomProcedure("InsertIntialBudgetMaster", this);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }
       
        #endregion Public Methods

        #region PrivateMethods
        private void ApplyCurrencyForCostCenterTable(DataSet sourceDS, int associateCurrency, CurrencyConverter converter, int dsIndex)
        {

            DataTable sourceTable = sourceDS.Tables[2];

            //Cycle through each row of the cost center table
            foreach (DataRow row in sourceTable.Rows)
            {
                //Get the cost center currency for the current row
                int costCenterCurrency = (int)row["IdCurrency"];
                //If both currencies are the same, do nothing
                if (costCenterCurrency == associateCurrency)
                    continue;

                BudgetColumnsCalculationsList columns = this.GetCalculatedColumns(dsIndex);
                foreach (KeyValuePair<string, EBudgetCalculationMethod> entry in columns)
                {
                    //Get the current calculated column name
                    string columnName = entry.Key;
                    if (sourceTable.Columns[columnName].DataType == typeof(decimal))
                    {
                        //Gets the current value of the column
                        decimal val = (decimal)row[columnName];
                        //Get the parrent datarow
                        DataRow wpRow = GetParentWPRow(sourceTable.DataSet, row);
                        //Get the start year month and end year month for the currenct cost center
                        YearMonth startYearMonth = new YearMonth((int)wpRow["StartYearMonth"]);
                        YearMonth endYearMonth = new YearMonth((int)wpRow["EndYearMonth"]);
                        //Calculate the existing value for each month in the date interval
                        int numberOfMonths = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;
                        decimal[] yearMonthValues = Rounding.Divide(val, numberOfMonths);
                        decimal newValue = 0;
                        //Calculates the new value for each month and sum it
                        for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
                        {
                            int valueIterator = currentYearMonth.GetMonthsDiffrence(startYearMonth);
                            newValue += converter.GetConversionValue(yearMonthValues[valueIterator], costCenterCurrency, currentYearMonth, associateCurrency);
                        }
                        //Updates the value
                        row[columnName] = Rounding.Round(newValue);
                    }
                }
            }
        }
        #endregion PrivateMethods

        #region Overrides
        /// <summary>
        /// Apply a given amount scale option to the current object value
        /// </summary>
        /// <param name="scaleOption">The amount scale to be applied</param>
        public override void ApplyAmountScaleOption(AmountScaleOption scaleOption)
        {
            try
            {
                //Calculate the multiplier
                int multiplier = 1;
                for (int i = 1; i <= (int)scaleOption; i++)
                    multiplier *= 1000;

                //Update the values
                if (_ValuedHours != ApplicationConstants.DECIMAL_NULL_VALUE)
                    _ValuedHours *= multiplier;
                if (_Sales != ApplicationConstants.DECIMAL_NULL_VALUE)
                    _Sales *= multiplier;
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Converts the edited cc list from an old amount scale option to Unit amount scale by passing through a new one
        /// The old scale must be greater than the new one
        /// </summary>
        /// <param name="oldOption"></param>
        /// <param name="newOption"></param>
        /// <param name="htValues"></param>
        public override void ApplyAmountScaleOptionToHT(AmountScaleOption oldOption, AmountScaleOption newOption, List<InitialBudget> htValues)
        {
            try
            {
                //Gets the diffrence between scales
                int scaleDif = oldOption - newOption;

                decimal multiplier = 1;
                if (scaleDif == 0)
                    return;
                for (int i = 1; i <= scaleDif; i++)
                    multiplier *= 1000;

                foreach (InitialBudget iBudget in htValues)
                {
                    iBudget.ValuedHours = (iBudget.ValuedHours == ApplicationConstants.DECIMAL_NULL_VALUE) ? ApplicationConstants.DECIMAL_NULL_VALUE : Rounding.Round(Decimal.Multiply((decimal)iBudget.ValuedHours, multiplier));
                    iBudget.Sales = (iBudget.Sales == ApplicationConstants.DECIMAL_NULL_VALUE) ? ApplicationConstants.DECIMAL_NULL_VALUE : Rounding.Round(Decimal.Multiply((decimal)iBudget.Sales, multiplier));
                }
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Transforms the datasource by updating the decimal values with the exchange rate of the associate currency 
        /// </summary>
        /// <param name="sourceDS">The source data set</param>
        /// <param name="currentUser">The current logged user</param>
        protected override void ApplyAssociateCurrency(DataSet sourceDS, CurrentUser currentUser, CurrencyConverter converter, int dsIndex)
        {
            ApplyCurrencyForCostCenterTable(sourceDS, currentUser.IdCurrency, converter, dsIndex);
            UpdateParentTableValues(sourceDS.Tables[1], sourceDS.Tables[2], new string[] { "IdPhase", "IdWP" }, dsIndex);
            UpdateParentTableValues(sourceDS.Tables[0], sourceDS.Tables[1], new string[] { "IdPhase" }, dsIndex);
        }

        /// <summary>
        /// Apply the cost center currency to the current object properties
        /// </summary>
        /// <param name="associateCurrency">the associate currency</param>
        protected override void ApplyCostCenterCurrency(int associateCurrency, CurrencyConverter converter)
        {
            CostCenter currentCostCenter = new CostCenter(this.CurrentConnectionManager);
            currentCostCenter.Id = IdCostCenter;
            int idCurrency = currentCostCenter.GetCostCenterCurrency().Id;

            if (_ValuedHours != ApplicationConstants.DECIMAL_NULL_VALUE)
                _ValuedHours = converter.GetConversionValue(_ValuedHours, associateCurrency, new YearMonth(YearMonth), idCurrency);

            _Sales = converter.GetConversionValue(_Sales, associateCurrency, new YearMonth(YearMonth), idCurrency);
        }

        /// <summary>
        /// Sets null instead of acutal data for the first and second table
        /// </summary>
        /// <param name="sourceDS">the source dataset</param>
        protected override void RemoveNonCalculableValues(DataTable sourceTable, int dsIndex)
        {
            foreach (DataRow row in sourceTable.Rows)
            {
                BudgetColumnsCalculationsList columns = this.GetCalculatedColumns(dsIndex);
                foreach (KeyValuePair<string, EBudgetCalculationMethod> entry in columns)
                {
                     string columnName = entry.Key;
                    
                     if (sourceTable.Columns[columnName].DataType == typeof(decimal))
                     {
                         row[columnName] = DBNull.Value;
                     }
                }
            }
        }

        protected override BudgetColumnsCalculationsList GetCalculatedColumns(int dsIndex)
        {
            BudgetColumnsCalculationsList columnsList = new BudgetColumnsCalculationsList();
            switch (dsIndex)
            {
                case 0:
                    columnsList.Add("TotalHours", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("Averate", EBudgetCalculationMethod.eAVG);
                    columnsList.Add("ValuedHours", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("OtherCosts", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("Sales", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("NetCosts", EBudgetCalculationMethod.eSUM);
                    break;
                default:
                    throw new NotImplementedException("Undefinded dataset index: " + dsIndex);
            }
            return columnsList;
        }
        protected override void Row2Object(DataRow row)
        {
            this.IdProject = (int)row["IdProject"];
            this.IdPhase = (int)row["IdPhase"];
            this.IdWP = (int)row["IdWP"];
            this.IdCostCenter = (int)row["IdCostCenter"];
        }
        #endregion Overrides
    }
}
