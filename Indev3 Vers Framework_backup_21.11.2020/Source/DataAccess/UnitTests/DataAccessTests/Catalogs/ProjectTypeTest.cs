using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NUnit.Framework;

using Inergy.Indev3.DataAccess;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.Catalogues;

namespace Inergy.Indev3.DataAccessTests.Catalogues
{
    [TestFixture]
    public class ProjectTypeTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBProjectType(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertProjectTypeTest(IProjectType ProjectType)
        {
            ProjectType.Id = dbEntity.InsertObject(ProjectType);
            return ProjectType.Id;

        }
        public int UpdateProjectTypeTest(IProjectType ProjectType)
        {
            int rowCount = dbEntity.UpdateObject(ProjectType);
            return rowCount;
        }

        public DataSet SelectProjectTypeTest(IProjectType ProjectType)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(ProjectType) as DataSet;
            return tableVerify;

        }
        public int DeleteProjectTypeTest(IProjectType ProjectType)
        {
            int rowCount = dbEntity.DeleteObject(ProjectType);
            return rowCount;
        }
        [Test]
        public void VerifyProjectType()
        {
            IProjectType projectType = BusinessObjectInitializer.CreateProjectType();

            Random random = new Random();

            projectType.Type = DATestUtils.GenerateString(20, true, false);
            projectType.Rank = random.Next(100000, 200000);

            int newId = InsertProjectTypeTest(projectType);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateProjectTypeTest(projectType);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectProjectTypeTest(projectType).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Type",
                                          "Rank",
                                          "Id"});

            DATestUtils.CheckTableStructure(resultTable, columns);
            
            int rowCount = DeleteProjectTypeTest(projectType);
            Assert.AreEqual(1, rowCount);
        }
    }
}
