using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Security.Principal;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using System.Collections.Generic;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.UI
{
    public partial class UserControls_Visuals_BreadCrumb : IndBaseControl
    {
        #region Event Handlers
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string pageUrl = Page.Request.Url.ToString();
                lblWelcome.Text = GetBreadCrumbText(pageUrl);
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
        }
        #endregion Event Handlers

        #region Private Methods
        private string WelcomeMessage()
        {
            CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.CURRENT_USER);
            return "Welcome " + (currentUser == null ? String.Empty : currentUser.AssociateName);
        }

        /// <summary>
        /// Gets the text to be displayed in the breadcrumb, depending on the url of the page
        /// </summary>
        /// <param name="pageUrl">the page url</param>
        /// <returns>the text to be displayed in the breadcrumb</returns>
        private string GetBreadCrumbText(string pageUrl)
        {
            Dictionary<string, string> breadCrumbMapping;
            if (Session[SessionStrings.BREADCRUMB_VALUES] == null)
            {
                breadCrumbMapping = BreadCrumbUtils.BuildBreadCrumbMapping();
                Session[SessionStrings.BREADCRUMB_VALUES] = breadCrumbMapping;
            }
            else
            {
                breadCrumbMapping = (Dictionary<string, string>)Session[SessionStrings.BREADCRUMB_VALUES];
            }

            foreach (string breadCrumbMappingKey in breadCrumbMapping.Keys)
            {
                //If the page url contains the key in the mapping table
                if (pageUrl.ToLower().Contains(breadCrumbMappingKey.ToLower()))
                {
                    //If the value is "Welcome", show the welcome message
                    if (breadCrumbMapping[breadCrumbMappingKey.ToLower()] == "Welcome")
                        return WelcomeMessage();
                    //This handles special cases. For now, only 1 special case exists, when a specific budget (initial, revised or
                    //reforecast) is viewed when coming from follow-up. In this case, the breadcrumb value should be the one
                    //of follow-up budget, not the one of the specific budget. This is a kind of hack but because the breadcrumb is not
                    //really a breadcrumb but rather shows the page the user is viewing and because there is a single exception from the rule
                    // (this one), the code will not be changed right now. If the breadcrumb will become more complex, another implementation
                    //will be used.
					if (pageUrl.ToLower().Contains("budget.aspx") && !(pageUrl.ToLower().Contains("movebudget.aspx")) || pageUrl.ToLower().Contains("isfromfollowup"))
						return BreadCrumbUtils.GetBudgetSpecificBreadCrumbText(pageUrl.ToLower(), breadCrumbMapping, breadCrumbMappingKey.ToLower());

                    //Else show the breadcrumb text
                    return breadCrumbMapping[breadCrumbMappingKey.ToLower()];
                }
            }
            return "Unknown Page";
        }
        #endregion Private Methods
    }
}