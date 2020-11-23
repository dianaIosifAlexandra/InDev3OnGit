using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface of the ExchangeRate Entity
    /// </summary>
    public interface IExchangeRate : IGenericEntity
    {
        int Year
        {
            get;
            set;
        }

        int Month
        {
            get;
            set;
        }
        int IdCurrencyTo
        {
            get;
            set;
        }
        decimal ConversionRate
        {
            get;
            set;
        }
    }
}
