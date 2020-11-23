using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using Inergy.Indev3.ApplicationFramework.Timing_Interco;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    /// <summary>
    /// List of IntercoLogicalKey objects
    /// </summary>
    public class WPList : List<IntercoLogicalKey>
    {
        public new bool Contains(IntercoLogicalKey searchItem)
        {
            foreach (IntercoLogicalKey key in this)
            {
                if (key.IdProject == searchItem.IdProject && key.IdPhase == searchItem.IdPhase && key.IdWP == searchItem.IdWP)
                    return true;
            }
            return false;
        }
    }
    public class BudgetColumnsCalculationsList : Dictionary<string, EBudgetCalculationMethod>
    {
    }
}
