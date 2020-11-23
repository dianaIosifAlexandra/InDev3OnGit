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
    public class OwnerTypeTests
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
        public void GetAllOwnerTypesTest()
        {
            OwnerType ownerType = new OwnerType(connManager);
            DataSet ds = ownerType.GetAll();
            Assert.AreEqual(2, ds.Tables[0].Columns.Count);
        }
    }
}
