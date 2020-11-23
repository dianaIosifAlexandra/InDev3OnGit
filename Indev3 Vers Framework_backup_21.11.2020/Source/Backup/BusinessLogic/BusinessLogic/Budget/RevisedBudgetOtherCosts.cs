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
    public class RevisedBudgetOtherCosts : GenericEntity, IRevisedBudgetOtherCosts
    {
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

        #region Properties used at Insert/Update
        private EOtherCostTypes _IdCostType;
        public EOtherCostTypes IdCostType
        {
            get { return _IdCostType; }
            set { _IdCostType = value; }
        }

        private decimal _CostVal = ApplicationConstants.DECIMAL_NULL_VALUE ;
        public decimal CostVal
        {
            get { return _CostVal; }
            set { _CostVal = value; }
        }
        #endregion Properties used at Insert/Update

        #region Properties used for Select
        private ActualRevisedCosts _CurrentCosts;

        public ActualRevisedCosts CurrentCosts
        {
            get { return _CurrentCosts; }
            set { _CurrentCosts = value; }
        }
        private ActualRevisedCosts _UpdateCosts;

        public ActualRevisedCosts UpdateCosts
        {
            get { return _UpdateCosts; }
            set { _UpdateCosts = value; }
        }
        private ActualRevisedCosts _NewCosts;

        public ActualRevisedCosts NewCosts
        {
            get { return _NewCosts; }
            set { _NewCosts = value; }
        }
        #endregion Properties used for Select

        #region Constructors
        public RevisedBudgetOtherCosts()
            : base(null)
        {
            _CurrentCosts = new ActualRevisedCosts();
            _UpdateCosts = new ActualRevisedCosts();
            _NewCosts = new ActualRevisedCosts();
        }
        public RevisedBudgetOtherCosts(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBRevisedBudgetOtherCosts(connectionManager));
            _CurrentCosts = new ActualRevisedCosts();
            _UpdateCosts = new ActualRevisedCosts();
            _NewCosts = new ActualRevisedCosts();
        }
        #endregion Constructors

        #region Internal Methods
        internal void SaveSplitted(YearMonth startYearMonth, YearMonth endYearMonth)
        {
            int monthsNo = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;

            decimal[] TEList = Rounding.Divide(this._NewCosts.TE, monthsNo);
            decimal[] ProtoPartsList = Rounding.Divide(this._NewCosts.ProtoParts, monthsNo);
            decimal[] ProtoToolingList = Rounding.Divide(this._NewCosts.ProtoTooling, monthsNo);
            decimal[] TrialsList = Rounding.Divide(this._NewCosts.Trials, monthsNo);
            decimal[] OtherExpensesList = Rounding.Divide(this._NewCosts.OtherExpenses, monthsNo);

            for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
            {
                int iteratorPosition = currentYearMonth.GetMonthsDiffrence(startYearMonth);
                RevisedBudgetOtherCosts currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
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
        }

        internal void SaveSplitted(YearMonth startYearMonth, YearMonth endYearMonth, bool isAssociateCurrency, int idCostCenter, int associateCurrency, CurrencyConverter converter)
        {
            int monthsNo = endYearMonth.GetMonthsDiffrence(startYearMonth) + 1;

            decimal[] TEList = Rounding.Divide(this._NewCosts.TE, monthsNo);
            decimal[] ProtoPartsList = Rounding.Divide(this._NewCosts.ProtoParts, monthsNo);
            decimal[] ProtoToolingList = Rounding.Divide(this._NewCosts.ProtoTooling, monthsNo);
            decimal[] TrialsList = Rounding.Divide(this._NewCosts.Trials, monthsNo);
            decimal[] OtherExpensesList = Rounding.Divide(this._NewCosts.OtherExpenses, monthsNo);

            for (YearMonth currentYearMonth = new YearMonth(startYearMonth.Value); currentYearMonth.Value <= endYearMonth.Value; currentYearMonth.AddMonths(1))
            {
                int iteratorPosition = currentYearMonth.GetMonthsDiffrence(startYearMonth);
                RevisedBudgetOtherCosts currentOtherCost = CreateInstanceWithSameFlag(currentYearMonth);
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
        }
        #endregion Internal Methods

        #region Private Methods
        private RevisedBudgetOtherCosts CreateInstanceWithSameFlag(YearMonth currentYearMonth)
        {
            //Get an instance of an object
            RevisedBudgetOtherCosts newOC = new RevisedBudgetOtherCosts(this.CurrentConnectionManager);
            //Create primary key
            newOC.IdProject = this._IdProject;
            newOC.IdPhase = this._IdPhase;
            newOC.IdWP = this._IdWP;
            newOC.IdCostCenter = this._IdCostCenter;
            newOC.IdAssociate = this._IdAssociate;
            newOC.IdAssociateViewer = this._IdAssociateViewer;
            newOC.YearMonth = currentYearMonth.Value;

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

        private void ApplyCostCenterCurrency(int idCostCenter, int associateCurrency, CurrencyConverter converter)
        {
            CostCenter currentCostCenter = new CostCenter(this.CurrentConnectionManager);
            currentCostCenter.Id = idCostCenter;
            int idCurrency = currentCostCenter.GetCostCenterCurrency().Id;

            _CostVal = converter.GetConversionValue(_CostVal, associateCurrency, new YearMonth(YearMonth), idCurrency);
        }
        #endregion Private Methods
    }

    /// <summary>
    /// Actual costs
    /// </summary>
    public class ActualRevisedCosts
    {
        public decimal TE;
        public decimal ProtoParts;
        public decimal ProtoTooling;
        public decimal Trials;
        public decimal OtherExpenses;
    }
}
