using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;

using System.Data;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBRegion : DBGenericEntity
    {
        public DBRegion(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IRegion)
            {
                IRegion region = (IRegion)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertRegion";
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, region.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, region.Name));
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, region.Rank));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateRegion";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, region.Id));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, region.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, region.Name));
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, region.Rank));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteRegion";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, region.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectRegion";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, region.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }

}
