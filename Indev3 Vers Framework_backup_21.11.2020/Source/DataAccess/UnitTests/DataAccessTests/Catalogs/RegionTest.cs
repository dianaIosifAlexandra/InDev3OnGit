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
    public class RegionTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBRegion(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertRegionTest(IRegion region)
        {
            region.Id = dbEntity.InsertObject(region);
            return region.Id;

        }
        public int UpdateRegionTest(IRegion region)
        {
            int rowCount = dbEntity.UpdateObject(region);
            return rowCount;
        }

        public DataSet SelectRegionTest(IRegion region)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(region) as DataSet;
            return tableVerify;

        }
        public int DeleteRegionTest(IRegion region)
        {
            int rowCount = dbEntity.DeleteObject(region);
            return rowCount;
        }
        [Test]
        public void VerifyRegion()
        {
            IRegion region = BusinessObjectInitializer.CreateRegion();
            Random random = new Random();
           
            region.Name = DATestUtils.GenerateString(30, true, false);
            region.Code = DATestUtils.GenerateString(8, true, true);
            region.Rank = random.Next(100000, 200000);

            int newId = InsertRegionTest(region);
            Assert.Greater(newId, 0);

            int rowsUpdated = UpdateRegionTest(region);
            Assert.AreEqual(1, rowsUpdated);

            DataTable resultTable = SelectRegionTest(region).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Code", 
                                           "Name",
                                           "Rank",
                                           "Id"});

            DATestUtils.CheckTableStructure(resultTable, columns);

            int rowCount = DeleteRegionTest(region);
            Assert.AreEqual(1, rowCount);
        }
    }
}
