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
    public class OwnerTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBOwner(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        
        public int InsertOwnerTest(IOwner owner)
        {
            owner.Id = dbEntity.InsertObject(owner);
            return owner.Id;

        }
        public int UpdateOwnerTest(IOwner owner)
        {
            int rowCount = dbEntity.UpdateObject(owner);
            return rowCount;
        }

        public DataSet SelectOwnerTest(IOwner owner)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(owner) as DataSet;
            return tableVerify;

        }
        public int DeleteOwnerTest(IOwner owner)
        {
            int rowCount = dbEntity.DeleteObject(owner);
            return rowCount;
        }
        [Test]
        public void VerifyOwner()
        {
            Random random = new Random();

            IOwner owner = BusinessObjectInitializer.CreateOwner();
            
            owner.Name = DATestUtils.GenerateString(30, true, false);
            owner.Code = DATestUtils.GenerateString(3, true, true);
            owner.IdOwnerType = random.Next(1,5);
            owner.Rank = random.Next(100000, 200000);

            int newId = InsertOwnerTest(owner);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateOwnerTest(owner);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectOwnerTest(owner).Tables[0];

                        //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Code",
                                        "Name",
                                        "OwnerType",
                                        "Rank",
                                        "Id",
                                        "IdOwnerType"});

            DATestUtils.CheckTableStructure(resultTable, columns);
 
            int rowCount = DeleteOwnerTest(owner);
            Assert.AreEqual(1, rowCount);
        }
    }
}
