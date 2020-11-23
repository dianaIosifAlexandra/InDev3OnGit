using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the Function Entity
    /// </summary>
    public interface IFunction : IGenericEntity
    {
        string Name
        {
            get;
            set;
        }
    }
}