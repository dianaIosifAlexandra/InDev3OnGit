using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NUnit.Framework;

using Inergy.Indev3.DataAccess;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;

namespace Inergy.Indev3.DataAccessTests.Budget
{
    [TestFixture]
    public class DBProjectFunctionTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();            
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public DataSet SelectProjectFunctionTest(IProjectFunction projectFunction, DBGenericEntity dbGenericEntity)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbGenericEntity.SelectObject(projectFunction) as DataSet;
            return tableVerify;

        }
        [Test]
        public void VerifyProjectFunction()
        {
            Random random = new Random();

            DBProjectFunction dbProjectFunctionEntity = new DBProjectFunction(connManager);
            IProjectFunction projectFunction = BusinessObjectInitializer.CreateProjectFunction();

            DataTable tableVerify = SelectProjectFunctionTest(projectFunction, dbProjectFunctionEntity).Tables[0];
            //Verifies that the table is not null
            Assert.IsNotNull(tableVerify, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerify, 0, "Id");
            DATestUtils.CheckColumn(tableVerify, 1, "Name");
        }
    }
}
