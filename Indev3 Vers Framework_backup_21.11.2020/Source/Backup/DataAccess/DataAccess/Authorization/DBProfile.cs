using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess.Authorization
{
    /// <summary>
    /// Class used by the Profile object (business logic) to query the database
    /// </summary>
    public class DBProfile : DBGenericEntity
    {
        #region Constructors
        public DBProfile(object connectionManager)
            : base(connectionManager)
        {
        }

        #endregion Constructors
        #region Public Methods
        /// <summary>
        /// Gets all associates
        /// </summary>
        /// <returns>datatable containing the id's and names of the associates</returns>
        public DataTable GetAssociates()
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authSelectAssociates";
            return CurrentConnectionManager.GetDataTable(command);
        }

        /// <summary>
        /// Gets all roles
        /// </summary>
        /// <returns>datatable containing the id's and names of the roles (does not get Program Manager and Core Team Member roles)</returns>
        public DataTable GetRoles()
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authSelectRoles";

            SqlParameter idAssociateParameter = new SqlParameter("@IdAssociate", ApplicationConstants.INT_NULL_VALUE);
            idAssociateParameter.DbType = DbType.Int32;
            idAssociateParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(idAssociateParameter);
            return CurrentConnectionManager.GetDataTable(command);
        }

        public DataTable GetAssociateRole(int idAssociate)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authSelectRoles";

            SqlParameter idAssociateParameter = new SqlParameter("@IdAssociate", idAssociate);
            idAssociateParameter.DbType = DbType.Int32;
            idAssociateParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(idAssociateParameter);
            return CurrentConnectionManager.GetDataTable(command);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ent"></param>
        public DataTable GetAsscoiateRoles()
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authSelectProfile";
            return CurrentConnectionManager.GetDataTable(command);
        }
        /// <summary>
        /// Updates or inserts a new associate to a role
        /// </summary>
        /// <param name="idAssociate">the id of the associate</param>
        /// <param name="idRole">the id of the role</param>
        /// <returns>the number of affected rows (should be 1   )</returns>
        public int SaveAssociateRole(int idAssociate, int idRole)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authUpdateAssociateRole";

            SqlParameter idAssociateParameter = new SqlParameter("@IdAssociate", idAssociate);
            idAssociateParameter.DbType = DbType.Int32;
            idAssociateParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(idAssociateParameter);

            SqlParameter idRoleParameter = new SqlParameter("@IdRole", idRole);
            idRoleParameter.DbType = DbType.Int32;
            idRoleParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(idRoleParameter);

            return CurrentConnectionManager.ExecuteStoredProcedure(command);
        }

        public int DeleteAssociateRole(int idAssociate)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "authDeleteAssociateRole";

            SqlParameter idAssociateParameter = new SqlParameter("@IdAssociate", idAssociate);
            idAssociateParameter.DbType = DbType.Int32;
            idAssociateParameter.Direction = ParameterDirection.Input;
            command.Parameters.Add(idAssociateParameter);

            return CurrentConnectionManager.ExecuteStoredProcedure(command);
        }

        #endregion Public Methods
    }
}
