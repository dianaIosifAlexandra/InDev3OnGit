using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.InitialBudget
{
    public interface IUploadInitialBudget
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
    }
}
