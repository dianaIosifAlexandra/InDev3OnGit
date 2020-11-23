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

using Telerik.WebControls;

using Inergy.Indev3.DataAccess;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework.WebControls;


namespace Inergy.Indev3.UI
{
    public partial class UserControls_UserSettings_UserSettings : IndBaseControl
    {
        #region Members
        private CurrentUser CurrentUser;
        private bool AccessDenied = false;
        #endregion Members

        #region Event Handlers
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                btnChangeCountry.OnClientClick = "needToConfirm = false; if (!ShowPopUpWithoutPostBack('../Authorization/SelectUserCountry.aspx?UserSettings=1', 0, 300, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;";
                if (!IsPostBack)
                {
                    hdnUserSettingsDirty.Value = "0";
                }

                bool isFromChangeCountryPopUp = String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["ChangeCountry"]) ? false : true;
                if (!isFromChangeCountryPopUp)
                {
                    CurrentUser = SessionManager.GetCurrentUser(ParentPage);
                }
                else
                {
                    CurrentUser = (CurrentUser)SessionManager.GetSessionValueRedirect(ParentPage, SessionStrings.TEMP_CURRENT_USER);
                    if (CurrentUser == null) //we are elready in a redirect, code below would crack
                        return;
                }
                //This can only happen if the current user has no right in the application (after changing the country, the new user may be
                //in this situaton)
                if (SessionManager.GetCurrentUser(ParentPage) != null && !SessionManager.GetCurrentUser(this.Page).HasViewPermission(ApplicationConstants.MODULE_USER_SETTINGS))
                {
                    AccessDenied = true;
                    throw new IndException(ApplicationMessages.EXCEPTION_NO_PERMISSION_TO_VIEW_PAGE);
                }

