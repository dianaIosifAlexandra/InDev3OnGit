using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.WebFramework.WebControls
{
    public interface IGenericCatWebControl
    {
        string EntityProperty
        {
            get;
            set;
        }
        bool EnabledOnNew
        {
            get;
            set;
        }
        bool EnabledOnEdit
        {
            get;
            set;
        }
        bool VisibleOnNew
        {
            get;
            set;
        }
        bool VisibleOnEdit
        {
            get;
            set;
        }
        void SetValue(object val);
        object GetValue();
        /// <summary>
        /// Represents the attributes that will be used for populating the datasource
        /// </summary>
        /// <param name="attributes"></param>
        void SetDataSource(object[] attributes);
    }
}
