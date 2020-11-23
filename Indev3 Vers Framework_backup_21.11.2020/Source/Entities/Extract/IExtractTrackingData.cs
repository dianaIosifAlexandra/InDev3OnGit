using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.Entities.Extract
{
    public interface IExtractTrackingData : IGenericEntity
    {
        int Year { get; set; }
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

        int IdRole
        {
            get;
            set;
        }

    }
}
