using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the ProjectPhase entity
    /// </summary>
    public class ProjectPhase : GenericEntity, IProjectPhase
    {
        #region IProjectPhase Members
        private string _Code;
        [PropertyValidation(true, 3)]
        [GridColumnProperty("Code")]
        public string Code
        {
            get { return _Code; }
            set { _Code = value; }
        }

        private string _Name;
        [PropertyValidation(true, 50)]
        [GridColumnProperty("Name")]
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        #endregion

        #region Constructors
        public ProjectPhase()
            : this(null)
        {

        }
        public ProjectPhase(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBProjectPhase(connectionManager));
        }

        public ProjectPhase(DataRow row, object connectionManager)
            : this(connectionManager)
        {
            try
            {
                Row2Object(row);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion

        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this.Code = row["Code"].ToString();
            this.Name = row["Name"].ToString();
        }
    }
}
