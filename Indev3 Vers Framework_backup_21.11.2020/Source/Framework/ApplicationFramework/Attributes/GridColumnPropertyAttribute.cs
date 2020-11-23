using System;

namespace Inergy.Indev3.ApplicationFramework.Attributes
{
    [AttributeUsage(AttributeTargets.Property)]
    public class GridColumnPropertyAttribute : Attribute
    {
        private bool _IsVisible = true;

        public bool IsVisible
        {
            get { return _IsVisible; }
            set { _IsVisible = value; }
        }

        private string _ColumnHeaderName = null;

        public string ColumnHeaderName
        {
            get { return _ColumnHeaderName; }
            set { _ColumnHeaderName = value; }
        }

        public GridColumnPropertyAttribute(bool isVisible)
        {
            this._IsVisible = isVisible;
        }
        public GridColumnPropertyAttribute(string columnHeaderName)
        {
            this._ColumnHeaderName = columnHeaderName;
        }
    }
}
