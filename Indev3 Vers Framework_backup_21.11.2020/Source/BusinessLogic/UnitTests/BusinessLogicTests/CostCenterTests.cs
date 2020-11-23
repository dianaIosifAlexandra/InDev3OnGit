using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

using NUnit.Framework;

using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework;


namespace Inergy.Indev3.BusinessLogicTests
{
    [TestFixture]
    public class CostCenterTests
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
        public void GetAllCostCentersTest()
        {
            CostCenter costCenter = new CostCenter(connManager);
            DataSet ds = costCenter.GetAll();
            Assert.AreEqual(11, ds.Tables[0].Columns.Count);
        }

        [Test]
        public void InsertCostCenterTest()
        {
            Random random = new Random();
            CostCenter costCenter = new CostCenter(connManager);
            costCenter.IdInergyLocation = random.Next(1,2);
            costCenter.IdDepartment = random.Next(1,1);
            costCenter.IsActive = true;
            costCenter.Code = "UTCode " + Guid.NewGuid().ToString();
            costCenter.Name = "UTName " + Guid.NewGuid().ToString();
            costCenter.SetNew();
            costCenter.Id = costCenter.Save();

            Assert.Greater(costCenter.Id, 0);

            costCenter.SetDeleted();
            costCenter.Save();
        }
    }
}
