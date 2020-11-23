using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Budget
{
    /// <summary>
    /// Interface for the Cost Center Filter Entity
    /// </summary>
    public interface ICostCenterFilter : IGenericEntity
    {
        string NameCostCenter
        {
            get;
            set;
        }
        string NameFunction
        {
            get;
            set;
        }
        string NameInergyLocation
        {
            get;
            set;
        }
        int IdCostCenter
        {
            get;
            set;
        }
        int IdFunction
        {
            get;
            set;
        }
        int IdInergyLocation
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
