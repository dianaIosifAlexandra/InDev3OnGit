using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using NUnit.Framework;
using Inergy.Indev3.DataAccess;
using System.Data.SqlClient;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

using Inergy.Indev3.DataAccessTests;

namespace Inergy.Indev3.DataAccessTests.Catalogues
{
    [TestFixture]
    public class ExchangeRateTest : BaseTest
    {
        /// <summary>
        /// Declaration of variables region
        /// </summary>
            private SqlParameter IdCategory;
            private SqlParameter CurrencyFrom;
            private SqlParameter Year;
            private SqlParameter Month;
            private SqlParameter NewExchangeRate;

            private DATestUtils utils; 
            private double expectedReturnedConversionRate;
            private SqlCommand executeInsertOrUpdateExchangeRate;

        /// <summary>
        /// This constructor initializes all variables that all nUNIT tests for Exchange Rates will use
        /// </summary>
        public ExchangeRateTest()
        {
            utils = new DATestUtils();
            executeInsertOrUpdateExchangeRate = new SqlCommand();
            executeInsertOrUpdateExchangeRate.CommandType = CommandType.StoredProcedure;
            executeInsertOrUpdateExchangeRate.CommandText = "catInsertOrUpdateExchangeRate";
            
            IdCategory = new SqlParameter();
            CurrencyFrom = new SqlParameter();
            Year = new SqlParameter();
            Month = new SqlParameter();
            NewExchangeRate = new SqlParameter();
        }

        [SetUp]
        public override void Initialize()
        {
            InitializeCmdParameters();
            base.Initialize();
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        private void InitializeCmdParameters()
        {
            IdCategory.Value = utils.testConstantInitialized;
            IdCategory.ParameterName = "@IdCategory";
            IdCategory.DbType = DbType.Int32;

            CurrencyFrom.Value = "USD";
            CurrencyFrom.ParameterName = "@CurrencyFrom";
            CurrencyFrom.DbType = DbType.String;

            Year.Value = 2007;
            Year.ParameterName = "@Year";
            Year.DbType = DbType.Int32;

            Month.Value = 10;
            Month.ParameterName = "@Month";
            Month.DbType = DbType.Int32;
    
            NewExchangeRate.Value = 2.05;
            NewExchangeRate.ParameterName = "@NewExchangeRate";
            NewExchangeRate.DbType = DbType.Decimal;

            expectedReturnedConversionRate = Math.Round((double)(1 / (double)NewExchangeRate.Value), 4);
        }

        private void AddParametersToSQLCommand()
        {
            executeInsertOrUpdateExchangeRate.Parameters.Clear();       

            executeInsertOrUpdateExchangeRate.Parameters.Add(IdCategory);
            executeInsertOrUpdateExchangeRate.Parameters.Add(CurrencyFrom);
            executeInsertOrUpdateExchangeRate.Parameters.Add(Year);
            executeInsertOrUpdateExchangeRate.Parameters.Add(Month);
            executeInsertOrUpdateExchangeRate.Parameters.Add(NewExchangeRate);
        }

        [Test, ExpectedException(typeof(IndException))]
        public void ExchangeRateInsertBadCurrency()
        {
            DataSet ds;

            CurrencyFrom.Value = "JPT";
            AddParametersToSQLCommand();

            //below line should fail    
            ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);
        }


         /// <summary>
        /// This method will test if the method fails with an invalid yearmonth
        /// </summary>
        [Test, ExpectedException(typeof(IndException))]
        public void ExchangeRateBadYearMonthTest()
        {
            DataSet ds;

            Year.Value = 1999;
            Month.Value = 13; //invalid value
 
            AddParametersToSQLCommand();

            //below line should fail    
            ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);
        }



        /// <summary>
        /// This method will test that if the value of the NewExchangeRate is -1, it will throw an error 
        /// </summary>
        [Test, ExpectedException(typeof(IndException))]
        public void ExchangeRateBadNewExchageRateTest()
        {
            DataSet ds;

            NewExchangeRate.Value = -1;
            AddParametersToSQLCommand();

            ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);
        }

 

        /// <summary>
        /// The following method tests that if the CurrencyFrom will be inserted with the NULL value, 
        /// the stored procedure will throw an error
        /// </summary>
        [Test, ExpectedException(typeof(IndException))]
        public void ExchangeRateNullVerifyTest()
        {
            DataSet ds;

            CurrencyFrom.Value = DBNull.Value;
            AddParametersToSQLCommand();

            ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);
        }

        /// <summary>
        /// The following method tests that if the IdCategory will be inserted with the NULL value, 
        /// the stored procedure will throw an error
        /// </summary>
        [Test, ExpectedException(typeof(IndException))]
        public void ExchangeRateNullVerifyIdCategoryTest()
        {
            DataSet ds;

            IdCategory.Value = DBNull.Value;
            AddParametersToSQLCommand();

            ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);
        }

        /// <summary>
        /// The following method tests that if the Year will be inserted with the NULL value, 
        /// the stored procedure will throw an error
        /// </summary>
        [Test, ExpectedException(typeof(IndException))]
        public void ExchangeRateNullVerifyYearTest()
        {
            DataSet ds;          
            
            Year.Value = DBNull.Value;

            AddParametersToSQLCommand();

            ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);
        }

        /// <summary>
        /// The following method tests that if the Year will be inserted with the NULL value, 
        /// the stored procedure will throw an error
        /// </summary>
        [Test, ExpectedException(typeof(IndException))]
        public void ExchangeRateNullVerifyMonthTest()
        {
            DataSet ds;

            Month.Value = DBNull.Value;

            AddParametersToSQLCommand();

            ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);
        }


        /// <summary>
        /// The following method tests that if the NewExchangeRate will be inserted with the NULL value, 
        /// the stored procedure will throw an error
        /// </summary>
        [Test, ExpectedException(typeof(IndException))]
        public void ExchangeRateNullVerifyNewExchangeRateTest()
        {
            DataSet ds;   
            NewExchangeRate.Value = DBNull.Value;

            AddParametersToSQLCommand();

            ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);

        }

        /// <summary>
        /// This method will test if the result from calling the method is a dataset, and if yes, 
        /// what value does it contains
        /// </summary>
        [Test]
        public void ExchangeRateCorrectReturnTest()
        {
            AddParametersToSQLCommand();

            //read the dataset from the database             
            DataSet ds = (DataSet)((ConnectionManager)connManager).GetDataSet(executeInsertOrUpdateExchangeRate);
            Assert.AreEqual(expectedReturnedConversionRate, (double)Math.Round((decimal)ds.Tables[0].Rows[0][0], 4));
        }
    }
}