                SetChangeCountryButtonState();
                AddAjaxSettings();
                if (!IsPostBack || isFromChangeCountryPopUp)
                {
                    LoadUserSettings();
                }
            }

            catch (IndException ex)
            {
                HideControls();
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
        }



        protected void btnSaveConfiguration_Click(object sender, EventArgs e)
        {
            try
            {
                SaveUserConfiguration();
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


        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                if (AccessDenied)
                {
                    HideControls();
                }
                PopulateControlsWithUserSettings();
                base.OnPreRender(e);
            }
            catch (IndException ex)
            {
                HideControls();
                ReportControlError(ex);
                return;
            }
            catch (Exception ex)
            {
                HideControls();
                ReportControlError(new IndException(ex));
                return;
            }
        }

        private void PopulateControlsWithUserSettings()
        {
            if (CurrentUser.Settings == null)
                return;

            txtNumberOfRecordsPerPage.Text = CurrentUser.Settings.NumberOfRecordsPerPage.ToString();
            cmbAmountScaleOption.SelectedValue = ((int)CurrentUser.Settings.AmountScaleOption).ToString();
            cmbCurrencyRepresentation.SelectedValue = ((int)CurrentUser.Settings.CurrencyRepresentation).ToString();
        }

        protected void btnChangeCountry_Click(object sender, EventArgs e)
        {
            try
            {
                hdnUserSettingsDirty.Value = "1";
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
        /// loads settings from database to user interface textboxes
        /// </summary>
        private void LoadUserSettings()
        {
            AmountScaleOption amountScaleOption;
            int numberOfRecordsPerPage;
            CurrencyRepresentationMode currencyRepresentationMode;
            UserSettings userSettings = CurrentUser.Settings;
            if (userSettings == null)
            {
                DataTable userSettingsTable = GetData();
                if (userSettingsTable.Rows.Count == 1)
                {
                    DataRow row = userSettingsTable.Rows[0];
                    amountScaleOption = (AmountScaleOption)int.Parse(row["AmountScaleOption"].ToString());
                    numberOfRecordsPerPage = (int)row["NumberOfRecordsPerPage"];
                    currencyRepresentationMode = (CurrencyRepresentationMode)int.Parse(row["CurrencyRepresentation"].ToString());
                }
                else
                {
                    amountScaleOption = AmountScaleOption.Unit;
                    numberOfRecordsPerPage = ApplicationConstants.DEFAULT_DATAGRID_PAGESIZE;
                    currencyRepresentationMode = CurrencyRepresentationMode.CostCenter;
                }

                CurrentUser.Settings = new UserSettings();
                CurrentUser.Settings.AmountScaleOption = amountScaleOption;
                CurrentUser.Settings.NumberOfRecordsPerPage = numberOfRecordsPerPage;
                CurrentUser.Settings.CurrencyRepresentation = currencyRepresentationMode;
            }
            else
            {
                amountScaleOption = userSettings.AmountScaleOption;
                numberOfRecordsPerPage = userSettings.NumberOfRecordsPerPage;
                currencyRepresentationMode = userSettings.CurrencyRepresentation;
            }

            LoadAmountScaleOption(amountScaleOption);
            LoadCurrencyRepresentation(currencyRepresentationMode);

            lblCountry.Text = CurrentUser.CountryName;
        }

        /// <summary>
        /// gets data from database
        /// </summary>
        /// <returns></returns>
        private DataTable GetData()
        {
            UserSettings userSettings = new UserSettings(CurrentUser.IdAssociate, SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.CONNECTION_MANAGER));
            DataTable userSettingsTable = userSettings.SelectUserSettings();
            return userSettingsTable;
        }
        /// <summary>
        /// load currency combo
        /// </summary>

        private void LoadCurrencyRepresentation(CurrencyRepresentationMode currencyRepresentationMode)
        {
            cmbCurrencyRepresentation.Items.Clear();
            cmbCurrencyRepresentation.Items.Add(new RadComboBoxItem("local currency", ((int)CurrencyRepresentationMode.CostCenter).ToString()));
            cmbCurrencyRepresentation.Items.Add(new RadComboBoxItem("user currency", ((int)CurrencyRepresentationMode.Associate).ToString()));
        }
        /// <summary>
        /// load amount combo
        /// </summary>

        private void LoadAmountScaleOption(AmountScaleOption amountScaleOption)
        {
            cmbAmountScaleOption.Items.Clear();
            cmbAmountScaleOption.Items.Add(new RadComboBoxItem("Unit", ((int)AmountScaleOption.Unit).ToString()));
            cmbAmountScaleOption.Items.Add(new RadComboBoxItem("Thousands", ((int)AmountScaleOption.Thousands).ToString()));
            cmbAmountScaleOption.Items.Add(new RadComboBoxItem("Millions", ((int)AmountScaleOption.Millions).ToString()));
        }

        private void SaveUserConfiguration()
        {
            int numberOfRecordsOnPage = ApplicationConstants.INT_NULL_VALUE;
            string texNumberOfRecords = txtNumberOfRecordsPerPage.Text;
            if (!string.IsNullOrEmpty(texNumberOfRecords))
            {
                bool resultParse = Int32.TryParse(texNumberOfRecords, out numberOfRecordsOnPage);
                if (!resultParse || numberOfRecordsOnPage <= 0)
                    numberOfRecordsOnPage = ApplicationConstants.INT_NULL_VALUE;
            }
            if (numberOfRecordsOnPage == ApplicationConstants.INT_NULL_VALUE)
            {
                return;
            }

            UserSettings usrSettings = new UserSettings(CurrentUser.IdAssociate, (AmountScaleOption)Int32.Parse(cmbAmountScaleOption.SelectedValue), numberOfRecordsOnPage, (CurrencyRepresentationMode)Int32.Parse(cmbCurrencyRepresentation.SelectedValue), SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.CONNECTION_MANAGER));
            bool result = usrSettings.InsertOrUpdateUserSettings();
           
            if (result)
            {
                string redirectScript = String.Empty;
                CurrentUser.Settings = usrSettings;
                SessionManager.SetSessionValue(ParentPage, SessionStrings.CURRENT_USER, CurrentUser);
                bool isFromChangeCountryPopUp = String.IsNullOrEmpty(HttpContext.Current.Request.QueryString["ChangeCountry"]) ? false : true;
                if (isFromChangeCountryPopUp)
                {
                    //Remove the current project from session when changing the user
                    SessionManager.RemoveValueFromSession(ParentPage, SessionStrings.CURRENT_PROJECT);
                    redirectScript = "window.location = '" + ResolveUrl(ParentPage.Request.Url.ToString()) + "';";
                }
                if (!Page.ClientScript.IsStartupScriptRegistered(typeof(Page), "SaveConfirmation"))
                {
                    Page.ClientScript.RegisterStartupScript(typeof(Page), "SaveConfirmation", "alert('User Settings successfully saved!');" + redirectScript, true);
                }
            }
        }
        /// <summary>
        /// Sets the Change Country button enabled or disabled, depending whether more than 1 country is associated to the current inergy
        /// login
        /// </summary>
        private void SetChangeCountryButtonState()
        {
            DataTable tblCountries = CurrentUser.GetUserCountries();
            //Enable the change country button only if there are more more countries for the inergy login of the current user
            btnChangeCountry.Enabled = tblCountries.Rows.Count > 1;
        }

        private void HideControls()
        {
            pnlUserSettings.Visible = false;
        }
        
        private void AddAjaxSettings()
        {
            RadAjaxManager ajaxManager = ParentPage.GetAjaxManager();
            Panel pnlErrors = (Panel)ParentPage.Master.FindControl("pnlErrors");
            ajaxManager.AjaxSettings.AddAjaxSetting(pnlUserSettings, pnlErrors);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSaveConfiguration, hdnUserSettingsDirty);
            ajaxManager.AjaxSettings.AddAjaxSetting(btnSaveConfiguration, pnlErrors);
        }
        #endregion Private Methods
    }
}