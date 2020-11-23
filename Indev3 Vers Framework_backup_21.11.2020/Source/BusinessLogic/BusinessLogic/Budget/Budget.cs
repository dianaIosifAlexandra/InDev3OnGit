using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Collections;
using Inergy.Indev3.BusinessLogic.Authorization;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public abstract class Budget : GenericEntity
    {
        #region Constants
        public const string THOUSANDS_SEPARATOR = ",";
        public const string DECIMAL_SEPARATOR = ".";
        #endregion Constants

        #region Properties
        protected ConversionUtils conversionUtils;
        private int _IdProject;
        /// <summary>
        /// The Project's Id
        /// </summary>
        public int IdProject
        {
            get { return _IdProject; }
            set { _IdProject = value; }
        }

        private int _IdPhase;
        /// <summary>
        /// the Phase's Id
        /// </summary>
        public int IdPhase
        {
            get { return _IdPhase; }
            set { _IdPhase = value; }
        }

        private int _IdWP;
        /// <summary>
        /// The WP's Id
        /// </summary>
        public int IdWP
        {
            get { return _IdWP; }
            set { _IdWP = value; }
        }

        private int _IdAssociate;
        /// <summary>
        /// The Associate's Id
        /// </summary>
        public int IdAssociate
        {
            get { return _IdAssociate; }
            set { _IdAssociate = value; }
        }

        private int _IdAssociateViewer;
        /// <summary>
        /// The Associate's Id
        /// </summary>
        public int IdAssociateViewer
        {
            get { return _IdAssociateViewer; }
            set { _IdAssociateViewer = value; }
        }

        private int _IdCostCenter;
        public int IdCostCenter
        {
            get
            {
                return _IdCostCenter;
            }
            set
            {
                _IdCostCenter = value;
            }
        }
        private int _YearMonth;
        public int YearMonth
        {
            get
            {
                return _YearMonth;
            }
            set
            {
                _YearMonth = value;
            }
        }

        private int _IdDetail;

        public int IdDetail
        {
            get { return _IdDetail; }
            set { _IdDetail = value; }
        }

        private bool _IsAssociateCurrency;
        //Specifies if the values from the budget object are in the currency of the associate
        public bool IsAssociateCurrency
        {
            get { return _IsAssociateCurrency; }
            set { _IsAssociateCurrency = value; }
        }
        #endregion Properties

        #region Constructors
        public Budget(object connectionManager)
            : base(connectionManager)
        {
            conversionUtils = new ConversionUtils();
        }
        #endregion Constructors

        #region Protected Methods
        /// <summary>
        /// Calculates the Date  Interval column for a given budget table
        /// </summary>
        /// <param name="sourceTable">the source table</param>
        /// <param name="dateIntervalCol">The column that contains the Date Interval value</param>
        /// <param name="startYearMonthCol">The column that contains the StartYearMonth value</param>
        /// <param name="endYearMonthCol">The column that contains the EndYearMonth value</param>
        protected void CalculateDateIntervalColumn(DataTable sourceTable, string dateIntervalCol, string startYearMonthCol, string endYearMonthCol)
        {
            if (!sourceTable.Columns.Contains(startYearMonthCol))
                throw new IndException(ApplicationMessages.EXCEPTION_COLUMN_MISSING);
            if (!sourceTable.Columns.Contains(endYearMonthCol))
                throw new IndException(ApplicationMessages.EXCEPTION_COLUMN_MISSING);
            sourceTable.Columns.Add(new DataColumn(dateIntervalCol,typeof(string)));
            foreach (DataRow row in sourceTable.Rows)
            {
                
                if ((row[startYearMonthCol] == DBNull.Value) || (row[endYearMonthCol] == DBNull.Value))
                    continue;
                YearMonth startYearMonth = new YearMonth(row[startYearMonthCol].ToString());
                YearMonth endYearMonth = new YearMonth(row[endYearMonthCol].ToString());


                string firstPart = startYearMonth.GetMonthRepresentation() + "-" + startYearMonth.Year.ToString().Substring(2);
                string lastPart = endYearMonth.GetMonthRepresentation() + "-" + endYearMonth.Year.ToString().Substring(2);
                row[dateIntervalCol] = firstPart + " to " + lastPart;
            }
        }

        /// <summary>
        /// Rounds the values from a datatable
        /// </summary>
        /// <param name="table">The table that contains the values</param>
        /// <param name="columns">The columns that contain the values that will be rounded</param>
        protected void RoundTableValues(DataTable table, string[] columns)
        {
            //Cycle through ach table row
            foreach (DataRow row in table.Rows)
            {
                //For each column update the value from the current row
                for (int i = 0; i < columns.Length; i++)
                {
                    //The column type should be decimal
                    if (table.Columns[columns[i]].DataType != typeof(Decimal))
                        throw new IndException(ApplicationMessages.EXCEPTION_WRONG_TYPE_RECEIVED);

                    //Round the value if it is diffrent than null
                    if (row[columns[i]]==DBNull.Value)
                        continue;
                    row[columns[i]] = Rounding.Round((decimal)row[columns[i]]);
                }
            }
        }

        /// <summary>
        /// Updates a table using a child table and the associated agreagate functions
        /// </summary>
        /// <param name="parentTable">The parent table to be updated</param>
        /// <param name="childTable">The child table which contains the data needed for the calcultation</param>
        /// <param name="keyColumns">the columns that represents the logical key</param>
        /// <param name="dsIndex">The index of the dataset for which we are updating the parent table</param>
        protected void UpdateParentTableValues(DataTable parentTable, DataTable childTable, string[] keyColumns, int dsIndex)
        {
            foreach (string keyColumn in keyColumns)
            {
                if (!parentTable.Columns.Contains(keyColumn))
                    throw new IndException(ApplicationMessages.EXCEPTION_COLUMN_MISSING);
                if (!childTable.Columns.Contains(keyColumn))
                    throw new IndException(ApplicationMessages.EXCEPTION_COLUMN_MISSING);
            }
            BudgetColumnsCalculationsList calculatedColumns = GetCalculatedColumns(dsIndex);

            foreach (DataRow masterRow in parentTable.Rows)
            {
                foreach (KeyValuePair<string,EBudgetCalculationMethod> entry in calculatedColumns)
                    masterRow[entry.Key] = 0;
                int childRowCount = 0;
                foreach (DataRow childRow in childTable.Rows)
                {
                    bool isChildRow = true;
                    for (int i = 0; i < keyColumns.Length; i++)
                        if ((int)masterRow[keyColumns[i]] != (int)childRow[keyColumns[i]])
                        {
                            isChildRow = false;
                            break;
                        }

                    if (!isChildRow)
                        continue;
                    else
                        childRowCount++;

                    foreach (KeyValuePair<string, EBudgetCalculationMethod> entry in calculatedColumns)
                    {
                        if (parentTable.Columns[entry.Key].DataType == typeof(Decimal))
                            masterRow[entry.Key] = (decimal)masterRow[entry.Key] + (decimal)childRow[entry.Key];
                        else
                            masterRow[entry.Key] = (int)masterRow[entry.Key] + (int)childRow[entry.Key];
                    }
                }
                foreach (KeyValuePair<string, EBudgetCalculationMethod> entry in calculatedColumns)
                {
                    if (entry.Value == EBudgetCalculationMethod.eAVG && childRowCount != 0)
                        masterRow[entry.Key] = Rounding.Round((decimal)masterRow[entry.Key] / childRowCount);
                }
            }
        }

        /// <summary>
        /// Returns the parent row for a cost center
        /// </summary>
        /// <param name="sourceDS">The budget source dataset</param>
        /// <param name="currentRow">the datarow for the costcenter from the third table</param>
        /// <returns>The WP datarow of the costcenter parent</returns>
        protected DataRow GetParentWPRow(DataSet sourceDS, DataRow currentRow)
        {
            foreach (DataRow row in sourceDS.Tables[1].Rows)
            {
                if (((int)currentRow["IdWP"] == (int)row["IdWP"]) && ((int)currentRow["IdPhase"] == (int)row["IdPhase"]))
                {
                    return row;
                }
            }
            return null;
        }
        #endregion Protected Methods

        #region Public Methods
        /// <summary>
        /// Applay the scale option to an existing datasource(to all decimal columns). 
        /// If the newOption is greater than the oldOption, than the datasource need 
        /// to be expressed in Unit scale
        /// </summary>
        /// <param name="oldOption">The old scale option</param>
        /// <param name="newOption">The new scale optin</param>
        /// <param name="initialTable">The table that will be transformed</param>
        public void ApplyAmountScaleOptionToDataSource(AmountScaleOption oldOption, AmountScaleOption newOption, DataTable initialTable)
        {
            try
            {
                //Gets the diffrence between scales
                int scaleDif = oldOption - newOption;

                if ((scaleDif > 0) && (oldOption != AmountScaleOption.Unit))
                    throw new IndException(ApplicationMessages.EXCEPTION_PRECISION_LOST_ON_CONVERT);

                //The number that will be used to multiplay the values from the data source 
                decimal transformInd = 1;
                //Represents the sign that will be used for multiplay
                decimal multiplier = (scaleDif > 0) ? 1000 : (decimal)1 / 1000;
                //Calculates the transform indice
                for (int i = 0; i < Math.Abs(scaleDif); i++)
                {
                    transformInd *= multiplier;
                }
                //Gets the decimal columns in the table
                foreach (DataColumn column in initialTable.Columns)
                {
                    if (column.DataType == typeof(decimal))
                    {
                        //Update the value for all rows
                        foreach (DataRow row in initialTable.Rows)
                        {
                            if (row[column] != DBNull.Value)
                            {
                                row[column] = Rounding.Round(Decimal.Multiply((decimal)row[column], transformInd));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Applay the scale option to an existing hash table(to all decimal columns). 
        /// If the newOption is greater than the oldOption, than the datasource need 
        /// to be expressed in Unit scale
        /// </summary>
        /// <param name="oldOption">The old scale option</param>
        /// <param name="newOption">The new scale optin</param>
        /// <param name="initialTable">The table that will be transformed</param>
        public virtual void ApplyAmountScaleOptionToHT(AmountScaleOption oldOption, AmountScaleOption newOption, List<InitialBudget> htValues)
        {

        }
        #endregion Public Methods

        #region Virtual methods

        /// <summary>
        /// Transforms the datasource by updating the decimal values with the exchange rate of the associate currency 
        /// </summary>
        /// <param name="sourceDS">The source dataset</param>
        /// <param name="currentUser">The current logged user</param>
        /// <param name="dsIndex">the index of the dataset for which the calculations are made (in revised budget there are 3 tabs -> 3 datasets)</param>
        protected virtual void ApplyAssociateCurrency(DataSet sourceDS, CurrentUser currentUser, CurrencyConverter converter, int dsIndex)
        {
        }

        /// <summary>
        /// Sets null instead of acutal data for the first and second table
        /// </summary>
        /// <param name="sourceDS">the source dataset</param>
        /// <param name="dsIndex">the index of the dataset for which the calculations are made (in revised budget there are 3 tabs -> 3 datasets)</param>
        protected virtual void RemoveNonCalculableValues(DataTable sourceDS, int dsIndex)
        {
        }

        public virtual void ApplyDataSourceTransformations(DataSet sourceDS, bool isAssociateCurrency, CurrentUser currentUser, CurrencyConverter converter, int dsIndex)
        {
            if (!isAssociateCurrency )
            {
                RemoveNonCalculableValues(sourceDS.Tables[0], dsIndex);
                RemoveNonCalculableValues(sourceDS.Tables[1], dsIndex);
            }
        }

        /// <summary>
        /// Applyes the given amount scale to the object values
        /// </summary>
        /// <param name="scaleOption">The Amount Scale Option to be applyed</param>
        public virtual void ApplyAmountScaleOption(AmountScaleOption scaleOption)
        {
        }

        /// <summary>
        /// Builds a list of columns to which aggregate functions will be applied
        /// </summary>
        /// <param name="dsIndex">the index of the dataset, in case there are more datasets (more tabs in UI) in the budget</param>
        /// <returns></returns>
        protected virtual BudgetColumnsCalculationsList GetCalculatedColumns(int dsIndex)
        {
            return new BudgetColumnsCalculationsList();
        }

        /// <summary>
        /// Apply the associate currency to the current object properties
        /// </summary>
        /// <param name="associateCurrency">the associate currency</param>
        protected virtual void ApplyCostCenterCurrency(int associateCurrency, CurrencyConverter converter)
        {
        }
        #endregion Virtual methods
    }
}
