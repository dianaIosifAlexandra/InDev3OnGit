using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.Authorization
{
    /// <summary>
    /// Object used by the CurrentUser object (in BusinessLogic) to communicate with the database
    /// </summary>
    public class DBCurrentUser : DBGenericEntity
    {
        #region Constructors
        public DBCurrentUser(object connectionManager)
            : base(connectionManager)
        {
        }
        #endregion Constructors

        #region Public Methods
        /// <summary>
        /// Gets information about the user, if his inergy login exists in the database
        /// </summary>
        /// <param name="InergyLogin">the inergy login of the user</param>
        /// <returns>a DataTable containing one row with information about the user, or an empty datatable if the user 
        /// does not have a valid inergy login</returns>
        public DataTable GetUserDetails(string inergyLogin, int idCountry)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authVerifyLogin";
            
            SqlParameter inergyLoginParameter = new SqlParameter("@InergyLogin", inergyLogin);
            inergyLoginParameter.DbType = DbType.String;
            inergyLoginParameter.Direction = ParameterDirection.Input;
            
            SqlParameter idCountryParameter;
            if (idCountry == ApplicationConstants.INT_NULL_VALUE)
            {
                idCountryParameter = new SqlParameter("@IdCountry", DBNull.Value);
            }
            else
            {
                idCountryParameter = new SqlParameter("@IdCountry", idCountry);
            }
            idCountryParameter.DbType = DbType.Int32;
            idCountryParameter.Direction = ParameterDirection.Input;
            
            command.Parameters.Add(inergyLoginParameter);
            command.Parameters.Add(idCountryParameter);
            return CurrentConnectionManager.GetDataTable(command);
        }
        /// <summary>
        /// Gets information about the projects that this user is part of
        /// </summary>
        /// <param name="idCurrentUser">the id of the current user</param>
        /// <returns>A DataTable containing information about the projects that this user is part of</returns>
        public DataTable GetUserProjects(int idCurrentUser)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authSelectUserProjects";
            SqlParameter idCurrentUserParameter = new SqlParameter("@IdUser", idCurrentUser);
            idCurrentUserParameter.DbType = DbType.Int32;
            idCurrentUserParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(idCurrentUserParameter);
            return CurrentConnectionManager.GetDataTable(command);
        }
        /// <summary>
        /// Gets the permissions of the current user
        /// </summary>
        /// <param name="idCurrentUser">the id of the current user</param>
        /// <returns>a dataset containing information about the permissions of the user</returns>
        public DataSet GetUserPermissions(int idCurrentUser, int idCountry)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authSelectUserPermissions";
            
            SqlParameter idCurrentUserParameter = new SqlParameter("@IdUser", idCurrentUser);
            idCurrentUserParameter.DbType = DbType.Int32;
            idCurrentUserParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(idCurrentUserParameter);

            return CurrentConnectionManager.GetDataSet(command);
        }
        /// <summary>
        /// Gets the permissions of a given role
        /// </summary>
        /// <param name="idRole">the id of the role</param>
        /// <returns>a datatable containing the permissions of the role</returns>
        public DataTable GetRolePermissions(int idRole)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authSelectRolePermissions";

            SqlParameter idRoleParameter = new SqlParameter("@IdRole", idRole);
            idRoleParameter.DbType = DbType.Int32;
            idRoleParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(idRoleParameter);

            return CurrentConnectionManager.GetDataTable(command);
        }

        public DataTable GetUserCountries(string inergyLogin)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authSelectUserCountries";

            SqlParameter inergyLoginParameter = new SqlParameter("@InergyLogin", inergyLogin);
            inergyLoginParameter.DbType = DbType.String;
            inergyLoginParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(inergyLoginParameter);

            return CurrentConnectionManager.GetDataTable(command);
        }
        #endregion
    }
}
