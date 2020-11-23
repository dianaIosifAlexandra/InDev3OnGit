using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Diagnostics;
using System.Web.UI.WebControls;

namespace Inergy.Indev3.WebFramework.WebControls
{
    public abstract class IndBaseControl : UserControl
    {
        protected internal IndBasePage ParentPage
        {
            get
            {
                Debug.Assert(Page != null, "All host pages for basecontrol  must not be null.");
                Debug.Assert(Page is IndBasePage, "All host pages of the IndBaseControls must be of type IndBasePage. Now is: " + this.Page.GetType().ToString() + "!");

                return (IndBasePage)this.Page;
            }
        }

        protected internal void ReportControlError(IndException ex)
        {
            ParentPage.ShowError(ex);
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (ParentPage.PageResponseShouldTerminate == false)
                base.Render(writer);
        }
    }
}
