using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.Entities;
using Inergy.Indev3.DataAccess;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Reflection;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Transactions;
using System.EnterpriseServices;

namespace Inergy.Indev3.BusinessLogic
{
    public abstract class GenericEntity : IGenericEntity
    {
        #region Members
        private EntityState _State = EntityState.Unset;
        public EntityState State
        {
            get { return _State; }
        }

        private int _Id = ApplicationConstants.INT_NULL_VALUE;
        [GridColumnProperty(false)]
        [IsInLogicalKey()]
        public int Id
        {
            get { return _Id; }
            set
            {
                _Id = value;
                SetModified();
            }
        }
        /// <summary>
        /// The connection manager of this DBGenericEntity. It will be held in the session and passed from layer to layer to the 
        /// data access layer. Only one connection manager object will be allowed per session.
        /// </summary>
        protected object CurrentConnectionManager;

        private DBGenericEntity dbEntity = null;
        #endregion Members

        #region Constructors
        public GenericEntity(object connectionManager)
        {
            _Id = ApplicationConstants.INT_NULL_VALUE;
            CurrentConnectionManager = connectionManager;
        }

        public GenericEntity(DataRow row, object connectionManager)
        {
            CurrentConnectionManager = connectionManager;
            Row2Object(row);
        }
        #endregion Constructors

        #region Public Methods

        public void SetNew()
        {
            this._State = EntityState.New;
        }
        public void SetModified()
        {
            this._State = EntityState.Modified;
        }
        public void SetDeleted()
        {
            this._State = EntityState.Deleted;
        }

        public void SetEntity(DBGenericEntity dbEntity)
        {
            this.dbEntity = dbEntity;
        }
        public DBGenericEntity GetEntity()
        {
            return dbEntity;
        }

        /// <summary>
        /// Saves the entity using no transactions
        /// </summary>
        /// <returns></returns>
        public int Save()
        {
            return Save(true);
        }

        /// <summary>
        /// Save the entity
        /// </summary>
        /// <param name="useTransaction">Specify if transactions should be used</param>
        /// <returns></returns>
        public int Save(bool useTransaction)
        {
            try
            {
                //If the coonection is already enlisted in a transaction use parent transaction
                if (IsInTransaction())
                    useTransaction = false;

                if (useTransaction)
                    BeginTransaction();

                int newId = ApplicationConstants.INT_NULL_VALUE;
                OnPreSave();
                if (!ValidateOperation())
                    throw new NotImplementedException(ApplicationMessages.EXCEPTION_IMPLEMENT_SETENTITY);


                if (State == EntityState.Deleted)
                {
                    DeleteChildren();
                    dbEntity.DeleteObject(this);
                }
                if (State == EntityState.New)
                {
                    newId = dbEntity.InsertObject(this);
                    SaveChildren();
                }
                if (State == EntityState.Modified)
                {
                    dbEntity.UpdateObject(this);
                    SaveChildren();
                }
                OnPostSave();

                if (useTransaction)
                    CommitTransaction();

                return newId;
            }
            catch (Exception exc)
            {
                if (useTransaction)
                    RollbackTransaction();

                throw new IndException(exc);
            }

        }

        public void Save(List<IGenericEntity> entities)
        {
            if ((entities == null) || (entities.Count == 0))
                return;

            ConnectionManager conManager = CurrentConnectionManager as ConnectionManager;
            if (conManager == null)
                throw new IndException(ApplicationMessages.EXCEPTION_CONNECTION_MANAGER_NULL);

            try
            {
                BeginTransaction();

                foreach (IGenericEntity entity in entities)
                {
                    entity.Save(false);
                }

                CommitTransaction();
            }
            catch (Exception exc)
            {
                RollbackTransaction();
                throw new IndException(exc);
            }

        }

        /// <summary>
        /// Creates a column used for passing parameters between View and Add/Edit window
        /// </summary>
        /// <param name="tbl"></param>
        public void CreateLogicalKeyColumn(DataTable tbl)
        {
            try
            {
                //Get the entity properties collection
                string logicalKeyExpression = "";
                PropertyInfo[] entityProperties = this.GetType().GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.FlattenHierarchy);
                object[] logicalKeyAttributes;
                foreach (PropertyInfo entityProperty in entityProperties)
                {
                    //Find out if the property has the IsInLogicalKeyAttribute attribute
                    logicalKeyAttributes = entityProperty.GetCustomAttributes(typeof(IsInLogicalKeyAttribute), true);
                    if (logicalKeyAttributes.Length == 1)
                    {
                        //See if the column has a diffrent name
                        object[] gridColumnPropertyAttributes;
                        gridColumnPropertyAttributes = entityProperty.GetCustomAttributes(typeof(GridColumnPropertyAttribute), true);
                        string gridColumnName = entityProperty.Name;
                        if (gridColumnPropertyAttributes.Length != 0)
                        {
                            string headerName = ((GridColumnPropertyAttribute)gridColumnPropertyAttributes[0]).ColumnHeaderName;
                            if (!String.IsNullOrEmpty(headerName))
                                gridColumnName = headerName;
                        }
                        if (tbl.Columns.Contains(gridColumnName))
                        {
                            //Append the column to the expression
                            logicalKeyExpression += "CONVERT('" + entityProperty.Name + "=','System.String') + CONVERT([" + gridColumnName + "],'System.String') + ','+";
                        }
                    }
                }
                //Add the new column and set it's expression.
                DataColumn colLogicalKey = new DataColumn("LogicalKey", typeof(string));
                if (!String.IsNullOrEmpty(logicalKeyExpression))
                {
                    colLogicalKey.Expression = logicalKeyExpression.Substring(0, logicalKeyExpression.Length - 6);
                    tbl.Columns.Add(colLogicalKey);
                }
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }

