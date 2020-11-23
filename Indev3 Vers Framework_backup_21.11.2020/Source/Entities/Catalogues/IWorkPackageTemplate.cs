using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the WorkPackageTemplate Entity
    /// </summary>
    public interface IWorkPackageTemplate : IGenericEntity
    {
        int IdPhase
        {
            get;
            set;
        }
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
        int Rank
        {
            get;
            set;
        }
        bool IsActive
        {
            get;
            set;
        }
        DateTime LastUpdate
        {
            get;
            set;
        }
        int IdLastUserUpdate
        {
            get;
            set;
        }

        String LastUserUpdate
        {
            get;
            set;
        }
        bool IsProgramManager
        {
            get;
            set;
        }
        void SetSettings(ApplicationSettings settings);

    }
}