using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.UserSettings;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.DataAccess.UserSettings;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Common
{
    /// <summary>
    /// used for wrapping user settings informations
    /// </summary>
    public class UserSettings: GenericEntity, IUserSettings
    {
        #region IUserSettings Members
        private int _AssociateId;
        public int AssociateId
        {
            get
            {
                return _AssociateId;
            }
            set
            {
                _AssociateId = value;
            }
        }

        private AmountScaleOption _AmountScaleOption;

        public AmountScaleOption AmountScaleOption
        {
            get
            {
                return _AmountScaleOption;
            }
            set
            {
                _AmountScaleOption = value;
            }
        }
        private int _NumberOfRecordsPerPage;
        public int NumberOfRecordsPerPage
        {
            get
            {
                return _NumberOfRecordsPerPage;
            }
            set
            {
                _NumberOfRecordsPerPage = value;
            }
        }

        private CurrencyRepresentationMode _CurrencyRepresentation;

        public CurrencyRepresentationMode CurrencyRepresentation
        {
            get
            {
                return _CurrencyRepresentation;
            }
            set
            {
                _CurrencyRepresentation = value;
            }
        }
        private DBUserSettings DBUserSettings;
        #endregion

        #region Constructors
        public UserSettings() : base(null)
        {
        }
        public UserSettings(int associateId, object connectionManager)
            : base(connectionManager)
        {
            this._AssociateId = associateId;
            this._NumberOfRecordsPerPage = ApplicationConstants.DEFAULT_DATAGRID_PAGESIZE;
            this._AmountScaleOption = AmountScaleOption.Unit;
            this._CurrencyRepresentation = CurrencyRepresentationMode.CostCenter;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="associateId"></param>
        /// <param name="amountScaleOption"></param>
        /// <param name="numberOfRecordsPerPage"></param>
        /// <param name="currencyRepresentation"></param>
        public UserSettings(int associateId, AmountScaleOption amountScaleOption, int numberOfRecordsPerPage, CurrencyRepresentationMode currencyRepresentation, object connectionManager)
            : base(connectionManager)
        {
            this._AssociateId = associateId;
            this._AmountScaleOption = amountScaleOption;
            this._CurrencyRepresentation = currencyRepresentation;
            this._NumberOfRecordsPerPage = numberOfRecordsPerPage;
        }
        #endregion Constructors

        #region Public Methods
        public DataTable SelectUserSettings()
        {
            DataTable userSettingsTable = new DataTable();
            try
            {
                userSettingsTable = GetDBUserSettings().usrSelectUserSettings(this._AssociateId);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return userSettingsTable;
        }
        public bool InsertOrUpdateUserSettings()
        {
            bool result;
            try
            {
                result = GetDBUserSettings().usrInsertOrUpdateUserSettings(this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return result;
        }
        #endregion Public Methods

        #region Private Methods
        private DBUserSettings GetDBUserSettings()
        {
            if (DBUserSettings == null)
            {
                DBUserSettings = new DBUserSettings(this.CurrentConnectionManager);
            }
            return DBUserSettings;
        }
        #endregion Private Methods
    }
}
