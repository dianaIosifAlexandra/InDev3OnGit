using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.DataAccess.Authorization;
using System.Data;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Common;


namespace Inergy.Indev3.BusinessLogic.Authorization
{
    /// <summary>
    /// Class containing all information about the current user accessing the application
    /// </summary>
    public class CurrentUser : GenericEntity
    {
        #region Constructors
        public CurrentUser(object connectionManager)
            : base(connectionManager)
        {
        }
        public CurrentUser(string inergyLogin, object connectionManager)
            : base(connectionManager)
        {
            this._InergyLogin = inergyLogin;
        }

        #endregion Constructors
        
        #region Members

        private int _IdAssociate;
        /// <summary>
        /// The Id of this associate (asssociate == user)
        /// </summary>
        public int IdAssociate
        {
            get { return _IdAssociate; }
            set { _IdAssociate = value; }
        }

        private string _AssociateName;
        /// <summary>
        /// The name of the associate
        /// </summary>
        public string AssociateName
        {
            get { return _AssociateName; }
            set { _AssociateName = value; }
        }

        private string _InergyLogin;
        /// <summary>
        /// The Inergy login of the user
        /// </summary>
        public string InergyLogin
        {
            get { return _InergyLogin; }
            set { _InergyLogin = value; }
        }
        
        private int _IdCountry;
        /// <summary>
        /// The Id of the country of the current user
        /// </summary>
        public int IdCountry
        {
            get { return _IdCountry; }
            set { _IdCountry = value; }
        }

        private string _CountryName;
        /// <summary>
        /// The country name of the current user
        /// </summary>
        public string CountryName
        {
            get { return _CountryName; }
            set { _CountryName = value; }
        }

        private string _CountryCode;
        /// <summary>
        /// The country name of the current user
        /// </summary>
        public string CountryCode
        {
            get { return _CountryCode; }
            set { _CountryCode = value; }
        }

        private int _IdCurrency;
        /// <summary>
        /// The id of the currency corresponding to the country of this user
        /// </summary>
        public int IdCurrency
        {
            get { return _IdCurrency; }
            set { _IdCurrency = value; }
        }

        private String _CodeCurrency;
        /// <summary>
        /// The id of the currency corresponding to the country of this user
        /// </summary>
        public String CodeCurrency
        {
            get { return _CodeCurrency; }
            set { _CodeCurrency = value; }
        }

        private IndRole _UserRole;
        /// <summary>
        /// The role this user belongs to
        /// </summary>
        public IndRole UserRole
        {
            get { return _UserRole; }
            set { _UserRole = value; }
        }

        private int _IdImpersonatedAssociate; 
        /// <summary>
        /// The IdAssociate who is impersonated for initializing budget
        /// </summary>
        public int IdImpersonatedAssociate
        {
            get { return _IdImpersonatedAssociate; }
            set { _IdImpersonatedAssociate = value; }
        }

        private string _NameImpersonatedAssociate = string.Empty;
        /// <summary>
        /// The IdAssociate who is impersonated for initializing budget
        /// </summary>
        public string NameImpersonatedAssociate
        {
            get { return _NameImpersonatedAssociate; }
            set { _NameImpersonatedAssociate = value; }
        }


        private Dictionary<int, string> _ProgramManagerProjects;
        /// <summary>
        /// Holds the id's and names of the projects for which this user is program manager
        /// </summary>
        public Dictionary<int, string> ProgramManagerProjects
        {
            get { return _ProgramManagerProjects; }
            set { _ProgramManagerProjects = value; }
        }

        private Dictionary<int, string> _CoreTeamProjects;
        /// <summary>
        /// Holds the id's and names of the projects for which this user is anyhing but program manager (has a different project function)
        /// </summary>
        public Dictionary<int, string> CoreTeamProjects
        {
            get { return _CoreTeamProjects; }
            set { _CoreTeamProjects = value; }
        }

