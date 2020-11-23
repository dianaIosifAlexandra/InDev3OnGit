using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    public interface IBudget : IGenericEntity
    {
        int IdProject
        {   get;
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
        int IdAssociate
        {
            get;
            set;
        }
        bool IsAssociateCurrency
        {
            get;
            set;
        }
        /// <summary>
        /// Id of the associate viewing the budget.
        /// In case of normal evidence this is the same as IdAssociate. In case of Follow-up, 
        /// it may a different associate
        /// </summary>
        int IdAssociateViewer
        {
            get;
            set;
        }
    }
}
