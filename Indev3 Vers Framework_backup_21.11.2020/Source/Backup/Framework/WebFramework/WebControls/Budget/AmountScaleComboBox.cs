using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Diagnostics;
using System.Web.UI.WebControls;
using Telerik.WebControls;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Reflection;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Common;
using Inergy.Indev3.BusinessLogic.Authorization;
using System.Threading;

namespace Inergy.Indev3.WebFramework.WebControls.Budget
{
    /// <summary>
    /// Class used in all budget screens for selecting amount scale options
    /// </summary>
    [DefaultProperty("ID")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.DropDownList))]
    [ToolboxData("<{0}:IndAmountScaleComboBox runat=\"server\"></{0}:IndAmountScaleComboBox>")]
    public class IndAmountScaleComboBox : RadComboBox
    {
        #region Members

        internal ControlHierarchyManager ControlHierarchyManager;
       
        #endregion Members
        #region Constructors
        public IndAmountScaleComboBox()
        {
            this.SkinsPath = "~/Skins/ComboBox";
            this.Skin = "Default";
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructors

        #region Event handlers
        protected override void OnLoad(EventArgs e)
        {
            try
            {
                //HACK: Fix for issue 0027007 which appeared only for ajax callbacks. Wait 120 miliseconds
                //because the FixUp function from the RadComboBox.js file waits for 100 ms before calling
                //the fixup method with setTimeout
                if (IsCallBack || Page.Request.Params["RadAJAXControlID"] != null)
                {
                    Thread.Sleep(120);
                }

                base.OnLoad(e);

                if (!Page.IsPostBack)
                {
                    RadComboBoxItem newItem = new RadComboBoxItem(AmountScaleOption.Unit.ToString(), "Unit");
                    this.Items.Add(newItem);
                    newItem = new RadComboBoxItem(AmountScaleOption.Thousands.ToString(), "Thousands");
                    this.Items.Add(newItem);
                    newItem = new RadComboBoxItem(AmountScaleOption.Millions.ToString(), "Millions");
                    this.Items.Add(newItem);
                }
                this.DataBind();
                if (!Page.ClientScript.IsStartupScriptRegistered("FixCombo_" + this.ClientID))
                    Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "FixCombo_" + this.ClientID, "try{FixCombo(" + this.ClientID + ")}catch(err){}", true);
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

        #endregion Event handlers


    }
}
