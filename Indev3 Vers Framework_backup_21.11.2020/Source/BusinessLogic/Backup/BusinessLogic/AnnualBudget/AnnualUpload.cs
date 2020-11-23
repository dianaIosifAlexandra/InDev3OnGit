using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.DataAccess.AnnualBudget;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic.AnnualBudget
{
    public class AnnualUpload : GenericEntity,IAnnualUpload
    {
        #region Members
        int _idImport;

        public int IdImport
        {
            get { return _idImport; }
            set { _idImport = value; }
        }

        string _fileName;

        public string FileName
        {
            get { return _fileName; }
            set { _fileName = value; }
        }

        private int _idAssociate;

        public int IdAssociate
        {
            get { return _idAssociate; }
            set { _idAssociate = value; }
        }
        #endregion
        #region Constructor
        public AnnualUpload(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBAnnualUpload(connectionManager));
            _idImport = ApplicationConstants.INT_NULL_VALUE;
            _fileName = string.Empty;
            _idAssociate = ApplicationConstants.INT_NULL_VALUE;
        }
        #endregion
        #region Public Methods
        /// <summary>
        /// write in Annual Import table data from csv file
        /// </summary>
        /// <returns>id of the import</returns>
        public int WriteToAnnualImportTable()
        {
            int IdImport = ApplicationConstants.INT_NULL_VALUE;            
            try
            {
                this.BeginTransaction();
                IdImport = this.GetEntity().ExecuteCustomProcedureWithReturnValue("WriteToAnnualImportTable", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
            return IdImport;
        }
        /// <summary>
        /// insert records from annual import table into annual budget tables and annual logs table
        /// </summary>
        /// <returns>integer for success or failure</returns>
        public int InsertIntoAnnualTable()
        {
            int result = ApplicationConstants.INT_NULL_VALUE;           
            try
            {
                this.BeginTransaction();
                result = this.GetEntity().ExecuteCustomProcedureWithReturnValue("WriteToAnnualTable", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
            return result;
        }
        /// <summary>
        /// check annual import and annual logs table to see if file is already uploaded
        /// </summary>
        /// <returns>integer for success or failure</returns>
        public int CheckFileAlreadyUploaded()
        {
            int result = ApplicationConstants.INT_NULL_VALUE;
            try
            {
                result = this.GetEntity().ExecuteCustomProcedureWithReturnValue("CheckAnnualFileAlreadyUploaded", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return result;
        }
        #endregion Public Methods
    }
}
