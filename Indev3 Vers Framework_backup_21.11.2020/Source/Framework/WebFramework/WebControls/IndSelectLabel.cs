using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.ComponentModel;
using System.Drawing;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// The LAbel control that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.Label))]
    [ToolboxData("<{0}:IndSelectLabel runat=\"server\"></{0}:IndSelectLabel>")]
    public class IndSelectLabel : CompositeControl, INamingContainer
    {
        #region Members

        private Label lblData;
        private Button btnPopUp;
        /// <summary>
        /// The text of the label
        /// </summary>
        [DefaultValue("")]
        [Category("Extension")]
        public string LabelText
        {
            get { return lblData.Text; }
            set { lblData.Text = value; }
        }
        private string _PopUpName;
        /// <summary>
        /// The name of the aspx window that will popup when clicking the button
        /// </summary>
        [DefaultValue("")]
        [Category("Extension")]
        public string PopUpName
        {
            get { return _PopUpName; }
            set { _PopUpName = value; }
        }

        private int _PopUpWidth;
        [DefaultValue(0)]
        [Category("Extension")]
        /// <summary>
        /// The width of the aspx window that will popup when clicking the button
        /// </summary>
        public int PopUpWidth
        {
            get { return _PopUpWidth; }
            set { _PopUpWidth = value; }
        }

        private int _PopUpHeight;
        [DefaultValue(0)]
        [Category("Extension")]
        /// <summary>
        /// The height of the aspx window that will popup when clicking the button
        /// </summary>
        public int PopUpHeight
        {
            get { return _PopUpHeight; }
            set { _PopUpHeight = value; }
        }

        internal ControlHierarchyManager ControlHierarchyManager;
        #endregion Members

        #region Constructors

        public IndSelectLabel()
        {
            lblData = new Label();
            btnPopUp = new Button();
            btnPopUp.Text = "...";
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
        #endregion Constructors

        #region Overriden Methods

        protected override void OnInit(EventArgs e)
        {
            try
            {
                if (String.IsNullOrEmpty(_PopUpName))
                {
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_MUST_SET_POPUPNAME_FOR_CONTROL, this.UniqueID));
                }
                if (_PopUpWidth == 0)
                {
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_MUST_SET_POPUPWIDTH_FOR_CONTROL, this.UniqueID));
                }
                if (_PopUpHeight == 0)
                {
                    throw new IndException(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_MUST_SET_POPUPHEIGHT_FOR_CONTROL, this.UniqueID));
                }
                btnPopUp.Attributes.Add("onclick", "");
                base.OnInit(e);
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

        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                lblData.CssClass = CSSStrings.LabelCssClass;
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

        protected override void CreateChildControls()
        {
            try
            {
                this.Controls.Clear();
                this.Controls.Add(lblData);
                this.Controls.Add(btnPopUp);
                base.CreateChildControls();
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
        #endregion Overriden Methods
    }
}
