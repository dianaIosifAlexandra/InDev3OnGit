using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    public class ActiveProgram:Program
    {
        public ActiveProgram() : base()
        {
            this.OnlyActive = true;
        }
        public ActiveProgram(object connectionManager)
            : base(connectionManager)
        {
            this.OnlyActive = true;
        }
        public ActiveProgram(DataRow row, object connectionManager)
            : base(row, connectionManager)
        {
            this.OnlyActive = true;
        }
    }
}
