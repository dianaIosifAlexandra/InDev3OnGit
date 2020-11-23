using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// Summary description for EBTCheckBox.
    /// </summary>
    [DefaultProperty("Checked")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.CheckBox))]
    [ToolboxData("<{0}:IndCatCheckBox runat=\"server\"></{0}:IndCatCheckBox>")]
    public class IndCatCheckBox : IndCheckBox, IGenericCatWebControl
    {
        #region Members
        public string _EnitityProperty;
        [DefaultValue("")]
        [Category("Extension")]
        public string EntityProperty
        {
            get { return _EnitityProperty; }
            set { _EnitityProperty = value; }
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
        public IndCatCheckBox()
            : base()
        {
        }
        #endregion Constructors

        #region Public Methods
        public void SetValue(object val)
        {
            try
            {
                this.Checked = (bool)val;
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
                return this.Checked;
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
        public void SetDataSource(object[] attributes)
        {
        }
        #endregion Public Methods
    }
}
