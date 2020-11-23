using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Runtime.Serialization;

namespace Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls
{
    [Serializable]
    public class IndFilterItem
    {
        public Hashtable FilterValues;
        public StringBuilder FilterExpression;

        public IndFilterItem()
        {
            FilterValues = new Hashtable();
            FilterExpression = new StringBuilder();
        }
    }
}
