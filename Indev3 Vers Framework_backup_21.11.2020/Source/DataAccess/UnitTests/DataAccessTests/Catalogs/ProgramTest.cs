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
    public class ProgramTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBProgram(connManager);
        }

        [TearDown]
        public override void CleanUp()
        {
            base.CleanUp();
        }

        public int InsertProgramTest(IProgram program)
        {
            program.Id = dbEntity.InsertObject(program);
            return program.Id;

        }
        public int UpdateProgramTest(IProgram program)
        {
            int rowCount = dbEntity.UpdateObject(program);
            return rowCount;
        }

        public DataSet SelectProgramTest(IProgram program)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(program) as DataSet;
            return tableVerify;

        }
        public int DeleteProgramTest(IProgram program)
        {
            int rowCount = dbEntity.DeleteObject(program);
            return rowCount;
        }
        [Test]
        public void VerifyProgram()
        {
            Random random = new Random();

            IProgram program = BusinessObjectInitializer.CreateProgram();

            program.Name = DATestUtils.GenerateString(50, true, false);
            program.Code = DATestUtils.GenerateString(10, true, true);
            program.IdOwner = random.Next(1,3);
            program.Rank = random.Next(100000, 200000);

            int newId = InsertProgramTest(program);
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateProgramTest(program);
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectProgramTest(program).Tables[0];

                        //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"Code",
                                        "Name",
                                        "OwnerName",
                                        "OwnerType",
                                        "IsActive",
                                        "Rank",
                                        "Id",
                                        "IdOwner",
                                        "IdOwnerType"});

            DATestUtils.CheckTableStructure(resultTable, columns);
 
            int rowCount = DeleteProgramTest(program);
            Assert.AreEqual(1, rowCount);
        }
    }
}
