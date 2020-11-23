using System;
using System.Collections.Generic;
using System.Text;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Authorization;
using System.Web.UI;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// Represents an item in the main menu
    /// </summary>
    public class IndMenuItem : RadMenuItem
    {
        #region Members
        private string _ModuleCode;
        /// <summary>
        /// The associated module code for this menu item
        /// </summary>
        public string ModuleCode
        {
            get { return _ModuleCode; }
            set { _ModuleCode = value; }
        }

        internal ControlHierarchyManager ControlHierarchyManager;
        #endregion Members

        public IndMenuItem()
        {
            ControlHierarchyManager = new ControlHierarchyManager(this);
        }
    }
}
