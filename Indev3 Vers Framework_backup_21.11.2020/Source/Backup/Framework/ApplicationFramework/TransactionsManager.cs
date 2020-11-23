using System;
using System.Collections.Generic;
using System.Text;
using System.Transactions;

namespace Inergy.Indev3.ApplicationFramework
{
    /// <summary>
    /// Manages the transactions in the SwissTradeApplication
    /// </summary>
    public static class TransactionsManager
    {
        /// <summary>
        /// Creates a new transactionScope with the given timeout (expressed in minutes)
        /// </summary>
        /// <param name="timeout">The timeout (in minutes) for this transaction</param>
        /// <returns></returns>
        public static TransactionScope GetNewTransactionScope(int timeout)
        {
            TransactionOptions options = new TransactionOptions();
            options.Timeout = new TimeSpan(0, timeout, 0);
            return new TransactionScope(TransactionScopeOption.RequiresNew, options, EnterpriseServicesInteropOption.Full);
        }
        /// <summary>
        /// Creates a new transactionScope with 30 seconds timeout
        /// </summary>
        /// <param name="timeout"></param>
        /// <returns></returns>
        public static TransactionScope GetNewTransactionScope()
        {
            TransactionOptions options = new TransactionOptions();
            options.Timeout = new TimeSpan(0, 0, 30);
            return new TransactionScope(TransactionScopeOption.RequiresNew, options, EnterpriseServicesInteropOption.Full);
        }
    }
}
