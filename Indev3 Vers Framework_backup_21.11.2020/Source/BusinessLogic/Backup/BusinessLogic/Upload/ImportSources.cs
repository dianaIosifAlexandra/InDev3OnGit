using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.UserSettings;
using System.Data;
using System.Data.SqlClient;
using Inergy.Indev3.Entities.Upload;
using Inergy.Indev3.DataAccess.Upload;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic.Upload
{
    public class ImportSources : GenericEntity, IImportSources
    {
        #region Private fields
        private int _idImportSource;

        public int IdImportSource
        {
            get { return _idImportSource; }
            set { _idImportSource = value; }
        }

        private int _idApplicationType;
        public int IdApplicationType
        {
            get { return _idApplicationType; }
            set { _idApplicationType = value; }
        }

        private string _code;

        public string Code
        {
            get { return _code; }
            set { _code = value; }
        }

       
        private string _sourceName;
        public string SourceName
        {
            get { return _sourceName; }
            set { _sourceName = value; }
        }

        private string _idCodeName;

        public string IdCodeName
        {
            get { return _idCodeName; }
            set { _idCodeName = value; }
        }

        private int _idCurrentAssociate;
        public int IdCurrentAssociate
        {
            get { return _idCurrentAssociate; }
            set { _idCurrentAssociate = value; }
        }

        //private DBImportSources DBImportSources;
        #endregion

        #region Constructor
        public ImportSources(int IdImportSource, int IdApplicationType, string Code, string SourceName, int IdCurrentAssociate, object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBImportSources(this.CurrentConnectionManager));
            this._idImportSource = IdImportSource;
            this._idApplicationType = IdApplicationType;
            this._code = Code;
            this._sourceName = SourceName;
            this._idCurrentAssociate = IdCurrentAssociate;
        }

        public ImportSources(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBImportSources(connectionManager));
            this._idImportSource = ApplicationConstants.INT_NULL_VALUE;
            this._idApplicationType = ApplicationConstants.INT_NULL_VALUE;
            this._sourceName = string.Empty;
            this._code = string.Empty;
        }
        #endregion

        #region Methods

        public DataTable SelectApplicationTypes()
        {
            DataTable importSources = new DataTable();
            try 
            {
                importSources = this.GetEntity().GetCustomDataSet("SpSelectImportSource", this).Tables[0];
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return importSources;
        }
         

        public bool IsUserAllowedOnImportSource()
        {
            object result;
            result = this.GetEntity().ExecuteScalar("SpIsUserAllowedOnImportSource", this);

            return Convert.ToBoolean(result);            
        }
        #endregion
    }
}
