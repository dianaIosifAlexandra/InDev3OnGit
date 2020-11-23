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
    /// Represents the Department entity
    /// </summary>
    public class Department : GenericEntity, IDepartment
    {
        #region IDepartment Members

        private int _IdFunction;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(Function))]
        [DesignerName("Function Code")]
        public int IdFunction
        {
            get
            {
                return _IdFunction;
            }
            set
            {
                _IdFunction = value;
            }
        }
        private string _FunctionName;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Function Code")]
        public string FunctionName
        {
            get
            {
                return _FunctionName;
            }
            set
            {
                _FunctionName = value;
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

        private int _Rank;
        [GridColumnProperty("Rank")]
        [ReferenceMapping(typeof(Department))]
        [PropertyValidation(true, 5)]
        [SortBy()]
        public int Rank
        {
            get { return _Rank; }
            set { _Rank = value; }
        }      

        #endregion

        #region Constructors
        public Department()
            : this(null)
        {
        }
        public Department(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBDepartment(connectionManager));
            _IdFunction = ApplicationConstants.INT_NULL_VALUE; ;
        }

        public Department(DataRow row, object connectionManager)
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
            this.IdFunction = (int)row["IdFunction"];
            this.FunctionName = row["FunctionName"].ToString();
            this.Name = row["Name"].ToString();
            this.Rank = int.Parse(row["Rank"].ToString());
        }
    }
}
