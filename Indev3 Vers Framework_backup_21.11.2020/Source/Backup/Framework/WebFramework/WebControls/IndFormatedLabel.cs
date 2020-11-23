using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// The LAbel control that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.Label))]
    [ToolboxData("<{0}:IndFormatedLabel runat=\"server\"></{0}:IndFormatedLabel>")]
    public class IndFormatedLabel : Label
    {
        internal ControlHierarchyManager ControlHierarchyManager;

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
                    _Text = conversionUtils.FormatString(value);
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
        public IndFormatedLabel()
        {
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        
    }
}
