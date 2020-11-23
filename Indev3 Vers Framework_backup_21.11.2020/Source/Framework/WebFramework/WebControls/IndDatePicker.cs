using System;
using System.Collections.Generic;
using System.Text;
using Telerik.WebControls;
using System.Drawing;
using System.Web.UI;
using System.ComponentModel;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// DatePicker used by the application
    /// </summary>
    [DefaultProperty("ID")]
    [ToolboxBitmap(typeof(Calendar))]
    [ToolboxData("<{0}:IndDatePicker runat=\"server\"></{0}:IndDatePicker>")]
    public class IndDatePicker : RadDatePicker
    {
        internal ControlHierarchyManager ControlHierarchyManager;
        #region IGenericWebControl Members
        
        public IndDatePicker()
        {
            CssClass = CSSStrings.DatePickerCssClass; 
            this.Calendar.Skin = "NewDefault";
            this.Calendar.SkinsPath = "~/Skins/Calendar";
            this.DateInput.Skin = "NewDefault";
            this.DateInput.SkinsPath = "~/Skins/Calendar";
            this.DateInput.CssClass = "NewDefault";
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        public override void ConfigureDateInput()
        {
            try
            {
                base.ConfigureDateInput();
                this.DateInput.DateFormat = "dd/MM/yyyy";
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
        #endregion
    }
}
