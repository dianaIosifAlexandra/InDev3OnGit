using System;
using System.Data;
using System.Configuration;
using Inergy.Indev3.ApplicationFramework;
using System.Web.Configuration;

namespace Inergy.Indev3.UI
{

    /// <summary>
    /// Reads and writes settings in web.config file
    /// </summary>

    public class SqlSettingsSection : ConfigurationSection
    {
        [ConfigurationProperty("server", IsRequired = true)]
        public string SqlServerName
        {
            get { return EncryptingSupport.Base64DecodeString((string)base["server"]); }
            set { base["server"] = EncryptingSupport.Base64EncodeString(value); }
        }
        [ConfigurationProperty("userName", IsRequired = true)]
        public string SqlUserName
        {
            get { return EncryptingSupport.Base64DecodeString((string)base["userName"]); }
            set { base["userName"] = EncryptingSupport.Base64EncodeString(value); }
        }

        [ConfigurationProperty("password", IsRequired = true)]
        public string SqlPassword
        {
            get { return EncryptingSupport.Base64DecodeString((string)base["password"]); }
            set { base["password"] = EncryptingSupport.Base64EncodeString(value); }
        }

        [ConfigurationProperty("database", IsRequired = true)]
        public string SqlDatabaseName
        {
            get { return EncryptingSupport.Base64DecodeString((string)base["database"]); }
            set { base["database"] = EncryptingSupport.Base64EncodeString(value); }
        }

        [ConfigurationProperty("sqlConnectionTimeout", IsRequired = true)]
        public int ConnectionTimeout
        {
            get
            {
                int connectionTimeout;
                if (int.TryParse(base["sqlConnectionTimeout"].ToString(), out connectionTimeout) == false)
                    return 15;
                return connectionTimeout;
            }
            set { base["sqlConnectionTimeout"] = value; }
        }

        [ConfigurationProperty("sqlCommandTimeout", IsRequired = true)]
        public int CommandTimeout
        {
            get
            {
                int commandTimeout;
                if (int.TryParse(base["sqlCommandTimeout"].ToString(), out commandTimeout) == false)
                    return 30;
                return commandTimeout;
            }
            set { base["sqlCommandTimeout"] = value; }
        }
    }
    
    /// <summary>
    /// reads and write settings to web.config file Mail Section
    /// </summary>
    public class MailSettingsSection : ConfigurationSection
    {
        [ConfigurationProperty("mailServer", IsRequired = true)]
        public string MailServer
        {
            get { return (string)base["mailServer"]; }
            set { base["mailServer"] = value; }
        }

        [ConfigurationProperty("administrativeMail", IsRequired = true)]
        public string AdministrativeMail
        {
            get { return (string)base["administrativeMail"]; }
            set { base["administrativeMail"] = value; }
        }
    }

    /// <summary>
    /// reads and write settings to web.config file Reporting Settings
    /// </summary>
    public class ReportingSettingsSection : ConfigurationSection
    {
        [ConfigurationProperty("virtualDirectory", IsRequired = true)]
        public string VirtualDirectory
        {
            get { return (string)base["virtualDirectory"]; }
            set { base["virtualDirectory"] = value; }
        }
    }
}