using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.AnnualBudget
{
    public interface IAnnualDownload : IGenericEntity
    {
        int IdCountry
        {
            get;
            set;
        }
        int IdInergyLocation
        {
            get;
            set;
        }
        int Year
        {
            get;
            set;
        }
    }
}
