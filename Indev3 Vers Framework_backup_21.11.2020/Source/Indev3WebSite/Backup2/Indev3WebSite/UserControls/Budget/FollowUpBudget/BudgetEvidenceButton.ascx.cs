using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using Inergy.Indev3.BusinessLogic.Budget;

using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.WebFramework.GenericControls;

using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.UI
{
    public partial class UserControls_Budget_FollowUpBudget_BudgetEvidenceButton : GenericUserControl
    {
        #region Members
        
        
        private bool _approvedVisible = false;
        //property that change the Approve button visibility
        public bool ApprovedVisible
        {
            get { return _approvedVisible; }
            set { _approvedVisible = value; }
        }

        private bool _rejectVisible = false;
        //property that change the Reject button visibility;
        public bool RejectVisible
        {
            get { return _rejectVisible; }
            set { _rejectVisible = value; }
        }

        private bool _submitVisible = false;
        public bool SubmitVisible
        {
            get { return _submitVisible; }
            set 
            {
                _submitVisible = value;
                this.btnSubmit.Visible = value;
            }
        }

        public bool SumbitEnabled
        {
            get
            {
                return btnSubmit.Enabled;
            }
            set
            {
                btnSubmit.Enabled = value;
                if (value == true)
                {
                    btnSubmit.ImageUrl = ResolveUrl("~/Images/button_tab_submit.png");
                    btnSubmit.ImageUrlOver = ResolveUrl("~/Images/button_tab_submit.png");
                }
                else
                {
                    btnSubmit.ImageUrl = ResolveUrl("~/Images/button_tab_submit_disabled.png");
                    btnSubmit.ImageUrlOver = ResolveUrl("~/Images/button_tab_submit_disabled.png");
                }
            }
        }

        private string _budgetState = string.Empty;
        public string BudgetState
        {
            get { return _budgetState; }
            set { _budgetState = value; }
        }

        private int _idAssociate = ApplicationConstants.INT_NULL_VALUE;
        public int IdAssociate
        {
            get { return _idAssociate; }
            set { _idAssociate = value; }
        }

        private int _idProject;
        public int IdProject
        {
            get { return _idProject; }
            set { _idProject = value; }
        }

        private int _budgetType = 0;
        public int BudgetType
        {
            get { return _budgetType; }
            set { _budgetType = value; }
        }

        private string _budgetVersion = string.Empty;
        public string BudgetVersion
        {
            get { return _budgetVersion; }
            set { _budgetVersion = value; }
        }
        #endregion

        #region Event Handlers
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected override void OnPreRender(System.EventArgs e)
        {
            try
            {
                SetVisibility();

                btnSubmit.OnClientClick = "if(!confirm('" + ApplicationMessages.BUDGET_CTM_SUBMIT + "')) return false;";
                btnReject.OnClientClick = "if(!confirm('" + ApplicationMessages.BUDGET_PM_REJECT + "')) return false;";
                btnApprove.OnClientClick = "if(!confirm('" + ApplicationMessages.BUDGET_PM_APPROVE + "')) return false;";

                base.OnPreRender(e);
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            try
            {
                string budgetNextState = BudgetStates.GetBudgetNextState(BudgetState);
                switch (BudgetType)
                {
                    case 0:
                        ApproveInitialBudget(budgetNextState);
                        break;
                    case 1:
                        ApproveRevisedBudget(budgetNextState);
                        break;
                    case 2:
                        ApproveCompletionBudget(budgetNextState);
                        break;
                    default:
                        throw new IndException("Unknown budget type: " + BudgetType.ToString());
                }
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }

            //navigate back to followup - Do not put this in try!!!!
            ParentPage.ResponseRedirect("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?BudgetType=" + BudgetType + "&BudgetVersion=" + BudgetVersion);
        }


        protected void btnReject_Click(object sender, EventArgs e)
        {
            try
            {
                switch (BudgetType)
                {
                    case 0:
                        RejectInitialBudget();
                        break;
                    case 1:
                        RejectRevisedBudget();
                        break;
                    case 2:
                        RejectCompletionBudget();
                        break;
                    default:
                        throw new IndException("Unknown budget type: " + BudgetType.ToString());
                }
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }

            //navigate back to followup
            ParentPage.ResponseRedirect("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?BudgetType=" + BudgetType + "&BudgetVersion=" + BudgetVersion);
        }

        

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string budgetNextState = BudgetStates.GetBudgetNextState(BudgetState);
                switch (BudgetType)
                {
                    case 0:
                        SubmitInitialBudget(budgetNextState);
                        break;
                    case 1:
                        SubmitRevisedBudget(budgetNextState);
                        break;
                    case 2:
                        SubmitCompletionBudget(budgetNextState);
                        break;
                    default:
                        throw new IndException("Unknown budget type: " + BudgetType.ToString());
                }
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
        }
        #endregion Event Handlers

        #region Private Methods

        /// <summary>
        /// method that set visibility for the 3 buttons
        /// </summary>
        private void SetVisibility()
        {
            btnApprove.Visible = ApprovedVisible;
            btnReject.Visible = RejectVisible;
            btnSubmit.Visible = SubmitVisible;
        }

        /// <summary>
        /// method for PM to approve budget
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
       

        private void ApproveInitialBudget(string budgetNextState)
        {
            FollowUpInitialBudget followUpInitBud = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpInitBud.IdProject = IdProject;
            followUpInitBud.IdAssociate = IdAssociate;
            followUpInitBud.StateCode = budgetNextState;
            followUpInitBud.SetModified();
            int ret = followUpInitBud.Save();
            SubmitVisible = false;
            ApprovedVisible = false;
            RejectVisible = true;            
        }
        /// <summary>
        /// method for PM to approve revised button
        /// </summary>
        /// <param name="budgetNextState"></param>
        private void ApproveRevisedBudget(string budgetNextState)
        {
            FollowUpRevisedBudget followUpRevBud = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpRevBud.IdProject = IdProject;
            followUpRevBud.BudVersion = BudgetVersion;
            followUpRevBud.IdAssociate = IdAssociate;
            followUpRevBud.StateCode = budgetNextState;

            followUpRevBud.SetModified();
            int ret = followUpRevBud.Save();

            SubmitVisible = false;
            ApprovedVisible = false;
            RejectVisible = true;           
        }

        private void ApproveCompletionBudget(string budgetNextState)
        {
            FollowUpCompletionBudget followUpCompBud = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpCompBud.IdProject = IdProject;
            followUpCompBud.BudVersion = BudgetVersion;
            followUpCompBud.IdAssociate = IdAssociate;
            followUpCompBud.StateCode = budgetNextState;

            followUpCompBud.SetModified();
            int ret = followUpCompBud.Save();

            SubmitVisible = false;
            ApprovedVisible = false;
            RejectVisible = true;

        }
       
        /// <summary>
        /// method for PM to Reject Initial Budget
        /// </summary>
        private void RejectInitialBudget()
        {
            FollowUpInitialBudget followUpInitBud = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpInitBud.IdProject = IdProject;
            followUpInitBud.IdAssociate = IdAssociate;
            followUpInitBud.StateCode = ApplicationConstants.BUDGET_STATE_OPEN;
            followUpInitBud.SetModified();
            int ret = followUpInitBud.Save();
            SubmitVisible = false;
            ApprovedVisible = false;
            RejectVisible = false;            
        }
        /// <summary>
        /// Method for PM to reject revised button
        /// </summary>
        private void RejectRevisedBudget()
        {
            FollowUpRevisedBudget followUpRevBud = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpRevBud.IdProject = IdProject;
            followUpRevBud.BudVersion = BudgetVersion;
            followUpRevBud.IdAssociate = IdAssociate;
            followUpRevBud.StateCode = ApplicationConstants.BUDGET_STATE_OPEN;

            followUpRevBud.SetModified();
            int ret = followUpRevBud.Save();
            SubmitVisible = false;
            ApprovedVisible = false;
            RejectVisible = false;                      
        }
        /// <summary>
        /// Method for PM to reject completion budget
        /// </summary>
        private void RejectCompletionBudget()
        {
            FollowUpCompletionBudget followUpCompBud = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpCompBud.IdProject = IdProject;
            followUpCompBud.BudVersion = BudgetVersion;
            followUpCompBud.IdAssociate = IdAssociate;
            followUpCompBud.StateCode = ApplicationConstants.BUDGET_STATE_OPEN;

            followUpCompBud.SetModified();
            int ret = followUpCompBud.Save();
            SubmitVisible = false;
            ApprovedVisible = false;
            RejectVisible = false;  
        }
        /// <summary>
        /// method for CTM to submit initial budget
        /// </summary>
        /// <param name="budgetNextState"></param>
        private void SubmitInitialBudget(string budgetNextState)
        {
            FollowUpInitialBudget followUpInitBud = new FollowUpInitialBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpInitBud.IdProject = IdProject;
            followUpInitBud.IdAssociate = IdAssociate;
            followUpInitBud.StateCode = budgetNextState;
            followUpInitBud.SetModified();
            int ret = followUpInitBud.Save();
            SubmitVisible = false;
            btnSubmit.Visible = false;
        }
        /// <summary>
        /// method for CTM to submit revised budget
        /// </summary>
        /// <param name="budgetNextState"></param>
        private void SubmitRevisedBudget(string budgetNextState)
        {
            FollowUpRevisedBudget followUpRevBud = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpRevBud.IdProject = IdProject;
            followUpRevBud.BudVersion = BudgetVersion;
            followUpRevBud.IdAssociate = IdAssociate;
            followUpRevBud.StateCode = budgetNextState;

            followUpRevBud.SetModified();

            int ret = followUpRevBud.Save();
            SubmitVisible = false;       
        }

        private void SubmitCompletionBudget(string budgetNextState)
        {
            FollowUpCompletionBudget followUpCompBud = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
            followUpCompBud.IdProject = IdProject;
            followUpCompBud.BudVersion = BudgetVersion;
            followUpCompBud.IdAssociate = IdAssociate;
            followUpCompBud.StateCode = budgetNextState;

            followUpCompBud.SetModified();

            int ret = followUpCompBud.Save();
            SubmitVisible = false;
        }
     
        #endregion Private Methods

    }
}

