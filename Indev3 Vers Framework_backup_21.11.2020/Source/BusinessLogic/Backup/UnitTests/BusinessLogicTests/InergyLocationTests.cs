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
    public class InergyLocationTests
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
        public void GetAllInergyLocationsTest()
        {
            InergyLocation inergyLocation = new InergyLocation(connManager);
            DataSet ds = inergyLocation.GetAll();
            Assert.AreEqual(8, ds.Tables[0].Columns.Count);
        }

        [Test]
        public void InsertInergyLocationTest()
        {
            Random random = new Random();

            Region region = new Region(connManager);
            region.Name = "UTRegion";
            region.Code = "UTCode";
            region.Rank = random.Next(100000, 110000);
            region.SetNew();
            region.Id = region.Save();

            Currency currency = new Currency(connManager);
            currency.Code = "UTCode";
            currency.Name = "UTCurrency";
            currency.SetNew();
            currency.Id = currency.Save();

            Country country = new Country(connManager);
            country.Code = "UTCode";
            country.Name = "UTCountry";
            country.IdCurrency = currency.Id;
            country.IdRegion = region.Id;
            country.Rank = random.Next(100000, 110000);
            country.SetNew();
            country.Id = country.Save();

            InergyLocation inergyLocation = new InergyLocation(connManager);
            inergyLocation.IdCountry = country.Id;
            inergyLocation.Code = "UTCode";
            inergyLocation.Name = "UTName";
            inergyLocation.Rank = random.Next(100000, 110000);
            inergyLocation.SetNew();
            inergyLocation.Id = inergyLocation.Save();

            Assert.Greater(country.Id, 0);

            inergyLocation.SetDeleted();
            inergyLocation.Save();

            BLTestUtils.DeleteCountryGLAccounts(country.Id, connManager);
            country.SetDeleted();
            country.Save();

            currency.SetDeleted();
            currency.Save();

            region.SetDeleted();
            region.Save();
        }
    }
}
