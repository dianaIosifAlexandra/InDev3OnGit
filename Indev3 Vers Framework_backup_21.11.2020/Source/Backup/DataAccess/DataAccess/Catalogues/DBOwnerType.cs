using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBOwnerType : DBGenericEntity
    {
        public DBOwnerType(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
                IGenericEntity OwnerType = ent;
                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectOwnerType";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, OwnerType.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            
        }
    }

}
