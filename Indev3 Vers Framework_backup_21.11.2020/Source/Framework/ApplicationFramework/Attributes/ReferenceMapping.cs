using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.ApplicationFramework.Attributes
{
    /// <summary>
    /// Attribute class used to map a property of an entity to a TextBox
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public class ReferenceMappingAttribute : Attribute
    {
        #region Members
        
        private Type _ReferencedEntity;
        /// <summary>
        /// The Type of the Entity that is referenced by the current entity and that will populate the ComboBox
        /// </summary>
        public Type ReferencedEntity
        {
            get { return _ReferencedEntity; }
            set { _ReferencedEntity = value; }
        }
        #endregion Members

        #region Constructors
        public ReferenceMappingAttribute(Type referencedEntity)
        {
            _ReferencedEntity = referencedEntity;
        }
        #endregion Constructors
    }
}