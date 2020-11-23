using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NUnit.Framework;

using Inergy.Indev3.DataAccess;


namespace Inergy.Indev3.DataAccessTests
{
    [TestFixture]
    public class DBStoredProcedureTest
    {
        private object connManager;

        [SetUp]
        public void Initialize()
        {
            DBSessionConnectionHelper sessionConnectionHelper = new DBSessionConnectionHelper();
            connManager = sessionConnectionHelper.GetNewConnectionManager(DATestUtils.ConnString, DATestUtils.COMMAND_TIMEOUT);
        }

        [TearDown]
        public void CleanUp()
        {
            ((ConnectionManager)connManager).DisposeConnection();
        }

        [Test]
        public void AddParameterTest()
        {
            DBStoredProcedure storedProcedure = new DBStoredProcedure();
            DBParameter parameter = new DBParameter("@Param", DbType.String, ParameterDirection.Input, "cici");
            
            storedProcedure.AddParameter(parameter);
            
            Assert.AreEqual(1, storedProcedure.DBParameters.Count);
            Assert.AreEqual(true, storedProcedure.DBParameters.ContainsKey("@Param"));
            Assert.AreEqual(parameter, storedProcedure.DBParameters["@Param"]);
        }

        [Test]
        public void GetSqlCommandTest()
        {
            DBStoredProcedure storedProcedure = new DBStoredProcedure();
            storedProcedure.ProcedureName = "spUT";
            DBParameter parameterId = new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, 1);
            DBParameter parameterName = new DBParameter("@Name", DbType.String, ParameterDirection.Input, "stringVal");
            storedProcedure.AddParameter(parameterId);
            storedProcedure.AddParameter(parameterName);

            SqlCommand sqlCommand = storedProcedure.GetSqlCommand();
            
            Assert.AreEqual(storedProcedure.ProcedureName, sqlCommand.CommandText);
            Assert.AreEqual(2, sqlCommand.Parameters.Count);
            Assert.AreEqual(1, sqlCommand.Parameters[0].Value);
            Assert.AreEqual("stringVal", sqlCommand.Parameters[1].Value);
        }
    }
}
