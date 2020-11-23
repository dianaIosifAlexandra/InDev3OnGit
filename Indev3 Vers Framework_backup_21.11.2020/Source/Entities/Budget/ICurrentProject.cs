using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Budget
{
    /// <summary>
    /// Interface for the Current Project Entity
    /// </summary>
    public interface ICurrentProject : IGenericEntity
    {
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
        int IdAssociate
        {
            get;
            set;
        }
        int IdProgram
        {
            get;
            set;
        }
        string ShowOnly
        {
            get;
            set;
        }
    }
}
