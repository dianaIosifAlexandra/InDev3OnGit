<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectTypeEdit.ascx.cs"
    Inherits="UserControls_ProjectType_ProjectTypeEdit" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<cc2:GenericEditControl ID="ProjectTypeEditControl" runat="server">
    <table>
        <tr>
            <td align="right">
                <cc1:IndCatLabel ID="Type" runat="server" Text="Type"></cc1:IndCatLabel></td>
            <td align="left">
                <cc1:IndCatTextBox ID="txtType" runat="server" EntityProperty="Type" Width="150px"></cc1:IndCatTextBox></td>
        </tr>
        <tr>
            <td align="right">
                <cc1:IndCatLabel ID="Rank" runat="server" Text="Rank" AlphaNumericCheck="True"></cc1:IndCatLabel>
            </td>
            <td align="left">
                <cc1:IndCatTextBox ID="txtRank" runat="server" EntityProperty="Rank" Width="50px"
                    MaxLength="9"></cc1:IndCatTextBox>
                <asp:RegularExpressionValidator ID="revRank" runat="server" ControlToValidate="txtRank"
                    SetFocusOnError="true" ValidationExpression="^\d+$" ErrorMessage="Field Rank must be a positive integer."
                    ForeColor="#626262" Display="Dynamic" CssClass="foreColorIE">*
                </asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
</cc2:GenericEditControl>
