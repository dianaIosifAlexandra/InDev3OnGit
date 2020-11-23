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
    public class CostIncomeTypeTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBCostIncomeType(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public DataSet SelectCostIncomeTypeTest(ICostIncomeType costIncomeType)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(costIncomeType) as DataSet;
            return tableVerify;

        }
        [Test]
        public void VerifyCostIncomeType()
        {
            Random random = new Random();

            ICostIncomeType costIncomeType = BusinessObjectInitializer.CreateCostIncomeType();

            costIncomeType.Name = DATestUtils.GenerateString(30, true, false);
            costIncomeType.Id = random.Next(1, 10);

            DataTable resultTable = SelectCostIncomeTypeTest(costIncomeType).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Id", 
                                          "Name",
                                          "DefaultAccount"});

            DATestUtils.CheckTableStructure(resultTable, columns);
        }
    }
}
