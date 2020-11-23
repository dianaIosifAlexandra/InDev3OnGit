using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NUnit.Framework;

using Inergy.Indev3.DataAccess;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccessTests;



namespace Inergy.Indev3.DataAccessTests.Budget
{
    [TestFixture]
    public class DBCurrentProjectTest : BaseTest
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

        public DataSet SelectCurrentProjectTest(ICurrentProject currentProject, DBGenericEntity dbGenericEntity)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbGenericEntity.SelectObject(currentProject) as DataSet;
            return tableVerify;

        }
        [Test]
        public void VerifyCurrentProject()
        {
            Random random = new Random();

            DBGenericEntity dbCurrentProjectEntity = new DBCurrentProject(connManager);;
            ICurrentProject currentProject = BusinessObjectInitializer.CreateCurrentProject();

            currentProject.IdAssociate = DATestUtils.DEFAULT_ASSOCIATE;
            currentProject.IdOwner = DATestUtils.DEFAULT_ENTITY_ID;


            DataTable tableVerify = SelectCurrentProjectTest(currentProject, dbCurrentProjectEntity).Tables[0];
            //Verifies that the table is not null
            Assert.IsNotNull(tableVerify, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerify, 0, "ProjectId");
            DATestUtils.CheckColumn(tableVerify, 1, "ProjectName");
            DATestUtils.CheckColumn(tableVerify, 2, "ProgramName");
            DATestUtils.CheckColumn(tableVerify, 3, "ProjectFunction");
            DATestUtils.CheckColumn(tableVerify, 4, "ProgramId");
            DATestUtils.CheckColumn(tableVerify, 5, "ProjectFunctionId");
            DATestUtils.CheckColumn(tableVerify, 6, "OwnerId");
            DATestUtils.CheckColumn(tableVerify, 7, "ProgramCode");
            DATestUtils.CheckColumn(tableVerify, 8, "ProjectCode");
        }
    }
}
