using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    /// <summary>
    /// Class that represents a YearMonth value
    /// </summary>
    public class YearMonth
    {
        #region Properties
        private int _Value;
        /// <summary>
        /// The value of the YearMonth
        /// </summary>
        public int Value
        {
            get { return _Value; }
            set { _Value = value; }
        }
        public int Year
        {
            get
            {
                return _Value / 100;
            }
        }
        public int Month
        {
            get
            {
                return _Value % 100;
            }
        }

        public static int FirstYear = 2005;
        public static int LastYear = DateTime.Now.Year + 5;
        #endregion Properties

        #region Constructors
        public YearMonth(int value)
        {
            this._Value = value;
        }
        
        /// <summary>
        /// Builds a new object based on a given value and a separator (Ex: "/")
        /// </summary>
        /// <param name="value">The string value of the YearMonth</param>
        /// <param name="separator">The separator used in the string</param>
        public YearMonth(string value, string separator) : this(value.Replace(separator, ""))
        {
        }

        /// <summary>
        /// Builds a new object based on a given string value
        /// </summary>
        /// <param name="value">The string value of the YearMonth</param>
        public YearMonth(string value)
        {
            if (string.IsNullOrEmpty(value))
                throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_NULL_ENCOUNTERED, "YearMonth"));
            if (!int.TryParse(value, out _Value))
                throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_FORMAT_NOT_VALID, "YearMonth"));
        }
        #endregion Constructors

        #region Public Methods
        /// <summary>
        /// Gets the difference (in months) between current object and other YearMonth object
        /// </summary>
        /// <param name="otherYearMonth">The other year Month</param>
        /// <returns>The difference in months</returns>
        public int GetMonthsDiffrence(YearMonth otherYearMonth)
        {
            int yearDifference = this.Year - otherYearMonth.Year;
            int monthDifference = this.Month - otherYearMonth.Month;
            return yearDifference * 12 + monthDifference;
        }

        /// <summary>
        /// Add a given number of months to the current object
        /// </summary>
        /// <param name="monthsNo">The number of months</param>
        public void AddMonths(int monthsNo)
        {
            int yearsNo = (this.Month + monthsNo) / 13;
            monthsNo = (this.Month + monthsNo) % 13;
            if (monthsNo == 0)
                monthsNo = 1;
            this._Value = (this.Year + yearsNo) * 100 + monthsNo;
        }

        public string GetMonthRepresentation()
        {
            
            switch (this.Month)
            {
                case 1:
                    return "Jan";
                case 2:
                    return "Feb";
                case 3:
                    return "Mar";
                case 4:
                    return "Apr";
                case 5:
                    return "May";
                case 6:
                    return "Jun";
                case 7:
                    return "Jul";
                case 8:
                    return "Aug";
                case 9:
                    return "Sep";
                case 10:
                    return "Oct";
                case 11:
                    return "Nov";
                case 12:
                    return "Dec";
                default:
                    throw new IndException("YearMonth " + this.Value.ToString() + " not in the correct format");
            }
        }

        #endregion Public Methods
    }
}
