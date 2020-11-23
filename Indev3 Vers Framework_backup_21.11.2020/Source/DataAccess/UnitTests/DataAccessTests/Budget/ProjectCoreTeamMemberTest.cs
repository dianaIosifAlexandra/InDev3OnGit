using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NUnit.Framework;

using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.DataAccess.Budget;
using Inergy.Indev3.Entities.Budget;
using Inergy.Indev3.DataAccess;

namespace Inergy.Indev3.DataAccessTests.Budget
{
    [TestFixture]
    public class DBProjectCoreTeamMemberTest : BaseTest
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

        public int InsertProjectCoreTeamMemberTest(IProjectCoreTeamMember projectCoreTeamMember, DBProjectCoreTeamMember dbGenericEntity)
        {
            projectCoreTeamMember.Id = dbGenericEntity.InsertObject(projectCoreTeamMember);
            return projectCoreTeamMember.Id;

        }
        public int UpdateProjectCoreTeamMemberTest(IProjectCoreTeamMember projectCoreTeamMember, DBProjectCoreTeamMember dbGenericEntity)
        {
            int rowCount = dbGenericEntity.UpdateObject(projectCoreTeamMember);
            return rowCount;
        }

        public DataSet SelectProjectCoreTeamMemberTest(IProjectCoreTeamMember projectCoreTeamMember, DBProjectCoreTeamMember dbGenericEntity)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbGenericEntity.SelectObject(projectCoreTeamMember) as DataSet;
            return tableVerify;

        }
        public int DeleteProjectCoreTeamMemberTest(IProjectCoreTeamMember projectCoreTeamMember, DBProjectCoreTeamMember dbGenericEntity)
        {
            int rowCount = dbGenericEntity.DeleteObject(projectCoreTeamMember);
            return rowCount;
        }
        [Test]
        [Category ("COMPLEX")]
        public void VerifyProjectCoreTeamMember()
        {
            Random random = new Random();

            DBProjectCoreTeamMember dbProjectCoreTeamMemberEntity = new DBProjectCoreTeamMember(connManager);
            IProjectCoreTeamMember projectCoreTeamMember = BusinessObjectInitializer.CreateProjectCoreTeamMember();

            projectCoreTeamMember.IdFunction = DATestUtils.DEFAULT_PROJECT_FUNCTION;
            projectCoreTeamMember.IdAssociate = DATestUtils.DEFAULT_ASSOCIATE;
            projectCoreTeamMember.IdProject = random.Next(1,2);
            projectCoreTeamMember.IsActive = true;

            DataTable dtCoreTeamMembers = SelectProjectCoreTeamMemberTest(projectCoreTeamMember, dbProjectCoreTeamMemberEntity).Tables[0];
            if (dtCoreTeamMembers.Rows.Count == 0)
            {
                int newId = InsertProjectCoreTeamMemberTest(projectCoreTeamMember, dbProjectCoreTeamMemberEntity);
                Assert.AreEqual(newId, 1);
            }

            int rowsAffected = UpdateProjectCoreTeamMemberTest(projectCoreTeamMember, dbProjectCoreTeamMemberEntity);
            Assert.AreEqual(1, rowsAffected);

            int rowCount = DeleteProjectCoreTeamMemberTest(projectCoreTeamMember, dbProjectCoreTeamMemberEntity);
            Assert.AreEqual(1, rowCount);

            DataTable tableVerify = SelectProjectCoreTeamMemberTest(projectCoreTeamMember, dbProjectCoreTeamMemberEntity).Tables[0];
            //Verifies that the table is not null
            Assert.IsNotNull(tableVerify, "The table returned should not be null");
            //Verifies that the table returns the correcty columns
            DATestUtils.CheckColumn(tableVerify, 0, "CoreTeamMemberName");
            DATestUtils.CheckColumn(tableVerify, 1, "FunctionName");
            DATestUtils.CheckColumn(tableVerify, 2, "Country");
            DATestUtils.CheckColumn(tableVerify, 3, "LastUpdateDate");
            DATestUtils.CheckColumn(tableVerify, 4, "IsActive");
            DATestUtils.CheckColumn(tableVerify, 5, "IdProject");
            DATestUtils.CheckColumn(tableVerify, 6, "IdAssociate");
            DATestUtils.CheckColumn(tableVerify, 7, "IdFunction");
            DATestUtils.CheckColumn(tableVerify, 8, "ProjectName");

        }
    }
}
