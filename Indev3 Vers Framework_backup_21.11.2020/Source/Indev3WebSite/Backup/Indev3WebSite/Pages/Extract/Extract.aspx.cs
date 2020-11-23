using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.BusinessLogic.Extract;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;

namespace Inergy.Indev3.UI
{
    public partial class Pages_Extract_Extract : IndBasePage
    {
        private CurrentProject currentProject
        {
            get
            {
                return SessionManager.GetSessionValueRedirect(this, SessionStrings.CURRENT_PROJECT) as CurrentProject;
            }
        }        

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //Add the ajax settings for this window
                AddAjaxSettings();
                string issuer = (string.IsNullOrEmpty(Page.Request.Params.Get("__EVENTTARGET")) ? string.Empty : Page.Request.Params.Get("__EVENTTARGET"));

                if (!Page.IsPostBack || issuer.Contains("lnkChange"))
                {                    
                    DisplayCurrentProjectLabel();
                    LoadCombos();
                    SetCurrentVersionLabel();
                    SetCboVerionVisibility();
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
        private void SetCboYearVisibility()
        {

            if (cmbSource.SelectedValue == ((int)EExtractSource.annual_budget).ToString())
            {
                lblYear.Style.Add("display", "inline");
                cmbYear.Style.Add("display", "inline");
            }
            else
            {
                lblYear.Style.Add("display", "none");
                cmbYear.Style.Add("display", "none");
            }
        }

        protected void cmbSource_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                SetCurrentVersionLabel();
                SetCboYearVisibility();
                SetCboVerionVisibility();

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
        protected void cmbType_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                SetCurrentVersionLabel();
                SetCboYearVisibility();
                SetCboVerionVisibility();

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
        private void SetCurrentVersionLabel()
        {
            string version = GetSourceCurrentVersion();
            if (string.IsNullOrEmpty(version))
            {
                lblCurrentVersion.Text = "No version available";
            }
            else
            {
                if (version != "_")
                {
                    lblCurrentVersion.Text = string.Empty;
                    LoadVersionCombo(version);
                }
                else
                    lblCurrentVersion.Text = string.Empty;
            }
        }

        private void DownloadFile()
        {
            String fileContent;
            DataSet ds;           

            ds = GetDataSet();
            if (ds == null)
            {
                this.ShowError(new IndException(ApplicationMessages.EXCEPTION_EXTRACT_NODATA));
                return;
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                fileContent = ExtractMethod(ds);
                if (fileContent.Length > 0)
                { 
                    //Download the file
                    DownloadUtils.DownloadFile(GetExportFileName(), fileContent);

                }
            }
            else
                this.ShowError(new IndException(ApplicationMessages.EXCEPTION_EXTRACT_NODATA));
            
        }

        //concatenate the file name to export
        //rule: 
            /*Program code (max 10 chars)
            Project code (max 10 chars)
            Budget Type (max 10)
            Version number (in case the exported budget type is revised or refoprecast)
            Separator is "_". extension of file is CSV.*/
        private string GetExportFileName()
        {
            string fileName;
            string budgetType = cmbSource.SelectedItem.Text;
            string sourceCurrentVersion = string.Empty;

            if (cmbSource.SelectedValue == ((int)EExtractSource.reforecast).ToString() ||
                cmbSource.SelectedValue == ((int)EExtractSource.revised).ToString())
            {
                if (lblCurrentVersion.Text == string.Empty)
                {
                    sourceCurrentVersion = cmbVersion.SelectedItem.Value;
                }
            }
            else
            {
                sourceCurrentVersion = GetSourceCurrentVersion();
            }

            
            if (cmbType.SelectedValue == ((int)EExtractType.project_only).ToString())
            {
                string[] projectCodeArr = currentProject.Name.Split('[');
                string projectCode = projectCodeArr[1].ToString().Substring(0,projectCodeArr[1].ToString().Length-1);
               
                fileName = currentProject.ProgramCode + "_" + projectCode + "_" + budgetType + "_" + sourceCurrentVersion + ".csv";                
            }
            else
            {
                fileName = currentProject.ProgramCode + "_ALL_" + budgetType + "_" + sourceCurrentVersion + ".csv";
            }
            //current version might be empty so double underscore must be replace
            return fileName.Replace("__.", ".");
        }
        

        private DataSet GetDataSet()
        {
            Extract extract = new Extract(SessionManager.GetConnectionManager(this));
            extract.IdProject = currentProject.Id;
            extract.IdProgram = currentProject.IdProgram;
            extract.Year = int.Parse(cmbYear.SelectedItem.Text);
            int idgeneration = -1;
            if ((cmbSource.SelectedValue == ((int)EExtractSource.reforecast).ToString() && (cmbType.SelectedValue == ((int) EExtractType.project_only).ToString())) ||
             (cmbSource.SelectedValue == ((int)EExtractSource.revised).ToString() && (cmbType.SelectedValue == ((int)EExtractType.project_only).ToString())))
            {
                if (lblCurrentVersion.Text == string.Empty)
                {
                    idgeneration = int.Parse(cmbVersion.SelectedItem.Value);
                }
            }
            extract.IdGeneration = idgeneration;
            extract.ActiveStatus = cmbActive.SelectedValue;
            CurrentUser user = (CurrentUser)SessionManager.GetSessionValueRedirect(this, "CurrentUser");
            extract.IdCurrencyAssociate = user.IdCurrency;
            DataSet ds = extract.GetExtractData(int.Parse(cmbType.SelectedValue), int.Parse(cmbSource.SelectedValue));

            if (ds != null)
            {
                ds.Tables[0].Columns["Exchange Rate"].ColumnName = "Exchange Rate (" + user.CodeCurrency + ")";
                ds.AcceptChanges();
            }
            return ds;
        }

        private string ExtractMethod(DataSet ds)
        {
            //StringBuilder that will hold the contents of the csv file to be exported
            StringBuilder fileContent = new StringBuilder();
            //List holding visible column names
            List<string> visibleColumnNames = new List<string>();
            foreach (DataColumn col in ds.Tables[0].Columns)
            {
                visibleColumnNames.Add(col.ColumnName);
                fileContent.Append("\"" + col.ColumnName + "\";");
            }

            if (fileContent.ToString().EndsWith(";"))
                fileContent.Remove(fileContent.Length - 1, 1);

            DataRow[] rows = ds.Tables[0].Select();
            fileContent.Append(DSUtils.BuildCSVExport(rows, visibleColumnNames, true));
            return fileContent.ToString();
        }

        private void DisplayCurrentProjectLabel()
        {
            if (currentProject != null)
            {
                lblProgramName.Text = currentProject.ProgramName + " [" + currentProject.ProgramCode + "]";
                lblProjectName.Text = currentProject.Name;
            }
        }

        private void LoadCombos()
        {
            EExtractType extType = new EExtractType();
            cmbType.DataSource = EnumUtil.MakeEnumWithSpaces(extType);
            cmbType.DataTextField = "Key";
            cmbType.DataValueField = "Value";
            cmbType.DataBind();
            cmbType.SelectedIndex = 0;

            EExtractSource source = new EExtractSource();
            cmbSource.DataSource = EnumUtil.MakeEnumWithSpaces(source);
            cmbSource.DataTextField = "Key";
            cmbSource.DataValueField = "Value";
            cmbSource.DataBind();
            cmbSource.SelectedIndex = 0;



            LoadYearCombo();
            SetCboYearVisibility();
            
        }
        void SetCboVerionVisibility()
        {
            if(cmbType.SelectedValue == ((int)EExtractType.entire_program).ToString())
            {
                cmbVersion.Style.Add("display", "none");
                lblVersion.Style.Add("display", "none");
                return;
            }
            if (cmbSource.SelectedValue == ((int)EExtractSource.reforecast).ToString() ||
             cmbSource.SelectedValue == ((int)EExtractSource.revised).ToString())
            {
                if (lblCurrentVersion.Text == string.Empty)
                {
                    cmbVersion.Style.Add("display", "inline");
                    lblVersion.Style.Add("display", "inline");
                }
                else
                {
                    cmbVersion.Style.Add("display", "none");
                    lblVersion.Style.Add("display", "none");
                }
            }
            else
            {
                cmbVersion.Style.Add("display", "none");
                lblVersion.Style.Add("display", "none");
            }
        }
        void LoadVersionCombo(string crtveriosn)
        {
            cmbVersion.Items.Clear();
            if (cmbSource.SelectedItem.Text == ApplicationConstants.BUDGET_TYPE_TOCOMPLETION.ToLower())
            {
                ReforecastBudget reforecastBug = new ReforecastBudget(SessionManager.GetConnectionManager(this));
                reforecastBug.IdProject = currentProject.Id;
                reforecastBug.Version = ApplicationConstants.BUDGET_VERSION_RELEASED_CODE;
                DataSet versionsDS = reforecastBug.GetVersions();
 
                foreach (DataRow r in versionsDS.Tables[0].Rows)
                {
                    cmbVersion.Items.Add(new RadComboBoxItem(r["IdGeneration"].ToString() , r["IdGeneration"].ToString()));
                }
            }
            if (cmbSource.SelectedItem.Text == ApplicationConstants.BUDGET_TYPE_REVISED.ToLower())
            {
                RevisedBudget revisedBug = new RevisedBudget(SessionManager.GetConnectionManager(this));
                revisedBug.IdProject = currentProject.Id;
                revisedBug.Version = ApplicationConstants.BUDGET_VERSION_RELEASED_CODE;
                DataSet versionsDS = revisedBug.GetVersions();

                foreach (DataRow r in versionsDS.Tables[0].Rows)
                {
                    cmbVersion.Items.Add(new RadComboBoxItem(r["IdGeneration"].ToString(), r["IdGeneration"].ToString()));
                }
            }
            cmbVersion.SelectedValue = crtveriosn;
        }

        private void LoadYearCombo()
        {
            //Set the combo data source
            cmbYear.DataSource = PeriodUtils.GetYears();
            cmbYear.DataBind();
            cmbYear.SelectedIndex = cmbYear.Items.Count - 1 - ApplicationConstants.YEAR_AHEAD_TO_INCLUDE  ; /*select curent year*/
        }
        /// <summary>
        /// Method that returns current version of selected budget only for Revised or Reforcast
        /// </summary>
        /// <returns>version number or empty for revised or Reforcast, _ character for initial and actual</returns>
        private string GetSourceCurrentVersion()
        {
            string versionNo = string.Empty;
            bool bIsFake;

            if (cmbSource.SelectedItem.Text == ApplicationConstants.BUDGET_TYPE_REVISED.ToLower())
            {
                RevisedBudget revisedBug = new RevisedBudget(SessionManager.GetConnectionManager(this));
                revisedBug.IdProject = currentProject.Id;
                revisedBug.Version = ApplicationConstants.BUDGET_VERSION_RELEASED_CODE;
                return revisedBug.GetVersionNumber(out bIsFake);
            }
            if (cmbSource.SelectedItem.Text == ApplicationConstants.BUDGET_TYPE_TOCOMPLETION.ToLower())
            {
                ReforecastBudget reforecastBug = new ReforecastBudget(SessionManager.GetConnectionManager(this));
                reforecastBug.IdProject = currentProject.Id;
                reforecastBug.Version = ApplicationConstants.BUDGET_VERSION_RELEASED_CODE;
                return reforecastBug.GetVersionNumber(out bIsFake);
            }            
           //if ends here there another type of budget(initial or actual)
            return "_";
        }

        /// <summary>
        /// Adds the ajax settings for this window
        /// </summary>
        private void AddAjaxSettings()
        {
            //get the ajax manager from the IndBasePage
            RadAjaxManager ajaxManager = GetAjaxManager();

            //get the errors pannel
            Panel phErrors = (Panel)Master.FindControl("pnlErrors");           

            //add ajax settings
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbSource, lblCurrentVersion);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbSource, phErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbSource, lblYear);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbSource, cmbYear);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbSource, cmbVersion);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbSource, lblVersion);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbType, cmbVersion);
            ajaxManager.AjaxSettings.AddAjaxSetting(cmbType, lblVersion);
        }
    }
}