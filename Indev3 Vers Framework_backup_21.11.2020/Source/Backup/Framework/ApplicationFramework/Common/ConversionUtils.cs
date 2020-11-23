using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    public class ConversionUtils
    {
        public const string THOUSANDS_SEPARATOR = ",";
        public const string DECIMAL_SEPARATOR = ".";

        /// <summary>
        /// Creates a unique key from the combination of the primary keys. The unique Key name will be named
        /// "UniqueKey"
        /// </summary>
        /// <param name="table">The table that should have a unique key</param>
        /// <param name="primaryKeys">the primary key that will be used to construct the unique key </param>
        public static void MakeUniqueKey(DataTable table, string[] primaryKeys)
        {
            try
            {
                //Constructs the expression for the new key
                string uniqueKeyExpression = "";
                foreach (string key in primaryKeys)
                    uniqueKeyExpression += "["+key+"]+'_'+";
                //Create the column
                DataColumn col = new DataColumn("UniqueKey",typeof(string));
                //Sets th unique column expression
                col.Expression = uniqueKeyExpression.Substring(0,uniqueKeyExpression.Length-5);
                //Add the column to the table
                table.Columns.Add(col);
            }
            catch (Exception exc)
            {
                Logger.WriteLine(exc.Message);
                throw new IndException(exc.Message + " " + ApplicationMessages.EXCEPTION_UNIQUE_KEY_CREATION_FAILED);                
            }
        }

        public string GetDecimalStringFromObject(object val)
        {
            try
            {
                decimal decimalVal = decimal.Parse(val.ToString());
                string stringVal = FormatString(decimalVal.ToString());
                if (!stringVal.Contains(DECIMAL_SEPARATOR))
                    stringVal += DECIMAL_SEPARATOR + "00";
                return stringVal;
            }
            catch (Exception exc)
            {
                throw new IndException(exc.Message + " " + ApplicationMessages.EXCEPTION_VALUE_NOT_CONVERTED_TO_DECIMAL);
            }
        }

        /// <summary>
        /// Adds thousands separator to the string representation of a number
        /// </summary>
        /// <param name="text">string representation of a number</param>
        /// <param name="thousandsSeparator"></param>
        /// <returns></returns>
        public string FormatString(string text)
        {
            try
            {
                if (String.IsNullOrEmpty(text))
                    return text;

                if (text[0] == '-')
                    return FormatString(text, false);
                return FormatString(text, true);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }

        public string FormatString(string text, bool ignoreSign)
        {
            try
            {
                if (String.IsNullOrEmpty(text))
                    return text;

                int lowLimitIndex;
                int newIndex = text.Length;
                while (true)
                {
                    int index = text.IndexOf(THOUSANDS_SEPARATOR);
                    if (index == -1)
                    {
                        int decimalSeparatorIndex = text.IndexOf(DECIMAL_SEPARATOR);
                        if (decimalSeparatorIndex == -1)
                        {
                            index = text.Length;
                        }
                        else
                        {
                            index = decimalSeparatorIndex;
                        }
                    }
                    newIndex = index - 4;

                    if (ignoreSign)
                        lowLimitIndex = 0;
                    else
                        lowLimitIndex = 1;

                    if (newIndex < lowLimitIndex)
                        return text;

                    text = text.Insert(newIndex + 1, THOUSANDS_SEPARATOR);
                }
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Removes the thousands separator used in budget screens
        /// </summary>
        /// <returns>The string withoud the thousands separator</returns>
        public string RemoveThousandsFormat(string initialValue)
        {
            string result;
            try
            {
                result = initialValue.Replace(THOUSANDS_SEPARATOR, "");
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return result;
        }

        /// <summary>
        /// Returns the string that will be used for the decimal(money) columns in the budget 
        /// </summary>
        /// <returns>The Data Format String</returns>
        public string GetDecimalColumnDataFormatString()
        {
            return "{0:#,##0;-#,##0;0}";
        }
        public string GetIntColumnDataFormatString()
        {
            return "{0:#,##0;-#,##0;0}";
        }

        /// <summary>
        /// Given a number represented as a string, adds the "+" sign in front of it is positive or leaves it as it is if it is negative
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public string AddSign(string text)
        {
            if (String.IsNullOrEmpty(text))
                return null;

            //Leave number 0 as it is
            if (text.Length == 1 && text[0] == '0')
                return text;

            //If number is negative, leave it as it is, else put a "+" sign in front of it
            if (text[0] == '-')
                return text;
            else
                return "+" + text;
        }
    }
}
