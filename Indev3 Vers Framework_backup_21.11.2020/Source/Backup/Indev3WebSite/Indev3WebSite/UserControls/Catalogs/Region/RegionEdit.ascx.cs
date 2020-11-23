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
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.WebFramework.GenericControls;
using Inergy.Indev3.BusinessLogic.Catalogues;

using Inergy.Indev3.WebFramework.Utils;
using Inergy.Indev3.WebFramework;

public partial class UserControls_Region_RegionEdit : GenericUserControl
{
    public UserControls_Region_RegionEdit()
    {
        this.Entity = new Region();
    }
}