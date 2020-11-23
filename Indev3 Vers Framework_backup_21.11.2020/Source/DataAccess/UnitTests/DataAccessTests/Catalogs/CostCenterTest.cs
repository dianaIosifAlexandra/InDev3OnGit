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
    public class CostCenterTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBCostCenter(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertCostCenterTest(ICostCenter costCenter)
        {
            costCenter.Id = dbEntity.InsertObject(costCenter);
            return costCenter.Id;

        }
        public int UpdateCostCenterTest(ICostCenter costCenter)
        {
            int rowCount = dbEntity.UpdateObject(costCenter);
            return rowCount;
        }

        public DataSet SelectCostCenterTest(ICostCenter costCenter)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(costCenter) as DataSet;
            return tableVerify;

        }
        public int DeleteCostCenterTest(ICostCenter costCenter)
        {
            int rowCount = dbEntity.DeleteObject(costCenter);
            return rowCount;
        }
        [Test]
        public void VerifyCostCenter()
        {
            Random random = new Random();

            ICostCenter costCenter = BusinessObjectInitializer.CreateCostCenter();
            
            costCenter.Name = DATestUtils.GenerateString(50, true, false);
            costCenter.Code = DATestUtils.GenerateString(10, true, true);
            costCenter.IdDepartment = random.Next(1, 1);
            costCenter.IdInergyLocation = random.Next(1, 2);
            costCenter.IsActive = true;

            int newId = InsertCostCenterTest(costCenter);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateCostCenterTest(costCenter);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectCostCenterTest(costCenter).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"InergyLocation",
	                                    "Code",
	                                    "Name",
	                                    "IsActive",
	                                    "DepartmentName",
	                                    "FunctionName",
	                                    "Id",	
	                                    "IdInergyLocation",	
	                                    "IdDepartment",
	                                    "IdFunction"});
            DATestUtils.CheckTableStructure(resultTable, columns);

            int rowCount = DeleteCostCenterTest(costCenter);
            Assert.AreEqual(1, rowCount);
        }
    }
}