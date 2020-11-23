using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.DataAccess;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic
{
    /// <summary>
    /// Provides a link between user interface and data access layers. This is needed to carry the ConnectionManager object from
    /// data access to session
    /// </summary>
    public class SessionConnectionHelper
    {
        private DBSessionConnectionHelper dbSessionConnectionHelper;

        public SessionConnectionHelper()
        {
            dbSessionConnectionHelper = new DBSessionConnectionHelper();
        }

        /// <summary>
        /// Given a connection string, returns a ConnectionManager object as an object containing a valid sql connection
        /// </summary>
        /// <param name="connectionString">the connections string</param>
        /// <returns>the connectionmanager object as an object</returns>
        public object GetNewConnectionManager(string connectionString, int commandTimeout)
        {
            object connectionManager;
            try
            {
                connectionManager = dbSessionConnectionHelper.GetNewConnectionManager(connectionString, commandTimeout);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }


            return connectionManager;
        }

        public void DisposeConnection(object connManager)
        {
            try
            {
                dbSessionConnectionHelper.DisposeConnection(connManager);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
    }
}
