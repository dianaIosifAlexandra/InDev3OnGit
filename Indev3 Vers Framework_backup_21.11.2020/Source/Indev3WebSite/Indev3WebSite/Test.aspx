<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Test" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>
    <telerik:RadWindowManager ID="RadWindowManager2" runat="server" OnClientClose="OnClientClose">
    </telerik:RadWindowManager>

    <div>
    <%--<telerik:RadComboBox ID="cmbTest" runat="server"></telerik:RadComboBox>--%>
    <asp:LinkButton ID="lnkChange" runat="server" ForeColor="#C9C9C9" Font-Names="Tahoma" Font-Size="7pt">change</asp:LinkButton>
    </div>
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server" OnClientClose="OnClientClose">
    </telerik:RadWindowManager>
    </form>
</body>
</html>
<script type="text/javascript">

    function ShowPopUpWithoutPostBackWithDirtyCheck(name, height, width, sessionExpiredUrl) {
        var isPageDirty = CheckDirtyBeforeOpeningPopUp();
        if (isPageDirty) {
            if (!confirm("There are unsaved changes on this page. If you click OK you may lose all unsaved changes. Are you sure you want to close this window?")) {
                return false;
            }
        }
        //var returnValue = window.showModalDialog(name, null, "status:no;center:yes;resizable:no;help:no;dialogHeight:" + height + "px;dialogWidth:" + width + "px");
        var returnValue = 1;
        radopen(name, "RadWindow1", width, height, 100,100);
        //If the ok button is pressed
        if (returnValue == 1) {
            //If the user pressed the save button in the pop-up, clear the dirty flag
            //ClearDirtyBeforePopUp();
            return false;
        }
        if (returnValue == -1) {
            window.location = sessionExpiredUrl;
            return false;
        }
        return false;
    }

    function OnClientClose(sender, args) {
        console.log('args');
    console.log(args);
}
</script>