using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Upload;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.DataAccess.Upload;
using System.Data;

namespace Inergy.Indev3.BusinessLogic.Upload
{
    /// <summary>
    /// class for imports
    /// </summary>
    public class Imports : GenericEntity, IImports
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

        private string _sourceCode;

        public string SourceCode
        {
            get { return _sourceCode; }
            set { _sourceCode = value; }
        }

        private int _idSource;

        public int IdSource
        {
            get { return _idSource; }
            set { _idSource = value; }
        }

        private string _message;

        public string Message
        {
            get { return _message; }
            set { _message = value; }
        }

        private int _idRow;

        public int IdRow
        {
            get { return _idRow; }
            set { _idRow = value; }
        }

        #endregion

        #region Constructor
        public Imports(int idImport, DateTime importDate, string fileName, int idAssociate, string sourceCode,int IdSource, object connectionManager)
            : base(connectionManager)
        {
            this._idImport = idImport;
            this._importDate = importDate;
            this._fileName = fileName;
            this._idAssociate = idAssociate;
            this._sourceCode = sourceCode;
            this._idSource = IdSource;

            SetEntity(new DBImports(connectionManager));
        }

        public Imports(object connectionManager)
            : base(connectionManager)
        {
            this._idImport = ApplicationConstants.INT_NULL_VALUE;
            this._importDate = DateTime.MinValue;
            this._fileName = string.Empty;
            this._idAssociate = ApplicationConstants.INT_NULL_VALUE;
            this._sourceCode = string.Empty;
            this._idSource = ApplicationConstants.INT_NULL_VALUE;

            SetEntity(new DBImports(connectionManager));
        }

        #endregion

        #region Methods

        public int InsertToImportsTable(string fileName, int IDAssociate)
        {
            int importID;

            try
            {
                this.BeginTransaction();
                this.FileName = fileName;
                this.IdAssociate = IDAssociate;               
                importID = this.GetEntity().ExecuteCustomProcedureWithReturnValue("InsertToImportsTable", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
            return importID;
        }

        public int InsertToActualTable(string fileName, int IDAssociate, int IDImport)
        {
            int result = ApplicationConstants.INT_NULL_VALUE;
           
            try
            {
                this.BeginTransaction();
                this.FileName = fileName;
                this.IdAssociate = IDAssociate;               
                this.IdImport = IDImport;
                result = this.GetEntity().ExecuteCustomProcedureWithReturnValue("InsertToActualTable", this);
                this.CommitTransaction();
            }
            catch (IndException ex)
            {
                RollbackTransaction();
                throw ex;
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
            return result;
        }

        public void InsertToLogTable(string fileName, int IdAssociate, int IdImport)
        {
            try
            {
                this.FileName = fileName;
                this.IdAssociate = IdAssociate;
                this.IdImport = IdImport;
                this.GetEntity().ExecuteCustomProcedure("InsertToLogTable", this);
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        public int CheckFileAlreadyUploaded(string fileName)
        {
            try
            {
                int result = ApplicationConstants.INT_NULL_VALUE;
                this.FileName = fileName;
                result = this.GetEntity().ExecuteCustomProcedureWithReturnValue("CheckFileAlreadyUploaded", this);
                return result;
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }
        /// <summary>
        /// write red semaphore logs to database
        /// </summary>
        public void UploadErrorsToLogTables()
        {            
            try
            {
                this.BeginTransaction();
                this.GetEntity().ExecuteCustomProcedure("UploadErrorsToLogTables", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        public void ProcessErrorToLogTable()
        {
            try
            {
                this.BeginTransaction();
                this.GetEntity().ExecuteCustomProcedure("ProcessErrorToLogTable", this);
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        public void WriteKeyrowsMissingToLogTable(DataTable dtKeyrowsMissing)
        {
            try
            {
                this.BeginTransaction();
                foreach (DataRow dr in dtKeyrowsMissing.Rows)
                {
                    this._idRow = (int)dr["IdRow"];
                    this.GetEntity().ExecuteCustomProcedure("WriteKeyrowsMissingToLogTable", this);
                }
                this.CommitTransaction();
            }
            catch (Exception ex)
            {
                RollbackTransaction();
                throw new IndException(ex);
            }
        }

        public DataSet SelectNonExistingAssociateNumbers(int IdImport)
        {
            DataSet ds;
            this.IdImport = IdImport;
            ds = this.GetEntity().GetCustomDataSet("GetNonExistingAssociateNumbers", this);
            return ds;
        }

        public int CheckChronologicalImports(string fileName)
        {
            int result;
            this.FileName = fileName;
            result = (int)this.GetEntity().ExecuteCustomProcedure("CheckFileImportChronologicalOrder", this);
            return result;
        }

        public void ChronologicalErrorToDB()
        {
            try
            {
                this.BeginTransaction();
                this.GetEntity().ExecuteCustomProcedure("ChronologicalErrorsToLogTables", this);
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
