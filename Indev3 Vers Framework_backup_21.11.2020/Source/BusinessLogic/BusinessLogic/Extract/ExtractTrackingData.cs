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
    public class ExtractTrackingData : GenericEntity, IExtractTrackingData
    {

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

        private int _IdProgram;
        public int IdProgram
        {
            get
            {
                return _IdProgram;
            }
            set
            {
                _IdProgram = value;
            }
        }

        private int _IdProject;
        public int IdProject
        {
            get
            {
                return _IdProject;
            }
            set
            {
                _IdProject = value;
            }
        }

        private int _IdRole;
        public int IdRole
        {
            get
            {
                return _IdRole;
            }
            set
            {
                _IdRole = value;
            }
        }

        public ExtractTrackingData(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBExtractTrackingData(connectionManager));
            _Year = ApplicationConstants.INT_NULL_VALUE;
            _IdProgram = ApplicationConstants.INT_NULL_VALUE;
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
            _IdRole = ApplicationConstants.INT_NULL_VALUE;
        }

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

        public DataSet GetData()
        {
            try
            {
                return this.GetEntity().GetCustomDataSet("ExtractTrackingData", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        #endregion Public Methods


    }
}
