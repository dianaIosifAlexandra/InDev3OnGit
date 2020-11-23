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
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.ImageButton))]
    [ToolboxData("<{0}:IndImageButton runat=\"server\"></{0}:IndImageButton>")]
    public class IndImageButton : ImageButton
    {
        #region Properties
        private string _ImageUrlOver = String.Empty;
        [DefaultValue("")]
        [Category("Extension")]
        [Browsable(true)]
        public string ImageUrlOver
        {
            get { return _ImageUrlOver; }
            set { _ImageUrlOver = value; }
        }
        internal ControlHierarchyManager ControlHierarchyManager;

        #endregion Properties

        public IndImageButton()
        {
            this.CssClass = CSSStrings.ImageButtonCssClass;
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }

        protected override void CreateChildControls()
        {
            try
            {
                base.CreateChildControls();
                this.Attributes.Add("onmouseover", "document.getElementById('" + this.ClientID + "').src = '" + ResolveUrl(this.ImageUrlOver) + "';");
                this.Attributes.Add("onmouseout", "document.getElementById('" + this.ClientID + "').src = '" + ResolveUrl(this.ImageUrl) + "';");
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
