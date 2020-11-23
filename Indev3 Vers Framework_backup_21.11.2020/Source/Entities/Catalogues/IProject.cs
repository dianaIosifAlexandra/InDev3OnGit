using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the Project Entity
    /// </summary>
    public interface IProject : IGenericEntity
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
        int IdProgram
        {
            get;
            set;
        }
        int IdProjectType
        {
            get;
            set;
        }
        bool IsActive
        {
            get;
            set;
        }
        string ProgramCode
        {
            get;
            set;
        }
        int IdAssociate
        {
            get;
            set;
        }
        bool UseWorkPackageTemplate
        {
            get;
            set;
        }
    }
}
