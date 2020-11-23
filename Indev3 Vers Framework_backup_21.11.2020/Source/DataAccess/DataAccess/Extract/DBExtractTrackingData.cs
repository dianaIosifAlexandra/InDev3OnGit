using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Extract;
using System.Data;

namespace Inergy.Indev3.DataAccess.Extract
{
    public class DBExtractTrackingData : DBGenericEntity
    {
        public DBExtractTrackingData(object connectionManager): base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IExtractTrackingData)
            {
                IExtractTrackingData extractTrackingData = (IExtractTrackingData)ent;

                DBStoredProcedure spSelectAllPrograms = new DBStoredProcedure();
                spSelectAllPrograms.ProcedureName = "catSelectProgram";
                spSelectAllPrograms.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, -1));
                spSelectAllPrograms.AddParameter(new DBParameter("@OnlyActive", DbType.Byte, ParameterDirection.Input, 1));
                this.AddStoredProcedure("SelectObject", spSelectAllPrograms);

                DBStoredProcedure spSelectActual = new DBStoredProcedure();
                spSelectActual.ProcedureName = "extExtractTrackingData";
                spSelectActual.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, extractTrackingData.Year));
                spSelectActual.AddParameter(new DBParameter("@IdProgram", DbType.Int32, ParameterDirection.Input, extractTrackingData.IdProgram));
                spSelectActual.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, extractTrackingData.IdProject));
                spSelectActual.AddParameter(new DBParameter("@IdRole", DbType.Int32, ParameterDirection.Input, extractTrackingData.IdRole));
                this.AddStoredProcedure("ExtractTrackingData", spSelectActual);


            }
        }

    }
}
