using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    public interface IReforecastBudget : IBudget
    {
        int IdCostCenter
        {
            get;
            set;
        }
        string CostCenterName
        {
            get;
            set;
        }
        int YearMonth
        {
            get;
            set;
        }
        decimal Previous
        {
            get;
            set;
        }
        decimal Current
        {
            get;
            set;
        }
        decimal New
        {
            get;
            set;
        }
        decimal PercentComplete
        {
            get;
            set;
        }
        string Version
        {
            get;
            set;
        }
        int IdCostType
        {
            get;
            set;
        }
        DateTime ActualDataTimestamp
        {
            get;
            set;
        }
        bool ShowOnlyCCsWithSighificantValues
        {
			get;
			set;
        }
        int IdCountry
        {
			get;
			set;
        }
    }
}
