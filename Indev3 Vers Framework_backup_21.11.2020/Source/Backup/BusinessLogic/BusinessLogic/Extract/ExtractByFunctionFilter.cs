using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.Entities.Extract;
using Inergy.Indev3.DataAccess.Extract;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic.Extract
{
    /// <summary>
    /// Represents the Extract By Function Filter entity
    /// </summary>
    public class ExtractByFunctionFilter : GenericEntity, IExtractByFunctionFilter
    {
        #region IExtractByFunctionFilter Members

        private string _NameRegion;
        public string NameRegion
        {
            get
            {
                return _NameRegion;
            }
            set
            {
                _NameRegion = value;
            }
        }
        private string _NameCountry;
        public string NameCountry
        {
            get
            {
                return _NameCountry;
            }
            set
            {
                _NameCountry = value;
            }
        }        
        private string _NameInergyLocation;
        public string NameInergyLocation
        {
            get
            {
                return _NameInergyLocation;
            }
            set
            {
                _NameInergyLocation = value;
            }
        }
        private string _NameFunction;
        public string NameFunction
        {
            get
            {
                return _NameFunction;
            }
            set
            {
                _NameFunction = value;
            }
        }
        private string _NameDepartment;
        public string NameDepartment
        {
            get
            {
                return _NameDepartment;
            }
            set
            {
                _NameDepartment = value;
            }
        }

        private int _IdRegion;
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
        private int _IdInergyLocation;
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
        private int _IdFunction;
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
        private int _IdDepartment;
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
        private int _IdCurrencyAssociate;
        public int IdCurrencyAssociate
        {
            get
            {
                return _IdCurrencyAssociate;
            }
            set
            {
                _IdCurrencyAssociate = value;
            }
        }

        private int _Year;
        public int Year
        {
            get
            {
                return _Year;
            }
            set
            {
                _Year = value;
            }
        }
        private string _ActiveStatus;
        public string ActiveStatus
        {
            get
            {
                return _ActiveStatus;
            }
            set
            {
                _ActiveStatus = value;
            }
        }
        private string _CostTypeCategory;
        public string CostTypeCategory
        {
            get
            {
                return _CostTypeCategory;
            }
            set
            {
                _CostTypeCategory = value;
            }
        }
        #endregion

        #region Constructors
        public ExtractByFunctionFilter(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBExtractByFunctionFilter(connectionManager));
            _Year = ApplicationConstants.INT_NULL_VALUE;
            _IdRegion = ApplicationConstants.INT_NULL_VALUE;
            _IdCountry = ApplicationConstants.INT_NULL_VALUE;
            _IdInergyLocation = ApplicationConstants.INT_NULL_VALUE;
            _IdFunction = ApplicationConstants.INT_NULL_VALUE;
            _IdDepartment = ApplicationConstants.INT_NULL_VALUE;
            _IdCurrencyAssociate = ApplicationConstants.INT_NULL_VALUE;
            _ActiveStatus = String.Empty;
            _CostTypeCategory = String.Empty;
        }

        public ExtractByFunctionFilter(DataRow row, object connectionManager)
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

        #region Protected Methods
        protected override void Row2Object(DataRow row)
        {
            this.NameRegion = row["NameRegion"].ToString();
            this.NameCountry = row["NameCountry"].ToString();
            this.NameInergyLocation = row["NameInergyLocation"].ToString();
            this.NameFunction = row["NameFunction"].ToString();
            this.NameDepartment = row["NameDepartment"].ToString();
            this.IdRegion = (int)row["IdRegion"];
            this.IdCountry = (int)row["IdCountry"];
            this.IdInergyLocation = (int)row["IdInergyLocation"];
            this.IdFunction = (int)row["IdFunction"];
            this.IdDepartment = (int)row["IdDepartment"];
            this.IdCurrencyAssociate = (int)row["IdCurrencyAssociate"];
            this.Year = (int)row["Year"];
        }
        #endregion Protected Methods

        #region Public Methods
        public DataSet SelectProcedure(string spName)
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet(spName.ToString(), this);
                DSUtils.AddEmptyRecord(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }

        public DataSet GetData(int iSelectedSource)
        {
            try
            {
                switch (iSelectedSource)
                {
                    case (int)EExtractSourceFunction.actual:
                        return this.GetEntity().GetCustomDataSet("ExtractActualData", this);
                    case (int)EExtractSourceFunction.annual_budget:
                        return this.GetEntity().GetCustomDataSet("ExtractAnnualBudgetData", this);
                    case (int)EExtractSourceFunction.initial:
                        return this.GetEntity().GetCustomDataSet("ExtractInitialData", this);
                    case (int)EExtractSourceFunction.reforecast:
                        return this.GetEntity().GetCustomDataSet("ExtractReforcastData", this);
                    case (int)EExtractSourceFunction.revised:
                        return this.GetEntity().GetCustomDataSet("ExtractRevisedData", this);
                    default:
                        throw new IndException("Project switch exception");
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion Public Methods
    }
}
