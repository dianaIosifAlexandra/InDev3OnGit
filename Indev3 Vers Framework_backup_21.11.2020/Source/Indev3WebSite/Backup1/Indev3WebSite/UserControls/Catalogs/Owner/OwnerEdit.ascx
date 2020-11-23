<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OwnerEdit.ascx.cs" Inherits="UserControls_Owner_OwnerEdit" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="OwnerEditControl" runat="server">
    <table>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblCode" runat="server" Text="Code"></cc3:IndCatLabel>
            </td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtCode" runat="server" EntityProperty="Code" Width="150px"
                    AlphaNumericCheck="True"></cc3:IndCatTextBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblName" runat="server" Text="Name"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblOwnerType" runat="server" Text="Owner Type"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbOwnerType" runat="server" EntityProperty="IdOwnerType"
                    DataTextField="Name" DataValueField="Id" Width="152px">
                </cc3:IndCatComboBox>
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
                    ForeColor="#626262" Display="Dynamic">*
                </asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
</cc2:GenericEditControl>
