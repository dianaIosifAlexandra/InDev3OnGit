using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.Entities.Upload
{
    public interface IDataStatus : IGenericEntity
    {
        int Year
        {
            get;
            set;
        }
        
    }
}
