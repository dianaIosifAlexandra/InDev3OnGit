using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Collections.Specialized;

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


        //http://forums.asp.net/t/1823287.aspx?ImageButtons+not+working+in+IE10
        //Arno Stalgik answer
        protected override bool LoadPostData(string postDataKey, NameValueCollection postCollection)
        {
            // Control coordinates are sent in decimal by IE10
            // Recreating the collection with corrected values
            NameValueCollection modifiedPostCollection = new NameValueCollection();
            for (int i = 0; i < postCollection.Count; i++)
            {
                string actualKey = postCollection.GetKey(i);
                string[] actualValueTab = postCollection.GetValues(i);
                if (actualKey.EndsWith(".x") || actualKey.EndsWith(".y"))
                {
                    string value = actualValueTab[0];
                    decimal dec;
                    Decimal.TryParse(value, out dec);
                    modifiedPostCollection.Add(actualKey, ((int)Math.Round(dec)).ToString());
                }
                else
                {
                    foreach (string actualValue in actualValueTab)
                    {
                        modifiedPostCollection.Add(actualKey, actualValue);
                    }
                }
            }
            return base.LoadPostData(postDataKey, modifiedPostCollection);
        }
    }
}
