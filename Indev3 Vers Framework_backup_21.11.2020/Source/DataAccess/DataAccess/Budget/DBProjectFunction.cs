using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Budget;
using System.Data;


namespace Inergy.Indev3.DataAccess.Budget
{
    public class DBProjectFunction : DBGenericEntity
    {
        public DBProjectFunction(object connectionManager)
            : base(connectionManager)
        {

        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IProjectFunction)
            {
                IProjectFunction projectFunction = (IProjectFunction)ent;
                
                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "bgtSelectProjectFunctions";
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }
}
