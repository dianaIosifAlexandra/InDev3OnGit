using System;
using System.Collections.Generic;
using System.Text;

using Inergy.Indev3.DataAccess;

namespace Inergy.Indev3.DataAccessTests
{
    public abstract class BaseTest
    {
        protected object connManager;
        protected DBGenericEntity dbEntity;

        public virtual void Initialize()
        {
            DBSessionConnectionHelper sessionConnectionHelper = new DBSessionConnectionHelper();
            connManager = sessionConnectionHelper.GetNewConnectionManager(DATestUtils.ConnString, DATestUtils.COMMAND_TIMEOUT);
        }

        public virtual void CleanUp()
        {
            ((ConnectionManager)connManager).DisposeConnection();
        }
    }
}
