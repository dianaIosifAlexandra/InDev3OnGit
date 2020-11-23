using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// Summary description for EBTCheckBox.
    /// </summary>
    [DefaultProperty("Checked")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.CheckBox))]
    [ToolboxData("<{0}:IndCheckBox runat=\"server\"></{0}:IndCheckBox>")]

    public class IndCheckBox : CheckBox
    {
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
        
        public IndCheckBox()
        {
            CssClass = CSSStrings.CheckBoxCssClass;
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                if (_CheckDirty)
                {
                    this.Attributes.Add("onclick", "SetDirty(1)");
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
    }
}
