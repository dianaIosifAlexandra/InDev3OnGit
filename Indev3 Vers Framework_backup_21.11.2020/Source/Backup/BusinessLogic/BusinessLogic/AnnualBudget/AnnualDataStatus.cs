using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.ApplicationFramework.Common;
using System.Data;
using Inergy.Indev3.DataAccess.AnnualBudget;
using Inergy.Indev3.ApplicationFramework.Attributes;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.BusinessLogic.Upload
{
    public class AnnualDataStatus : GenericEntity, IAnnualDataStatus
    {
        #region Public Properties
        #endregion Public Properties;

        #region Constructors
        public AnnualDataStatus()
            : this(null)
        {
        }
        public AnnualDataStatus(object connectionManager)
            : base(connectionManager)
        {
            SetEntity(new DBAnnualDataStatus(connectionManager));
        }
        #endregion

        #region Protected Methods
        protected override DataSet PostGetEntities(DataSet ds)
        {
            InergyCountry country = new InergyCountry(this.CurrentConnectionManager);
            //Get the countries dataset
            DataSet dsCountries = country.GetAll();

            //Get a list of years
            List<int> years = new List<int>();
            for (int i = YearMonth.FirstYear; i <= YearMonth.LastYear; i++)
                years.Add(i);
            //Build the dataset structure
            DataSet dsDataStatus = BuildDSStructure(years);
            //Add a row for each country
            foreach (DataRow countryRow in dsCountries.Tables[0].Rows)
            {
                DataRow newRow = dsDataStatus.Tables[0].NewRow();
                newRow["IdCountry"] = countryRow["Id"];
                newRow["Country"] = countryRow["Name"];
                dsDataStatus.Tables[0].Rows.Add(newRow);
            }
            //Add true where necessary
            foreach (DataRow importRow in ds.Tables[0].Rows)
            {
                DataRow row = GetDataRow((int)importRow["IdCountry"], dsDataStatus);
                //The exception thrown bellow in only used for development
                if (row == null)
                    throw new IndException("Corrupted DataSet in Annual Data Status");

                row[importRow["Year"].ToString()] = true;
            }

            return dsDataStatus;
        }
        #endregion Protected Methods

        #region Private Methods
        private DataRow GetDataRow(int idCountry, DataSet ds)
        {
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                if ((int)row["IdCountry"] == idCountry)
                    return row;
            }
            return null;
        }

        private DataSet BuildDSStructure(List<int> years)
        {
            DataSet resultDS = new DataSet();
            resultDS.Tables.Add(new DataTable("tblDataStatus"));
            resultDS.Tables[0].Columns.Add(new DataColumn("IdCountry", typeof(int)));
            resultDS.Tables[0].Columns.Add(new DataColumn("Country", typeof(string)));
            foreach (int currentYear in years)
            {
                DataColumn currentColumn = new DataColumn(currentYear.ToString(), typeof(bool));
                currentColumn.DefaultValue = false;
                resultDS.Tables["tblDataStatus"].Columns.Add(currentColumn);
            }
            return resultDS;
        }
        #endregion Private Methods
    }
}
