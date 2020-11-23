using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the OwnerType Entity
    /// </summary>
    public interface IOwnerType : IGenericEntity
    {
        string Name
        {
            get;
            set;
        }
    }
}