        private Dictionary<int, string> _ProgramReaderProjects;
        /// <summary>
        /// Holds the id's and names of the projects for which this user is anyhing but program manager (has a different project function)
        /// </summary>
        public Dictionary<int, string> ProgramReaderProjects
        {
            get { return _ProgramReaderProjects; }
            set { _ProgramReaderProjects = value; }
        }
        
        private Dictionary<IndPair, Permissions> _CoreTeamPermissions;
        /// <summary>
        /// Holds the permissions of Core Team Members
        /// </summary>
        public Dictionary<IndPair, Permissions> CoreTeamPermissions
        {
            get { return _CoreTeamPermissions; }
            set { _CoreTeamPermissions = value; }
        }

        private Dictionary<IndPair, Permissions> _ProgramManagerPermissions;
        /// <summary>
        /// Holds the permissions of Program Managers
        /// </summary>
        public Dictionary<IndPair, Permissions> ProgramManagerPermissions
        {
            get { return _ProgramManagerPermissions; }
            set { _ProgramManagerPermissions = value; }
        }

        private Dictionary<IndPair, Permissions> _ProgramReaderPermissions;
        /// <summary>
        /// Holds the permissions of Program Readers
        /// </summary>
        public Dictionary<IndPair, Permissions> ProgramReaderPermissions
        {
            get { return _ProgramReaderPermissions; }
            set { _ProgramReaderPermissions = value; }
        }

        /// <summary>
        /// The DBCurrentUser associated with this user
        /// </summary>
        private DBCurrentUser DBCurrentUser;

        private UserSettings _Settings = null;
        /// <summary>
        /// The settings for the logged user
        /// </summary>
        public UserSettings Settings
        {
            get { return _Settings; }
            set { _Settings = value; }
        }
        #endregion Members 

