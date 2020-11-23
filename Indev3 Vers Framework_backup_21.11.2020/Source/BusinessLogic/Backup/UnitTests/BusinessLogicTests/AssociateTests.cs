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
    public class AssociateTests
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
        public void GetAllAssociatesTest()
        {
            Associate associate = new Associate(connManager);
            DataSet ds = associate.GetAll();
            Assert.AreEqual(11, ds.Tables[0].Columns.Count);

            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("IdCountry",10);
            Associate a = new Associate();
            a.FillEditParameters(dic);
            ///a.IdCountry = 10 ???

        }

        [Test]
        public void InsertAssociateTest()
        {
            Random random = new Random();

            Region region = new Region(connManager);
            region.Code = "RUT";
            region.Name = "UTRegion";
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

            Associate associate = new Associate(connManager);
            associate.IdCountry = country.Id;
            associate.EmployeeNumber = "UTEmployeeNumber";
            associate.Name = "UTAssociateName";
            associate.InergyLogin = "UTInergyLogin";
            associate.PercentageFullTime = 100;
            associate.IsActive = true;
            associate.IsSubContractor = true;
            associate.SetNew();
            associate.Id = associate.Save();

            Assert.Greater(associate.Id, 0);

            associate.SetDeleted();
            associate.Save();

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
