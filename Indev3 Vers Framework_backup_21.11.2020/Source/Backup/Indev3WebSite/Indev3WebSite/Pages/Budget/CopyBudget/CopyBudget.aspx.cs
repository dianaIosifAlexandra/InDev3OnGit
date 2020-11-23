﻿using System;
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
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using System.Collections.Generic;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.UI
{
	public partial class Pages_Budget_CopyBudget_CopyBudget : IndBasePage
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
				lblCopyBudgetStatus.Text = String.Empty;
				grdCopyBudget.Visible = true;
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
				foreach (GridColumn column in grdCopyBudget.MasterTableView.Columns)
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

		protected void grdCopyBudget_ItemCreated(object sender, GridItemEventArgs e)
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
		protected void btnCopyBudget_Click(object sender, EventArgs e)
		{
			try
			{
				string BudgetCode = GetBudgetCode();
				
				switch (BudgetCode)
				{
					case ApplicationConstants.MODULE_REVISED:
						CopyBudgetRows_Revised();
						break;
					case ApplicationConstants.MODULE_REFORECAST:
						CopyBudgetRows_ToCompletion();
						break;
				}
				lblCopyBudgetStatus.Text = "Budget successfully moved";
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
			this.grdCopyBudget.Visible = false;
			lblProject.Visible = false;
			lblProjectName.Visible = false;
			lblCopyBudgetStatus.Visible = false;
			btnCopyBudget.Visible = false;
		}
		
		#endregion

		#region Private Methods
		/// <summary>
		/// Applies the columns css class
		/// </summary>
		/// <param name="column">the column to which the css class is applied</param>
		private void ApplyColumnCSSClass(GridColumn column)
		{
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
			int index = grdCopyBudget.Columns.IndexOf(currentColumn);
			int visibleIndex = 0;
			foreach (GridColumn column in grdCopyBudget.Columns)
			{
				if (column is GridColumn && column.Display)
				{
					if (grdCopyBudget.Columns.IndexOf(column) < index)
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
						dr.Delete();
					}
				}
				ds.AcceptChanges();
				
				if (ds.Tables[0].Rows.Count > 0)
				{
					grdCopyBudget.DataSource = ds.Tables[0];
					grdCopyBudget.DataBind();
				}
				else
				{
					grdCopyBudget.Visible = false;
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

		private void CopyBudgetRows_Revised()
		{
			GridTableView grdTableVw = grdCopyBudget.MasterTableView;
			GridDataItemCollection itemCollection = grdTableVw.Items;
			foreach (GridItem gridItem in itemCollection)
			{
				if (!(gridItem is GridEditableItem))
					continue;
				GridEditableItem item = gridItem as GridEditableItem;

				CheckBox chkSelected = item["SelectAssociateCol"].FindControl("chkSelectAssociate") as CheckBox;
				if (chkSelected == null)
					continue;
				if (!chkSelected.Checked)
					continue;
				int idAssociateNM = ApplicationConstants.INT_NULL_VALUE;
				int.TryParse(item["IdAssociate"].Text, out idAssociateNM);

				FollowUpRevisedBudget followUpRevisedBudget = new FollowUpRevisedBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
				followUpRevisedBudget.CopyRevisedBudget(currentProject.Id, GetIdAssociateLM(), idAssociateNM);
			}
		}

		private void CopyBudgetRows_ToCompletion()
		{
			GridTableView grdTableVw = grdCopyBudget.MasterTableView;
			GridDataItemCollection itemCollection = grdTableVw.Items;
			foreach (GridItem gridItem in itemCollection)
			{
				if (!(gridItem is GridEditableItem))
					continue;
				GridEditableItem item = gridItem as GridEditableItem;

				CheckBox chkSelected = item["SelectAssociateCol"].FindControl("chkSelectAssociate") as CheckBox;
				if (chkSelected == null)
					continue;
				if (!chkSelected.Checked)
					continue;
				int idAssociateNM = ApplicationConstants.INT_NULL_VALUE;
				int.TryParse(item["IdAssociate"].Text, out idAssociateNM);

				FollowUpCompletionBudget followUpCompletionBudget = new FollowUpCompletionBudget(SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.CONNECTION_MANAGER));
				followUpCompletionBudget.CopyCompletionBudget(currentProject.Id, GetIdAssociateLM(), idAssociateNM);
			}
		}
		
		#endregion		
	}
}