using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Upload;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Data;
using Inergy.Indev3.DataAccess.Upload;
using Inergy.Indev3.ApplicationFramework.Attributes;

namespace Inergy.Indev3.BusinessLogic.Upload
{
    public class DataStatus : GenericEntity, IDataStatus
    {
        #region Public Properties
        private int _Year;
        public int Year
        {
            get { return _Year; }
            set { _Year = value; }
        }
        #endregion Public Properties;

        #region Constructors
        public DataStatus()
            : this(null)
        {
        }
        public DataStatus(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBDataStatus(connectionManager));
        }
        #endregion
    }
}
