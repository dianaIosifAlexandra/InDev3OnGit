using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.Entities;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class InitialBudgetOtherCosts : GenericEntity, IInitialBudgetOtherCosts
    {
        #region Properties

        #region Properties used for Foreign Key
        private int _IdProject;
        public int IdProject
        {
            get { return _IdProject; }
            set { _IdProject = value; }
        }

        private int _IdPhase;
        public int IdPhase
        {
            get { return _IdPhase; }
            set { _IdPhase = value; }
        }

        private int _IdWP;
        public int IdWP
        {
            get { return _IdWP; }
            set { _IdWP = value; }
        }

        private int _IdCostCenter;
        public int IdCostCenter
        {
            get { return _IdCostCenter; }
            set { _IdCostCenter = value; }
        }

        private int _IdAssociate;
        public int IdAssociate
        {
            get { return _IdAssociate; }
            set { _IdAssociate = value; }
        }

        private int _IdAssociateViewer;
        public int IdAssociateViewer
        {
            get { return _IdAssociateViewer; }
            set { _IdAssociateViewer = value; }
        }

        private int _YearMonth;
        public int YearMonth
        {
            get { return _YearMonth; }
            set { _YearMonth = value; }
        }

        private bool _IsAssociateCurrency;
        //Specifies if the values from the budget object are in the currency of the associate
        public bool IsAssociateCurrency
        {
            get { return _IsAssociateCurrency; }
            set { _IsAssociateCurrency = value; }
        }
        #endregion Properties used for foreign Key

        #region Properties used for Select
        private decimal _TE = 0;
        public decimal TE
        {
            get { return _TE; }
            set { _TE = value; }
        }

        private decimal _ProtoParts = 0;
        public decimal ProtoParts
        {
            get { return _ProtoParts; }
            set { _ProtoParts = value; }
        }

        private decimal _ProtoTooling = 0;
        public decimal ProtoTooling
        {
            get { return _ProtoTooling; }
            set { _ProtoTooling = value; }
        }

        private decimal _Trials = 0;
        public decimal Trials
        {
            get { return _Trials; }
            set { _Trials = value; }
        }

        private decimal _OtherExpenses = 0;
        public decimal OtherExpenses
        {
            get { return _OtherExpenses; }
            set { _OtherExpenses = value; }
        }

        public decimal TotalValue
        {
            get 
            {
                if ((_TE == ApplicationConstants.DECIMAL_NULL_VALUE) && (_ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE) && (_ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE) &&
                    (_Trials == ApplicationConstants.DECIMAL_NULL_VALUE) && (_OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE))
                    return ApplicationConstants.DECIMAL_NULL_VALUE;

                return ((_TE == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : _TE) + ((_ProtoParts == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : _ProtoParts) +
                    ((_ProtoTooling == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : _ProtoTooling) + ((_Trials == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : _Trials) +
                    ((_OtherExpenses == ApplicationConstants.DECIMAL_NULL_VALUE) ? 0 : _OtherExpenses);

            }
        }
        #endregion Properties used for Select

        #region Properties used at Insert/Update
        private EOtherCostTypes _IdCostType;
        public EOtherCostTypes IdCostType
        {
            get { return _IdCostType; }
            set { _IdCostType = value; }
        }

        private decimal _CostVal;
        public decimal CostVal
        {
            get { return _CostVal; }
            set { _CostVal = value; }
        }
        #endregion Properties used at Insert/Update

        #endregion Properties

        #region Constructors
        public InitialBudgetOtherCosts(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBInitialBudgetOtherCosts(connectionManager));
        }
        #endregion Constructors

        #region Internal Methods
        internal void SaveSplitted(YearMonth startYearMonth, YearMonth endYearMonth, bool isAssociateCurrency, int idCostCenter, int associateCurrency, CurrencyConverter converter)
        {
			bool splitOtherCostsUniform = (ApplicationConstants.SPLIT_OTHER_COSTS_ALGORYTHM == ApplicationConstants.SPLIT_OTHER_COSTS_ALGORYTHM_UNIFORM);
			int monthsNo = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;
			
			decimal[] TEList = Rounding.Divide(this._TE, monthsNo);
			decimal[] ProtoPartsList = Rounding.Divide(this._ProtoParts, monthsNo);
			decimal[] ProtoToolingList = Rounding.Divide(this._ProtoTooling, monthsNo);
			decimal[] TrialsList = Rounding.Divide(this._Trials, monthsNo);
			decimal[] OtherExpensesList = Rounding.Divide(this._OtherExpenses, monthsNo);
            
            for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
            {
				InitialBudgetOtherCosts currentOtherCost = new InitialBudgetOtherCosts(this.CurrentConnectionManager);
                
                if (splitOtherCostsUniform)
                {
					int iteratorPosition = currentYearMonth.GetMonthsDiffrence(startYearMonth);

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.TE;
					currentOtherCost.CostVal = TEList[iteratorPosition];
	                
					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);
	               
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.ProtoParts;
					currentOtherCost.CostVal = ProtoPartsList[iteratorPosition];

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);

					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.ProtoTooling;
					currentOtherCost.CostVal = ProtoToolingList[iteratorPosition];

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);
	                
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.Trials;
					currentOtherCost.CostVal = TrialsList[iteratorPosition];

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);
	                
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.OtherExpenses;
					currentOtherCost.CostVal = OtherExpensesList[iteratorPosition];

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);
	                
					currentOtherCost.Save();
                }
				else
				{
					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.TE;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._TE : 0);

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);

					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.ProtoParts;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._ProtoParts : 0);

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);

					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.ProtoTooling;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._ProtoTooling : 0);

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);

					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.Trials;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._Trials : 0);

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);

					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.OtherExpenses;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._OtherExpenses : 0);

					//Apply the cost center currency if this is the case
					if (isAssociateCurrency)
						currentOtherCost.ApplyCostCenterCurrency(idCostCenter, associateCurrency, converter);

					currentOtherCost.Save();
				}
				
            }
        }

        internal void SaveSplitted(YearMonth startYearMonth, YearMonth endYearMonth)
        {
			bool splitOtherCostsUniform = (ApplicationConstants.SPLIT_OTHER_COSTS_ALGORYTHM == ApplicationConstants.SPLIT_OTHER_COSTS_ALGORYTHM_UNIFORM);
            int monthsNo = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;

            decimal[] TEList = Rounding.Divide(this._TE, monthsNo);
            decimal[] ProtoPartsList = Rounding.Divide(this._ProtoParts, monthsNo);
            decimal[] ProtoToolingList = Rounding.Divide(this._ProtoTooling, monthsNo);
            decimal[] TrialsList = Rounding.Divide(this._Trials, monthsNo);
            decimal[] OtherExpensesList = Rounding.Divide(this._OtherExpenses, monthsNo);


            for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
            {
                InitialBudgetOtherCosts currentOtherCost = new InitialBudgetOtherCosts(this.CurrentConnectionManager);

				if (splitOtherCostsUniform)
				{
					int iteratorPosition = currentYearMonth.GetMonthsDiffrence(startYearMonth);

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.TE;
					currentOtherCost.CostVal = TEList[iteratorPosition];
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.ProtoParts;
					currentOtherCost.CostVal = ProtoPartsList[iteratorPosition];
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.ProtoTooling;
					currentOtherCost.CostVal = ProtoToolingList[iteratorPosition];
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.Trials;
					currentOtherCost.CostVal = TrialsList[iteratorPosition];
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.OtherExpenses;
					currentOtherCost.CostVal = OtherExpensesList[iteratorPosition];
					currentOtherCost.Save();
                }
				else
				{
					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.TE;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._TE : 0);
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.ProtoParts;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._ProtoParts : 0);
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.ProtoTooling;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._ProtoTooling : 0);
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.Trials;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._Trials : 0);
					currentOtherCost.Save();

					currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
					currentOtherCost.IdCostType = EOtherCostTypes.OtherExpenses;
					currentOtherCost.CostVal = (currentYearMonth.Value == endYearMonth.Value ? this._OtherExpenses : 0);
					currentOtherCost.Save();	
				}
            }
        }
        #endregion Internal Methods

        #region Private Methods

        private void ApplyCostCenterCurrency(int idCostCenter, int associateCurrency, CurrencyConverter converter)
        {
            CostCenter currentCostCenter = new CostCenter(this.CurrentConnectionManager);
            currentCostCenter.Id = idCostCenter;
            int idCurrency = currentCostCenter.GetCostCenterCurrency().Id;

            _CostVal = converter.GetConversionValue(_CostVal, associateCurrency, new YearMonth(YearMonth), idCurrency);
        }

        private InitialBudgetOtherCosts CreateInstanceWithSameFlag(YearMonth yearMonth)
        {
            //Get an instance of an object
            InitialBudgetOtherCosts newOC = new InitialBudgetOtherCosts(this.CurrentConnectionManager);
            //Create primary key
            newOC.IdProject = this._IdProject;
            newOC.IdPhase = this._IdPhase;
            newOC.IdWP = this._IdWP;
            newOC.IdCostCenter = this._IdCostCenter;
            newOC.IdAssociate = this._IdAssociate;
            newOC.IdAssociateViewer = this._IdAssociateViewer;
            newOC.YearMonth = yearMonth.Value;

            //Set state flag
            if (this.State == EntityState.New)
                newOC.SetNew();
            if (this.State == EntityState.Modified)
                newOC.SetModified();
            if (this.State == EntityState.Deleted)
                newOC.SetDeleted();

            //Return the object
            return newOC;
        }
        #endregion Private Methods
    }
}
