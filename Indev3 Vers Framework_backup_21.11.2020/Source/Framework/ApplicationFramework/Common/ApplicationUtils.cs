using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.IO;
using System.Data;
using System.Configuration;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    /// <summary>
    /// Static class containing methods used in the entire application
    /// </summary>
    public static class ApplicationUtils
    {
        /// <summary>
        /// Checks if the given value is null (for its type)
        /// </summary>
        /// <param name="value">the value that is checked for null</param>
        /// <returns>true if the value is null (for its type), false otherwise</returns>
        public static bool AssertValueIsNull(object value)
        {
            if (value.GetType() == typeof(int))
            {
                return ((int)value == ApplicationConstants.INT_NULL_VALUE || (int)value == ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS);
            }
            if (value.GetType() == typeof(short))
            {
                return (short)value == ApplicationConstants.SHORT_NULL_VALUE;
            }
            if (value.GetType() == typeof(decimal))
            {
                return (decimal)value == ApplicationConstants.DECIMAL_NULL_VALUE;
            }
            if (value.GetType() == typeof(string))
            {
                return String.IsNullOrEmpty((string)value);
            }
            throw new ArgumentException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_NULL_VALUE_FOR_TYPE_IS_NOT_DEFINED, value.GetType().ToString()));
        }

        /// <summary>
        /// Returns true if the given value is of numeric type
        /// </summary>
        /// <param name="value">the value that is checked if it is numeric</param>
        /// <returns>true if value is numeric, false otherwise</returns>
        public static bool AssertValueIsNumeric(object value)
        {
            return (value is int) || (value is short) || (value is decimal);
        }

        /// <summary>
        /// Converts a text to a yearMonth format (integer with 6 digits)
        /// </summary>
        /// <param name="yearMonthText">a string with thw format: YYYY/MM</param>
        /// <returns>the numeric representation of the YearMonth value</returns>
        public static int StringToYearMonth(string yearMonthText)
        {
            //Asserts that the value is not empty
            if (yearMonthText == String.Empty)
                return ApplicationConstants.INT_NULL_VALUE;
            //Verfies if the text has exactly 7 digits
            if (yearMonthText.Length != 7)
                return ApplicationConstants.INT_NULL_VALUE;
            try
            {
               int yearMonthValue = int.Parse(yearMonthText.Replace(@"/",""));
               return yearMonthValue;
            }
            catch (Exception exc)
            {
                throw new IndException(exc.Message + " The string " + yearMonthText + " is not a valid YearMonth.");
            }

        }
        public static string YearMonthToString(int yearMonthValue)
        {
            if (yearMonthValue == ApplicationConstants.INT_NULL_VALUE)
                return String.Empty;
            if (yearMonthValue.ToString().Length !=6)
                return "YearMonth not correct";
            return yearMonthValue.ToString().Substring(0, 4) + @"/" + yearMonthValue.ToString().Substring(4, 2);
        }
        /// <summary>
        /// Replaces all occurences of ';' character in oldValue with ' ' character. Used in the CSV export process
        /// </summary>
        /// <param name="oldValue">the value of the string to be processed</param>
        /// <returns>the string oldValue with all occurences of ';' character replaced with ' '</returns>
        public static string ReplaceSemicolonWithSpace(string oldValue)
        {
            string newValue;
            newValue = oldValue.Replace(';', ' ');
            return newValue;
        }

        public static string ReplaceDateTimeWithDate(string oldValue)
        {            
            string[] newValue = oldValue.Split(' ');
            return newValue[0];
        }

        public static string FormatDateFrenchStyle(string tempString)
        {
            
            string result = string.Empty;
            DateTime startDate = DateTime.MinValue;
            DateTime.TryParse(tempString,out startDate);            
            if (startDate != DateTime.MinValue)
            {
                string day = "00" + startDate.Day.ToString();
                string month = "00" + startDate.Month.ToString();
                result = day.Substring(day.Length-2)+ "/" + month.Substring(month.Length-2) + "/" + startDate.Year.ToString();
            }
            return result;
        }

        public static string DisplayEntity(string strToDisplay, int length)
        {
            if (string.IsNullOrEmpty(strToDisplay)) return strToDisplay;
            if(strToDisplay.Length<length) return strToDisplay;
            return strToDisplay.Substring(0, length - 1).Trim() + "...";
        }

        public static string GetCleanFileName(string fileName)
        {
            string[] str = Path.GetFileName(fileName).Split('_');
            string[] arr = str[0].Split('.');
            return arr[0] + Path.GetExtension(fileName);
        }

        public static string GetClientValueName(string clientControlID)
        {
            return clientControlID.Replace("_", "$") + "_value";
        }

        public static int CreateAssociatesTextFile(DataSet ds, string fileName)
        {
            string dirUrl = string.Empty;
            int i = ApplicationConstants.INT_NULL_VALUE;
            if (ds == null)
                return i;
            if (ds.Tables[0].Rows.Count == 0)
                return i;

            using (StreamWriter sw = File.CreateText(fileName))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    i++;
                    sw.WriteLine(dr[0].ToString());
                }

            }
            return i;
        }

        public static string GetIntValueStringRepresentation(int value)
        {
            return (value == ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS) ? String.Empty : value.ToString();
        }

        public static string GetDecimalValueStringRepresentation(decimal value)
        {
            return (value == ApplicationConstants.DECIMAL_NULL_VALUE) ? String.Empty : value.ToString();
        }

        /// <summary>
        /// When a decimal value is aprt of a sum, if the value is null, it will be added as 0. This method does exactly this, 
        /// returning 0 is the value is null or the unchanged value if it is not null
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static decimal GetDecimalValueForSum(decimal value)
        {
            return (value == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : value;
        }
    }

    /// <summary>
    /// used for user settings
    /// </summary>
    public enum AmountScaleOption
    {
        Unit = 0,
        Thousands,
        Millions
    }

    public enum CurrencyRepresentationMode
    {
        CostCenter = 0,
        Associate
    }    
}
