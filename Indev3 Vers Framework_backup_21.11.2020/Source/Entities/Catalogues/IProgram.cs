using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the Program Entity
    /// </summary>
    public interface IProgram : IGenericEntity
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
        int IdOwner
        {
            get;
            set;
        }
        int IdOwnerType
        {
            get;
            set;
        }
        bool IsActive
        {
            get;
            set;
        }

        bool OnlyActive
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
