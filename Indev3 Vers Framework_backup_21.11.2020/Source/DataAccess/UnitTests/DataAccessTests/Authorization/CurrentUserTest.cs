using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NUnit.Framework;

using Inergy.Indev3.DataAccess;
using Inergy.Indev3.DataAccess.Authorization;
using Inergy.Indev3.ApplicationFramework;
using System.Security.Principal;

namespace Inergy.Indev3.DataAccessTests.Authorization
{
    /// <summary>
    /// This is the class that performs the unitests for the CurrentUser catalog 
    /// </summary>
    [TestFixture]
    public class CurrentUserTest : BaseTest
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
        /// In this method, the currentUser object is created, and then is populated with values.
        /// All methods for insert, update, delete, select are called with the required parameters.
        /// Here are also made the Unit Tests
        /// </summary>
        [Test]
        public void VerifyCurrentUser()
        {
            DBCurrentUser dbCurrentUserEntity = new DBCurrentUser(connManager);

            DataTable tableVerifyDetail = dbCurrentUserEntity.GetUserDetails(DATestUtils.DEFAULT_USER, ApplicationConstants.INT_NULL_VALUE);

            //Verifies that the table is not null
            Assert.IsNotNull(tableVerifyDetail, "The table returned should not be null");
            //Verifies that the table returns the correct columns
            DATestUtils.CheckColumn(tableVerifyDetail, 0, "IdAssociate");
            DATestUtils.CheckColumn(tableVerifyDetail, 1, "AssociateName");
            DATestUtils.CheckColumn(tableVerifyDetail, 2, "IdCountry");
            DATestUtils.CheckColumn(tableVerifyDetail, 3, "CountryName");
            tableVerifyDetail.Dispose();

            DataSet setVerifyPermissions = dbCurrentUserEntity.GetUserPermissions((int)tableVerifyDetail.Rows[0][0],(int)tableVerifyDetail.Rows[0][2]);
            DATestUtils.CheckColumn(setVerifyPermissions.Tables[0], 0, "IdRole");
            DATestUtils.CheckColumn(setVerifyPermissions.Tables[0], 1, "RoleName");
            DATestUtils.CheckColumn(setVerifyPermissions.Tables[1], 0, "ModuleCode");
            DATestUtils.CheckColumn(setVerifyPermissions.Tables[1], 1, "IdOperation");
            DATestUtils.CheckColumn(setVerifyPermissions.Tables[1], 2, "IdPermission");
            setVerifyPermissions.Dispose();

            DataTable tableVerifyProjects = dbCurrentUserEntity.GetUserProjects((int)tableVerifyDetail.Rows[0][0]);
            DATestUtils.CheckColumn(tableVerifyProjects, 0, "IdProject");
            DATestUtils.CheckColumn(tableVerifyProjects, 1, "ProjectName");
            DATestUtils.CheckColumn(tableVerifyProjects, 2, "IdFunction");
            DATestUtils.CheckColumn(tableVerifyProjects, 3, "ProjectFunction");
            tableVerifyProjects.Dispose();

            DataTable tableVerifyRolePermissions = dbCurrentUserEntity.GetRolePermissions((int)setVerifyPermissions.Tables[0].Rows[0][0]);
            DATestUtils.CheckColumn(tableVerifyRolePermissions, 0, "ModuleCode");
            DATestUtils.CheckColumn(tableVerifyRolePermissions, 1, "IdOperation");
            DATestUtils.CheckColumn(tableVerifyRolePermissions, 2, "IdPermission");
            tableVerifyRolePermissions.Dispose();
        }
    }
}
