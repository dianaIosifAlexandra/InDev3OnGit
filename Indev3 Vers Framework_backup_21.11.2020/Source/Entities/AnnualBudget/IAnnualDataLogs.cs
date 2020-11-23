using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.Entities.AnnualBudget
{
    public interface IAnnualDataLogs
    {
        YearMonth Period
        {
            get;
            set;
        }
        string Validation
        {
            get;
            set;
        }
        string FileName
        {
            get;
            set;
        }
        int IdImport
        {
            get;
            set;
        }
        DateTime Date
        {
            get;
            set;
        }
        string CountryCode
        {
            get;
            set;
        }
    }
}
