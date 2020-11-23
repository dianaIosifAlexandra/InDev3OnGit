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
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// Represents the Project Core Team entity
    /// </summary>
    public class CostCenterFilter : GenericEntity, ICostCenterFilter
    {
        #region ICostCenterFilter Members

        private string _NameCostCenter;
        public string NameCostCenter
        {
            get
            {
                return _NameCostCenter;
            }
            set
            {
                _NameCostCenter = value;
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
        #endregion

        #region Constructors
        public CostCenterFilter(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBCostCenterFilter(connectionManager));
            _IdCostCenter = ApplicationConstants.INT_NULL_VALUE;
            _IdFunction = ApplicationConstants.INT_NULL_VALUE;
            _IdInergyLocation = ApplicationConstants.INT_NULL_VALUE;
            _IdCountry = ApplicationConstants.INT_NULL_VALUE;
        }

        public CostCenterFilter(DataRow row, object connectionManager)
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
            this.NameCostCenter = row["NameCostCenter"].ToString();
            this.NameFunction = row["NameFunction"].ToString();
            this.NameInergyLocation = row["NameInergyLocation"].ToString();
            this.IdCostCenter = (int)row["IdCostCenter"];
            this.IdFunction = (int)row["IdFunction"];
            this.IdInergyLocation = (int)row["IdInergyLocation"];
            this.IdCountry = (int)row["IdCountry"];
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
        #endregion Public Methods
    }
}
