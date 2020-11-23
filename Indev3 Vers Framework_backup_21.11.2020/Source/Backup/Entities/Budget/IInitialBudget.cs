using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    public interface IInitialBudget : IBudget
    {
        int IdCostCenter {get;set;}
        int YearMonth {get;set;}
        int TotalHours {get;set;}
        decimal ValuedHours { get;set;}
        decimal Sales {get;set;}
        int IdCountry {get;set;}
    }
    
}
