using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.DataAccess.AnnualBudget;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic.AnnualBudget
{
    public class AnnualImports : GenericEntity,IAnnualImports
    {
        #region Members
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

        private string _message;

        public string Message
        {
            get { return _message; }
            set { _message = value; }
        }

        private int _idAssociate;

        public int IdAssociate
        {
            get { return _idAssociate; }
            set { _idAssociate = value; }
        }

        #endregion
        #region Constructor
         public AnnualImports(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBAnnualImports(connectionManager));
        }
        #endregion
        #region Methods
         /// <summary>
        /// write red semaphore logs to database
        /// </summary>
        public void UploadErrorsToLogTables()
        {            
            try
            {
                this.BeginTransaction();
                this.GetEntity().ExecuteCustomProcedure("AnnualUploadErrorsToLogTables", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        public void ProcessErrorsToLogTables()
        {
            try
            {
                this.BeginTransaction();
                this.GetEntity().ExecuteCustomProcedure("AnnualProcessErrorsToLogTables", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }
        #endregion
    }
}
