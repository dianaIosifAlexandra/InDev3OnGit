using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.BusinessLogic.Authorization;

namespace Inergy.Indev3.WebFramework.Utils
{
    /// <summary>
    /// Class that manages the access to the session
    /// </summary>
    public static class SessionManager
    {
        #region Public Methods
        /// <summary>
        /// Gets the value from the session object but does not redirect to default page if session is null
        /// </summary>
        /// <param name="sender">calling page</param>
        /// <param name="key">the key from the session whose value is returned</param>
        /// <returns>the value from the session or null if the session has expired</returns>
        public static object GetSessionValueNoRedirect(Page sender, string key)
        {
            if (!(sender is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }
            
            return GetSessionValue((IndBasePage)sender, key, false);
        }

        /// <summary>
        /// Gets the value from the session object and redirects to default page if session is null
        /// </summary>
        /// <param name="sender">calling page</param>
        /// <param name="key">the key from the session whose value is returned</param>
        /// <returns>the value from the session or null if the session has expired</returns>
        public static object GetSessionValueRedirect(Page sender, string key)
        {
            if (!(sender is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }
            
            return GetSessionValue((IndBasePage)sender, key, true);
        }

        public static void SetSessionValue(Page sender, string key, object value)
        {
            if (!(sender is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }
            
            try
            {
                sender.Session[key] = value;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public static void RemoveValueFromSession(Page sender, string key)
        {
            if (!(sender is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }
            
            try
            {
                sender.Session.Remove(key);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public static object GetConnectionManager(Page page)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }
            
            return GetSessionValue(page as IndBasePage, SessionStrings.CONNECTION_MANAGER, false);
        }
        public static CurrentUser GetCurrentUser(Page page)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }
            
            return GetSessionValue(page as IndBasePage, SessionStrings.CURRENT_USER, true) as CurrentUser;
        }
        public static CurrentProject GetCurrentProject(Page page)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }

            return GetSessionValue(page as IndBasePage, SessionStrings.CURRENT_PROJECT, true) as CurrentProject;
        }

        public static CurrencyConverter GetCurrencyConverter(Page page)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }

            CurrencyConverter currencyConverter;

            currencyConverter = GetSessionValue(page as IndBasePage, SessionStrings.CURRENCY_CONVERTER, false) as CurrencyConverter;
            if (currencyConverter == null)
                currencyConverter = new CurrencyConverter(GetConnectionManager(page));

            return currencyConverter;
        }

        /// <summary>
        /// Get the other costs object from session if it exist in the list
        /// </summary>
        /// <param name="page">The page that has access to the session</param>
        /// <param name="otherCosts">The object that contains the key</param>
        /// <returns></returns>
        public static InitialBudgetOtherCosts GetOtherCost(Page page, InitialBudgetOtherCosts otherCosts)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }

            List<InitialBudgetOtherCosts> otherCostsList = GetSessionValue(page as IndBasePage, SessionStrings.INITIAL_OTHER_COSTS_LIST, false) as List<InitialBudgetOtherCosts>;

            try
            {              
                if (otherCostsList == null)
                    return null;
                foreach (InitialBudgetOtherCosts currentOC in otherCostsList)
                {
                    if ((currentOC.IdProject == otherCosts.IdProject) && (currentOC.IdPhase == otherCosts.IdPhase) && (currentOC.IdWP == otherCosts.IdWP) && (currentOC.IdCostCenter == otherCosts.IdCostCenter))
                        return currentOC;
                }
                return null;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public static void AddOtherCosts(Page page, InitialBudgetOtherCosts otherCosts)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }

            List<InitialBudgetOtherCosts> otherCostsList = GetSessionValue(page as IndBasePage, SessionStrings.INITIAL_OTHER_COSTS_LIST, false) as List<InitialBudgetOtherCosts>;
            try
            {
                if (otherCostsList == null)
                {
                    otherCostsList = new List<InitialBudgetOtherCosts>();
                    otherCostsList.Add(otherCosts);
                }
                else
                {
                    InitialBudgetOtherCosts foundOtherCost = null;
                    foreach (InitialBudgetOtherCosts currentOC in otherCostsList)
                    {
                        if ((currentOC.IdProject == otherCosts.IdProject) && (currentOC.IdPhase == otherCosts.IdPhase) && (currentOC.IdWP == otherCosts.IdWP) && (currentOC.IdCostCenter == otherCosts.IdCostCenter))
                        {
                            foundOtherCost = currentOC;
                            break;
                        }
                    }
                    if (foundOtherCost == null)
                        otherCostsList.Add(otherCosts);
                    else
                    {
                        otherCostsList.Remove(foundOtherCost);
                        otherCostsList.Add(otherCosts);
                    }
                }
                SetSessionValue(page, SessionStrings.INITIAL_OTHER_COSTS_LIST, otherCostsList);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Removes otherCosts BudgetRevisedOtherCosts object from the list of BudgetRevisedOtherCosts objects
        /// </summary>
        /// <param name="page">calling page</param>
        /// <param name="otherCosts">object to be removed from the list</param>
        public static void RemoveInitialBudgetOtherCosts(Page page, InitialBudgetOtherCosts otherCosts)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }

