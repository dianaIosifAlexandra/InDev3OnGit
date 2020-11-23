using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Data;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.BusinessLogic.Authorization
{
    /// <summary>
    /// Represents a role in the Indev3 application
    /// </summary>
    public class IndRole
    {
        #region Members
        private int _Id;
        /// <summary>
        /// The Id of the Role (from the database)
        /// </summary>
        public int Id
        {
            get { return _Id; }
            set { _Id = value; }
        }

        private string _Name;
        /// <summary>
        /// The name of the Role
        /// </summary>
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }

        private Dictionary<IndPair, Permissions> _RolePermissions;
        /// <summary>
        /// The permissions of this Role. The Key is a pair composed of the Module name and the operation (add, edit etc.), and the value is
        /// the permission type (all, restricted, none)
        /// </summary>
        public Dictionary<IndPair, Permissions> RolePermissions
        {
            get { return _RolePermissions; }
            set { _RolePermissions = value; }
        }
        #endregion Members

        #region Constructors
        /// <summary>
        /// Initializes an IndRole object with the given id and name
        /// </summary>
        /// <param name="permissionsDataSet">dataset containing the information about the role and permissions</param>
        public IndRole(DataSet permissionsDataSet)
        {
            InitializeRoleInformation(permissionsDataSet.Tables[0]);
            InitializePermissionsInformation(permissionsDataSet.Tables[1]);
        }

        #endregion Constructors

        #region Internal Methods
        /// <summary>
        /// Gets the permissions for the given module code and operation
        /// </summary>
        /// <param name="moduleCode">The code of the module</param>
        /// <param name="operation">The operation to be performed on the module</param>
        /// <returns>The permission to perform the given operation on the given module</returns>
        internal Permissions GetPermission(string moduleCode, Operations operation)
        {
            //If the module code - operation pair is not contained in the dictionary, return none permission
            if (!_RolePermissions.ContainsKey(new IndPair(moduleCode, operation)))
            {
                return Permissions.None;
            }
            return _RolePermissions[new IndPair(moduleCode, operation)];
        }
        #endregion Internal Methods

        #region Private Methods
        /// <summary>
        /// Initialize the id and name of the role from the given DataTable
        /// </summary>
        /// <param name="roleInformationTable">the DataTable containing the information about the role (without the permissions)</param>
        private void InitializeRoleInformation(DataTable roleInformationTable)
        {
            //If the user has a role
            if (roleInformationTable.Rows.Count == 1)
            {
                //Get the row containing the information
                DataRow roleInformationRow = roleInformationTable.Rows[0];
                //Set the id and name of the role
                _Id = (int)roleInformationRow["IdRole"];
                _Name = roleInformationRow["RoleName"].ToString();
            }
            //The user has no role
            else
            {
                _Id = ApplicationConstants.INT_NULL_VALUE;
            }
        }
        /// <summary>
        /// Initialize the permissions of the role from the given DataTable
        /// </summary>
        /// <param name="dataTable">the DataTable containing the permissions of the role</param>
        private void InitializePermissionsInformation(DataTable dataTable)
        {
            //Instantiate the role permissions dictionary
            _RolePermissions = new Dictionary<IndPair, Permissions>(new IndPairComparer());
            //For each row in the table
            foreach (DataRow row in dataTable.Rows)
            {
                //Build the pair of module code and operation which will be the key of the dictionary
                IndPair pair = new IndPair(row["ModuleCode"].ToString(), (Operations)row["IdOperation"]);
                //Add the key-value pair to the dictionary (the value is the permission)
                _RolePermissions.Add(pair, (Permissions)row["IdPermission"]);
            }
        }
        #endregion Private Methods
    }
}
