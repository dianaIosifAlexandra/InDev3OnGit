<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProgramEdit.ascx.cs" Inherits="UserControls_Program_ProgramEdit" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="ProgramEditControl" runat="server">
    <table style="table-layout: fixed">
        <colgroup>
            <col width="100px" />
            <col width="185px" />
        </colgroup>
        <tbody>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblCode" Width="90px" runat="server" Text="Code"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtCode" runat="server" EntityProperty="Code" Width="150px"
                        AlphaNumericCheck="True"></cc3:IndCatTextBox>
                    <asp:RegularExpressionValidator ID="revCode" runat="server" ControlToValidate="txtCode"
                        SetFocusOnError="true" ValidationExpression="[\w]+" ErrorMessage="Filed Code can only contain alphanumeric characters"
                        ForeColor="#6E6E6E" Display="Dynamic">*
                    </asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblName" Width="90px" runat="server" Text="Name"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblOwner" Width="90px" runat="server" Text=" Owner Name"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatComboBox ID="cmbOwner" runat="server" DataValueField="Id" DataTextField="Name"
                        EntityProperty="IdOwner" Width="152px" ReferencedControlName="lblOwnerTypeName"
                        ReferencedControlValueMember="OwnerType">
                    </cc3:IndCatComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblOwnerType" Width="90px" runat="server" Text="Organization"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    &nbsp;
                    <cc3:IndCatLabel ID="lblOwnerTypeName" runat="server" CssClass="IndCatLabel" EntityProperty="OwnerType"></cc3:IndCatLabel></td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblIsActive" Width="90px" runat="server" Text="Active" CssClass="IndCatLabel"
                        EnabledOnNew="true" EntityProperty=""></cc3:IndCatLabel>
                </td>
                <td align="left" style="padding-left:5px;">
                    <cc3:IndCatCheckBox ID="chkIsActive" runat="server" EntityProperty="IsActive" EnabledOnNew="true">
                    </cc3:IndCatCheckBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="Rank" runat="server" Text="Rank" AlphaNumericCheck="True"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtRank" runat="server" EntityProperty="Rank" Width="50px"
                        MaxLength="9"></cc3:IndCatTextBox>
                    <asp:RegularExpressionValidator ID="revRank" runat="server" ControlToValidate="txtRank"
                        SetFocusOnError="true" ValidationExpression="^\d+$" ErrorMessage="Field Rank must be a positive integer."
                        ForeColor="#626262" Display="Dynamic" CssClass="foreColorIE">*
                    </asp:RegularExpressionValidator>
                </td>
            </tr>
        </tbody>
    </table>
</cc2:GenericEditControl>
