using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.Utils
{
    /// <summary>
    /// Contains utilities used by the application entities
    /// </summary>
    public static class EntityUtils
    {
        /// <summary>
        /// Builds a dictionary containing mappings between class names and catalogue names
        /// </summary>
        public static Dictionary<string, string> CreateCatalogueMapping()
        {
            Dictionary<string, string> entityMapping = new Dictionary<string, string>();
            try
            {
                entityMapping.Add("Associate", "Associate Catalogue");
                entityMapping.Add("CostCenter", "Cost Center Catalogue");
                entityMapping.Add("CostIncomeType", "Cost Income Type Catalogue");
                entityMapping.Add("Country", "Country Catalogue");
                entityMapping.Add("Currency", "Currency Catalogue");
                entityMapping.Add("Department", "Department Catalogue");
                entityMapping.Add("Function", "Function Catalogue");
                entityMapping.Add("GlAccount", "G/L Account Catalogue");
                entityMapping.Add("HourlyRate", "Hourly Rate Catalogue");
                entityMapping.Add("InergyLocation", "Inergy Location Catalogue");
                entityMapping.Add("Owner", "Program Owner Catalogue");
                entityMapping.Add("OwnerType", "Owner Type Catalogue");
                entityMapping.Add("Program", "Program Catalogue");
                entityMapping.Add("Project", "Project Catalogue");
                entityMapping.Add("ProjectType", "Project Type Catalogue");
                entityMapping.Add("Region", "Region Catalogue");
                entityMapping.Add("WorkPackage", "Work Package Catalogue");
                entityMapping.Add("WorkPackageTemplate", "Work Package Template Catalogue");
                entityMapping.Add("ProjectCoreTeamMember", "Project Core Team");
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return entityMapping;
        }

        /// <summary>
        /// Builds a dictionary containing mappings between view control names and the current page index of the grid in the control
        /// </summary>
        /// <returns></returns>
        public static Dictionary<string, int> GetPageNumberMapping()
        {
            Dictionary<string, int> pageNumberMapping = new Dictionary<string, int>();
            try
            {
                pageNumberMapping.Add(ApplicationConstants.MODULE_ASSOCIATE, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_COST_CENTER, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_COUNTRY, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_CURRENCY, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_NOTIMPLEMENTED, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_DEPARTMENT, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_GL_ACCOUNT, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_HOURLY_RATE, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_INERGY_LOCATION, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_OWNER, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_PROGRAM, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_PROJECT, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_PROJECT_TYPE, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_REGION, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_WORK_PACKAGE, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_CORE_TEAM, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_PROFILE, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_DATA_LOGS, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_ANNUAL_LOGS, 0);
                pageNumberMapping.Add(ApplicationConstants.MODULE_WORK_PACKAGE_TEMPLATE, 0);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return pageNumberMapping;
        }

        /// <summary>
        /// Returns a list containing the 7 default accounts that are added to each inergy country when it is added in the db
        /// </summary>
        /// <param name="connectionManager"></param>
        /// <returns></returns>
        public static List<CostIncomeType> GetDefaultAccounts(object connectionManager)
        {
            List<CostIncomeType> defaultAccounts = new List<CostIncomeType>();

            try
            {
                CostIncomeType costIncomeType = new CostIncomeType(connectionManager);
                DataSet dsDefaultAccounts = costIncomeType.GetAll();

                foreach (DataRow row in dsDefaultAccounts.Tables[0].Rows)
                {
                    costIncomeType = new CostIncomeType(row, connectionManager);
                    defaultAccounts.Add(costIncomeType);
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }

            return defaultAccounts;
        }

        /// <summary>
        /// Returns a list containing the codes of all catalogs that can be exported (csv export)
        /// </summary>
        /// <returns></returns>
        public static List<String> GetExportableCatalogs()
        {
            List<String> exportableCatalogCodes = new List<String>();
            try
            {
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_ASSOCIATE);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_COST_CENTER);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_COUNTRY);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_DEPARTMENT);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_GL_ACCOUNT);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_HOURLY_RATE);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_INERGY_LOCATION);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_OWNER);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_PROGRAM);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_PROJECT);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_PROJECT_TYPE);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_REGION);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_WORK_PACKAGE);
                exportableCatalogCodes.Add(ApplicationConstants.MODULE_WORK_PACKAGE_TEMPLATE);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return exportableCatalogCodes;
        }
    }
}
