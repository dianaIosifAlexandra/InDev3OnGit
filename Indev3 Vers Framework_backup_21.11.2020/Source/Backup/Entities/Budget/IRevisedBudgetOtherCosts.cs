using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.Entities.Budget
{
    public interface IRevisedBudgetOtherCosts : IGenericEntity
    {
        int IdProject
        {
            get;
            set;
        }

        int IdPhase
        {
            get;
            set;
        }

        int IdWP
        {
            get;
            set;
        }

        int IdCostCenter
        {
            get;
            set;
        }

        int IdAssociate
        {
            get;
            set;
        }

        int IdAssociateViewer
        {
            get;
            set;
        }

        int YearMonth
        {
            get;
            set;
        }
        EOtherCostTypes IdCostType
        {
            get;
            set;
        }

        decimal CostVal
        {
            get;
            set;
        }
        bool IsAssociateCurrency
        {
            get;
            set;
        }
    }
}
