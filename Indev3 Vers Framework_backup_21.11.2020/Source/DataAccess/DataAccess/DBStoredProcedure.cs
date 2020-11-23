using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using Inergy.Indev3.ApplicationFramework;

namespace Inergy.Indev3.DataAccess
{
    public class DBStoredProcedure
    {
        public string ProcedureName = null;
        public Dictionary<string,DBParameter> DBParameters = new Dictionary<string,DBParameter>();

        public void AddParameter(DBParameter dbParameter)
        {
            if (DBParameters.ContainsKey(dbParameter.Name))
                throw new Exception(ApplicationMessages.MessageWithParameters(ApplicationMessages.EXCEPTION_PROCEDURE_ALREADY_CONTAINS_PARAMETER, ProcedureName, dbParameter.Name));

            DBParameters.Add(dbParameter.Name, dbParameter);
        }

        public void AddParameter(string name, DbType dbType, ParameterDirection direction, object value)
        {
            DBParameter dbParameter = new DBParameter(name, dbType, direction, value);
            AddParameter(dbParameter);
        }

        public SqlCommand GetSqlCommand()
        {
            SqlCommand sqlCommand = new SqlCommand();
            
            sqlCommand.CommandText = this.ProcedureName;
            sqlCommand.CommandType = CommandType.StoredProcedure;
            Dictionary<string, DBParameter>.Enumerator enumerator = DBParameters.GetEnumerator();
            while (enumerator.MoveNext())
            {
                DBParameter currentParameter = enumerator.Current.Value;
                SqlParameter sqlParameter = new SqlParameter(currentParameter.Name, currentParameter.DBType);
                sqlParameter.Direction = currentParameter.Direction;
                sqlParameter.Value = currentParameter.Value;

                sqlCommand.Parameters.Add(sqlParameter);
            }

            return sqlCommand;
        }

        public SqlDataAdapter GetSqlDataAdapter()
        {
            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
            sqlDataAdapter.SelectCommand = GetSqlCommand();

            return sqlDataAdapter;
        }
    }
}
