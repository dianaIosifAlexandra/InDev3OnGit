using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.WebFramework.Utils
{
    public class CatalogFilter
    {
        public string Code;
        public string WhereClause;
        private Telerik.WebControls.GridColumnCollection cols;
        public  Telerik.WebControls.GridColumnCollection Columns
        {
            get { return cols; }
        }

        public CatalogFilter()
        {
            Code = string.Empty;
            WhereClause = string.Empty;
            cols = null;
        }

        public void CopyColumnsFrom(Telerik.WebControls.GridColumnCollection sourceCols)
        {
            if (sourceCols == null || sourceCols.Count < 2) return;
            cols = new Telerik.WebControls.GridColumnCollection(sourceCols[0].Owner);
            for (int i = 2; i < sourceCols.Count; i++)
            {
                cols.Add(sourceCols[i]);
            }
        }
    }
}
