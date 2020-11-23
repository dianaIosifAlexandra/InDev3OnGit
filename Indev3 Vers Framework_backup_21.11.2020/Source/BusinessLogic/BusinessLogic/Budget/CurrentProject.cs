using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// Represents the Project Core Team entity
    /// </summary>
    public class CurrentProject : GenericEntity, ICurrentProject
    {
        #region ICurrentProject Members

        private string _ProgramName;
        public string ProgramName
        {
            get
            {
                return _ProgramName;
            }
            set
            {
                _ProgramName = value;
            }
        }
        private string _Name;
        public string Name
        {
            get
            {
                return _Name;
            }
            set
            {
                _Name = value;
            }
        }
        private int _IdOwner;
        public int IdOwner
        {
            get
            {
                return _IdOwner;
            }
            set
            {
                _IdOwner = value;
            }
        }
        private int _IdAssociate;
        public int IdAssociate
        {
            get
            {
                return _IdAssociate;
            }
            set
            {
                _IdAssociate = value;
            }
        }
        private int _IdProgram;
        public int IdProgram
        {
            get
            {
                return _IdProgram;
            }
            set
            {
                _IdProgram = value;
            }
        }

        private int _IdVersion;
        public int IdVersion
        {
            get
            {
                return _IdVersion;
            }
            set
            {
                _IdVersion = value;
            }
        }

        private string _ShowOnly;
        public string ShowOnly
        {
            get
            {
                return _ShowOnly;
            }
            set
            {
                _ShowOnly = value;
            }
        }

        private string _ProgramCode;
        public string ProgramCode
        {
            get { return _ProgramCode; }
            set { _ProgramCode = value; }
        }

        private string _ProjectCode;
        public string ProjectCode
        {
            get { return _ProjectCode; }
            set { _ProjectCode = value; }
        }
        private string _ProjectFunctionWPCodeSuffix;
        public string ProjectFunctionWPCodeSuffix
        {
            get { return _ProjectFunctionWPCodeSuffix; }
            set { _ProjectFunctionWPCodeSuffix = value; }
        }

        #endregion

        #region Constructors
        public CurrentProject(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBCurrentProject(connectionManager));
            _IdOwner = ApplicationConstants.INT_NULL_VALUE;
            _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
            _IdProgram = ApplicationConstants.INT_NULL_VALUE;
            _ShowOnly = ApplicationConstants.SHOW_ONLY_ACTIVE_PROJECTS;
            _IdVersion = ApplicationConstants.INT_NULL_VALUE; 
        }

        public CurrentProject(DataRow row, object connectionManager)
            : this(connectionManager)
        {
            try
            {
                Row2Object(row);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion

        #region Protected Methods
        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["ProjectId"];
            this.ProgramName = row["ProgramName"].ToString();
            this.Name = row["ProjectName"].ToString();
            this.IdProgram = (row["ProgramId"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["ProgramId"];
            this.IdOwner = (row["OwnerId"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["OwnerId"];
            ProgramCode = row["ProgramCode"].ToString();
            ProjectCode = row["ProjectCode"].ToString();
            ProjectFunctionWPCodeSuffix = row["ProjectFunctionWPCodeSuffix"].ToString();
        }
        #endregion Protected Methods
    }
}
