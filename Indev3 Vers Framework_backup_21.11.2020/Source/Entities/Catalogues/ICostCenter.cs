using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;


namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the CostCenter Entity
    /// </summary>
    public interface ICostCenter : IGenericEntity
    {
        int IdFunction
        {
            get;
            set;
        }
        int IdDepartment
        {
            get;
            set;
        }
        int IdInergyLocation
        {
            get;
            set;
        }
        bool IsActive
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

    }
}
