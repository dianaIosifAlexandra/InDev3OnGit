using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.Utils
{
    /// <summary>
    /// Provides utils for the breadcrumb
    /// </summary>
    public static class BreadCrumbUtils
    {
        /// <summary>
        /// Builds the dictionary containing the mapping between pages and the text of the breadcrumb
        /// </summary>
        public static Dictionary<string, string> BuildBreadCrumbMapping()
        {
            Dictionary<string, string> breadCrumbMapping = new Dictionary<string, string>();

            try
            {
                breadCrumbMapping.Add("/default.aspx", "Welcome");
                breadCrumbMapping.Add("/catalogs.aspx?code=nim", "Not Implemented");

                breadCrumbMapping.Add("/wppreselection.aspx?code=ini", "Project Information > Budget > Work Package Preselection (Initial Budget)");
                breadCrumbMapping.Add("/wppreselection.aspx?code=rev", "Project Information > Budget > Work Package Preselection (Revised Budget)");
                breadCrumbMapping.Add("/wppreselection.aspx?code=ref", "Project Information > Budget > Work Package Preselection (Reforecast)");
				breadCrumbMapping.Add("/wppreselection.aspx?code=ini&isfromfollowup", "Project Information > Budget > Follow-up > Work Package Preselection (Initial Budget)");
				breadCrumbMapping.Add("/wppreselection.aspx?code=rev&isfromfollowup", "Project Information > Budget > Follow-up > Work Package Preselection (Revised Budget)");
				breadCrumbMapping.Add("/wppreselection.aspx?code=ref&isfromfollowup", "Project Information > Budget > Follow-up > Work Package Preselection (Reforecast)");
                breadCrumbMapping.Add("/initialbudget.aspx", "Project Information > Budget > Initial");
                breadCrumbMapping.Add("/revisedbudget.aspx", "Project Information > Budget > Revised");
                breadCrumbMapping.Add("/reforecastbudget.aspx", "Project Information > Budget > Reforecast");
                breadCrumbMapping.Add("/followupbudget.aspx", "Project Information > Budget > Follow-up");
				breadCrumbMapping.Add("/copybudget.aspx?code=rev", "Project Information > Budget > Follow-up > Move Budget (Revised)");
				breadCrumbMapping.Add("/copybudget.aspx?code=ref", "Project Information > Budget > Follow-up > Move Budget (Reforecast)");

                breadCrumbMapping.Add("/catalogs.aspx?code=crt", "Project Information > Information > Core Team");
                breadCrumbMapping.Add("/timingandinterco.aspx", "Project Information > Information > Timing & Interco");
                breadCrumbMapping.Add("/catalogs.aspx?code=wkp", "Project Information > Information > Work Package");
                
                breadCrumbMapping.Add("/catalogs.aspx?code=reg", "Administration > Organizational Data > Region");
                breadCrumbMapping.Add("/catalogs.aspx?code=cty", "Administration > Organizational Data > Country");
                breadCrumbMapping.Add("/catalogs.aspx?code=inl", "Administration > Organizational Data > Inergy Location");
                breadCrumbMapping.Add("/catalogs.aspx?code=dep", "Administration > Organizational Data > Department");
                breadCrumbMapping.Add("/catalogs.aspx?code=asc", "Administration > Organizational Data > Associate");

                breadCrumbMapping.Add("/catalogs.aspx?code=typ", "Administration > Project Data > Project Type");
                breadCrumbMapping.Add("/catalogs.aspx?code=own", "Administration > Project Data > Program Owner");
                breadCrumbMapping.Add("/catalogs.aspx?code=prg", "Administration > Project Data > Program");
                breadCrumbMapping.Add("/catalogs.aspx?code=prj", "Administration > Project Data > Project");
                breadCrumbMapping.Add("/catalogs.aspx?code=wpt", "Administration > Project Data > Work Package Template");

                breadCrumbMapping.Add("/catalogs.aspx?code=gla", "Administration > Financial Data > G/L Account");
                breadCrumbMapping.Add("/catalogs.aspx?code=ctc", "Administration > Financial Data > Cost Center");
                breadCrumbMapping.Add("/catalogs.aspx?code=hra", "Administration > Financial Data > Hourly Rate");
				breadCrumbMapping.Add("/exchangerates.aspx", "Administration > Financial Data > Exchange Rates");

                breadCrumbMapping.Add("/upload.aspx", "Data Upload > Actual > Upload");
                breadCrumbMapping.Add("/catalogs.aspx?code=dlg", "Data Upload > Actual > Logs");
                breadCrumbMapping.Add("/datastatus.aspx", "Data Upload > Actual > Status");

                breadCrumbMapping.Add("/annualbudget/annualdownload.aspx", "Data Upload > Annual Budget > Download");
                breadCrumbMapping.Add("/annualbudget/annualupload.aspx", "Data Upload > Annual Budget > Upload");
                breadCrumbMapping.Add("/catalogs.aspx?code=anl", "Data Upload > Annual Budget > Logs");
                breadCrumbMapping.Add("/annualbudget/annualdatastatus.aspx", "Data Upload > Annual Budget > Status");

                breadCrumbMapping.Add("/extract.aspx", "Extract > Criteria > Extract by Project");
                breadCrumbMapping.Add("/extractbyfunction.aspx", "Extract > Criteria > Extract by Function");

                breadCrumbMapping.Add("/catalogs.aspx?code=tst", "Settings > Technical Settings");
                breadCrumbMapping.Add("/catalogs.aspx?code=prf", "Settings > Profile");
                breadCrumbMapping.Add("/usersettings/usersettings.aspx", "Settings > User Settings");

                breadCrumbMapping.Add("/uploadinitialbudget/uploadinitialbudget.aspx", "Data Upload > Initial Budget > Upload");
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }

            return breadCrumbMapping;

        }

        /// <summary>
        /// Handles the special budget cases (for example, when viewing a specific budget from follow-up -> the
        /// breadcrumb text should be the one for Follow-up Budget, not the one for that specific budget)
        /// </summary>
        /// <param name="breadCrumbMapping"></param>
        /// <returns></returns>
        public static string GetBudgetSpecificBreadCrumbText(string pageUrl, Dictionary<string, string> breadCrumbMapping, string breadCrumbMappingKey)
        {
            try
            {
                //Split the url of the page in 2 parts, delimited by the "?" character which separates the url from the query string
                //parameters
                string[] pageUrlParts = pageUrl.Split(new string[] { "?" }, StringSplitOptions.RemoveEmptyEntries);

                //If the url does not contain the "?" character
                if (pageUrlParts.Length == 1)
                {
                    return breadCrumbMapping[breadCrumbMappingKey];
                }
                if (pageUrlParts.Length == 2)
                {
                    //Split the query string values
                    string[] queryStringArguments = pageUrlParts[1].Split(new string[] { "&" }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string queryStringArgument in queryStringArguments)
                    {
                        //Find the query string value containing the id associate
                        if (queryStringArgument.ToLower().Contains("idassociate"))
                        {
                            string[] idAssociateParts = queryStringArgument.Split(new string[] { "=" }, StringSplitOptions.RemoveEmptyEntries);
                            //If no value for the "idassociate" key was found, return the breadcrumb for the specific budget
                            if (idAssociateParts.Length == 1)
                                return breadCrumbMapping[breadCrumbMappingKey];
                            if (idAssociateParts.Length == 2)
                            {
                                int idAssociate;
                                //If the value for the id associate is not an int, return the breadcrumb for the specific budget
                                if (int.TryParse(idAssociateParts[1], out idAssociate) == false)
                                    return breadCrumbMapping[breadCrumbMappingKey];
                                //If the associate id is BUDGET_DIRECT_ACCESS, return the breadcrumb for the specific budget 
                                if (idAssociate == ApplicationConstants.BUDGET_DIRECT_ACCESS)
                                {
                                    return breadCrumbMapping[breadCrumbMappingKey];
                                }
                                //else, the page is from follow-up budget and return the follow-up budget breadcrumb value
                                else
                                {
									if (pageUrlParts[1].ToLower().Contains("isfromfollowup"))
									{
										breadCrumbMappingKey += "&isfromfollowup";
										return breadCrumbMapping[breadCrumbMappingKey];
									}
									else
									{
										return breadCrumbMapping["/followupbudget.aspx"];
									}	
                                }
                            }
                        }
                    }
                    //If the idassociate query string value was not found, return the breadcrumb for the specific budget
                    return breadCrumbMapping[breadCrumbMappingKey];
                }
                return "Unknown Page";
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
    }
}
