using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Inergy.Indev3.Entities
{
    public interface IGenericEntity
    {
        #region Memebers
        int Id
        {
            get;
            set;
        }

        EntityState State
        {
            get;
        }
        #endregion Memebers

        #region Methods

        void SetNew();
        void SetModified();
        void SetDeleted();
        int Save();
        int Save(bool useTransaction);
        void Save(List<IGenericEntity> entities);
        void CreateLogicalKeyColumn(DataTable tbl);
        DataSet GetAll();
        DataSet GetAll(bool useCurrentObject);
        void SetSqlConnection(object connectionManager);
        void FillEditParameters(Dictionary<string, object> editParameters);
        DataRow SelectEntity();
        DataRow SelectNew();

        #endregion Methods
    }

    public enum EntityState
    {
        New = 0,
        Modified,
        Deleted,
        Unset
    }
}
