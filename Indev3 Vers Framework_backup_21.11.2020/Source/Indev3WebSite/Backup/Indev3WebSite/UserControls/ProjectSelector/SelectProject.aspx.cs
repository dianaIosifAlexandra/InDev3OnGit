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
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.ApplicationFramework.Common;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


public partial class UserControls_ProjectSelector_SelectProject : IndPopUpBasePage
{
    private CurrentUser CurrentUser;
    PageStatePersister _pers;

    protected override PageStatePersister PageStatePersister
    {
        get
        {
            if (_pers == null)
            {
                _pers = new SessionPageStatePersister(this);
            }
            return _pers;
        }
    }
    #region Event Handlers
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {           
            LoadCurrentUser();
            if (CurrentUser != null)
            {
                //check user role to see if ShowOnly Combobox will be visible
                if (CurrentUser.UserRole.Id == ApplicationConstants.ROLE_FINANCIAL_TEAM)
                {
                    lblShowOnly.Visible = false;
                    cmbShowOnly.Visible = false;
                }

                if (!Page.IsPostBack)
                {
                    CurrentProject currentProject = (CurrentProject)SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CURRENT_PROJECT);

                    //check to see if we have something already selected
                    if (currentProject != null)
                    {
                        //fill in the hard coded values to display
                        FillShowOnlyValues();

                        LoadOwnersFiltered(currentProject.IdOwner);
                        cmbOW.SelectedValue = currentProject.IdOwner.ToString();

                        LoadProgramsFiltered(currentProject.IdOwner);
                        cmbPG.SelectedValue = currentProject.IdProgram.ToString();

                        LoadProjectsFiltered(currentProject.IdProgram);
                        cmbPJ.SelectedValue = currentProject.Id.ToString();

                        UpdateFunctionLabel();
                        UpdateActiveMembersLabel();
                        UpdateTimingIntercoPercentLabel();
                        UpdateInitialBudgetValidatedLabel();
                    }
                    else
                        PopulateComboBoxes();
                }                
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

    

    /// <summary>
    /// Event that is fired when the Owners Combo Box index changes
    /// </summary>
    /// <param name="o"></param>
    /// <param name="e"></param>
    protected void cmbOW_SelectedIndexChanged(object o, Telerik.WebControls.RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            //we read the initial owner selected
            String currentOwner = cmbOW.SelectedValue;

            //re-load the programs
            LoadOwners();

            //if one owner is selected then the selection is restored
            if (currentOwner != ApplicationConstants.INT_NULL_VALUE.ToString() &&
                currentOwner != String.Empty)
            {
                cmbOW.SelectedValue = currentOwner;
            }

            //re-load the programs
            LoadPrograms();

            //re-load the projects
            LoadProjects();



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
    /// Event that is fired when the user clicks the Select Button
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSelect_Click(object sender, EventArgs e)
    {
        try
        {
            if (cmbPJ.IsEmptyValueSelected())
                throw new IndException(ApplicationMessages.EXCEPTION_SELECT_PROJECT);

            //Create the project and Fill In The Owner Id        
            DataRow row = cmbPJ.GetComboSelection();
            CurrentProject prj = new CurrentProject(row, SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

            SetProjectAdditionalInfo(prj);

            SessionManager.SetSessionValue(this, SessionStrings.CURRENT_PROJECT, prj);

            //Close the window
            if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonClickScript"))
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonClickScript", "window.returnValue = 1; window.close();", true);
            }

            //Since the pop-up will close anyway, we do not need to transport to the client all the page viewstate since it will not be used anyway
            //In addition, the items of the comboboxes do not need to be rendered on the client.
            this.EnableViewState = false;

            cmbOW.Items.Clear();
            cmbPG.Items.Clear();
            cmbPJ.Items.Clear();
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
    /// Event that is fired when the Programs Combo Box index changes
    /// </summary>
    /// <param name="o"></param>
    /// <param name="e"></param>
    protected void cmbPG_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            //select the owner of the selected program
            ProjectSelectorFilter projectSelectorFilter = null;
            if (!cmbPG.IsEmptyValueSelected())
            {
                DataRow row = cmbPG.GetComboSelection();
                projectSelectorFilter = new ProjectSelectorFilter(int.Parse(cmbPG.SelectedValue), ApplicationConstants.INT_NULL_VALUE, SessionManager.GetConnectionManager(this));

                //re-load the owners
                LoadOwners();

                //re-select the active element
                cmbOW.SelectedValue = projectSelectorFilter.IdOwner.ToString();
            }
            else
            {
                cmbOW.ClearSelection();
                LoadOwners();
            }

            //re-load the programs with the owner selected so that only the program under the current owner are shown
            LoadPrograms();

            if (projectSelectorFilter != null) //if there is one value selected we need to restore selection
                cmbPG.SelectedValue = projectSelectorFilter.IdProgram.ToString();

            //Fill the project combo box with the values corresponding to the Program selected
            LoadProjects();
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
    /// Event that is fired when the Projects Combo Box index changes
    /// </summary>
    /// <param name="o"></param>
    /// <param name="e"></param>
    protected void cmbPJ_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            ProjectSelectorFilter projectSelectorFilter = null;

            if (cmbPJ.IsEmptyValueSelected())
            {
                cmbOW.ClearSelection();
                LoadOwners();
                cmbPG.ClearSelection();
                LoadPrograms();

                lblFunction.Text = String.Empty;
				lblActiveMembers.Text = String.Empty;
				lblTimingIntercoPercent.Text = String.Empty;
				lblInitialBudgetValidated.Text = String.Empty;
            }
            else
            {
                DataRow row = cmbPJ.GetComboSelection();

                //then the owner and the program
                projectSelectorFilter = new ProjectSelectorFilter(ApplicationConstants.INT_NULL_VALUE,int.Parse(cmbPJ.SelectedValue), SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

                //re-load owners
                LoadOwnersFiltered(projectSelectorFilter.IdOwner);

                //restore selection
                cmbOW.SelectedValue = projectSelectorFilter.IdOwner.ToString();


                //re-load the programs with the programs corresponding to the owner selected 
                LoadProgramsFiltered(projectSelectorFilter.IdOwner);

                //restore selection
                cmbPG.SelectedValue = projectSelectorFilter.IdProgram.ToString();
            }

            //re-load the project with the projects corresponding to the program selected
            LoadProjects();
            if (projectSelectorFilter != null) //restore selection
            {
                cmbPJ.SelectedValue = projectSelectorFilter.IdProject.ToString();

                UpdateFunctionLabel();
                UpdateActiveMembersLabel();
                UpdateTimingIntercoPercentLabel();
                UpdateInitialBudgetValidatedLabel();
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

    /// <summary>
    /// Event that is fired when the Programs Combo Box index changes
    /// </summary>
    /// <param name="o"></param>
    /// <param name="e"></param>
    protected void cmbShowOnly_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            //re-load the owners
            cmbOW.SelectEmptyValue();
            LoadOwners();

            //re-load the programs with the programs corresponding to the owner selected 
            cmbPG.SelectEmptyValue();
            LoadPrograms();

            //reload the projects - these are the only ones affected by this option
            cmbPJ.SelectEmptyValue();
            LoadProjects();
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
            base.OnPreRender(e);
            if (!ClientScript.IsOnSubmitStatementRegistered(this.GetType(), "ResizePopUp"))
            {
                ClientScript.RegisterOnSubmitStatement(this.GetType(), "ResizePopUp", "SetPopUpHeight();");
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

	protected void rbOrderProjects_SelectedIndexChanged(object sender, EventArgs e) 
    {
        try
        {
            PopulateComboBoxes();
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
    #endregion Event Handlers

    #region Private Methods
    private void LoadCurrentUser()
    {
        CurrentUser = (CurrentUser)SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER);
    }
    private void PopulateComboBoxes()
    {
        //fill in the hard coded values to display
        FillShowOnlyValues();

        //fill all the controls from the current page
        LoadOwners();
        LoadPrograms();
        LoadProjects();
    }

    /// <summary>
    /// Sets the owner and associate for a project
    /// </summary>
    /// <param name="project"></param>
    private void SetProjectAdditionalInfo(CurrentProject project)
    {
        if (!cmbOW.IsEmptyValueSelected())
        {
            DataTable tbl = ((DataSet)cmbOW.DataSource).Tables[0];
            DataRow row = tbl.Rows[cmbOW.SelectedIndex];
            project.IdOwner = (row["OwnerId"] == DBNull.Value) ? ApplicationConstants.INT_NULL_VALUE : (int)row["OwnerId"];
        }
        project.IdAssociate = CurrentUser.IdAssociate;
        project.ShowOnly = cmbShowOnly.SelectedValue;
    }


    private void LoadOwners()
    {       
        int ownerId;

        //Fill the project combo box with the values corresponding to the selected owner
        if (cmbOW.IsEmptyValueSelected())
            ownerId = ApplicationConstants.INT_NULL_VALUE;
        else
            ownerId = Int32.Parse(cmbOW.SelectedValue);

        LoadOwnersFiltered(ownerId);
    }

    private void LoadOwnersFiltered(int ownerId)
    {
        ProjectSelectorFilter projectSelectorFilter = new ProjectSelectorFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

        projectSelectorFilter.IdAssociate = CurrentUser.IdAssociate;
        projectSelectorFilter.ShowOnly = cmbShowOnly.SelectedValue;
        projectSelectorFilter.OrderBy = rbOrderProjects.SelectedValue;
        //Fill the project combo box with the values corresponding to the selected owner
        projectSelectorFilter.IdOwner = ownerId;

        DataSet ownerDS = projectSelectorFilter.SelectProcedure("SelectOwners");
        DSUtils.AddEmptyRecord(ownerDS.Tables[0]);
        cmbOW.DataSource = ownerDS;
        cmbOW.DataMember = ownerDS.Tables[0].ToString();
        cmbOW.DataValueField = "OwnerId";
        cmbOW.DataTextField = "Name";
        cmbOW.DataBind();
    }

    private void LoadPrograms()
    {
        int ownerId;

        //Fill the project combo box with the values corresponding to the OwnerId
        if (cmbOW.IsEmptyValueSelected())
            ownerId = ApplicationConstants.INT_NULL_VALUE;
        else
            ownerId = Int32.Parse(cmbOW.SelectedValue);

        LoadProgramsFiltered(ownerId);
    }

    private void LoadProgramsFiltered(int ownerId)
    {
        ProjectSelectorFilter projectSelectorFilter = new ProjectSelectorFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

        projectSelectorFilter.IdAssociate = CurrentUser.IdAssociate;
        projectSelectorFilter.ShowOnly = cmbShowOnly.SelectedValue;
		projectSelectorFilter.OrderBy = rbOrderProjects.SelectedValue;
        //Fill the project combo box with the values corresponding to the selected owner
        projectSelectorFilter.IdOwner = ownerId;

        DataSet programsDS = projectSelectorFilter.SelectProcedure("SelectPrograms");
        DSUtils.AddEmptyRecord(programsDS.Tables[0]);
        cmbPG.DataSource = programsDS;
        cmbPG.DataMember = programsDS.Tables[0].ToString();
        cmbPG.DataValueField = "ProgramId";
        cmbPG.DataTextField = "Name";
        cmbPG.DataBind();

        //reset the function
        lblFunction.Text = String.Empty;
        //reset additional labels
		lblActiveMembers.Text = String.Empty;
		lblTimingIntercoPercent.Text = String.Empty;
		lblInitialBudgetValidated.Text = String.Empty;
    }

    private void LoadProjects()
    {
        int programId;

        //Fill the project combo box with the values corresponding to the OwnerId
        if (cmbPG.IsEmptyValueSelected())
            programId = ApplicationConstants.INT_NULL_VALUE;
        else
            programId = Int32.Parse(cmbPG.SelectedValue);

        LoadProjectsFiltered(programId);
    }

    private void LoadProjectsFiltered(int programId)
    {
        ProjectSelectorFilter projectSelectorFilter = new ProjectSelectorFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));

        if (!cmbOW.IsEmptyValueSelected())
            projectSelectorFilter.IdOwner = Int32.Parse(cmbOW.SelectedValue);

        projectSelectorFilter.IdAssociate = CurrentUser.IdAssociate;
        projectSelectorFilter.ShowOnly = cmbShowOnly.SelectedValue;
		projectSelectorFilter.OrderBy = rbOrderProjects.SelectedValue;
        projectSelectorFilter.IdProgram = programId;

        DataSet projectDS = projectSelectorFilter.SelectProcedure("SelectProjects"); ;
        DSUtils.AddEmptyRecord(projectDS.Tables[0]);
        cmbPJ.DataSource = projectDS;
        cmbPJ.DataMember = projectDS.Tables[0].ToString();
        cmbPJ.DataValueField = "ProjectId";
        cmbPJ.DataTextField = "ProjectName";
        cmbPJ.DataBind();
    }

    private void FillShowOnlyValues()
    {
        cmbShowOnly.Items.Add(new RadComboBoxItem("Active", ApplicationConstants.SHOW_ONLY_ACTIVE_PROJECTS));
        cmbShowOnly.Items.Add(new RadComboBoxItem("Inactive", ApplicationConstants.SHOW_ONLY_INACTIVE_PROJECTS));
        cmbShowOnly.Items.Add(new RadComboBoxItem("All", ApplicationConstants.SHOW_ALL_PROJECTS));

        if (CurrentUser.UserRole.Id == ApplicationConstants.ROLE_TECHNICAL_ADMINISTATOR ||
            CurrentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR ||
            CurrentUser.UserRole.Id == ApplicationConstants.ROLE_FUNCTIONAL_MANAGER)
            cmbShowOnly.SelectedValue = ApplicationConstants.SHOW_ONLY_ACTIVE_PROJECTS;
        else
            cmbShowOnly.SelectedValue = ApplicationConstants.SHOW_ALL_PROJECTS;
    }

    private void UpdateFunctionLabel()
    {
        DataRow row = cmbPJ.GetComboSelection();
        //Updates the label on the screen for the function
        lblFunction.Text = (row["ProjectFunction"] == DBNull.Value) ? "" : row["ProjectFunction"].ToString();
    }

    private void UpdateActiveMembersLabel()
    {
        DataRow row = cmbPJ.GetComboSelection();
        //Updates the label on the screen for the active members
        lblActiveMembers.Text = (row["ProjectFunction"] == DBNull.Value) ? "" : row["ActiveMembers"].ToString();
    }

    private void UpdateTimingIntercoPercentLabel()
    {
        DataRow row = cmbPJ.GetComboSelection();
        //Updates the label on the screen for the timing & interco percent
		lblTimingIntercoPercent.Text = (row["ProjectFunction"] == DBNull.Value) ? "" : row["TimingIntercoPercent"].ToString();
    }

    private void UpdateInitialBudgetValidatedLabel()
    {
        DataRow row = cmbPJ.GetComboSelection();
        //Updates the label on the screen for the initial budget validated
		if (row["ProjectFunction"] == DBNull.Value)
		{
			lblInitialBudgetValidated.Text = String.Empty;
		}
		else
		{
			lblInitialBudgetValidated.Text = (bool)row["IsInitialBudgetValidated"] ? "Yes" : "No";
		}	
    }

    #endregion Private Methods
}
