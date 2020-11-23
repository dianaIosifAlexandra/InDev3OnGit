using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.WebFramework.WebControls.Budget
{
    /// <summary>
    /// Label used to display var columns in the reforecast budget with thousand separators.
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.Label))]
    [ToolboxData("<{0}:IndFormatedLabel runat=\"server\"></{0}:IndFormatedLabel>")]
    public class IndReforecastBudgetVarLabel : Label
    {
        private string _Text;
        public override string Text
        {
            get
            {
                return _Text;
            }
            set
            {
                try
                {
                    ConversionUtils conversionUtils = new ConversionUtils();
                    _Text = conversionUtils.FormatString(value, false);
                    base.Text = _Text;
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
        internal ControlHierarchyManager ControlHierarchyManager;

        public IndReforecastBudgetVarLabel()
        {
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
    }
}
