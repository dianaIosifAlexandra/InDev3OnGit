using System;
using System.Collections.Generic;
using System.Text;
using Telerik.WebControls;
using System.Drawing;
using System.Web.UI;
using System.ComponentModel;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// DatePicker used by the application
    /// </summary>
    [DefaultProperty("ID")]
    [ToolboxBitmap(typeof(Calendar))]
    [ToolboxData("<{0}:IndCatDatePicker runat=\"server\"></{0}:IndCatDatePicker>")]
    public class IndCatDatePicker : IndDatePicker, IGenericCatWebControl
    {
        #region Members
        /// <summary>
        /// The property mapped to this control
        /// </summary>
        private string _EntityProperty;
        [DefaultValue("")]
        [Category("Extension")]
        public string EntityProperty
        {
            get
            {
                return _EntityProperty;
            }
            set
            {
                _EntityProperty = value;
            }
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
        public IndCatDatePicker()
            : base()
        {
        }
        #endregion Constructors

        #region Public Methods
        /// <summary>
        /// Sets the value of this control
        /// </summary>
        /// <param name="val"></param>
        public void SetValue(object val)
        {
            try
            {
                this.SelectedDate = (val == null) ? DateTime.MinValue : (DateTime)val;
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

        /// <summary>
        /// Gets the value of this control
        /// </summary>
        /// <returns></returns>
        public object GetValue()
        {
            try
            {
                return this.SelectedDate;
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
        /// Only valid for comboboxes
        /// </summary>
        /// <param name="attributes"></param>
        public void SetDataSource(object[] attributes)
        {
        }
        #endregion Public Methods
    }
}
