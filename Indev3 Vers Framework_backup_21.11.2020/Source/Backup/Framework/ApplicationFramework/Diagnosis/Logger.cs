using System;
using System.Diagnostics;

namespace Inergy.Indev3.ApplicationFramework
{
    /// <summary>
    /// Class used for managing logging
    /// </summary>
    public static class Logger
    {
        /// <summary>
        /// Writes a message to the trace listeners
        /// </summary>
        /// <param name="message">The message to be written to the trace listeners
        /// </param>
        public static void WriteLine(string message)
        {
            Trace.WriteLine(DateTime.Now + " " + message);
        }
    }
}
