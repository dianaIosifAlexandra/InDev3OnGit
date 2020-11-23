using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Collections;

namespace Inergy.Indev3.ApplicationFramework.ExceptionHandling
{
    /// <summary>
    /// This class represents the Exception that will be used by the INDev3 application
    /// For a detailed documentation about how to use this class see .NET Coding Guidelines
    /// </summary>
    public class IndException : Exception
    {
        #region Properties
        private Exception _BaseException;
        /// <summary>
        /// This will always be the first Exception that was thrown, no matter
        /// how many InnerExceptions exists
        /// </summary>
        public Exception BaseException
        {
            get { return _BaseException; }
        }

        private bool _IsUnexpected;
        /// <summary>
        /// Specify if the exception is a user exception or an unexpected one
        /// </summary>
        public bool IsUnexpected
        {
            get { return _IsUnexpected; }
        }

        /// <summary>
        /// Used to keep the StackTrace
        /// </summary>
        private string _StackTrace;
        
        /// <summary>
        /// Used to store the Error Message
        /// </summary>
        private string _Message;
       
        #endregion Properties

        #region Constructors
        /// <summary>
        /// Constructor used to throw a user exception
        /// Used if the exception is not based on any exception
        /// </summary>
        /// <param name="exceptionMessage"></param>
        public IndException(string exceptionMessage)
        {
            this._StackTrace = String.Empty;
            this._IsUnexpected = false;
            this._BaseException = null;
            _Message = exceptionMessage;
        }

        /// <summary>
        /// Constructor used to throw exceptions form the DataAccess layer 
        /// when a SQLException is caught 
        /// </summary>
        /// <param name="sqlExc">The SqlException caught</param>
        public IndException(SqlException sqlExc)
        {
            this._StackTrace = sqlExc.StackTrace;
            //If the state is 0 than the expection is unexpected
            this._IsUnexpected = (sqlExc.State == 0) ? true : false;
            this._BaseException = sqlExc;
            this._Message = sqlExc.Message;
        }

        /// <summary>
        /// Constructor used to rethrow  exceptions
        /// </summary>
        /// <param name="exc">The Exception caught</param>
        public IndException(Exception exc)
        {
            //To rethrow SqlException use another constructor
            if (exc is SqlException)
                throw new IndException(ApplicationMessages.EXCEPTION_CONSTRUCTOR_RETHROW_SQLEXCEPTION); 

            if (exc is IndException)
            {
                this._StackTrace = ((IndException)exc).StackTrace;
                this._IsUnexpected = ((IndException)exc).IsUnexpected;
                this._BaseException = ((IndException)exc).BaseException;
            }
            else
            {
                this._StackTrace = exc.StackTrace;
                this._IsUnexpected = true;
                this._BaseException = exc;
            }
            this._Message = exc.Message;
        }


        public IndException(ArrayList errList)
        {
            StringBuilder concatenatedMessages = new StringBuilder();
            String err;

            for (int i = 0; i < errList.Count; i++)
            {
                err = (String)errList[i];
                concatenatedMessages.Append(err);

                //if we are not at the last error, append BR
                if (i != errList.Count-1)
                    concatenatedMessages.Append("<BR>");
            }

            this._StackTrace = String.Empty;
            this._IsUnexpected = false;
            this._BaseException = null;
            _Message = concatenatedMessages.ToString();
        }

        /// <summary>
        /// Constructor used to rethrow an exception
        /// </summary>
        /// <param name="exceptionMessage">the Exception message</param>
        /// <param name="exc">The exception caught</param>
        public IndException(string exceptionMessage, Exception exc)
        {
            //To rethrow SqlException use another constructor
            if (exc is SqlException)
                throw new IndException(ApplicationMessages.EXCEPTION_CONSTRUCTOR_RETHROW_SQLEXCEPTION);

            //To rethrow IndException use another constructor
            if (exc is IndException)
                throw new IndException(ApplicationMessages.EXCEPTION_CONSTRUCTOR_RETHROW_INDEXCEPTION);

            this._StackTrace = exc.StackTrace;
            this._IsUnexpected = false;
            this._BaseException = exc;
            _Message = exceptionMessage;
        }

        
        #endregion Constructors

        #region Overrides
        public override string Message
        {
            get
            {
                return _Message;
            }
        }
        public override string StackTrace
        {
            get
            {
                return _StackTrace;
            }
        }
        #endregion Overrides
    }
}
