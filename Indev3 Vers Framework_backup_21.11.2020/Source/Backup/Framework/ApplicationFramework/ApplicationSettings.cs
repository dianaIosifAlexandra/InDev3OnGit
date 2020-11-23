using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Configuration;


namespace Inergy.Indev3.ApplicationFramework
{
    /// <summary>
    /// used for wrapping user and technical settings
    /// </summary>
    public class ApplicationSettings
    {
        private string sqlServerName;
        private string sqlUserName;
        private string sqlPassword;
        private string sqlDatabaseName;
        private string mailServer;
        private string mailFrom;
        private int _ConnectionTimeout;
        private int _CommandTimeout;

        public string Skin = "IndGenericGrid";
               

        /// <summary>
        /// property to store SQL server name from web.config
        /// </summary>
        public string SqlServerName
        {
            get { return sqlServerName; }
            set { sqlServerName = value; }
        }


        /// <summary>
        /// property used to store sql user name from web.config
        /// </summary>
        public string SqlUserName
        {
            get { return sqlUserName; }
            set { sqlUserName = value; }
        }


        /// <summary>
        /// property used to store sql password from web.config
        /// </summary>
        public string SqlPassword
        {
            get { return sqlPassword; }
            set { sqlPassword = value; }
        }
        /// <summary>
        /// property used to store sql database name from web.config
        /// </summary>
        public string SqlDatabaseName
        {
            get { return sqlDatabaseName; }
            set { sqlDatabaseName = value; }
        }
        /// <summary>
        /// property used to store mail sever from web.config
        /// </summary>
        public string MailServer
        {
            get { return mailServer; }
            set { mailServer = value; }
        }
        /// <summary>
        /// property used to store mail_from from web.config file
        /// </summary>
        public string MailFrom
        {
            get { return mailFrom; }
            set { mailFrom = value; }
        }

        private string _ConnectionString;
        /// <summary>
        /// property used to store connection string from web.config file
        /// </summary>
        public string ConnectionString
        {
            get
            {
                if (String.IsNullOrEmpty(SqlServerName) && String.IsNullOrEmpty(SqlDatabaseName)
                    && String.IsNullOrEmpty(SqlUserName) && String.IsNullOrEmpty(SqlPassword))
                    return null;
                else
                    return this._ConnectionString = "Data Source=" + SqlServerName + ";Initial Catalog=" + SqlDatabaseName + "; User ID="
                                         + SqlUserName + ";Password=" + SqlPassword + ";Connection Timeout=" + _ConnectionTimeout + ";";
            }
            set { this._ConnectionString = value; }
        }



        private bool _DisplayErrorDetails = true;
        /// <summary>
        /// Specify if the application should display detailed error messages to the user
        /// </summary>
        public bool DisplayErrorDetails
        {
            get { return this._DisplayErrorDetails; }
        }

        public int ConnectionTimeout
        {
            get { return _ConnectionTimeout; }
            set { _ConnectionTimeout = value; }
        }

        public int CommandTimeout
        {
            get { return _CommandTimeout; }
            set { _CommandTimeout = value; }
        }
    }

}