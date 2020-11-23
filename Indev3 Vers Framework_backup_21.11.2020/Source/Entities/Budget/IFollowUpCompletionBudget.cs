using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    public interface IFollowUpCompletionBudget : IGenericEntity
    {
        int IdProject
        {
            get;
            set;
        }

        int IdGeneration
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
        string BudVersion
        {
            get;
            set;
        }
        int YearMonthActualData
        {
            get;
            set;
        }

		int IdAssociateNM
		{
			get;
			set;
		}

        int IdAssociateMovingBudget
        {
            get;
            set;
        }
    }
}
