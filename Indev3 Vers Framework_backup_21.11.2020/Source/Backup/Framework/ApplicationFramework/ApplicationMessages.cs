using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.ApplicationFramework
{
    /// <summary>
    /// Class holding the application messages 
    /// </summary>
    public static class ApplicationMessages
    {
        //exception text constants
        public const string EXCEPTION_PAGE_EXPIRED = "Time Out, page has expired and you have been redirected to the home page.";
        public const string EXCEPTION_CONNECTION_MANAGER_NULL = "Internal Error. Could not load connection manager.";
        public const string EXCEPTION_CONSTRUCTOR_RETHROW_SQLEXCEPTION = "Internal Error. The constructor used to rethrow an SqlException is IndException(SqlException).";
        public const string EXCEPTION_CONSTRUCTOR_RETHROW_INDEXCEPTION = "Internal Error. The constructor used to rethrow an IndException is IndException(exc).";
        public const string EXCEPTION_ASCX_NOT_FOUND = "Internal Error. ASCX with the given index not found";
        public const string EXCEPTION_PANEL_NOT_EXIST = "Internal Error. Error panel does not exist";
        public const string EXCEPTION_NOT_HAVE_RIGHTS = "You do not have sufficient rights to access this application.<BR>Please contact your system administrator and communicate him your identity: ";
        public const string EXCEPTION_VIRTUAL_DATASOURCE_OF_TYPE_NOT_SUPPORTED = "Internal Error. VirtualDataSource of type {0} not supported.";
        public const string EXCEPTION_NULL_VALUE_FOR_TYPE_IS_NOT_DEFINED = "The null value for type {0} is not defined.";
        public const string EXCEPTION_SELECT_PROJECT = "Please select a Project.";
        public const string EXCEPTION_SELECT_COSTCENTER = "Please select a Cost Center.";
        public const string EXCEPTION_PROCEDURE_ALREADY_CONTAINS_PARAMETER = "Internal Error. Procedure {0} already contains parameter {1}.";
        public const string EXCEPTION_MUST_SET_ENTITY_PROPERTY = "Internal Error. You must set the Entity property of this control";
        public const string EXCEPTION_WRONG_ATTRIBUTE_RECEIVED = "Internal Error. Wrong attribute received on IndComboBox.SetDataSource()";
        public const string EXCEPTION_MUST_SET_POPUPNAME_FOR_CONTROL = "Internal Error. You must set the PopUpName property for {0} control.";
        public const string EXCEPTION_MUST_SET_POPUPWIDTH_FOR_CONTROL = "Internal Error. You must set the PopUpWidth property for {0} control.";
        public const string EXCEPTION_MUST_SET_POPUPHEIGHT_FOR_CONTROL = "Internal Error. You must set the PopUpHeight property for {0} control.";
        public const string EXCEPTION_YEARMONTH_NOT_HAVE_FORMAT = "Internal Error. The value for the YearMonth control does not have the format YYYYMM";
        public const string EXCEPTION_END_DATE_MUST_BE_GREATER = "The End Date must be greater than the Start Date.";
        public const string EXCEPTION_COULD_NOT_GET_CATALOGUE_CODE_PARAMETER = "Could not get catalogue code parameter.";
        public const string EXCEPTION_MUST_SELECT_AN_ASSOCIATE = "You must select an Associate.";
        public const string EXCEPTION_CONTROL_NOT_PLACED_CORRECT = "Internal Error. Control is not placed on the correct parent.";
        public const string EXCEPTION_EDITCOLUMN_NOT_CONTAIN_IMAGEBUTTON = "Internal Error. EditColumn does not contain an ImageButton.";
        public const string EXCEPTION_DELETECOLUMN_NOT_CONTAIN_CHECKBOX = "Internal Error. DeleteColumn does not contain an CheckBox.";
        public const string EXCEPTION_VALUE_OF_YEARMONTH_MUST_BE_INT = "Internal Error. The value for the YearMonth control is not of type int.";
        public const string EXCEPTION_VALUE_OF_YEARMONTH_START_NOT_VALID = "Internal Error. Only one value of Start Date field is selected.";
        public const string EXCEPTION_VALUE_OF_YEARMONTH_END_NOT_VALID = "Internal Error. Only one value of End Date field is selected.";
        public const string EXCEPTION_VALUE_OF_YEARMONTH_NOT_VALID = "YearMonth field not valid";
        public const string EXCEPTION_IMPLEMENT_CONSTRUCTOR = "Internal Error. Implement constructor.";
        public const string EXCEPTION_IMPLEMENT_SETENTITY = "Internal Error. Implement SetEntity.";
        public const string EXCEPTION_IMPLEMENT_INSERTOBJECT = "Internal Error. Implement InsertObject.";
        public const string EXCEPTION_IMPLEMENT_UPDATEOBJECT = "Internal Error. Implement UpdateObject.";
        public const string EXCEPTION_IMPLEMENT_DELETEOBJECT = "Internal Error. Implement DeleteObject.";
        public const string EXCEPTION_IMPLEMENT_SELECTOBJECT = "Internal Error. Implement SelectObject.";
        public const string EXCEPTION_IMPLEMENT = "Internal Error. Implement {0}.";
        public const string EXCEPTION_IMPLEMENT_INITIALIZEOBJECT = "Internal Error. Implement InitializeObject.";
        public const string EXCEPTION_SELECT_STARTYM_AND_ENDYM = "Select both the Start Date and End Date.";
        public const string EXCEPTION_ENDYM_MUST_BE_GREATER_THEN_STARTYM = "The end YearMonth must be greater than the start YearMonth.";
        public const string EXCEPTION_PERCENT_COUNTRY_IS_INVALID = "WP {0} percent on country {1} is invalid.";
        public const string EXCEPTION_PERCENT_SUM_IS_INVALID = "Work Package '{0}' has the percent sum different than 100.";
        public const string EXCEPTION_PERCENT_SUM_GREATER_THAN_MAXIMUM = "Work Package '{0}' has the percent sum greater than 100.";
        public const string EXCEPTION_PERIOD_INFO_MISSING = "WP '{0}' doesn't have Timing information associated.";
        public const string EXCEPTION_INTERCO_INFO_MISSING = "WP '{0}' doesn't have Interco information associated.";
        public const string EXCEPTION_PERIOD_INTERCO_INFO_MISSING = "WP '{0}' doesn't have Timing and Interco information associated.";
        public const string EXCEPTION_UNIQUE_KEY_CREATION_FAILED = "Could not create unique key.";
        public const string EXCEPTION_USER_SETTINGS_NOT_EXISTS = "User Settings does not exist.";
        public const string EXCEPTION_ENTITY_DOES_NOT_EXIST = "The current entity does not exist anymore. Refresh your information.";
        public const string EXCEPTION_INTERCO_WP_PHASE_CHANGED = "Key information about WP with code {0} has been changed by another user. Please refresh your information.";
        public const string EXCEPTION_PRESELECTION_WP_PHASE_CHANGED = "Preselection check: key information about at least one of project''s WPs was changed by another user. Please refresh your information.";
        public const string EXCEPTION_WP_CANNOT_BE_REMOVED = "The following WPs will not be removed because they have budget information: {0}.";
        public const string EXCEPTION_NUMBER_OF_DETAIL_TABLES = "Internal error. Number of detail tables for budget data is invalid.";
        public const string EXCEPTION_BUDGET_LAYOUT_MISSING = "Could not load budget layout.";
        public const string EXCEPTION_COLUMN_MISSING = "The specified column does not exist.";
        public const string EXCEPTION_WRONG_TYPE_RECEIVED = "Internal error. Wrong type received, decimal was expectd.";
        public const string EXCEPTION_PRECISION_LOST_ON_CONVERT = "Cannot convert values because data will be lost.";
        public const string EXCEPTION_EXCHANGE_RATE_NOT_FOUND = "The exchange rate from the currency with id {0} to currency with id {1} could not be found.";
        public const string EXCEPTION_PAGE_NOT_INDBASEPAGE = "Internal error. Page is not of type IndBasePage.";
        public const string EXCEPTION_VALUE_NOT_CONVERTED_TO_DECIMAL = "The value could not be converted to decimal.";

        public const string EXCEPTION_FIELD_NOT_NUMERIC = "{0} must be numeric.";
        public const string EXCEPTION_FIELD_CANNOT_BE_EMPTY = "{0} cannot be empty.";
        public const string EXCEPTION_SUM_OF_TWO_FIELDS_NOT_POSITIVE = "Sum of {0} and {1} must be positive.";
        public const string EXCEPTION_NO_ROWS_DIFFERENT = "These tables must have the same number of rows.";
        public const string EXCEPTION_ROWS_DO_NOT_MATCH = "Table rows do not match.";
        public const string EXCEPTION_BUDGET_STATE_MISSING = "No state for this budget.";

        public const string EXCEPTION_FORMAT_NOT_VALID = "The format for object {0} is not valid.";
        public const string EXCEPTION_NULL_ENCOUNTERED = " {0} is null.";
        public const string EXCEPTION_COST_CENTER_PARENT_NOT_FOUND = "The parent WP for the cost center was not found.";
        public const string EXCEPTION_INITIAL_BUDGET_INCOMPLETE_PROPERTIES = "Internal error. The Initial Budget object does not have the neccessary properties set.";
        public const string EXCEPTION_REVISED_BUDGET_INCOMPLETE_PROPERTIES = "Internal error. The Revised Budget object does not have the neccessary properties set.";
        public const string EXCEPTION_UNDEFINED_TAB = "Undefined tab";

        public const string EXCEPTION_BUDGET_TOCOMPLETION_NOTIMPLEMENTED = "Not implemented";
        public const string EXCEPTION_BUDGET_INTIAL_MISSING_FOR_VERSION = "There is no {0} version for {1}.";
        public const string EXCEPTION_BUDGET_REVISED_MISSING_FOR_VERSION = "There is no {0} version for {1}.";
        public const string EXCEPTION_BUDGET_REVISED_VALIDATE = "There was an error validating the budget.";
        public const string EXCEPTION_BUDGET_COMPLETION_MISSING_FOR_VERSION = "There is no {0} version for {1}.";        
        
        public const string EXCEPTION_COST_CENTER_KEY_NOT_FOUND = "The selected cost center was not found in the data source.";
        public const string EXCEPTION_INCORRECT_VALUES = "The entered values are not in the correct format.";

        public const string EXCEPTION_FIELD_MUST_BE_POSITIVE = "{0} must be positive.";
        public const string EXCEPTION_COULD_NOT_GET_KEY_VALUE_FOR_INITIAL = "Could not get the key value from the given item.";

        public const string EXCEPTION_COULD_NOT_GET_PARAMETER = "Could not get {0} parameter";
        public const string EXCEPTION_WRONG_ASSOCIATE_CURRENCY_PARAMETER = "Wrong associate currency parameter received.";

        public const string EXCEPTION_COULD_NOT_GET_TOTALS = "Could not get the Totals values.";
        public const string EXCEPTION_INITIAL_BUDGET_VALIDATED = "The Initial budget is already validated. Please use the Revised Budget.";
        public const string EXCEPTION_INITIAL_BUDGET_VALIDATED_DOES_NOT_EXIST = "No validated initial budget found for this project. Please go to initial budget page or choose a different project.";
        public const string EXCEPTION_BUDGET_WAITING_FOR_APPROVAL_STATE = "Unable to enter the budget, you have one waiting for approval. To visualize it, please go to &quot;Follow-up&quot; section.";

        public const string EXCEPTION_NO_PERMISSION_TO_VIEW_PAGE = "You do not have sufficient rights to view this page.";
        public const string EXCEPTION_USER_IS_NOT_IN_CORETEAM = "You have to be an active core team member of the current project to access this page. Project Readers are also not allowed to view this page.";

        public const string EXCEPTION_NO_TRANSACTION_AVAILABLE_COMMIT = "Could not commit transaction because no transaction is enlisted.";
        public const string EXCEPTION_NO_TRANSACTION_AVAILABLE_ROLLBACK = "Could not rollback transaction because no transaction is enlisted.";
        public const string EXCEPTION_ANOTHER_TRANSACTION_ENLISTED = "Connection already enlisted in a transaction";

        public const string EXCEPTION_REFORECAST_DISPLAYED_DATA_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE = "DataValueMember property of Displayed Data Combobox must be of integer type.";
        public const string EXCEPTION_REFORECAST_DISPLAYED_DATA_OPTION_NOT_AVAILABLE = "Selected option for display is not available.";

        public const string EXCEPTION_REFORECAST_MASTER_FIELD_NOT_NUMERIC= "Value from {0} is not positive numeric. WP/Cost Center: {1}.";
        public const string EXCEPTION_REFORECAST_DETAIL_FIELD_NOT_NUMERIC = "Value from {0} is not {1} numeric. Department/Inergy Location/Cost Center: {2}, Month {3}.";

        public const string EXCEPTION_NOT_IMPLEMENTED = "Not implemented.";
        public const string EXCEPTION_UPDATE_NOT_ALLOWED = "Updating is not allowed for this type of data.";
        public const string EXCEPTION_COST_TYPE_NOT_SUPPORTED = "Cost type not supported for this data type.";      
        public const string EXCEPTION_DATA_SET_CORRUPTED = "Internal error. Dataset is corrupted.";

        public const string EXCEPTION_ACTUALDATA_TIMESTAMP_NOT_DATETIME = "Actual Data timestamp is not of type DateTime.";

        public const string EXCEPTION_ANNUALBUDGET_DOWNLOAD_NODATA = "No data to export for country '{0}', Inergy location '{1}' and year {2}.";

        public const string EXCEPTION_SELF_DELETION = "Self deletion is not allowed";

		public const string EXCEPTION_BUDGET_COUNTRY_COMBOBOX_DATA_VALUE_MEMBER_WRONG_TYPE = "DataValueMember property of Country Combobox must be of integer type.";

        //menu text constants
        public const string MENU_ASSOCIATE = "Associate";
        public const string MENU_HOURLY_RATE = "Hourly Rate";
        public const string MENU_GL_ACCOUNT = "G/L Account";
        public const string MENU_REGION = "Region";
        public const string MENU_COUNTRY = "Country";
        public const string MENU_INERGY_LOCATION = "Inergy Location";
        public const string MENU_PROJECT_TYPE = "Project Type";
        public const string MENU_OWNER = "Program Owner";
        public const string MENU_DEPARTMENT = "Department";
        public const string MENU_FUNCTION = "Function";
        public const string MENU_PHASE = "Phase";
        public const string MENU_WORK_PACKAGE = "Work Package";
        public const string MENU_COST_CENTER = "Cost Center";
        public const string MENU_PROGRAM = "Program";
        public const string MENU_PROJECT = "Project";
        public const string MENU_TECHNICAL_SETTINGS = "Technical Settings";
        public const string MENU_USER_SETTINGS = "User Settings";
        public const string MENU_CORE_TEAM = "Core Team";
        public const string MENU_TIMING_INTERCO = "Timing & Interco";
        public const string MENU_UPLOAD = "Upload";
        public const string MENU_DATA_LOGS = "Logs";
        public const string MENU_DATA_STATUS = "Status";
        public const string MENU_PROFILE = "Profile";
        public const string MENU_WORK_GROUP = "Work Group";
        public const string MENU_INITIAL = "Initial";
        public const string MENU_REVISED = "Revised";
        public const string MENU_REFORECAST = "Reforecast";
        public const string MENU_FOLLOW_UP = "Follow-up";
        public const string MENU_EXTRACT = "Extract";
        public const string MENU_UPLOAD_INITIAL_BUDGET = "Initial Budget";

        //region messages

        public const string BUDGET_CTM_SUBMIT = "You are submitting the budget. Core team member will not be able to edit this budget anymore unless project manager disapprove it.";
        public const string BUDGET_PM_VALIDATE = "Validate this budget?";
        public const string BUDGET_PM_APPROVE = "Approve this budget?";
        public const string BUDGET_PM_REJECT = "You are disapproving this budget. Core team member will be able to modify it again.";

        public const string BUDGET_REVISED_ERROR_SUBMIT = "There was an error while submitting the budget.";

        public const string IMPORT_FILE_ALREADY_EXIST = "The selected file already exist. Overwrite?";
        public const string IMPORT_WRONG_COUNTRY = "The file: {0} you are trying to upload does not belong to country {1} you are registered in.";
        public const string IMPORT_COUNTRY_NOT_IN_IMPORTSOURCE = "Your country {0} is not associated with selected import source {1}.";
        public const string IMPORT_NO_FILE_SELECTED = "Please select a file.";
        public const string IMPORT_WRONG_APPLICATION = "The selected file {0} does not match the chosen File Type: {1}.";
        public const string IMPORT_WRONG_FILE_FORMAT = "The file: {0} you are trying to upload does not have the correct format Application Name+Country+Month+Year(eg. SAPFRA012007).";
        public const string IMPORT_WRONG_YEARMONTH = "The file: {0} you are trying to upload does not match the selected Period: {1}.";
        public const string IMPORT_FILE_PROCESSED = "File(s) successfully processed.";
        public const string IMPORT_FILE_ERROR = "File: {0} was NOT successfully imported. Check the data logs for details.";
        public const string IMPORT_FILE_INITIAL_BUDGET_ERROR = "File: {0} was NOT successfully imported. {1}";
        public const string IMPORT_FILE_NOT_EXIST = "File {0} cannot be accessed because does not exist on the server anymore or because share {1} is not activ.";
        public const string IMPORT_DESTINATION_UNKNOWN = "Destination file does not exist.";
        public const string IMPORT_FILE_ALREADY_UPLOADED = "File {0} is already processed.";
        public const string IMPORT_FILE_ERROR_ON_MOVING = "File {0} encountered an error during the moving process: {1}.";
        public const string IMPORT_FILE_UPLOAD_ERROR = "There was an error on uploading file {0}. {1}";
        public const string IMPORT_SELECT_YEARMONTH = "* Period is required.";
        public const string IMPORT_SELECT_FILETYPE = "* File Type is required.";
        public const string IMPORT_CHECK_FILE_CRASH = "There was an error checking if file was already processed.";
        public const string UPLOAD_SUCCESFULLY = "File succesfully uploaded.";
        public const string UPLOAD_SUCCESSFULY_BUDGET_INITIAL = "File succesfully uploaded with id {0}. Press 'Process' to continue.";
        public const string UPLOAD_ZERO_SIZE = "The file you are trying to upload is empty.";
        public const string UPLOAD_WRONG_MONTH = "{0} is not a valid month. Check if document name: {1} is valid format (eg. SAPFRA012007).";
        public const string UPLOAD_WRONG_YEAR = "{0} is not a valid year.Check if document name: {1} is valid format (eg. SAPFRA012007).";
        public const string IMPORT_FOLDER_DOES_NOT_EXIST = "Import folder: {0} does not exist.";
        public const string DATATABLE_EMPTY_ERROR = "Null DataTables cannot be written to file.";
        public const string IMPORT_WRONG_CHRONOLOGICAL_ORDER = "Files import must be made in chronological order. Last succesfully import was for Period: {0}.";

        public const string INITIAL_IMPORT_WRONG_FILE_FORMAT = "The file: {0} you are trying to upload does not have the correct format InitialBudget[ProjectCode](eg. InitialBudgetW1 ).";

        public const string ANNUAL_IMPORT_WRONG_FILE_FORMAT = "The file: {0} you are trying to upload does not have the correct format Country+Year(eg. FRA2007).";
        public const string ANNUAL_IMPORT_WRONG_YEAR = "The file {0} you are trying to upload does not match the selected Year field.";
        public const string PROCESS_ZERO_SIZE = "The file {0} you are trying to process is empty.";

        public const string UPLOAD_MISSING_ASSOCIATES = " There are {0} associate(s) not found in Associates catalogue. For details check {1}.";
        public const string UPLOAD_ASSOCIATES_INSERTED = " The missing associates were automatically inserted in the Associates catalogue.";

        public const string EXCEPTION_EXTRACT_NODATA = "No data to export.";
        public static string MessageWithParameters(string textMessage, params string[] listParameters)
        {
            StringBuilder strMessage = new StringBuilder(textMessage);
            for (int i = 0; i < listParameters.Length; i++)
            {
                strMessage.Replace("{" + i.ToString() + "}",listParameters[i]);
            }
            return strMessage.ToString();
        }
        
    }
}

