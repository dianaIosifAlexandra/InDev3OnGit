using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.Olap;
using Inergy.Indev3.DataAccess.Olap;

namespace Inergy.Indev3.BusinessLogic.Olap
{
    public class OlapHelper : GenericEntity, IOlapHelper
    {
        #region Constructors
        public OlapHelper(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBOlapHelper(connectionManager));
        }
        #endregion Constructors
    }
}
