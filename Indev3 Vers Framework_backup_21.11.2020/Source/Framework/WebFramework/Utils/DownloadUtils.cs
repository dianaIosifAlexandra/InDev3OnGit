using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.Utils
{
    /// <summary>
    /// Class holding methods used for downloading
    /// </summary>
    public static class DownloadUtils
    {
        /// <summary>
        /// Initiates a download of a file with the name fileName, containg fileContent
        /// </summary>
        /// <param name="fileName">the name of the file</param>
        /// <param name="fileContent">the content of the file</param>
        public static void DownloadFile(string fileName, string fileContent)
        {
            try
            {
                //set the server response for downloading the specified file
                //HttpContext.Current.Response.Clear();
                //HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.ContentType = "text/csv";
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
                HttpContext.Current.Response.Write(fileContent);
                HttpContext.Current.Response.End();
            }
            catch (Exception ex)
            {
                throw new IndException(ex);
            }
        }
    }
}
