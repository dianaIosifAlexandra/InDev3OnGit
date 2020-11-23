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
    public class CurrencyTests
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
        public void GetAllCurrenciesTest()
        {
            Currency currency = new Currency(connManager);
            DataSet ds = currency.GetAll();
            Assert.AreEqual(3, ds.Tables[0].Columns.Count);
        }

        [Test]
        public void InsertCurrencyTest()
        {
            Currency currency = new Currency(connManager);
            currency.Code = "UTCode";
            currency.Name = "UTCurrency";
            currency.SetNew();

            currency.Id = currency.Save();
            Assert.Greater(currency.Id, 0);

            currency.SetDeleted();
            currency.Save();
        }
    }
}
