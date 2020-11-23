using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the Program entity
    /// </summary>
    public class Program : GenericEntity, IProgram
    {
        #region IProgram Members

        private int _IdOwner;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(Owner))]
        [DesignerName("Owner Name")]
        public int IdOwner
        {
            get
            {
                return _IdOwner;
            }
            set
            {
                _IdOwner = value;
            }
        }
        private string _OwnerName;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Owner Name")]
        public string OwnerName
        {
            get
            {
                return _OwnerName;
            }
            set
            {
                _OwnerName = value;
            }
        }
        private int _IdOwnerType;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(OwnerType))]
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
        private string _OwnerType;
        [PropertyValidation(true, 50)]
        [GridColumnProperty("Organization")]
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
        private bool _IsActive;
        [PropertyValidation(true)]
        [GridColumnProperty("Active")]
        public bool IsActive
        {
            get
            {
                return _IsActive;
            }
            set
            {
                _IsActive = value;
            }
        }
        private string _Name;
        [PropertyValidation(true, 50)]
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

        private bool _OnlyActive = false;
        public bool OnlyActive
        {
            get { return _OnlyActive; }
            set { _OnlyActive = value; }
        }

        private int _Rank;
        [GridColumnProperty("Rank")]
        [ReferenceMapping(typeof(Program))]
        [PropertyValidation(true, 7)]
        [SortBy()]
        public int Rank
        {
            get { return _Rank; }
            set { _Rank = value; }
        }      

        #endregion

        #region Constructors
        public Program()
            : this(null)
        {

        }
        public Program(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBProgram(connectionManager));
            _IdOwner = ApplicationConstants.INT_NULL_VALUE;
            _IdOwnerType = ApplicationConstants.INT_NULL_VALUE;
            _IsActive = true;
        }

        public Program(DataRow row, object connectionManager)
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

        #region Protected Methods

        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this.IdOwner = (int)row["IdOwner"];
            this.OwnerName = row["OwnerName"].ToString();
            this.IdOwnerType = (int)row["IdOwnerType"];
            this.OwnerType = row["OwnerType"].ToString();
            this.IsActive = (bool)row["IsActive"];
            this.Name = row["Name"].ToString();
            this.Code = row["Code"].ToString();
            this.Rank = int.Parse(row["Rank"].ToString());
        }
        protected override DataSet PostGetEntities(DataSet ds)
        {
            DSUtils.ReplaceBooleanColumn("IsActive", ds, 0);
            return ds;
        }
        #endregion Protected Methods
    }
}
