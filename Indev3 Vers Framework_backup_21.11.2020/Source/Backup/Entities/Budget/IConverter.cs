using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Budget
{
    /// <summary>
    /// Interface for the Cost Center Filter Entity
    /// </summary>
    public interface IConverter : IGenericEntity
    {
       int Currency
       {
            get;
            set;
        }
        int YearMonth
        {
            get;
            set;
        }
    }
}
