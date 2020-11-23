using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Budget
{
    /// <summary>
    /// Interface for the Project Selector Filter
    /// </summary>
    public interface IProjectSelectorFilter
    {
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
        int IdProject
        {
            get;
            set;
        }
        string ShowOnly
        {
            get;
            set;
        }
        string OrderBy
        {
			get;
			set;
        }
    }
}
