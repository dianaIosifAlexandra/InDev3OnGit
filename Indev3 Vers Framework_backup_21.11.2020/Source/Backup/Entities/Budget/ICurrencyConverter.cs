using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.Entities.Budget
{
    /// <summary>
    /// Interface for the  Filter Entity
    /// </summary>
    public interface ICurrencyConverter : IGenericEntity
    {
        int CurrencyFrom
        {
            get;
            set;
        }
        int CurrencyTo
        {
            get;
            set;
        }
        YearMonth StartYearMonth
        {
            get;
            set;
        }
        YearMonth EndYearMonth
        {
            get;
            set;
        }
    }
}
