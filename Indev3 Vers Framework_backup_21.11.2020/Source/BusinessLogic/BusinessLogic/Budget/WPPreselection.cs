using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using System.Data;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.Timing_Interco;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class WPPreselection : GenericEntity, IWPPreselection
    {
        #region IWPPreselection Members
        private int _EndYearMonth;
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
        private int _IdLastUserUpdate;
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
        private int _IdPhase;
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
        private int _IdProject;
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
        private int _IdWP;
        public int IdWP
        {
            get
            {
                return _IdWP;
            }
            set
            {
                _IdWP = value;
            }
        }
        private DateTime _LastUpdate;
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
        private string _LastUserUpdateName;
        public string LastUserUpdateName
        {
            get
            {
                return _LastUserUpdateName;
            }
            set
            {
                _LastUserUpdateName = value;
            }
        }
        private string _PhaseName;
        public string PhaseName
        {
            get
            {
                return _PhaseName;
            }
            set
            {
                _PhaseName = value;
            }
        }
        private int _StartYearMonth;
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
        private string _WPName;
        public string WPName
        {
            get
            {
                return _WPName;
            }
            set
            {
                _WPName = value;
            }
        }
        private string _WPCode;
        public string WPCode
        {
            get
            {
                return _WPCode;
            }
            set
            {
                _WPCode = value;
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

        private string _BudgetType;
        /// <summary>
        /// The type of budget to be viewed (used only when coming from follow-up)
        /// </summary>
        public string BudgetType
        {
            get { return _BudgetType; }
            set { _BudgetType = value; }
        }

        private string _BudgetVersion;
        /// <summary>
        /// The version of the budget to be viewed (used only when coming from follow-up)
        /// </summary>
        public string BudgetVersion
        {
            get { return _BudgetVersion; }
            set { _BudgetVersion = value; }
        }

        private string _ActiveState;
        /// <summary>
        /// Coding for the "Active", "Inactive" or "All" wps that are viewed in preselection
        /// </summary>
        public string ActiveState
        {
            get { return _ActiveState; }
            set { _ActiveState = value; }
        }


        private bool _IsFromFollowUp;
        /// <summary>
        /// Shows if the object is used from follow-up. To be set by the user
        /// </summary>
        public bool IsFromFollowUp
        {
            get { return _IsFromFollowUp; }
            set { _IsFromFollowUp = value; }
        }

        #endregion

        #region Constructors
        public WPPreselection(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBWPPreselection(connectionManager));
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
            _IdPhase = ApplicationConstants.INT_NULL_VALUE;
            _IdWP = ApplicationConstants.INT_NULL_VALUE;
            _StartYearMonth = ApplicationConstants.INT_NULL_VALUE;
            _EndYearMonth = ApplicationConstants.INT_NULL_VALUE;
            _IdLastUserUpdate = ApplicationConstants.INT_NULL_VALUE;
            _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
            _IsFromFollowUp = false;
        }

        public WPPreselection(DataRow row, object connectionManager)
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
        #endregion Constructors

        #region Public Methods
        public void BulkInsertWP(WPList wpList)
        {
            try
            {
                string bulkInsertString = BuildBulkInsertString(wpList);
                ((DBWPPreselection)GetEntity()).BulkInsert(bulkInsertString);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public DataSet GetUnusedWP()
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet("SelectWPUnused", this);
                ConversionUtils.MakeUniqueKey(ds.Tables[0], new string[] { "IdProject", "IdPhase", "IdWP" });
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }
        
        /// <summary>
        /// Given a list of work packages that have only the key (IdProject, IdPhase, IdWorkPackage), returns a table
        /// containing all the wp preselection data for each of these work packages (startym, endym)
        /// </summary>
        /// <param name="selectedItems">List of work packages that have only the key (IdProject, IdPhase, IdWorkPackage) filled in</param>
        /// <returns>Table containing all the wp preselection data for each of these work packages (startym, endym)</returns>
        public DataTable GetPreselectionData(List<IntercoLogicalKey> keys)
        {
            DataTable dtResult = null;
            try
            {
                foreach (IntercoLogicalKey key in keys)
                {
                    SetKey(key);
                    DataSet ds = this.GetEntity().GetCustomDataSet("SelectWPInfo", this);
                    if (dtResult == null)
                        dtResult = ds.Tables[0].Clone();
                    //check that wp keys was not change meanwhile by another user
                    if (ds.Tables[0].Rows.Count == 0)
                        throw new IndException(ApplicationMessages.EXCEPTION_PRESELECTION_WP_PHASE_CHANGED);
                    DataRow row = ds.Tables[0].Rows[0];
                    dtResult.ImportRow(row);
                    
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dtResult;
        }

        public DataTable GetPreselectionData()
        {
            DataSet dsResult = null;
            try
            {
                dsResult = this.GetEntity().GetCustomDataSet("SelectWPInfo", this);
                if (dsResult.Tables.Count == 0)
                    throw new IndException("bgtSelectWPPreselectionInfo stored procedure returned a wrong number of tables.");
                //if the row not exist anymore for the selected key (idproject, idphase, idworkpackage) than someone else modified workpackage and
                //error must be thrown
                if (dsResult.Tables[0].Rows.Count == 0)
                    throw new IndException(ApplicationMessages.EXCEPTION_PRESELECTION_WP_PHASE_CHANGED);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dsResult.Tables[0];
        }

        public void DeleteWPInfo()
        {
            try
            {
                this.GetEntity().ExecuteCustomProcedure("DeleteWPInfo", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        #endregion Public Methods
        
        #region Private Methods
        /// <summary>
        /// Creates the bulk insert string
        /// </summary>
        /// <param name="wpList">list containing IntercoLogicalKey objects</param>
        /// <returns>the bulk insert string</returns>
        private string BuildBulkInsertString(WPList wpList)
        {
            StringBuilder bulkInsertString = new StringBuilder();
            bulkInsertString.Append("IF object_id(N'tempdb.dbo.#BUDGET_PRESELECTION_TEMP') IS NULL CREATE TABLE #BUDGET_PRESELECTION_TEMP (IdProject INT, IdPhase INT, IdWP INT)\r\n");
            bulkInsertString.Append("DELETE FROM #BUDGET_PRESELECTION_TEMP\r\n");
            //Start of transaction
            bulkInsertString.Append("BEGIN TRANSACTION\r\n");
            //Insert template
            string insertTemplate = "INSERT INTO #BUDGET_PRESELECTION_TEMP VALUES({0}, {1}, {2})\r\n";
            //Insert values
            foreach (IntercoLogicalKey key in wpList)
            {
                string currentInsert = string.Format(insertTemplate, key.IdProject, key.IdPhase, key.IdWP);
                bulkInsertString.Append(currentInsert);
            }
            //End transaction
            bulkInsertString.Append("COMMIT TRANSACTION");
            return bulkInsertString.ToString();
        }

        private void SetKey(IntercoLogicalKey key)
        {
            this.IdProject = key.IdProject;
            this.IdPhase = key.IdPhase;
            this.IdWP = key.IdWP;
            this.WPCode = key.WPCode;
        }

        #endregion Private Methods
        
        #region Overrides
        protected override void Row2Object(DataRow row)
        {
            _IdProject = (int)row["IdProject"];
            _IdPhase = (int)row["IdPhase"];
            _IdWP = (int)row["IdWP"];
            _StartYearMonth = (row["StartYearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["StartYearMonth"];
            _EndYearMonth = (row["EndYearMonth"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["EndYearMonth"];
            _IdLastUserUpdate = (int)row["IdLastUserUpdate"];
        }
        #endregion Overrides
    }
}
