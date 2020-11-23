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
    /// Represents the Owner entity
    /// </summary>
    public class Owner : GenericEntity, IOwner
    {
        #region IOwner Members

        private int _IdOwnerType;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(OwnerType))]
        [DesignerName("Owner Type")]
        public int IdOwnerType
        {
            get
            {
                return _IdOwnerType;
            }
            set
            {
                _IdOwnerType = value;
            }
        }
        private string _Code;
        [PropertyValidation(true, 10)]
        [GridColumnProperty("Code")]
        public string Code
        {
            get
            {
                return _Code;
            }
            set
            {
                _Code = value;
            }
        }
        private string _Name;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Name")]
        public string Name
        {
            get
            {
                return _Name;
            }
            set
            {
                _Name = value;
            }
        }

        private string _OwnerType;
        [PropertyValidation(true, 50)]
        [GridColumnProperty("Owner Type")]
        public string OwnerType
        {
            get
            {
                return _OwnerType;
            }
            set
            {
                _OwnerType = value;
            }
        }

        private int _Rank;
        [GridColumnProperty("Rank")]
        [ReferenceMapping(typeof(Owner))]
        [PropertyValidation(true, 5)]
        [SortBy()]
        public int Rank
        {
            get { return _Rank; }
            set { _Rank = value; }
        }

        #endregion

        #region Constructors
        public Owner()
            : this(null)
        {

        }
        public Owner(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBOwner(connectionManager));
            _IdOwnerType = ApplicationConstants.INT_NULL_VALUE;
        }

        public Owner(DataRow row, object connectionManager)
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
            this.IdOwnerType = (int)row["IdOwnerType"];
            this.OwnerType = row["OwnerType"].ToString();
            this.Code = row["Code"].ToString();
            this.Name = row["Name"].ToString();
            this.Rank = int.Parse(row["Rank"].ToString());
        }
    }
}
