using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Inergy.Indev3.ApplicationFramework;
using System.Reflection;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using System.Collections;
using Telerik.WebControls;
using System.Web.UI.Design;
using System.Web.UI.HtmlControls;
using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.Entities;
using System.Diagnostics;
using Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls;
using Inergy.Indev3.BusinessLogic.Authorization;


namespace Inergy.Indev3.WebFramework.GenericControls
{
    /// <summary>
    /// Generic user control used to add/edit a Catalogue
    /// </summary>
    [ToolboxData("<{0}:GenericEditControl runat=server></{0}:GenericEditControl>")]
    [Designer(typeof(ContainerControlDesigner))]
    [ParseChildren(false)]
    public class GenericEditControl : IndBaseControl, INamingContainer
    {
        #region Members
        public RadAjaxManager AjaxManager = new RadAjaxManager();
        private IndImageButton btnSave = new IndImageButton();
        private HtmlButton btnCancel = new HtmlButton();
        private IndLabel lblTitle;

        //Delegate used to call a method in the generic user control that is placed inside this control, method that occurs before the actual save operation
        public delegate void BeforeSaveDelegate();
        public BeforeSaveDelegate BeforeSave;

        private GenericUserControl _ParentGenericUserControl
        {
            get
            {
                if (!DesignMode)
                {
                    Debug.Assert(this.Parent != null, "Parent for GenericViewControl must not be null.");
                    Debug.Assert(this.Parent is GenericUserControl, "Parent for GenericViewControl must be of type GenericUserControl. Now is: " + this.Parent.GetType().ToString() + "!");

                    return (GenericUserControl)this.Parent;
                }
                else
                    return null;
            }
        }

        private bool _ShouldContinue = true;
        private bool ShouldContinue
        {
            get
            {
                return _ShouldContinue;
            }
            set
            {
                _ShouldContinue = value;
                //TODO: Write here code to disable all controls if this is desired
            }
        }
        /// <summary>
        /// The entity associated with this control
        /// </summary>
        private IGenericEntity _Entity;
        [Browsable(false)]
        public IGenericEntity Entity
        {
            get
            {
                if (_Entity == null)
                {
                    _Entity = _ParentGenericUserControl.Entity;
                }
                return _Entity;
            }
            set
            {
                _Entity = value;
                
            }
        }
        /// <summary>
        /// Hashtable containing the property names of the entity as keys, and the names of the mapping controls as values
        /// </summary>
        private Dictionary<PropertyInfo, IGenericCatWebControl> PropertyToControlDictionary;

        /// <summary>
        /// properties of the business object
        /// </summary>
        private PropertyInfo[] entityProperties;

        //The following property allows instances of GenericEditControl class to see if the window is 
        //or isn't in edit mode
        private bool _EditMode;
        public bool EditMode
        {
            get { return _EditMode; }
        }
        #endregion

        #region Public Methods
        public void AddSaveHandler(ImageClickEventHandler handler)
        {
            btnSave.Click += handler;
        }
        #endregion Public Methods


        public GenericEditControl()
        {
            PropertyToControlDictionary = new Dictionary<PropertyInfo, IGenericCatWebControl>();
        }


        #region Event Handlers

        protected override void OnInit(EventArgs e)
        {
            try
            {
                base.OnInit(e);
                object connectionManager = SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.CONNECTION_MANAGER);
                this.Entity.SetSqlConnection(connectionManager);
                _EditMode = (SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.EDIT_PARAMETERS) != null);

                if (!_EditMode)
                {
                    Entity.Id = ApplicationConstants.INT_NULL_VALUE;
                }
                else
                {
                    Dictionary<string, object> editParameters = (Dictionary<string, object>)SessionManager.GetSessionValueNoRedirect((IndPopUpBasePage)this.Page, SessionStrings.EDIT_PARAMETERS);
                    Entity.FillEditParameters(editParameters);
                }

                if (SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.ENTITY_MAPPING) == null)
                {
                    SessionManager.SetSessionValue(ParentPage, SessionStrings.ENTITY_MAPPING, EntityUtils.CreateCatalogueMapping());
                }

                //Get the properties of the entity
                entityProperties = GetEntityProperties();

                //first create the layout
                CreateControlLayout();

                //add custom validators
                LayoutAddCustomValidators();

