<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TechnicalSettingsView.ascx.cs"
    Inherits="Inergy.Indev3.UI.UserControls_Settings_TechnicalSettingsView" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>

<script type="text/javascript">
    var needToConfirm = true;
    var _isset = 0;
    window.onbeforeunload = confirmExit;

    function confirmExit()
    {
        if (needToConfirm)
        {
            var isDirty = document.getElementById('IsDirty');
            if (isDirty != null && isDirty.value == 1)
            {
                _isset = 1;
                needToConfirm = false;
                setTimeout("enableCheck()", "100");
                return "There are unsaved changes on this page. If you click OK you may lose all unsaved changes.";        
            }
        }           
    }

    function enableCheck()
    {
        //HACK: this is done because ResponseEnd is not called when CANCEL button is pressed when leaving the page.
        if(_isset==1)
        {
            ResponseEnd(null,null);
        }
        needToConfirm = true;
    }
</script>

<table cellpadding="2" cellspacing="2" border="0" width="100%">
    <tr>
        <td>
            <asp:Panel ID="pnlMailSettings" runat="server" CssClass="Panel">
                <table cellpadding="5" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td align="right" style="width: 50%">
                            <cc1:IndLabel ID="lblMailServer" runat="server" Text="Mail Server"></cc1:IndLabel>
                        </td>
                        <td align="left">
                            <cc1:IndTextBox ID="txtMailServer" runat="server" Width="250px"></cc1:IndTextBox>
                            <asp:RequiredFieldValidator ID="valRequireMailServer" runat="server" ControlToValidate="txtMailServer"
                                Text="*" ErrorMessage="Mail Server is required." ForeColor="#6e6e6e"
                                ValidationGroup="vgrTechnicalSettings"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <cc1:IndLabel ID="lblAdministrativeMail" runat="server" Text="INDev3 Administrative Mail"
                                CssClass="IndLabel"></cc1:IndLabel>
                        </td>
                        <td align="left">
                            <cc1:IndTextBox ID="txtAdministrativeMail" runat="server" Width="250px"></cc1:IndTextBox>
                            <asp:RequiredFieldValidator ID="valRequireAdministrativeMail" runat="server" ControlToValidate="txtAdministrativeMail"
                                Text="*" ErrorMessage="INDev3 Administrative Mail is required."
                                ForeColor="#6e6e6e" ValidationGroup="vgrTechnicalSettings"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator runat="server" ID="valAdministrativeEmailPattern"
                                ControlToValidate="txtAdministrativeMail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                ErrorMessage="The INDev3 Administrative Mail address you specified is not well-formed."
                                ForeColor="#6e6e6e" ValidationGroup="vgrTechnicalSettings">*</asp:RegularExpressionValidator>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Panel ID="pnlSqlServerSettings" runat="server" CssClass="Panel">
                <table cellpadding="5" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td align="right" style="width: 50%">
                            <cc1:IndLabel ID="lblSqlServerName" runat="server" Text="SQL Server name"></cc1:IndLabel>
                        </td>
                        <td align="left">
                            <cc1:IndTextBox ID="txtSqlServerName" runat="server" Width="250px"></cc1:IndTextBox>
                            <asp:RequiredFieldValidator ID="valRequireSqlServerName" runat="server" ControlToValidate="txtSqlServerName"
                                Text="*" ToolTip="The Sql Server Name field is required." ErrorMessage="SQL Server name is required."
                                ForeColor="#6e6e6e" ValidationGroup="vgrTechnicalSettings"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <cc1:IndLabel ID="lblSqlServerUserName" runat="server" Text="SQL Server username"></cc1:IndLabel>
                        </td>
                        <td align="left">
                            <cc1:IndTextBox ID="txtSqlServerUserName" runat="server" Width="250px"></cc1:IndTextBox>
                            <asp:RequiredFieldValidator ID="valRequireSqlServerUserName" runat="server" ControlToValidate="txtSqlServerUserName"
                                Text="*" ToolTip="The Sql Server User Name field is required." ErrorMessage="SQL Server username is requred."
                                ForeColor="#6e6e6e" ValidationGroup="vgrTechnicalSettings"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <cc1:IndLabel ID="lblSqlServerPassword" runat="server" Text="SQL Server password"></cc1:IndLabel>
                        </td>
                        <td align="left">
                            <cc1:IndTextBox ID="txtSqlServerPassword" runat="server" Width="250px"></cc1:IndTextBox>
                            <asp:RequiredFieldValidator ID="valRequireSqlServerPassword" runat="server" ControlToValidate="txtSqlServerPassword"
                                Text="*" ToolTip="Field is required." ErrorMessage="SQL Server password is required."
                                ForeColor="#6e6e6e" ValidationGroup="vgrTechnicalSettings"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <cc1:IndLabel ID="lblSqlDatabaseName" runat="server" Text="SQL Database name" CssClass="IndLabel"></cc1:IndLabel>
                        </td>
                        <td align="left">
                            <cc1:IndTextBox ID="txtSqlDatabaseName" runat="server" Width="250px"></cc1:IndTextBox>
                            <asp:RequiredFieldValidator ID="valRequireSqlDataBaseName" runat="server" ControlToValidate="txtSqlDatabaseName"
                                Text="*" ToolTip="Sql Database Name field is required." ErrorMessage="SQL Database name is requred."
                                ForeColor="#6e6e6e" ValidationGroup="vgrTechnicalSettings"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td align="left">
                            <asp:Button ID="btnTestSqlConnection" Text="Test sql connection" Width="160px" runat="server"
                                OnClick="btnTestSqlConnection_Click" /></td>
                    </tr>
                </table>
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <td>
            <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="width: 50%">
                        <asp:Button ID="btnSave" runat="server" Text="Save All Settings" OnClick="btnSave_Click"
                            OnClientClick="if (IsPageDirty()) {if (Page_IsValid) { if(!confirm('This action will reset your session. Continue?')) {return false;} else {ClearOnBeforeUnload();}}} else {alert('There are no changes on this page.'); return false;}"
                            ValidationGroup="vgrTechnicalSettings" /></td>
                </tr>
                <tr>
                    <td style="padding-top:10px;">
                        <cc1:IndValidationSummary ID="IndValidationSummary1" runat="server" ValidationGroup="vgrTechnicalSettings" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="lblWarning" CssClass="Warning" runat="server" Text="Please note that changing any of the settings will reset ALL current sessions!"></asp:Label></td>
    </tr>
</table>
