using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.Entities;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the Currency entity
    /// </summary>
    public class Currency : GenericEntity, ICurrency
    {
        #region ICurrency Members
        private string _Code;
        [PropertyValidation(true, 3)]
        public string Code
        {
            get { return _Code; }
            set { _Code = value; }
        }

        private string _Name;
        [PropertyValidation(true, 30)]
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        #endregion

        #region Constructors
        public Currency()
            : this(null)
        {
        }
        public Currency(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBCurrency(connectionManager));
        }

        public Currency(DataRow row, object connectionManager)
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

        public DataSet GetForDisplayPages()
        {
            try
            {
                IGenericEntity newEntity = EntityFactory.GetEntityInstance(this.GetType(), this.CurrentConnectionManager);
                return PostGetEntities(((DBCurrency)this.GetEntity()).SelectObjectForDisplay(newEntity));
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }

        }
    }
}
