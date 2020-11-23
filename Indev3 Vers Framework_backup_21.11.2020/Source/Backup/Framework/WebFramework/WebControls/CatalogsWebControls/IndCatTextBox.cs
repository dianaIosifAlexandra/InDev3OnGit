using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.WebFramework.Utils;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls
{
    /// <summary>
    /// The TextBox that will be used in Indev3 project
    /// </summary>
    [DefaultProperty("Text")]
    [ToolboxBitmap(typeof(System.Web.UI.WebControls.TextBox))]
    [ToolboxData("<{0}:IndCatTextBox runat=\"server\"></{0}:IndCatTextBox>")]
    public class IndCatTextBox : IndTextBox, IGenericCatWebControl
    {
        #region Properties
        private string _EntityProperty;
        [DefaultValue("")]
        [Category("Extension")]
        public string EntityProperty
        {
            get { return _EntityProperty; }
            set { _EntityProperty = value; }
        }

        private bool _EnabledOnNew = true;
        /// <summary>
        /// True if this textbox will be enabled on add operation
        /// </summary>
        [DefaultValue(true)]
        [Category("Extension")]
        public bool EnabledOnNew
        {
            get { return _EnabledOnNew; }
            set { _EnabledOnNew = value; }
        }

        private bool _EnabledOnEdit = true;
        /// <summary>
        /// True if this textbox will be enabled on edit operation
        /// </summary>
        [DefaultValue(true)]
        [Category("Extension")]
        public bool EnabledOnEdit
        {
            get { return _EnabledOnEdit; }
            set { _EnabledOnEdit = value; }
        }

        private bool _VisibleOnNew = true;
        /// <summary>
        /// True if this textbox will be visible on add operation
        /// </summary>
        [DefaultValue(true)]
        [Category("Extension")]
        public bool VisibleOnNew
        {
            get { return _VisibleOnNew; }
            set { _VisibleOnNew = value; }
        }

        private bool _VisibleOnEdit = true;
        /// <summary>
        /// True if this textbox will be visible on edit operation
        /// </summary>
        [DefaultValue(true)]
        [Category("Extension")]
        public bool VisibleOnEdit
        {
            get { return _VisibleOnEdit; }
            set { _VisibleOnEdit = value; }
        }

        #endregion Properties

        #region Constructor
        public IndCatTextBox():base()
        {
        }
        #endregion Constructor

        #region Overrides
        public void SetValue(object val)
        {
            try
            {
                this.Text = (val == null) ? String.Empty : val.ToString();
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return;
            }
        }
        public object GetValue()
        {
            try
            {
                return this.Text;
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return null;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return null;
            }
        }
        public void SetDataSource(object[] attributes)
        {
            try
            {
                if (attributes.Length == 0)
                    return;
                ReferenceMappingAttribute attribute = attributes[0] as ReferenceMappingAttribute;
                if (attribute == null)
                    return;

                IGenericEntity referencedEntity = EntityFactory.GetEntityInstance(attribute.ReferencedEntity, SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
                DataRow referencedDataRow = referencedEntity.SelectNew();
                this.SetValue(referencedDataRow["Rank"]);
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return;
            }
        }       
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);
                //If _AlphaNumericCheck attribute is true, then all characters that will be allowed to be 
                //filled in will be the ones defined in ALLOWED_TEXTBOX_CHARACTERS variable
                if (AlphaNumericCheck)
                {
                    string previousEvent = this.Attributes["onKeyPress"];
                    this.Attributes.Add("onKeyPress", (String.IsNullOrEmpty(previousEvent)?"":previousEvent) + "if (getKeyCode(event) == 13) {return false;} return RestrictKeys(event,'" + ApplicationConstants.ALLOWED_TEXTBOX_CHARACTERS + "',\"" + this.ClientID + "\")");
                }
            }
            catch (IndException ex)
            {
                ControlHierarchyManager.ReportError(ex);
                return;
            }
            catch (Exception ex)
            {
                ControlHierarchyManager.ReportError(new IndException(ex));
                return;
            }
        }
        #endregion Overrides
    }
}
