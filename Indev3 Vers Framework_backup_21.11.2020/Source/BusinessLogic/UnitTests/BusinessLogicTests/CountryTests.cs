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
    public class CountryTests
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
        public void GetAllCountriesTest()
        {
            Country country = new Country(connManager);
            DataSet ds = country.GetAll();
            Assert.AreEqual(9, ds.Tables[0].Columns.Count);
        }

        [Test]
        public void InsertCountryTest()
        {
            Random random = new Random();
            Country country = new Country(connManager);
            country.Code = Guid.NewGuid().ToString().Substring(0, 3);
            country.Name = "UTCountry " + Guid.NewGuid().ToString();
            country.IdCurrency = random.Next(1,1);
            country.IdRegion = random.Next(1,3);
            country.Rank = random.Next(100000, 110000);
            country.SetNew();
            country.Id = country.Save();

            Assert.Greater(country.Id, 0);

            BLTestUtils.DeleteCountryGLAccounts(country.Id, connManager);

            country.SetDeleted();
            country.Save();
        }
    }
}
