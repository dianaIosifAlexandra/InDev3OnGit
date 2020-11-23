using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// The LAbel control that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.Label))]
    [ToolboxData("<{0}:IndYearMonthLabel runat=\"server\"></{0}:IndYearMonthLabel>")]
    public class IndYearMonthLabel : Label
    {
        #region Properties
        [DefaultValue(false)]
        [Category("Extension")]
        public string YearMonthText
        {
            get
            {
                return ApplicationUtils.StringToYearMonth(this.Text).ToString();
            }
            set
            {
                try
                {
                    int yearMonthValue = (value == String.Empty) ? ApplicationConstants.INT_NULL_VALUE : int.Parse(value);
                    string val = ApplicationUtils.YearMonthToString(yearMonthValue);
                    this.Text = val;
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
        #endregion Properties

        #region Constructor
        public IndYearMonthLabel()
        {
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructor

    }
}
