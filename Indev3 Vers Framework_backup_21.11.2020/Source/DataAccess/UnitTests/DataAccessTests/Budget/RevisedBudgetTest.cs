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
    public class DBRevisedBudgetTest : BaseTest
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
        private int InsertRevisedBudgetMasterTest(IRevisedBudget revisedBudget, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.ExecuteCustomProcedure("InsertRevisedBudgetMaster", revisedBudget);
            return rowCount;
        }
        private int InsertRevisedBudgetTest(IRevisedBudget revisedBudget, DBGenericEntity dbGenericEntity)
        {
            revisedBudget.Id = dbGenericEntity.InsertObject(revisedBudget);
            return revisedBudget.Id;

        }
        /// <summary>
        /// This method is used for updating an object into the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the update should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        private int UpdateRevisedBudgetTest(IRevisedBudget revisedBudget, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.UpdateObject(revisedBudget);
            return rowCount;
        }
        /// <summary>
        /// This method is used for selecting an object from the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the select should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        public DataSet SelectRevisedBudgetHoursTest(IRevisedBudget revisedBudget, DBGenericEntity dbGenericEntity)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbGenericEntity.GetCustomDataSet("GetRevisedBudgetHours", revisedBudget) as DataSet;
            return tableVerify;

        }
        public DataSet SelectRevisedBudgetCostsTest(IRevisedBudget revisedBudget, DBGenericEntity dbGenericEntity)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbGenericEntity.GetCustomDataSet("GetRevisedBudgetCosts", revisedBudget) as DataSet;
            return tableVerify;
        }
        /// <summary>
        /// This method is used for deleting an object from the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the delete should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        private int DeleteRevisedBudgetTest(IRevisedBudget revisedBudget, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.DeleteObject(revisedBudget);
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
        public int ValidateBudget(IFollowUpInitialBudget followUpBudegt, DBFollowUpInitialBudget dbFollowup)
        {
            int x = dbFollowup.ExecuteCustomProcedure("ValidateInitialBudget", followUpBudegt);
            return 1;
        }
        public int ValidateRevisedbudget(IFollowUpRevisedBudget followUpRevisedBudget, DBFollowUpRevisedBudget dbFollowUpRevisedBudget)
        {
            int rowCount = dbFollowUpRevisedBudget.ExecuteCustomProcedure("ValidateRevisedBudget", followUpRevisedBudget);
            return rowCount;
        }
        private int DeleteInitialBudgetTest(IInitialBudget initialBudget, DBGenericEntity dbGenericEntity)
        {
            int rowCount = dbGenericEntity.DeleteObject(initialBudget);
            return rowCount;
        }
        
        [Test]
        [Category("COMPLEX")]
        public void VerifyRevisedBudget()
        {
            IRevisedBudget revisedBudget = BusinessObjectInitializer.CreateRevisedBudget();
            ICostCenter costCenter = BusinessObjectInitializer.CreateCostCenter();
            IWorkPackage workPackage = BusinessObjectInitializer.CreateWorkPackage();
            IProject project = BusinessObjectInitializer.CreateProject();
            IInitialBudget initialBudget = BusinessObjectInitializer.CreateInitialBudget();
            IProjectCoreTeamMember coreTeamMembers = BusinessObjectInitializer.CreateProjectCoreTeamMember();
            IFollowUpInitialBudget followUpBudegt = BusinessObjectInitializer.CreateValidateBudget();
            

            DBRevisedBudget dbRevisedBudget = new DBRevisedBudget(connManager);
            DBGenericEntity dbCostCenterEntity = new DBCostCenter(connManager);
            DBGenericEntity dbWorkPackageEntity = new DBWorkPackage(connManager);
            DBGenericEntity dbProjectEntity = new DBProject(connManager);
            DBInitialBudget dbInitialBudget = new DBInitialBudget(connManager);
            DBProjectCoreTeamMember dbCoreteamMember = new DBProjectCoreTeamMember(connManager);

            DBFollowUpInitialBudget dbFollowUpBudget = new DBFollowUpInitialBudget(connManager);

            IFollowUpRevisedBudget followUpRevisedBudget = BusinessObjectInitializer.ValidateFollowUpRevisedBudget();
            DBFollowUpRevisedBudget dbFollowUpRevisedBudget = new DBFollowUpRevisedBudget(connManager);

            Random random = new Random();
                       
            revisedBudget.IdAssociate = DATestUtils.DEFAULT_ASSOCIATE;
            revisedBudget.IdPhase = random.Next(1, 9);
            costCenter.Id = random.Next(1000, 2000);
            costCenter.Name = DATestUtils.GenerateString(50, true, false);
            costCenter.Code = DATestUtils.GenerateString(10, true, true);
            costCenter.IdDepartment = random.Next(1, 1);
            costCenter.IdInergyLocation = random.Next(1, 2);
            costCenter.IsActive = true;
            workPackage.IdPhase = revisedBudget.IdPhase;
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
            revisedBudget.NewCosts = random.Next(50000, 1000000);
            revisedBudget.NewHours = random.Next(1, 100);
            revisedBudget.NewSales = random.Next(50000, 1000000);
            revisedBudget.NewVal = random.Next(1, 100);
            revisedBudget.UpdateCosts = random.Next(50000, 1000000);
            revisedBudget.UpdateHours = random.Next(1, 100);
            revisedBudget.UpdateSales = random.Next(50000, 1000000);
            revisedBudget.UpdateVal = random.Next(1, 100);
            revisedBudget.YearMonth = DATestUtils.DEFAULT_YEAR_MONTH;

            int newId = InsertCostCenterTest(costCenter, dbCostCenterEntity);
            //Verifies that the id returned by the insert method is greater than 0
            Assert.Greater(newId, 0);
            initialBudget.IdCostCenter = newId;
            revisedBudget.IdCostCenter = initialBudget.IdCostCenter;

            newId = InsertProjectTest(project, dbProjectEntity);
            //Verifies that the id returned by the insert method is greater than 0
            Assert.Greater(newId, 0);
            revisedBudget.IdProject = newId;
            workPackage.IdProject = revisedBudget.IdProject;
            initialBudget.IdProject = newId;
            coreTeamMembers.IdProject = newId;
            followUpBudegt.IdProject = newId;
            followUpRevisedBudget.IdProject = revisedBudget.IdProject;

            newId = InsertWorkPackageTest(workPackage, dbWorkPackageEntity);
            //Verifies that the id returned by the insert method is greater than 0
            Assert.Greater(newId, 0);
            revisedBudget.IdWP = newId;
            initialBudget.IdWP = newId;




            initialBudget.IdAssociate = DATestUtils.DEFAULT_ASSOCIATE;
            initialBudget.IdPhase = revisedBudget.IdPhase;
            initialBudget.Sales = random.Next(50000, 1000000);
            initialBudget.TotalHours = random.Next(1, 100);
            initialBudget.ValuedHours = random.Next(1, 100);
            initialBudget.YearMonth = DATestUtils.DEFAULT_YEAR_MONTH;
            //initialBudget.IdCostCenter = random.Next(1000, 2000);

            InsertInitialBudgetMasterTest(initialBudget, dbInitialBudget);

            coreTeamMembers.IdAssociate = DATestUtils.DEFAULT_ASSOCIATE;
            coreTeamMembers.IdFunction = DATestUtils.DEFAULT_PROJECT_FUNCTION;

            //verify if have core team member
            DataTable dsCoreMember = SelectProjectCoreTeamMemberTest(coreTeamMembers, dbCoreteamMember).Tables[0];
            if (dsCoreMember.Rows.Count == 0)
            {
                int IdCoreteammember = InsertProjectCoreTeamMemberTest(coreTeamMembers, dbCoreteamMember);
            }
            InsertInitialBudgetTest(initialBudget, dbInitialBudget);
            ValidateBudget(followUpBudegt, dbFollowUpBudget);
            //revisedBudget.IdCostCenter = random.Next(1000, 2000);

            followUpRevisedBudget.BudVersion = "N";
            ValidateRevisedbudget(followUpRevisedBudget, dbFollowUpRevisedBudget);

            InsertRevisedBudgetMasterTest(revisedBudget, dbRevisedBudget);
           // InsertRevisedBudgetTest(revisedBudget, dbRevisedBudget);
            
            
            UpdateRevisedBudgetTest(revisedBudget, dbRevisedBudget);

            DBWPPreselection tempTable = new DBWPPreselection(connManager);
            tempTable.BulkInsert("CREATE TABLE #BUDGET_PRESELECTION_TEMP (IdProject INT NOT NULL, IdPhase INT NOT NULL, IdWP INT NOT NULL)");
            tempTable.BulkInsert("INSERT  INTO #BUDGET_PRESELECTION_TEMP (IdProject,IdPhase,IdWP) VALUES (" + revisedBudget.IdProject.ToString() + "," + revisedBudget.IdPhase.ToString() + "," + revisedBudget.IdWP.ToString() + ")");

            DataSet RevisedBudgetHoursDS = SelectRevisedBudgetHoursTest(revisedBudget, dbRevisedBudget);
            //Verifies that the table is not null
            DataTable tableVerifyPhases = RevisedBudgetHoursDS.Tables[0];
            DataTable tableVerifyWorkPackages = RevisedBudgetHoursDS.Tables[1];
            DataTable tableVerifyCostCenters = RevisedBudgetHoursDS.Tables[2];
            Assert.IsNotNull(tableVerifyPhases, "The table returned should not be null");
            Assert.IsNotNull(tableVerifyWorkPackages, "The table returned should not be null");
            Assert.IsNotNull(tableVerifyCostCenters, "The table returned should not be null");
            //Verifies that the first table is not null
            Assert.IsNotNull(tableVerifyPhases, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyPhases, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyPhases, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyPhases, 2, "PhaseName");
            DATestUtils.CheckColumn(tableVerifyPhases, 3, "CurrentHours");
            DATestUtils.CheckColumn(tableVerifyPhases, 4, "UpdateHours");
            DATestUtils.CheckColumn(tableVerifyPhases, 5, "NewHours");
            DATestUtils.CheckColumn(tableVerifyPhases, 6, "CurrentVal");
            DATestUtils.CheckColumn(tableVerifyPhases, 7, "UpdateVal");
            DATestUtils.CheckColumn(tableVerifyPhases, 8, "NewVal");
            //Verifies that the second table is not null
            Assert.IsNotNull(tableVerifyWorkPackages, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 2, "IdWP");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 3, "WPName");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 4, "StartYearMonth");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 5, "EndYearMonth");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 6, "CurrentHours");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 7, "UpdateHours");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 8, "NewHours");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 9, "CurrentVal");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 10, "UpdateVal");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 11, "NewVal");
            //Verifies that the third table is not null
            Assert.IsNotNull(tableVerifyWorkPackages, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyCostCenters, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 2, "IdWP");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 3, "IdCostCenter");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 4, "CostCenterName");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 5, "CurrentHours");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 6, "UpdateHours");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 7, "NewHours");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 8, "CurrentVal");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 9, "UpdateVal");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 10, "NewVal");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 11, "IdCurrency");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 12, "CurrencyCode");

            DataSet RevisedBudgetCostsDS = SelectRevisedBudgetCostsTest(revisedBudget, dbRevisedBudget);
            //Verifies that the table is not null
            tableVerifyPhases = RevisedBudgetCostsDS.Tables[0];
            tableVerifyWorkPackages = RevisedBudgetCostsDS.Tables[1];
            tableVerifyCostCenters = RevisedBudgetCostsDS.Tables[2];
            //Verifies that the first table is not null
            Assert.IsNotNull(tableVerifyPhases, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyPhases, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyPhases, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyPhases, 2, "PhaseName");
            DATestUtils.CheckColumn(tableVerifyPhases, 3, "CurrentCost");
            DATestUtils.CheckColumn(tableVerifyPhases, 4, "UpdateCost");
            DATestUtils.CheckColumn(tableVerifyPhases, 5, "NewCost");
            DATestUtils.CheckColumn(tableVerifyPhases, 6, "CurrentSales");
            DATestUtils.CheckColumn(tableVerifyPhases, 7, "UpdateSales");
            DATestUtils.CheckColumn(tableVerifyPhases, 8, "NewSales");
            //Verifies that the second table is not null
            Assert.IsNotNull(tableVerifyWorkPackages, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 2, "IdWP");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 3, "WPName");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 4, "StartYearMonth");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 5, "EndYearMonth");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 6, "CurrentCost");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 7, "UpdateCost");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 8, "NewCost");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 9, "CurrentSales");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 10, "UpdateSales");
            DATestUtils.CheckColumn(tableVerifyWorkPackages, 11, "NewSales");
            //Verifies that the third table is not null
            Assert.IsNotNull(tableVerifyWorkPackages, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerifyCostCenters, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 1, "IdPhase");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 2, "IdWP");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 3, "IdCostCenter");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 4, "CostCenterName");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 5, "CurrentCost");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 6, "UpdateCost");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 7, "NewCost");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 8, "CurrentSales");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 9, "UpdateSales");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 10, "NewSales");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 11, "IdCurrency");
            DATestUtils.CheckColumn(tableVerifyCostCenters, 12, "CurrencyCode");

            DeleteRevisedBudgetTest(revisedBudget, dbRevisedBudget);
            DeleteInitialBudgetTest(initialBudget, dbInitialBudget);
            //int rowCount = DeleteCostCenterTest(costCenter, dbCostCenterEntity);
            ////Verifies that one and only one row is affected by the delete
            //Assert.AreEqual(1, rowCount);

            
           //int rowCount = DeleteWorkPackageTest(workPackage, dbWorkPackageEntity);
           // //Verifies that one and only one row is affected by the delete
           // Assert.AreEqual(1, rowCount);

           // rowCount = DeleteProjectTest(project, dbProjectEntity);
           // //Verifies that one and only one row is affected by the delete
           // Assert.AreEqual(1, rowCount);
        }
    }
}
