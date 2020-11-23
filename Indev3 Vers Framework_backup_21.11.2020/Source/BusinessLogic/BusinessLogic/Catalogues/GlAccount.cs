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
    /// Represents the GlAccount entity
    /// </summary>
    public class GlAccount : GenericEntity, IGlAccount
    {
        #region IGlAccount Members

        private int _IdCountry;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(InergyCountry))]
        [DesignerName("Country")]
        [IsInLogicalKey()]
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
        private int _IdCostType;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(CostIncomeType))]
        [DesignerName("Cost Type")]
        public int IdCostType
        {
            get
            {
                return _IdCostType;
            }
            set
            {
                _IdCostType = value;
            }
        }
        private string _CostType;
        [PropertyValidation(true, 50)]
        [GridColumnProperty("Cost Type")]
        public string CostType
        {
            get
            {
                return _CostType;
            }
            set
            {
                _CostType = value;
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
        private string _Account;
        [PropertyValidation(true, 20)]
        [GridColumnProperty("G/L Account")]
        [DesignerName("G/L Account")]
        [IsInLogicalKey()]
        public string Account
        {
            get
            {
                return _Account;
            }
            set
            {
                _Account = value;
            }
        }


        #endregion

        #region Constructors
        public GlAccount()
            : this(null)
        {
        }
        public GlAccount(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBGlAccount(connectionManager));
            _IdCountry = ApplicationConstants.INT_NULL_VALUE;
        }

        public GlAccount(DataRow row, object connectionManager)
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
        public override void FillEditParameters(Dictionary<string, object> editParameters)
        {
            try
            {
                base.FillEditParameters(editParameters);
                if (editParameters.ContainsKey("IdCountry"))
                {
                    this._IdCountry = int.Parse(editParameters["IdCountry"].ToString());
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion Public Methods

        #region Protected Methods
        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this.IdCountry = (int)row["IdCountry"];
            this.CountryName = row["CountryName"].ToString();
            this.Account = row["G/L Account"].ToString();
            this.Name = row["Name"].ToString();
            this.IdCostType = (int)row["IdCostType"];
            this.CostType = row["CostType"].ToString();
        }
        #endregion Protected Methods
    }
}