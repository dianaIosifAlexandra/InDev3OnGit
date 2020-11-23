using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    public interface IWPPreselection : IGenericEntity
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
        string PhaseName
        {
            get;
            set;
        }
        int IdWP
        {
            get;
            set;
        }
        string WPName
        {
            get;
            set;
        }
        string WPCode
        {
            get;
            set;
        }
        int StartYearMonth
        {
            get;
            set;
        }
        int EndYearMonth
        {
            get;
            set;
        }
        DateTime LastUpdate
        {
            get;
            set;
        }
        int IdLastUserUpdate
        {
            get;
            set;
        }
        string LastUserUpdateName
        {
            get;
            set;
        }
        int IdAssociate
        {
            get;
            set;
        }
        string BudgetType
        {
            get;
            set;
        }
        string BudgetVersion
        {
            get;
            set;
        }
        string ActiveState
        {
            get;
            set;
        }
        bool IsFromFollowUp
        {
            get;
            set;
        }
    }
}
