using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

using NUnit.Framework;

using Inergy.Indev3.BusinessLogic;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.Entities;
using Inergy.Indev3.ApplicationFramework;


namespace Inergy.Indev3.BusinessLogicTests
{
    [TestFixture]
    public class DepartmentTests
    {
        private SessionConnectionHelper sessionConnectionHelper;
        private object connManager;

        [SetUp]
        public void Initialize()
        {
            sessionConnectionHelper = new SessionConnectionHelper();
            connManager = sessionConnectionHelper.GetNewConnectionManager(BLTestUtils.ConnString, BLTestUtils.COMMAND_TIMEOUT);
        }
        [TearDown]
        public void CloseUp()
        {
            sessionConnectionHelper.DisposeConnection(connManager);
        }

        [Test]
        public void GetAllDepartmentsTest()
        {
            Department department = new Department(connManager);
            DataSet ds = department.GetAll();
            Assert.AreEqual(5, ds.Tables[0].Columns.Count);
        }

        [Test]
        public void InsertDepartmentTest()
        {
            Random random = new Random();
            Department department = new Department(connManager);
            department.IdFunction = random.Next(1,9);
            department.Name = Guid.NewGuid().ToString().Substring(0, 30);
            department.Rank = random.Next(100000, 110000);
            department.SetNew();
            department.Id = department.Save();

            Assert.Greater(department.Id, 0);

            department.SetDeleted();
            department.Save();
        }
    }
}
