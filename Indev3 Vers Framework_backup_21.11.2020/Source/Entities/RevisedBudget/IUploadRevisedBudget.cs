using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.RevisedBudget
{
    public interface IUploadRevisedBudget
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

        int IdAssociate
        {
            get;
            set;
        }

        bool SkipExistRevisedBudgetError
        {
            get;
            set;
        }
    }
}

