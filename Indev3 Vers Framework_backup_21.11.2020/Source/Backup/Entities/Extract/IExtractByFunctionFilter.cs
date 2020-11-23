using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Extract
{
    /// <summary>
    /// Interface for the Cost Center Filter Entity
    /// </summary>
    public interface IExtractByFunctionFilter : IGenericEntity
    {
        string NameRegion
        {
            get;
            set;
        }
        string NameCountry
        {
            get;
            set;
        }
        string NameInergyLocation
        {
            get;
            set;
        }
        string NameFunction
        {
            get;
            set;
        }
        string NameDepartment
        {
            get;
            set;
        }
        int IdRegion
        {
            get;
            set;
        }
        int IdCountry
        {
            get;
            set;
        }
        int IdInergyLocation
        {
            get;
            set;
        }
        int IdFunction
        {
            get;
            set;
        }
        int IdDepartment
        {
            get;
            set;
        }
        int IdCurrencyAssociate
        {
            get;
            set;
        }
        int Year
        {
            get;
            set;
        }
        string ActiveStatus
        {
            get;
            set;
        }

        string CostTypeCategory
        {
            get;
            set;
        }
    }
}
