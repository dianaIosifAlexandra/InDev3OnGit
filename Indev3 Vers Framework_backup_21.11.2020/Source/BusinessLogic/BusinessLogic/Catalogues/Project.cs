using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.ApplicationFramework.Attributes;
using System.Data;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;


namespace Inergy.Indev3.BusinessLogic.Catalogues
{
    /// <summary>
    /// Represents the Project entity
    /// </summary>
    public class Project : GenericEntity, IProject
    {
        #region IProject Members
        
        private int _IdProjectType;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(ProjectType))]
        [DesignerName("Project Type")]
        public int IdProjectType
        {
            get
            {
                return _IdProjectType;
            }
            set
            {
                _IdProjectType = value;
            }
        }
        private string _ProjectType;
        [PropertyValidation(true, 20)]
        [GridColumnProperty("Project Type")]
        public string ProjectType
        {
            get
            {
                return _ProjectType;
            }
            set
            {
                _ProjectType = value;
            }
        }
        private int _IdProgram;
        [PropertyValidation(true)]
        [GridColumnProperty(false)]
        [ReferenceMapping(typeof(ActiveProgram))]
        [DesignerName("Program")]
        public int IdProgram
        {
            get
            {
                return _IdProgram;
            }
            set
            {
                _IdProgram = value;
            }
        }
        private string _ProgramName;
        [PropertyValidation(true, 50)]
        [GridColumnProperty(false)]
        public string ProgramName
        {
            get
            {
                return _ProgramName;
            }
            set
            {
                _ProgramName = value;
            }
        }
        private string _ProgramCode;
        [PropertyValidation(true, 10)]
        [GridColumnProperty("Program Code")]
        public string ProgramCode
        {
            get
            {
                return _ProgramCode;
            }
            set
            {
                _ProgramCode = value;
            }
        }
        private bool _IsActive;
        [PropertyValidation(true)]
        [GridColumnProperty("Active")]
        public bool IsActive
        {
            get
            {
                return _IsActive;
            }
            set
            {
                _IsActive = value;
            }
        }
        private int _ActiveMembers;
        [PropertyValidation(true, 10)]
        [GridColumnProperty("Active Members")]
        public int ActiveMembers
        {
            get
            {
                return _ActiveMembers;
            }
            set
            {
                _ActiveMembers = value;
            }
        }
        private int _TimingIntercoPercent;
        [PropertyValidation(true, 10)]
        [GridColumnProperty("Timing & Interco %")]
        public int TimingIntercoPercent
        {
            get
            {
                return _TimingIntercoPercent;
            }
            set
            {
                _TimingIntercoPercent = value;
            }
        }
        private bool _IsInitialBudgetValidated;
        [PropertyValidation(true)]
        [GridColumnProperty("Initial Budget Valid.")]
        public bool IsInitialBudgetValidated
        {
            get
            {
                return _IsInitialBudgetValidated;
            }
            set
            {
                _IsInitialBudgetValidated = value;
            }
        }
        private string _Name;
        [PropertyValidation(true, 30)]
        [GridColumnProperty("Name")]
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
        [PropertyValidation(true, 10)]
        [GridColumnProperty("Code")]
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

        private string _CodeName;
        [PropertyValidation(true, 50)]
        [GridColumnProperty(false)]
        public string CodeName
        {
            get
            {
                return _CodeName;
            }
            set
            {
                _CodeName = value;
            }
        }

        private int _IdAssociate;
        [GridColumnProperty(false)]
        public int IdAssociate
        {
            get { return _IdAssociate; }
            set { _IdAssociate = value; }
        }

        private bool _UseWorkPackageTemplate;
        [PropertyValidation(false)]
        [GridColumnProperty("Use Work Package Template")]
        public bool UseWorkPackageTemplate
        {
            get
            {
                return _UseWorkPackageTemplate;
            }
            set
            {
                _UseWorkPackageTemplate = value;
            }
        }


        private int _HasActualData = 0;
        [GridColumnProperty(false)]
        public int HasActualData
        {
            get { return _HasActualData; }
            set
            {
                _HasActualData = value;
            }
        }

        #endregion

        #region Constructors
        public Project()
            : this(null)
        {

        }
        public Project(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBProject(connectionManager));
            _IdProjectType = ApplicationConstants.INT_NULL_VALUE;
            _IdProgram = ApplicationConstants.INT_NULL_VALUE;
            _IdAssociate = ApplicationConstants.INT_NULL_VALUE;
            _IsActive = true;
            _UseWorkPackageTemplate = true;
        }

        public Project(DataRow row, object connectionManager)
            : this(connectionManager)
        {
            try
            {
                Row2Object(row);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
        #endregion

        protected override void Row2Object(DataRow row)
        {
            this.Id = (int)row["Id"];
            this.IdProjectType = (int)row["IdProjectType"];
            this.ProjectType = row["ProjectType"].ToString();
            this.IdProgram = (int)row["IdProgram"];
            this.ProgramName = row["ProgramName"].ToString();
            this.IsActive = (bool)row["IsActive"];
            this.ActiveMembers = (int)row["ActiveMembers"];
            this.TimingIntercoPercent = (int)row["TimingIntercoPercent"];
            this.IsInitialBudgetValidated = (bool)row["IsInitialBudgetValidated"];
            this.Name = row["Name"].ToString();
            this.Code = row["Code"].ToString();
            this.HasActualData = (int)row["HasActualData"];
        }
        protected override DataSet PostGetEntities(DataSet ds)
        {
            DSUtils.ReplaceBooleanColumn("IsActive", ds, 0);
            DSUtils.ReplaceBooleanColumn("IsInitialBudgetValidated", ds, 0);
            
            DataColumn newProjectCodeName = new DataColumn("CodeName", typeof(string));
            ds.Tables[0].Columns.Add(newProjectCodeName);

            //transform the null values for StartYearMonth and EndYearMonth
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                //Set column Project
                row["CodeName"] = row["Code"] + " - " + row["Name"];
            }           
            return ds;
        }
    }
}
