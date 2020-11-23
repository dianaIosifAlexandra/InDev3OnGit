using System;

namespace Inergy.Indev3.ApplicationFramework.Attributes
{
    [AttributeUsage(AttributeTargets.Property)]
    public class DesignerNameAttribute : Attribute
    {

        private string _Name = null;

        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }

        public DesignerNameAttribute(string name)
        {
            this._Name = name;
        }
    }
}
