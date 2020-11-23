using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;


namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBInergyLocation : DBGenericEntity
    {
        public DBInergyLocation(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IInergyLocation)
            {
                IInergyLocation InergyLocation = (IInergyLocation)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertInergyLocation";
                spInsert.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, InergyLocation.IdCountry));
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, InergyLocation.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, InergyLocation.Name));
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, InergyLocation.Rank));

                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateInergyLocation";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, InergyLocation.Id));
                spUpdate.AddParameter(new DBParameter("@IdCountry", DbType.Int32, ParameterDirection.Input, InergyLocation.IdCountry));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, InergyLocation.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, InergyLocation.Name));
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, InergyLocation.Rank));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteInergyLocation";
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, InergyLocation.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectInergyLocation";
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, InergyLocation.Id));
                this.AddStoredProcedure("SelectObject", spSelect);

                //used in Annual Budget for selecting an Inergy Location when a country Id is provided
                DBStoredProcedure spSelectInergyLocation_Country = new DBStoredProcedure();
                spSelectInergyLocation_Country.ProcedureName = "catSelectInergyLocation_Country";
                spSelectInergyLocation_Country.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, InergyLocation.IdCountry));
                this.AddStoredProcedure("SelectInergyLocation_Country", spSelectInergyLocation_Country);
            }
        }
    }
}
