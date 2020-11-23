using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.ApplicationFramework
{
    /// <summary>
    /// Class holding the application constants 
    /// </summary>
    public static class ApplicationConstants
    {
        public const int INT_NULL_VALUE = -1;
        public const int SHORT_NULL_VALUE = -1;
        public const decimal DECIMAL_NULL_VALUE = decimal.MinValue;
        public const string MIN_DATE_CATALOGS = "1980-01-01";
        public const int INT_YEAR_MONTH_NOT_VALID = -777;
        //The minimum value that sql server stores for yearmonth fields
        public const int YEAR_MONTH_SQL_MIN_VALUE = 190001;
        public const int YEAR_SQL_MIN_VALUE = 1900;
        public const int YEAR_AHEAD_TO_INCLUDE = 10;
        public const string SEPARATOR_SQL = "|";
        public const int INT_NULL_VALUE_FOR_VALUE_FIELDS = int.MinValue;

        public const string NOT_AVAILABLE = "N/A";

        //Constants used for authorization (every menu item will have a module name associated and access to it will be permitted or not,
        //depending on the role of the current user)
        public const string MODULE_ASSOCIATE = "ASC";
        public const string MODULE_CORE_TEAM = "CRT";
        public const string MODULE_COST_CENTER = "CTC";
        public const string MODULE_COUNTRY = "CTY";
        public const string MODULE_CURRENCY = "CUR";
        public const string MODULE_DEPARTMENT = "DEP";
        public const string MODULE_EXCHANGE_RATES = "EXR";
        public const string MODULE_FOLLOW_UP = "FOL";
        public const string MODULE_GL_ACCOUNT = "GLA";
        public const string MODULE_HOURLY_RATE = "HRA";
        public const string MODULE_INITIAL = "INI";
        public const string MODULE_INERGY_LOCATION = "INL";
        public const string MODULE_NOTIMPLEMENTED = "NIM";
        public const string MODULE_OWNER = "OWN";
        public const string MODULE_PROFILE = "PRF";
        public const string MODULE_PROGRAM = "PRG";
        public const string MODULE_PROJECT = "PRJ";
        public const string MODULE_REFORECAST = "REF";
        public const string MODULE_REGION = "REG";
        public const string MODULE_REPORTING = "REP";
        public const string MODULE_REVISED = "REV";
        public const string MODULE_PROJECT_SELECTION = "SEL";
        public const string MODULE_STATUS = "STS";
        public const string MODULE_TIMING_INTERCO = "TIN";
        public const string MODULE_TECHNICAL_SETTINGS = "TST";
        public const string MODULE_PROJECT_TYPE = "TYP";
        public const string MODULE_UPLOAD = "UPL";
        public const string MODULE_DATA_LOGS = "DLG";
        public const string MODULE_DATA_STATUS = "DST";
        public const string MODULE_USER_SETTINGS = "UST";
        public const string MODULE_WORK_PACKAGE = "WKP";
        public const string MODULE_WORK_PACKAGE_TEMPLATE = "WPT";
        public const string MODULE_ANNUAL_UPLOAD = "ANU";
        public const string MODULE_ANNUAL_DOWNLOAD = "AND";
        public const string MODULE_ANNUAL_LOGS = "ANL";
        public const string MODULE_ANNUAL_STATUS = "ANS";
                
        //Id's for the project functions
        public const int PROJECT_FUNCTION_PROGRAM_MANAGER = 1;
        public const int PROJECT_FUNCTION_PAE = 2;
        public const int PROJECT_FUNCTION_IE = 3;
        public const int PROJECT_FUNCTION_QE = 4;
        public const int PROJECT_FUNCTION_PB = 5;
        public const int PROJECT_FUNCTION_CSAE = 9;
        public const int PROJECT_FUNCTION_SALES = 6;
        public const int PROJECT_FUNCTION_PROGRAM_ASSISTANT = 7;
        public const int PROJECT_FUNCTION_PROGRAM_READER = 8;

        public const int COST_CENTER_WITHOUT_HOURLYRATE_CODE_FROM_SP = 1000;
        public const int SKIP_START_END_PHASE_VALIDATION_HOURS = -1000;
        public const int SKIP_START_END_PHASE_VALIDATION_COSTS = -2000;
        public const int SKIP_START_END_PHASE_VALIDATION_SALES = -3000;

        //Id's for the roles in the application
        public const int ROLE_BUSINESS_ADMINISTATOR = 1;
        public const int ROLE_TECHNICAL_ADMINISTATOR = 2;
        public const int ROLE_FINANCIAL_TEAM = 3;
        public const int ROLE_PROGRAM_MANAGER = 4;
        public const int ROLE_CORE_TEAM = 5;
        public const int ROLE_FUNCTIONAL_MANAGER = 6;
        public const int ROLE_PROGRAM_READER = 7;
        public const int ROLE_KEY_USER = 8;

        public const int VIEW_ASCX_INDEX = 0;
        public const int EDIT_ASCX_INDEX = 1;

        //User settings constants
        public const int DEFAULT_DATAGRID_PAGESIZE = 15;

        //Constants for project selection
        public const string SHOW_ONLY_ACTIVE_PROJECTS = "A";
        public const string SHOW_ONLY_INACTIVE_PROJECTS = "I";
        public const string SHOW_ALL_PROJECTS = "T";
        public const string ORDER_BY_CODE = "C";
		public const string ORDER_BY_NAME = "N";

        //Constants for CC selection
        public const string ADD_CC_TO_CURRENT_WP = "Current WP";
        public const string ADD_CC_TO_MY_WPS = "My WPs";
        public const string ADD_CC_TO_ALL_WPS = "All WPs";

        public static Dictionary<string, string[]> WINDOW_CODES = null;

        public const string DEFAULT_FILE_NAME = "CatalogueExport.csv";
        public const string DEFAULT_EXPORT_FILE_NAME = "AnnualBudgetExport.csv";
		public const string DEFAULT_BUDGET_EXPORT_FILE_NAME = "BudgetExport.csv";

        public const string DEFAULT_INITIAL_BUDGET_FILE_NAME = "InitialBudget#.csv";
        public const string DEFAULT_REVISED_BUDGET_FILE_NAME = "RevisedBudget#.csv";

        //Constant used for definition of the characters that are allowed to be inserted in textboxes
        public const string ALLOWED_TEXTBOX_CHARACTERS = "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";

        //region BUDGET STATES

        public const string BUDGET_STATE_NONE = "N";
        public const string BUDGET_STATE_UPLOADED = "U";
        public const string BUDGET_STATE_OPEN = "O";
        public const string BUDGET_STATE_WAITING_APPROVAL = "W";
        public const string BUDGET_STATE_APPROVED = "A";
        public const string BUDGET_STATE_VALIDATED = "V";

        //region Budget versions
        public const string BUDGET_VERSION_IN_PROGRESS = "InProgress";
        public const string BUDGET_VERSION_RELEASED = "Released";
        public const string BUDGET_VERSION_PREVIOUS = "Previous";

        //region Budget types
        public const string BUDGET_TYPE_INITIAL = "Initial";
        public const string BUDGET_TYPE_REVISED = "Revised";
        public const string BUDGET_TYPE_TOCOMPLETION = "Reforecast";

        //It is 'N' (new), because this is how it is passed to the function that calculates the generation
        public const string BUDGET_VERSION_IN_PROGRESS_CODE = "N";
        //It is 'C' (current), because this is how it is passed to the function that calculates the generation
        public const string BUDGET_VERSION_RELEASED_CODE = "C";
        public const string BUDGET_VERSION_PREVIOUS_CODE = "P";

        public const string DATE_TIME_FORMAT_STRING = "{0:dd/MM/yyyy}";

        public const string INITIAL_BUDGET_DATASET = "InitialBudgetDS";

        public const string HOURLY_RATE_MASS_MULTIPLE_CURRENCY = "Multiple currency";

        public const string BUDGET_USER_CURRENCY_WARNING_MESSAGE = "The numbers displayed could be inaccurate because of the exchange rate conversion and rounding";
        public const string BUDGET_LOCAL_CURRENCY_WARNING_MESSAGE = "No total amount displayed in local currency mode";

        public const string REPORTING_MENU_FILE = "~/MenuReporting.xml";
        public const string REPORTING_MENU_ITEM = "/MenuReporting/MenuItem";
        public const int REPORTING_MAXIMUM_LEVEL = 4;

		public const int SPLIT_OTHER_COSTS_ALGORYTHM = 2; //1 = Initial split algorythm (uniform split over the WP period); 2 = All the cost is set on the last month of the WP period
		public const int SPLIT_OTHER_COSTS_ALGORYTHM_UNIFORM = 1;
		public const int SPLIT_OTHER_COSTS_ALGORYTHM_LAST_MONTH = 2;

        /// <summary>
        /// Codes a value indicating that a budget was accessed directly, not from follow-up
        /// </summary>
        public const int BUDGET_DIRECT_ACCESS = -2;

        public const int ID_EXCHANGE_RATE_FOR_BUDGET = 2;

        static ApplicationConstants()
        {
            AddModuleCodes();           
        }

        /// <summary>
        /// Get the ASCX path corresponding to the given module code for the selected index
        /// </summary>
        /// <param name="ascxCode"></param>
        /// <returns></returns>
        public static string GetASCXPath(string ascxCode, int ascxIndex)
        {
            //Verify if the key exists in the list
            if (!WINDOW_CODES.ContainsKey(ascxCode))
                return WINDOW_CODES[MODULE_NOTIMPLEMENTED][ascxIndex];
            if (WINDOW_CODES[ascxCode].Length < ascxIndex + 1)
                throw new IndException(ApplicationMessages.EXCEPTION_ASCX_NOT_FOUND);

            return WINDOW_CODES[ascxCode][ascxIndex];
        }
        /// <summary>
        /// Get the first ASCX path corresponding to the given module code
        /// </summary>
        /// <param name="ascxCode"></param>
        /// <returns></returns>
        public static string GetASCXPath(string ascxCode)
        {
            return GetASCXPath(ascxCode, 0);
        }

        /// <summary>
        /// Fills the list that contains the module codes for the view windows
        /// </summary>
        public static void AddModuleCodes()
        {
            WINDOW_CODES = new Dictionary<string, string[]>();

            WINDOW_CODES.Add(MODULE_ASSOCIATE, new string[] { "~/UserControls/Catalogs/Associate/AssociateView.ascx", "~/UserControls/Catalogs/Associate/AssociateEdit.ascx" });
            WINDOW_CODES.Add(MODULE_CORE_TEAM, new string[] { "~/UserControls/Budget/ProjectCoreTeamMember/ProjectCoreTeamMemberView.ascx", "~/UserControls/Budget/ProjectCoreTeamMember/ProjectCoreTeamMemberEdit.ascx" });
            WINDOW_CODES.Add(MODULE_COST_CENTER, new string[] { "~/UserControls/Catalogs/CostCenter/CostCenterView.ascx", "~/UserControls/Catalogs/CostCenter/CostCenterEdit.ascx" });
            WINDOW_CODES.Add(MODULE_COUNTRY, new string[] { "~/UserControls/Catalogs/Country/CountryView.ascx", "~/UserControls/Catalogs/Country/CountryEdit.ascx" });
            WINDOW_CODES.Add(MODULE_CURRENCY, new string[] { "~/UserControls/Catalogs/Currency/CurrencyView.ascx", "~/UserControls/Catalogs/Currency/CurrencyEdit.ascx" });
            WINDOW_CODES.Add(MODULE_DEPARTMENT, new string[] { "~/UserControls/Catalogs/Department/DepartmentView.ascx", "~/UserControls/Catalogs/Department/DepartmentEdit.ascx" });
            //WINDOW_CODES.Add(MODULE_EXCHANGE_RATE, new string[] { "~/UserControls/Catalogs/ExchangeRate/ExchangeRateView.ascx", "~/UserControls/Catalogs/ExchangeRate/ExchangeRateEdit.ascx" });
            WINDOW_CODES.Add(MODULE_FOLLOW_UP, null);
            WINDOW_CODES.Add(MODULE_GL_ACCOUNT, new string[] { "~/UserControls/Catalogs/GLAccount/GLAccountView.ascx","~/UserControls/Catalogs/GLAccount/GLAccountEdit.ascx" });
            WINDOW_CODES.Add(MODULE_HOURLY_RATE, new string[] { "~/UserControls/Catalogs/HourlyRate/HourlyRateView.ascx", "~/UserControls/Catalogs/HourlyRate/HourlyRateEdit.ascx" });
            WINDOW_CODES.Add(MODULE_INITIAL, null);
            WINDOW_CODES.Add(MODULE_INERGY_LOCATION, new string[] { "~/UserControls/Catalogs/InergyLocation/InergyLocationView.ascx", "~/UserControls/Catalogs/InergyLocation/InergyLocationEdit.ascx" });
            WINDOW_CODES.Add(MODULE_NOTIMPLEMENTED, new string[] { "~/UserControls/NotImplemented.ascx",null });
            WINDOW_CODES.Add(MODULE_OWNER, new string[] { "~/UserControls/Catalogs/Owner/OwnerView.ascx", "~/UserControls/Catalogs/Owner/OwnerEdit.ascx" });
            WINDOW_CODES.Add(MODULE_PROGRAM, new string[] { "~/UserControls/Catalogs/Program/ProgramView.ascx", "~/UserControls/Catalogs/Program/ProgramEdit.ascx" });
            WINDOW_CODES.Add(MODULE_PROJECT, new string[] { "~/UserControls/Catalogs/Project/ProjectView.ascx", "~/UserControls/Catalogs/Project/ProjectEdit.ascx" });
            WINDOW_CODES.Add(MODULE_PROFILE, new string[] { "~/UserControls/Profile/Profile.ascx",null });
            WINDOW_CODES.Add(MODULE_PROJECT_TYPE, new string[] { "~/UserControls/Catalogs/ProjectType/ProjectTypeView.ascx", "~/UserControls/Catalogs/ProjectType/ProjectTypeEdit.ascx" });
            WINDOW_CODES.Add(MODULE_REFORECAST, null);
            WINDOW_CODES.Add(MODULE_REGION, new string[] { "~/UserControls/Catalogs/Region/RegionView.ascx", "~/UserControls/Catalogs/Region/RegionEdit.ascx" });
            WINDOW_CODES.Add(MODULE_REPORTING, null);
            WINDOW_CODES.Add(MODULE_REVISED, null);
            WINDOW_CODES.Add(MODULE_PROJECT_SELECTION, null);
            WINDOW_CODES.Add(MODULE_STATUS, null);
            WINDOW_CODES.Add(MODULE_TIMING_INTERCO, new string[] { "~/UserControls/Budget/Interco/TimingAndInterco.ascx" ,null});
            WINDOW_CODES.Add(MODULE_TECHNICAL_SETTINGS, new string[] { "~/UserControls/TechnicalSettings/TechnicalSettingsView.ascx", null });
            WINDOW_CODES.Add(MODULE_USER_SETTINGS, new string[] { "~/UserControls/UserSettings/UserSettings.ascx",null });
            WINDOW_CODES.Add(MODULE_WORK_PACKAGE, new string[] { "~/UserControls/Catalogs/WorkPackage/WorkPackageView.ascx", "~/UserControls/Catalogs/WorkPackage/WorkPackageEdit.ascx" });
            WINDOW_CODES.Add(MODULE_WORK_PACKAGE_TEMPLATE, new string[] { "~/UserControls/Catalogs/WorkPackageTemplate/WorkPackageTemplateView.ascx", "~/UserControls/Catalogs/WorkPackageTemplate/WorkPackageTemplateEdit.ascx" });
            WINDOW_CODES.Add(MODULE_UPLOAD, null);
            WINDOW_CODES.Add(MODULE_DATA_LOGS, new string[] { "~/UserControls/DataUpload/Upload/DataLogs.ascx", "~/UserControls/DataUpload/Upload/DataLogsDetail.ascx" });
            WINDOW_CODES.Add(MODULE_ANNUAL_LOGS, new string[] { "~/UserControls/AnnualBudget/DataLogs.ascx", "~/UserControls/AnnualBudget/DataLogsDetail.ascx" });
        }
    }
}
