using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the ProjectType Entity
    /// </summary>
    public interface IProjectType : IGenericEntity
    {
        string Type
        {
            get;
            set;
        }

        int Rank
        {
            get;
            set;
        }
    }
}