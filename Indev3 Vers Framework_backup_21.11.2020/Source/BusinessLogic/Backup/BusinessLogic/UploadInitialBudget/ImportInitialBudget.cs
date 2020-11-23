using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.InitialBudget;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.DataAccess.UploadInitialBudget;
using System.Data;

namespace Inergy.Indev3.BusinessLogic.UploadInitialBudget
{
    public class ImportInitialBudget: GenericEntity, IUploadInitialBudget
    {
        #region private fields
        private int _idImport;

        public int IdImport
        {
            get { return _idImport; }
            set { _idImport = value; }
        }

        private DateTime _importDate;

        public DateTime ImportDate
        {
            get { return _importDate; }
            set { _importDate = value; }
        }

        private string _fileName;

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
        public ImportInitialBudget(int idImport, DateTime importDate, string fileName, int idAssociate, object connectionManager)
            : base(connectionManager)
        {
            this._idImport = idImport;
            this._importDate = importDate;
            this._fileName = fileName;
            this._idAssociate = idAssociate;

            SetEntity(new DBImportInitialBudget(connectionManager));
        }

        public ImportInitialBudget(object connectionManager)
            : base(connectionManager)
        {
            this._idImport = ApplicationConstants.INT_NULL_VALUE;
            this._importDate = DateTime.MinValue;
            this._fileName = string.Empty;
            this._idAssociate = ApplicationConstants.INT_NULL_VALUE;

            SetEntity(new DBImportInitialBudget(connectionManager));
        }
        #endregion


        #region Methods
        /// <summary>
        /// write in Annual Import table data from csv file
        /// </summary>
        /// <returns>id of the import</returns>
        public int WriteToInitialBudgetImportTable(string fileName, int idAssociate)
        {
            int IdImport = ApplicationConstants.INT_NULL_VALUE;
            try
            {
                this.IdAssociate = idAssociate;
                this.FileName = fileName;

                this.BeginTransaction();
                IdImport = this.GetEntity().ExecuteCustomProcedureWithReturnValue("WriteToInitialBudgetImportTable", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
            return IdImport;
        }

        public int InsertToBudgetTable(int idImport)
        {
            int retVal = default(int);
            
            try
            {
                this.IdImport = idImport;
                this.BeginTransaction();
                retVal = this.GetEntity().ExecuteCustomProcedureWithReturnValue("InsertToBudgetTable", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }

            return retVal;
        }        
        #endregion

    }
}