        #region Public Methods
        public int LoadUserDetails()
        {
            try
            {
                //Instantiate the DBCurrentUser object
                DBCurrentUser = new DBCurrentUser(this.CurrentConnectionManager);
                //Get the table containing the user information
                DataTable userTable = DBCurrentUser.GetUserDetails(_InergyLogin, _IdCountry);
                //If the user contains a row, initialize this object with the data from the row
                if (userTable.Rows.Count == 1)
                {
                    DataRow userRow = userTable.Rows[0];
                    Initialize((int)userRow["IdAssociate"], userRow["AssociateName"].ToString(), _InergyLogin, (int)userRow["IdCountry"], userRow["CountryName"].ToString(), (int)userRow["IdCurrency"], userRow["CodeCurrency"].ToString(), userRow["CountryCode"].ToString());
                    BuildProjectInformation();
                    if (_ProgramManagerProjects.Count > 0)
                    {
                        GetProgramManagerPermissions();
                    }

                    if (_CoreTeamProjects.Count > 0)
                    {
                        GetCoreTeamMemberPermissions();
                    }

                    if (_ProgramReaderProjects.Count > 0)
                    {
                        GetProgramReaderPermissions();
                    }

                    BuildRoleInformation();
                }
                //Else instantiate the object with default values
                else
                {
                    Initialize(ApplicationConstants.INT_NULL_VALUE, String.Empty, String.Empty, ApplicationConstants.INT_NULL_VALUE, String.Empty, ApplicationConstants.INT_NULL_VALUE, String.Empty, String.Empty);
                }
                return userTable.Rows.Count;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public CurrentUser Clone()
        {
            CurrentUser newUser = new CurrentUser(this.InergyLogin, this.CurrentConnectionManager);
            newUser.AssociateName = this.AssociateName;
            newUser.CodeCurrency = this.CodeCurrency;
            newUser.CoreTeamPermissions = new Dictionary<IndPair,Permissions>(this.CoreTeamPermissions);
            newUser.CoreTeamProjects  = new Dictionary<int,string>(this.CoreTeamProjects);
            newUser.CountryCode = this.CountryCode;
            newUser.CountryName = this.CountryName;
            newUser.Id = this.Id;
            newUser.IdAssociate = this.IdAssociate;
            newUser.IdCountry = this.IdCountry;
            newUser.IdCurrency = this.IdCurrency;
            newUser.IdImpersonatedAssociate = this.IdImpersonatedAssociate;
            newUser.NameImpersonatedAssociate = this.NameImpersonatedAssociate;
            newUser.ProgramManagerPermissions = new Dictionary<IndPair, Permissions>(this.ProgramManagerPermissions);
            newUser.ProgramManagerProjects = new Dictionary<int, string>(this.ProgramManagerProjects);
            newUser.ProgramReaderPermissions = new Dictionary<IndPair, Permissions>(this.ProgramReaderPermissions);
            newUser.ProgramReaderProjects = new Dictionary<int, string>(this.ProgramReaderProjects);
            newUser.Settings = new UserSettings(this.Settings.AssociateId, this.CurrentConnectionManager);
            newUser.UserRole = this.UserRole;

            return newUser;
        }

        public DataTable GetUserCountries()
        {
            try
            {
                //Instantiate the DBCurrentUser object
                DBCurrentUser = new DBCurrentUser(this.CurrentConnectionManager);
                //Get the table containing the user information
                DataTable userTable = DBCurrentUser.GetUserCountries(_InergyLogin);
                return userTable;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
       

        /// <summary>
        /// Gets the permissions for the given module code and operation
        /// </summary>
        /// <param name="moduleCode">The code of the module</param>
        /// <param name="operation">The operation to be performed on the module</param>
        /// <returns>The permission to perform the given operation on the given module</returns>
        public Permissions GetPermission(string moduleCode, Operations operation)
        {
            try
            {
                //Get the permission from the user role corresponding to the given module and operation 
                Permissions permission = _UserRole.GetPermission(moduleCode, operation);

                IndPair moduleOperation = new IndPair(moduleCode, operation);

                //If neither thr CoreTeamPermissions dictionary nor the ProgramManagerPermissions contain this permission,
                //then the permission for this user will be the one from its role
                if (!_ProgramManagerPermissions.ContainsKey(moduleOperation) &&
                    !_CoreTeamPermissions.ContainsKey(moduleOperation) &&
                    !_ProgramReaderPermissions.ContainsKey(moduleOperation))
                {
                    return permission;
                }
                //The permission that comes not from the user role (which can only be business administrator, technical administrator or
                //financial team), but from the user being a program manager or core team member (different from program manager)
                Permissions nonRolePermission = GetNonRolePermissions(moduleOperation);
                
                //The permission will be the smallest of the 2 permissions (Permission.All = 1, Permissions.Restricted = 2, Permissions.None = 3
                // - this means that choosing the least restrictive permission from the permissions enumeration is the same thing as chosing the 
                // permission with the smallest value - this is why we calculate the minimum value of the 2 permissions).
                return (permission < nonRolePermission) ? permission : nonRolePermission;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        /// <summary>
        /// Gets the permissions for the given module code and operation, for modules which are accessed only after a project is selected
        /// </summary>
        /// <param name="moduleCode">The code of the module</param>
        /// <param name="operation">The operation to be performed on the module</param>
        /// <param name="idProject">The project for which the permission is applied</param>
        /// <returns></returns>
        public Permissions GetPermission(string moduleCode, Operations operation, int idProject)
        {
            try
            {
                Permissions permission = _UserRole.GetPermission(moduleCode, operation);

                IndPair moduleOperation = new IndPair(moduleCode, operation);

                //If this user does not belong to the core team of the given project, the permission is the one from its role
                if (!_ProgramManagerProjects.ContainsKey(idProject) &&
                    !_CoreTeamProjects.ContainsKey(idProject) &&
                    !_ProgramReaderProjects.ContainsKey(idProject))
                {
                    return permission;
                }
                //The permission that comes not from the user role (which can only be business administrator, technical administrator or
                //financial team), but from the user being a program manager or core team member (different from program manager)
                Permissions nonRolePermission = GetNonRolePermissions(moduleOperation, idProject);

                //The permission will be the smallest of the 2 permissions (Permission.All = 1, Permissions.Restricted = 2, Permissions.None = 3
                // - this means that choosing the least restrictive permission from the permissions enumeration is the same thing as chosing the 
                // permission with the smallest value - this is why we calculate the minimum value of the 2 permissions).
                return (permission < nonRolePermission) ? permission : nonRolePermission;
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        /// <summary>
        /// Checks if the role has permission to view the module given by module code
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <returns>true if this role allows viewing the module, false otherwise</returns>
        public bool HasViewPermission(string moduleCode)
        {
            bool hasViewPermission;
            try
            {
                hasViewPermission = HasXPermission(moduleCode, Operations.View);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return hasViewPermission;
        }
        /// <summary>
        /// Checks if the role has permission to add an entity in the module given by module code
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <returns>true if this role allows viewing the module, false otherwise</returns>
        public bool HasAddPermission(string moduleCode)
        {
            bool hasAddPermission;
            try
            {
                hasAddPermission = HasXPermission(moduleCode, Operations.Add);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return hasAddPermission;
        }
        /// <summary>
        /// Checks if the role has permission to edit an entity in the module given by module code
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <returns>true if this role allows viewing the module, false otherwise</returns>
        public bool HasEditPermission(string moduleCode)
        {
            bool hasEditPermission;
            try
            {
                hasEditPermission = HasXPermission(moduleCode, Operations.Edit);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return hasEditPermission;
        }
        /// <summary>
        /// Checks if the role has permission to delete an entity in the module given by module code
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <returns>true if this role allows viewing the module, false otherwise</returns>
        public bool HasDeletePermission(string moduleCode)
        {
            bool hasDeletePermission;
            try
            {
                hasDeletePermission = HasXPermission(moduleCode, Operations.Delete);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return hasDeletePermission;
        }

        /// <summary>
        /// Checks if the role has permission to view the module given by module code for the given project
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <param name="idProject">the id of the project</param>
        /// <returns>true if this role allows viewing the module, false otherwise</returns>
        public bool HasViewPermission(string moduleCode, int idProject)
        {
            bool hasViewPermission;
            try
            {
                hasViewPermission = HasXPermission(moduleCode, Operations.View, idProject);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return hasViewPermission;
        }
        /// <summary>
        /// Checks if the role has permission to add an entity in the module given by module code for the given project
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <param name="idProject">the id of the project</param>
        /// <returns>true if this role allows viewing the module, false otherwise</returns>
        public bool HasAddPermission(string moduleCode, int idProject)
        {
            bool hasAddPermission;
            try
            {
                hasAddPermission = HasXPermission(moduleCode, Operations.Add, idProject);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return hasAddPermission;
        }
        /// <summary>
        /// Checks if the role has permission to edit an entity in the module given by module code for the given project
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <param name="idProject">the id of the project</param>
        /// <returns>true if this role allows viewing the module, false otherwise</returns>
        public bool HasEditPermission(string moduleCode, int idProject)
        {
            bool hasEditPermission;
            try
            {
                hasEditPermission = HasXPermission(moduleCode, Operations.Edit, idProject);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return hasEditPermission;
        }
        /// <summary>
        /// Checks if the role has permission to delete an entity in the module given by module code for the given project
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <param name="idProject">the id of the project</param>
        /// <returns>true if this role allows viewing the module, false otherwise</returns>
        public bool HasDeletePermission(string moduleCode, int idProject)
        {
            bool hasDeletePermission;
            try
            {
                hasDeletePermission = HasXPermission(moduleCode, Operations.Delete, idProject);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return hasDeletePermission;
        }
        #endregion Public Methods

        #region Private Methods
        /// <summary>
        /// Initializes a CurrentUser object with the given associate id, associate name, inergy login, country id and country name
        /// </summary>
        /// <param name="idAssociate">the id of the associate</param>
        /// <param name="associateName">the name of the associate</param>
        /// <param name="inergyLogin">the inergy login</param>
        /// <param name="idCountry">the country id</param>
        /// <param name="countryName">the name of the country of the user</param>
        private void Initialize(int idAssociate, string associateName, string inergyLogin, int idCountry, string countryName, int idCurrency, string codeCurrency, string countryCode)
        {
            _IdAssociate = idAssociate;
            _AssociateName = associateName;
            _InergyLogin = inergyLogin;
            _IdCountry = idCountry;
            _CountryName = countryName;

            _ProgramManagerProjects = new Dictionary<int, string>();
            _CoreTeamProjects = new Dictionary<int, string>();
            _ProgramReaderProjects = new Dictionary<int, string>();

            _ProgramManagerPermissions = new Dictionary<IndPair, Permissions>(new IndPairComparer());
            _CoreTeamPermissions = new Dictionary<IndPair, Permissions>(new IndPairComparer());
            _ProgramReaderPermissions = new Dictionary<IndPair, Permissions>(new IndPairComparer());

            _IdCurrency = idCurrency;
            _CodeCurrency = codeCurrency;
            _CountryCode = countryCode;
        }
        /// <summary>
        /// Builds the Dictionary objects containing information about the projects of this user
        /// </summary>
        private void BuildProjectInformation()
        {
            //Get the projects of this user from the database
            DataTable projectsDataTable = DBCurrentUser.GetUserProjects(_IdAssociate);
            //For each row in the datatable
            foreach (DataRow row in projectsDataTable.Rows)
            {
                //If the user is Program Manager for this project, add the project to _ProgramManagerProjects
                if (IsProjectManagerFunction((int)row["IdFunction"]))
                {
                    _ProgramManagerProjects.Add((int)row["IdProject"], row["ProjectName"].ToString());
                    continue;
                }

                if (IsCoreTeamFunction((int)row["IdFunction"]))
                {
                    _CoreTeamProjects.Add((int)row["IdProject"], row["ProjectName"].ToString());
                    continue;
                }

                if (IsProgramReaderFunction((int)row["IdFunction"]))
                {
                    _ProgramReaderProjects.Add((int)row["IdProject"], row["ProjectName"].ToString());
                    continue;
                }
            }
        }
        /// <summary>
        /// Builds the role information of this user which will contain all permissions of this user
        /// </summary>
        private void BuildRoleInformation()
        {
            //Get the dataset containing the permissions of the role of this user
            DataSet permissionsDataSet = DBCurrentUser.GetUserPermissions(_IdAssociate, _IdCountry);
            //Build the IndRole object associated to this user
            _UserRole = new IndRole(permissionsDataSet);
        }
        /// <summary>
        /// Populates the _ProgramManagerPermissions dictionary with the permissions the program manager role if this user is a program manager.
        /// If he is not a core team member, this function will not get called
        /// </summary>
        private void GetProgramManagerPermissions()
        {
            DataTable permissionsDataTable = DBCurrentUser.GetRolePermissions(ApplicationConstants.ROLE_PROGRAM_MANAGER);
            foreach (DataRow row in permissionsDataTable.Rows)
            {
                //Build the pair of module code and operation which will be the key of the dictionary
                IndPair pair = new IndPair(row["ModuleCode"].ToString(), (Operations)row["IdOperation"]);
                //Add the key-value pair to the dictionary (the value is the permission)
                _ProgramManagerPermissions.Add(pair, (Permissions)row["IdPermission"]);
            }
        }
        /// <summary>
        /// Populates the _CoreTeamPermissions dictionary with the permissions the core team role if this user is a core team member
        /// (other than program manager). If he is not a core team member (other than program manager), this function will not get called
        /// </summary>
        private void GetCoreTeamMemberPermissions()
        {
            DataTable permissionsDataTable = DBCurrentUser.GetRolePermissions(ApplicationConstants.ROLE_CORE_TEAM);
            foreach (DataRow row in permissionsDataTable.Rows)
            {
                //Build the pair of module code and operation which will be the key of the dictionary
                IndPair pair = new IndPair(row["ModuleCode"].ToString(), (Operations)row["IdOperation"]);
                //Add the key-value pair to the dictionary (the value is the permission)
                _CoreTeamPermissions.Add(pair, (Permissions)row["IdPermission"]);
            }
        }

        /// <summary>
        /// Populates the _CoreTeamPermissions dictionary with the permissions the core team role if this user is a core team member
        /// (other than program manager). If he is not a core team member (other than program manager), this function will not get called
        /// </summary>
        private void GetProgramReaderPermissions()
        {
            DataTable permissionsDataTable = DBCurrentUser.GetRolePermissions(ApplicationConstants.ROLE_PROGRAM_READER);
            foreach (DataRow row in permissionsDataTable.Rows)
            {
                //Build the pair of module code and operation which will be the key of the dictionary
                IndPair pair = new IndPair(row["ModuleCode"].ToString(), (Operations)row["IdOperation"]);
                //Add the key-value pair to the dictionary (the value is the permission)
                _ProgramReaderPermissions.Add(pair, (Permissions)row["IdPermission"]);
            }
        }

        /// <summary>
        /// Checks if this user has permission to perform the given operation on the given module
        /// </summary>
        /// <param name="moduleCode">the code of the module</param>
        /// <param name="operation">the operation to be performed</param>
        /// <returns>true if this user has permission to perform the given operation on the given module, false otherwise</returns>
        private bool HasXPermission(string moduleCode, Operations operation)
        {
            //Get the view permission from the user role corresponding to the given module
            Permissions rolePermission = _UserRole.GetPermission(moduleCode, operation);

            IndPair moduleOperation = new IndPair(moduleCode, operation);

            //If the CoreTeamPermission dictionary does not contain this permission, then the permission for this user will be the one from
            //its role
            if (!_ProgramManagerPermissions.ContainsKey(moduleOperation) &&
                !_CoreTeamPermissions.ContainsKey(moduleOperation) &&
                !_ProgramReaderPermissions.ContainsKey(moduleOperation))
            {
                //The user has view permission if the permission is not none
                return (rolePermission != Permissions.None);
            }            

            //The permission that comes not from the user role (which can only be business administrator, technical administrator or
            //financial team), but from the user being a program manager or core team member (different from program manager)
            Permissions nonRolePermission = GetNonRolePermissions(moduleOperation);
           
            //Else, if either of the 2 permissions (from the role of the user, or from the core team role) is not none, than the user
            //will have view permission
            return (rolePermission != Permissions.None) || (nonRolePermission != Permissions.None);
        }




        /// <summary>
        /// Checks if this user has permission to perform the given operation on the given module, for modules which are accessed only after a project is selected
        /// </summary>
        /// <param name="moduleCode">The code of the module</param>
        /// <param name="operation">The operation to be performed on the module</param>
        /// <param name="idProject">The project for which the permission is applied</param>
        /// <returns>true if this user has permission to perform the given operation on the given module for the selected project, false otherwise</returns>
        private bool HasXPermission(string moduleCode, Operations operation, int idProject)
        {
            Permissions rolePermission = _UserRole.GetPermission(moduleCode, operation);

            IndPair moduleOperation = new IndPair(moduleCode, operation);                

            //If this user does not belong to the core team of the given project, the permission is the one from its role
            if (!_ProgramManagerProjects.ContainsKey(idProject) && 
                !_CoreTeamProjects.ContainsKey(idProject) &&
                !_ProgramReaderProjects.ContainsKey(idProject))
            {
                //The user has view permission if the permission is not none
                return (rolePermission != Permissions.None);
            }
            //The permission that comes not from the user role (which can only be business administrator, technical administrator or
            //financial team), but from the user being a program manager or core team member (different from program manager)
            Permissions nonRolePermission = GetNonRolePermissions(moduleOperation, idProject);         

            //Else, if either of the 2 permissions (from the role of the user, or from the core team role) is not none, than the user
            //will have view permission
            return (rolePermission != Permissions.None) || (nonRolePermission != Permissions.None);
        }

        private bool IsProjectManagerFunction(int idFunction)
        {
            if (idFunction == ApplicationConstants.PROJECT_FUNCTION_PROGRAM_MANAGER ||
                idFunction == ApplicationConstants.PROJECT_FUNCTION_PROGRAM_ASSISTANT)
                return true;

            return false;
        }

        private bool IsCoreTeamFunction(int idFunction)
        {
            if (idFunction == ApplicationConstants.PROJECT_FUNCTION_IE ||
                idFunction == ApplicationConstants.PROJECT_FUNCTION_PAE ||
                idFunction == ApplicationConstants.PROJECT_FUNCTION_PB ||
                idFunction == ApplicationConstants.PROJECT_FUNCTION_CSAE ||
                idFunction == ApplicationConstants.PROJECT_FUNCTION_QE ||
                idFunction == ApplicationConstants.PROJECT_FUNCTION_SALES)
                return true;

            return false;
        }

        private bool IsProgramReaderFunction(int idFunction)
        {
            if (idFunction == ApplicationConstants.PROJECT_FUNCTION_PROGRAM_READER)
                return true;

            return false;
        }

        private Permissions GetNonRolePermissions(IndPair moduleOperation)
        { 
            //The permission that comes not from the user role (which can only be business administrator, technical administrator or
            //financial team), but from the user being a program manager or core team member (different from program manager)
            Permissions nonRolePermission = Permissions.None;
            //Get the nonRolePermission from the program manager permissions if this user is a program manager,
            //else get it from the core team member permissions
            //else get it from the program reader permissions
            if (_ProgramManagerPermissions.ContainsKey(moduleOperation))
            {
                nonRolePermission = _ProgramManagerPermissions[moduleOperation];
                return nonRolePermission;
            }

            if (_CoreTeamPermissions.ContainsKey(moduleOperation))
            {
                nonRolePermission = _CoreTeamPermissions[moduleOperation];
                return nonRolePermission;
            }

            if (_ProgramReaderPermissions.ContainsKey(moduleOperation))
            {
                nonRolePermission = _ProgramReaderPermissions[moduleOperation];
                return nonRolePermission;
            }

            return nonRolePermission;
        }

        private Permissions GetNonRolePermissions(IndPair moduleOperation, int idProject)
        {
            //The permission that comes not from the user role (which can only be business administrator, technical administrator or
            //financial team), but from the user being a program manager or core team member (different from program manager)
            Permissions nonRolePermission = Permissions.None;
            //Get the nonRolePermission from the program manager permissions if this user is a program manager,
            //else get it from the core team member permissions
            //else get it from the program reader permissions
            if (_ProgramManagerProjects.ContainsKey(idProject))
            {
                nonRolePermission = _ProgramManagerPermissions[moduleOperation];
                return nonRolePermission;
            }

            if (_CoreTeamProjects.ContainsKey(idProject))
            {
                nonRolePermission = _CoreTeamPermissions[moduleOperation];
                return nonRolePermission;
            }

            if (_ProgramReaderProjects.ContainsKey(idProject))
            {
                nonRolePermission = _ProgramReaderPermissions[moduleOperation];
                return nonRolePermission;
            }

            return nonRolePermission;
        }

        #endregion Private Methods
    }
}
