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
    public class CurrencyTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBCurrency(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        
        public DataSet SelectCurrencyTest(ICurrency currency)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(currency) as DataSet;
            return tableVerify;

        }
        [Test]
        public void VerifyCurrency()
        {
            ICurrency currency = BusinessObjectInitializer.CreateCurrency();
 
            Random random = new Random();

            currency.Name = DATestUtils.GenerateString(30, true, false);
            //There are already currencies with id's from 1 to 12 in the database from the initialization script
            currency.Id = random.Next(1, 12);

            DataTable resultTable = SelectCurrencyTest(currency).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Id",
	                                    "Code",
	                                    "Name"});
            DATestUtils.CheckTableStructure(resultTable, columns);
        }
    }
}
