using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.BusinessLogic.Upload
{
    /// <summary>
    /// class for Upload datagrid
    /// </summary>
    public class UploadFile
    {
        public UploadFile(DateTime _dataUpload, string _fileName, string _realFileName) 
        {
            this._dataUpload = _dataUpload;
            this._fileName = _fileName;
            this._realFileName = _realFileName;
        }

        private DateTime _dataUpload;
        public DateTime DataUpload
        {
            get { return _dataUpload; }
            set { _dataUpload = value;}
        }

        private string _fileName;
        public string FileName
        {
            get { return _fileName; }
            set { _fileName = value; }
        }

        private string _realFileName;
        public string RealFileName
        {
            get { return _realFileName; }
            set { _realFileName = value; }
        }

    }
}
