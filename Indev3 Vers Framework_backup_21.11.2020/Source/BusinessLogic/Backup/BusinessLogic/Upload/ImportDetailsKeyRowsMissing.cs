using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.DataAccess.Upload;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Upload;


namespace Inergy.Indev3.BusinessLogic.Upload
{
    public class ImportDetailsKeyRowsMissing : GenericEntity, IImportDetailsKeyRowsMissing
    {
        #region Members
        private int _idImport;
        public int IdImport
        {
            get { return _idImport; }
            set { _idImport = value; }
        }


        #endregion

        #region Constructor
        public ImportDetailsKeyRowsMissing(int IdImport, object connectionManager)
            : base(connectionManager)
        {
            this._idImport = IdImport;
            SetEntity(new DBImportDetailsKeyRowsMissing(connectionManager));
        }


        public ImportDetailsKeyRowsMissing(object connectionManager)
            : base(connectionManager)
        {
            this._idImport = ApplicationConstants.INT_NULL_VALUE;
            SetEntity(new DBImportDetailsKeyRowsMissing(connectionManager));
        }

        #endregion

        public int InsertKeyRowsMissing()
        {
            int RowsInsertedCount;

            try
            {
                BeginTransaction();
                RowsInsertedCount = this.GetEntity().ExecuteCustomProcedureWithReturnValue("InsertImportDetailsKeyRowsMissing", this);
                CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }

            return RowsInsertedCount;
        }

        public DataTable SelectKeyRowsMissing()
        {
            DataTable dt = null;

            try
            {
                DataSet ds = this.GetEntity().GetCustomDataSet("SelectImportDetailsKeyRowsMissing", this);
                dt = ds.Tables[0];
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }

            return dt;
        }

    }
}
