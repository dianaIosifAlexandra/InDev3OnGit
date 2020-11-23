using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Security.Principal;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Web.UI.WebControls;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// The LastUserLabel that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.Label))]
    [ToolboxData("<{0}:IndCatLastUserLabel runat=\"server\"></{0}:IndCatLastUserLabel>")]
    public class IndCatLastUserLabel : Label, IGenericCatWebControl
    {
        #region Properties
        private bool _AutoReplaceBlank = false;
        /// <summary>
        /// Removes all blanks from the Text property of the LastUserLabel
        /// </summary>
        [DefaultValue(false)]
        [Category("Extension")]
        public bool AutoReplaceBlank
        {
            get { return _AutoReplaceBlank; }
            set { _AutoReplaceBlank = value; }
        }

        private bool _FocusOnLoad = false;
        /// <summary>
        /// If it is set to Yes, the textbox will be focused when opening the screen
        /// </summary>
        [DefaultValue("false")]
        [Category("Extension")]
        public bool FocusOnLoad
        {
            get { return _FocusOnLoad; }
            set { _FocusOnLoad = value; }
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
        internal ControlHierarchyManager ControlHierarchyManager;
        #endregion Properties

        #region Constructor
        public IndCatLastUserLabel()
        {
            this.CssClass = CSSStrings.LabelCssClass;
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructor

        #region Overrides
        public void SetValue(object val)
        {
            try
            {
                this.Text = Page.User.Identity.Name;
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
                return this.Text;
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
        #endregion Overrides
    }
}
