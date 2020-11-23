using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.BusinessLogic.Common
{
    public static class PeriodUtils
    {
        /// <summary>
        /// Return an ArrayList with all years between "YearMonth.FirstYear" from ApplicationFramework.Common and current year
        /// </summary>
        public static ArrayList GetYears()
        {
            ArrayList alYears = new ArrayList();

            for (int i = YearMonth.FirstYear; i <= DateTime.Now.Year + ApplicationConstants.YEAR_AHEAD_TO_INCLUDE; i++)
                alYears.Add(i);

            return alYears;
        }
    }
}
