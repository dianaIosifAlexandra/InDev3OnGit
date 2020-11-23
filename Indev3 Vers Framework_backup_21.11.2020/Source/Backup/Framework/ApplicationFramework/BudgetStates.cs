using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;

namespace Inergy.Indev3.ApplicationFramework
{
    public static class BudgetStates
    {
        /// <summary>
        /// method that returns the next state in budget state workflow
        /// </summary>
        /// <param name="stateCode"></param>
        /// <returns></returns>
        public static string GetBudgetNextState(string stateCode)
        {
            if (string.IsNullOrEmpty(stateCode))
                stateCode = "N";

            Dictionary<string,string> BudgetState = new Dictionary<string, string>();            
            BudgetState.Add("N", "O");
            BudgetState.Add("O", "W");
            BudgetState.Add("W", "A");
            BudgetState.Add("A", "V");

            if (BudgetState.ContainsKey(stateCode))
                return BudgetState[stateCode].ToString();
            else
                return null;
        }
    }
}
