using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Diagnostics;
using System.Web.UI.WebControls;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Reflection;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{

    [DefaultProperty("ID")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.DropDownList))]
    [ToolboxData("<{0}:IndComboBox runat=\"server\"></{0}:IndComboBox>")]
    public class IndComboBox : Telerik.Web.UI.RadComboBox
    {
        
        #region Constants
        private const int EXPAND_ARROW_WIDTH = 11;
        #endregion Constants
        #region Properties
        internal ControlHierarchyManager ControlHierarchyManager;

        protected bool _FocusOnLoad;
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

        #endregion Properties

        public IndComboBox()
        {
            CssClass = CSSStrings.ComboBoxCssClass;
            this.MarkFirstMatch = true;
            //this.sK = "~/Skins/ComboBox";
            this.Skin = "Default";
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }

        public override object DataSource
        {
            get
            {
                return ViewState["DataSource"] ;
            }
            set
            {
                ViewState["DataSource"] = value;
                base.DataSource = value;
            }
        }


        protected override void OnLoad(EventArgs e)
        {
            try
            {
                base.OnLoad(e);
                if (!Page.ClientScript.IsStartupScriptRegistered("FixCombo_" + this.ClientID))
                    Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "FixCombo_" + this.ClientID, "try {FixCombo(" + this.ClientID + ");}catch(err){}", true);

                //string scriptText = "var prototype = RadComboBox.prototype;" + Environment.NewLine +
                //                    "var set_text = prototype.SetText;"  + Environment.NewLine +
                //                    "var propertyChange = prototype.OnInputPropertyChange;" + Environment.NewLine +
                //                    "prototype.SetText = function (value) {" + Environment.NewLine +
                //                    "   this._skipEvent = 0;" + Environment.NewLine +
                //                    "   set_text.call(this, value);" + Environment.NewLine +
                //                    "};" + Environment.NewLine +
                //                    "prototype.OnInputPropertyChange = function () {" + Environment.NewLine +
                //                    "   if (!event.propertyName)" + Environment.NewLine +
                //                    "       event = event.rawEvent;" + Environment.NewLine +
                //                    "       if (event.propertyName == \"value\") {" + Environment.NewLine +
                //                    "          this._skipEvent++;" + Environment.NewLine +
                //                    "           if (this._skipEvent == 2)" + Environment.NewLine +
                //                    "               return;" + Environment.NewLine +
                //                    "           propertyChange.call(this);" + Environment.NewLine +
                //                    "       }" + Environment.NewLine +
                //                    "};";
                //if (!Page.ClientScript.IsStartupScriptRegistered(this.Page.GetType(), "FixComboTelerik"))
                //    Page.ClientScript.RegisterStartupScript(this.Page.GetType(),"FixComboTelerik", scriptText, true);
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


        #region utility methods
        /// <summary>
        /// This method will return the selected row from the datatable behind the combo
        /// </summary>
        /// <returns>DataRow field filled with data</returns>
        public DataRow GetComboSelection()
        {
            try
            {
                //If selected index is negative, return
                if (this.SelectedIndex < 0)
                    return null;

                DataTable tbl = ((DataSet)this.DataSource).Tables[0];
                DataRow row = tbl.Rows[this.SelectedIndex];

                return row;
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
        #endregion

        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                //Set the maximum height of the combobox
                if (Items.Count > ComboBoxUtils.VisibleItemCount)
                    Height = ComboBoxUtils.ComboHeight;
                else
                    Height = Unit.Empty;
                if (_CheckDirty)
                {
                    OnClientSelectedIndexChanged = "RadComboBoxSetDirty";
                }
                //When the combo is expanded, it will never have a greater width than its width when it was not expanded (horizontal scrollbars
                //will appear if long names cannot be displayed). Solves a lot of issues, with long names, especially in pop-up windows
                //when scrollbars appear.
                DropDownWidth = Unit.Pixel((int)Width.Value - EXPAND_ARROW_WIDTH);
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

        public bool IsEmptyValueSelected()
        {
            if (String.IsNullOrEmpty (this.SelectedValue))
                return true;


            if (this.SelectedValue == ApplicationConstants.INT_NULL_VALUE.ToString())
                return true;

            return false;
        }

        public void SelectEmptyValue()
        {
            this.SetValue(ApplicationConstants.INT_NULL_VALUE);           
        }

        public void SetValue(object val)
        {
            try
            {
                int i = ApplicationConstants.INT_NULL_VALUE;
                int.TryParse(val.ToString(), out i);

                if (i <= 0)
                {
                    this.SelectedIndex = 0;
                }
                else
                {
                    this.SelectedValue = val.ToString();
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
                //watch dog agains a telerik selection bug that returns "" when selecting nothing
                if (String.IsNullOrEmpty(this.SelectedValue))
                    return ApplicationConstants.INT_NULL_VALUE;

                return int.Parse(this.SelectedValue);
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
    }
}
