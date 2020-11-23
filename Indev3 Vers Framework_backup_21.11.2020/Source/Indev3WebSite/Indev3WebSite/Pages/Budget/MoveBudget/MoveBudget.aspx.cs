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
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using System.Collections.Generic;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.UI
{
    public partial class Pages_Budget_MoveBudget_MoveBudget : IndBasePage
	{
		#region Members
		#endregion

		#region Properties
		//holds the Current Project
		private CurrentProject currentProject
		{
			get
			{
				return SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
			}
		}
		#endregion

		#region Event Handlers
		protected void Page_Load(object sender, EventArgs e)
		{
			try
			{
				lblMoveBudgetStatus.Text = String.Empty;
				grdMoveBudget.Visible = true;

                if (Inergy.Indev3.WebFramework.Utils.HelperFunctions.GetInternetExplorerVersion() > 8.0)
                {
                    grdMoveBudget.Columns[1].Visible = false;
                    grdMoveBudget.Columns[3].Visible = false;
                }

				AddAjaxSettings();

				if (!Page.IsPostBack)
				{
					//set the project name
					lblProjectName.Text = currentProject.Name;

					LoadGrid();
					SetBackButtonProperties();
				}
			}
			catch (IndException ex)
			{
				ShowError(ex);
				return;
			}
			catch (Exception ex)
			{
				ShowError(new IndException(ex));
				return;
			}
		}

		protected override void OnPreRender(EventArgs e)
		{
			try
			{
				foreach (GridColumn column in grdMoveBudget.MasterTableView.Columns)
				{
					ApplyColumnCSSClass(column);
				}
			}
			catch (IndException ex)
			{
				ShowError(ex);
				return;
			}
			catch (Exception ex)
			{
				ShowError(new IndException(ex));
				return;
			}
		}

		protected void grdMoveBudget_ItemCreated(object sender, GridItemEventArgs e)
		{
			try
			{

			}
			catch (IndException ex)
			{
				ShowError(ex);
				return;
			}
			catch (Exception ex)
			{
				ShowError(new IndException(ex));
				return;
			}
		}

		/// <summary>
		/// Event handler for the Click event of btnSave
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnMoveBudget_Click(object sender, EventArgs e)
		{
			try
			{
                int idAssociateNM = ApplicationConstants.INT_NULL_VALUE;
				string BudgetCode = GetBudgetCode();
				
				switch (BudgetCode)
				{
					case ApplicationConstants.MODULE_REVISED:
						MoveBudgetRows_Revised();
						break;
					case ApplicationConstants.MODULE_REFORECAST:
						MoveBudgetRows_ToCompletion();
						break;
                    default:
                        throw new NotImplementedException(ApplicationMessages.EXCEPTION_NOT_IMPLEMENTED);
				}

                GridTableView grdTableVw = grdMoveBudget.MasterTableView;
                GridDataItemCollection itemCollection = grdTableVw.Items;

                string associateNameTo = null;

                foreach (GridDataItem gridItem in itemCollection)
                {
                    associateNameTo = gridItem["Associate"].Text;
                    idAssociateNM = GetIdAssociateNM(gridItem);
                    if (idAssociateNM == ApplicationConstants.INT_NULL_VALUE)
                        continue;
                    else
                        break;
                }

                lblMoveBudgetStatus.Text = "Budget successfully moved from " + hdnAssociateName.Value + " to " + associateNameTo;
			}
			catch (IndException indExc)
			{
				HideChildControls();
				ShowError(indExc);
				return;
			}
			catch (Exception exc)
			{
				HideChildControls();
				ShowError(new IndException(exc));
				return;
			}
		}

		/// <summary>
		/// Hides the controls from the screen
		/// </summary>
		protected override void HideChildControls()
		{
			this.grdMoveBudget.Visible = false;
			lblProject.Visible = false;
			lblProjectName.Visible = false;
			lblMoveBudgetStatus.Visible = false;
			btnMoveBudget.Visible = false;
		}
		
		#endregion

		#region Private Methods
		/// <summary>
		/// Applies the columns css class
		/// </summary>
		/// <param name="column">the column to which the css class is applied</param>
		private void ApplyColumnCSSClass(GridColumn column)
		{
            if (column.Display == false) 
            {
              //fix for IE8 - TODO: uncomment this when IE7 is dropped completely :)

              //column.HeaderStyle.CssClass = "GridElements_IndGenericGrid_Hide";
              //column.ItemStyle.CssClass = "GridElements_IndGenericGrid_Hide";
              // column.FooterStyle.CssClass = "GridElements_IndGenericGrid_Hide";
            }
            else
			    if (GetColumnIndex(column) % 2 == 1)
			    {
				    column.ItemStyle.CssClass = "IndEvenColumn";
			    }
			    else
			    {
				    column.ItemStyle.CssClass = "IndOddColumn";
			    }
		}

		/// <summary>
		/// Gets the index of the current column (taking into account only the visible columns, not the hidden ones)
		/// </summary>
		/// <param name="currentColumn">the column whose index is calculated</param>
		/// <returns>the index of the current column (taking into account only the visible columns, not the hidden ones)</returns>
		private int GetColumnIndex(GridColumn currentColumn)
		{
            int index = grdMoveBudget.Columns.IndexOf(currentColumn);
			int visibleIndex = 0;
            foreach (GridColumn column in grdMoveBudget.Columns)
			{
				if (column is GridColumn && column.Display)
				{
                    if (grdMoveBudget.Columns.IndexOf(column) < index)
					{
						visibleIndex++;
					}
				}
			}
			return visibleIndex;
		}
		
		private void AddAjaxSettings()
		{
			//get the ajax manager from the page
			RadAjaxManager ajaxManager = GetAjaxManager();
			ajaxManager.EnableAJAX = false;
		}

		private void LoadGrid()
		{
			DataSet ds = null;
			int IdAssociateLM = GetIdAssociateLM();
			
			ProjectCoreTeamMember teamMember = new ProjectCoreTeamMember(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
			teamMember.IdProject = currentProject.Id;
			teamMember.IdAssociate = ApplicationConstants.INT_NULL_VALUE;
			ds = teamMember.GetAll(true);
			
			if (ds != null)
			{
				//remove inactive associates and also the member that leaves the project
				foreach (DataRow dr in ds.Tables[0].Rows)
				{
					if (!(bool)dr["OldIsActive"] || (int)dr["IdAssociate"] == IdAssociateLM)
					{
                        if ((int)dr["IdAssociate"] == IdAssociateLM)
                        {
                            hdnAssociateName.Value = dr["CoreTeamMemberName"].ToString();
                        }
						dr.Delete();
					}
				}
				ds.AcceptChanges();
				
				if (ds.Tables[0].Rows.Count > 0)
				{
                    lblMoveBudgetStatus.Text = "Please select a user to move " + hdnAssociateName.Value + "'s budget to.";
                    grdMoveBudget.DataSource = ds.Tables[0];
                    grdMoveBudget.DataBind();
				}
				else
				{
                    grdMoveBudget.Visible = false;
				}
			}
		}
		
		private void SetBackButtonProperties()
		{
			int IdAssociateLM = GetIdAssociateLM();
			int BudgetType = GetBudgetType();
			string BudgetVersion = GetBudgetVersion();
			string BudgetCode = GetBudgetCode();
			
			btnBackToFollowUp.OnClientClick = "try { window.location = '" + ResolveUrl("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + BudgetCode + "&IdAssociate=" + IdAssociateLM.ToString() + "&BudgetType=" + BudgetType + "&BudgetVersion=" + BudgetVersion) + "'; } catch(e) {} return false;";
			((Template)this.Master).SetBackButtonNavigateUrl(ResolveUrl("~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?Code=" + BudgetCode + "&IdAssociate=" + IdAssociateLM.ToString() + "&BudgetType=" + BudgetType + "&BudgetVersion=" + BudgetVersion));
			btnBackToFollowUp.ToolTip = "Follow-up Screen";

		}

		/// <summary>
		/// Gets the budget code from the query string
		/// </summary>
		/// <returns></returns>
		private string GetBudgetCode()
		{
			if (String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["Code"]))
			{
				this.ShowError(new IndException("Budget Code is missing"));
				return null;
			}
			string budgetCode = HttpContext.Current.Request.QueryString["Code"];
			if (budgetCode != ApplicationConstants.MODULE_REVISED
				&& budgetCode != ApplicationConstants.MODULE_REFORECAST)
			{
				throw new IndException("Unrecognized budget code");
			}
			return budgetCode;
		}

		/// <summary>
		/// Gets the budget type from the query string
		/// </summary>
		/// <returns></returns>
		private int GetBudgetType()
		{
			int budgetType = ApplicationConstants.INT_NULL_VALUE;
			if (int.TryParse(HttpContext.Current.Request.QueryString["BudgetType"], out budgetType) == false)
			{
				throw new IndException("The budget type value in the QueryString is not numeric.");
			}
			return budgetType;
		}		

		/// <summary>
		/// Gets the budget version from the query string
		/// </summary>
		/// <returns></returns>
		private string GetBudgetVersion()
		{
			if (String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["BudgetVersion"]))
			{
				throw new IndException("Budget Version is missing");
			}
			string budgetVersion = HttpContext.Current.Request.QueryString["BudgetVersion"];
			if (budgetVersion != ApplicationConstants.BUDGET_VERSION_PREVIOUS_CODE
				&& budgetVersion != ApplicationConstants.BUDGET_VERSION_RELEASED_CODE
				&& budgetVersion != ApplicationConstants.BUDGET_VERSION_IN_PROGRESS_CODE)
			{
				throw new IndException("Unrecognized budget version");
			}
			return budgetVersion;
		}

		/// <summary>
		/// Gets the IdAssociate from the query string
		/// </summary>
		/// <returns></returns>
		private int GetIdAssociateLM()
		{
			int idAssociate = ApplicationConstants.INT_NULL_VALUE;
			if (int.TryParse(HttpContext.Current.Request.QueryString["IdAssociate"], out idAssociate) == false)
			{
				throw new IndException("The IdAssociate value in the QueryString is not numeric.");
			}

			return idAssociate;
		}

        private void MoveBudgetRows_Revised()
		{
            int moveReleased = 0;

            RevisedBudget revisedBudget = new RevisedBudget(SessionManager.GetConnectionManager(this));
            revisedBudget.IdProject = currentProject.Id;
            object lastRevisedValidatedVersion = revisedBudget.GetLastValidatedVersion();

            if (lastRevisedValidatedVersion != null && int.Parse(lastRevisedValidatedVersion.ToString()) > 0)
            {
                moveReleased = 1;
            }

            GridTableView grdTableVw = grdMoveBudget.MasterTableView;
			GridDataItemCollection itemCollection = grdTableVw.Items;
			foreach (GridItem gridItem in itemCollection)
			{
                int idAssociateNM = GetIdAssociateNM(gridItem);

                if (idAssociateNM != ApplicationConstants.INT_NULL_VALUE)
                {
                    FollowUpRevisedBudget followUpRevisedBudget = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
                    if (moveReleased == 0)
                    {
                        followUpRevisedBudget.MoveRevisedBudget(currentProject.Id, GetIdAssociateLM(), idAssociateNM, SessionManager.GetCurrentUser(this).IdAssociate);
                    }
                    else
                    {
                        followUpRevisedBudget.MoveRevisedBudgetReleasedVersion(currentProject.Id, GetIdAssociateLM(), idAssociateNM, SessionManager.GetCurrentUser(this).IdAssociate);
                    }
                    btnMoveBudget.Visible = false;
                }
			}
		}

        private void MoveBudgetRows_ToCompletion()
		{
            int moveReleased = 0;

            GridTableView grdTableVw = grdMoveBudget.MasterTableView;
			GridDataItemCollection itemCollection = grdTableVw.Items;

            ReforecastBudget reforecastBudget = new ReforecastBudget(SessionManager.GetConnectionManager(this));
            reforecastBudget.IdProject = currentProject.Id;
            object lastRevisedValidatedVersion = reforecastBudget.GetLastValidatedVersion();

            if (lastRevisedValidatedVersion != null && int.Parse(lastRevisedValidatedVersion.ToString()) > 0)
            {
                moveReleased = 1;
            }

			foreach (GridItem gridItem in itemCollection)
			{
				int idAssociateNM = GetIdAssociateNM(gridItem);

                if (idAssociateNM == ApplicationConstants.INT_NULL_VALUE)
                    continue;
                else
                {
                    FollowUpCompletionBudget followUpCompletionBudget = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
                    if (moveReleased == 0)
                    {
                        followUpCompletionBudget.MoveCompletionBudget(currentProject.Id, GetIdAssociateLM(), idAssociateNM, SessionManager.GetCurrentUser(this).IdAssociate);
                    }
                    else
                    {
                        followUpCompletionBudget.MoveCompletionBudgetReleasedVersion(currentProject.Id, GetIdAssociateLM(), idAssociateNM, SessionManager.GetCurrentUser(this).IdAssociate);
                    }
                    btnMoveBudget.Visible = false;
                }
			}
		}

        private int GetIdAssociateNM(GridItem gridItem)
        {
            int idAssociateNM = ApplicationConstants.INT_NULL_VALUE;

            if (!(gridItem is GridEditableItem))
                return ApplicationConstants.INT_NULL_VALUE;
            GridEditableItem item = gridItem as GridEditableItem;

            CheckBox chkSelected = item["SelectAssociateCol"].FindControl("chkSelectAssociate") as CheckBox;
            if (chkSelected == null)
                return ApplicationConstants.INT_NULL_VALUE;
            if (!chkSelected.Checked)
                return ApplicationConstants.INT_NULL_VALUE;

            int.TryParse(item["IdAssociate"].Text, out idAssociateNM);

            return idAssociateNM;
        }
		
		#endregion		
	}
}