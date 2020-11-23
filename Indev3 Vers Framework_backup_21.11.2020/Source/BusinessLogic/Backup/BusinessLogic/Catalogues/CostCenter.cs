using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the CostCenter entity
    /// </summary>
    public class CostCenter : GenericEntity, ICostCenter
    {
        #region ICostCenter Members

        private int _IdFunction;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(Function))]
        public int IdFunction
        {
            get
            {
                return _IdFunction;
            }
            set
            {
                _IdFunction = value;
            }
        }
        private string _FunctionName;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Function")]
        public string FunctionName
        {
            get
            {
                return _FunctionName;
            }
            set
            {
                _FunctionName = value;
            }
        }
        private int _IdDepartment;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(Department))]
        [DesignerName("Department")]
        public int IdDepartment
        {
            get
            {
                return _IdDepartment;
            }
            set
            {
                _IdDepartment = value;
            }
        }
        private string _DepartmentName;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Department")]
        public string DepartmentName
        {
            get
            {
                return _DepartmentName;
            }
            set
            {
                _DepartmentName = value;
            }
        }
        private int _IdInergyLocation = ApplicationConstants.INT_NULL_VALUE;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(InergyLocation))]
        [DesignerName("Inergy Location")]
        public int IdInergyLocation
        {
            get
            {
                return _IdInergyLocation;
            }
            set
            {
                _IdInergyLocation = value;
            }
        }
        private string _InergyLocation;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Inergy Location")]
        public string InergyLocation
        {
            get
            {
                return _InergyLocation;
            }
            set
            {
                _InergyLocation = value;
            }
        }
        private bool _IsActive;
        [PropertyValidation(true)]
        [GridColumnProperty("Active")]
        public bool IsActive
        {
            get
            {
                return _IsActive;
            }
            set
            {
                _IsActive = value;
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
        [PropertyValidation(true, 15)]
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


        #endregion

        #region Constructors
        public CostCenter()
            : this(null)
        {
        }
        public CostCenter(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBCostCenter(connectionManager));
            _IdFunction = ApplicationConstants.INT_NULL_VALUE;
            _IdDepartment = ApplicationConstants.INT_NULL_VALUE;
            _IsActive = true;
        }

        public CostCenter(DataRow row, object connectionManager)
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
        public Currency GetCostCenterCurrency()
        {
            try
            {
                DataSet ds = this.GetEntity().GetCustomDataSet("SelectCostCenterCurrency", this);
                //UNIT TEST THIS SO NO VALIDATION SHOULD BE DONE HERE
                Currency currency = new Currency(this.CurrentConnectionManager);

                currency.Id = (int)ds.Tables[0].Rows[0]["IdCurrency"];
                currency.Code = ds.Tables[0].Rows[0]["CurrencyCode"].ToString();
                currency.Name = ds.Tables[0].Rows[0]["CurrencyName"].ToString();

                return currency;
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
            this.IdFunction = (int)row["IdFunction"];
            this.FunctionName = row["FunctionName"].ToString();
            this.IdDepartment = (int)row["IdDepartment"];
            this.DepartmentName = row["DepartmentName"].ToString();
            this.IdInergyLocation = (int)row["IdInergyLocation"];
            this.InergyLocation = row["InergyLocation"].ToString();
            this.IsActive = (bool)row["IsActive"];
            this.Name = row["Name"].ToString();
            this.Code = row["Code"].ToString();
        }

        protected override DataSet PostGetEntities(DataSet ds)
        {
            DSUtils.ReplaceBooleanColumn("IsActive", ds, 0);
            return ds;
        }
        #endregion Protected Methods
    }
}
