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
    public class CountryTest : BaseTest
    {      
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBCountry(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertCountryTest(ICountry country)
        {
            country.Id = dbEntity.InsertObject(country);
            return country.Id;

        }
        public int UpdateCountryTest(ICountry country)
        {
            int rowCount = dbEntity.UpdateObject(country);
            return rowCount;
        }

        public DataSet SelectCountryTest(ICountry country)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(country) as DataSet;
            return tableVerify;

        }
        public int DeleteCountryTest(ICountry country)
        {
            int rowCount = dbEntity.DeleteObject(country);
            return rowCount;
        }
        [Test]
        public void VerifyCountry()
        {
            ICountry country = BusinessObjectInitializer.CreateCountry();
            Random random = new Random();

            country.Code = DATestUtils.GenerateString(3, true, true);
            country.Name = DATestUtils.GenerateString(30, true, false);
            country.IdRegion = random.Next(1, 3);
            country.IdCurrency = random.Next(1, 12);
            country.Rank = random.Next(100000, 200000);

            int newId = InsertCountryTest(country);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateCountryTest(country);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectCountryTest(country).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Code",
                                        "Name",
                                        "RegionName",
                                        "CurrencyName",
                                        "Email",
                                        "Rank",
                                        "Id",
                                        "IdRegion",
                                        "IdCurrency"});
            DATestUtils.CheckTableStructure(resultTable, columns);

            try
            {
                //we delete the 7 accounts associated with a country
                GlAccountTest accountTest = new GlAccountTest();
                accountTest.Initialize();
                IGlAccount glAccount = BusinessObjectInitializer.CreateGLAccount();

                glAccount.IdCountry = newId;
                for (int i = 1; i <= 7; i++)
                {
                    glAccount.Id = i;
                    accountTest.DeleteGlAccountTest(glAccount);
                }
                 accountTest.CleanUp();
            }
            catch (Exception ex)
            {
                throw new Exception("Pre-Condition failed for delete operation. Gl/account operation meessage: " + ex.Message);
            }

            int rowCount = DeleteCountryTest(country);
            Assert.AreEqual(1, rowCount);
        }
    }
}
