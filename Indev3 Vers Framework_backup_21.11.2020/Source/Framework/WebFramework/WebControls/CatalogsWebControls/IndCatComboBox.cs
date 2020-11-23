using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Diagnostics;
using System.Web.UI.WebControls;
using Telerik.WebControls;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Reflection;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.WebFramework.WebControls
{

    [DefaultProperty("ID")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.DropDownList))]
    [ToolboxData("<{0}:IndCatComboBox runat=\"server\"></{0}:IndCatComboBox>")]
    public class IndCatComboBox : IndComboBox, IGenericCatWebControl
    {
        #region Members
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

        public string _EntityProperty;
        [DefaultValue("")]
        [Category("Extension")]
        public string EntityProperty
        {
            get { return _EntityProperty; }
            set { _EntityProperty = value; }
        }

        private string _ReferencedControlName;
        [DefaultValue("")]
        [Category("Extension")]
        /// <summary>
        /// Gets or sets the control name that will be updated on IndexChanged
        /// </summary>
        public string ReferencedControlName
        {
            get { return _ReferencedControlName; }
            set { _ReferencedControlName = value; }
        }

        private string _ReferencedControlValueMember;
        [DefaultValue("")]
        [Category("Extension")]
        /// <summary>
        /// Gets or sets the value member of the referenced control.
        /// This value must be in the data source of the combobox.
        /// </summary>
        public string ReferencedControlValueMember
        {
            get { return _ReferencedControlValueMember; }
            set { _ReferencedControlValueMember = value; }
        }

        private bool _VisibleOnNew = true;
        /// <summary>
        /// True if this textbox will be visible on add operation
        /// </summary>
        [DefaultValue(true)]
        [Category("Extension")]
        public bool VisibleOnNew
        {
            get { return _VisibleOnNew; }
            set { _VisibleOnNew = value; }
        }

        private bool _VisibleOnEdit = true;
        /// <summary>
        /// True if this textbox will be visible on edit operation
        /// </summary>
        [DefaultValue(true)]
        [Category("Extension")]
        public bool VisibleOnEdit
        {
            get { return _VisibleOnEdit; }
            set { _VisibleOnEdit = value; }
        }
        #endregion Members

        #region Constructors

        public IndCatComboBox()
            : base()
        {
            this.SelectedIndexChanged += new Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventHandler(IndComboBox_SelectedIndexChanged);
            if (Inergy.Indev3.WebFramework.Utils.HelperFunctions.GetInternetExplorerVersion() != 7.0)
            {
                this.Style.Add("margin-left", "-2px");
            }
            else
            {
                this.Style.Add("margin-left", "0px");
            }
        }
        #endregion Constructors

        #region Public Methods


        public void SetDataSource(object[] attributes)
        {
            try
            {
                ReferenceMappingAttribute attribute = attributes[0] as ReferenceMappingAttribute;
                if (attribute == null)
                    throw new IndException(ApplicationMessages.EXCEPTION_WRONG_ATTRIBUTE_RECEIVED);


                IGenericEntity referencedEntity = EntityFactory.GetEntityInstance(attribute.ReferencedEntity, SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
                //Call the GetAll() method of the referenced object
                DataSet referencedDataSet = referencedEntity.GetAll();
                DSUtils.AddEmptyRecord(referencedDataSet.Tables[0]);
                //Set the DataSource, DataMember, DataValueField and DataTextField of the combobox
                this.DataSource = referencedDataSet;
                this.DataMember = referencedDataSet.Tables[0].TableName;
                this.DataBind();
                this.SelectedValue = ApplicationConstants.INT_NULL_VALUE.ToString();
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
        #endregion Public Methods

        #region Event Handlers

        private void IndComboBox_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            try
            {
                if (String.IsNullOrEmpty(ReferencedControlName))
                    return;
                Control referencedControl = this.Parent.FindControl(ReferencedControlName);
                if (referencedControl == null)
                    throw new IndException(ReferencedControlName + "was not found.");
                if (!(referencedControl is IGenericCatWebControl))
                    throw new IndException(ReferencedControlName + "does not implement IGenericWebControl.");
                //The dataTable exist because the event was fired
                DataTable tbl = ((DataSet)this.DataSource).Tables[0];
                if (!tbl.Columns.Contains(this.ReferencedControlValueMember))
                    throw new IndException(ReferencedControlValueMember + "was not found in the datasource table.");
                object referencedControlValue = tbl.Rows[this.SelectedIndex][this.ReferencedControlValueMember];
                ((IGenericCatWebControl)referencedControl).SetValue(referencedControlValue);
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

        protected override void OnLoad(EventArgs e)
        {
            try
            {
                if (!String.IsNullOrEmpty(ReferencedControlName))
                    this.AutoPostBack = true;

                base.OnLoad(e);
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
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                if (_FocusOnLoad)
                    this.Focus();

                AddAjaxReference();

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
        #endregion Event Handlers

        #region Private Methods
        private void AddAjaxReference()
        {
            if (String.IsNullOrEmpty(this.ReferencedControlName))
                return;
            if (!(this.Parent is GenericEditControl))
                return;

            Control referencedControl = this.Parent.FindControl(ReferencedControlName);
            if (referencedControl == null)
                throw new IndException(ReferencedControlName + "was not found.");
            if (!(referencedControl is IGenericCatWebControl))
                throw new IndException(ReferencedControlName + "does not implement IGenericWebControl.");

            GenericEditControl parent = (GenericEditControl)this.Parent;
            parent.AjaxManager.AjaxSettings.AddAjaxSetting(this, referencedControl);
        }
        #endregion Private Methods
    }
}
