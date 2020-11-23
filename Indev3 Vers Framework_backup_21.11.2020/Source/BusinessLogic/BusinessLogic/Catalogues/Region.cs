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
    /// Represents the Region entity
    /// </summary>   
    public class Region : GenericEntity, IRegion
    {
        #region IRegion Members

        private string _Code;
        [PropertyValidation(true, 8)]
        [GridColumnProperty("Code")]
        public string Code
        {
            get { return _Code; }
            set { _Code = value; }
        }

        private string _Name;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Name")]
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        private int _Rank;
        [GridColumnProperty("Rank")]       
        [ReferenceMapping(typeof(Region))]
        [PropertyValidation(true,5)]
        [SortBy()]
        public int Rank
        {
            get { return _Rank; }
            set { _Rank = value; }
        }
        #endregion

        #region Constructors
        public Region()
            : this(null)
        {

        }
        public Region(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBRegion(connectionManager));
        }

        public Region(DataRow row, object connectionManager)
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
            this.Rank = int.Parse(row["Rank"].ToString());
        }
    }
}
