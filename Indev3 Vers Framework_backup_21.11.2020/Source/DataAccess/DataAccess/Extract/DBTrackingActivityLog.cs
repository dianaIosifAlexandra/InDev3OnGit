using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Extract;
using System.Data;

namespace Inergy.Indev3.DataAccess.Extract
{
    public class DBTrackingActivityLog : DBGenericEntity
    {
        public DBTrackingActivityLog(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is ITrackingActivityLog)
            {
                ITrackingActivityLog trackingActivityLog = (ITrackingActivityLog)ent;

                DBStoredProcedure spInsertTKA = new DBStoredProcedure();
                spInsertTKA.ProcedureName = "logInsertITrackingActivity";
                spInsertTKA.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, trackingActivityLog.IdAssociate));
                spInsertTKA.AddParameter(new DBParameter("@IdMemberImpersonated", DbType.Int32, ParameterDirection.Input, trackingActivityLog.IdMemberImpersonated));
                spInsertTKA.AddParameter(new DBParameter("@IdProjectFunctionImpersonated", DbType.Int32, ParameterDirection.Input, trackingActivityLog.IdProjectFunctionImpersonated));
                spInsertTKA.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, trackingActivityLog.IdProject));
                spInsertTKA.AddParameter(new DBParameter("@IdAction", DbType.Int32, ParameterDirection.Input, trackingActivityLog.IdAction));
                spInsertTKA.AddParameter(new DBParameter("@IdGeneration", DbType.Int32, ParameterDirection.Input, trackingActivityLog.IdGeneration));
                this.AddStoredProcedure("InsertTrackingActivityLog", spInsertTKA);
            }
        }

    }
}
