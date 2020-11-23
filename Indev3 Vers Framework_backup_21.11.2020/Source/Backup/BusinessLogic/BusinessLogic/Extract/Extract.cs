using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Inergy.Indev3.Entities.Extract;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.DataAccess.Extract;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogic.Extract
{
    public class Extract : GenericEntity, IExtract
    {
        #region Members

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

        private int _IdProgram;
        public int IdProgram
        {
            get { return _IdProgram; }
            set { _IdProgram = value; }
        }
        private int _Year;
        public int Year
        {
            get
            {
                return _Year;
            }
            set
            {
                _Year = value;
            }
        }
        private int _IdGeneration;
        public int IdGeneration
        {
            get
            {
                return _IdGeneration;
            }
            set
            {
                _IdGeneration = value;
            }
        }
        private int _IdCurrencyAssociate;
        public int IdCurrencyAssociate
        {
            get
            {
                return _IdCurrencyAssociate;
            }
            set
            {
                _IdCurrencyAssociate = value;
            }
        }
        private string _ActiveStatus;
        public string ActiveStatus
        {
            get
            {
                return _ActiveStatus;
            }
            set
            {
                _ActiveStatus = value;
            }
        }
        #endregion


        #region Constructor
        public Extract(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBExtract(connectionManager));
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
            _IdProgram = ApplicationConstants.INT_NULL_VALUE;
            _Year = ApplicationConstants.INT_NULL_VALUE;
            _IdGeneration = ApplicationConstants.INT_NULL_VALUE;
            _IdCurrencyAssociate = ApplicationConstants.INT_NULL_VALUE;
        }
        #endregion

        #region Methods

        public DataSet GetExtractData(int iSelectedType, int iSelectedSource)
        {
            try
            {
                switch (iSelectedType)
                {
                    case (int)EExtractType.entire_program:
                        return GetProgramData(iSelectedSource);
                    case (int)EExtractType.project_only:
                        return GetProjectData(iSelectedSource);
                    default:
                        throw new IndException("Extract type switch exception");
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public DataSet GetProjectData(int iSelectedSource)
        {
            try
            {
                switch (iSelectedSource)
                {
                    case (int)EExtractSource.actual:
                        return this.GetEntity().GetCustomDataSet("ExtractProjectActualData", this);
                    case (int)EExtractSource.initial:
                        return this.GetEntity().GetCustomDataSet("ExtractProjectInitialData", this);
                    case (int)EExtractSource.reforecast:
                        return this.GetEntity().GetCustomDataSet("ExtractProjectReforcastData", this);
                    case (int)EExtractSource.revised:
                        return this.GetEntity().GetCustomDataSet("ExtractProjectRevisedData", this);
                    case (int) EExtractSource.annual_budget:
                        return this.GetEntity().GetCustomDataSet("ExtractProjectAnnualData", this);
                    default:
                        throw new IndException("Project switch exception");
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }

        public DataSet GetProgramData(int iSelectedSource)
        {
            try
            {
                switch (iSelectedSource)
                {
                    case (int)EExtractSource.actual:
                        return this.GetEntity().GetCustomDataSet("ExtractProgramActualData", this);
                    case (int)EExtractSource.initial:
                        return this.GetEntity().GetCustomDataSet("ExtractProgramInitialData", this);
                    case (int)EExtractSource.reforecast:
                        return this.GetEntity().GetCustomDataSet("ExtractProgramReforcastData", this);
                    case (int)EExtractSource.revised:
                        return this.GetEntity().GetCustomDataSet("ExtractProgramRevisedData", this);
                    case (int)EExtractSource.annual_budget:
                        return this.GetEntity().GetCustomDataSet("ExtractProgramAnnualData", this);
                    default:
                        throw new IndException("Program switch exception");
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion
    }
}
