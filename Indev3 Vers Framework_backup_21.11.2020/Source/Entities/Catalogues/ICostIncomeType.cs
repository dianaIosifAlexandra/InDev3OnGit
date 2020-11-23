using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;


namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Interface for the CostIncomeType Entity
    /// </summary>
    public interface ICostIncomeType : IGenericEntity
    {
        string Name
        {
            get;
            set;
        }
        string DefaultAccount
        {
            get;
            set;
        }
    }
}