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
    /// <summary>
    /// This is the class that performs the unitests for the Associate catalog.
    /// It contains 4 methods for inserting, updating, deleting and selecting data from and into the Associate Catalog
    /// </summary>
    [TestFixture]
    public class AssociateTest : BaseTest
    {
        [SetUp]
        public override void Initialize()
        {
            base.Initialize();
            dbEntity = new DBAssociate(connManager);
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
        private int InsertAssociateTest(IAssociate associate)
        {
            associate.Id = dbEntity.InsertObject(associate);
            return associate.Id;

        }
        /// <summary>
        /// This method is used for updating an object into the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the update should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        private int UpdateAssociateTest(IAssociate associate)
        {
            int rowCount = dbEntity.UpdateObject(associate);
            return rowCount;
        }
        /// <summary>
        /// This method is used for selecting an object from the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the select should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        private DataSet SelectAssociateTest(IAssociate associate)
        {
            DataSet tableVerify = new DataSet();
            tableVerify = dbEntity.SelectObject(associate) as DataSet;
            return tableVerify;

        }
        /// <summary>
        /// This method is used for deleting an object from the database
        /// </summary>
        /// <param name="associate">This is the Associate object that holds all information that is required so that the delete should be made.</param>
        /// <param name="dbGenericEntity">This is the Associate Entity.</param>
        /// <returns></returns>
        private int DeleteAssociateTest(IAssociate associate)
        {
            int rowCount = dbEntity.DeleteObject(associate);
            return rowCount;
        }
        /// <summary>
        /// In this method, the associate object is created, and then is populated with values.
        /// All methods for insert, update, delete, select are called with the required parameters.
        /// Here are also made the Unit Tests
        /// </summary>
        [Test]
        public void VerifyAssociate()
        {
            IAssociate associate = BusinessObjectInitializer.CreateAssociate();
            Random random = new Random();

            associate.IdCountry = random.Next(1,3);
            associate.Name = DATestUtils.GenerateString(50, true, false);
            associate.InergyLogin = DATestUtils.GenerateString(50, true, false);
            associate.EmployeeNumber = DATestUtils.GenerateString(15, true, false);
            associate.IsActive = true;
            associate.PercentageFullTime = random.Next(1, 100);
            associate.IsSubContractor = true;

            int newId = InsertAssociateTest(associate);
            //Verifies that the id returned by the insert method is greater than 1
            Assert.Greater(newId, 0);

            int rowsAffected = UpdateAssociateTest(associate);
            //Verifies that one and only one row is affected by the update
            Assert.AreEqual(1, rowsAffected);

            DataTable resultTable = SelectAssociateTest(associate).Tables[0];

            //Verifies that the table contains the correct column names and order
            StringCollection columns = new StringCollection();
            columns.AddRange(new string[]{"CountryName", 
                                            "EmployeeNumber",
                                            "Name", 
                                            "InergyLogin", 
                                            "IsActive", 
                                            "PercentageFullTime",
                                            "IsSubContractor",
                                            "Id", 
                                            "IdCountry"});

            DATestUtils.CheckTableStructure(resultTable, columns);
            
            int rowCount = DeleteAssociateTest(associate);
            Assert.AreEqual(1, rowCount);
        }
    }
}
