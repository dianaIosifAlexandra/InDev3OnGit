<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectCoreTeamMemberEdit.ascx.cs" Inherits="UserControls_Budget_ProjectCoreTeamMember_ProjectCoreTeamMemberEdit" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc2" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc1" %>
    <script language="javascript" type="text/javascript" >
    function ShowAssociates() 
    {
        //avoid message from dirty flag - we get the message because when we return true there is no AJAX, is pure postback
        SetDirty(0);

        var returnValue = window.showModalDialog("UserControls/Budget/ProjectCoreTeamMember/SelectCoreTeamMember.aspx", null, "status:no;center:yes;resizable:no;help:no;dialogHeight:0px;dialogWidth:280px");
        if (returnValue == undefined)
            returnValue = 0;

        //in case nothing was selected we return false to avoid postback
        return (returnValue == 1) ? true : false;
    }
    </script>
<cc1:GenericEditControl ID="ProjectCoreTeamMemberEditControl" runat="server">
    <table border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td align="right">
                <cc2:IndCatLabel ID="lblMember" runat="server" CssClass="IndLabel" EnabledOnEdit="False" EntityProperty="">Member Name</cc2:IndCatLabel></td>
            <td align="left" valign="bottom">
                <cc2:IndCatTextBox ID="txtMember" runat="server" EnabledOnEdit="False" EnabledOnNew="False"
                    EntityProperty="CoreTeamMemberName" Width="150px"></cc2:IndCatTextBox><asp:Button ID="btnSelect" class="browseButton" runat="server" Text="..." CausesValidation="False" OnClientClick="var retval=ShowAssociates(); return retval;" /></td>
        </tr>
        <tr>
            <td align="right">
                <cc2:IndCatLabel ID="lblEmployeeNumber" runat="server" CssClass="IndLabel" EnabledOnEdit="False" EntityProperty="">Employee Number</cc2:IndCatLabel></td>
            <td align="left" valign="bottom">
                <asp:Label ID="lblEmpty" runat="server" ForeColor="#626262" Text="&nbsp;"></asp:Label>
                <cc2:IndCatLabel ID="txtEmployeeNumber" runat="server" CssClass="IndLabel" EntityProperty="EmployeeNumber">
                </cc2:IndCatLabel>
              </td>
        </tr>
        <tr>
            <td align="right">
                <cc2:IndCatLabel ID="lblFunction" runat="server" CssClass="IndLabel">Function</cc2:IndCatLabel></td>
            <td align="left" valign="bottom">
                <cc2:IndCatComboBox ID="cmbFunction" runat="server" DataTextField="Name" DataValueField="Id" EntityProperty="IdFunction" Width="152px" >
                </cc2:IndCatComboBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc2:IndCatLabel ID="lblLastUpdateText" runat="server" CssClass="IndLabel">Last Update</cc2:IndCatLabel></td>
            <td align="left" style="padding-left:8px;">
                <cc2:IndCatLabel ID="lblLastUpdate" runat="server" CssClass="IndLabel" EntityProperty="LastUpdateDate"></cc2:IndCatLabel></td>
        </tr>
        <tr>
            <td align="right">
                <cc2:IndCatLabel ID="lblActive" runat="server" CssClass="IndLabel">Active</cc2:IndCatLabel>&nbsp;
            </td>
            <td align="left">
                &nbsp;<cc2:IndCatCheckBox ID="chkActive" runat="server" Checked="True" EnabledOnNew="False"
                    EntityProperty="IsActive" /></td>
        </tr>
    </table>
    <radA:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableOutsideScripts="True">
        <AjaxSettings>
            <radA:AjaxSetting AjaxControlID="btnSelect">
                <UpdatedControls>
                    <radA:AjaxUpdatedControl ControlID="txtMember" />
                    <radA:AjaxUpdatedControl ControlID="txtEmployeeNumber" />
                    <radA:AjaxUpdatedControl ControlID="cmbFunction" />
                </UpdatedControls>
            </radA:AjaxSetting>
            <radA:AjaxSetting AjaxControlID="cmbFunction">
                <UpdatedControls>
                    <radA:AjaxUpdatedControl ControlID="cmbFunction" />
                </UpdatedControls>
            </radA:AjaxSetting>
        </AjaxSettings>
    </radA:RadAjaxManager>
    <asp:Button ID="btnDoPostBack" runat="server" CausesValidation="false" Visible="false" />
</cc1:GenericEditControl>
