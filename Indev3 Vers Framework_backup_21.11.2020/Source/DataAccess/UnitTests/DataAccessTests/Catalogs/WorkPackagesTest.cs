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
    public class WorkPackageTest: BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBWorkPackage(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        
        public int InsertWorkPackageTest(IWorkPackage workPackage)
        {
            workPackage.Id = dbEntity.InsertObject(workPackage);
            return workPackage.Id;

        }
        public int UpdateWorkPackageTest(IWorkPackage workPackage)
        {
            int rowCount = dbEntity.UpdateObject(workPackage);
            return rowCount;
        }

        public DataSet SelectWorkPackageTest(IWorkPackage workPackage)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(workPackage) as DataSet;
            return tableVerify;

        }
        public int DeleteWorkPackageTest(IWorkPackage workPackage)
        {
            int rowCount = dbEntity.DeleteObject(workPackage);
            return rowCount;
        }
        [Test]
        public void VerifyWorkPackage()
        {
            Random random = new Random();

            IWorkPackage workPackage = BusinessObjectInitializer.CreateWorkPackage();
            
            workPackage.IdProject = random.Next(1,2);
            workPackage.IdPhase = random.Next(1,9);
            workPackage.Code = DATestUtils.GenerateString(3, true, true);
            workPackage.Name = DATestUtils.GenerateString(30, true, false);
            workPackage.Rank = random.Next(1, 100);
            workPackage.IsActive = true;
            workPackage.StartYearMonth = DATestUtils.DEFAULT_YEAR_MONTH;
            workPackage.EndYearMonth = DATestUtils.DEFAULT_YEAR_MONTH;
            workPackage.LastUpdate = DateTime.Today;
            workPackage.IdLastUserUpdate = DATestUtils.DEFAULT_ASSOCIATE;

            int newId = InsertWorkPackageTest(workPackage);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateWorkPackageTest(workPackage);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectWorkPackageTest(workPackage).Tables[0];

                        //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"ProjectPhase",
                                            "ProjectCode",
                                            "Code",
                                            "Name",
                                            "Rank",
                                            "IsActive",
                                            "StartYearMonth",
                                            "EndYearMonth",
                                            "LastUpdate",
                                            "LastUserUpdate",
                                            "IsProgramManager",
                                            "ProjectName",	
                                            "IdLastUserUpdate",
                                            "Id",
                                            "IdPhase",
                                            "IdProject",
                                            "IdProjectFunction"});

            DATestUtils.CheckTableStructure(resultTable, columns);          


            int rowCount = DeleteWorkPackageTest(workPackage);
            Assert.AreEqual(1, rowCount);
        }
    }
}
