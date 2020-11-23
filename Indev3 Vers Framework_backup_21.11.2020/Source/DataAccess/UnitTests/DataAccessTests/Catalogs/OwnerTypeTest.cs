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
    public class OwnerTypeTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBOwnerType(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public DataSet SelectOwnerTypeTest(IOwnerType OwnerType)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(OwnerType) as DataSet;
            return tableVerify;
        }

        [Test]
        public void VerifyOwnerType()
        {
            Random random = new Random();

            IOwnerType ownerType = BusinessObjectInitializer.CreateOwnerType();
            DBGenericEntity dbOwnerTypeEntity = new DBOwnerType(connManager);

            ownerType.Name = DATestUtils.GenerateString(50, true, false);
            ownerType.Id = random.Next(1, 5);

            DataTable resultTable = SelectOwnerTypeTest(ownerType).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Id",
	                                    "Name"});
            DATestUtils.CheckTableStructure(resultTable, columns);
        }
    }
}
