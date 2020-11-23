using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    /// <summary>
    /// Class used for rounding values
    /// </summary>
    public static class Rounding
    {
        private const int DECIMALS_NUMBER = 0;

        /// <summary>
        /// Rounds a value with using the application default number of decimals
        /// </summary>
        /// <param name="value">The value that should be rounded</param>
        /// <returns>The roudned value</returns>
        public static decimal Round(decimal value)
        {
            try
            {
                return decimal.Round(value, DECIMALS_NUMBER, MidpointRounding.AwayFromZero);
            }
            catch (OverflowException exc)
            {
                throw new IndException(exc);
            }
        }

        /// <summary>
        /// Divides value to divider. The result is applied the rounding rules. Returns an array having each value equal to this result.
        /// If after applying the rounding rules, the sum of the multiplication of this result and divider is different than value, the last
        /// element of this array will be added the difference such that the sum of elements is equal to value.
        /// </summary>
        /// <param name="value">the value to be divided</param>
        /// <param name="divider">the divider</param>
        /// <returns>an array containing the divided values</returns>
        public static decimal[] Divide(decimal value, int divider)
        {
            //Store in this variable whether the number to divide is negative
            bool isValueNegative = false;
            if (value < 0)
                isValueNegative = true;

            value = Round(value);
            decimal[] result = new decimal[divider];
            if (value == ApplicationConstants.DECIMAL_NULL_VALUE)
            {
                for (int i = 0; i < divider; i++)
                {
                    result[i] = ApplicationConstants.DECIMAL_NULL_VALUE;
                }
            }
            else
            {
                //Get the absolute value of the number to divide and divide it as if it were positive
                value = Math.Abs(value);
                //Divide value to divider and apply rounding rules
                decimal divisionResult = Round(decimal.Divide(value, divider));
                decimal partialSum = 0;
                //Populate result array
                for (int i = 0; i < divider; i++)
                {
                    if (decimal.Subtract(value, partialSum) >= divisionResult)
                    {
                        result[i] = divisionResult;
                    }
                    else
                    {
                        result[i] = decimal.Subtract(value, partialSum);
                    }
                    partialSum = decimal.Add(partialSum, result[i]);
                }
                //If partialsum is not equal to initial value, adjust the last element of the result array
                if (decimal.Compare(partialSum, value) != 0)
                {
                    result[result.Length - 1] = decimal.Add(result[result.Length - 1], decimal.Subtract(value, partialSum));
                }
                
                //If the number to divide was negative, multiply each value in the result array with -1
                if (isValueNegative)
                {
                    for (int i = 0; i < result.Length; i++)
                        result[i] *= -1;
                }
            }
            return result;
        }

        /// <summary>
        /// Divides an int value to a divider. This method simply calls the other Divide method (with decimals) and casts the results
        /// from decimal to int
        /// </summary>
        /// <param name="value">the value to be divided</param>
        /// <param name="divider">the divider</param>
        /// <returns>an array containing the divided values</returns>
        public static int[] Divide(int value, int divider)
        {
            decimal decimalValue = new decimal(value);
            decimal[] decimalResult = new decimal[divider];
            int[] result = new int[divider];

            if (value == ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS)
            {
                for (int i = 0; i < divider; i++)
                {
                    result[i] = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;
                }
            }
            else
            {
                decimalResult = Divide(decimalValue, divider);

                for (int i = 0; i < divider; i++)
                {
                    if (decimalResult[i] == ApplicationConstants.DECIMAL_NULL_VALUE)
                        result[i] = ApplicationConstants.INT_NULL_VALUE_FOR_VALUE_FIELDS;
                    else
                        result[i] = (int)decimalResult[i];
                }
            }
            return result;
        }
    }
}
