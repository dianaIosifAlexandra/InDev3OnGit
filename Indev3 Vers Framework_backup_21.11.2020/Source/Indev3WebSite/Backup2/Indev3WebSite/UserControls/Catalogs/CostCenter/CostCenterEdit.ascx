<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CostCenterEdit.ascx.cs"
    Inherits="UserControls_CostCenter_CostCenterEdit" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="CostCenterEditControl" runat="server">
    <table style="table-layout:fixed">
        <colgroup>
            <col width="100px" />
            <col width="185px" />
        </colgroup>
        <tbody>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblInergyLocation" runat="server" Text="Inergy Location"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatComboBox ID="cmbInergyLocation" runat="server" EntityProperty="IdInergyLocation"
                        DataTextField="Name" DataValueField="Id" Width="152px">
                    </cc3:IndCatComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblCode" runat="server" Text="Code"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtCode" runat="server" EntityProperty="Code" Width="150px"
                        AlphaNumericCheck="True"></cc3:IndCatTextBox></td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblName" runat="server" Text="Name"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox></td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblIsActive" runat="server" Text="Active" CssClass="IndCatLabel"
                        EnabledOnNew="False" EntityProperty=""></cc3:IndCatLabel>
                </td>
                <td align="left" style="padding-left:5px;">
                    <cc3:IndCatCheckBox ID="chkIsActive" runat="server" EntityProperty="IsActive" EnabledOnNew="False">
                    </cc3:IndCatCheckBox></td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblDepartment" runat="server" Text="Department"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatComboBox ID="cmbDepartment" runat="server" EntityProperty="IdDepartment"
                        DataTextField="Name" DataValueField="Id" Width="152px" ReferencedControlName="lblFunctionName"
                        ReferencedControlValueMember="FunctionName">
                    </cc3:IndCatComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblFunction" Width="90px" runat="server" Text="Function"></cc3:IndCatLabel>
                </td>
                <td align="left" style="padding-left: 8px; padding-top: 3px;">
                    <cc3:IndCatLabel ID="lblFunctionName" runat="server" CssClass="IndCatLabel" EntityProperty="FunctionName"></cc3:IndCatLabel>
                </td>
            </tr>
        </tbody>
    </table>
</cc2:GenericEditControl>
