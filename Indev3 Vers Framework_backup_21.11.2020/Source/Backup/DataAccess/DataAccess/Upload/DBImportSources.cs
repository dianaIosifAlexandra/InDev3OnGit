using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using Inergy.Indev3.Entities.Upload;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.Entities;

namespace Inergy.Indev3.DataAccess.Upload
{
    public class DBImportSources : DBGenericEntity
    {
        public DBImportSources(object connectionManager)
            : base(connectionManager)
        {
        }


       /* public DataTable SelectImportSources()
        {
            DataTable dt = new DataTable();
            try
            {
                SqlCommand cmd = new SqlCommand("impSelectImportSource");
                cmd.CommandType = CommandType.StoredProcedure;
                dt = CurrentConnectionManager.GetDataTable(cmd);
            }
            catch (SqlException ex)
            {
                throw new IndException(ex);
            }
            return dt;
        }*/

        protected override void InitializeObject(IGenericEntity ent)
        {
            if (ent is IImportSources)
            {
                IImportSources importSources = (IImportSources)ent;

                DBStoredProcedure spSelectImportSource = new DBStoredProcedure();
                spSelectImportSource.ProcedureName = "impSelectImportSource";
                this.AddStoredProcedure("SpSelectImportSource", spSelectImportSource);

                DBStoredProcedure spIsUserAllowedOnImportSource = new DBStoredProcedure();
                spIsUserAllowedOnImportSource.ProcedureName = "impIsUserAllowedOnImportSource";
                spIsUserAllowedOnImportSource.AddParameter(new DBParameter("@IdAssociate", DbType.Int32, ParameterDirection.Input, importSources.IdCurrentAssociate));
                spIsUserAllowedOnImportSource.AddParameter(new DBParameter("@IdImportSource", DbType.Int32, ParameterDirection.Input, importSources.IdImportSource));
                this.AddStoredProcedure("SpIsUserAllowedOnImportSource", spIsUserAllowedOnImportSource);
            }
        }
    }
}
