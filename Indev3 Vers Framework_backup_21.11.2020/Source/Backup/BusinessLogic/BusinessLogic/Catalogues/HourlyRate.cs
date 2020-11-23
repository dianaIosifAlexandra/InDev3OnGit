using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Collections;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the HourlyRate Entity
    /// </summary>
    public class HourlyRate : GenericEntity, IHourlyRate
    {
        #region IHourlyRate Members

        private int _YearMonth;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [IsInLogicalKey()]
        [DesignerName("Period")]
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
        private int _IdCurrency;
        [PropertyValidation(false)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(Currency))]       
        [DesignerName("Currency")]
        public int IdCurrency
        {
            get
            {
                return _IdCurrency;
            }
            set
            {
                _IdCurrency = value;
            }
        }
        private string _CurrencyName;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Currency")]
        public string CurrencyName
        {
            get
            {
                return _CurrencyName;
            }
            set
            {
                _CurrencyName = value;
            }
        }
        private int _IdCostCenter;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(CostCenter))]
        [IsInLogicalKey()]
        [DesignerName("Cost Center")]
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
        private string _CostCenterCode;
        [PropertyValidation(true, 15)]
        [GridColumnProperty("Cost Center Code")]
        public string CostCenterCode
        {
            get
            {
                return _CostCenterCode;
            }
            set
            {
                _CostCenterCode = value;
            }
        }

        private string _CostCenterName;
        [PropertyValidation(true, 30)]
        [GridColumnProperty(false)]
        public string CostCenterName
        {
            get
            {
                return _CostCenterName;
            }
            set
            {
                _CostCenterName = value;
            }
        }

        private decimal _Value;
        [PropertyValidation(true, 0, 999999999)]
        [GridColumnProperty("Hourly Rate")]
        [DesignerName("Hourly Rate")]
        public decimal Value
        {
            get
            {
                return _Value;
            }
            set
            {
                _Value = value;
            }
        }
        private int _IdCountry;

        public int IdCountry
        {
            get { return _IdCountry; }
            set { _IdCountry = value; }
        }

        #region Mass Attribution Properties

        private int _IdInergyLocation;
        [PropertyValidation(false)]
        [GridColumnProperty(false)]
        [DesignerName("Inergy Location")]
        [ReferenceMapping(typeof(InergyLocation))]
        public int IdInergyLocation
        {
            get { return _IdInergyLocation; }
            set { _IdInergyLocation = value; }
        }

        private string _InergyLocationName;
        [PropertyValidation(true)]
        [GridColumnProperty("Inergy Location")]        
        public string InergyLocationName
        {
            get { return _InergyLocationName; }
            set { _InergyLocationName = value; }
        }

        private int _StartYearMonth;

        public int StartYearMonth
        {
            get { return _StartYearMonth; }
            set { _StartYearMonth = value; }
        }

        private int _EndYearMonth;

        public int EndYearMonth
        {
            get { return _EndYearMonth; }
            set { _EndYearMonth = value; }
        }
        #endregion Mass Attribution Properties


        #endregion

        #region Constructors
        public HourlyRate()
            : this(null)
        {

        }
        public HourlyRate(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBHourlyRate(connectionManager));
            _IdCurrency = ApplicationConstants.INT_NULL_VALUE;
            _IdCostCenter = ApplicationConstants.INT_NULL_VALUE;
            _YearMonth = ApplicationConstants.INT_NULL_VALUE;
            _Value = ApplicationConstants.DECIMAL_NULL_VALUE;
            _IdCountry = ApplicationConstants.INT_NULL_VALUE;
        }
        public HourlyRate(DataRow row, object connectionManager)
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

        #region Public Methods
        public static int MassFill(ArrayList inergyLocationsIds, int startYearMonth, int endYearMonth, decimal hrValue, object connectionManager)
        {
            int updatedCCCount = 0;
            try
            {
                foreach (int inergyLocationId in inergyLocationsIds)
                {
                    HourlyRate hr = new HourlyRate(connectionManager);
                    hr.IdInergyLocation = inergyLocationId;
                    hr.StartYearMonth = startYearMonth;
                    hr.EndYearMonth = endYearMonth;
                    hr.Value = hrValue;
                    updatedCCCount += hr.GetEntity().ExecuteCustomProcedureWithReturnValue("MassAttribution", hr);
                }
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
            return updatedCCCount;
        }

        public override void FillEditParameters(Dictionary<string, object> editParameters)
        {
            try
            {
                base.FillEditParameters(editParameters);
                if (editParameters.ContainsKey("YearMonth"))
                {
                    this.YearMonth = int.Parse(editParameters["YearMonth"].ToString());
                }
                if (editParameters.ContainsKey("IdCostCenter"))
                {
                    this.IdCostCenter = int.Parse(editParameters["IdCostCenter"].ToString());
                }
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }
        #endregion Public Methods

        #region Protected Methods

        protected override void Row2Object(DataRow row)
        {
            this.Value = (decimal)row["Value"];
            this.YearMonth = (row["YearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["YearMonth"];
            this.IdCurrency = (int)row["IdCurrency"];
            this.CurrencyName = row["CurrencyName"].ToString();
            this.IdCostCenter = (int)row["IdCostCenter"];
            this.CostCenterCode = row["CostCenterCode"].ToString();
            this.CostCenterName = row["CostCenterName"].ToString();
        }

        protected override DataSet PostGetEntities(DataSet ds)
        {
            //Add columns in the grid
            DataColumn newCol = new DataColumn("Period", typeof(string));
            int oldColumnPosition = ds.Tables[0].Columns["YearMonth"].Ordinal;
            ds.Tables[0].Columns.Add(newCol);
            //Hard-coded the ordinal position in order to display the "No records to display" text correctly
            newCol.SetOrdinal(2);
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                //Get the YearMonth value
                int yearMonth = (row["YearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["YearMonth"];
                //Set the Year and Month columns
                if (yearMonth == ApplicationConstants.INT_NULL_VALUE)
                    row["Period"] = DBNull.Value;
                else
                    row["Period"] = DateTimeUtils.GetDateFromYearMonth(yearMonth);

            }
            return ds;
        }

        protected override void OnPreSave()
        {
            if (this._YearMonth == ApplicationConstants.INT_YEAR_MONTH_NOT_VALID)
                throw new IndException(ApplicationMessages.EXCEPTION_VALUE_OF_YEARMONTH_NOT_VALID);
        }
        #endregion Protected Methods
    }
}
