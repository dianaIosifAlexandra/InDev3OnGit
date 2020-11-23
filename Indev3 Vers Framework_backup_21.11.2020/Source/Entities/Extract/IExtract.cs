using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Extract
{
    public interface IExtract : IGenericEntity
    {
        int IdProject
        {
            get;
            set;
        }
        int IdProgram
        {
            get;
            set;
        }
        int Year
        {
            get;
            set;
        }
        int IdGeneration
        {
            get;
            set;
        }
        string ActiveStatus
        {
            get;
            set;
        }
        int IdCurrencyAssociate
        {
            get;
            set;
        }
    }
}
