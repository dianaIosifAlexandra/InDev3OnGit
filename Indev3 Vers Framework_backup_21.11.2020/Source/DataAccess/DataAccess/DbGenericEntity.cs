using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.EnterpriseServices;
using System.Transactions;

namespace Inergy.Indev3.DataAccess
{
    /// <summary>
    /// Generic class used by the GenericEntity object to communicate with the database
    /// </summary>
    public abstract class DBGenericEntity
    {
        #region Members
        /// <summary>
        /// Dictionary containing strings as keys (InsertObject, UpdateObject etc.), and DBStoredProcedure objects as values
        /// </summary>
        protected Dictionary<string, DBStoredProcedure> storedProcedures = new Dictionary<string, DBStoredProcedure>();
        /// <summary>
        /// The connection manager of this DBGenericEntity. It will be held in the session and passed from layer to layer to the 
        /// data access layer. Only one connection manager object will be allowed per session.
        /// </summary>
        protected ConnectionManager CurrentConnectionManager;
        #endregion Members

        #region Constructors
        public DBGenericEntity(object connectionManager)
        {
            CurrentConnectionManager = (ConnectionManager)connectionManager;
        }
        #endregion Constructors

        #region Public Methods
        /// <summary>
        /// Generic method used to insert an IGenericEntity to the database
        /// </summary>
        /// <param name="ent">the entity to be inserted</param>
        /// <returns>the return value from the stored procedure</returns>
        public virtual int InsertObject(IGenericEntity ent)
        {
            //Clear the stored procedures dictionary
            storedProcedures.Clear();
            InitializeObject(ent);
            //If the insert stpred procedure does not exist, throw exception
            if (!storedProcedures.ContainsKey("InsertObject"))
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_IMPLEMENT_INSERTOBJECT);

            DBStoredProcedure insertSP = storedProcedures["InsertObject"];
            SqlCommand cmd = insertSP.GetSqlCommand();
            SqlParameter returnParameter = cmd.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
            returnParameter.Direction = ParameterDirection.ReturnValue;
            try
            {
                CurrentConnectionManager.ExecuteStoredProcedure(cmd);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
            return (int)cmd.Parameters["RETURN_VALUE"].Value;
        }
        public virtual int UpdateObject(IGenericEntity ent)
        {
            storedProcedures.Clear();
            InitializeObject(ent);
            if (!storedProcedures.ContainsKey("UpdateObject"))
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_IMPLEMENT_UPDATEOBJECT);

            DBStoredProcedure updateSP = storedProcedures["UpdateObject"];
            SqlCommand cmd = updateSP.GetSqlCommand();
            SqlParameter returnParameter = cmd.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
            returnParameter.Direction = ParameterDirection.ReturnValue;
            try
            {
                CurrentConnectionManager.ExecuteStoredProcedure(cmd);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
            return (int)cmd.Parameters["RETURN_VALUE"].Value;
        }

        public virtual int DeleteObject(IGenericEntity ent)
        {
            storedProcedures.Clear();
            InitializeObject(ent);
            if (!storedProcedures.ContainsKey("DeleteObject"))
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_IMPLEMENT_DELETEOBJECT);

            DBStoredProcedure deleteSP = storedProcedures["DeleteObject"];
            SqlCommand cmd = deleteSP.GetSqlCommand();
            //Some Delete procedures takes longtime to execute. For example catDeleteGlAccount
            SqlParameter returnParameter = cmd.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
            returnParameter.Direction = ParameterDirection.ReturnValue;
            try
            {
                CurrentConnectionManager.ExecuteStoredProcedure(cmd);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }

            return (int)cmd.Parameters["RETURN_VALUE"].Value;
        }
        public virtual DataSet SelectObject(IGenericEntity ent)
        {
            storedProcedures.Clear();
            InitializeObject(ent);

            if (!storedProcedures.ContainsKey("SelectObject"))
                throw new NotImplementedException(ApplicationMessages.EXCEPTION_IMPLEMENT_SELECTOBJECT);
            
            DBStoredProcedure selectSP = storedProcedures["SelectObject"];
            SqlCommand cmd = selectSP.GetSqlCommand();

            DataSet returnDS = null;
            try
            {
                returnDS = CurrentConnectionManager.GetDataSet(cmd);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }

            return returnDS;

        }

        public void AddStoredProcedure(string procedureName, DBStoredProcedure procedure)
        {
            storedProcedures.Add(procedureName, procedure);
        }

        /// <summary>
        /// xecutes a custom stored procedure and returns the number of rows affected
        /// </summary>
        /// <param name="procedureName"></param>
        /// <param name="ent"></param>
        /// <returns>the number of rows affected</returns>
        public int ExecuteCustomProcedure(string procedureName, IGenericEntity ent)
        {
            int rowsAffected;

            storedProcedures.Clear();
            InitializeObject(ent);

            if (!storedProcedures.ContainsKey(procedureName))
                throw new NotImplementedException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_IMPLEMENT, procedureName));

            DBStoredProcedure insertSP = storedProcedures[procedureName];
            SqlCommand cmd = insertSP.GetSqlCommand();

            try
            {
                rowsAffected = CurrentConnectionManager.ExecuteStoredProcedure(cmd);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
            
            return rowsAffected;
        }

        /// <summary>
        /// Executes a custom stored procedure and returns the SP return value
        /// </summary>
        /// <param name="procedureName"></param>
        /// <param name="ent"></param>
        /// <returns>the stored procedure returned value</returns>
        public int ExecuteCustomProcedureWithReturnValue(string procedureName, IGenericEntity ent)
        {
            storedProcedures.Clear();
            InitializeObject(ent);

            if (!storedProcedures.ContainsKey(procedureName))
                throw new NotImplementedException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_IMPLEMENT, procedureName));

            DBStoredProcedure insertSP = storedProcedures[procedureName];
            SqlCommand cmd = insertSP.GetSqlCommand();
            SqlParameter returnParameter = cmd.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
            returnParameter.Direction = ParameterDirection.ReturnValue;

            try
            {
                CurrentConnectionManager.ExecuteStoredProcedure(cmd);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }

            return (int)cmd.Parameters["RETURN_VALUE"].Value;
        }

        public object ExecuteScalar(string procedureName, IGenericEntity ent)
        {
            object result = null;

            storedProcedures.Clear();
            InitializeObject(ent);

            if (!storedProcedures.ContainsKey(procedureName))
                throw new NotImplementedException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_IMPLEMENT, procedureName));

            DBStoredProcedure insertSP = storedProcedures[procedureName];
            SqlCommand cmd = insertSP.GetSqlCommand();

            try
            {
                result = CurrentConnectionManager.ExecuteScalar(cmd);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }

            return result;
        }

        public DataSet GetCustomDataSet(string procedureName, IGenericEntity ent)
        {
            storedProcedures.Clear();
            InitializeObject(ent);

            if (!storedProcedures.ContainsKey(procedureName))
                throw new NotImplementedException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_IMPLEMENT, procedureName));
                
            DBStoredProcedure insertSP = storedProcedures[procedureName];
            SqlCommand cmd = insertSP.GetSqlCommand();

            DataSet returnDS = null;

            try
            {
                returnDS = CurrentConnectionManager.GetDataSet(cmd);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }

            return returnDS;
        }

        public virtual void SetConnectionManager(object connectionManager)
        {
            CurrentConnectionManager = (ConnectionManager)connectionManager;
        }
        #endregion  Public Methods

        #region Protected Methods
        /// <summary>
        /// Add stored procedures here
        /// </summary>
        protected virtual void InitializeObject(IGenericEntity ent)
        {
            throw new NotImplementedException(ApplicationMessages.EXCEPTION_IMPLEMENT_INITIALIZEOBJECT);
        }
        #endregion Protected Methods
    }
}
