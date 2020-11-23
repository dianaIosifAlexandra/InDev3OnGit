using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.ComponentModel;
using Telerik.WebControls;
using System.Drawing;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// The YearMonth control that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.DropDownList))]
    [ToolboxData("<{0}:IndYearMonth runat=\"server\"></{0}:IndYearMonth>")]
    public class IndYearMonth : CompositeControl, INamingContainer
    {
        #region Members
        /// <summary>
        /// The Year label
        /// </summary>
        protected Label lblYear = new Label();
        /// <summary>
        /// The month label
        /// </summary>
        protected Label lblMonth = new Label();
        /// <summary>
        /// The Year combobox
        /// </summary>
        protected RadComboBox cmbYear = new RadComboBox();
        /// <summary>
        /// The month combobox
        /// </summary>
        protected RadComboBox cmbMonth = new RadComboBox();
        /// <summary>
        /// RequiredFieldValidator for cmbYear
        /// </summary>
        private RequiredFieldValidator reqYear = new RequiredFieldValidator();
        /// <summary>
        /// RequiredFieldValidator for cmbMonth
        /// </summary>
        private RequiredFieldValidator reqMonth = new RequiredFieldValidator();
        #endregion Members

        #region Properties
        public string Text
        {
            get { return GetValue().ToString(); }
            set { SetValue(value); }
        }
        private string _EntityProperty;
        [DefaultValue("")]
        [Category("Extension")]
        public string EntityProperty
        {
            get { return _EntityProperty; }
            set { _EntityProperty = value; }
        }

        private bool _EnabledOnNew = true;
        /// <summary>
        /// True if this textbox will be enabled on add operation
        /// </summary>
        [DefaultValue(true)]
        [Category("Extension")]
        public bool EnabledOnNew
        {
            get { return _EnabledOnNew; }
            set { _EnabledOnNew = value; }
        }

        private bool _EnabledOnEdit = true;
        /// <summary>
        /// True if this textbox will be enabled on edit operation
        /// </summary>
        [DefaultValue(true)]
        [Category("Extension")]
        public bool EnabledOnEdit
        {
            get { return _EnabledOnEdit; }
            set { _EnabledOnEdit = value; }
        }

        private int _FirstYear;
        [Category("Extension")]
        /// <summary>
        /// Th first year that will appear in the combobox
        /// </summary>
        public int FirstYear
        {
            get { return _FirstYear; }
            set { _FirstYear = value; }
        }

        private int _LastYear;
        [Category("Extension")]
        /// <summary>
        /// Th first year that will appear in the combobox
        /// </summary>
        public int LastYear
        {
            get { return _LastYear; }
            set { _LastYear = value; }
        }
        private bool _CheckDirty = true;
        /// <summary>
        /// If it is set to Yes, the textbox will set the dirty flag onkeypress
        /// </summary>
        [DefaultValue("true")]
        [Category("Extension")]
        public bool CheckDirty
        {
            get { return _CheckDirty; }
            set { _CheckDirty = value; }
        }
        internal ControlHierarchyManager ControlHierarchyManager;

        #endregion Properties

        #region Constructor
        /// <summary>
        /// Default Constructor
        /// </summary>
        public IndYearMonth()
        {
            //Set the value for the labels
            lblYear.ID = "lblYear";
            lblYear.Text = "Year";
            lblMonth.ID = "lblMonth";
            lblMonth.Text = "Month";
            cmbYear.ID = "cmbYear";
            cmbMonth.SkinsPath = "~/Skins/ComboBox";
            cmbMonth.Skin = "Default";
            cmbYear.Width = 60;
            cmbYear.SkinsPath = "~/Skins/ComboBox";
            cmbYear.Skin = "Default";
            cmbYear.Height = 100;
            cmbMonth.ID = "cmbMonth";
            cmbMonth.Width = 40;
            cmbMonth.Height = 100;
            _FirstYear = YearMonth.FirstYear;
            _LastYear = YearMonth.LastYear;
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructor

        #region Public Methods
        /// <summary>
        /// Sets the height of the Year and Month combo boxes
        /// </summary>
        /// <param name="height">The height (in pixels)</param>
        public void SetComboHeight(Unit height)
        {
            try
            {
                this.cmbMonth.Height = height;
                this.cmbYear.Height = height;
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return;
            }
        }

        public void SetValue(object val)
        {
            //Covers the Add operation
            try
            {
                if (val.GetType() == typeof(string))
                    val = val.ToString().Replace("&nbsp;", String.Empty);
                if ((val == null) || (String.IsNullOrEmpty(val.ToString())))
                    return;
                if (int.Parse(val.ToString()) == 0)
                    return;
                
                //Treat the null case
                if (int.Parse(val.ToString()) == ApplicationConstants.INT_NULL_VALUE)
                {
                    cmbYear.SelectedValue = "";
                    cmbMonth.SelectedValue = "";
                    return;
                }
                //The object value should have the format YYYYMM
                if (val.ToString().Length != 6)
                    throw new IndException(ApplicationMessages.EXCEPTION_YEARMONTH_NOT_HAVE_FORMAT);
                int yearmonth = int.Parse(val.ToString());
                int year = yearmonth / 100;
                int month = yearmonth % 100;
                //Set the selected index. The selected value does not work
                cmbYear.SelectedIndex = year - FirstYear + 1;
                cmbMonth.SelectedIndex = month;
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return;
            }
        }
        public object GetValue()
        {
            try
            {
                //If any of the comboboxes are empty return -1
                if (String.IsNullOrEmpty(cmbYear.Text) || String.IsNullOrEmpty(cmbMonth.Text))
                    return ApplicationConstants.INT_NULL_VALUE;
                //Concatenate the values in the comboboxes
                string month = (cmbMonth.Text.Length == 1) ? "0" + cmbMonth.Text : cmbMonth.Text;
                string yearMonth = cmbYear.Text + month;
                //Return the concatenated value as int
                return int.Parse(yearMonth);
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return null;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return null;
            }
        }
        /// <summary>
        /// Sets the comboboxes datasource
        /// </summary>
        /// <param name="attributes"></param>
        public void SetDataSource(object[] attributes)
        {

        }

        /// <summary>
        /// Adds validators to each of the 2 comboboxes (year and month)
        /// </summary>
        /// <param name="controlFunctionalName"></param>
        public void AddValidators(string controlFunctionalName)
        {
            reqYear.ID = "RequiredValidator" + cmbYear.UniqueID;
            reqYear.ControlToValidate = cmbYear.ID;
            reqYear.Display = ValidatorDisplay.Dynamic;
            reqYear.Text = "*";
            reqYear.ForeColor = Utils.IndConstants.ColorValidator;
            reqYear.ErrorMessage = "Year in " + controlFunctionalName + " not filled in.";

            reqMonth.ID = "RequiredValidator" + cmbMonth.UniqueID;
            reqMonth.ControlToValidate = cmbMonth.ID;
            reqMonth.Display = ValidatorDisplay.Dynamic;
            reqMonth.Text = "*";
            reqMonth.ForeColor = Utils.IndConstants.ColorValidator;
            reqMonth.ErrorMessage = "Month in " + controlFunctionalName + " not filled in.";

            this.Controls.Add(reqYear);
            this.Controls.Add(reqMonth);
        }
        #endregion Public Methods

        #region Overrides
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                //Set the CSS classes for the labels
                lblYear.CssClass = CSSStrings.LabelCssClass;
                lblMonth.CssClass = CSSStrings.LabelCssClass;

                if (_CheckDirty)
                {
                    cmbYear.OnClientSelectedIndexChanged = "RadComboBoxSetDirty";
                    cmbMonth.OnClientSelectedIndexChanged = "RadComboBoxSetDirty";
                }

                if (!Page.ClientScript.IsStartupScriptRegistered("FixCombo_" + cmbMonth.ClientID))
                    Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "FixCombo_" + cmbMonth.ClientID, "try {FixCombo(" + cmbMonth.ClientID + "); FixCombo(" + cmbYear.ClientID + ");}catch(err){}", true);

                base.OnPreRender(e);
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return;
            }
        }

        protected override void CreateChildControls()
        {
            try
            {
                //Add the controls to the screen
                //this.Controls.Add(lblYear);
                this.Controls.Add(cmbYear);
                //this.Controls.Add(lblMonth);
                this.Controls.Add(cmbMonth);
                PopulateControls();
                base.CreateChildControls();
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return;
            }
        }

        
        #endregion Overrides

        #region Private Methods
        private void PopulateControls()
        {
            //Set the Year Combobox datasource
            cmbYear.Items.Add(new RadComboBoxItem(String.Empty));
            for (int yearIterator = _FirstYear; yearIterator <= _LastYear; yearIterator++)
                cmbYear.Items.Add(new RadComboBoxItem(yearIterator.ToString()));
            //Set the Month Combobox datasource
            cmbMonth.Items.Add(new RadComboBoxItem(String.Empty));
            for (int monthIterator = 1; monthIterator <= 12; monthIterator++)
                cmbMonth.Items.Add(new RadComboBoxItem(monthIterator.ToString()));
        }
        #endregion Private Methods
    }
}
