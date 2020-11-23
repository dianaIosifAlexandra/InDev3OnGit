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
    /// The LAbel control that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.Label))]
    [ToolboxData("<{0}:IndCatLabel runat=\"server\"></{0}:IndCatLabel>")]
    public class IndCatLabel : IndLabel, IGenericCatWebControl
    {
        #region Properties

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
        #endregion Properties

        #region Constructor
        public IndCatLabel():base()
        {
        }
        #endregion Constructor

        #region Public Methods

        public void SetValue(object val)
        {
            try
            {
				ViewState["MyObject_" + this.ID] = val;

                if (val is DateTime)
                {
                    if ((DateTime)val == DateTime.MinValue)
                    {
                        this.Text = String.Empty;
                    }
                    else
                    {
                        this.Text = ((DateTime)val).ToShortDateString();
                    }
                }
                else
                {
					if (val is bool)
					{
						this.Text = (bool)(val) ? "Yes" : "No";
					}
					else
					{
						this.Text = (val == null) ? String.Empty : val.ToString();
					}
                }
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
				if (ViewState["MyObject_" + this.ID] is bool)
				{
					return ((bool)(ViewState["MyObject_" + this.ID]) ? "True" : "False");
				}
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
        #endregion Public Methods
    }
}
