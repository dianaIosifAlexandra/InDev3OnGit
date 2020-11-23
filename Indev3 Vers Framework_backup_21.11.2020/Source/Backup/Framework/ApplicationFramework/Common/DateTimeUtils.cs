using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    public static class DateTimeUtils
    {
        /// <summary>
        /// Gets the MM/YYYY format from an int that has the format YYYYMM
        /// </summary>
        /// <param name="yearMonthVal"></param>
        /// <returns></returns>
        public static string GetDateFromYearMonth(int yearMonthVal)
        {
            //Treats null values
            if ((yearMonthVal == 0) || (yearMonthVal == ApplicationConstants.INT_NULL_VALUE))
                return String.Empty;
            //The format must be YYYYMM
            if (yearMonthVal.ToString().Length != 6)
                throw new IndException(ApplicationMessages.EXCEPTION_YEARMONTH_NOT_HAVE_FORMAT);
            //Gets the year and month from the int object
            int year = yearMonthVal / 100;
            int month = yearMonthVal % 100;
            //If month < 10 add a 0 in front of it
            string monthText = (month.ToString().Length == 1) ? "0" + month.ToString() : month.ToString();
            //return the desired format
            return year.ToString() + "/" + monthText;
        }
    }
}
