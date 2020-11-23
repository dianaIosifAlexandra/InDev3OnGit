using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.AnnualBudget
{
    public interface IAnnualUpload : IGenericEntity
    {
        int IdImport
        {
            get;
            set;
        }
        string FileName
        {
            get;
            set;
        }
        int IdAssociate
        {
            get;
            set;
        }
        bool SkipStartEndPhaseErrorsHours
        {
            get;
            set;
        }
        bool SkipStartEndPhaseErrorsCosts
        {
            get;
            set;
        }
        bool SkipStartEndPhaseErrorsSales
        {
            get;
            set;
        }
    }
}
