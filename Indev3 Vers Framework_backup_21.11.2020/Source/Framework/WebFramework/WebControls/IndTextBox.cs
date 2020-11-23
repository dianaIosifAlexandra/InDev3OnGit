using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// The TextBox that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.TextBox))]
    [ToolboxData("<{0}:IndTextBox runat=\"server\"></{0}:IndTextBox>")]
    public class IndTextBox : TextBox
    {
        #region Properties

        private bool _AlphaNumericCheck = false;
        /// <summary>
        /// Will let only alphanumeric characters to be introduced
        /// </summary>
        [DefaultValue(false)]
        [Category("Extension")]
        public bool AlphaNumericCheck
        {
            get { return _AlphaNumericCheck; }
            set { _AlphaNumericCheck = value; }
        }

        private bool _AutoReplaceBlank = false;
        /// <summary>
        /// Removes all blanks from the Text property of the TextBox
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
        public IndTextBox()
        {
            this.CssClass = CSSStrings.TextBoxCssClass;
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructor

        #region Overrides
        public override string Text
        {
            get
            {
                return base.Text.Trim();
            }
            set
            {
                base.Text = value;
            }
        }

        protected override void OnPreRender(System.EventArgs e)
        {
            try
            {
                if (this.Enabled == false || this.ReadOnly == true)
                {
                    this.CssClass = CSSStrings.TextBoxCssClass + "Disabled";
                }

                if (_AutoReplaceBlank)
                    this.Text = this.Text.Replace(" ", "&nbsp;");

                if (_FocusOnLoad)
                {
                    //this.Focus();
                    string focusScript = "<script type='text/javascript'>";
                    focusScript += "try{";
                    focusScript += string.Format("document.forms[0].{0}.focus();", this.ClientID);
                    focusScript += string.Format("document.forms[0].{0}.select();", this.ClientID);
                    focusScript += "}catch(ex){}";
                    focusScript += "</script>";
                    this.Page.ClientScript.RegisterStartupScript(this.GetType(), "SET_FOCUS_SCRIPT", focusScript);
                }
                if (_CheckDirty)
                {
                    this.Attributes.Add("onchange", "SetDirty(1);");
                    this.Attributes.Add("onkeypress", "SetDirty(1);");
                }
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
        #endregion Overrides
    }
}
