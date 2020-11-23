using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBCurrency : DBGenericEntity
    {
        public DBCurrency(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ICurrency)
            {
                ICurrency Currency = (ICurrency)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertCurrency";
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, Currency.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Currency.Name));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateCurrency";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Currency.Id));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, Currency.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, Currency.Name));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteCurrency";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Currency.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectCurrency";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, Currency.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }

}
