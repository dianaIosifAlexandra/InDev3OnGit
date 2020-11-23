using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.Entities.UserSettings
{
    public interface IUserSettings
    {
        int AssociateId
        {
            get;
            set;
        }

        AmountScaleOption AmountScaleOption
        {
            get;
            set;
        }

        int NumberOfRecordsPerPage
        {
            get;
            set;
        }

        CurrencyRepresentationMode CurrencyRepresentation
        {
            get;
            set;
        }


    }
}
