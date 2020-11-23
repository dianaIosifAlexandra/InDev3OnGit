using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBInergyCountry : DBGenericEntity
    {
        public DBInergyCountry(object connectionManager)
            : base(connectionManager)
        {
        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ICountry)
            {             
                ICountry country = (ICountry)ent;
               
                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectInergyCountry";
                spSelect.AddParameter(new DBParameter("Id", DbType.Int32, ParameterDirection.Input, country.Id));
                this.AddStoredProcedure("SelectObject", spSelect);
            }
        }
    }
}
