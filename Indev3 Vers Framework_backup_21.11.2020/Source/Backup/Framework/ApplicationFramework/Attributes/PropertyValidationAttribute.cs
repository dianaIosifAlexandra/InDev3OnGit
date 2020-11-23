using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.ApplicationFramework.Attributes
{
    /// <summary>
    /// Attribute class used to automatically validate properties of entities
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public class PropertyValidationAttribute : Attribute
    {
        #region Members
        private bool _IsRequired;
        /// <summary>
        /// The property is required (a value must be entered for this property)
        /// </summary>
        public bool IsRequired
        {
            get { return _IsRequired; }
            set { _IsRequired = value; }
        }
  
        private int _MinValue;
        /// <summary>
        /// The minimum value this property can have (if it is numeric)
        /// </summary>
        public int MinValue
        {
            get { return _MinValue; }
            set { _MinValue = value; }
        }

        private int _MaxValue;
        /// <summary>
        /// The maximum value this property can have  (if it is numeric)
        /// </summary>
        public int MaxValue
        {
            get { return _MaxValue; }
            set { _MaxValue = value; }
        }

        private int _MaxLength;
        /// <summary>
        /// The maximum length the value of this property (if it is String)
        /// </summary>
        public int MaxLength
        {
            get { return _MaxLength; }
            set { _MaxLength = value; }
        }
        #endregion

        #region Constructors

        /// <summary>
        /// Initializes an EntityPropertyValidation attribute
        /// </summary>
        /// <param name="isRequired">true if the field is required, false otherwise</param>
        public PropertyValidationAttribute(bool isRequired)
        {
            this._IsRequired = isRequired;
            this._MinValue = int.MaxValue;
            this._MaxValue = int.MinValue;
            this._MaxLength = int.MinValue;
        }

        /// <summary>
        /// Initializes an EntityPropertyValidation attribute
        /// </summary>
        /// <param name="isRequired">true if the field is required, false otherwise</param>
        /// <param name="maxLength">The maximum length (maximum number of characters) of the property</param>
        public PropertyValidationAttribute(bool isRequired, int maxLength)
        {
            this._IsRequired = isRequired;
            this._MaxLength = maxLength;
            this._MinValue = int.MaxValue;
            this._MaxValue = int.MinValue;
        }

        /// <summary>
        /// Initializes an EntityPropertyValidation attribute
        /// </summary>
        /// <param name="isRequired">true if the field is required, false otherwise</param>
        /// <param name="minValue">The minimum value of the property</param>
        /// <param name="maxValue">The maximum value of the property</param>
        public PropertyValidationAttribute(bool isRequired, int minValue, int maxValue)
        {
            this._IsRequired = isRequired;
            this._MinValue = minValue;
            this._MaxValue = maxValue;
            this._MaxLength = int.MinValue;
        }

        #endregion Constructors
    }
}
