using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface of the HourlyRate Entity
    /// </summary>
    public interface IHourlyRate : IGenericEntity
    {
        int YearMonth
        {
            get;
            set;
        }
        int IdCostCenter
        {
            get;
            set;
        }
        int IdCurrency
        {
            get;
            set;
        }
        decimal Value
        {
            get;
            set;
        }

        int IdInergyLocation
        {
            get;
            set;
        }
        int StartYearMonth
        {
            get;
            set;
        }
        int EndYearMonth
        {
            get;
            set;
        }
        int IdCountry
        {
            get;
            set;
        }
    }
}
