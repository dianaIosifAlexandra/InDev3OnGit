using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.WebFramework.Utils
{
    public static class SessionStrings
    {       
        /// <summary>
        /// Used for storing into session a Project object
        /// </summary>
        public const string CURRENT_PROJECT = "CurrentProject";
        /// <summary>
        /// Used for storing into session an Associate object (when adding/editing a core team member)
        /// </summary>
        public const string CORE_TEAM_ASSOCIATE = "CoreTeamAssociate";
        /// <summary>
        /// Used for storing into session the current user that uses the application
        /// </summary>
        public const string CURRENT_USER = "CurrentUser";
        /// <summary>
        /// Used for storing into session exceptions
        /// </summary>
        public const string ERROR_MESSAGE = "ErrorMessage";
        /// <summary>
        /// Used to store the parameters that are passed to the edit pop-up window
        /// </summary>
        public const string EDIT_PARAMETERS = "EditParameters";
        /// <summary>
        /// Used to store the name of the ascx used for viewing an entity   
        /// </summary>
        public const string VIEW_CONTROL = "ViewControl";
        /// <summary>
        /// Used to store the name of the ascx used for adding/editing an entity   
        /// </summary>
        public const string EDIT_CONTROL = "EditControl";
        /// <summary>
        /// Used to store the id's of selected WP
        /// </summary>
        public const string SELECTED_WP = "SelectedWP";
        /// <summary>
        /// Represents a pair (int, int) where both arguments are YearMonth
        /// </summary>
        public const string DATE_INTERVAL = "YearMonthInterval";
        /// <summary>
        /// Used to store a percent value
        /// </summary>
        public const string PERCENT = "Percent";
        /// <summary>
        /// Used to store the user settings for the current user
        /// </summary>
        public const string USER_SETTINGS = "UserSettings";
        /// <summary>
        /// Holds the BreadCrumbValues hashtable containing the mapping between pages and the breadcrumb text
        /// </summary>
        public const string BREADCRUMB_VALUES = "BreadCrumbValues";
        /// <summary>
        /// This holds the current CostCenter selected from the CostCenterFilter
        /// </summary>
        public const string CURRENT_COSTCENTER = "CurrentCostCenter";
        /// <summary>
        /// Holds the current ConnectionManager object
        /// </summary>
        public const string CONNECTION_MANAGER = "ConnectionManager";
        /// <summary>
        /// Holds the application settings
        /// </summary>
        public const string APPLICATION_SETTINGS = "ApplicationSettings";
        /// <summary>
        /// Holds a BudgetPreselectionLayout object containing the currently selected budget layout
        /// </summary>
        public const string BUDGET_LAYOUT = "BudgetPreselectionLayout";
        /// <summary>
        /// Holds a BudgetOtherCosts object
        /// </summary>
        public const string INITIAL_OTHER_COSTS = "BudgetOtherCosts";
        /// <summary>
        /// Holds a list of BudgetOtherCosts objects
        /// </summary>
        public const string INITIAL_OTHER_COSTS_LIST = "BudgetOtherCostsList";

        /// <summary>
        /// Holds the state of initial budget
        /// </summary>
        public const string BUDGET_INITIAL_STATE = "BudgetInitialState";

        /// <summary>
        /// Holds the state for revised budget
        /// </summary>
        public const string BUDGET_REVISED_STATE = "BudgetReviseState";

        /// <summary>
        /// Holds a BudgetRevisedOtherCosts object
        /// </summary>
        public const string REVISED_OTHER_COSTS = "RevisedOtherCosts";
        /// <summary>
        /// Holds a list of BudgetRevisedOtherCosts objects
        /// </summary>
        public const string REVISED_OTHER_COSTS_LIST = "RevisedOtherCostsList";

        /// <summary>
        /// Holds the currency converter
        /// </summary>
        public const string CURRENCY_CONVERTER = "CurrencyConverter";

        /// <summary>
        /// Holds a list of CostCenterKey objects which represent the cost centers in edit mode, before postback. Used to restore
        /// the correct cost centers that are in edit mode, after an add or delete cost center operation
        /// </summary>
        public const string EDITED_COST_CENTERS = "EditedCostCenters";

        /// <summary>
        /// Specifies what WPs will be updated when a CC is added
        /// </summary>
        public const string ADD_CC_TO_TARGET = "ADD_CC_TO_TARGET";
        
        /// <summary>
        /// Key used to hold in the session the id of the coutry of the current user, in case there are 2 or more countries for the same inergy
        /// login
        /// </summary>
        public const string CURRENT_USER_COUNTRY_ID = "CurrentUserCountryId";
        /// <summary>
        /// The inergy login of the current user
        /// </summary>
        public const string INERGY_LOGIN = "InergyLogin";
        /// <summary>
        /// Temporarily holds a CurrentUser object into session (this happens when changing the current user in the "select country" 
        /// pop-up when in user settings)
        /// </summary>
        public const string TEMP_CURRENT_USER = "TempCurrentUser";
        /// <summary>
        /// Holds an array containing the 7 default accounts created when an inergy country is added into the application
        /// </summary>
        public const string DEFAULT_ACCOUNTS = "DefaultAccounts";
        /// <summary>
        ///  Holds an array containing the codes of the exportable catalogs
        /// </summary>
        public const string EXPORTABLE_CATALOG_CODES = "ExportableCatalogCodes";
        /// <summary>
        /// Holds a dictionary containing mappings between class names and catalogue names
        /// </summary>
        public const string ENTITY_MAPPING = "EntityMapping";
        /// <summary>
        /// Holds a dictionary containing mappings between view control names and the current page index of the grid in the control
        /// </summary>
        public const string PAGE_NUMBER_MAPPING = "PageNumberMapping";
        /// <summary>
        /// Holds an IndFilterItem object in session
        /// </summary>
        public const string FILTER_ITEM = "FilterItem";
        /// <summary>
        /// Holds the filter expression string in session
        /// </summary>
        public const string FILTER_EXPRESSION = "FilterExpression";

    }
}
