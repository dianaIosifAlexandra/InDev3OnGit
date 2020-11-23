using System;
using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.BusinessLogic;

namespace Inergy.Indev3.BusinessLogicTests
{
    [TestFixture]
    public class RegionTests
    {
        private SessionConnectionHelper sessionConnectionHelper;

        private object connManager;

        [SetUp]
        public void Initialize()
        {
            sessionConnectionHelper = new SessionConnectionHelper();
            connManager = sessionConnectionHelper.GetNewConnectionManager(BLTestUtils.ConnString, BLTestUtils.COMMAND_TIMEOUT);
        }
        [TearDown]
        public void CloseUp()
        {
            sessionConnectionHelper.DisposeConnection(connManager);
        }


        [Test]
        public void GetAllRegionsTest()
        {
            Region region = new Region(connManager);
            DataSet ds = region.GetAll();
            Assert.AreEqual(4, ds.Tables[0].Columns.Count);
        }

        [Test]
        public void InsertRegionTest()
        {
            Random random = new Random();

            Region region = new Region(connManager);
            region.Name = "UTRegion";
            region.Code = "UTCode";
            region.Rank = random.Next(100000, 110000);
            region.SetNew();

            region.Id = region.Save();
            Assert.Greater(region.Id, 0);

            region.SetDeleted();
            region.Save();
        }
    }
}
