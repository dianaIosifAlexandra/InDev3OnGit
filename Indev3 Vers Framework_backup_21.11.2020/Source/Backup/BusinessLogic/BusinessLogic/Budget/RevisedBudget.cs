using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.DataAccess.Budget;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.Timing_Interco;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.Entities;
using System.Collections;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Catalogues;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class RevisedBudget : Budget, IRevisedBudget
    {
        #region IRevisedBudget Members

        private string _CostCenterName;
        public string CostCenterName
        {
            get { return _CostCenterName; }
            set { _CostCenterName = value; }
        }
        private int _CurrentHours;
        public int CurrentHours
        {
            get { return _CurrentHours; }
            set { _CurrentHours = value; }
        }
        private decimal _CurrentVal;
        public decimal CurrentVal
        {
            get { return _CurrentVal; }
            set { _CurrentVal = value; }
        }
        private int _NewHours;
        public int NewHours
        {
            get { return _NewHours; }
            set { _NewHours = value; }
        }
        private decimal _NewVal;
        public decimal NewVal
        {
            get { return _NewVal; }
            set { _NewVal = value; }
        }
        private int _UpdateHours;
        public int UpdateHours
        {
            get { return _UpdateHours; }
            set { _UpdateHours = value; }
        }
        private decimal _UpdateVal;
        public decimal UpdateVal
        {
            get { return _UpdateVal; }
            set { _UpdateVal = value; }
        }
        private decimal _CurrentCosts;
        public decimal CurrentCosts
        {
            get { return _CurrentCosts; }
            set { _CurrentCosts = value; }
        }
        private decimal _UpdateCosts;
        public decimal UpdateCosts
        {
            get { return _UpdateCosts; }
            set { _UpdateCosts = value; }
        }
        private decimal _NewCosts;
        public decimal NewCosts
        {
            get { return _NewCosts; }
            set { _NewCosts = value; }
        }
        private decimal _CurrentSales;
        public decimal CurrentSales
        {
            get { return _CurrentSales; }
            set { _CurrentSales = value; }
        }
        private decimal _UpdateSales;
        public decimal UpdateSales
        {
            get { return _UpdateSales; }
            set { _UpdateSales = value; }
        }
        private decimal _NewSales;
        public decimal NewSales
        {
            get { return _NewSales; }
            set { _NewSales = value; }
        }
        private string _Version;
        /// <summary>
        /// The main version (the most recent, in the "New" column of the revised grid) of revised budget that will be displayed in the grid
        /// </summary>
        public string Version
        {
            get { return _Version; }
            set { _Version = value; }
        }
        
        private bool _SaveHours;
        /// <summary>
        /// When set to true, the hours are updated to the database, otherwise the sales are updated (it is set depending on
        /// the grid on which the budget is saved)
        /// </summary>
        public bool SaveHours
        {
            get { return _SaveHours; }
            set { _SaveHours = value; }
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
        #endregion IRevisedBudget Members

        #region Constructors
        public RevisedBudget(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBRevisedBudget(connectionManager));
            //By default, budget version will be "New". This may be changed in the case when
            //revised budget is viewed coming from the follow-up screen
            Version = ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE;
        }

        #endregion Constructors

        #region Public Methods
        public void BuildObjectFromHashTable(Hashtable values)
        {
            try
            {
                int updateHours;
                decimal updateCost;
                decimal updateSales;
                if (values.ContainsKey("UpdateHours"))
                {
                    if (values["UpdateHours"] != null && int.TryParse(conversionUtils.RemoveThousandsFormat(values["UpdateHours"].ToString()), out updateHours))
                    {
                        this._UpdateHours = updateHours;
                    }
                    else
                    {
                        this._UpdateHours = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;
                    }
                }
                if (values.ContainsKey("UpdateCost"))
                {
                    if (values["UpdateCost"] != null && decimal.TryParse(conversionUtils.RemoveThousandsFormat(values["UpdateCost"].ToString()), out updateCost))
                    {
                        this._UpdateCosts = updateCost;
                    }
                    else
                    {
                        this._UpdateCosts = ApplicationConstants.DECIMAL_NULL_VALUE;
                    }
                }
                if (values.ContainsKey("UpdateSales"))
                {
                    if (values["UpdateSales"] != null && decimal.TryParse(conversionUtils.RemoveThousandsFormat(values["UpdateSales"].ToString()),out updateSales))
                    {
                        this._UpdateSales = updateSales;
                    }
                    else
                    {
                        this._UpdateSales = ApplicationConstants.DECIMAL_NULL_VALUE;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        /// <summary>
        /// Gets the dataset for the Hours tab of revised budget
        /// </summary>
        /// <returns>the dataset for the Hours tab of revised budget</returns>
        public DataSet GetHours()
        {
            //Create the dataset structure (master-detail-detail)
            DataSet dsHours = new DataSet();

            try
            {
                dsHours = this.GetEntity().GetCustomDataSet("GetRevisedBudgetHours", this);
                SetTablesPrimaryKeys(dsHours);
                //The data set should return exactly 3 tables
                if (dsHours.Tables.Count != 3)
                    throw new IndException(ApplicationMessages.EXCEPTION_NUMBER_OF_DETAIL_TABLES);

                CalculateDateIntervalColumn(dsHours.Tables[1], "DateInterval", "StartYearMonth", "EndYearMonth");
                RoundTableValues(dsHours.Tables[0], new string[] { "CurrentVal", "UpdateVal", "NewVal" });
                RoundTableValues(dsHours.Tables[1], new string[] { "CurrentVal", "UpdateVal", "NewVal" });
                RoundTableValues(dsHours.Tables[2], new string[] { "CurrentVal", "UpdateVal", "NewVal" });
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dsHours;
        }

        public DataSet GetCostsSales()
        {
            //Create the dataset structure (master-detail-detail)
            DataSet dsCostsSales = new DataSet();
            try
            {
                dsCostsSales = this.GetEntity().GetCustomDataSet("GetRevisedBudgetCosts", this);
                SetTablesPrimaryKeys(dsCostsSales);
                //The data set should return exactly 3 tables
                if (dsCostsSales.Tables.Count != 3)
                    throw new IndException(ApplicationMessages.EXCEPTION_NUMBER_OF_DETAIL_TABLES);

                CalculateDateIntervalColumn(dsCostsSales.Tables[1], "DateInterval", "StartYearMonth", "EndYearMonth");
                RoundTableValues(dsCostsSales.Tables[0], new string[] { "CurrentCost", "UpdateCost", "NewCost", "CurrentSales", "UpdateSales", "NewSales" });
                RoundTableValues(dsCostsSales.Tables[1], new string[] { "CurrentCost", "UpdateCost", "NewCost", "CurrentSales", "UpdateSales", "NewSales" });
                RoundTableValues(dsCostsSales.Tables[2], new string[] { "CurrentCost", "UpdateCost", "NewCost", "CurrentSales", "UpdateSales", "NewSales" });
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dsCostsSales;
        }

        
        public DataSet BuildValidationDataSet(DataSet dsHours, DataSet dsCostsSales)
        {
            DataSet dsValidation = new DataSet();
            try
            {
                //Build the phases table based on the phases tables of dsHours and dsCostsSalse
                DataTable tblPhases = BuildValidationPhasesTable(dsHours.Tables[0], dsCostsSales.Tables[0]);
                dsValidation.Tables.Add(tblPhases);
                //Build the wp table based on the wp tables of dsHours and dsCostsSalse
                DataTable tblWP = BuildValidationWPTable(dsHours.Tables[1], dsCostsSales.Tables[1]);
                dsValidation.Tables.Add(tblWP);
                //Build the cost center table based on the cost center tables of dsHours and dsCostsSalse
                DataTable tblCostCenters = BuildValidationCostCentersTable(dsHours.Tables[2], dsCostsSales.Tables[2]);
                dsValidation.Tables.Add(tblCostCenters);

                //CalculateDateIntervalColumn(tblWP, "DateInterval", "StartYearMonth", "EndYearMonth");
                RoundTableValues(tblPhases, new string[] { "Averate", "ValHours", "OtherCost", "Sales", "NetCost" });
                RoundTableValues(tblWP, new string[] { "Averate", "ValHours", "OtherCost", "Sales", "NetCost" });
                RoundTableValues(tblCostCenters, new string[] { "Averate", "ValHours", "OtherCost", "Sales", "NetCost" });
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dsValidation;
        }

        /// <summary>
        /// Saves the revised budget to the database
        /// </summary>
        /// <param name="startYearMonth">start yearmonth of the work package associated to this budget entry (cost center)</param>
        /// <param name="endYearMonth">end yearmonth of the work package associated to this budget entry (cost center)</param>
        /// <param name="otherCosts">other costs object which is saved to the database</param>
        /// <param name="insertMasterRecord">specifies whether a master record will be inserted in the BUDGET_REVISED table</param>
        public void SaveBudget(YearMonth startYearMonth, YearMonth endYearMonth, RevisedBudgetOtherCosts otherCosts, bool insertMasterRecord)
        {
            //Begin the transaction
            BeginTransaction();
            try
            {
                //Insert the master record only if it is necessary
                if (insertMasterRecord)
                {
                    InsertMasterRecord();
                }
                //Save the budget
                SaveSplitted(startYearMonth, endYearMonth, otherCosts);
                //Commit the transaction
                CommitTransaction();
            }
            catch (Exception exc)
            {
                //If, for any reason, an exception was thrown, rollback the transaction
                RollbackTransaction();
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Saves the revised budget to the database
        /// </summary>
        /// <param name="startYearMonth">start yearmonth of the work package associated to this budget entry (cost center)</param>
        /// <param name="endYearMonth">end yearmonth of the work package associated to this budget entry (cost center)</param>
        /// <param name="otherCosts">other costs object which is saved to the database</param>
        /// <param name="isAssociateCurrency">specifies whether the data is in the currency of the associate
        /// (if this is the case, the values must be converted to the cost center currency before saving)</param>
        /// <param name="associateCurrency">the currency of the associate</param>
        /// <param name="converter">the converter object used to convert values between currencies</param>
        /// <param name="scaleOption">the scale option in which the values are represented (if it is different than unit, it will be
        /// converted before saving)</param>
        /// <param name="insertMasterRecord">specifies whether a master record will be inserted in the BUDGET_REVISED table</param>
        public void SaveBudget(YearMonth startYearMonth, YearMonth endYearMonth, RevisedBudgetOtherCosts otherCosts, bool isAssociateCurrency, int associateCurrency, CurrencyConverter converter, AmountScaleOption scaleOption, bool insertMasterRecord)
        {
            //Begin the transaction
            BeginTransaction();
            try
            {
                //Insert the master record only if it is necessary
                if (insertMasterRecord)
                {
                    InsertMasterRecord();
                }
                //Save the budget
                SaveSplitted(startYearMonth, endYearMonth, otherCosts, isAssociateCurrency, associateCurrency, converter, scaleOption);
                //Commit the transaction
                CommitTransaction();
            }
            catch (Exception exc)
            {
                //If, for any reason, an exception was thrown, rollback the transaction
                RollbackTransaction();
                throw new IndException(exc);
            }
        }

        public string GetVersionNumber(out bool bIsFake)
        {
            DataSet dsResult;
            string versionNo;

            bIsFake = false;
            try
            {
                dsResult = this.GetEntity().GetCustomDataSet("GetRevisedVersionNo", this);
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
                dsVersions = this.GetEntity().GetCustomDataSet("GetRevisedVersions", this);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
            return dsVersions;
        }
        #endregion Public Methods

        #region Private Methods
        /// <summary>
        /// Inserts (if it is the case) a master record in the master table
        /// OBS: The current object must have the IdProject set
        /// </summary>
        private void InsertMasterRecord()
        {
            if (this.IdProject == ApplicationConstants.INT_NULL_VALUE || this.IdAssociate == ApplicationConstants.INT_NULL_VALUE)
                throw new IndException(ApplicationMessages.EXCEPTION_REVISED_BUDGET_INCOMPLETE_PROPERTIES);

            this.GetEntity().ExecuteCustomProcedure("InsertRevisedBudgetMaster", this);
        }

        /// <summary>
        /// Save the Revised Budget object by splitting it into several object according to
        /// startYearMonth and endYearMonth values.
        /// </summary>
        /// <param name="startYearMonth">The startYearMonth value</param>
        /// <param name="endYearMonth">The endYearMonth value</param>
        private void SaveSplitted(YearMonth startYearMonth, YearMonth endYearMonth, RevisedBudgetOtherCosts otherCosts)
        {
            //TODO: Implement transactions

            //Get the months difference
            int monthsNo = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;
            int[] newHours = Rounding.Divide(this.NewHours, monthsNo);
            decimal[] newSales = Rounding.Divide(this.NewSales, monthsNo);
            //Iterate through each month and construct the InitialBudget object
            for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
            {
                //construct a new revised budget object
                RevisedBudget newBudget = new RevisedBudget(this.CurrentConnectionManager);
                newBudget.IdProject = this.IdProject;
                newBudget.IdPhase = this.IdPhase;
                newBudget.IdWP = this.IdWP;
                newBudget.IdCostCenter = this.IdCostCenter;
                newBudget.IdAssociate = this.IdAssociate;
                newBudget.YearMonth = currentYearMonth.Value;
                newBudget.NewHours = newHours[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                newBudget.NewSales = newSales[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                newBudget.SaveHours = this.SaveHours;
                if (this.State == EntityState.New)
                    newBudget.SetNew();
                if (this.State == EntityState.Modified)
                    newBudget.SetModified();
                if (this.State == EntityState.Deleted)
                    newBudget.SetDeleted();
                //Saves the new budget
                int idNewBudget = newBudget.Save();
            }
            //Insert Other cost object
            if (otherCosts != null)
            {
                otherCosts.SaveSplitted(startYearMonth, endYearMonth);
            }
        }

        /// <summary>
        /// Save the Revised Budget object by splitting it into several object according to
        /// startYearMonth and endYearMonth values.
        /// </summary>
        /// <param name="startYearMonth">The startYearMonth value</param>
        /// <param name="endYearMonth">The endYearMonth value</param>
        /// <param name="otherCosts">other costs object that will be saved if it is not null</param>
        /// <param name="isAssociateCurrency">specifies if a conversion must be made from the associate currency to the cost center currency before saving</param>
        /// <param name="associateCurrency">the id of the associate currency</param>
        /// <param name="converter">the currency converter object to be used for the currency conversion</param>
        /// <param name="scaleOption">the amount scale from the budget interface (if it is not unit, a multiplication must be made before saving)</param>
        private void SaveSplitted(YearMonth startYearMonth, YearMonth endYearMonth, RevisedBudgetOtherCosts otherCosts, bool isAssociateCurrency, int associateCurrency, CurrencyConverter converter, AmountScaleOption scaleOption)
        {
            //TODO: Implement transactions

            //Get the months difference
            int monthsNo = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;
            int[] newHours = Rounding.Divide(this.NewHours, monthsNo);
            decimal[] newSales = Rounding.Divide(this.NewSales, monthsNo);
            //Iterate through each month and construct the InitialBudget object
            for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
            {
                //construct a new revised budget object
                RevisedBudget newBudget = new RevisedBudget(this.CurrentConnectionManager);
                newBudget.IdProject = this.IdProject;
                newBudget.IdPhase = this.IdPhase;
                newBudget.IdWP = this.IdWP;
                newBudget.IdCostCenter = this.IdCostCenter;
                newBudget.IdAssociate = this.IdAssociate;
                newBudget.YearMonth = currentYearMonth.Value;
                newBudget.NewHours = newHours[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                newBudget.NewSales = newSales[currentYearMonth.GetMonthsDiffrence(startYearMonth)];
                newBudget.SaveHours = this.SaveHours;
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
                int idNewBudget = newBudget.Save();
            }
            //Insert Other cost object
            if (otherCosts != null)
            {
                otherCosts.SaveSplitted(startYearMonth, endYearMonth, isAssociateCurrency, this.IdCostCenter, associateCurrency, converter);
            }
        }
        /// <summary>
        /// Sets the primary key columns of the tables in a master-detail-detail grid
        /// </summary>
        /// <param name="dataSet"></param>
        private void SetTablesPrimaryKeys(DataSet dataSet)
        {
            dataSet.Tables[0].PrimaryKey = new DataColumn[] { dataSet.Tables[0].Columns["IdPhase"] };
            dataSet.Tables[1].PrimaryKey = new DataColumn[] { dataSet.Tables[1].Columns["IdPhase"], dataSet.Tables[1].Columns["IdWP"] };
            dataSet.Tables[2].PrimaryKey = new DataColumn[] { dataSet.Tables[2].Columns["IdPhase"], dataSet.Tables[2].Columns["IdWP"], dataSet.Tables[2].Columns["IdCostCenter"] };
        }

        /// <summary>
        /// Builds the phases table of validation dataset
        /// </summary>
        /// <param name="tblPhasesHours">the phases table in the hours dataset</param>
        /// <param name="tblPhasesCosts">the phases table in the costs & sales dataset</param>
        /// <returns>the phases table of validation dataset</returns>
        private DataTable BuildValidationPhasesTable(DataTable tblPhasesHours, DataTable tblPhasesCosts)
        {
            if (tblPhasesHours.Rows.Count != tblPhasesCosts.Rows.Count)
            {
                throw new IndException(ApplicationMessages.EXCEPTION_NO_ROWS_DIFFERENT);
            }
            DataTable tblPhases = new DataTable("tblPhases");
            //Create the columns
            DataColumn newCol = new DataColumn("IdProject", typeof(int));
            tblPhases.Columns.Add(newCol);
            newCol = new DataColumn("IdPhase", typeof(int));
            tblPhases.Columns.Add(newCol);
            newCol = new DataColumn("PhaseName", typeof(string));
            tblPhases.Columns.Add(newCol);
            newCol = new DataColumn("TotHours", typeof(int));
            tblPhases.Columns.Add(newCol);
            newCol = new DataColumn("Averate", typeof(decimal));
            tblPhases.Columns.Add(newCol);
            newCol = new DataColumn("ValHours", typeof(decimal));
            tblPhases.Columns.Add(newCol);
            newCol = new DataColumn("OtherCost", typeof(decimal));
            tblPhases.Columns.Add(newCol);
            newCol = new DataColumn("Sales", typeof(decimal));
            tblPhases.Columns.Add(newCol);
            newCol = new DataColumn("NetCost", typeof(decimal));
            tblPhases.Columns.Add(newCol);
            tblPhases.PrimaryKey = new DataColumn[] { tblPhases.Columns["IdPhase"] };

            foreach (DataRow hoursRow in tblPhasesHours.Rows)
            {
                DataRow costsRow = tblPhasesCosts.Rows.Find(hoursRow["IdPhase"]);
                if (costsRow == null)
                {
                    throw new IndException(ApplicationMessages.EXCEPTION_ROWS_DO_NOT_MATCH);
                }
                DataRow phasesRow = tblPhases.NewRow();
                phasesRow["IdProject"] = hoursRow["IdProject"];
                phasesRow["IdPhase"] = hoursRow["IdPhase"];
                phasesRow["PhaseName"] = hoursRow["PhaseName"];
                phasesRow["TotHours"] = hoursRow["NewHours"];
                if (hoursRow["NewVal"] != DBNull.Value && hoursRow["NewHours"] != DBNull.Value)
                {
                    phasesRow["Averate"] = ((int)hoursRow["NewHours"] == 0) ? 0 : decimal.Divide((decimal)hoursRow["NewVal"], (int)hoursRow["NewHours"]);
                }
                else
                {
                    phasesRow["Averate"] = DBNull.Value;
                }
                phasesRow["ValHours"] = hoursRow["NewVal"];
                phasesRow["OtherCost"] = costsRow["NewCost"];
                phasesRow["Sales"] = costsRow["NewSales"];

                phasesRow["NetCost"] = DSUtils.SumNullableDecimals (hoursRow["NewVal"], costsRow["NewCost"], costsRow["NewSales"]);
                tblPhases.Rows.Add(phasesRow);
            }

            return tblPhases;
        }
        /// <summary>
        /// Builds the wp table of validation dataset
        /// </summary>
        /// <param name="tblPhasesHours">the wp table in the hours dataset</param>
        /// <param name="tblPhasesCosts">the wp table in the costs & sales dataset</param>
        /// <returns>the wp table of validation dataset</returns>
        private DataTable BuildValidationWPTable(DataTable tblWPHours, DataTable tblWPCosts)
        {
            if (tblWPHours.Rows.Count != tblWPCosts.Rows.Count)
            {
                throw new IndException(ApplicationMessages.EXCEPTION_NO_ROWS_DIFFERENT);
            }
            DataTable tblWP = new DataTable("tblWP");
            //Create the columns
            DataColumn newCol = new DataColumn("IdProject", typeof(int));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("IdPhase", typeof(int));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("IdWP", typeof(int));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("WPName", typeof(string));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("StartYearMonth", typeof(int));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("EndYearMonth", typeof(int));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("DateInterval", typeof(string));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("TotHours", typeof(int));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("Averate", typeof(decimal));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("ValHours", typeof(decimal));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("OtherCost", typeof(decimal));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("Sales", typeof(decimal));
            tblWP.Columns.Add(newCol);
            newCol = new DataColumn("NetCost", typeof(decimal));
            tblWP.Columns.Add(newCol);
            tblWP.PrimaryKey = new DataColumn[] { tblWP.Columns["IdPhase"], tblWP.Columns["IdWP"] };

            foreach (DataRow hoursRow in tblWPHours.Rows)
            {
                DataRow costsRow = tblWPCosts.Rows.Find(new object[] { hoursRow["IdPhase"], hoursRow["IdWP"] });
                if (costsRow == null)
                {
                    throw new IndException(ApplicationMessages.EXCEPTION_ROWS_DO_NOT_MATCH);
                }
                DataRow phasesRow = tblWP.NewRow();
                phasesRow["IdProject"] = hoursRow["IdProject"];
                phasesRow["IdPhase"] = hoursRow["IdPhase"];
                phasesRow["IdWP"] = hoursRow["IdWP"];
                phasesRow["WPName"] = hoursRow["WPName"];
                phasesRow["StartYearMonth"] = hoursRow["StartYearMonth"];
                phasesRow["EndYearMonth"] = hoursRow["EndYearMonth"];
                phasesRow["DateInterval"] = hoursRow["DateInterval"];
                phasesRow["TotHours"] = hoursRow["NewHours"];
                if (hoursRow["NewVal"] != DBNull.Value && hoursRow["NewHours"] != DBNull.Value)
                {
                    phasesRow["Averate"] = ((int)hoursRow["NewHours"] == 0) ? 0 : decimal.Divide((decimal)hoursRow["NewVal"], (int)hoursRow["NewHours"]);
                }
                else
                {
                    phasesRow["Averate"] = DBNull.Value;
                }
                phasesRow["ValHours"] = hoursRow["NewVal"];
                phasesRow["OtherCost"] = costsRow["NewCost"];
                phasesRow["Sales"] = costsRow["NewSales"];

                phasesRow["NetCost"] = DSUtils.SumNullableDecimals(hoursRow["NewVal"], costsRow["NewCost"], costsRow["NewSales"]);            
                tblWP.Rows.Add(phasesRow);
            }

            return tblWP;
        }
        /// <summary>
        /// Builds the cost centers table of validation dataset
        /// </summary>
        /// <param name="tblPhasesHours">the cost centers table in the hours dataset</param>
        /// <param name="tblPhasesCosts">the cost centers table in the costs & sales dataset</param>
        /// <returns>the cost centers table of validation dataset</returns>
        private DataTable BuildValidationCostCentersTable(DataTable tblCostCentersHours, DataTable tblCostCentersCosts)
        {
            if (tblCostCentersHours.Rows.Count != tblCostCentersCosts.Rows.Count)
            {
                throw new IndException(ApplicationMessages.EXCEPTION_NO_ROWS_DIFFERENT);
            }
            DataTable tblCostCenters = new DataTable("tblCostCenters");
            //Create the columns
            DataColumn newCol = new DataColumn("IdProject", typeof(int));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("IdPhase", typeof(int));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("IdWP", typeof(int));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("IdCostCenter", typeof(int));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("CostCenterName", typeof(string));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("TotHours", typeof(int));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("Averate", typeof(decimal));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("ValHours", typeof(decimal));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("OtherCost", typeof(decimal));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("Sales", typeof(decimal));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("NetCost", typeof(decimal));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("IdCurrency", typeof(int));
            tblCostCenters.Columns.Add(newCol);
            newCol = new DataColumn("CurrencyCode", typeof(string));
            tblCostCenters.Columns.Add(newCol);
            tblCostCenters.PrimaryKey = new DataColumn[] { tblCostCenters.Columns["IdPhase"], tblCostCenters.Columns["IdWP"], tblCostCenters.Columns["IdCostCenter"] };

            foreach (DataRow hoursRow in tblCostCentersHours.Rows)
            {
                DataRow costsRow = tblCostCentersCosts.Rows.Find(new object[] { hoursRow["IdPhase"], hoursRow["IdWP"], hoursRow["IdCostCenter"] });
                if (costsRow == null)
                {
                    throw new IndException(ApplicationMessages.EXCEPTION_ROWS_DO_NOT_MATCH);
                }
                DataRow phasesRow = tblCostCenters.NewRow();
                phasesRow["IdProject"] = hoursRow["IdProject"];
                phasesRow["IdPhase"] = hoursRow["IdPhase"];
                phasesRow["IdWP"] = hoursRow["IdWP"];
                phasesRow["IdCostCenter"] = hoursRow["IdCostCenter"];
                phasesRow["CostCenterName"] = hoursRow["CostCenterName"];
                phasesRow["TotHours"] = hoursRow["NewHours"];
                if (hoursRow["NewVal"] != DBNull.Value && hoursRow["NewHours"] != DBNull.Value)
                {
                    phasesRow["Averate"] = ((int)hoursRow["NewHours"] == 0) ? 0 : decimal.Divide((decimal)hoursRow["NewVal"], (int)hoursRow["NewHours"]);
                }
                else
                {
                    phasesRow["Averate"] = DBNull.Value;
                }
                phasesRow["ValHours"] = hoursRow["NewVal"];
                phasesRow["OtherCost"] = costsRow["NewCost"];
                phasesRow["Sales"] = costsRow["NewSales"];

                phasesRow["NetCost"] = DSUtils.SumNullableDecimals(hoursRow["NewVal"], costsRow["NewCost"], costsRow["NewSales"]);

                phasesRow["IdCurrency"] = hoursRow["IdCurrency"];
                phasesRow["CurrencyCode"] = hoursRow["CurrencyCode"];
                tblCostCenters.Rows.Add(phasesRow);
            }

            return tblCostCenters;
        }

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
                        DataRow wpRow = GetParentWPRow(sourceDS, row);
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
        #endregion Private Methods

        #region Overrides
        /// <summary>
        /// Builds a list of columns whose values will be calculated depending on a specified aggregate function
        /// </summary>
        /// <param name="dsIndex"></param>
        /// <returns></returns>
        protected override BudgetColumnsCalculationsList GetCalculatedColumns(int dsIndex)
        {
            BudgetColumnsCalculationsList columnsList = new BudgetColumnsCalculationsList();
            switch (dsIndex)
            {
                //First dataset (on the first tab)
                case 0:
                    columnsList.Add("CurrentHours", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("UpdateHours", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("NewHours", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("CurrentVal", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("UpdateVal", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("NewVal", EBudgetCalculationMethod.eSUM);
                    break;
                //Second dataset (on the second tab)
                case 1:
                    columnsList.Add("CurrentCost", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("UpdateCost", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("NewCost", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("CurrentSales", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("UpdateSales", EBudgetCalculationMethod.eSUM);
                    columnsList.Add("NewSales", EBudgetCalculationMethod.eSUM);
                    break;
                //Third dataset (on the third tab)
                case 2:
                    break;
                default:
                    throw new NotImplementedException("Undefinded dataset index: " + dsIndex);
            }
            return columnsList;
        }

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

                if (_NewSales != ApplicationConstants.DECIMAL_NULL_VALUE)
                    _NewSales *= multiplier;
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

            _NewSales = converter.GetConversionValue(_NewSales, associateCurrency, new YearMonth(YearMonth), idCurrency);
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

       

        #endregion Overrides
    }
}
