using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;


namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface of the Country Entity
    /// </summary>
    public interface IInergyCountry : IGenericEntity
    {
        string Code
        {
            get;
            set;
        }

        string Name
        {
            get;
            set;
        }
        int IdRegion
        {
            get;
            set;
        }
        int IdCurrency
        {
            get;
            set;
        }
    }
}