        #endregion Public Methods

        #region Transactions Related Methods
        /// <summary>
        /// Begins a new transaction with this entity
        /// </summary>
        protected void BeginTransaction()
        {
            ConnectionManager conManager = CurrentConnectionManager as ConnectionManager;
            if (conManager == null)
                throw new IndException(ApplicationMessages.EXCEPTION_CONNECTION_MANAGER_NULL);
            if (conManager.IsInTransaction)
                throw new IndException(ApplicationMessages.EXCEPTION_ANOTHER_TRANSACTION_ENLISTED);

            conManager.BeginTransaction();
        }
        protected void CommitTransaction()
        {
            ConnectionManager conManager = CurrentConnectionManager as ConnectionManager;
            if (conManager == null)
                throw new IndException(ApplicationMessages.EXCEPTION_CONNECTION_MANAGER_NULL);

            conManager.CommitTransaction();
        }
        protected void RollbackTransaction()
        {
            ConnectionManager conManager = CurrentConnectionManager as ConnectionManager;
            if (conManager == null)
                throw new IndException(ApplicationMessages.EXCEPTION_CONNECTION_MANAGER_NULL);
            conManager.RollbackTransaction();
        }

        protected bool IsInTransaction()
        {
            ConnectionManager conManager = CurrentConnectionManager as ConnectionManager;
            if (conManager == null)
                throw new IndException(ApplicationMessages.EXCEPTION_CONNECTION_MANAGER_NULL);
            return conManager.IsInTransaction;
        }
        #endregion Transactions Related Methods

        #region Virtual Methods

        public virtual DataRow SelectEntity()
        {
            try
            {
                DataSet objectDS = dbEntity.SelectObject(this);
                if (objectDS.Tables[0].Rows.Count == 0)
                    throw new IndException(ApplicationMessages.EXCEPTION_ENTITY_DOES_NOT_EXIST);
                return objectDS.Tables[0].Rows[0];
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public virtual DataRow SelectNew()
        {
            try
            {
                this.Id = -2;
                DataSet objectDS = dbEntity.SelectObject(this);
                if (objectDS.Tables[0].Rows.Count == 0)
                    throw new IndException(ApplicationMessages.EXCEPTION_ENTITY_DOES_NOT_EXIST);
                return objectDS.Tables[0].Rows[0];
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Retrives all records from the database for the current entity
        /// </summary>
        /// <returns></returns>
        public virtual DataSet GetAll()
        {
            try
            {
                IGenericEntity newEntity = EntityFactory.GetEntityInstance(this.GetType(), this.CurrentConnectionManager);
                return PostGetEntities(dbEntity.SelectObject(newEntity));
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        /// <summary>
        /// Retrives all records from the database for the current entity 
        /// </summary>
        /// <param name="useCurrentObject">True to take into account the entity values, false otherwise</param>
        /// <returns></returns>
        public virtual DataSet GetAll(bool useCurrentObject)
        {
            try
            {
                if (useCurrentObject)
                    return PostGetEntities(dbEntity.SelectObject(this));
                else
                    return GetAll();
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public virtual void SaveChildren()
        {
        }

        public virtual void DeleteChildren()
        {
        }
        
        public virtual void FillEditParameters(Dictionary<string, object> editParameters)
        {
            try
            {
                if (editParameters.ContainsKey("Id"))
                {
                    this._Id = int.Parse(editParameters["Id"].ToString());
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public virtual void SetSqlConnection(object connectionManager)
        {
            try
            {
                this.CurrentConnectionManager = connectionManager;
                dbEntity.SetConnectionManager(connectionManager);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        protected virtual void OnPreSave()
        {
        }

        protected virtual void OnPostSave()
        {
        }

        protected virtual DataSet PostGetEntities(DataSet ds)
        {
            return ds;
        }

        protected virtual void Row2Object(DataRow row)
        {
            throw new NotImplementedException();
        }

        #endregion Virtual Methods

        #region Private Methods
        private bool ValidateOperation()
        {
            if (dbEntity == null)
                return false;
            return true;
        }
        #endregion Private Methods
    }
}
