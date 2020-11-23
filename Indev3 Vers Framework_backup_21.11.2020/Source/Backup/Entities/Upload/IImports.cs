using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Upload
{
    public interface IImports
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

        string SourceCode
        {
            get;
            set;
        }

        int IdSource
        {
            get;
            set;
        }

        string Message
        {
            get;
            set;
        }

        int IdRow
        {
            get;
            set;
        }
    }
}
