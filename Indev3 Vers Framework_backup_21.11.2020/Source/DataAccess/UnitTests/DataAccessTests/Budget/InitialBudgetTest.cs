using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NUnit.Framework;

using Inergy.Indev3.DataAccess;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess.Catalogues;

namespace Inergy.Indev3.DataAccessTests.Budget
{
    [TestFixture]
    public class DBInitialBudgetTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        /// <summary>
        /// This method is used for inserting an object into the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the insert should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        private int InsertInitialBudgetMasterTest(IInitialBudget initialBudget, DBGenericEntity dbGenericEntity)
        {

            int rowCount = dbGenericEntity.ExecuteCustomProcedure("InsertIntialBudgetMaster", initialBudget);
            return rowCount;
        }
        private int InsertInitialBudgetTest(IInitialBudget initialBudget, DBGenericEntity dbGenericEntity)
        {
            initialBudget.Id = dbGenericEntity.InsertObject(initialBudget);
            return initialBudget.Id;

        }
        /// <summary>
        /// This method is used for updating an object into the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the update should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        private int UpdateInitialBudgetTest(IInitialBudget initialBudget, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.UpdateObject(initialBudget);
            return rowCount;
        }
        /// <summary>
        /// This method is used for selecting an object from the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the select should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        public DataSet SelectInitialBudgetTest(IInitialBudget initialBudget, DBGenericEntity dbGenericEntity)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbGenericEntity.SelectObject(initialBudget) as DataSet;
            return tableVerify;
        }
        /// <summary>
        /// This method is used for deleting an object from the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the delete should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        private int DeleteInitialBudgetTest(IInitialBudget initialBudget, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.DeleteObject(initialBudget);
            return rowCount;
        }

        public int InsertCostCenterTest(ICostCenter costCenter, DBGenericEntity dbGenericEntity)
        {
            costCenter.Id = dbGenericEntity.InsertObject(costCenter);
            return costCenter.Id;

        }

        public int DeleteCostCenterTest(ICostCenter costCenter, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.DeleteObject(costCenter);
            return rowCount;
        }

        public int InsertWorkPackageTest(IWorkPackage workPackage, DBGenericEntity dbGenericEntity)
        {
            workPackage.Id = dbGenericEntity.InsertObject(workPackage);
            return workPackage.Id;

        }
        public int DeleteWorkPackageTest(IWorkPackage workPackage, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.DeleteObject(workPackage);
            return rowCount;
        }

        public int InsertProjectTest(IProject project, DBGenericEntity dbGenericEntity)
        {
            project.Id = dbGenericEntity.InsertObject(project);
            return project.Id;

        }

        public int DeleteProjectTest(IProject project, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.DeleteObject(project);
            return rowCount;
        }

        public DataSet SelectProjectCoreTeamMemberTest(IProjectCoreTeamMember projectCoreTeamMember, DBProjectCoreTeamMember dbGenericEntity)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbGenericEntity.SelectObject(projectCoreTeamMember) as DataSet;
            return tableVerify;

        }
        public int InsertProjectCoreTeamMemberTest(IProjectCoreTeamMember projectCoreTeamMember, DBProjectCoreTeamMember dbGenericEntity)
        {
            projectCoreTeamMember.Id = dbGenericEntity.InsertObject(projectCoreTeamMember);
            return projectCoreTeamMember.Id;

        }
        public int DeleteProjectCoreTeamMemberTest(IProjectCoreTeamMember projectCoreTeamMember, DBProjectCoreTeamMember dbGenericEntity)
        {
            int rowCount = dbGenericEntity.DeleteObject(projectCoreTeamMember);
            return rowCount;
        }
        [Test]
        [Category("COMPLEX")]
        public void VerifyInitialBudget()
        {
            IInitialBudget initialBudget = BusinessObjectInitializer.CreateInitialBudget();
            ICostCenter costCenter = BusinessObjectInitializer.CreateCostCenter();
            IWorkPackage workPackage = BusinessObjectInitializer.CreateWorkPackage();
            IProject project = BusinessObjectInitializer.CreateProject();
            IProjectCoreTeamMember coreTeamMembers = BusinessObjectInitializer.CreateProjectCoreTeamMember();

            DBInitialBudget dbInitialBudget = new DBInitialBudget(connManager);
            DBGenericEntity dbCostCenterEntity = new DBCostCenter(connManager);
            DBGenericEntity dbWorkPackageEntity = new DBWorkPackage(connManager);
            DBGenericEntity dbProjectEntity = new DBProject(connManager);
            DBProjectCoreTeamMember dbCoreteamMember = new DBProjectCoreTeamMember(connManager);

            Random random = new Random();
            
            initialBudget.IdAssociate = DATestUtils.DEFAULT_ASSOCIATE;
            initialBudget.IdPhase = random.Next(1, 9);
            costCenter.Id = random.Next(1000, 2000);
            costCenter.Name = DATestUtils.GenerateString(50, true, false);
            costCenter.Code = DATestUtils.GenerateString(10, true, true);
            costCenter.IdDepartment = random.Next(1, 1);
            costCenter.IdInergyLocation = random.Next(1, 2);
            costCenter.IsActive = true;
            
            workPackage.IdPhase = initialBudget.IdPhase;
            workPackage.Code = DATestUtils.GenerateString(3, true, true);
            workPackage.Name = DATestUtils.GenerateString(30, true, false);
            workPackage.Rank = random.Next(1, 100);
            workPackage.IsActive = true;
            workPackage.StartYearMonth = random.Next(2000, 2079) * 100 + random.Next(1, 12);
            workPackage.EndYearMonth = random.Next(2000, 2079) * 100 + random.Next(1, 12);
            workPackage.LastUpdate = DateTime.Today;
            workPackage.IdLastUserUpdate = DATestUtils.DEFAULT_ASSOCIATE;
            project.Name = DATestUtils.GenerateString(50, true, false);
            project.Code = DATestUtils.GenerateString(10, true, true);
            project.IdProgram = random.Next(1, 2);
            project.IdProjectType = random.Next(1, 2);
            project.IsActive = true;
            
            initialBudget.Sales = random.Next(50000, 1000000);
            initialBudget.TotalHours = random.Next(1, 100);
            initialBudget.ValuedHours = random.Next(1, 100);
            initialBudget.YearMonth = DATestUtils.DEFAULT_YEAR_MONTH;

            int newId = InsertCostCenterTest(costCenter, dbCostCenterEntity);
            //Verifies that the id returned by the insert method is greater than 0
            Assert.Greater(newId, 0);
            initialBudget.IdCostCenter = newId;

            newId = InsertProjectTest(project, dbProjectEntity);
            //Verifies that the id returned by the insert method is greater than 0
            Assert.Greater(newId, 0);
            initialBudget.IdProject = newId;
            workPackage.IdProject = initialBudget.IdProject;
            coreTeamMembers.IdProject = initialBudget.IdProject;
                        
            newId = InsertWorkPackageTest(workPackage, dbWorkPackageEntity);
            //Verifies that the id returned by the insert method is greater than 0
            Assert.Greater(newId, 0);
            initialBudget.IdWP = newId;

            InsertInitialBudgetMasterTest(initialBudget, dbInitialBudget);

            coreTeamMembers.IdAssociate = DATestUtils.DEFAULT_ASSOCIATE;
            coreTeamMembers.IdFunction = DATestUtils.DEFAULT_PROJECT_FUNCTION;
            
            //verify if have core team member
            DataTable dsCoreMember =  SelectProjectCoreTeamMemberTest(coreTeamMembers, dbCoreteamMember).Tables[0];
            if (dsCoreMember.Rows.Count == 0)
            {
                int IdCoreteammember = InsertProjectCoreTeamMemberTest(coreTeamMembers, dbCoreteamMember);
            }

            InsertInitialBudgetTest(initialBudget, dbInitialBudget);
            
            UpdateInitialBudgetTest(initialBudget, dbInitialBudget);

            DBWPPreselection tempTable = new DBWPPreselection(connManager);
            tempTable.BulkInsert("CREATE TABLE #BUDGET_PRESELECTION_TEMP (IdProject INT NOT NULL, IdPhase INT NOT NULL, IdWP INT NOT NULL)");
            tempTable.BulkInsert("INSERT  INTO #BUDGET_PRESELECTION_TEMP (IdProject,IdPhase,IdWP) VALUES (" + initialBudget.IdProject.ToString() + "," + initialBudget.IdPhase.ToString() + "," + initialBudget.IdWP.ToString() + ")");
            
            DataSet InitialBudgetDS = SelectInitialBudgetTest(initialBudget, dbInitialBudget);
            //Verifies that the table is not null
            DataTable tableVerifyPhases = InitialBudgetDS.Tables[0];
            DataTable tableVerifyWorkPackages = InitialBudgetDS.Tables[1];
            DataTable tableVerifyCostCenters = InitialBudgetDS.Tables[2];
            Assert.IsNotNull(tableVerifyPhases, "The table returned should not be null");
            Assert.IsNotNull(tableVerifyWorkPackages, "The table returned should not be null");
            Assert.IsNotNull(tableVerifyCostCenters, "The table returned should not be null");
            //Verifies that the first table is not null
            Assert.IsNotNull(tableVerifyPhases, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyPhases, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyPhases, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyPhases, 2, "PhaseName");
            DATestUtils.CheckColumn(tableVerifyPhases, 3, "TotalHours");
            DATestUtils.CheckColumn(tableVerifyPhases, 4, "Averate");
            DATestUtils.CheckColumn(tableVerifyPhases, 5, "ValuedHours");
            DATestUtils.CheckColumn(tableVerifyPhases, 6, "OtherCosts");
            DATestUtils.CheckColumn(tableVerifyPhases, 7, "Sales");
            DATestUtils.CheckColumn(tableVerifyPhases, 8, "NetCosts");
            //Verifies that the second table is not null
            Assert.IsNotNull(tableVerifyWorkPackages, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 2, "IdWP");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 3, "WPName");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 4, "StartYearMonth");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 5, "EndYearMonth");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 6, "TotalHours");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 7, "Averate");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 8, "ValuedHours");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 9, "OtherCosts");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 10, "Sales");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 11, "NetCosts");
            //Verifies that the third table is not null
            Assert.IsNotNull(tableVerifyWorkPackages, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyCostCenters, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 2, "IdWP");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 3, "IdCostCenter");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 4, "CostCenterName");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 5, "TotalHours");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 6, "Averate");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 7, "ValuedHours");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 8, "OtherCosts");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 9, "Sales");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 10, "NetCosts");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 11, "IdCurrency");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 12, "CurrencyCode");

            DeleteInitialBudgetTest(initialBudget, dbInitialBudget);
            
            int rowCount = DeleteCostCenterTest(costCenter, dbCostCenterEntity);
            //Verifies that one and only one row is affected by the delete
            Assert.AreEqual(1, rowCount);

            rowCount = DeleteWorkPackageTest(workPackage, dbWorkPackageEntity);
            //Verifies that one and only one row is affected by the delete
            Assert.AreEqual(1, rowCount);

            //Verifies that one and only one row is affected by the delete
            rowCount = DeleteProjectCoreTeamMemberTest(coreTeamMembers, dbCoreteamMember);
            Assert.AreEqual(1, rowCount);

            rowCount = DeleteProjectTest(project, dbProjectEntity);
            //Verifies that one and only one row is affected by the delete
            Assert.AreEqual(1, rowCount);


        }
    }
}
