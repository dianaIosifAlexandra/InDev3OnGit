using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.DataAccess.Catalogues;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.DataAccess;


namespace Inergy.Indev3.DataAccessTests
{
    internal class DATestUtils
    {
        /// <summary>
        /// Generates a random string with the given length
        /// </summary>
        /// <param name="size">Size of the string</param>
        /// <param name="lowerCase">If true, generate lowercase string</param>
        /// <returns>Random string</returns>
        internal static string GenerateString(int size, bool lowerCase,bool code)
        {
            StringBuilder builder = new StringBuilder();
            Random random = new Random();
            string ch;
            if (!code)
            {
                size -= 8;
                builder.Append("Indev3UT");
            }
            for (int i = 0; i < size; i++)
            {
                //Randomize a new number
                ch = random.Next(0, 10).ToString();
                //Adds the number to the string builder
                builder.Append(ch);
            }
            if (lowerCase)
                return builder.ToString().ToLower();
            //Returns the result
            return builder.ToString();
        }

        internal static void CheckTableStructure(DataTable table, StringCollection columnList)
        {
            if (table == null || table.Columns == null)
                throw new NoNullAllowedException("CheckTableStructure: Table returned cannot be null");

            if (columnList.Count != table.Columns.Count)
                throw new RowNotInTableException(String.Format("CheckTableStructure: Number of columns expected {0}. Current {1}", columnList.Count, table.Columns.Count));

            for (int i = 0; i < columnList.Count; i++)
            {
                CheckColumn(table, i, columnList[i]);
            }
        }


        /// <summary>
        /// Checks if a specific column is on a specific position in a given table
        /// </summary>
        /// <param name="table">The source table</param>
        /// <param name="columnPosition">The column's position</param>
        /// <param name="columnName">The column's name</param>
        internal static void CheckColumn(DataTable table, int columnPosition, string columnName)
        {
            if (table.Columns[columnPosition].ColumnName != columnName)
                throw new InvalidColumnException(columnName, columnPosition);
        }

        /// <summary>
        /// Verifies that the stored procedure really exists
        /// </summary>
        internal bool VerifyStoredProcedureName(string Name)
        {
            SqlConnection connection = new SqlConnection(DATestUtils.ConnString);

            SqlCommand cmd = new SqlCommand();

            cmd.Connection = connection;
            cmd.CommandText = "testVerifyProcedureName";
            cmd.CommandType = CommandType.StoredProcedure;
            
            SqlParameter nameParameter = new SqlParameter();
            nameParameter.ParameterName = "@Name";
            nameParameter.DbType = DbType.String;
            nameParameter.Direction = ParameterDirection.Input;
            nameParameter.Value = Name;
            cmd.Parameters.Add(nameParameter);

            SqlParameter returnParameter = new SqlParameter();
            returnParameter.ParameterName = "RETURN_VALUE";
            returnParameter.DbType = DbType.Boolean;
            returnParameter.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(returnParameter);
            
            cmd.ExecuteNonQuery();

            return (bool)cmd.Parameters["RETURN_VALUE"].Value;
        }

        //this constant is used for the Ids that go into tables that have an Initialization script
        internal int testConstantInitialized = 1;
        //this constant is used for the Ids that go into tables that have an Initialization script
        internal int testConstantAssociateInitialized = 16;
        //this constant is used for the Ids that go into tables that don't have an Initialization script
        internal int testConstantNotInitialized = 100000;
        //this constant is used for the fields YearMonth that hold the concateneted year + month
        internal int testConstantYearMonth = 200701;
        internal decimal testConstantDecimal = (decimal)0.00;

        internal const int DEFAULT_ENTITY_ID = 100000;
        internal const decimal DEFAULT_DECIMAL_VALUE = (decimal)0.00;
        internal const int DEFAULT_YEAR_MONTH = 200001;
        internal const int DEFAULT_ASSOCIATE = 2;
        internal const int DEFAULT_PROJECT_FUNCTION = 1;

        internal const string ConnString = "Data Source=patrocle;Initial Catalog=Indev3Work;User ID=sa;Password=sa;";
        internal const int COMMAND_TIMEOUT = 120;
        internal const string DEFAULT_USER = "AKELAINF\\ionelb";
    }
}
