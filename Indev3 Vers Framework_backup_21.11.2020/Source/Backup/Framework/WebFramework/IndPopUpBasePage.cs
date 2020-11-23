using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Collections;
using System.Drawing;
using System.Web.UI;
using Telerik.WebControls;

namespace Inergy.Indev3.WebFramework    
{
    /// <summary>
    /// Base class for all pop-up windows
    /// </summary>
    public abstract class IndPopUpBasePage : IndBasePage
    {
        #region Members
        /// <summary>
        /// Errors panel
        /// </summary>
        private Panel _pnlErrors = null;
        internal override Panel pnlErrors
        {
            get 
            {
                return _pnlErrors;
            }
        }

        #endregion Members

        #region Constructors
        public IndPopUpBasePage()
        {
            _pnlErrors = new Panel();
        }
        #endregion Constructors

        #region Protected Methods
        protected override void OnInit(EventArgs e)
        {
            try
            {
                base.OnInit(e);

                _pnlErrors.ID = "pnlErrors";
                _pnlErrors.CssClass = "popupPanel";
                this.Page.Form.Controls.Add(_pnlErrors);//The panel must be added to Form property of the Page otherwise the panel is added after the </form> tag
            }
            catch (IndException ex)
            {
                ShowError(ex);
                return;
            }
        }

        /// <summary>
        /// Override the show error method in IndBasePage
        /// </summary>
        /// <param name="indExc"></param>
        protected internal override void ShowError(IndException indExc)
        {
            AddError(indExc.Message);
        }

        /// <summary>
        /// Override the show error method in IndBasePage
        /// </summary>
        /// <param name="indExc"></param>
        protected internal override void ShowError(ArrayList errors)
        {
            foreach (string error in errors)
            {
                AddError(error);
            }
        }

        #endregion Protected Methods

        #region Private Methods
        private void AddError(String errMessage)
        {
            Label lblError = new Label();

            lblError.ID = "lblError" + encryptingSupport.GetUniqueKey();
            lblError.Text = errMessage;
            lblError.CssClass = CSSStrings.ErrorLabelCssClass;

            _pnlErrors.Controls.Add(lblError);
            LiteralControl br = new LiteralControl("<BR>");
            _pnlErrors.Controls.Add(br);
        }
        #endregion Private Methods
    }
}
