using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.Entities;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the Associate entity
    /// </summary>
    public class Associate : GenericEntity, IAssociate
    {
        #region IAssociate Members
        private int _IdCountry;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(InergyCountry))]
        [IsInLogicalKey()]
        [DesignerName("Country")]
        public int IdCountry
        {
            get
            {
                return _IdCountry;
            }
            set
            {
                _IdCountry = value;
            }
        }
        private int _IdCurrentAssociate;

        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(Associate))]
        public int IdCurrentAssociate
        {
            get { return _IdCurrentAssociate; }
            set { _IdCurrentAssociate = value; }
        }

        private string _CountryName;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Country")]
        public string CountryName
        {
            get
            {
                return _CountryName;
            }
            set
            {
                _CountryName = value;
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
        private string _EmployeeNumber;

        [PropertyValidation(true, 15)]
        [GridColumnProperty("Employee Number")]
        [DesignerName("Employee Number")]
        public string EmployeeNumber
        {
            get
            {
                return _EmployeeNumber;
            }
            set
            {
                _EmployeeNumber = value;
            }
        }
        private string _InergyLogin;
        [PropertyValidation(true, 50)]
        [GridColumnProperty("Inergy Login")]
        [DesignerName("Inergy Login")]
        public string InergyLogin
        {
            get
            {
                return _InergyLogin;
            }
            set
            {
                _InergyLogin = value;
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
        private bool _IsSubContractor;
        [PropertyValidation(true)]
        [GridColumnProperty("Subcont.")]
        public bool IsSubContractor
        {
            get
            {
                return _IsSubContractor;
            }
            set
            {
                _IsSubContractor = value;
            }
        }
        private int _PercentageFullTime;
        [PropertyValidation(true, 0, 100)]
        [GridColumnProperty("FTE")]
        [DesignerName("Full Time")]
        public int PercentageFullTime
        {
            get
            {
                return _PercentageFullTime;
            }
            set
            {
                _PercentageFullTime = value;
            }
        }

        #endregion

        #region Constructors
        public Associate()
            : this(null)
        {
        }
        public Associate(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBAssociate(connectionManager));
            _IdCountry = ApplicationConstants.INT_NULL_VALUE;
            _IdCurrentAssociate = ApplicationConstants.INT_NULL_VALUE;
            _PercentageFullTime = ApplicationConstants.INT_NULL_VALUE;
            _IsActive = true;
        }

        public Associate(DataRow row, object connectionManager)
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

        #region Public Methods
        public DataSet SelectActiveAssociates()
        {
            DataSet dsActiveAssociates;
            try
            {
                dsActiveAssociates = this.GetEntity().GetCustomDataSet("SelectActiveAssociates", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dsActiveAssociates;
        }

        public bool HasCurrentData()
        {
            object result = null;
            try
            {
                result = this.GetEntity().ExecuteScalar("bgtAssociateHasCurrentData", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return result != null && result.ToString() == "1" ? true : false;
        }
        #endregion Public Methods

        #region Overrides

        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this.IdCountry = (int)row["IdCountry"];
            this.CountryName = row["CountryName"].ToString();
            this.EmployeeNumber = row["EmployeeNumber"].ToString();
            this.Name = row["Name"].ToString();
            this.InergyLogin = row["InergyLogin"].ToString();

            //HACK : This code is unsafe and needs to be fixed(if IsActive = "Car" it will be false, and if it is 
            //not string, but is Dataset for example, it will be cast to bool
            if (row["IsActive"].GetType() == typeof(string))
            {
                this.IsActive = (row["IsActive"].ToString() == "Yes") ? true : false;
            }
            else
            {
                this.IsActive = (bool)row["IsActive"];
            }
            if (row["IsSubContractor"].GetType() == typeof(string))
            {
                this.IsSubContractor = (row["IsSubContractor"].ToString() == "Yes") ? true : false;
            }
            else
            {
                this.IsSubContractor = (bool)row["IsSubContractor"];
            }
            this.PercentageFullTime = (int)row["PercentageFullTime"];
        }
        protected override DataSet PostGetEntities(DataSet ds)
        {
            DSUtils.ReplaceBooleanColumn("IsActive", ds, 0);
            DSUtils.ReplaceBooleanColumn("IsSubContractor", ds, 0);
            return ds;
        }
        public override void FillEditParameters(Dictionary<string, object> editParameters)
        {
            try
            {
                base.FillEditParameters(editParameters);
                if (editParameters.ContainsKey("IdCountry"))
                {
                    this._IdCountry = int.Parse(editParameters["IdCountry"].ToString());
                }
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        protected override void OnPreSave()
        {
            //Check if logged user try to delete himself
            if (this.Id == this.IdCurrentAssociate &&
                this.State == EntityState.Deleted)
            {
                throw new IndException(ApplicationMessages.EXCEPTION_SELF_DELETION);
            }
        }
        #endregion Overrides
    }
}