using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Test : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string url = ResolveUrl("~/UserControls/ProjectSelector/SelectProject.aspx");
        lnkChange.OnClientClick = "return ShowPopUpWithoutPostBackWithDirtyCheck('" + url + "',400,540, '" + ResolveUrl("~/Default.aspx?SessionExpired=1") + "')";
    }
}