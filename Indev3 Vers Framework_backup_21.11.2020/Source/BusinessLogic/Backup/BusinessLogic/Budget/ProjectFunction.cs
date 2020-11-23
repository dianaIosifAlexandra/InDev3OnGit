using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess.Budget;


namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class ProjectFunction : GenericEntity, IProjectFunction 
    {
        #region IProjectFunction Members
        /// <summary>
        /// The name of the project function
        /// </summary>
        private string _Name;
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        #endregion IProjectFunction Members

        #region Constructors

        /// <summary>
        /// Default constructors. Sets the default values of numeric properties
        /// </summary>
        public ProjectFunction(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBProjectFunction(connectionManager));
        }
        #endregion Constructors
    }
}
