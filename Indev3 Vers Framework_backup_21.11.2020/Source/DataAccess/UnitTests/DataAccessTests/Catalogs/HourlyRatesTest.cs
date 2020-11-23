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
    public class HourlyRateTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBHourlyRate(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertHourlyRateTest(IHourlyRate hourlyRate)
        {
            hourlyRate.Id = dbEntity.InsertObject(hourlyRate);
            return hourlyRate.Id;

        }
        public int UpdateHourlyRateTest(IHourlyRate hourlyRate)
        {
            int rowCount = dbEntity.UpdateObject(hourlyRate);
            return rowCount;
        }

        public DataSet SelectHourlyRateTest(IHourlyRate hourlyRate)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(hourlyRate) as DataSet;
            return tableVerify;

        }
        public int DeleteHourlyRateTest(IHourlyRate hourlyRate)
        {
            int rowCount = dbEntity.DeleteObject(hourlyRate);
            return rowCount;
        }
        [Test]
        public void VerifyHourlyRate()
        {
            Random random = new Random();
            
            IHourlyRate hourlyRate = BusinessObjectInitializer.CreateHourlyRate();

            hourlyRate.YearMonth = random.Next(2010,2079)*100+random.Next(1,12);
            hourlyRate.IdCurrency = random.Next(1,12);
            hourlyRate.IdCostCenter = random.Next(1,3);
            hourlyRate.Value = DATestUtils.DEFAULT_DECIMAL_VALUE;

            int newId = InsertHourlyRateTest(hourlyRate);
            Assert.AreEqual(newId, 0);

            int rowsAffected = UpdateHourlyRateTest(hourlyRate);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectHourlyRateTest(hourlyRate).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"InergyLocationName",
                                        "CostCenterCode",
                                        "CurrencyName",
                                        "Value",
                                        "YearMonth",
                                        "CostCenterName",
                                        "IdInergyLocation",
                                        "IdCostCenter",
                                        "IdCurrency"});

            DATestUtils.CheckTableStructure(resultTable, columns);

            int rowCount = DeleteHourlyRateTest(hourlyRate);
            Assert.AreEqual(1, rowCount);
        }
    }
}
