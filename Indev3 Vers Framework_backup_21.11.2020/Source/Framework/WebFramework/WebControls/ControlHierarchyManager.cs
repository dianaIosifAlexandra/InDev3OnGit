using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Web.UI;
using System.Diagnostics;

namespace Inergy.Indev3.WebFramework.WebControls
{
    internal class ControlHierarchyManager
    {
        #region Members
        private Control Owner;
        #endregion Members

        #region Constructors
        internal ControlHierarchyManager(Control owner)
        {
            Owner = owner;
        }
        #endregion Constructors

        internal void ReportError(IndException ex)
        {
            Control errorHandlerControl = GetErrorHandlerControl();
            if (errorHandlerControl is IndBaseControl)
            {
                ((IndBaseControl)errorHandlerControl).ReportControlError(ex);
                return;
            }
            if (errorHandlerControl is IndBasePage)
            {
                ((IndBasePage)errorHandlerControl).ShowError(ex);
                return;
            }
        }

        private Control GetErrorHandlerControl()
        {
            Control errorHandlerControl = Owner.Parent;
            Debug.Assert(errorHandlerControl != null, "Parent Control of " + Owner.GetType() + " cannot be null.");
            while (!(errorHandlerControl is IndBaseControl) && !(errorHandlerControl is IndBasePage))
            {
                errorHandlerControl = errorHandlerControl.Parent;
                Debug.Assert(errorHandlerControl != null, "Parent Control of " + Owner + " cannot be null.");
            }
            return errorHandlerControl;
        }
    }
}
