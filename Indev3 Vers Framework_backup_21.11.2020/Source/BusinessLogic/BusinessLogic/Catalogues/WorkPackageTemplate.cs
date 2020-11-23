using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.Entities;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the WorkPackageTemplate entity
    /// </summary>
    public class WorkPackageTemplate : GenericEntity, IWorkPackageTemplate
    {
        #region IWorkPackageTemplate Members

        private int _IdPhase;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(ProjectPhase))]
        [IsInLogicalKey()]
        [DesignerName("Phase")]
        public int IdPhase
        {
            get
            {
                return _IdPhase;
            }
            set
            {
                _IdPhase = value;
            }
        }
        private string _ProjectPhase;
        [PropertyValidation(true, 50)]
        [GridColumnProperty("Phase")]
        public string ProjectPhase
        {
            get
            {
                return _ProjectPhase;
            }
            set
            {
                _ProjectPhase = value;
            }
        }
       
        /// <summary>
        /// Here is kept the last state of IsActive checkbox
        /// </summary>
        private bool lastIsActive;

        private bool _IsActive;
        [PropertyValidation(true)]
        [GridColumnProperty("Active")]
        public bool IsActive
        {
            get
            {
                return _IsActive;
            }
            set
            {
                _IsActive = value;
            }
        }
        private string _Name;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Name")]
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
        private string _Code;
        [PropertyValidation(true, 3)]
        [GridColumnProperty("Code")]
        public string Code
        {
            get
            {
                return _Code;
            }
            set
            {
                _Code = value;
            }
        }
        private int _Rank;
        [PropertyValidation(true, 8)]
        [GridColumnProperty("Rank")]
        [DesignerName("Rank")]
        [ReferenceMapping(typeof(WorkPackageTemplate))]
        [SortBy()]
        public int Rank
        {
            get
            {
                return _Rank;
            }
            set
            {
                _Rank = value;
            }
        }
       
        private DateTime _LastUpdate;
        [PropertyValidation(true)]
        [GridColumnProperty("Last Update")]
        public DateTime LastUpdate
        {
            get
            {
                return _LastUpdate;
            }
            set
            {
                _LastUpdate = value;
            }
        }
        private int _IdLastUserUpdate;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        public int IdLastUserUpdate
        {
            get
            {
                return _IdLastUserUpdate;
            }
            set
            {
                _IdLastUserUpdate = value;
            }
        }
        private string _LastUserUpdate;
        [PropertyValidation(false, 50)]
        [GridColumnProperty("Last User")]
        public string LastUserUpdate
        {
            get
            {
                return _LastUserUpdate;
            }
            set
            {
                _LastUserUpdate = value;
            }
        }
        private bool _IsProgramManager;
        public bool IsProgramManager
        {
            get
            {
                return _IsProgramManager;
            }
            set
            {
                _IsProgramManager = value;
            }
        }

        private ApplicationSettings Settings;

        #endregion

        #region Constructors
        public WorkPackageTemplate()
            : this(null)
        {
        }
        public WorkPackageTemplate(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBWorkPackageTemplate(connectionManager));
            _IdPhase = ApplicationConstants.INT_NULL_VALUE;
            _IdLastUserUpdate = ApplicationConstants.INT_NULL_VALUE;
            _Rank = ApplicationConstants.INT_NULL_VALUE;
            _IsActive = true;
            _IsProgramManager = false;
        }

        public WorkPackageTemplate(DataRow row, object connectionManager)
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

        #region Public Methods
        public override void FillEditParameters(Dictionary<string, object> editParameters)
        {
            try
            {
                base.FillEditParameters(editParameters);
                if (editParameters.ContainsKey("IdPhase"))
                {
                    this._IdPhase = int.Parse(editParameters["IdPhase"].ToString());
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public void SetSettings(ApplicationSettings settings)
        {
            Settings = settings;
        }
        #endregion Public Methods

        #region Protected Methods
        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this._IdPhase = (int)row["IdPhase"];
            this._ProjectPhase = row["ProjectPhase"].ToString();
            this._IsActive = lastIsActive = (bool)row["IsActive"];
            this._Name = row["Name"].ToString();
            this._Code = row["Code"].ToString();
            this._Rank = (int)row["Rank"];
            this._LastUpdate = (DateTime)row["LastUpdate"];
            this._LastUserUpdate = row["LastUserUpdate"].ToString();
            this._IdLastUserUpdate = (int)row["IdLastUserUpdate"];
            this._IsProgramManager = (bool)row["IsProgramManager"];
        }
        

        protected override DataSet PostGetEntities(DataSet ds)
        {
            DSUtils.ReplaceBooleanColumn("IsActive", ds, 0);
            
            return ds;
        }

        #endregion Protected Methods

        private void ReadNewKeys()
        {
            DataSet dsNewKeys = this.GetEntity().GetCustomDataSet("GetWorkPackageTemplateNewKeys", this);
            if (dsNewKeys.Tables.Count == 1 && dsNewKeys.Tables[0].Rows.Count == 1)
            {
                this.IdPhase = (int)dsNewKeys.Tables[0].Rows[0]["IdPhase"];
                this.Id = (int)dsNewKeys.Tables[0].Rows[0]["Id"];
            }
        }

    }
}
