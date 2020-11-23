using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.Entities.Extract;
using Inergy.Indev3.DataAccess.Extract;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.BusinessLogic.Authorization;
namespace Inergy.Indev3.BusinessLogic.Extract
{
    public class TrackingActivityLog : GenericEntity, ITrackingActivityLog
    {

        private int _IdAssociate;
        public int IdAssociate
        {
            get
            {
                return _IdAssociate;
            }
            set
            {
                _IdAssociate = value;
            }
        }


        private int _IdMemberImpersonated;
        public int IdMemberImpersonated
        {
            get
            {
                return _IdMemberImpersonated;
            }
            set
            {
                _IdMemberImpersonated = value;
            }
        }

        private int _IdProjectFunctionImpersonated;
        public int IdProjectFunctionImpersonated
        {
            get
            {
                return _IdProjectFunctionImpersonated;
            }
            set
            {
                _IdProjectFunctionImpersonated = value;
            }
        }

        private int _IdProject;
        public int IdProject
        {
            get
            {
                return _IdProject;
            }
            set
            {
                _IdProject = value;
            }
        }

        private int _IdAction;
        public int IdAction
        {
            get
            {
                return _IdAction;
            }
            set
            {
                _IdAction = value;
            }
        }

        private int _IdGeneration;
        public int IdGeneration
        {
            get
            {
                return _IdGeneration;
            }
            set
            {
                _IdGeneration = value;
            }
        }

        private DateTime _Logdate;
        public DateTime Logdate
        {
            get
            {
                return _Logdate;
            }
            set
            {
                _Logdate = value;
            }
        }

        public TrackingActivityLog(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBTrackingActivityLog(connectionManager));
            _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
            _IdMemberImpersonated = ApplicationConstants.INT_NULL_VALUE;
            _IdProjectFunctionImpersonated = ApplicationConstants.INT_NULL_VALUE;
            _IdProject = ApplicationConstants.INT_NULL_VALUE;
            _IdAction = ApplicationConstants.INT_NULL_VALUE;
            _IdGeneration = ApplicationConstants.INT_NULL_VALUE;
            _Logdate = DateTime.Now;
        }

        public void InsertTrackingActivityLog(CurrentProject currentProject, CurrentUser currentUser, ETrackingActivity act)
        {
            BeginTransaction();


            try
            {
                //TODO: Call this method only if this is the case
                this.IdAssociate = currentUser.IdAssociate;
                this.IdMemberImpersonated = currentUser.IdImpersonatedAssociate;
                this.IdProjectFunctionImpersonated = currentUser.IdProjectFunctionImpersonated;
                this.IdProject = currentProject.Id;
                this.IdAction = (int)act;
                this.IdGeneration = currentProject.IdVersion;

                InsertMasterRecord();
                CommitTransaction();
            }
            catch (Exception exc)
            {
                RollbackTransaction();
                throw new IndException(exc);
            }
        }

        private void InsertMasterRecord()
        {
            if (this.IdAssociate <= 0)
                throw new IndException(ApplicationMessages.EXCEPTION_TRACKING_ACTIVITY_LOG_INCOMPLETE_PROPERTIES);

            if (this.IdAction <= 0)
                throw new IndException(ApplicationMessages.EXCEPTION_TRACKING_ACTIVITY_LOG_INCOMPLETE_PROPERTIES);

            if (this.IdMemberImpersonated > 0 && this.IdProject < 0)
                throw new IndException(ApplicationMessages.EXCEPTION_TRACKING_ACTIVITY_LOG_INCOMPLETE_PROPERTIES);

            //if (this.IdMemberImpersonated > 0 && this.IdProjectFunctionImpersonated < 0)
            //    throw new IndException(ApplicationMessages.EXCEPTION_TRACKING_ACTIVITY_LOG_INCOMPLETE_PROPERTIES);

            try
            {
                this.GetEntity().ExecuteCustomProcedure("InsertTrackingActivityLog", this);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }
        }
    }
}
