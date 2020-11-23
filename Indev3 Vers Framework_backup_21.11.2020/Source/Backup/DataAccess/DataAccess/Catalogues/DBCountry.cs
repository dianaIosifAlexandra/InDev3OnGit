using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBCountry : DBGenericEntity
    {
        public DBCountry(object connectionManager)
            : base(connectionManager)
        {        
        }
        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ICountry)
            {
                ICountry country = (ICountry)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertCountry";
                spInsert.AddParameter(new DBParameter("Name", DbType.String, ParameterDirection.Input, country.Name));
                spInsert.AddParameter(new DBParameter("Code", DbType.String, ParameterDirection.Input, country.Code));
                spInsert.AddParameter(new DBParameter("IdCurrency", DbType.Int32, ParameterDirection.Input, country.IdCurrency));
                if (country.IdRegion != ApplicationConstants.INT_NULL_VALUE)
                    spInsert.AddParameter(new DBParameter("IdRegion", DbType.Int32, ParameterDirection.Input, country.IdRegion));
                if (String.IsNullOrEmpty(country.Email))
                {
                    spInsert.AddParameter(new DBParameter("Email", DbType.String, ParameterDirection.Input, DBNull.Value));
                }
                else
                {
                    spInsert.AddParameter(new DBParameter("Email", DbType.String, ParameterDirection.Input, country.Email));
                }
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, country.Rank));


                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateCountry";
                spUpdate.AddParameter(new DBParameter("Id", DbType.Int32, ParameterDirection.Input, country.Id));
                spUpdate.AddParameter(new DBParameter("Name", DbType.String, ParameterDirection.Input, country.Name));
                spUpdate.AddParameter(new DBParameter("Code", DbType.String, ParameterDirection.Input, country.Code));
                spUpdate.AddParameter(new DBParameter("IdCurrency", DbType.Int32, ParameterDirection.Input, country.IdCurrency));
                if (country.IdRegion != ApplicationConstants.INT_NULL_VALUE)
                    spUpdate.AddParameter(new DBParameter("IdRegion", DbType.Int32, ParameterDirection.Input, country.IdRegion));
                if (String.IsNullOrEmpty(country.Email))
                {
                    spUpdate.AddParameter(new DBParameter("Email", DbType.String, ParameterDirection.Input, DBNull.Value));
                }
                else
                {
                    spUpdate.AddParameter(new DBParameter("Email", DbType.String, ParameterDirection.Input, country.Email));
                }
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, country.Rank));


                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteCountry";
                spDelete.AddParameter(new DBParameter("Id", DbType.Int32, ParameterDirection.Input, country.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectCountry";
                spSelect.AddParameter(new DBParameter("Id", DbType.Int32, ParameterDirection.Input, country.Id));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spSelectCountry_InergyLocation = new DBStoredProcedure();
                spSelectCountry_InergyLocation.ProcedureName = "catSelectCountry_InergyLocation";
                spSelectCountry_InergyLocation.AddParameter(new DBParameter("@Id", DbType.Int32,ParameterDirection.Input,country.Id));
                spSelectCountry_InergyLocation.AddParameter(new DBParameter("@IdInergyLocation", DbType.Int32, ParameterDirection.Input, country.IdInergyLocation));
                this.AddStoredProcedure("SelectCountry_InergyLocation", spSelectCountry_InergyLocation);
            }
        }
    }
}
