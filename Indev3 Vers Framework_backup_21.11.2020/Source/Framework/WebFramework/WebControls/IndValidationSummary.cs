using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Web.UI;

namespace Inergy.Indev3.WebFramework.WebControls
{
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.TextBox))]
    [ToolboxData("<{0}:IndValidationSummary runat=\"server\"></{0}:IndValidationSummary>")]
    public class IndValidationSummary : ValidationSummary
    {
        internal ControlHierarchyManager ControlHierarchyManager;

        public IndValidationSummary()
        {
            this.CssClass = "IndValidationSummary";
            this.ForeColor = Color.Yellow;
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
    }
}
