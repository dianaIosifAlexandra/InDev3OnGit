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
    public class ProjectTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBProject(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertProjectTest(IProject project)
        {
            project.Id = dbEntity.InsertObject(project);
            return project.Id;

        }
        public int UpdateProjectTest(IProject project)
        {
            int rowCount = dbEntity.UpdateObject(project);
            return rowCount;
        }

        public DataSet SelectProjectTest(IProject project)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(project) as DataSet;
            return tableVerify;

        }
        public int DeleteProjectTest(IProject project)
        {
            int rowCount = dbEntity.DeleteObject(project);
            return rowCount;
        }

        [Test]
        public void VerifyProject()
        {
            Random random = new Random();

            IProject project = BusinessObjectInitializer.CreateProject();
   
            project.Name = DATestUtils.GenerateString(50, true, false);
            project.Code = DATestUtils.GenerateString(10, true, true);
            project.IdProgram = random.Next(1,2);
            project.IdProjectType = random.Next(1, 2);
            project.IsActive = true;

            int newId = InsertProjectTest(project);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateProjectTest(project);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectProjectTest(project).Tables[0];

                        //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Code",
		                                "Name",
		                                "ProgramCode",
		                                "ProjectType",
		                                "IsActive",
		                                "ProgramName",
		                                "Id",
		                                "IdProgram",
		                                "IdProjectType"});

            DATestUtils.CheckTableStructure(resultTable, columns);

            int rowCount = DeleteProjectTest(project);
            Assert.AreEqual(1, rowCount);
        }
    }
}
