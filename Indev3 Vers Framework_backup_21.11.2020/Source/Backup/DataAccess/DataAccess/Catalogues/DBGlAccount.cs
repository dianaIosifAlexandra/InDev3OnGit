using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBGlAccount : DBGenericEntity
    {
        public DBGlAccount(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IGlAccount)
            {
                IGlAccount GlAccount = (IGlAccount)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertGlAccount";
                spInsert.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, GlAccount.IdCountry));
                spInsert.AddParameter(new DBParameter("@Account", DbType.String, ParameterDirection.Input, GlAccount.Account));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, GlAccount.Name));
                spInsert.AddParameter(new DBParameter("@IdCostType", DbType.Int32, ParameterDirection.Input, GlAccount.IdCostType));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateGlAccount";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, GlAccount.Id));
                spUpdate.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, GlAccount.IdCountry));
                spUpdate.AddParameter(new DBParameter("@Account", DbType.String, ParameterDirection.Input, GlAccount.Account));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, GlAccount.Name));
                spUpdate.AddParameter(new DBParameter("@IdCostType", DbType.Int32, ParameterDirection.Input, GlAccount.IdCostType));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteGlAccount";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, GlAccount.Id));
                spDelete.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, GlAccount.IdCountry));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectGlAccount";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, GlAccount.Id));
                spSelect.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, GlAccount.IdCountry));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }
}
