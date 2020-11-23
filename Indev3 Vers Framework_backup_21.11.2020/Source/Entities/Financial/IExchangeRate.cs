using System;
using System.Collections.Generic;

namespace Inergy.Indev3.Entities.Financial
{
    public interface IExchangeRate:IGenericEntity
    {
        int Year
        {
            get;
            set;
        }

        int IdCategory
        {
            get;
            set;
        }

        decimal Value
        {
            get;
            set;
        }

        int IdCurrency
        {
            get;
            set;
        }
    }
}
