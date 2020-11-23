using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework.Timing_Interco;


namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// Represents the Project Core Team entity
    /// </summary>
    public class TimingAndInterco : GenericEntity, ITimingAndInterco
    {
        #region ITimingAndInterco Members

        private int _IdProject;
        public int IdProject
        {
            get
            {
                return _IdProject;
            }
            set
            {
                _IdProject = value;
            }
        }
        private int _IdPhase;
        public int IdPhase
        {
            get
            {
                return _IdPhase;
            }
            set
            {
                _IdPhase = value;
            }
        }
        private string _PhaseCode;
        public string PhaseCode
        {
            get
            {
                return _PhaseCode;
            }
            set
            {
                _PhaseCode = value;
            }
        }
        
        private string _PhaseName;
        public string PhaseName
        {
            get
            {
                return _PhaseName;
            }
            set
            {
                _PhaseName = value;
            }
        }
        private int _IdWP;
        public int IdWP
        {
            get
            {
                return _IdWP;
            }
            set
            {
                _IdWP = value;
            }
        }
        private string _WPCode;
        public string WPCode
        {
            get
            {
                return _WPCode;
            }
            set
            {
                _WPCode = value;
            }
        }
        private string _WPName;
        public string WPName
        {
            get
            {
                return _WPName;
            }
            set
            {
                _WPName = value;
            }
        }

        private int _StartYearMonth;
        public int StartYearMonth
        {
            get
            {
                return _StartYearMonth;
            }
            set
            {
                _StartYearMonth = value;
            }
        }
        private int _EndYearMonth;
        public int EndYearMonth
        {
            get
            {
                return _EndYearMonth;
            }
            set
            {
                _EndYearMonth = value;
            }
        }

        private int _LastUserUpdate;

        public int LastUserUpdate
        {
            get { return _LastUserUpdate; }
            set { _LastUserUpdate = value; }
        }

        private int _IdAssociate;

        public int IdAssociate
        {
            get { return _IdAssociate; }
            set { _IdAssociate = value; }
        }

        private List<IIntercoCountry> _IntercoCountries;

        public List<IIntercoCountry> IntercoCountries
        {
            get { return _IntercoCountries; }
            set { _IntercoCountries = value; }
        }

        public static readonly int FirstCountryColumn = 7;
        #endregion ITimingAndInterco

        #region Constructors
        public TimingAndInterco(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBTimingAndInterco(connectionManager));
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
            _IdPhase = ApplicationConstants.INT_NULL_VALUE;
            _IdWP = ApplicationConstants.INT_NULL_VALUE;
            _StartYearMonth = ApplicationConstants.INT_NULL_VALUE;
            _EndYearMonth = ApplicationConstants.INT_NULL_VALUE;
        }

        public TimingAndInterco(DataRow row, object connectionManager)
            : this(connectionManager)
        {
            try
            {
                Row2Object(row);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion

        #region Overrides
        protected override void Row2Object(DataRow row)
        {
            this.IdProject = (int)row["IdProject"];
            this.IdPhase = (int)row["IdPhase"];
            this.IdWP = (int)row["IdWP"];
            this.WPName = row["WPCode"].ToString();
            this.StartYearMonth = (row["StartYearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["StartYearMonth"];
            this.EndYearMonth = (row["EndYearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["EndYearMonth"];
            if (row["WPCode"].ToString().Contains("-"))
                this.WPCode = row["WPCode"].ToString().Split('-')[0].Trim();
            else
                this.WPCode = row["WPCode"].ToString().Substring(0, 3);
        }
        public override void SaveChildren()
        {
            try
            {
                if (this.IntercoCountries == null)
                    return;
                foreach (IntercoCountry country in this.IntercoCountries)
                {
                    country.Save();
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion Overrides

        #region Public Methods
        public DataSet GetAffectedWPTiming()
        {
            try
            {
                DataSet ds = this.GetEntity().GetCustomDataSet("GetAffectedWPTiming", this);
                DataSet newDS = TransformTimingDS(ds);
                return newDS;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        public DataSet GetAffectedWPInterco()
        {
            try
            {
                DataSet ds = this.GetEntity().GetCustomDataSet("GetAffectedWPInterco", this);
                DataSet newDS = TransformIntercoDS(ds);
                return newDS;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        public DataSet GetUnnaffectedWP()
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet("GetUnaffectedWP", this);
                ConversionUtils.MakeUniqueKey(ds.Tables[0], new string[] { "IdProject", "IdPhase", "IdWP" });
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }
        /// <summary>
        /// Return the start yearMonth and endYearMonth for the given WP
        /// </summary>
        /// <param name="keys"></param>
        /// <returns></returns>
        public DataTable GetWPTiming(List<IntercoLogicalKey> keys)
        {
            DataTable resultTable = null;
            try
            {
                foreach (IntercoLogicalKey key in keys)
                {
                    this.SetKey(key);
                    DataSet ds = this.GetEntity().GetCustomDataSet("GetWPTiming", this);
                    if (ds.Tables[0].Rows.Count == 0)
                        throw new IndException(string.Format(ApplicationMessages.EXCEPTION_INTERCO_WP_PHASE_CHANGED, key.WPCode));
                    if (resultTable == null)
                        resultTable = ds.Tables[0].Clone();
                    DataRow row = ds.Tables[0].Rows[0];
                    resultTable.ImportRow(row);
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return resultTable;
        }

        /// <summary>
        /// Creates the country layout
        /// </summary>
        /// <param name="idProject">The project for which the layout is created</param>
        /// <param name="countriesLayout">The list of objects that represent the layout</param>
        public static void CreateCountryLayout(int idProject, List<IntercoCountry> countriesLayout, object connectionManager)
        {
            try
            {
                //First delete the country layout for this layer
                IntercoCountry.DeleteCountryLayout(idProject, connectionManager);
                //Recreate the layout
                IntercoCountry.CreateCountryLayout(countriesLayout);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public static void SaveAll(List<TimingAndInterco> intercos)
        {
            try
            {
                //The state of the Interco object can not be New. Cycle in the list of objects and save
                //each one of them
                foreach (TimingAndInterco interco in intercos)
                {
                    if ((interco.State == EntityState.Modified) || (interco.State == EntityState.Deleted))
                        interco.Save();
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public void AddCountries(DataRow row)
        {
            try
            {
                DataTable table = row.Table;
                this.IntercoCountries = new List<IIntercoCountry>();
                for (int i = TimingAndInterco.FirstCountryColumn; i < table.Columns.Count; i++)
                {
                    if (table.Columns[i].ColumnName == "IsChanged")
                        continue;
                    int countryId = int.Parse(table.Columns[i].ColumnName);
                    IIntercoCountry country = new IntercoCountry(this.CurrentConnectionManager);
                    country.IdProject = this.IdProject;
                    country.IdPhase = this.IdPhase;
                    country.IdWP = this.IdWP;
                    country.IdCountry = countryId;
                    country.Percent = (row[i] == DBNull.Value) ? ApplicationConstants.DECIMAL_NULL_VALUE : (decimal)row[i];
                    country.WPCode = this.WPCode;
                    if ((bool)row["IsChanged"])
                        ((IntercoCountry)country).SetModified();
                    this.IntercoCountries.Add(country);
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        public static IntercoLogicalKey GetKey(int rowIndex, DataTable table)
        {
            if (table.Rows.Count <= rowIndex)
                return new IntercoLogicalKey();

            IntercoLogicalKey key = new IntercoLogicalKey();
            try
            {

                DataRow row = table.Rows[rowIndex];
                key.IdProject = (int)row["IdProject"];
                key.IdPhase = (int)row["IdPhase"];
                key.IdWP = (int)row["IdWP"];
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return key;
        }
        public static IntercoLogicalKey GetKey(DataRow row)
        {
            IntercoLogicalKey key = new IntercoLogicalKey();
            try
            {
                key.IdProject = (int)row["IdProject"];
                key.IdPhase = (int)row["IdPhase"];
                key.IdWP = (int)row["IdWP"];
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return key;
        }
        public static IntercoLogicalKey GetKey(TimingAndInterco intreco)
        {
            IntercoLogicalKey key = new IntercoLogicalKey();
            try
            {
                key.IdProject = intreco.IdProject;
                key.IdPhase = intreco.IdPhase;
                key.IdWP = intreco.IdWP;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return key;
        }

        #endregion Public Methods

        #region Private Methods
        private void SetKey(IntercoLogicalKey key)
        {
            this.IdProject = key.IdProject;
            this.IdPhase = key.IdPhase;
            this.IdWP = key.IdWP;
        }
        private DataSet TransformTimingDS(DataSet ds)
        {
            //put PhaseName next to PhaseCode
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                row["PhaseCode"] = row["PhaseCode"] + " - " + row["PhaseName"];
            }
            //put WPName next to WPCode
            foreach (DataRow row in ds.Tables[1].Rows)
            {
                row["WPCode"] = row["WPCode"] + " - " + row["WPName"];
            }
            ds.Tables[1].DefaultView.Sort = "PhaseCode,WPCode";
            ds.AcceptChanges();
            return ds;
        }
        
        private DataSet TransformIntercoDS(DataSet originalDS)
        {
            DataSet newDS = new DataSet();
            newDS.Tables.Add(originalDS.Tables[0].Copy());
            DataTable phasesTable = newDS.Tables[0];

            foreach (DataRow row in phasesTable.Rows)
            {
                row["PhaseCode"] = row["PhaseCode"] + " - " + row["PhaseName"];
            }

            DataTable countriesTable = this.GetEntity().GetCustomDataSet("GetWPIntercoCountries", this).Tables[0];

            //Get the table that has as columns the final first three columns of the result table
            DataTable structureTable = originalDS.Tables[1];

            DataTable valuesTable = originalDS.Tables[2];

            DataTable resultTable = new DataTable();
            
            #region Build Final Table and Phases Table Structure
            //Add the first three columns
            resultTable.Columns.Add(new DataColumn("IdProject", typeof(int)));
            resultTable.Columns.Add(new DataColumn("IdPhase", typeof(int)));
            resultTable.Columns.Add(new DataColumn("PhaseCode", typeof(string)));
            resultTable.Columns.Add(new DataColumn("IdWP", typeof(int)));
            resultTable.Columns.Add(new DataColumn("WPCode", typeof(string)));
            //Add the Total Column
            resultTable.Columns.Add(new DataColumn("HasBudget", typeof(bool)));
            resultTable.Columns.Add(new DataColumn("Total",typeof(decimal)));


            //Add the Total Column
            phasesTable.Columns.Add(new DataColumn("Total", typeof(decimal)));

            //Add the countries columns
            foreach (DataRow row in countriesTable.Rows)
            {
                string countryName = row["CountryName"].ToString();
                int countryId = (int)row["IdCountry"];
                DataColumn countryCol = new DataColumn(countryId.ToString(), typeof(decimal));
                countryCol.Caption = countryName;
                countryCol.DefaultValue = "0.00";
                resultTable.Columns.Add(countryCol);

                countryCol = new DataColumn(countryId.ToString(), typeof(decimal));
                countryCol.Caption = countryName;
                phasesTable.Columns.Add(countryCol);
            }
            #endregion Build Final Table Structure

            #region Add Rows int he Final Table Structure
            //this will add values only in the first three columns of each row
            foreach (DataRow row in structureTable.Rows)
            {
                DataRow newRow = resultTable.NewRow();
                newRow["IdProject"] = row["IdProject"];
                newRow["IdPhase"] = row["IdPhase"];
                newRow["PhaseCode"] = row["PhaseCode"] ;
                newRow["IdWP"] = row["IdWP"];
                //newRow["WPCode"] = row["WPCode"];
                newRow["WPCode"] = row["WPCode"] + " - " + row["WPName"];
                newRow["HasBudget"] = row["HasBudget"];
                resultTable.Rows.Add(newRow);
            }
            #endregion Add Rows int he Final Table Structure

            #region Fill final DS with Interco values
            int resultIterator = 0;
            int valuesIterator = 0;
            while ((valuesIterator < valuesTable.Rows.Count) && (resultIterator < resultTable.Rows.Count))
            {
                IntercoLogicalKey resultKey = GetKey(resultIterator, resultTable);
                IntercoLogicalKey valuesKey = GetKey(valuesIterator, valuesTable);
                if (IntercoLogicalKey.AreKeysEqual(resultKey, valuesKey) && (!resultKey.IsNull()))
                {
                    //Fills the value from the value table in the result table
                    DataRow valuesRow = valuesTable.Rows[valuesIterator];
                    int idCountry = (int)valuesRow["IdCountry"];
                    decimal percent = (decimal)valuesRow["Percent"];

                    DataRow resultRow = resultTable.Rows[resultIterator];
                    resultRow.BeginEdit();
                    resultRow[idCountry.ToString()] = percent;
                    resultRow.EndEdit();
                    valuesIterator++;
                }
                else
                    resultIterator++;
            }
            #endregion Fill final DS with Interco values

            string expression ="";
            for (int i = FirstCountryColumn; i < resultTable.Columns.Count;i++ )
            {
                DataColumn col = resultTable.Columns[i];
                if (col.ColumnName != "IsChanged")
                    expression += "IsNull([" + col.ColumnName + "],0)+";
            }
            if (expression != "")
                resultTable.Columns["Total"].Expression = expression.Substring(0, expression.Length - 1);

            resultTable.AcceptChanges();

            newDS.Tables.Add(resultTable);
            newDS.Tables[1].DefaultView.Sort = "PhaseCode,WPCode";
            newDS.AcceptChanges();
            return newDS;
        }

        
        #endregion Private Methods

    }
    
    

    public class IntercoCountry:GenericEntity, IIntercoCountry
    {
        public IntercoCountry(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBIntercoCountry(connectionManager));
        }
        private int _IdProject;
        public int IdProject
        {
            get
            {
                return _IdProject;
            }
            set
            {
                _IdProject = value;
            }
        }
        private int _IdPhase;

        public int IdPhase
        {
            get { return _IdPhase; }
            set { _IdPhase = value; }
        }
        private int _IdWP;

        public int IdWP
        {
            get { return _IdWP; }
            set { _IdWP = value; }
        }
        private int _IdCountry;
        public int IdCountry
        {
            get
            {
                return _IdCountry;
            }
            set
            {
                _IdCountry = value;
            }
        }

        decimal _Percent;

        public decimal Percent
        {
            get { return _Percent; }
            set { _Percent = value; }
        }

        
        private int _Position;
        public int Position
        {
            get
            {
                return _Position;
            }
            set
            {
                _Position = value;
            }
        }

        private string _WPCode;
        public string WPCode
        {
            get
            {
                return _WPCode;
            }
            set
            {
                _WPCode = value;
            }
        }
        
        #region Internal Methods
        internal static void DeleteCountryLayout(int projectId, object connectionManager)
        {
            IntercoCountry country = new IntercoCountry(connectionManager);
            country.IdProject = projectId;
            country.GetEntity().ExecuteCustomProcedure("DeleteCountryLayout", country);
        }
        internal static void CreateCountryLayout(List<IntercoCountry> countries)
        {
            foreach (IntercoCountry country in countries)
            {
                country.GetEntity().ExecuteCustomProcedure("InsertCountryLayout", country);
            }
        }
        #endregion Internal Methods
        
    }
}

