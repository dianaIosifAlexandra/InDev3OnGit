using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    public interface IRevisedBudget : IBudget
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
        int CurrentHours
        {
            get;
            set;
        }
        int UpdateHours
        {
            get;
            set;
        }
        int NewHours
        {
            get;
            set;
        }
        decimal CurrentVal
        {
            get;
            set;
        }
        decimal UpdateVal
        {
            get;
            set;
        }
        decimal NewVal
        {
            get;
            set;
        }
        decimal CurrentCosts
        {
            get;
            set;
        }
        decimal UpdateCosts
        {
            get;
            set;
        }
        decimal NewCosts
        {
            get;
            set;
        }
        decimal CurrentSales
        {
            get;
            set;
        }
        decimal UpdateSales
        {
            get;
            set;
        }
        decimal NewSales
        {
            get;
            set;
        }
        bool SaveHours
        {
            get;
            set;
        }
        string Version
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
