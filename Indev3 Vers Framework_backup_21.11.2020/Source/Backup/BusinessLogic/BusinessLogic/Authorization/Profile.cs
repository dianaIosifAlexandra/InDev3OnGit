using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.DataAccess.Authorization;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Authorization
{
    /// <summary>
    /// Class used for the profile module
    /// </summary>
    public class Profile : GenericEntity
    {
        
        #region Members
        /// <summary>
        /// DBProfile object used to query the database
        /// </summary>
        private DBProfile dbProfile;
        #endregion Members

        #region Constructors
        public Profile(object connectionManager)
            : base(connectionManager)
        {
            dbProfile = new DBProfile(this.CurrentConnectionManager);
        }
        #endregion Constructors

        #region Public Methods
        /// <summary>
        /// Gets all associates in the database
        /// </summary>
        /// <returns>datatable containing information about all associates in the database</returns>
        public DataTable GetAssociates()
        {
            DataTable associatesDataTable;
            try
            {
                associatesDataTable = dbProfile.GetAssociates();
                DSUtils.AddEmptyRecord(associatesDataTable);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return associatesDataTable;
        }
        /// <summary>
        /// Gets all roles in the database (except Program manager and core team member)
        /// </summary>
        /// <returns>datatable containing information about all roles in the database</returns>
        public DataTable GetRoles()
        {
            DataTable rolesDataTable;
            try
            {
                rolesDataTable = dbProfile.GetRoles();
                DSUtils.AddEmptyRecord(rolesDataTable);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return rolesDataTable;
        }

        /// <summary>
        /// Gets the role of the given associate. If the associate does not have a role yet, an empty datatable is returned
        /// </summary>
        /// <param name="idAssociate">the id of the associate</param>
        /// <returns></returns>
        public DataTable GetAssociateRole(int idAssociate)
        {
            DataTable associateRoleDataTable;
            try
            {
                associateRoleDataTable = dbProfile.GetAssociateRole(idAssociate);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return associateRoleDataTable;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public DataTable GetAssociateRoles()
        {
            DataTable associateRolesDataTable;
            try
            {
                associateRolesDataTable = dbProfile.GetAsscoiateRoles();
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return associateRolesDataTable;
        }
        /// <summary>
        /// save access role for given associate    
        /// </summary>
        /// <param name="idAssociate"></param>
        /// <param name="idRole"></param>
        /// <returns></returns>
        public int SaveAssociateRole(int idAssociate, int idRole)
        {
            int result;
            try
            {
                result = dbProfile.SaveAssociateRole(idAssociate, idRole);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return result;
        }
        /// <summary>
        /// delete any role for given associate
        /// </summary>
        /// <param name="idAssociate"></param>
        /// <returns></returns>
        public int DeleteAssociateRole(int idAssociate)
        {
            int result;
            try
            {
                result = dbProfile.DeleteAssociateRole(idAssociate);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return result;
        }
        #endregion Public Methods
    }
}
