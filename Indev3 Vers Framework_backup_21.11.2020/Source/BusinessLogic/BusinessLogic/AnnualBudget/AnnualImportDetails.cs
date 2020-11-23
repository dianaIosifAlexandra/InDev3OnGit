using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities.AnnualBudget;
using Inergy.Indev3.DataAccess.AnnualBudget;
using Inergy.Indev3.ApplicationFramework;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Collections;

namespace Inergy.Indev3.BusinessLogic.AnnualBudget
{
    public class AnnualImportDetails : GenericEntity, IAnnualImportDetails
    {
        #region Members
        private int _idImport;
        public int IdImport
        {
            get { return _idImport; }
            set { _idImport = value; }
        }

        private int _idRow;
        public int IdRow
        {
            get { return _idRow; }
            set { _idRow = value; }
        }

        private string _country;
        public string Country
        {
            get { return _country; }
            set { _country = value; }
        }

        private int _year;
        public int Year
        {
            get { return _year; }
            set { _year = value; }
        }

        private int _month;
        public int Month
        {
            get { return _month; }
            set { _month = value; }
        }

        private string _costCenter;
        public string CostCenter
        {
            get { return _costCenter; }
            set { _costCenter = value; }
        }

        private string _projectCode;
        public string ProjectCode
        {
            get { return _projectCode; }
            set { _projectCode = value; }
        }

        private int _projectId;
        public int ProjectId
        {
            get { return _projectId; }
            set { _projectId = value; }
        }

        private string _wpCode;
        public string WPCode
        {
            get { return _wpCode; }
            set { _wpCode = value; }
        }

        private string _accountNumber;
        public string AccountNumber
        {
            get { return _accountNumber; }
            set { _accountNumber = value; }
        }

        private decimal _quantity;
        public decimal Quantity
        {
            get { return _quantity; }
            set { _quantity = value; }
        }

        private string _unitQty;
        public string UnitQty
        {
            get { return _unitQty; }
            set { _unitQty = value; }
        }

        private decimal _value;
        public decimal Value
        {
            get { return _value; }
            set { _value = value; }
        }

        private string _currencyCode;
        public string CurrencyCode
        {
            get { return _currencyCode; }
            set { _currencyCode = value; }
        }

        private DateTime _importDate;
        public DateTime ImportDate
        {
            get { return _importDate; }
            set { _importDate = value; }
        }
        #endregion

        #region Constructor
        public AnnualImportDetails(int idImport, int IdRow, string Country, int Year, int Month, string CostCenter, string ProjectCode,
                int ProjectId, string WPCode, string AccountNumber, string AssociateNumber, decimal Quantity, string UnitQty, decimal Value, string CurrencyCode,
                DateTime ImportDate, object connectionManager)
            : base(connectionManager)
        {
            this._idImport = idImport;
            this._idRow = IdRow;
            this._country = Country;
            this._year = Year;
            this._month = Month;
            this._costCenter = CostCenter;
            this._projectCode = ProjectCode;
            this._projectId = ProjectId;
            this._wpCode = WPCode;
            this.AccountNumber = AccountNumber;
            this._quantity = Quantity;
            this._unitQty = UnitQty;
            this._value = Value;
            this._currencyCode = CurrencyCode;
            this._importDate = ImportDate;
            SetEntity(new DBAnnualImportDetails(connectionManager));
        }

        public AnnualImportDetails(object connectionManager)
            : base(connectionManager)
        {
            this._value = 0;
            SetEntity(new DBAnnualImportDetails(connectionManager));
        }

        #endregion

        #region Public Methods
        public void UpdateImportDetailsTable()
        {           
            try
            {
                this.GetEntity().ExecuteCustomProcedure("UpdateAnnualImportDetails", this);               
            }
            catch (Exception ex)
            {                
                throw new IndException(ex);
            }
        }

