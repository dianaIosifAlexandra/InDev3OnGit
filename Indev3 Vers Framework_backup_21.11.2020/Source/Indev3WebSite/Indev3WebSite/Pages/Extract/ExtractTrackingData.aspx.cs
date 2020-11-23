using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections.Generic;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.BusinessLogic.Extract;
using Inergy.Indev3.BusinessLogic.Common;
using System.Text;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.DataAccess.Catalogues;

namespace Inergy.Indev3.UI
{
    public partial class Pages_Extract_ExtractTrackingData : IndBasePage
    {
        #region Members
        CurrentUser currentUser = null;
        #endregion

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //Add the ajax settings for this window
                AddAjaxSettings();
                string issuer = (string.IsNullOrEmpty(Page.Request.Params.Get("__EVENTTARGET")) ? string.Empty : Page.Request.Params.Get("__EVENTTARGET"));

                if (!Page.IsPostBack || issuer.Contains("lnkChange"))
                {
                    PopulateComboBoxes();
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

        protected void Page_Init(object sender, EventArgs e)
        {
            try
            {
                currentUser = SessionManager.GetCurrentUser(this);
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

        protected void btnDownload_Click(object sender, EventArgs e)
        {
            try
            {
                DownloadFile();
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

        #region Methods
        private void PopulateComboBoxes()
        {
            LoadYearCombo();
            LoadPrograms();
            LoadProjects();
        }

        private void LoadYearCombo()
        {
            //Set the combo data source
            cmbYear.DataSource = PeriodUtils.GetYears();
            cmbYear.DataBind();
            cmbYear.SelectedIndex = cmbYear.Items.Count - 1 - ApplicationConstants.YEAR_AHEAD_TO_INCLUDE; /*select curent year*/
        }

        private void LoadPrograms()
        {
            int ownerId;
            ownerId = ApplicationConstants.INT_NULL_VALUE;
            LoadProgramsFiltered(ownerId);
        }


        private void LoadProgramsFiltered(int ownerId)
        {
            ProjectSelectorFilter projectSelectorFilter = new ProjectSelectorFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            projectSelectorFilter.IdOwner = ownerId;
            projectSelectorFilter.IdAssociate = currentUser.IdAssociate;
            projectSelectorFilter.ShowOnly = string.Empty; //it is not used
            projectSelectorFilter.IdProgram = -1; //all program
            DataSet programsDS = projectSelectorFilter.SelectProcedure("SelectPrograms");
            DSUtils.AddEmptyRecord(programsDS.Tables[0],"ProgramId");

            cmbProgram.DataSource = programsDS;
            cmbProgram.DataMember = programsDS.Tables[0].ToString();
            cmbProgram.DataValueField = "ProgramId";
            cmbProgram.DataTextField = "Name";
            cmbProgram.DataBind();
       }


        private void LoadProjectsFiltered(int programId)
        {
            ProjectSelectorFilter projectSelectorFilter = new ProjectSelectorFilter(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER);

            if (!cmbProgram.IsEmptyValueSelected())
                projectSelectorFilter.IdProgram = Int32.Parse(cmbProgram.SelectedValue);
            else
                projectSelectorFilter.IdProgram = -1;
            projectSelectorFilter.IdAssociate = currentUser.IdAssociate;

            DataSet projectDS = projectSelectorFilter.SelectProcedure("SelectProjects"); ;
            DSUtils.AddEmptyRecord(projectDS.Tables[0],"ProjectId");
            cmbProject.DataSource = projectDS;
            cmbProject.DataMember = projectDS.Tables[0].ToString();
            cmbProject.DataValueField = "ProjectId";
            cmbProject.DataTextField = "ProjectName";
            cmbProject.DataBind();
        }

        protected void cmbProgram_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                //select the owner of the selected program

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


    private void LoadProjects()
    {
        int programId;

        //Fill the project combo box with the values corresponding to the OwnerId
        if (cmbProgram.IsEmptyValueSelected())
            programId = ApplicationConstants.INT_NULL_VALUE;
        else
            programId = Int32.Parse(cmbProgram.SelectedValue);

        LoadProjectsFiltered(programId);
    }

    protected void cmbProject_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            ProjectSelectorFilter projectSelectorFilter = null;

            if (cmbProject.IsEmptyValueSelected())
            {
                cmbProgram.ClearSelection();
                LoadPrograms();
            }
            else
            {
                DataRow row = cmbProject.GetComboSelection();

                //then the owner and the program
                projectSelectorFilter = new ProjectSelectorFilter(ApplicationConstants.INT_NULL_VALUE, int.Parse(cmbProject.SelectedValue), SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));


                //re-load the programs with the programs corresponding to the owner selected 
                LoadProgramsFiltered(projectSelectorFilter.IdOwner);

                //restore selection
                cmbProgram.SelectedValue = projectSelectorFilter.IdProgram.ToString();
            }

            //re-load the project with the projects corresponding to the program selected
            LoadProjects();
            if (projectSelectorFilter != null) //restore selection
            {
                cmbProject.SelectedValue = projectSelectorFilter.IdProject.ToString();

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


        private void DownloadFile()
         {
            String fileContent;
            DataSet ds;
            string separator = cmbSeparator.SelectedValue;
            if (string.IsNullOrEmpty(separator)) separator = ";";

            ds = GetDataSet();
            if (ds == null)
            {
                this.ShowError(new IndException(ApplicationMessages.EXCEPTION_EXTRACT_NODATA));
                return;
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                fileContent = ExtractMethod(ds, separator);
                if (fileContent.Length > 0)
                {
                    //Download the file
                    DownloadUtils.DownloadFile(GetExportFileName(), fileContent);

                }
            }
            else
                this.ShowError(new IndException(ApplicationMessages.EXCEPTION_EXTRACT_NODATA));

        }


        //Year_ProgramorProject_Role_Date_Hour
        //Rules:
                //ProgramorProject :
                //-If a program is selected but without project , insert the program code
                //-if a program is selected but with a project, insert the project code (and not the progam code)
                //-If no program, then ‘All’
                //Role : BA or KU
                //Date of the extraction
                //Hour of the extraction

        private string GetExportFileName()
        {
            CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_USER);

            string fileName;
            fileName = cmbYear.SelectedItem.Text;
            if (cmbProject.SelectedIndex > 0)
            {
                //extract project code from cmbProject.Text
                string pjCode = cmbProject.Text;
                string[] temp = pjCode.Split(new char[] { '[' });
                if (temp != null && temp.Length > 0)
                {
                    pjCode = temp[0].Trim();
                }
                fileName += "_" + pjCode;
            }
            else
            {
                if (cmbProgram.SelectedIndex > 0)
                {
                    //extract program code from cmbProgram.TExt
                    string pgCode = cmbProgram.Text;
                    string[] temp = pgCode.Split(new char[] {'['});
                    if (temp != null && temp.Length > 1)
                    {
                        pgCode = temp[1].Trim().Replace("]", string.Empty);
                    }
                    fileName += "_" + pgCode;
                }
                else
                {
                    fileName += "_All";
                }
            }

            if (cmbRole.SelectedIndex <= 0)
            {
                fileName += "_All_";
            }
            else if (cmbRole.SelectedIndex == 1)
            {
                fileName += "_BA_";
            }
            else if (cmbRole.SelectedIndex == 2)
            {
                fileName += "_KU_";
            }

            fileName += string.Format("{0:yyyyMMdd_HHmmss}",DateTime.Now) + ".csv";

            return fileName;
        }


        private DataSet GetDataSet()
        {
            DataSet ds = null;
            ExtractTrackingData extractTrackingData = new ExtractTrackingData(SessionManager.GetSessionValueNoRedirect(this, SessionStrings.CONNECTION_MANAGER));
            extractTrackingData.Year = int.Parse(cmbYear.SelectedItem.Text);
            extractTrackingData.IdProgram = int.Parse(cmbProgram.SelectedItem.Value);
            extractTrackingData.IdProject = int.Parse(cmbProject.SelectedItem.Value);
            extractTrackingData.IdRole = int.Parse(cmbRole.SelectedItem.Value);
            ds = extractTrackingData.GetData();

            return ds;
        }

        private string ExtractMethod(DataSet ds, string separator)
        {
            //StringBuilder that will hold the contents of the csv file to be exported
            StringBuilder fileContent = new StringBuilder();
            //List holding visible column names
            List<string> visibleColumnNames = new List<string>();
            foreach (DataColumn col in ds.Tables[0].Columns)
            {
                visibleColumnNames.Add(col.ColumnName);
                fileContent.Append("\"" + col.ColumnName + "\"" + separator);
            }

            if (fileContent.ToString().EndsWith(separator))
                fileContent.Remove(fileContent.Length - 1, 1);

            DataRow[] rows = ds.Tables[0].Select();
            fileContent.Append(DSUtils.BuildCSVExport(rows, visibleColumnNames, true, separator,true));
            return fileContent.ToString();
        }

        private string ExtractMethod(DataSet ds, string separator, Boolean dateWithTime)
        {
            //StringBuilder that will hold the contents of the csv file to be exported
            StringBuilder fileContent = new StringBuilder();
            //List holding visible column names
            List<string> visibleColumnNames = new List<string>();
            foreach (DataColumn col in ds.Tables[0].Columns)
            {
                visibleColumnNames.Add(col.ColumnName);
                fileContent.Append("\"" + col.ColumnName + "\"" + separator);
            }

            if (fileContent.ToString().EndsWith(separator))
                fileContent.Remove(fileContent.Length - 1, 1);

            DataRow[] rows = ds.Tables[0].Select();
            fileContent.Append(DSUtils.BuildCSVExport(rows, visibleColumnNames, true, separator, dateWithTime));
            return fileContent.ToString();
        }

        /// <summary>
        /// Adds the ajax settings for this window
        /// </summary>
        private void AddAjaxSettings()
        {
            //get the ajax manager from the IndBasePage
            RadAjaxManager ajaxManager = GetAjaxManager();
            ajaxManager.ClientEvents.OnRequestStart = "RequestStartNoMaster";
            ajaxManager.ClientEvents.OnResponseEnd = "ResponseEndNoMaster";

            //get the errors pannel
            Panel phErrors = (Panel)Master.FindControl("pnlErrors");

            //add ajax settings

            //it can't be sent binary files via call backs
            //ajaxManager.AjaxSettings.AddAjaxSetting(btnDownload, phErrors); 
        }
        #endregion
    }
}