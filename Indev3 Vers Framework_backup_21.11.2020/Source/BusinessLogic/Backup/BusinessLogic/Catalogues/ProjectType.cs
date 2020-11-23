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
    /// Represents the ProjectType entity
    /// </summary>
    public class ProjectType : GenericEntity, IProjectType
    {
        #region IProjectType Members

        private string _Type;
        [PropertyValidation(true, 20)]
        [GridColumnProperty("Type")]
        public string Type
        {
            get { return _Type; }
            set { _Type = value; }
        }

        private int _Rank;
        [GridColumnProperty("Rank")]
        [ReferenceMapping(typeof(ProjectType))]
        [PropertyValidation(true, 5)]
        [SortBy()]
        public int Rank
        {
            get { return _Rank; }
            set { _Rank = value; }
        }      
        #endregion

        #region Constructors
        public ProjectType()
            : this(null)
        {

        }
        public ProjectType(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBProjectType(connectionManager));
        }

        public ProjectType(DataRow row, object connectionManager)
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
            this.Type = row["Type"].ToString();
            this.Rank = int.Parse(row["Rank"].ToString());
        }
    }
}
