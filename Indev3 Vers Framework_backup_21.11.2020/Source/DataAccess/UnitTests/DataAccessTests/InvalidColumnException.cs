using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.DataAccessTests
{
    public class InvalidColumnException : Exception
    {
        private string columnName;
        private int columnPosition;

        public InvalidColumnException(string columnName, int columnPosition)
        {
            this.columnName = columnName;
            this.columnPosition = columnPosition;
        }

        public override string Message
        {
            get
            {
                return "Invalid Column name at position " + columnPosition.ToString() + ". Expected: " + columnName;
            }
        }
    }
}
