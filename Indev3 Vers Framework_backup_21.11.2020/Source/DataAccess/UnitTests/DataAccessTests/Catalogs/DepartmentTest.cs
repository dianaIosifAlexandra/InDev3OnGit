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
    public class DepartmentTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBDepartment(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertDepartmentTest(IDepartment department)
        {
            department.Id = dbEntity.InsertObject(department);
            return department.Id;

        }
        public int UpdateDepartmentTest(IDepartment department)
        {
            int rowCount = dbEntity.UpdateObject(department);
            return rowCount;
        }

        public DataSet SelectDepartmentTest(IDepartment department)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(department) as DataSet;
            return tableVerify;

        }
        public int DeleteDepartmentTest(IDepartment department)
        {
            int rowCount = dbEntity.DeleteObject(department);
            return rowCount;
        }

        [Test]
        public void VerifyDepartment()
        {
            Random random = new Random();

            IDepartment department = BusinessObjectInitializer.CreateDepartment();
            
            department.Name = DATestUtils.GenerateString(30, true, false);
            department.IdFunction = random.Next(1, 5);
            department.Rank = random.Next(100000, 200000);

            int newId = InsertDepartmentTest(department);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateDepartmentTest(department);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectDepartmentTest(department).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Name",
                                          "FunctionName",
                                          "Rank",
                                          "Id", 
                                          "IdFunction",});

            DATestUtils.CheckTableStructure(resultTable, columns);

            int rowCount = DeleteDepartmentTest(department);
            Assert.AreEqual(1, rowCount);
        }
    }
}
