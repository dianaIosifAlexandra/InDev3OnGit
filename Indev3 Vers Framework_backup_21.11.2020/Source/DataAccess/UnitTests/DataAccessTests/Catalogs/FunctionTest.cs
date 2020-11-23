using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NUnit.Framework;

using Inergy.Indev3.DataAccess;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.Catalogues;

namespace Inergy.Indev3.DataAccessTests.Catalogues
{
    [TestFixture]
    public class FunctionTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBFunction(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public DataSet SelectFunctionTest(IFunction Function)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(Function) as DataSet;
            return tableVerify;

        }
        [Test]
        public void VerifyFunction()
        {
            Random random = new Random();

            IFunction function = BusinessObjectInitializer.CreateFunction();
            
            function.Name = DATestUtils.GenerateString(30, true, false);
            function.Id = random.Next(1, 10);

            DataTable resultTable = SelectFunctionTest(function).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Id",
	                                    "Name"});
            DATestUtils.CheckTableStructure(resultTable, columns);
        }
    }
}
