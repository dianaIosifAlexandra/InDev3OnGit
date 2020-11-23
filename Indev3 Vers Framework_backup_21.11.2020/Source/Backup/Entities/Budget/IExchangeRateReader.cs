using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.Entities.Budget
{
    /// <summary>
    /// Interface for the Cost Center Filter Entity
    /// </summary>
    public interface IExchangeRateReader : IGenericEntity
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
        YearMonth YearMonth
        {
            get;
            set;
        }
    }
}
