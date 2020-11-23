using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Transactions;

namespace Inergy.Indev3.DataAccess
{
    public sealed class ConnectionManager
    {
        private String InnerConnectionString;
        private SqlConnection InnerSQLConnection;
        private SqlTransaction CurrentTransaction = null;
        private int CommandTimeout;

        /// <summary>
        /// Specify if the current sql connection is in transaction
        /// </summary>
        public bool IsInTransaction
        {
            get
            {
                return (CurrentTransaction == null) ? false : true;
            }
        }

        #region Public Methods
        /// <summary>
        /// Executes the SqlCommand and returns a datatable with the result of the command
        /// </summary>
        /// <param name="command">the SqlCommand to be executed</param>
        /// <returns>a DataTable containing the result of the command</returns>
        public DataTable GetDataTable(SqlCommand command)
        {
            //The result DataTable
            DataTable resultDataTable = new DataTable();
            try
            {
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
                //Gets the connection for the select command
                command.Connection = GetConnection();
                command.CommandTimeout = CommandTimeout;
                sqlDataAdapter.SelectCommand = command;
                //Fills the result DataTable
                sqlDataAdapter.Fill(resultDataTable);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
            return resultDataTable;
        }

        /// <summary>
        /// Returns a DataSet as an object containing the data specified in the sqlCommand parameter.
        /// Closes the SqlConnection is closeConnection is true. The Connection property of the sqlCommand
        /// parameter is overwritten in this method with our SqlConnection.
        /// </summary>
        /// <param name="command">The command executed on the database</param>
        /// <returns>A DataSet as an object containing the data specified in the sqlCommand parameter</returns>
        public DataSet GetDataSet(SqlCommand command)
        {
            //The result DataSet
            DataSet resultDataSet = new DataSet();
            try
            {
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
                //Gets the connection for the select command
                command.Connection = GetConnection();
                command.CommandTimeout = CommandTimeout;
                if (CurrentTransaction != null)
                    command.Transaction = CurrentTransaction;
                sqlDataAdapter.SelectCommand = command;
                //Fills the result DataSet
                sqlDataAdapter.Fill(resultDataSet);
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
            return resultDataSet;
        }

        /// <summary>
        /// Executes a stored procedure (given by the command) and returns the number of affected rows
        /// </summary>
        /// <param name="command">The command executed on the database</param>
        /// <returns>the number of affected rows</returns>
        public int ExecuteStoredProcedure(SqlCommand command)
        {
            int noRowsAffected;
            try
            {
                //Gets the connection for the select command
                command.Connection = GetConnection();
                command.CommandTimeout = CommandTimeout;
                if (CurrentTransaction != null)
                    command.Transaction = CurrentTransaction;
                noRowsAffected = command.ExecuteNonQuery();
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
            return noRowsAffected;
        }
        /// <summary>
        /// Disposes of the sql connection
        /// </summary>
        public void DisposeConnection()
        {
            InnerSQLConnection.Close();
            InnerSQLConnection.Dispose();
        }

        /// <summary>
        /// Executes a stored procedure (given by the command) and returns the value
        /// on the first line in the first column
        /// </summary>
        /// <param name="command">The command executed on the database</param>
        /// <returns>the first value</returns>
        public object ExecuteScalar(SqlCommand command)
        {
            object result = null;
            try
            {
                //Gets the connection for the select command
                command.Connection = GetConnection();
                command.CommandTimeout = CommandTimeout;
                if (CurrentTransaction != null)
                    command.Transaction = CurrentTransaction;
                result = command.ExecuteScalar();
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
            return result;
        }

        public void ExecuteTextCommand(SqlCommand command)
        {
            try
            {
                //Gets the connection for the select command
                command.Connection = GetConnection();
                command.CommandTimeout = CommandTimeout;
                if (CurrentTransaction != null)
                    command.Transaction = CurrentTransaction;
                command.ExecuteNonQuery();
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
        }

        #region Transactions Related Methods

        /// <summary>
        /// Begins a transaction using the current connection manager. The timeout is taken from the connection manager
        /// </summary>
        public void BeginTransaction()
        {
            try
            {
                CurrentTransaction = GetConnection().BeginTransaction();
            }
            catch (Exception exc)
            {
                CurrentTransaction = null;
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Commits the current enlisted transaction
        /// </summary>
        public void CommitTransaction()
        {
            if (CurrentTransaction != null)
            {
                try
                {
                    CurrentTransaction.Commit();
                }
                catch (Exception exc)
                {
                    throw new IndException(exc);
                }
                finally
                {
                    CurrentTransaction = null;
                }
            }
            else
            {
                throw new IndException(ApplicationMessages.EXCEPTION_NO_TRANSACTION_AVAILABLE_COMMIT);
            }
        }

        /// <summary>
        /// Rolls back the current enlisted transaction
        /// </summary>
        public void RollbackTransaction()
        {
            
            if (CurrentTransaction != null)
            {
                try
                {
                    CurrentTransaction.Rollback();
                }
                catch (SqlException sexc)
                {
                    throw new IndException(sexc);
                }
                catch (Exception exc)
                {
                    throw new IndException(exc);
                }
                finally
                {
                    CurrentTransaction = null;
                }
            }
            else
            {
                throw new IndException(ApplicationMessages.EXCEPTION_NO_TRANSACTION_AVAILABLE_ROLLBACK);
            }
        }
        #endregion Transactions Related Methods

        #endregion Public Methods

        #region Internal Methods
        /// <summary>
        /// Creates the connection to the SQL Server and stores it in InnerSQLConnection member
        /// </summary>
        /// <param name="ConnectionString"></param>
        /// <param name="commandTimeout"></param>
        internal void CreateNewConnection(String ConnectionString, int commandTimeout)
        {
            try
            {
                InnerConnectionString = ConnectionString;
                InnerSQLConnection = GetConnection();
                CommandTimeout = commandTimeout;
            }
            catch (SqlException exc)
            {
                throw new IndException(exc);
            }
        }
        #endregion Internal Methods

        #region Private Methods
        /// <summary>
        /// Gets a singleton instance of SQLConnection
        /// </summary>
        /// <returns></returns>
        private SqlConnection GetConnection()
        {
            if (String.IsNullOrEmpty(InnerConnectionString))
                throw new IndException("ConnectionManager: Invalid Connection String");

            if (InnerSQLConnection == null)
                InnerSQLConnection = new SqlConnection(InnerConnectionString);

            switch (InnerSQLConnection.State)
            {
                case ConnectionState.Broken:
                    InnerSQLConnection.Close();
                    InnerSQLConnection.Open();
                    break;
                case ConnectionState.Closed:
                    InnerSQLConnection.Open();
                    break;
                case ConnectionState.Open:
                    break;
                default:
                    throw new NotImplementedException("ConnectionManager: Unknown state " + InnerSQLConnection.State);
            }

            return InnerSQLConnection;
        }

        #endregion Private Methods
    }
}
