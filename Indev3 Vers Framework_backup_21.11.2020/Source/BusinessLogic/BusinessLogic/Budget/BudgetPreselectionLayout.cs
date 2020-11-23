using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    /// <summary>
    /// Holds information about the information selected in the target preselection screen
    /// </summary>
    public class BudgetPreselectionLayout
    {
        #region Members
        private bool _AllExpandedInitial;
        /// <summary>
        /// If true, the master detail view in the initial budget screen will be expanded, else it will be collapsed
        /// </summary>
        public bool AllExpandedInitial
        {
            get { return _AllExpandedInitial; }
            set { _AllExpandedInitial = value; }
        }

        private bool _AllExpandedRevised;
        /// <summary>
        /// If true, the master detail view in the revised budget screen will be expanded, else it will be collapsed
        /// </summary>
        public bool AllExpandedRevised
        {
            get { return _AllExpandedRevised; }
            set { _AllExpandedRevised = value; }
        }

        private bool _AllExpandedReforecast;
        /// <summary>
        /// If true, the master detail view in the reforecast budget screen will be expanded, else it will be collapsed
        /// </summary>
        public bool AllExpandedReforecast
        {
            get { return _AllExpandedReforecast; }
            set { _AllExpandedReforecast = value; }
        }

        private bool _IsViewAllFromFollowUp = false;
        public bool IsViewAllFromFollowUp
        {
            get { return _IsViewAllFromFollowUp; }
            set { _IsViewAllFromFollowUp = value; }
        }

        #endregion Members

        #region Constructors
        /// <summary>
        /// Set the defaults to each budget expanded state
        /// </summary>
        public BudgetPreselectionLayout()
        {
            _AllExpandedInitial = true;
            _AllExpandedRevised = true;
            _AllExpandedReforecast = false;
            _IsViewAllFromFollowUp = false;
        }
        #endregion Constructors
    }
}
