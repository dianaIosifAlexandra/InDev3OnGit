using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the InergyLocation entity
    /// </summary>
    public class InergyLocation : GenericEntity, IInergyLocation
    {
        #region IInergyLocation Members

        private int _IdCountry;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(InergyCountry))]
        [DesignerName("Country")]
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
        private string _CountryName;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Country")]
        public string CountryName
        {
            get
            {
                return _CountryName;
            }
            set
            {
                _CountryName = value;
            }
        }
        private string _Name;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Name")]
        public string Name
        {
            get
            {
                return _Name;
            }
            set
            {
                _Name = value;
            }
        }
        private string _Code;
        [PropertyValidation(true, 3)]
        [GridColumnProperty("Code")]
        public string Code
        {
            get
            {
                return _Code;
            }
            set
            {
                _Code = value;
            }
        }

        private int _IdCurrency;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]        
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
        [GridColumnProperty(false)]
        public string CurrencyName
        {
            get { return _CurrencyName; }
            set { _CurrencyName = value; }
        }

        private int _Rank;
        [GridColumnProperty("Rank")]
        [ReferenceMapping(typeof(InergyLocation))]
        [PropertyValidation(true, 5)]
        [SortBy()]
        public int Rank
        {
            get { return _Rank; }
            set { _Rank = value; }
        }      

      #endregion

        #region Constructors
        public InergyLocation()
            : this(null)
        {

        }
        public InergyLocation(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBInergyLocation(connectionManager));
            _IdCountry = ApplicationConstants.INT_NULL_VALUE;
        }

        public InergyLocation(DataRow row, object connectionManager)
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
        public DataSet SelectInergyLocation_Country()
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet("SelectInergyLocation_Country", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }
        #endregion Public Methods

        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this.IdCountry = (int)row["IdCountry"];
            this.CountryName = row["CountryName"].ToString();
            this.Code = row["Code"].ToString();
            this.Name = row["Name"].ToString();
            this.CurrencyName = row["CurrencyName"].ToString();
            this.Rank = int.Parse(row["Rank"].ToString());
        }
    }
}