                //create the dictionary to be used in update operation
                if (IsPostBack)
                    CreateControlDictionaryForUpdate();

                //fill embedded entity from database 
                FillEntityDataFromDB();

                //populate controls with data from database only if page is not posted back
                if (!IsPostBack)
                    PopulateControlsFromEntity();
            }
            catch (IndException exc)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(exc);
                return;
            }
            catch (Exception ex)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);
                AjaxManager.AjaxSettings.AddAjaxSetting(this, ParentPage.pnlErrors);
                if (!Page.ClientScript.IsOnSubmitStatementRegistered(ParentPage.GetType(), "ResizePopUp"))
                {
                    this.Page.ClientScript.RegisterOnSubmitStatement(ParentPage.GetType(), "ResizePopUp", "SetPopUpHeight(); try{if(Page_IsValid) this.disabled=true;}catch(e){}");
                }
            }
            catch (IndException exc)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(exc);
                return;
            }
            catch (Exception ex)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }



        protected override void CreateChildControls()
        {
            //if (!shouldContinue)
            //    return;

            try
            {
                HtmlForm frm = (HtmlForm)Page.FindControl("form1");

                Table tblHeader = (Table)frm.FindControl("tblHeader");
                TableRow rowHeader = (TableRow)tblHeader.FindControl("HeaderRow");
                TableCell cellHeader = (TableCell)rowHeader.FindControl("HeaderCell");
                cellHeader.Controls.Add(lblTitle);

                Table table = (Table)frm.FindControl("tbl");
                TableRow rowValidation = (TableRow)table.FindControl("ValidationRow");
                TableCell validationCell = (TableCell)rowValidation.FindControl("ValidationCell");

                Table tableFooter = (Table)frm.FindControl("tblFooter");
                TableRow rowFooter = (TableRow)tableFooter.FindControl("FooterRow");
                TableCell footerCell = (TableCell)rowFooter.FindControl("FooterCell");

                IndValidationSummary validationSummary = new IndValidationSummary();
                validationSummary.DisplayMode = ValidationSummaryDisplayMode.BulletList;

                validationCell.Controls.Add(validationSummary);

                footerCell.Controls.Add(btnSave);
                footerCell.Controls.Add(btnCancel);
                footerCell.Controls.Add(AjaxManager);
                base.CreateChildControls();
            }
            catch (IndException exc)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(exc);
                return;
            }
            catch (Exception ex)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }
        #endregion

        #region Private Methods
        /// <summary>
        /// The event handler for the Click event of the Save button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            if (!ShouldContinue)
                return;

            try
            {
                //If no operation takes place before the save, save the entity
                if (BeforeSave == null)
                {
                    if (Page.IsValid)
                    {
                        SaveEntity();

                        //Since the pop-up will close anyway, we do not need to transport to the client all the page viewstate since it will not be used anyway
                        //In addition, the items of the comboboxes do not need to be rendered on the client.
                        if (this.ShouldContinue)
                        {
                            this.EnableViewState = false;
                            ClearCombos(this);
                        }
                    }
                }
                //Else do the before save operation
                else
                {
                    BeforeSave();
                }
            }
            catch (IndException exc)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(exc);
                return;
            }
            catch (Exception ex)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }

        public void SaveEntity()
        {
            try
            {
                //Get the new entity (based on the data entered by the user) which will be saved
                IGenericEntity newEntity = BuildUpdatedEntity();

                if (_EditMode)
                {
                    newEntity.SetModified();
                }
                else
                {
                    newEntity.SetNew();
                }

                newEntity.Save();
                if (!Page.ClientScript.IsClientScriptBlockRegistered(this.GetType(), "ButtonClickScript"))
                {
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ButtonClickScript", "window.returnValue = 1; window.close();", true);
                }
            }
            catch (IndException exc)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(exc);
                return;
            }
            catch (Exception ex)
            {
                ShouldContinue = false;
                _ParentGenericUserControl.ReportControlError(new IndException(ex));
                return;
            }
        }

        /// <summary>
        /// Builds the new Entity from the data entered by the user
        /// </summary>
        /// <returns></returns>
        private IGenericEntity BuildUpdatedEntity()
        {
            IGenericEntity newEntity = _Entity;
            IGenericCatWebControl ctl;

            foreach (PropertyInfo entityProperty in PropertyToControlDictionary.Keys)
            {
                ctl = PropertyToControlDictionary[entityProperty];
                if (String.IsNullOrEmpty(ctl.GetValue().ToString()) && entityProperty.PropertyType == typeof(DateTime))
                {
                    entityProperty.SetValue(newEntity, DateTime.Now, null);
                    continue;
                }

                entityProperty.SetValue(newEntity, 
                                        Convert.ChangeType(ctl.GetValue(), entityProperty.PropertyType), 
                                        null);
            }
            //HACK 
            if (newEntity is ProjectCoreTeamMember && ((ProjectCoreTeamMember)newEntity).IdAssociate == ApplicationConstants.INT_NULL_VALUE)
            {
                Associate associate = (Associate)SessionManager.GetSessionValueRedirect(ParentPage, SessionStrings.CORE_TEAM_ASSOCIATE);
                ((ProjectCoreTeamMember)newEntity).IdAssociate = (associate == null) ? ApplicationConstants.INT_NULL_VALUE : associate.Id;
            }
            if (newEntity is Project && ((Project)newEntity).IdAssociate == ApplicationConstants.INT_NULL_VALUE)
            {
                CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER);
                ((Project)newEntity).IdAssociate = (currentUser == null) ? ApplicationConstants.INT_NULL_VALUE : currentUser.IdAssociate;
            }
            _ParentGenericUserControl.SetAdditionalProperties(newEntity);

            return newEntity;
        }

        /// <summary>
        /// 
        /// </summary>
        private void CreateControlDictionaryForUpdate()
        {
            IGenericCatWebControl correspondingControl = null;

            foreach (PropertyInfo entityProperty in entityProperties)
            {
                correspondingControl = LookupControlByEntityPropertyName(entityProperty.Name);
                if (correspondingControl == null)
                    continue;

                //add to the dictionary that will be used for update
                PropertyToControlDictionary.Add(entityProperty, correspondingControl);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void PopulateControlsFromEntity()
        {
            IGenericCatWebControl correspondingControl = null;

            foreach (PropertyInfo entityProperty in entityProperties)
            {
                correspondingControl = LookupControlByEntityPropertyName(entityProperty.Name);
                if (correspondingControl == null)
                    continue;

                PopulateControlFromEntity(correspondingControl, entityProperty);
            }
        }

        private void PopulateControlFromEntity(IGenericCatWebControl correspondingControl, PropertyInfo entityProperty)
        {
            correspondingControl.SetDataSource(entityProperty.GetCustomAttributes(typeof(ReferenceMappingAttribute), false));

            object value = entityProperty.GetValue(_Entity, null);

            //If the catalogue is in add mode, the value is numeric and null, do not populate the catalogue. In all other situations.
            //populate the control with the corresponding value
            if (!(!_EditMode && ApplicationUtils.AssertValueIsNumeric(value) && ApplicationUtils.AssertValueIsNull(value)))
            {
                if (!(correspondingControl is IndCatTextBox && entityProperty.Name == "Rank" && !_EditMode))
                {
                    correspondingControl.SetValue(value);
                }
            }
        }

        private void LayoutAddCustomValidators()
        {
            IGenericCatWebControl correspondingControl = null;

            foreach (PropertyInfo entityProperty in entityProperties)
            {
                correspondingControl = LookupControlByEntityPropertyName(entityProperty.Name);

                if (correspondingControl == null)
                    continue;

                //Add a validator to this control, if it is not checkbox or label
                if (!(correspondingControl is IndCheckBox || correspondingControl is IndLabel))
                {
                    AddValidators(entityProperty, (Control)correspondingControl);
                }
            }
        }

        private IGenericCatWebControl LookupControlByEntityPropertyName(String name)
        {
            IGenericCatWebControl correspondingControl = null;
            IGenericCatWebControl lookupControl = null;

            //look for corresponding control by name
            foreach (Control ctl in this.Controls)
            {
                if (ctl is IGenericCatWebControl)
                {
                    lookupControl = (IGenericCatWebControl)ctl;
                    if (lookupControl.EntityProperty == name)
                    {
                        correspondingControl = lookupControl;
                        break;
                    }
                }
            }

            return correspondingControl;
        }

        /// <summary>
        /// Adds the corresponding validators to the currentControl
        /// </summary>
        /// <param name="entityProperty">the property mapped to the control</param>
        /// <param name="currentControl">the control to which the validators are added</param>
        private void AddValidators(PropertyInfo entityProperty, Control currentControl)
        {
            object[] validationAttributes;
            //Get the validation attributes of the property
            validationAttributes = entityProperty.GetCustomAttributes(typeof(PropertyValidationAttribute), false);
            if (validationAttributes.Length == 1)
            {
                PropertyValidationAttribute validationAttribute = (PropertyValidationAttribute)validationAttributes[0];

                IndLabel lblRequired = new IndLabel();
                lblRequired.Text = " *";
                //If the property is required, add a RequiredFieldValidator
                if (validationAttribute.IsRequired)
                {
                    lblRequired.ForeColor = System.Drawing.Color.Yellow;

                    if (currentControl is IndCatYearMonth)
                    {
                        ((IndCatYearMonth)currentControl).AddValidators(GetPropertyName(entityProperty));
                    }
                    else
                    {
                        //RequiredFieldValidator
                        RequiredFieldValidator requiredValidator = new RequiredFieldValidator();
                        requiredValidator.ID = "RequiredValidator" + currentControl.UniqueID;
                        requiredValidator.ControlToValidate = currentControl.ID;
                        if (currentControl is IndDatePicker)
                        {
                            requiredValidator.InitialValue = ApplicationConstants.MIN_DATE_CATALOGS;
                        }
                        requiredValidator.Display = ValidatorDisplay.Dynamic;
                        requiredValidator.Text = "*";
                        requiredValidator.ForeColor = IndConstants.ColorValidator;
                        requiredValidator.ErrorMessage = GetPropertyName(entityProperty) + " is required.";
                        this.Controls.AddAt(this.Controls.IndexOf(currentControl) + 1, requiredValidator);
                    }
                }
                else
                {
                    lblRequired.ForeColor = IndConstants.ColorValidator;
                }
                this.Controls.AddAt(this.Controls.IndexOf(currentControl), lblRequired);

                //If the property must be in a range, add a RangeValidator
                if (validationAttribute.MinValue != int.MaxValue || validationAttribute.MaxValue != int.MinValue)
                {
                    //RangeValidator
                    RangeValidator rangeValidator = new RangeValidator();
                    rangeValidator.ID = "RangeValidator" + currentControl.UniqueID;
                    rangeValidator.ControlToValidate = currentControl.ID;
                    rangeValidator.MinimumValue = validationAttribute.MinValue.ToString();
                    rangeValidator.MaximumValue = validationAttribute.MaxValue.ToString();
                    rangeValidator.Type = ValidationDataType.Integer;
                    if (entityProperty.PropertyType == typeof(double) || entityProperty.PropertyType == typeof(decimal))
                    {
                        rangeValidator.Type = ValidationDataType.Double;
                    }
                    rangeValidator.Display = ValidatorDisplay.Dynamic;
                    rangeValidator.Text = "*";
                    rangeValidator.ForeColor = IndConstants.ColorValidator;
                    rangeValidator.ErrorMessage = "Field " + GetPropertyName(entityProperty) + " not in the correct range (" + rangeValidator.MinimumValue + ", " + rangeValidator.MaximumValue + ").";
                    this.Controls.AddAt(this.Controls.IndexOf(currentControl) + 1, rangeValidator);
                }
                //If the property has a maximum length, add a RegularExpressionValidator
                if (validationAttribute.MaxLength != int.MinValue)
                {
                    if (currentControl is IndTextBox)
                    {
                        ((IndTextBox)currentControl).MaxLength = validationAttribute.MaxLength;
                    }
                    //RegularExpressionValidator
                    RegularExpressionValidator regValidator = new RegularExpressionValidator();
                    regValidator.ID = "RegValidator" + currentControl.UniqueID;
                    regValidator.ControlToValidate = currentControl.ID;
                    //Set the regular expression
                    regValidator.ValidationExpression = ".{0," + validationAttribute.MaxLength + "}";
                    regValidator.Display = ValidatorDisplay.Dynamic;
                    regValidator.Text = "*";
                    regValidator.ForeColor = IndConstants.ColorValidator;
                    regValidator.ErrorMessage = "Field " + GetPropertyName(entityProperty) + " exceeds maximum allowed length (" + validationAttribute.MaxLength + " character(s)).";
                    this.Controls.AddAt(this.Controls.IndexOf(currentControl) + 1, regValidator);
                }
            }
            else //We do not have a validation attribute
            {
                //Put a invisible label in front of the control
                IndLabel lblRequired = new IndLabel();
                lblRequired.Text = " *";
                lblRequired.ForeColor = IndConstants.ColorValidator;
                this.Controls.AddAt(this.Controls.IndexOf(currentControl), lblRequired);
            }
        }

        /// <summary>
        /// Gets an array of PropertyInfo objects containing information about the properties of the entity
        /// </summary>
        /// <returns>An array of PropertyInfo objects containing information about the properties of the entity</returns>
        private PropertyInfo[] GetEntityProperties()
        {
            if (_Entity == null)
                throw new IndException(ApplicationMessages.EXCEPTION_MUST_SET_ENTITY_PROPERTY);
            Type entityType = _Entity.GetType();
            return entityType.GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.DeclaredOnly);
        }

        /// <summary>
        /// Sets the enabled property of each textbox, depending on whether we are adding or editing an entity
        /// </summary>
        /// <param name="entityId">the id of the entity which is -1 if it is being added</param>
        private void SetTextBoxesStates()
        {
            foreach (Control ctl in this.Controls)
            {
                if (ctl is IGenericCatWebControl && ctl is WebControl)
                {
                    ((WebControl)ctl).Enabled = (!_EditMode) ? ((IGenericCatWebControl)ctl).EnabledOnNew : ((IGenericCatWebControl)ctl).EnabledOnEdit;
                    ((WebControl)ctl).Visible = (!_EditMode) ? ((IGenericCatWebControl)ctl).VisibleOnNew : ((IGenericCatWebControl)ctl).VisibleOnEdit;
                }
            }
        }

        private void CreateControlLayout()
        {
            Dictionary<string, string> entityMapping = (Dictionary<string, string>)SessionManager.GetSessionValueNoRedirect(this.Page, SessionStrings.ENTITY_MAPPING);
            string catalogueName = entityMapping[Entity.GetType().Name].Replace("Catalogue", "");
            Page.Title = (!_EditMode) ? "Add " + catalogueName : "Edit " + catalogueName;

            lblTitle = new IndLabel();
            lblTitle.CssClass = CSSStrings.TitleLabelCssClass;
            lblTitle.Text = Page.Title;

            SetTextBoxesStates();

            btnSave.ID = "SaveButton";
            btnSave.Attributes.Add("OnClick", "ClearOnBeforeUnload();");
            btnSave.ToolTip = "Save";
            //btnSave.CssClass = "SaveButton";
            btnSave.ImageUrl = "~/Images/button_save.png";
            btnSave.ImageUrlOver = "~/Images/button_save.png";
            btnSave.Click += new ImageClickEventHandler(btnSave_Click);

            btnCancel.ID = "CancelButton";
            btnCancel.CausesValidation = false;
            btnCancel.Attributes.Add("OnClick", "CheckDirty();");
            btnCancel.Attributes.Add("class", "CancelButton");
            btnCancel.Attributes.Add("title", "Cancel");
        }

        private void FillEntityDataFromDB()
        {
            if (_EditMode)
            {
                DataRow row = _Entity.SelectEntity();
                this._Entity = EntityFactory.GetEntityInstance(_Entity.GetType(), row, SessionManager.GetSessionValueNoRedirect((IndPopUpBasePage)this.Page, SessionStrings.CONNECTION_MANAGER));
            }
        }


        private string GetPropertyName(PropertyInfo entityProperty)
        {
            string propertyName = string.Empty;
            object[] nameAttributes = entityProperty.GetCustomAttributes(typeof(DesignerNameAttribute), false);
            if (nameAttributes.Length == 1)
            {
                propertyName = ((DesignerNameAttribute)nameAttributes[0]).Name;
            }
            else
            {
                propertyName = entityProperty.Name;
            }
            return propertyName;
        }
        #endregion Private Methods


        private void ClearCombos(Control control)
        {
            if (control is RadComboBox)
            {
                ((RadComboBox)control).Items.Clear();
                return;
            }

            //call recursivelly
            foreach (Control controlInside in control.Controls)
            {
                ClearCombos(controlInside);
            }
        }
    }
}

