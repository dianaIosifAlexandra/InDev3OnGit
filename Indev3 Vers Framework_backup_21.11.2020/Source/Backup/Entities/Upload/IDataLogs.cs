using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.Entities.Upload
{
    public interface IDataLogs
    {
        YearMonth YearMonth
        {
            get;
            set;
        }
        string Validation
        {
            get;
            set;
        }
        string ApplicationName
        {
            get;
            set;
        }
        string FileName
        {
            get;
            set;
        }
        int IdUser
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
        string UserName
        {
            get;
            set;
        }

    }
}
