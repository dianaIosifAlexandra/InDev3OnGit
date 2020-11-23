using System;
using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.ApplicationFrameworkTests
{
    [TestFixture]
    public class ApplicationUtilsTests
    {
        [Test]
        public void AssertValueIsNullTest()
        {
            bool result;
            int intTestValue = ApplicationConstants.INT_NULL_VALUE;
            result = ApplicationUtils.AssertValueIsNull(intTestValue);
            Assert.AreEqual(true, result);

            short shortTestValue = ApplicationConstants.SHORT_NULL_VALUE;
            result = ApplicationUtils.AssertValueIsNull(shortTestValue);
            Assert.AreEqual(true, result);

            decimal decimalTestValue = ApplicationConstants.DECIMAL_NULL_VALUE;
            result = ApplicationUtils.AssertValueIsNull(decimalTestValue);
            Assert.AreEqual(true, result);

            string stringTestValue = String.Empty;
            result = ApplicationUtils.AssertValueIsNull(stringTestValue);
            Assert.AreEqual(true, result);
        }

        [Test]
        public void AssertValueIsNumericTest()
        {
            bool result;
            int intTestValue = ApplicationConstants.INT_NULL_VALUE;
            result = ApplicationUtils.AssertValueIsNumeric(intTestValue);
            Assert.AreEqual(true, result);

            short shortTestValue = ApplicationConstants.SHORT_NULL_VALUE;
            result = ApplicationUtils.AssertValueIsNumeric(shortTestValue);
            Assert.AreEqual(true, result);

            decimal decimalTestValue = ApplicationConstants.DECIMAL_NULL_VALUE;
            result = ApplicationUtils.AssertValueIsNumeric(decimalTestValue);
            Assert.AreEqual(true, result);

            string stringTestValue = String.Empty;
            result = ApplicationUtils.AssertValueIsNumeric(stringTestValue);
            Assert.AreEqual(false, result);
        }
    }
}
