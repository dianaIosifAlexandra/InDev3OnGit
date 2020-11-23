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
    /// Represents the WorkPackage entity
    /// </summary>
    public class WorkPackage : GenericEntity, IWorkPackage
    {
        #region IWorkPackage Members

        private string _Project;
        [PropertyValidation(false, 25)]
        [GridColumnProperty(false)]
        public string Project
        {
            get
            {
                return _Project;
            }
            set
            {
                _Project = value;
            }
        }
        
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
        private int _IdProject;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(Project))]
        [IsInLogicalKey()]
        [DesignerName("Project Name")]
        public int IdProject
        {
            get
            {
                return _IdProject;
            }
            set
            {
                _IdProject = value;
            }
        }

        private string _ProjectName;
        [PropertyValidation(true, 50)]
        [GridColumnProperty(false)]
        public string ProjectName
        {
            get
            {
                return _ProjectName;
            }
            set
            {
                _ProjectName = value;
            }
        }
             
        private DateTime _ProjectDate;
        [GridColumnProperty(false)]
        public DateTime ProjectDate
        {
            get
            {
                return _ProjectDate;
            }
            set
            {
                _ProjectDate = value;
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
        [ReferenceMapping(typeof(WorkPackage))]
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
        private int _StartYearMonth;
        [PropertyValidation(false)]
        [GridColumnProperty(false)]
        public int StartYearMonth
        {
            get
            {
                return _StartYearMonth;
            }
            set
            {
                _StartYearMonth = value;
            }
        }
        private int _EndYearMonth;
        [PropertyValidation(false)]
        [GridColumnProperty(false)]
        public int EndYearMonth
        {
            get
            {
                return _EndYearMonth;
            }
            set
            {
                _EndYearMonth = value;
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

        private int _IdProjectFunction;
        [GridColumnProperty(false)]
        public int IdProjectFunction
        {
            get
            {
                return _IdProjectFunction;
            }
            set
            {
                _IdProjectFunction = value;
            }
        }

        private int _IdAssociate;
        /// <summary>
        /// Used only for authorization. When IdAssociate a pozitive integer, only the work packages 
        /// of the projects for which this associate is program manager will be shown
        /// </summary>
        public int IdAssociate
        {
            get { return _IdAssociate; }
            set { _IdAssociate = value; }
        }

        private ApplicationSettings Settings;

        #endregion

        #region Constructors
        public WorkPackage()
            : this(null)
        {
        }
        public WorkPackage(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBWorkPackage(connectionManager));
            _IdPhase = ApplicationConstants.INT_NULL_VALUE;
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
            _IdLastUserUpdate = ApplicationConstants.INT_NULL_VALUE;
            _Rank = ApplicationConstants.INT_NULL_VALUE;
            _IsActive = true;
            _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
            _IsProgramManager = false;
            _IdProjectFunction = ApplicationConstants.INT_NULL_VALUE;
            _StartYearMonth = ApplicationConstants.INT_NULL_VALUE;
            _EndYearMonth = ApplicationConstants.INT_NULL_VALUE;
        }

        public WorkPackage(DataRow row, object connectionManager)
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
                if (editParameters.ContainsKey("IdProject"))
                {
                    this._IdProject = int.Parse(editParameters["IdProject"].ToString());
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
            this._IdProject= (int)row["IdProject"];
            this._ProjectName = row["ProjectName"].ToString();
            this._IsActive = lastIsActive = (bool)row["IsActive"];
            this._Name = row["Name"].ToString();
            this._Code = row["Code"].ToString();
            this._Rank = (int)row["Rank"];
            this._StartYearMonth = (row["StartYearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["StartYearMonth"];
            this._EndYearMonth = (row["EndYearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["EndYearMonth"];
            this._LastUpdate = (DateTime)row["LastUpdate"];
            this._LastUserUpdate = row["LastUserUpdate"].ToString();
            this._IdLastUserUpdate = (int)row["IdLastUserUpdate"];
            this._IsProgramManager = (bool)row["IsProgramManager"];
            this._IdProjectFunction = (int)row["IdProjectFunction"];
        }
        protected override void OnPreSave()
        {
            //TODO: Add validation that the start date can not be less than the start date of the project
            if ((this._EndYearMonth != ApplicationConstants.INT_NULL_VALUE) && (_StartYearMonth != ApplicationConstants.INT_NULL_VALUE))
                if (_EndYearMonth < _StartYearMonth)
                    throw new IndException(ApplicationMessages.EXCEPTION_END_DATE_MUST_BE_GREATER);

            if (this._EndYearMonth == ApplicationConstants.INT_YEAR_MONTH_NOT_VALID )
                throw new IndException(ApplicationMessages.EXCEPTION_VALUE_OF_YEARMONTH_END_NOT_VALID);
                
            if(this._StartYearMonth == ApplicationConstants.INT_YEAR_MONTH_NOT_VALID)
                throw new IndException(ApplicationMessages.EXCEPTION_VALUE_OF_YEARMONTH_START_NOT_VALID);

        }
        protected override void OnPostSave()
        {
            try
            {
                if (this.State == EntityState.Modified)
                {
                    string isActiveCheck;
                    if (IsActive == true)
                        isActiveCheck = "active";
                    else
                        isActiveCheck = "inactive";



                    //read new keys after update
                    ReadNewKeys();

                    DataSet ds = new DataSet();
                    DBWorkPackage dbWorkPackage = new DBWorkPackage(base.CurrentConnectionManager);
                    ds = dbWorkPackage.SelectObject(this);


                    string strFunction = "Project Manager";
                    if (ds.Tables[0].Rows[0]["IdProjectFunction"] != DBNull.Value &&
                        (int)ds.Tables[0].Rows[0]["IdProjectFunction"] == ApplicationConstants.PROJECT_FUNCTION_PROGRAM_ASSISTANT)
                        strFunction = "Program Assistant";

                    string mailSubject = String.Format("Project update {0}", this.ProjectName);
                    string mailText = "The work package " + this.Name + " of the project " + this.ProjectName + " has been turned to " + isActiveCheck + " by " + this.LastUserUpdate + ", " + strFunction + ". Please check your local system and see if you have something to invoice. This is an automatically sent email, please do not respond to it.";
                    
                    //Send the email only if the current user is program manager for this project
                    if ((bool)ds.Tables[0].Rows[0]["IsProgramManager"] == true)
                    {
                        if (IsActive != lastIsActive)
                        {
                            SendMail(mailSubject, mailText);
                        }
                    }
                }
            }
            //The exception can occur if the email was not sent. In this case, in addition to the exception message, we must add that
            //that the work package was not saved
            catch (Exception exc)
            {
                throw new IndException(exc.Message + " Work Package was not saved.");
            }
        }

        protected override DataSet PostGetEntities(DataSet ds)
        {
            DSUtils.ReplaceBooleanColumn("IsActive", ds, 0);

            DataColumn newStartDate = new DataColumn("Start Date", typeof(string));
            DataColumn newEndDate = new DataColumn("End Date", typeof(string));
            DataColumn newProjectCodeName = new DataColumn("Project", typeof(string));

            int oldStartDatePosition = ds.Tables[0].Columns["StartYearMonth"].Ordinal;
            int oldEndDatePosition = ds.Tables[0].Columns["EndYearMonth"].Ordinal;
            
            ds.Tables[0].Columns.Add(newStartDate);
            newStartDate.SetOrdinal(oldStartDatePosition);

            ds.Tables[0].Columns.Add(newEndDate);
            newEndDate.SetOrdinal(oldEndDatePosition);

            //move old YearMonth columns to the end - since they will be hidded
            DataColumn startYearMonthColumn = ds.Tables[0].Columns["StartYearMonth"];
            DataColumn endYearMonthColumn = ds.Tables[0].Columns["EndYearMonth"];
            startYearMonthColumn.SetOrdinal(ds.Tables[0].Columns.Count - 1);
            endYearMonthColumn.SetOrdinal(ds.Tables[0].Columns.Count - 1);

            ds.Tables[0].Columns.Add(newProjectCodeName);

            //transform the null values for StartYearMonth and EndYearMonth
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                int startYearMonth = (row["StartYearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["StartYearMonth"];
                int endYearMonth = (row["EndYearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["EndYearMonth"];

                //Get the startyearmonth value
                if (startYearMonth == ApplicationConstants.INT_NULL_VALUE)
                    row["Start Date"] = String.Empty;
                else
                    row["Start Date"] = DateTimeUtils.GetDateFromYearMonth(startYearMonth);

                //Get the endyearmonth value
                if (endYearMonth == ApplicationConstants.INT_NULL_VALUE)
                    row["End Date"] = String.Empty;
                else
                    row["End Date"] = DateTimeUtils.GetDateFromYearMonth(endYearMonth);
            }
            return ds;
        }

        #endregion Protected Methods

        private void SendMail(string mailSubject, string mailBody)
        {         
            EmailSupport email = new EmailSupport();
            DataSet dsIntercoCountries = this.GetEntity().GetCustomDataSet("GetIntercoCountries", this);
            foreach (DataRow row in dsIntercoCountries.Tables[0].Rows)
            {
                string mailTo = row["Email"].ToString();
                if (!String.IsNullOrEmpty(mailTo))
                {
                    email.SendMailMessage(Settings.MailServer, Settings.MailFrom, mailTo, mailSubject, mailBody);
                }
            }

        }

        private void ReadNewKeys()
        {
            DataSet dsNewKeys = this.GetEntity().GetCustomDataSet("GetWorkPackageNewKeys", this);
            if(dsNewKeys.Tables.Count == 1 && dsNewKeys.Tables[0].Rows.Count == 1)
            {
                this.IdProject = (int)dsNewKeys.Tables[0].Rows[0]["IdProject"];
                this.IdPhase = (int)dsNewKeys.Tables[0].Rows[0]["IdPhase"];
                this.Id = (int)dsNewKeys.Tables[0].Rows[0]["Id"];
            }
        }
        
    }
}
