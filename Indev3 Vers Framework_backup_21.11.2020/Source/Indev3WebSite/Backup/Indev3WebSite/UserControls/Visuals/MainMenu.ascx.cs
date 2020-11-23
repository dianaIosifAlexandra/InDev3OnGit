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
using Inergy.Indev3.WebFramework.Utils;
using Telerik.WebControls;
using Inergy.Indev3.WebFramework.WebControls;
using Inergy.Indev3.BusinessLogic.Authorization;
using Inergy.Indev3.BusinessLogic.Budget;
using Inergy.Indev3.WebFramework;
using Inergy.Indev3.ApplicationFramework;
using Inergy.Indev3.UI;
using System.Collections.Generic;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using System.Xml.XPath;
using System.Web.Configuration;
using System.Xml;
using System.Text;
using System.Diagnostics;

namespace Inergy.Indev3.UI
{
    /// <summary>
    /// Main menu user control
    /// </summary>
    public partial class UserControls_Menus_MainMenu : IndBaseControl
    {
        private int levelCount = 1;
        public string repBreadCrumb = "Reporting";       
        
        /// <summary>
        /// Override the oninit method of usercontrol
        /// </summary>
        /// <param name="e"></param>
        protected override void OnInit(EventArgs e)
        {
            try
            {
                base.OnInit(e);
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

        /// <summary>
        /// Load event of the page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //Load the menu mapping the first time it is loaded
                if (!IsPostBack)
                {
                    //if the user has no rihts the whole menu is disabled
                    if (SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER) == null)
                    {
                        mnuMain.Enabled = false;
                        return;
                    }
                }

                LoadReportMenu();

                //If no project has been selected
                if (SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_PROJECT) == null)
                {
                    //Add an onclick client event handler to show the project selector popup window. A project must be selected before the
                    //project core team is displayed
                    IndMenuItem menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_CORE_TEAM);
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_TIMING_INTERCO);
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_WORK_PACKAGE);
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_INITIAL);
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_REVISED);
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_FOLLOW_UP);
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_REFORECAST);
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");

                    menuItem = (IndMenuItem)mnuMain.FindItemByValue("mnuExtract"); // already exists an menu item that contains word Extract
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");

                    menuItem = (IndMenuItem)mnuMain.FindItemByValue("mnuInitialBudget");
                    menuItem.Attributes.Add("onclick", "if (!ShowPopUpWithoutPostBackWithDirtyCheck('" + ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx") + "',0,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')) return false;");
                }
                else
                {
                    IndMenuItem menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_CORE_TEAM);
                    menuItem.Attributes.Clear();

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_TIMING_INTERCO);
                    menuItem.Attributes.Clear();

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_WORK_PACKAGE);
                    menuItem.Attributes.Clear();

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_INITIAL);
                    menuItem.Attributes.Clear();

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_REVISED);
                    menuItem.Attributes.Clear();

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_FOLLOW_UP);
                    menuItem.Attributes.Clear();

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_REFORECAST);
                    menuItem.Attributes.Clear();

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_EXTRACT);
                    menuItem.Attributes.Clear();

                    menuItem = (IndMenuItem)mnuMain.FindItemByText(ApplicationMessages.MENU_UPLOAD_INITIAL_BUDGET);
                    menuItem.Attributes.Clear();
                }
            }
            catch (IndException ex)
            {
                ReportControlError(ex);
                return;
            }
            catch (XmlException ex)
            {
                ReportControlError(new IndException("MenuReporting notice: " + ex.Message));
                return;
            }
            catch (Exception ex)
            {
                ReportControlError(new IndException(ex));
                return;
            }
        }
        
        /// <summary>
        /// Override of the OnPreRender method
        /// </summary>
        /// <param name="e"></param>
        protected override void OnPreRender(EventArgs e)
        {
            try
            {
                base.OnPreRender(e);

                //if the user has no rihts the whole menu is disabled
                if (SessionManager.GetSessionValueNoRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER) == null)
                {
                    mnuMain.Enabled = false;
                    return;
                }

                CurrentUser currentUser = (CurrentUser)SessionManager.GetSessionValueRedirect((IndBasePage)this.Page, SessionStrings.CURRENT_USER);

                //Get all items in the menu
                ArrayList menuItems = mnuMain.GetAllItems();
                //For each IndMenuItem
                foreach (IndMenuItem menuItem in menuItems)
                {
                    //If the menu item has a module code and the current user does not have the right to view this module, disable the menu item
                    if (!String.IsNullOrEmpty(menuItem.ModuleCode) && !(currentUser.HasViewPermission(menuItem.ModuleCode)))
                    {
                        menuItem.Enabled = false;
                    }
                }
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

        #region Private Methods        
        

        private void LoadReportMenu()
        {
            XPathNodeIterator NodeIter;
            
            #region alternate way of reading the malformed xml
            string xmlPath = Server.MapPath(ApplicationConstants.REPORTING_MENU_FILE);
            System.IO.StreamReader sRead = new System.IO.StreamReader(xmlPath);
            string line = string.Empty;
            string fullXmlFile = string.Empty;
            string navigateUrl = "NavigateUrl";
            string xmlQuote = "\"";
            while (!String.IsNullOrEmpty(line = sRead.ReadLine()))
            {
                if (!line.Contains(navigateUrl))
                { 
                    fullXmlFile += line;
                }
                else
                {
                    string badUrl = line.Substring(line.IndexOf(navigateUrl) + navigateUrl.Length, line.Length - line.IndexOf(navigateUrl) - navigateUrl.Length);
                    //excluding "good" xml quotes
                    int xmlQuotePosition = badUrl.IndexOf(xmlQuote);
                    badUrl = badUrl.Substring(xmlQuotePosition + 1, badUrl.Length - (xmlQuotePosition + 1));
                    badUrl = badUrl.Substring(0, badUrl.LastIndexOf(xmlQuote));
                    string goodUrl = System.Security.SecurityElement.Escape(badUrl);
                    fullXmlFile += line.Replace(badUrl, goodUrl);
                }
            }

            sRead.Close();
            
            System.IO.StringReader stringRead = new System.IO.StringReader(fullXmlFile);
            XmlDocument xmlDocument = new XmlDocument();
            xmlDocument.Load(stringRead);

            stringRead.Close();

            XPathDocument xmlFile = new XPathDocument(new XmlNodeReader(xmlDocument));
            #endregion reading xml
  
            //XPathDocument xmlFile = new XPathDocument(Server.MapPath(ApplicationConstants.REPORTING_MENU_FILE));
            XPathNavigator xmlNavigator = xmlFile.CreateNavigator();
 
            int nodeCounter = 0;

            //Initial XPathNavigator to start at the root.
            xmlNavigator.MoveToRoot();
            NodeIter = xmlNavigator.Select(ApplicationConstants.REPORTING_MENU_ITEM);

            while (NodeIter.MoveNext())
            {                
                levelCount = 1;

                string cssClass = getCssClass(NodeIter.Count, nodeCounter);
                AddItemsToMenu(NodeIter.Current, "0", cssClass);

                nodeCounter++;
                repBreadCrumb = "Reporting";
            }            
        }

        private void AddItemsToMenu(XPathNavigator xmlNavigator, string parentValue, string cssClass)
        {
            levelCount++;
        
            //check to see if the number of levels is not over the maximum
            if (levelCount > ApplicationConstants.REPORTING_MAXIMUM_LEVEL)
                throw new XmlException(string.Format("A maximum of '{0}' menu levels is permitted. Level {1} is beyond this limit.",
                        ApplicationConstants.REPORTING_MAXIMUM_LEVEL, xmlNavigator.GetAttribute("Text", "")));

             string navigatorText = xmlNavigator.GetAttribute("Text", "");

             //check not to allow nodes without Text attribute
             if (string.IsNullOrEmpty(navigatorText))
                 throw new XmlException("Text attribute cannot be empty.");


             //on level 2 we should have only nodes
             if (levelCount == 2 && !string.IsNullOrEmpty(xmlNavigator.GetAttribute("NavigateUrl", "")))
             {
                 throw new XmlException(string.Format("Node '{0}' must be a parent MenuItem because it is a level 2 node.", navigatorText));
             }


             //Check not to allow leaf not to have a NavigateUrl attribute. Except level 2.
             if (levelCount > 2 && 
                 !xmlNavigator.HasChildren && 
                 string.IsNullOrEmpty(xmlNavigator.GetAttribute("NavigateUrl", "")))
             {
                 throw new XmlException(string.Format("NavigateUrl attribute is empty for node '{0}'. This is not allowed for a leaf MenuItem.",
                                                 navigatorText));
             }

             //Navigate url must be empty for a parent MenuItems. 
             if (xmlNavigator.HasChildren && 
                 !string.IsNullOrEmpty(xmlNavigator.GetAttribute("NavigateUrl", "")))
             {
                 throw new XmlException(string.Format("NavigateUrl attribute is NOT empty for node '{0}'. This is not allowed for a parent MenuItem.",
                                                 navigatorText));
             }
             //Window must be empty for a parent MenuItems. 
             if (xmlNavigator.HasChildren &&
                 !string.IsNullOrEmpty(xmlNavigator.GetAttribute("Window", "")))
             {
                 throw new XmlException(string.Format("Window attribute is NOT empty for node '{0}'. This is not allowed for a parent MenuItem.",
                                                 navigatorText));
             }

            //********* make the breadcrumb************************           
            repBreadCrumb += " > " + navigatorText;
            //*****************************************************

            EncryptingSupport encryptingSupport = new EncryptingSupport();
            IndMenuItem itemToAdd = new IndMenuItem();
            string newValue = encryptingSupport.GetUniqueKey();
            itemToAdd.Value = newValue;
            itemToAdd.Text = navigatorText;

            String window = xmlNavigator.GetAttribute("Window", "");
            String urlType = xmlNavigator.GetAttribute("UrlType", "");
            String navigateUrl = xmlNavigator.GetAttribute("NavigateUrl", "");
            
            if (window == "new")
                itemToAdd.Target = "newINDev3Window";


            String navigateUrlToSet;
            if (!string.IsNullOrEmpty(navigateUrl))
            {
                if (urlType == "absolute")
                    navigateUrlToSet = navigateUrl;
                else
                {
                    //we remove any HTTP text to avoid some fatal error
                    navigateUrl = navigateUrl.Replace("http://", "");

                    navigateUrlToSet = "~/ReportPlaceHolder.aspx?Code=" + navigateUrl
                                       + "&nav=" + repBreadCrumb;
                }
                
                itemToAdd.NavigateUrl = Server.UrlDecode(navigateUrlToSet);
            }

            itemToAdd.CssClass = cssClass;

            //Add to menu
            RadMenuItem item = mnuMain.FindItemByValue(parentValue);
            item.Items.Add(itemToAdd);
            
            //if has children append this function again
            XPathNodeIterator NodeItererator = xmlNavigator.Select("MenuItem");          

            int iterator = 0;
            while (NodeItererator.MoveNext())
            {                
                string css = getCssClass(NodeItererator.Count, iterator);
                AddItemsToMenu(NodeItererator.Current, newValue, css);

                iterator++;
                levelCount--;

                //***********reset the breadcrumb because navigator enters another branch *************
                    repBreadCrumb = repBreadCrumb.Remove(repBreadCrumb.LastIndexOf(" > "));
                //*************************************************************************************
            }
            
        }

        private string getCssClass(int Count, int itemRank)
        {           
            if (itemRank ==0 && Count!=1 )
                return "l1left";
            if (itemRank == 0 && Count == 1)
                return "l1center";
             if (itemRank ==Count-1 )
                 return "l1right";
            return  "l1center";            
        }       
        
        #endregion Private Methods
    }
}
