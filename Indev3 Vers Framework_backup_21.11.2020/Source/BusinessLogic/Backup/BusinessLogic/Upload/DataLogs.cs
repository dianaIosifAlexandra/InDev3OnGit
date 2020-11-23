using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Upload;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Data;
using Inergy.Indev3.DataAccess.Upload;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.BusinessLogic.Upload
{
    public class DataLogs : GenericEntity, IDataLogs
    {
        #region Public Properties
        private YearMonth _YearMonth;
        [GridColumnProperty(false)]
        public YearMonth YearMonth
        {
            get { return _YearMonth; }
            set { _YearMonth = value; }
        }
       
        private string _Validation;
        [GridColumnProperty(false)]
        public string Validation
        {
            get { return _Validation; }
            set { _Validation = value; }
        }

        private string _ApplicationName;
        [GridColumnProperty("Application")]
        [PropertyValidation(false,20)]
        public string ApplicationName
        {
            get { return _ApplicationName; }
            set { _ApplicationName = value; }
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
        #endregion Public Properties;

        #region Constructors
        public DataLogs()
            : this(null)
        {
        }
        public DataLogs(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBDataLogs(connectionManager));
        }

        public DataLogs(DataRow row, object connectionManager)
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
            this.YearMonth = new YearMonth((int)row["YearMonth"]);
            this.Validation = row["Validation"].ToString();
            this.ApplicationName = row["Application"].ToString();
            this.IdImport = (int)row["IdImport"];
            this.FileName = row["FileName"].ToString();
            this.IdUser = (int)row["IdUser"];
            this.Date = (DateTime)row["Date"];
            this.CountryCode = row["Country"].ToString();
            this.UserName = row["UserName"].ToString();

        }

        protected override DataSet PostGetEntities(DataSet ds)
        {
            DataColumn newPeriodColumn = new DataColumn("Period", typeof(string));

            int oldPeriodPosition = ds.Tables[0].Columns["YearMonth"].Ordinal;

            ds.Tables[0].Columns.Add(newPeriodColumn);
            newPeriodColumn.SetOrdinal(oldPeriodPosition);

            //move old YearMonth columns to the end - since they will be hidded
            DataColumn oldPeriodColumn = ds.Tables[0].Columns["YearMonth"];
            oldPeriodColumn.SetOrdinal(ds.Tables[0].Columns.Count - 1);

            //transform the null values for StartYearMonth and EndYearMonth
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                int yearMonth = (row["YearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["YearMonth"];

                //Get the startyearmonth value
                if (yearMonth == ApplicationConstants.INT_NULL_VALUE || yearMonth == ApplicationConstants.YEAR_MONTH_SQL_MIN_VALUE)
                    row["Period"] = ApplicationConstants.NOT_AVAILABLE;
                else
                    row["Period"] = DateTimeUtils.GetDateFromYearMonth(yearMonth);
            }
            return ds;
        }
        #endregion Overrides

        #region Public Methods
        public DataSet GetDataLogsDetail()
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet("GetDataLogsDetail", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }
        #endregion Public Methods
    }
}
