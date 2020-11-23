using System;
using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.BusinessLogic.Budget;
using System.Data.SqlClient;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogicTests
{
    [TestFixture]
    public class ExchangeRateReaderTest
    {
        private ExchangeRateReader exchangeRateReader;
        private decimal selectedExchangeRate;
        private SessionConnectionHelper sessionConnectionHelper;
        private object connManager;

        [SetUp]
        public void Initialize()
        {
            sessionConnectionHelper = new SessionConnectionHelper();
            connManager = sessionConnectionHelper.GetNewConnectionManager(BLTestUtils.ConnString, BLTestUtils.COMMAND_TIMEOUT);
            exchangeRateReader = new ExchangeRateReader(connManager);
        }

        [TearDown]
        public void CloseUp()
        {
            sessionConnectionHelper.DisposeConnection(connManager);
        }
        
        [Test]
        public void VerifyCategoryAndYearMonthTest()
        {
            BudgetExchangeRate exchangeRate = new BudgetExchangeRate();
            exchangeRate.CurrencyFrom = 2;
            exchangeRate.CurrencyTo = 1;
            exchangeRate.YearMonth = new YearMonth(200012);
            selectedExchangeRate = exchangeRateReader.GetExchangeRate(exchangeRate);
            Assert.AreEqual(0.03, selectedExchangeRate);
                        
            exchangeRate.YearMonth = new YearMonth(200702);
            selectedExchangeRate = exchangeRateReader.GetExchangeRate(exchangeRate);
            Assert.AreEqual(0.1, selectedExchangeRate);
            
            exchangeRate.YearMonth = new YearMonth(200701);
            selectedExchangeRate = exchangeRateReader.GetExchangeRate(exchangeRate);
            Assert.AreEqual(0.12, selectedExchangeRate);
        }

        [Test]
        [ExpectedException(typeof(IndException))]
        public void VerifyYearMonth()
        {
            BudgetExchangeRate exchangeRate = new BudgetExchangeRate();
            exchangeRate.YearMonth = new YearMonth(-2);
            exchangeRate.CurrencyFrom = 2;
            exchangeRate.CurrencyTo = 1;
            selectedExchangeRate = exchangeRateReader.GetExchangeRate(exchangeRate);
        }

        [Test]
        [ExpectedException(typeof(IndException))]
        public void VerifyCurrencyFrom()
        {
            BudgetExchangeRate exchangeRate = new BudgetExchangeRate();
            exchangeRate.YearMonth = new YearMonth(200702);
            exchangeRate.CurrencyFrom = -2;
            exchangeRate.CurrencyTo = 1;
            selectedExchangeRate = exchangeRateReader.GetExchangeRate(exchangeRate);
        }

        [Test]
        [ExpectedException(typeof(IndException))]
        public void VerifyCurrencyTo()
        {
            BudgetExchangeRate exchangeRate = new BudgetExchangeRate();
            exchangeRate.YearMonth = new YearMonth(200702);
            exchangeRate.CurrencyFrom = 1;
            exchangeRate.CurrencyTo = -2;
            selectedExchangeRate = exchangeRateReader.GetExchangeRate(exchangeRate);
        }
    }
}
