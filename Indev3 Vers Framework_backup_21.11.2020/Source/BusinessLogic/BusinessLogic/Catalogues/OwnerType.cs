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
    /// Represents the OwnerType entity
    /// </summary>
    public class OwnerType : GenericEntity, IOwnerType
    {
        #region IOwnerType Members

        private string _Name;
        [PropertyValidation(true, 50)]
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        #endregion

        #region Constructors
        public OwnerType()
            : this(null)
        {

        }
        public OwnerType(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBOwnerType(connectionManager));
        }

        public OwnerType(DataRow row, object connectionManager)
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
            this.Name = row["Name"].ToString();
        }
    }
}
