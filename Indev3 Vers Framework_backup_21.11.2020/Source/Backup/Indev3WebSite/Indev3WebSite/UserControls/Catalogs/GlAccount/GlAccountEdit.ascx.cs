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
using System.Collections.Generic;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

public partial class UserControls_GlAccount_GlAccountEdit : GenericUserControl
{
    public UserControls_GlAccount_GlAccountEdit()
    {
        this.Entity = new GlAccount();
    }

    protected override void OnPreRender(EventArgs e)
    {
        try
        {
            //Normally, for a G/L Account the name can be modified. But the names of the default accounts (stored in the Application)
            //cannot be modified
            if (this.GlAccountEditControl.EditMode)
            {
                List<CostIncomeType> defaultAccounts = (List<CostIncomeType>)Application[SessionStrings.DEFAULT_ACCOUNTS];
                if (defaultAccounts != null)
                {
                    foreach (CostIncomeType costIncomeType in defaultAccounts)
                    {
                        //If the account is found in the list of default accounts, do not permit the name of this account to be modified
                        if (costIncomeType.DefaultAccount == txtAccount.Text)
                        {
                            lblName.Enabled = false;
                            txtName.Enabled = false;
                            break;
                        }
                    }
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
}
