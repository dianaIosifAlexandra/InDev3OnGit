using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Security.Principal;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.WebFramework.WebControls;

public partial class UserControls_Visuals_StatusBar : IndBaseControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ApplicationSettings settings = (ApplicationSettings)SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.APPLICATION_SETTINGS);
            if (settings == null)
                return;//the page should be redirected at this moment.

            CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueNoRedirect(ParentPage, SessionStrings.CURRENT_USER);
                        

            if (currentUser != null)
            {
                lblUserName.Text = currentUser.InergyLogin + " | " + currentUser.CountryName + " | " + currentUser.AssociateName + " | "
                    + currentUser.UserRole.Name + " | " + ((currentUser.UserRole.Id == ApplicationConstants.ROLE_BUSINESS_ADMINISTATOR || currentUser.UserRole.Id == ApplicationConstants.ROLE_KEY_USER) && !string.IsNullOrEmpty(currentUser.NameImpersonatedAssociate) ? "Imp: " + currentUser.NameImpersonatedAssociate + " | " : string.Empty) + settings.SqlDatabaseName;
            }
            else
            {
                lblUserName.Text = ParentPage.User.Identity.Name + " | " + settings.SqlDatabaseName;
            }

            String svnRevision = ConfigurationManager.AppSettings["SVNRevision"];
            if (svnRevision != "@revision@")
                lblUserName.Text += " | SVN Revision: " + svnRevision;
        }
        catch (IndException ex)
        {
            ReportControlError(ex);
            return;
        }
        catch (Exception ex)
        {
            ReportControlError(new IndException(ex));
            return;
        }
    }
}