            List<InitialBudgetOtherCosts> otherCostsList = (List<InitialBudgetOtherCosts>)GetSessionValue(page as IndBasePage, SessionStrings.INITIAL_OTHER_COSTS_LIST, false);
            try
            {
                if (otherCostsList == null)
                    return;
                //BudgetRevisedOtherCosts foundOtherCost = null;
                foreach (InitialBudgetOtherCosts currentOC in otherCostsList)
                {
                    if ((currentOC.IdProject == otherCosts.IdProject)
                        && (currentOC.IdPhase == otherCosts.IdPhase)
                        && (currentOC.IdWP == otherCosts.IdWP)
                        && (currentOC.IdCostCenter == otherCosts.IdCostCenter))
                    {
                        otherCostsList.Remove(currentOC);
                        SetSessionValue(page, SessionStrings.INITIAL_OTHER_COSTS, otherCostsList);
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Get the revised other costs object from session if it exist in the list
        /// </summary>
        /// <param name="page">The page that has access to the session</param>
        /// <param name="otherCosts">The object that contains the key</param>
        /// <returns></returns>
        public static RevisedBudgetOtherCosts GetRevisedOtherCost(Page page, RevisedBudgetOtherCosts otherCosts)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }

            List<RevisedBudgetOtherCosts> otherCostsList = (List<RevisedBudgetOtherCosts>)GetSessionValue(page as IndBasePage, SessionStrings.REVISED_OTHER_COSTS_LIST, false);
            try
            {
                if (otherCostsList == null)
                    return null;
                foreach (RevisedBudgetOtherCosts currentOC in otherCostsList)
                {
                    if ((currentOC.IdProject == otherCosts.IdProject)
                        && (currentOC.IdPhase == otherCosts.IdPhase)
                        && (currentOC.IdWP == otherCosts.IdWP)
                        && (currentOC.IdCostCenter == otherCosts.IdCostCenter))
                        return currentOC;
                }
                return null;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Adds a BudgetRevisedOtherCosts to the list of BudgetRevisedOtherCosts objects
        /// </summary>
        /// <param name="page"></param>
        /// <param name="otherCosts"></param>
        public static void AddRevisedOtherCosts(Page page, RevisedBudgetOtherCosts otherCosts)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }

            List<RevisedBudgetOtherCosts> otherCostsList = (List<RevisedBudgetOtherCosts>)GetSessionValue(page as IndBasePage, SessionStrings.REVISED_OTHER_COSTS_LIST, false);
            try
            {
                if (otherCostsList == null)
                {
                    otherCostsList = new List<RevisedBudgetOtherCosts>();
                    otherCostsList.Add(otherCosts);
                }
                else
                {
                    RevisedBudgetOtherCosts foundOtherCost = null;
                    foreach (RevisedBudgetOtherCosts currentOC in otherCostsList)
                    {
                        if ((currentOC.IdProject == otherCosts.IdProject)
                            && (currentOC.IdPhase == otherCosts.IdPhase)
                            && (currentOC.IdWP == otherCosts.IdWP)
                            && (currentOC.IdCostCenter == otherCosts.IdCostCenter))
                        {
                            foundOtherCost = currentOC;
                            break;
                        }
                    }
                    if (foundOtherCost == null)
                        otherCostsList.Add(otherCosts);
                    else
                    {
                        otherCostsList.Remove(foundOtherCost);
                        otherCostsList.Add(otherCosts);
                    }
                }
                SetSessionValue(page, SessionStrings.REVISED_OTHER_COSTS_LIST, otherCostsList);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        /// <summary>
        /// Removes otherCosts BudgetRevisedOtherCosts object from the list of BudgetRevisedOtherCosts objects
        /// </summary>
        /// <param name="page">calling page</param>
        /// <param name="otherCosts">object to be removed from the list</param>
        public static void RemoveRevisedOtherCosts(Page page, RevisedBudgetOtherCosts otherCosts)
        {
            if (!(page is IndBasePage))
            {
                throw new IndException(ApplicationMessages.EXCEPTION_PAGE_NOT_INDBASEPAGE);
            }

            List<RevisedBudgetOtherCosts> otherCostsList = (List<RevisedBudgetOtherCosts>)GetSessionValue(page as IndBasePage, SessionStrings.REVISED_OTHER_COSTS_LIST, false);
            try
            {
                if (otherCostsList == null)
                    return;
                //BudgetRevisedOtherCosts foundOtherCost = null;
                foreach (RevisedBudgetOtherCosts currentOC in otherCostsList)
                {
                    if ((currentOC.IdProject == otherCosts.IdProject)
                        && (currentOC.IdPhase == otherCosts.IdPhase)
                        && (currentOC.IdWP == otherCosts.IdWP)
                        && (currentOC.IdCostCenter == otherCosts.IdCostCenter))
                    {
                        otherCostsList.Remove(currentOC);
                        SetSessionValue(page, SessionStrings.REVISED_OTHER_COSTS_LIST, otherCostsList);
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion Public Methods

        #region Private Methods
        /// <summary>
        /// Gets the value from the session object, where the key value is key and the page from which this method is called is sender.
        /// If redirect flag is true and if the session object is null or the object in the session whose key is key is null, 
        /// the sender page will be redirected to the Default page. 
        /// </summary>
        /// <param name="sender">calling page</param>
        /// <param name="key">the key from the session whose value is returned</param>
        /// <param name="redirect">if true, page will be redirected when session has expired</param>
        /// <returns>the value from the session or null if the session has expired</returns>
        private static object GetSessionValue(IndBasePage sender, string key, bool redirect)
        {
            if (sender.Session == null || sender.Session.Count == 0 || sender.Session[key] == null)
            {
                if (redirect)
                {
                    if (sender is IndPopUpBasePage)
                    {
                        if (!sender.ClientScript.IsClientScriptBlockRegistered(typeof(IndBasePage), "SessionExpirationClose"))
                        {
                            sender.ClientScript.RegisterClientScriptBlock(typeof(IndBasePage), "SessionExpirationClose", "window.returnValue = -1; window.close();", true);
                            return null;
                        }
                    }
                    else
                    {
                        sender.ResponseRedirect("~/Default.aspx?SessionExpired=1");
                    }
                }
            }
            return sender.Session[key];
        }
        #endregion Private Methods
    }
}
