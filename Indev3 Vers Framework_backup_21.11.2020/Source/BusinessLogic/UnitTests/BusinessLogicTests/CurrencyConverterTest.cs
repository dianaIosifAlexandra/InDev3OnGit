using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

using NUnit.Framework;

using Inergy.Indev3.Entities;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogicTests
{
    [TestFixture]
    public class CurrencyConverterTest
    {
        private CurrencyConverter currencyConverter;
        private decimal rawValue;
        private int currencyFrom;
        private int currencyTo;
        private decimal covertedValue;
        private decimal calculatedConversion = 3000M;

        private SessionConnectionHelper sessionConnectionHelper;
        private object connManager;

        [SetUp]
        public void Initialize()
        {
            sessionConnectionHelper = new SessionConnectionHelper();
            connManager = sessionConnectionHelper.GetNewConnectionManager(BLTestUtils.ConnString, BLTestUtils.COMMAND_TIMEOUT);
            currencyConverter = new CurrencyConverter(connManager);
        }
        [TearDown]
        public void CloseUp()
        {
            sessionConnectionHelper.DisposeConnection(connManager);
        }

        [Test]
        public void VerifyCategoryAndYearMonthTest()
        {
            rawValue = 100000;
            currencyFrom = 2;
            YearMonth yearMonth = new YearMonth(200012);
            currencyTo = 1;

            covertedValue = currencyConverter.GetConversionValue(rawValue, currencyFrom, yearMonth, currencyTo);
            Assert.AreEqual(calculatedConversion, covertedValue);
        }
        [Test]
        [ExpectedException(typeof(IndException))]
        public void VerifyRawValueTest()
        {
            rawValue = -1;
            currencyFrom = 6;
            YearMonth yearMonth = new YearMonth(200701);
            currencyTo = 100000;

            covertedValue = currencyConverter.GetConversionValue(rawValue, currencyFrom, yearMonth, currencyTo);
            Assert.AreEqual(calculatedConversion, covertedValue);
        }
        [Test]
        [ExpectedException(typeof(IndException))]
        public void VerifyCurrencyTest()
        {
            rawValue = 100000;
            currencyFrom = 5000;
            YearMonth yearMonth = new YearMonth(200701);
            currencyTo = 100000;

            covertedValue = currencyConverter.GetConversionValue(rawValue, currencyFrom, yearMonth, currencyTo);
            Assert.AreEqual(calculatedConversion, covertedValue);
        }
        
    }
}
