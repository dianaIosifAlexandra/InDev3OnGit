using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Upload
{
    public interface IImportDetails
    {
        int IdImport
        {
            get;
            set;
        }

        int IdRow
        {
            get;
            set;
        }

        string Country
        {
            get;
            set;
        }

        int Year
        {
            get;
            set;
        }

        int Month
        {
            get;
            set;
        }

        string CostCenter
        {
            get;
            set;
        }

        string ProjectCode
        {
            get;
            set;
        }

        int ProjectId
        {
            get;
            set;
        }

        string WPCode
        {
            get;
            set;
        }

        string AccountNumber
        {
            get;
            set;
        }

        string AssociateNumber
        {
            get;
            set;
        }

        decimal Quantity
        {
            get;
            set;
        }

        string UnitQty
        {
            get;
            set;
        }

        decimal Value
        {
            get;
            set;
        }

        string CurrencyCode
        {
            get;
            set;
        }

        DateTime ImportDate
        {
            get;
            set;
        }
    }
}
