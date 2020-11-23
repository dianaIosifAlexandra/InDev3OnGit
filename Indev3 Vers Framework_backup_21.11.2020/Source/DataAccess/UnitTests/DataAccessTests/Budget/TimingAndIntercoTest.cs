using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using NUnit.Framework;
using Inergy.Indev3.DataAccess;
using System.Data.SqlClient;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;

namespace Inergy.Indev3.DataAccessTests.Budget
{
    [TestFixture]
    public class DBTimingAndIntercoTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }
        public DataSet GetAffectedWPInterco(ITimingAndInterco timimgandInterco, DBGenericEntity dbGenericEntity)
        {
            DataSet ds = new DataSet();
            ds = dbGenericEntity.GetCustomDataSet("GetAffectedWPInterco", timimgandInterco) as DataSet;
            return ds;
        }
        public DataSet GetAffectedWPTiming(ITimingAndInterco timimgandInterco, DBGenericEntity dbGenericEntity)
        {
            DataSet ds = new DataSet();
            ds = dbGenericEntity.GetCustomDataSet("GetAffectedWPTiming", timimgandInterco) as DataSet;
            return ds;
        }

        [Test]
        [Category("COMPLEX")]
        public void VerifyTimingAndInterco()
        {
            ITimingAndInterco timingAndInterco = BusinessObjectInitializer.CreateTimingAndInterco();
            DBTimingAndInterco dbTimingAndInterco = new DBTimingAndInterco(connManager);

            timingAndInterco.IdProject = DATestUtils.DEFAULT_ENTITY_ID;
            timingAndInterco.IdPhase = DATestUtils.DEFAULT_ENTITY_ID;
            timingAndInterco.IdWP = DATestUtils.DEFAULT_ENTITY_ID;
            timingAndInterco.StartYearMonth = DATestUtils.DEFAULT_YEAR_MONTH;
            timingAndInterco.EndYearMonth = DATestUtils.DEFAULT_YEAR_MONTH;

            DataSet datasetGetWPPeriod  = GetAffectedWPTiming(timingAndInterco, dbTimingAndInterco);
            //Verifies that the dataset is not null
            Assert.IsNotNull(datasetGetWPPeriod, "The table returned should not be null");
            //Verifies that the dataset returns the correct columns
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[0], 0, "IdProject");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[0], 1, "IdPhase");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[0], 2, "PhaseCode");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[0], 3, "PhaseName");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[0], 4, "IdWP");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[0], 5, "WPCode");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[0], 6, "StartYearMonth");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[0], 7, "EndYearMonth");

            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 0, "IdProject");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 1, "IdPhase");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 2, "PhaseCode");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 3, "IdWP");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 4, "WPCode");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 5, "WPName");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 6, "StartYearMonth");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 7, "EndYearMonth");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 8, "LastUserUpdate");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 9, "LastUpdate");
            DATestUtils.CheckColumn(datasetGetWPPeriod.Tables[1], 10, "HasBudget");


            DataSet datasetGetWPIntercoCountries = GetAffectedWPInterco(timingAndInterco, dbTimingAndInterco);

            //Verifies that the dataset is not null
            Assert.IsNotNull(datasetGetWPIntercoCountries, "The table returned should not be null");
            //Verifies that the dataset returns the correct columns
            DATestUtils.CheckColumn(datasetGetWPIntercoCountries.Tables[1], 0, "IdProject");
            DATestUtils.CheckColumn(datasetGetWPIntercoCountries.Tables[1], 1, "IdPhase");
            DATestUtils.CheckColumn(datasetGetWPIntercoCountries.Tables[1], 2, "IdWP");
            DATestUtils.CheckColumn(datasetGetWPIntercoCountries.Tables[1], 3, "WPCode");
            DATestUtils.CheckColumn(datasetGetWPIntercoCountries.Tables[1], 4, "WPName");
            DATestUtils.CheckColumn(datasetGetWPIntercoCountries.Tables[1], 5, "PhaseCode");
            DATestUtils.CheckColumn(datasetGetWPIntercoCountries.Tables[1], 6, "HasBudget");
        }
    }
}
