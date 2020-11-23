using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.WebFramework.WebControls;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.Entities;

namespace Inergy.Indev3.WebFramework.GenericControls
{
    /// <summary>
    /// Base class for the ascx controls representing catalogs
    /// </summary>
    public abstract class GenericUserControl : IndBaseControl
    {
        #region Members
        public IGenericEntity Entity;
        private string _ModuleCode;
        /// <summary>
        /// The code of the module associated with this user controls (for authorization)
        /// </summary>
        public string ModuleCode
        {
            get { return _ModuleCode; }
            set { _ModuleCode = value; }
        }
        protected virtual void ApplyPermissions()
        {
        }

        public virtual void SetViewEntityProperties(IGenericEntity entity)
        {
        }
        /// <summary>
        /// Sets additional properties to the entity that can only be populated only on this control
        /// (for example Page properties)
        /// </summary>
        /// <param name="entity">The entity that will be modified</param>
        public virtual void SetAdditionalProperties(IGenericEntity entity)
        {
        }

        protected override void CreateChildControls()
        {
            try
            {
                base.CreateChildControls();
            }
            catch (IndException exc)
            {
                ReportControlError(exc);
                return;
            }
        }

        protected override void OnLoad(EventArgs e)
        {
            try
            {
                base.OnLoad(e);
                ApplyPermissions();
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            
        }

        #endregion Members
    }
}
