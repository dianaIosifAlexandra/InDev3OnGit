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
    public class InergyLocationTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBInergyLocation(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertInergyLocationTest(IInergyLocation inergyLocation)
        {
            inergyLocation.Id = dbEntity.InsertObject(inergyLocation);
            return inergyLocation.Id;

        }
        public int UpdateInergyLocationTest(IInergyLocation inergyLocation)
        {
            int rowCount = dbEntity.UpdateObject(inergyLocation);
            return rowCount;
        }

        public DataSet SelectInergyLocationTest(IInergyLocation inergyLocation)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(inergyLocation) as DataSet;
            return tableVerify;

        }
        public int DeleteInergyLocationTest(IInergyLocation inergyLocation)
        {
            int rowCount = dbEntity.DeleteObject(inergyLocation);
            return rowCount;
        }
        [Test]
        public void VerifyInergyLocation()
        {
            Random random = new Random();

            IInergyLocation inergyLocation = BusinessObjectInitializer.CreateInergyLocation();
            
            inergyLocation.Name = DATestUtils.GenerateString(30, true, false);
            inergyLocation.Code = DATestUtils.GenerateString(3, true, true);
            inergyLocation.IdCountry = random.Next(1,3);
            inergyLocation.Rank = random.Next(100000, 200000);

            int newId = InsertInergyLocationTest(inergyLocation);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateInergyLocationTest(inergyLocation);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectInergyLocationTest(inergyLocation).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Code",
                                        "Name",
                                        "CountryName",
                                        "Rank",
                                        "CurrencyName",
                                        "Id",
                                        "IdCountry",
                                        "IdCurrency"});
            DATestUtils.CheckTableStructure(resultTable, columns);

            int rowCount = DeleteInergyLocationTest(inergyLocation);
            Assert.AreEqual(1, rowCount);
        }
    }
}
