using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Collections;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.IO;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    public static class DSUtils
    {
        public static DataSet ReplaceBooleanColumn(string oldColumName, DataSet ds, int tableIndex)
        {
            DataColumn colBool = ds.Tables[tableIndex].Columns[oldColumName];
            DataColumn newCol = new DataColumn("New" + oldColumName, typeof(string));

            newCol.ExtendedProperties.Add("type", typeof(bool));
            int oldColumnPosition = ds.Tables[tableIndex].Columns[oldColumName].Ordinal;

            ds.Tables[tableIndex].Columns.Add(newCol);
            newCol.SetOrdinal(oldColumnPosition);

            colBool.ColumnName = "Old" + oldColumName;
            colBool.ExtendedProperties.Add("AddInGrid", false);

            newCol.Expression = "IIF ([" + colBool.ColumnName + "], 'Yes', 'No')";

            //foreach (DataRow row in ds.Tables[tableIndex].Rows)
            //{
            //    row.BeginEdit();
            //    row[newCol] = ((bool)row[colBool] == true) ? "Yes" : "No";
            //    row.EndEdit();
            //}
            //ds.Tables[tableIndex].Columns.Remove(oldColumName);
            //ds.AcceptChanges();
            newCol.ColumnName = oldColumName;
            //ds.AcceptChanges();
            return ds;
        }
        /// <summary>
        /// Adds an empty row to the DataTable when the Id column is named "Id"
        /// </summary>
        /// <param name="ds">The dataset to be modified</param>
        public static void AddEmptyRecord(DataTable tbl)
        {
            //All columns will be null, except the Id column (which is -1)
            AddEmptyRecord(tbl, "Id");
        }

        /// <summary>
        /// Adds an empty row to the DataTable
        /// </summary>
        /// <param name="ds">The dataset to be modified</param>
        public static void AddEmptyRecord(DataTable tbl, string idColumnName)
        {
            //All columns will be null, except the Id column (which is -1)
            DataRow row = tbl.NewRow();
            row.BeginEdit();
            foreach (DataColumn col in tbl.Columns)
            {
                if (col.ColumnName != idColumnName)
                    row[col] = DBNull.Value;
                else
                    row[col] = ApplicationConstants.INT_NULL_VALUE;
            }
            row.EndEdit();
            tbl.Rows.InsertAt(row,0);
            row.AcceptChanges();
        }
        /// <summary>
        /// Builds a string in a csv format (data separated by ';' character) from an array of DataRows
        /// </summary>
        /// <param name="rows">an array of DataRows containg data</param>
        /// <param name="columnNames">the names of the columns which will be exported</param>
        /// <returns>a string conaining the csv export</returns>
        public static string BuildCSVExport(DataRow[] rows, List<string> columnNames, bool hasHeader)
        {
            //StringBuilder storing the data in csv formatting
            StringBuilder fileContent = new StringBuilder();
            int intIterator = ApplicationConstants.INT_NULL_VALUE;
            //For each datarow
            foreach (DataRow row in rows)
            {
                intIterator++;
                if (hasHeader)
                {
                    //Add a newline (go to the next line)
                    fileContent.Append("\r\n");
                }
                else
                {
                    if(intIterator > 0)
                        //Add a newline (go to the next line)
                        fileContent.Append("\r\n");
                }
                //For each item of the row
                for (int i = 0; i < row.ItemArray.Length; i++)
                {
                    //If the item is a column that will be exported
                    if (columnNames.Contains(row.Table.Columns[i].ColumnName))
                    {
                        string tempString = string.Empty;
                        //Add the data item followed by a separator
                        tempString =  row[i].ToString();

                       if (row.Table.Columns[i].DataType == typeof(System.DateTime))
                       {
                           tempString = ApplicationUtils.FormatDateFrenchStyle(tempString);
                           tempString = ApplicationUtils.ReplaceDateTimeWithDate(tempString);
                       }
                       fileContent.Append(tempString + ";");
                    }
                }
                //Remove the last ';' from the end of the line
                fileContent.Remove(fileContent.Length - 1, 1);
            }
            return fileContent.ToString();
        }

        public static decimal GetDataRowValue(object rowValue)
        {
            if (rowValue == DBNull.Value)
                return 0;
            if (rowValue is int)
                return (int)rowValue;
            if (rowValue is decimal)
                return (decimal)rowValue;

            return ApplicationConstants.DECIMAL_NULL_VALUE;
        }

        /// <summary>
        /// Returns value, if it is not null, or DBNull.Value is value is null (because we cannot insert null in a dataset)
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static object GetValueToInsertInDataSet(object value)
        {
            if (value == null)
                return DBNull.Value;
            return value;
        }

        public static int WriteDataTableToCSVFile(DataTable dt, ArrayList columnsToSkip, String fileName, bool bAppend)
        {
            int nRowsWritten = 0;
            const string CSV_SEPARATOR = ";";

            if (dt == null)
            {
                throw new IndException(ApplicationMessages.DATATABLE_EMPTY_ERROR);
            }

            using (StreamWriter sw = new StreamWriter(fileName, bAppend, Encoding.GetEncoding(1252)))
            {
                foreach (DataRow dr in dt.Rows)
                {
                     for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        //skip columns from the column list to skip
                        if (columnsToSkip.Contains(dt.Columns[i].ColumnName))
                            continue;

                        //write only non-null values
                        if (!Convert.IsDBNull(dr[i]))
                        {
                            //if column type is datetime then it is a special case
                            if (dt.Columns[i].DataType == typeof(DateTime))
                                sw.Write((DateTime.Parse(dr[i].ToString()).Year * 100 + DateTime.Parse(dr[i].ToString()).Month) * 100 + DateTime.Parse(dr[i].ToString()).Day);
                            else
                                sw.Write(dr[i].ToString());
                        }

                        //we put separators except after last column
                        if (i < dt.Columns.Count - 1)
                        {
                            sw.Write(CSV_SEPARATOR);
                        }
                    }

                    sw.Write(sw.NewLine);
                    nRowsWritten++;
                }
                sw.Close();
            }


            return nRowsWritten;
        }

        public static object SumNullableDecimals(params object[] arrayDecimals)
        {
            decimal decReturn = 0;
            bool hasAtLeastOneValidValue = false;

            foreach (object objDecimal in arrayDecimals)
            {
                if (objDecimal == DBNull.Value)
                    continue;

                hasAtLeastOneValidValue = true;
                decReturn = decReturn + (decimal)objDecimal;
            }

            if (hasAtLeastOneValidValue)
                return (object)decReturn;
            else
                return DBNull.Value;
        }
    }
}
