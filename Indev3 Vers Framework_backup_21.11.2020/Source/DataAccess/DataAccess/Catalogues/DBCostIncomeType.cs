using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBCostIncomeType : DBGenericEntity
    {
        public DBCostIncomeType(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            IGenericEntity CostIncomeType = ent;
            DBStoredProcedure spSelect = new DBStoredProcedure();
            spSelect.ProcedureName = "catSelectCostIncomeType";
            spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, CostIncomeType.Id));
            this.AddStoredProcedure("SelectObject", spSelect);

        }
    }
}
