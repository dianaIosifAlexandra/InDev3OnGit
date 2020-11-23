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
    public class GlAccountTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBGlAccount(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertGlAccountTest(IGlAccount glAccount)
        {
            glAccount.Id = dbEntity.InsertObject(glAccount);
            return glAccount.Id;

        }
        public int UpdateGlAccountTest(IGlAccount glAccount)
        {
            int rowCount = dbEntity.UpdateObject(glAccount);
            return rowCount;
        }

        public DataSet SelectGlAccountTest(IGlAccount glAccount)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(glAccount) as DataSet;
            return tableVerify;

        }
        public int DeleteGlAccountTest(IGlAccount glAccount)
        {
            int rowCount = dbEntity.DeleteObject(glAccount);
            return rowCount;
        }
        [Test]
        public void VerifyGlAccount()
        {
            IGlAccount glAccount =BusinessObjectInitializer.CreateGLAccount();        

            Random random = new Random();

            glAccount.Name = DATestUtils.GenerateString(30, true, false);
            glAccount.Account = DATestUtils.GenerateString(20, true, false);
            glAccount.IdCostType = random.Next(1, 6);
            glAccount.IdCountry = random.Next(1,3);

            int newId = InsertGlAccountTest(glAccount);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateGlAccountTest(glAccount);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectGlAccountTest(glAccount).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"CountryName",
                                        "G/L Account",
                                        "Name",
                                        "CostType",
                                        "Id",
                                        "IdCountry",
                                        "IdCostType"});

            DATestUtils.CheckTableStructure(resultTable, columns);

            int rowCount = DeleteGlAccountTest(glAccount);
            Assert.AreEqual(1, rowCount);
        }
    }
}
