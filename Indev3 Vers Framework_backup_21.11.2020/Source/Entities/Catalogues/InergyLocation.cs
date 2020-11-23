using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.DataAccess.Catalogues;
using System.Data;

namespace Inergy.Indev3.Entities.Catalogues
{
    /// <summary>
    /// Represents the InergyLocation entity
    /// </summary>
    public class InergyLocation : GenericEntity, IInergyLocation
    {
        #region IInergyLocation Members

        private int _IdCountry;
        [PropertyValidation(true)]
        [ComboBoxMapping(typeof(Country), "Name", "Id")]
        [ControlName("cmbCountry")]
        public int IdCountry
        {
            get
            {
                return _IdCountry;
            }
            set
            {
                _IdCountry = value;
            }
        }
        private string _Name;
        [PropertyValidation(true, 30)]
        [TextBoxMapping()]
        [ControlName("txtName")]
        public string Name
        {
            get
            {
                return _Name;
            }
            set
            {
                _Name = value;
            }
        }
        private string _Code;
        [PropertyValidation(true, 3)]
        [TextBoxMapping()]
        [ControlName("txtCode")]
        public string Code
        {
            get
            {
                return _Code;
            }
            set
            {
                _Code = value;
            }
        }

        #endregion

        #region Constructors
        public InergyLocation()
        {
            SetEntity(new DBInergyLocation());
            _IdCountry = int.MinValue;
        }

        public InergyLocation(DataRow row)
            : this()
        {
            Row2Object(row);
        }
        #endregion

        public override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this.IdCountry = (int)row["IdCountry"];
            this.Code = row["Code"].ToString();
            this.Name = row["Name"].ToString();
        }
    }
}
