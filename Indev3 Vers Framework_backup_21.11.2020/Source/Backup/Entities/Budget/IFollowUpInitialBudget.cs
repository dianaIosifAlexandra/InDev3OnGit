using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    /// <summary>
    /// interface for Follow Up Initial Budget
    /// </summary>
    public interface IFollowUpInitialBudget : IGenericEntity
    {
        int IdProject
        {
            get;
            set;
        }
        int IdAssociate
        {
            get;
            set;
        }
        string StateCode
        {
            get;
            set;
        }
        DateTime StateDate
        {
            get;
            set;
        }

        bool IsValidated
        {
            get;
            set;
        }
        string Description
        {
            get;
            set;
        }

        string BudgetState
        {
            get;
            set;
        }

    }
}
