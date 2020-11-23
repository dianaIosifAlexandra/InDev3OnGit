using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBFunction : DBGenericEntity
    {
        public DBFunction(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IFunction)
            {
                IFunction Function = (IFunction)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertFunction";
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Function.Name));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateFunction";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Function.Id));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Function.Name));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteFunction";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Function.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectFunction";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Function.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }

}
