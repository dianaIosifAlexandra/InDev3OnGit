using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the WorkPackage Entity
    /// </summary>
    public interface IWorkPackage : IGenericEntity
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
        int IdProject
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
        int StartYearMonth
        {
            get;
            set;
        }
        int EndYearMonth
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

        int IdAssociate
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