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
    /// Represents the Country Entity
    /// </summary>
    public class Country : GenericEntity, ICountry
    {
        #region ICountry Members

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


        private string _Name;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Country Name")]
        [DesignerName("Country Name")]
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
        
        private int _IdCurrency;
        [PropertyValidation(true)]
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

        private int _IdRegion;
        [PropertyValidation(false)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(Region))]
        public int IdRegion
        {
            get
            {
                return _IdRegion;
            }
            set
            {
                _IdRegion = value;
            }
        }
        private string _RegionName;
        [PropertyValidation(false, 30)]
        [GridColumnProperty("Region Name")]
        public string RegionName
        {
            get
            {
                return _RegionName;
            }
            set
            {
                _RegionName = value;
            }
        }
        private string _Email;
        [PropertyValidation(false, 50)]
        [GridColumnProperty("Email")]
        public string Email
        {
            get { return _Email; }
            set { _Email = value; }
        }

        private int _Rank;
        [GridColumnProperty("Rank")]
        [ReferenceMapping(typeof(Country))]
        [PropertyValidation(true,8)]
        [SortBy()]
        public int Rank
        {
            get { return _Rank; }
            set { _Rank = value; }
        }

        private int _IdInergyLocation = ApplicationConstants.INT_NULL_VALUE;

        public int IdInergyLocation
        {
            get { return _IdInergyLocation; }
            set { _IdInergyLocation = value; }
        }
        #endregion
    
        #region Constructors
        public Country()
            : this(null)
        {
        }
        public Country(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBCountry(connectionManager));
            _IdCurrency = ApplicationConstants.INT_NULL_VALUE;
            _IdRegion = ApplicationConstants.INT_NULL_VALUE;
        }
        public Country(DataRow row, object connectionManager)
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
        public DataSet GetCountry_InergyLocation()
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet("SelectCountry_InergyLocation", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }
        #endregion Public Methods

        #region Protected Methods
        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this.Name = row["Name"].ToString();
            this.Code = row["Code"].ToString();
            this.IdCurrency = (int)row["IdCurrency"];
            this.CurrencyName = row["CurrencyName"].ToString();
            this.IdRegion = (row["IdRegion"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["IdRegion"];
            this.RegionName = row["RegionName"].ToString();
            this.Email = row["Email"].ToString();
            this.Rank = int.Parse(row["Rank"].ToString());
        }
        #endregion Protected Methods

    }
}
