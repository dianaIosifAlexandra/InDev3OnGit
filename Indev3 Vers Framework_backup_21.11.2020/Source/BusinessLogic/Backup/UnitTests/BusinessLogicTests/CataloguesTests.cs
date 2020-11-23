using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

using NUnit.Framework;

using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.BusinessLogicTests
{
    [TestFixture]
    public class CataloguesTests
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
        public void FillEditParametersTest()
        {
            Associate associate = new Associate();
            Dictionary<string, object> editParameters = new Dictionary<string, object>();
            editParameters.Add("IdCountry", 5);
            associate.FillEditParameters(editParameters);
            Assert.AreEqual(5, associate.IdCountry);

            editParameters.Clear();
            GlAccount glAccount = new GlAccount(connManager);
            editParameters = new Dictionary<string, object>();
            editParameters.Add("IdCountry", 10);
            glAccount.FillEditParameters(editParameters);
            Assert.AreEqual(10, glAccount.IdCountry);

            editParameters.Clear();
            HourlyRate hourlyRate = new HourlyRate(connManager);
            editParameters = new Dictionary<string, object>();
            editParameters.Add("YearMonth", 1010);
            editParameters.Add("IdCostCenter", 2);
            hourlyRate.FillEditParameters(editParameters);
            Assert.AreEqual(1010, hourlyRate.YearMonth);
            Assert.AreEqual(2, hourlyRate.IdCostCenter);

            editParameters.Clear();
            WorkPackage workPackage = new WorkPackage(connManager);
            editParameters = new Dictionary<string, object>();
            editParameters.Add("IdPhase", 1);
            editParameters.Add("IdProject", 2);
            workPackage.FillEditParameters(editParameters);
            Assert.AreEqual(1, workPackage.IdPhase);
            Assert.AreEqual(2, workPackage.IdProject);
        }
    }
}
