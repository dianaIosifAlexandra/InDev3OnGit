using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.Entities.UserSettings;
using Inergy.Indev3.ApplicationFramework;
using System.Data.SqlClient;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;



namespace Inergy.Indev3.DataAccess.UserSettings
{
    public class DBUserSettings : DBGenericEntity
    {
        public DBUserSettings(object connectionManager)
            : base(connectionManager)
        {
        }
        /// <summary>
        /// method used to update user settings
        /// </summary>
        /// <param name=""></param>
        /// <returns>return true if operation succeded</returns>
        public bool usrInsertOrUpdateUserSettings(IUserSettings userSettings)
        {
            int returnValue;
            try
            {
                SqlCommand cmd = new SqlCommand("usrInsertOrUpdateUserSettings");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@AssociateId", SqlDbType.Int).Value = userSettings.AssociateId;
                cmd.Parameters.Add("@AmountScaleOption", SqlDbType.Int).Value = userSettings.AmountScaleOption;
                cmd.Parameters.Add("@NumberOfRecordsPerPage", SqlDbType.Int).Value = userSettings.NumberOfRecordsPerPage;
                cmd.Parameters.Add("@CurrencyRepresentation", SqlDbType.Int).Value = userSettings.CurrencyRepresentation;

                returnValue = CurrentConnectionManager.ExecuteStoredProcedure(cmd);
            }
            catch (SqlException ex)
            {
                throw new IndException(ex);
            }
            return (returnValue == 1);
        }
        /// <summary>
        /// method used to retrieve user settings from database
        /// </summary>
        /// <param name="associateId"></param>
        public DataTable usrSelectUserSettings(int associateId)
        {
            DataTable dt = new DataTable();
            try
            {
                SqlCommand cmd = new SqlCommand("usrSelectUserSettings");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@AssociateId", SqlDbType.Int).Value = associateId;
                dt = CurrentConnectionManager.GetDataTable(cmd);
            }
            catch (SqlException ex)
            {
                throw new IndException(ex);
            }
            return dt;
        }
    }
}
