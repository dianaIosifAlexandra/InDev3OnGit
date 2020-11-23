using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBOwner : DBGenericEntity
    {
        public DBOwner(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IOwner)
            {
                IOwner Owner = (IOwner)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertOwner";
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, Owner.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Owner.Name));
                spInsert.AddParameter(new DBParameter("@IdOwnerType", DbType.Int32, ParameterDirection.Input, Owner.IdOwnerType));
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, Owner.Rank));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateOwner";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Owner.Id));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, Owner.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Owner.Name));
                spUpdate.AddParameter(new DBParameter("@IdOwnerType", DbType.Int32, ParameterDirection.Input, Owner.IdOwnerType));
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, Owner.Rank));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteOwner";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Owner.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectOwner";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Owner.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }

}
