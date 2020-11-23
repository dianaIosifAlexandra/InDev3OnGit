using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the Currency Entity
    /// </summary>
    public interface ICurrency : IGenericEntity
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
    }
}
