using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.DataAccess
{
    /// <summary>
    /// Used to communicate with business logic layer and send the connection manager object
    /// </summary>
    public class DBSessionConnectionHelper
    {
        /// <summary>
        /// Given a connection string, creates a connectionmanager object and sends it to the upper layers
        /// </summary>
        /// <param name="connectionString"></param>
        /// <returns></returns>
        public object GetNewConnectionManager(string connectionString, int commandTimeout)
        {
            ConnectionManager connectionManager;
            try
            {
                connectionManager = new ConnectionManager();
                connectionManager.CreateNewConnection(connectionString, commandTimeout);
            }
            catch (SqlException sqlExc)
            {
                throw new IndException(sqlExc);
            }
            return connectionManager;
        }

        public void DisposeConnection(object connManager)
        {
            ((ConnectionManager)connManager).DisposeConnection();
        }
    }
}
