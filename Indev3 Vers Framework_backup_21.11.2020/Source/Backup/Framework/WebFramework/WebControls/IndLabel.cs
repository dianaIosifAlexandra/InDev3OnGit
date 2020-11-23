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
    /// The LAbel control that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.Label))]
    [ToolboxData("<{0}:IndLabel runat=\"server\"></{0}:IndLabel>")]
    public class IndLabel : Label
    {
        #region Properties
        private bool _FocusOnLoad;
        [DefaultValue(false)]
        [Category("Extension")]
        public bool FocusOnLoad
        {
            get
            {
                return _FocusOnLoad;
            }
            set
            {
                _FocusOnLoad = value;
            }
        }
        internal ControlHierarchyManager ControlHierarchyManager;
        #endregion Properties

        #region Constructor
        public IndLabel()
        {
            this.CssClass = CSSStrings.LabelCssClass;
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructor

        #region Overrides
        protected override void OnPreRender(System.EventArgs e)
        {
            try
            {
                if (this.Enabled == false)
                {
                    this.CssClass = CSSStrings.LabelCssClass + "Disabled";
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
