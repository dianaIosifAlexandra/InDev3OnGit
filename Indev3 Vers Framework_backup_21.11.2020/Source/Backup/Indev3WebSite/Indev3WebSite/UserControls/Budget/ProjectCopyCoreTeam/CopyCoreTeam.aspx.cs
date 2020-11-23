using System;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Budget;
using Telerik.WebControls;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework;

public partial class UserControls_Budget_ProjectCopyCoreTeam_CopyCoreTeam : IndPopUpBasePage
{
	#region Properties
	/// <summary>
	/// The connection manger that will be used
	/// </summary>
	private object CurrentConnectionManager = null;

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
			if (!Page.IsPostBack)
			{
				LoadGrid();
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

	protected override void OnInit(EventArgs e)
	{
		try
		{
			base.OnInit(e);
			CurrentConnectionManager = SessionManager.GetConnectionManager(this);
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
			foreach (GridColumn column in grdCopyCoreTeam.MasterTableView.Columns)
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

	protected void btnCopyCoreTeam_Click(object sender, EventArgs e)
	{
		try
		{
			GridTableView grdTableVw = grdCopyCoreTeam.MasterTableView;
			GridDataItemCollection itemCollection = grdTableVw.Items;
			foreach (GridItem gridItem in itemCollection)
			{
				if (!(gridItem is GridEditableItem))
					continue;
				GridEditableItem item = gridItem as GridEditableItem;

				CheckBox chkSelected = item["SelectProjectCol"].FindControl("chkSelectProject") as CheckBox;
				if (chkSelected == null)
					continue;
				if (!chkSelected.Checked)
					continue;
				int idTargetProject = ApplicationConstants.INT_NULL_VALUE;
				int.TryParse(item["IdProject"].Text, out idTargetProject);

				ProjectCopyCoreTeam copyCoreTeam = new ProjectCopyCoreTeam(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
				copyCoreTeam.IdProject = currentProject.Id;
				copyCoreTeam.IdTargetProject = idTargetProject;
				int result = copyCoreTeam.CopyProjectCoreTeam();
			}
			
			LoadGrid();
			lblStatus.Text = "Core team successfully copied";
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
		int index = grdCopyCoreTeam.Columns.IndexOf(currentColumn);
		int visibleIndex = 0;
		foreach (GridColumn column in grdCopyCoreTeam.Columns)
		{
			if (column is GridColumn && column.Display)
			{
				if (grdCopyCoreTeam.Columns.IndexOf(column) < index)
				{
					visibleIndex++;
				}
			}
		}
		return visibleIndex;
	}

	private void LoadGrid()
	{
		DataSet ds = null;

		ProjectCopyCoreTeam copyCoreTeam = new ProjectCopyCoreTeam(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
		copyCoreTeam.IdProject = currentProject.Id;
		copyCoreTeam.IdAssociate = currentProject.IdAssociate;
		ds = copyCoreTeam.GetTargetProjects();
		
		if (ds != null)
		{
			if (ds.Tables[0].Rows.Count > 0)
			{
				grdCopyCoreTeam.DataSource = ds.Tables[0];
				grdCopyCoreTeam.DataBind();
			}
			else
			{
				lblStatus.Text = "No target projects for current user!";
				btnCopyCoreTeam.Enabled = false;
			}
		}
	}
	#endregion
}
