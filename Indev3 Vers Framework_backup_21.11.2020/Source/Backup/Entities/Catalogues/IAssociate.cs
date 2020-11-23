using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;


namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the Associate Entity
    /// </summary>
    public interface IAssociate : IGenericEntity
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
        string EmployeeNumber
        {
            get;
            set;
        }
        string InergyLogin
        {
            get;
            set;
        }
        bool IsActive
        {
            get;
            set;
        }
        bool IsSubContractor
        {
            get;
            set;
        }
        int PercentageFullTime
        {
            get;
            set;
        }
    }
}