        public DataSet SelectImportDetails(int IdImport)
        {            
            DataSet dsAnnual;
            try
            {
                this.IdImport = IdImport;
                dsAnnual = this.GetEntity().GetCustomDataSet("SelectAnnualImportDetails", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return dsAnnual;
        }

        public DataSet UpdateBatchImportDetails(List<AnnualImportDetails> importDetailsList)
        {
            DataSet ds;
            int localIdImport = ApplicationConstants.INT_NULL_VALUE;

            try
            {
                this.BeginTransaction();
                foreach (AnnualImportDetails impDetails in importDetailsList)
                {
                    impDetails.UpdateImportDetailsTable();
                    localIdImport = impDetails.IdImport;
                }
                ds = SelectImportDetailsForExport(localIdImport);
            }
            catch (Exception ex)
            {
                this.RollbackTransaction();
                throw new IndException(ex);
            }

            //we don't want to alter data...we just do the updates to create new upload file
            this.RollbackTransaction();
            return ds;
        }

        private DataSet SelectImportDetailsForExport(int IdImport)
        {
            DataSet dsAnnual;
            this.IdImport = IdImport;
            dsAnnual = this.GetEntity().GetCustomDataSet("SelectAnnualImportDetailsForExport", this);
            return dsAnnual;
        }

        public DataSet AnnualSelectImportDetailsWithErrors(int IdImport, string ApplicationPath)
        {
            DataSet ds;
            DataSet dsErrors;
            int IdRow;
            StringBuilder strErrors;

            try
            {
                //first we take the data
                ds = SelectImportDetails(IdImport);
                dsErrors = SelectImportDetailsErrors(IdImport);

                //then add the column to hold the errors
                ds.Tables[0].Columns.Add(new DataColumn("RowErrors", typeof(string)));
                ds.AcceptChanges();

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    strErrors = new StringBuilder();
                    IdRow = (int)row["IdRow"];

                    //set the filter in the errors recordset
                    DataRow[] rowsInner = dsErrors.Tables[0].Select("IdRow = " + IdRow);
                    foreach (DataRow rowInner in rowsInner)
                    {
                        strErrors.Append(rowInner["Details"]);
                        string projectCode = row["ProjectCode"].ToString();
                        string projectId = row["ProjectId"].ToString();
                        if (rowInner["Module"].Equals(ApplicationConstants.MODULE_WORK_PACKAGE))
                        {
                            if (!String.IsNullOrEmpty(projectId))
                            {
                                strErrors.Append("&nbsp;<a target=\"PopUpLogDetails\" href=\"" + ApplicationPath + "/Default.aspx?NewPage=1&Code=");
                                strErrors.Append(rowInner["Module"]);
                                strErrors.Append("&ProjectCode=" + projectCode + "&ProjectId=" + projectId);
                            }
                            else
                            {
                                strErrors.Append("&nbsp;<a href=\"javascript:alert('Cannot open work package catalogue when the project does not exist or is not specified !');");
                            }
                        }
                        else
                        {
                            strErrors.Append("&nbsp;<a target=\"PopUpLogDetails\" href=\"" + ApplicationPath + "/Default.aspx?NewPage=1&Code=");
                            strErrors.Append(rowInner["Module"]);
                        }
                        strErrors.Append("\">");
                        strErrors.Append(rowInner["ModuleName"]);
                        strErrors.Append("</a>&nbsp;&nbsp;");
                    }

                    row.BeginEdit();
                    row["RowErrors"] = strErrors.ToString();
                    row.EndEdit();
                }
                ds.AcceptChanges();
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }

        private DataSet SelectImportDetailsErrors(int IdImport)
        {
            DataSet ds;

            this.IdImport = IdImport;
            ds = this.GetEntity().GetCustomDataSet("SelectAnnualImportDetailsErrors", this);
            return ds;
        }

        public DataSet SelectHeaderInformation()
        {
            DataSet ds;
            try
            {
                ds = this.GetEntity().GetCustomDataSet("SelectAnnualImportDetailsHeader", this);
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
            return ds;
        }
        #endregion Public Methods
    }
}
