using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Inergy.Indev3.DataAccess
{
    public class DBParameter
    {
        public string Name = null;
        public object Value = null;
        public DbType DBType;
        public ParameterDirection Direction;

        public DBParameter(string name, DbType dbType, ParameterDirection direction, object value)
        {
            this.Name = name;
            this.DBType = dbType;
            this.Direction = direction;
            this.Value = value;
        }
    }
}
