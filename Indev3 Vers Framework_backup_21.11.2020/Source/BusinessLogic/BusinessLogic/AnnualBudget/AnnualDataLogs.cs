using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Data;
using Inergy.Indev3.DataAccess.Upload;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.DataAccess.AnnualBudget;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.BusinessLogic.AnnualBudget
{
    public class AnnualDataLogs : GenericEntity, IAnnualDataLogs
    {
        #region Public Properties
        private YearMonth _Period;
        [GridColumnProperty("Period")]
        public YearMonth Period
        {
            get { return _Period; }
            set { _Period = value; }
        }

        private string _Validation;
        [GridColumnProperty(false)]
        public string Validation
        {
            get { return _Validation; }
            set { _Validation = value; }
        }

        private string _FileName;
        [GridColumnProperty("File Name")]
        [PropertyValidation(false, 20)]
        public string FileName
        {
            get { return _FileName; }
            set { _FileName = value; }
        }

        private int _IdUser;
        [GridColumnProperty(false)]
        public int IdUser
        {
            get { return _IdUser; }
            set { _IdUser = value; }
        }

        private int _IdImport;
        [GridColumnProperty(false)]
        [IsInLogicalKey()]
        public int IdImport
        {
            get { return _IdImport; }
            set { _IdImport = value; }
        }
        private DateTime _Date;

        public DateTime Date
        {
            get { return _Date; }
            set { _Date = value; }
        }
        private string _CountryCode;
        [GridColumnProperty("Country")]
        [PropertyValidation(false, 5)]
        public string CountryCode
        {
            get { return _CountryCode; }
            set { _CountryCode = value; }
        }

        private string _UserName;
        [GridColumnProperty("User Name")]
        [PropertyValidation(false, 20)]
        public string UserName
        {
            get { return _UserName; }
            set { _UserName = value; }
        }
        #endregion Public Properties

        #region Constructors
        public AnnualDataLogs()
            : this(null)
        {
        }
        public AnnualDataLogs(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DbAnnualDataLogs(connectionManager));
        }

        public AnnualDataLogs(DataRow row, object connectionManager)
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
            this.Period = new YearMonth((int)row["Period"]);
            this.Validation = row["Validation"].ToString();
            this.IdImport = (int)row["IdImport"];
            this.FileName = row["FileName"].ToString();
            this.Date = (DateTime)row["Date"];
            this.CountryCode = row["Country"].ToString();
        }

        protected override DataSet PostGetEntities(DataSet ds)
        {
            AdjustDs(ds);
            return ds;
        }
        #endregion Overrides

        #region Public Methods
        public DataSet GetDataLogsDetail()
        {
            DataSet dsAnnual;
            try
            {
                dsAnnual = this.GetEntity().GetCustomDataSet("GetAnnualDataLogsDetail", this);
                AdjustDs(dsAnnual);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dsAnnual;
        }
        #endregion Public Methods
        
        #region Private Methods
        private void AdjustDs(DataSet ds)
        {
            DataColumn newPeriodColumn = new DataColumn("Period", typeof(string));

            int oldPeriodPosition = ds.Tables[0].Columns["Year"].Ordinal;

            ds.Tables[0].Columns.Add(newPeriodColumn);
            newPeriodColumn.SetOrdinal(oldPeriodPosition);

            //move old YearMonth columns to the end - since they will be hidded
            DataColumn oldPeriodColumn = ds.Tables[0].Columns["Year"];
            oldPeriodColumn.SetOrdinal(ds.Tables[0].Columns.Count - 1);

            //transform the null values for StartYearMonth and EndYearMonth
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                int year = (row["Year"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["Year"];

                //Get the startyearmonth value
                if (year == ApplicationConstants.INT_NULL_VALUE || year == ApplicationConstants.YEAR_SQL_MIN_VALUE)
                    row["Period"] = ApplicationConstants.NOT_AVAILABLE;
                else
                    row["Period"] = year.ToString();
            }
            ds.Tables[0].Columns.Remove("Year");
        }
        #endregion Private Methods
    }
}
