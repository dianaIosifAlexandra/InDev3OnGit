using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Catalogues;



namespace Inergy.Indev3.DataAccess.Catalogues
{
    public class DBWorkPackage : DBGenericEntity
    {
        public DBWorkPackage(object connectionManager)
            : base(connectionManager)
        {
        }

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IWorkPackage)
            {
                IWorkPackage WorkPackage = (IWorkPackage)ent;
                DBStoredProcedure spInsert = new DBStoredProcedure();
                spInsert.ProcedureName = "catInsertWorkPackage";
                WorkPackage.LastUpdate = DateTime.Today;
                spInsert.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, WorkPackage.Code));
                spInsert.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, WorkPackage.Name));
                spInsert.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, WorkPackage.IdProject));
                spInsert.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackage.IdPhase));
                spInsert.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, WorkPackage.IsActive));
                spInsert.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, WorkPackage.Rank));
                spInsert.AddParameter(new DBParameter("@StartYearMonth", DbType.Int32, ParameterDirection.Input, 
                    WorkPackage.StartYearMonth == ApplicationConstants.INT_NULL_VALUE ? (object)DBNull.Value : (object)WorkPackage.StartYearMonth));
                spInsert.AddParameter(new DBParameter("@EndYearMonth", DbType.Int32, ParameterDirection.Input,
                    WorkPackage.EndYearMonth == ApplicationConstants.INT_NULL_VALUE ? (object)DBNull.Value : (object)WorkPackage.EndYearMonth));
                spInsert.AddParameter(new DBParameter("@LastUserUpdate", DbType.Int32, ParameterDirection.Input, WorkPackage.IdLastUserUpdate));


                DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateWorkPackage";
                spUpdate.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, WorkPackage.Id));
                spUpdate.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, WorkPackage.Code));
                spUpdate.AddParameter(new DBParameter("@Name", DbType.String, ParameterDirection.Input, WorkPackage.Name));
                spUpdate.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, WorkPackage.IdProject));
                spUpdate.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackage.IdPhase));
                spUpdate.AddParameter(new DBParameter("@IsActive", DbType.Boolean, ParameterDirection.Input, WorkPackage.IsActive));
                spUpdate.AddParameter(new DBParameter("@Rank", DbType.Int32, ParameterDirection.Input, WorkPackage.Rank));
                spUpdate.AddParameter(new DBParameter("@StartYearMonth", DbType.Int32, ParameterDirection.Input,
                        WorkPackage.StartYearMonth == ApplicationConstants.INT_NULL_VALUE ? (object)DBNull.Value : (object)WorkPackage.StartYearMonth));
                spUpdate.AddParameter(new DBParameter("@EndYearMonth", DbType.Int32, ParameterDirection.Input,
                        WorkPackage.EndYearMonth == ApplicationConstants.INT_NULL_VALUE ? (object)DBNull.Value : (object)WorkPackage.EndYearMonth));
                spUpdate.AddParameter(new DBParameter("@LastUserUpdate", DbType.Int32, ParameterDirection.Input, WorkPackage.IdLastUserUpdate));

                DBStoredProcedure spDelete = new DBStoredProcedure();
                spDelete.ProcedureName = "catDeleteWorkPackage";
                spDelete.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, WorkPackage.IdProject));
                spDelete.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackage.IdPhase));
                spDelete.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, WorkPackage.Id));

                this.AddStoredProcedure("InsertObject", spInsert);
                this.AddStoredProcedure("UpdateObject", spUpdate);
                this.AddStoredProcedure("DeleteObject", spDelete);

                DBStoredProcedure spSelect = new DBStoredProcedure();
                spSelect.ProcedureName = "catSelectWorkPackage";
                spSelect.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, WorkPackage.IdProject));
                spSelect.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackage.IdPhase));
                spSelect.AddParameter(new DBParameter("@Id", DbType.Int32, ParameterDirection.Input, WorkPackage.Id));
                spSelect.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, WorkPackage.IdAssociate));
                this.AddStoredProcedure("SelectObject", spSelect);

                DBStoredProcedure spCheckWPPeriod = new DBStoredProcedure();
                spCheckWPPeriod.ProcedureName = "bgtCheckWPPeriod";
                spCheckWPPeriod.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, WorkPackage.IdProject));
                spCheckWPPeriod.AddParameter(new DBParameter("@IdPhase", DbType.Int32, ParameterDirection.Input, WorkPackage.IdPhase));
                spCheckWPPeriod.AddParameter(new DBParameter("@IdWorkPackage", DbType.Int32, ParameterDirection.Input, WorkPackage.Id));
                spCheckWPPeriod.AddParameter(new DBParameter("@CachedStartYearMonth", DbType.Int32, ParameterDirection.Input, WorkPackage.StartYearMonth));
                spCheckWPPeriod.AddParameter(new DBParameter("@CachedEndYearMonth", DbType.Int32, ParameterDirection.Input, WorkPackage.EndYearMonth));
                this.AddStoredProcedure("CheckWPPeriod", spCheckWPPeriod);


                DBStoredProcedure spGetIntercoCountries = new DBStoredProcedure();
                spGetIntercoCountries.ProcedureName = "catSelectIntercoCountries";
                spGetIntercoCountries.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, WorkPackage.IdProject));
                this.AddStoredProcedure("GetIntercoCountries", spGetIntercoCountries);

                DBStoredProcedure spGetWorkPackageNewKeys = new DBStoredProcedure();
                spGetWorkPackageNewKeys.ProcedureName = "catSelectWorkPackageNewKeys";
                spGetWorkPackageNewKeys.AddParameter(new DBParameter("@IdProject", DbType.Int32, ParameterDirection.Input, WorkPackage.IdProject));
                spGetWorkPackageNewKeys.AddParameter(new DBParameter("@Code", DbType.String, ParameterDirection.Input, WorkPackage.Code));
                this.AddStoredProcedure("GetWorkPackageNewKeys", spGetWorkPackageNewKeys);
            }
        }
    }

}
