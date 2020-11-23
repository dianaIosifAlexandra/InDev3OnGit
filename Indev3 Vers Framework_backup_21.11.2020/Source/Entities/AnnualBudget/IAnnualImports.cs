using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.AnnualBudget
{
    public interface IAnnualImports
    {
        int IdImport
        {
            get;
            set;
        }
        DateTime ImportDate
        {
            get;
            set;
        }
        string FileName
        {
            get;
            set;
        }

        string Message
        {
            get;
            set;
        }

        int IdAssociate
        {
            get;
            set;
        }
    }
}
