using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the GlAccount Entity
    /// </summary>
    public interface IGlAccount : IGenericEntity
    {
        int IdCountry
        {
            get;
            set;
        }
        string Name
        {
            get;
            set;
        }
        string Account
        {
            get;
            set;
        }
        int IdCostType
        {
            get;
            set;
        }
    }
}
