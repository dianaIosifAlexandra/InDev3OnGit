using System;
using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using System.Data;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.ApplicationFrameworkTests
{
    [TestFixture]
    public class DSUtilsTests
    {
        [Test]
        public void ReplaceBooleanColumnTest()
        {
            DataSet ds = new DataSet();
            DataTable dt = new DataTable("Table");
            DataColumn dc = new DataColumn("BoolColumn", typeof(bool));
            dt.Columns.Add(dc);
            ds.Tables.Add(dt);
            DataRow newRow = dt.NewRow();
            newRow["BoolColumn"] = true;
            dt.Rows.Add(newRow);
            newRow = dt.NewRow();
            newRow["BoolColumn"] = true;
            dt.Rows.Add(newRow);
            newRow = dt.NewRow();
            newRow["BoolColumn"] = false;
            dt.Rows.Add(newRow);
            
            DataSet newDs = DSUtils.ReplaceBooleanColumn("BoolColumn", ds, 0);
            
            Assert.AreEqual(1, newDs.Tables.Count);
            Assert.AreEqual("Table", newDs.Tables[0].TableName);
            Assert.AreEqual(2, newDs.Tables[0].Columns.Count);
            Assert.AreEqual("BoolColumn", newDs.Tables[0].Columns[0].ColumnName);
            Assert.AreEqual(3, newDs.Tables[0].Rows.Count);
            Assert.AreEqual("Yes", newDs.Tables[0].Rows[0]["BoolColumn"]);
            Assert.AreEqual("Yes", newDs.Tables[0].Rows[1]["BoolColumn"]);
            Assert.AreEqual("No", newDs.Tables[0].Rows[2]["BoolColumn"]);
        }

        [Test]
        public void AddEmptyRecordTest()
        {
            DataTable dt = new DataTable("Table");
            DataColumn dc = new DataColumn("Id", typeof(int));
            dt.Columns.Add(dc);
            dc = new DataColumn("Name", typeof(string));
            dt.Columns.Add(dc);

            DataRow newRow = dt.NewRow();
            newRow["Id"] = 1;
            newRow["Name"] = "cici";
            dt.Rows.Add(newRow);
            newRow = dt.NewRow();
            newRow["Id"] = 2;
            newRow["Name"] = "mimi";
            dt.Rows.Add(newRow);
            newRow = dt.NewRow();
            newRow["Id"] = 3;
            newRow["Name"] = "lili";
            dt.Rows.Add(newRow);

            DSUtils.AddEmptyRecord(dt);

            Assert.AreEqual(4, dt.Rows.Count);
            Assert.AreEqual(DBNull.Value, dt.Rows[0]["Name"]);
            Assert.AreEqual(-1, dt.Rows[0]["Id"]);
        }
    }
}
