using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.DataAccess.AnnualBudget;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic.AnnualBudget
{
    public class AnnualDownload : GenericEntity, IAnnualDownload
    {
        #region Members
        private int _idCountry;

        public int IdCountry
        {
            get { return _idCountry; }
            set { _idCountry = value; }
        }

        private int _idInergyLocation;

        public int IdInergyLocation
        {
            get { return _idInergyLocation; }
            set { _idInergyLocation = value; }
        }

        private int _year;

        public int Year
        {
            get { return _year; }
            set { _year = value; }
        }

        #endregion
        #region Constructor
        public AnnualDownload(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBAnnualDownload(connectionManager));
            _idCountry = ApplicationConstants.INT_NULL_VALUE;
            _idInergyLocation = ApplicationConstants.INT_NULL_VALUE;
            _year = ApplicationConstants.INT_NULL_VALUE;
        }

        #endregion

        #region Public Methods
        public DataSet ExtractFromDataSource()
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet("ExtractFromReforcastAndActualData", this);
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
