using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Net.Mail;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.ApplicationFramework
{
    /// <summary>
    /// Class used for sending email
    /// </summary>
    public class EmailSupport
    {
        /// <summary>
        /// The email message that will be sent
        /// </summary>
        private MailMessage email = null;

        /// <summary>
        /// Creates an email message and sends it
        /// </summary>
        /// <param name="smtpServerAdress">the smtp server adress</param>
        /// <param name="sender">The email's sender</param>
        /// <param name="recipient">The email's receiver</param>
        /// <param name="subject">The email's subject</param>
        /// <param name="body">The email's body</param>
        public void SendMailMessage(string smtpServerAdress, string sender, string recipient, string subject, string body)
        {
            //Instantiate the email object and sets the sender and the recipient
            email = new MailMessage(sender, recipient);
            //Sets the email subject
            email.Subject = subject;
            //Sets the email body
            email.Body = body;
            //Specify that the body is not in the HTML format
            email.IsBodyHtml = false;


            SmtpClient server = new SmtpClient();
            //Sets the server adress used for sending email messages
            server.Host = smtpServerAdress;
            try
            {
                //Sends the email message
                server.Send(email);
            }
            catch (Exception exc)
            {
                if (exc.InnerException!=null)
                    throw new IndException(exc.Message + " Extended information: " + exc.InnerException.Message + ".");
                else
                    throw new IndException(exc);
            }
        }
    }
}
