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
    /// Represents the CostIncomeType entity
    /// </summary>
    public class CostIncomeType : GenericEntity, ICostIncomeType
    {
        #region ICostIncomeType Members

        private string _Name;
        [PropertyValidation(true, 50)]
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        private string _DefaultAccount;
        public string DefaultAccount
        {
            get { return _DefaultAccount; }
            set { _DefaultAccount = value; }
        }
        #endregion

        #region Constructors
        public CostIncomeType()
            : this(null)
        {
        }
        public CostIncomeType(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBCostIncomeType(connectionManager));
        }

        public CostIncomeType(DataRow row, object connectionManager)
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
            this.DefaultAccount = row["DefaultAccount"].ToString();
        }
    }
}
