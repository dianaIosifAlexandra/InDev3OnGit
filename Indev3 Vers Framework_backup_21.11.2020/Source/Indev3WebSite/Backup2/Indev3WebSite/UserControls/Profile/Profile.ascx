<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Profile.ascx.cs" Inherits="UserControls_Profile_Profile" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
    
<script type="text/javascript">
    var needToConfirm = true;

    window.onbeforeunload = confirmExit;

    function confirmExit()
    {
        if (needToConfirm)
        {
            var isDirty = document.getElementById('IsDirty');
            if (isDirty != null && isDirty.value == 1)
            {
                needToConfirm = false;
                setTimeout("enableCheck()", "100");
                return "There are unsaved changes on this page. If you click OK you may lose all unsaved changes.";        
            }
        }
    }
      
    function enableCheck()
    {
        needToConfirm = true;
    }
</script>   
<asp:Panel ID="pnlProfile" runat="server" CssClass="Panel">
<table style="width: 100%" border="0">
    <tr>
        <td colspan="3" align="center">
        <asp:Panel ID="Panel2" runat="server" Width="538px">
            <cc1:IndCatGrid ID="grdAssociateRoles" runat="server" UserCanAdd="False" UserCanDelete="False"
                UserCanEdit="False">
                <PagerStyle Visible="False" />
                <MasterTableView TableLayout="Fixed">
                    <Columns>
                        <cc1:IndGridEditColumn Resizable="False" UniqueName="EditColumn">
                            <HeaderStyle Width="25px" />
                        </cc1:IndGridEditColumn>
                        <cc1:IndGridDeleteColumn Resizable="False" UniqueName="DeleteColumn">
                            <HeaderStyle Width="25px" />
                        </cc1:IndGridDeleteColumn>
                    </Columns>
                    <ExpandCollapseColumn Visible="False">
                        <HeaderStyle Width="19px" />
                    </ExpandCollapseColumn>
                    <RowIndicatorColumn Visible="False">
                        <HeaderStyle Width="20px" />
                    </RowIndicatorColumn>
                </MasterTableView>
                <ClientSettings>
                    <Resizing AllowColumnResize="True" />
                </ClientSettings>
            </cc1:IndCatGrid> 
            </asp:Panel>
            <br />
        </td>
    </tr>
    <tr>
        <td align="right" style="width:45%">
            <cc1:IndLabel ID="lblAssociates" runat="server" CssClass="IndLabel">Associate</cc1:IndLabel></td>
        <td style="width:5px">
            <asp:Label ID="lblRequiredFieldAssociate" runat="server" Text="*" ForeColor="Yellow"></asp:Label>
        </td>
        
        <td align="left" style="width:55%">
            <cc1:IndComboBox ID="cmbAssociates" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbAssociates_SelectedIndexChanged" Width="200px">
            </cc1:IndComboBox>
            <asp:RequiredFieldValidator ID="reqAssociates" runat="server" ErrorMessage="Associate is required." ControlToValidate="cmbAssociates" ForeColor="#6E6E6E" ValidationGroup="ProfileValidationGroup" >*</asp:RequiredFieldValidator>
            </td>
    </tr>
    <tr>
        <td align="right">
            <cc1:IndLabel ID="lblRoles" runat="server" CssClass="IndLabel">Role</cc1:IndLabel></td>
        <td>
            &nbsp
        </td>
        <td align="left" style="width:55%">
            <cc1:IndComboBox ID="cmbRoles" runat="server" Enabled="False" Width="200px">
            </cc1:IndComboBox>
            
            </td>
    </tr>
    <tr>
        <td align="right">
            <cc1:IndLabel ID="lblLogin" runat="server" CssClass="IndLabel">Inergy Login</cc1:IndLabel>
        </td>
        <td style="width:5px">
            &nbsp
        </td>
        <td align="left" style="width:55%;padding-left:12px;padding-top:3px;">
            <cc1:IndLabel ID="lblInergyLogin" runat="server" CssClass="IndLabel"></cc1:IndLabel>
        </td>
    </tr>
    <tr>
        <td colspan="3" style="height:20px">
            &nbsp;</td>
    </tr>
    <tr>
        <td colspan = "3" align="center">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" ValidationGroup="ProfileValidationGroup" OnClientClick="ClearOnBeforeUnload();" /></td>
    </tr>
    <tr>
        <td colspan="3" align="center" >
            <cc1:IndValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ProfileValidationGroup" />
        </td>
    </tr>
</table>

</asp:Panel>
