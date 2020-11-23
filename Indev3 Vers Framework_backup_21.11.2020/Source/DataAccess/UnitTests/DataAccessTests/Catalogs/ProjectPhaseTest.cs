using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Data;

using NUnit.Framework;

using Inergy.Indev3.DataAccess;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.Entities.Catalogues;

namespace Inergy.Indev3.DataAccessTests.Catalogues
{
    [TestFixture]
    public class ProjectPhaseTest: BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBProjectPhase(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }
        
        public int InsertProjectPhaseTest(IProjectPhase projectPhase)
        {
            projectPhase.Id = dbEntity.InsertObject(projectPhase);
            return projectPhase.Id;

        }
        public int UpdateProjectPhaseTest(IProjectPhase projectPhase)
        {
            int rowCount = dbEntity.UpdateObject(projectPhase);
            return rowCount;
        }

        public DataSet SelectProjectPhaseTest(IProjectPhase projectPhase)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(projectPhase) as DataSet;
            return tableVerify;

        }
        public int DeleteProjectPhaseTest(IProjectPhase projectPhase)
        {
            int rowCount = dbEntity.DeleteObject(projectPhase);
            return rowCount;
        }

        [Test]
        public void VerifyProjectPhase()
        {
            Random random = new Random();

            IProjectPhase projectPhase = BusinessObjectInitializer.CreateProjectPhase();

            projectPhase.Name = DATestUtils.GenerateString(50, true, false);
            projectPhase.Code = DATestUtils.GenerateString(10, true, true);

            int newId = InsertProjectPhaseTest(projectPhase);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateProjectPhaseTest(projectPhase);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectProjectPhaseTest(projectPhase).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Id", 
                                            "Code",
                                            "Name"});

            DATestUtils.CheckTableStructure(resultTable, columns);
            

            int rowCount = DeleteProjectPhaseTest(projectPhase);
            Assert.AreEqual(1, rowCount);
        }
    }
}
