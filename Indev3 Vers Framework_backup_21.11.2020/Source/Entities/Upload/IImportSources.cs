using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Upload
{
    public interface IImportSources
    {
        int IdImportSource
        {
            get;
            set;
        }

        int IdApplicationType
        {
            get;
            set;
        }

        string Code
        {
            get;
            set;
        }

        string SourceName
        {
            get;
            set;
        }

        string IdCodeName
        {
            get;
            set;
        }

        int IdCurrentAssociate
        {
            get;
            set;
        }
    }
}
