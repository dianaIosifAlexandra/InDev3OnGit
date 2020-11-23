<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CountryEdit.ascx.cs" Inherits="UserControls_Country_CountryEdit" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="CountryEditControl" runat="server">
    <table>
        <tr>
            <td align="right" style="height: 26px">
                <cc3:IndCatLabel ID="lblCode" runat="server" Text="Code"></cc3:IndCatLabel></td>
            <td align="left" style="height: 26px">
                <cc3:IndCatTextBox ID="txtCode" runat="server" EntityProperty="Code" Width="150px"
                    EnabledOnEdit="False" AlphaNumericCheck="True"></cc3:IndCatTextBox></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblName" runat="server" Text="Country Name"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblIdRegion" runat="server" Text="Region Name" CssClass="IndCatLabel"
                    EntityProperty=""></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbRegion" runat="server" EntityProperty="IdRegion" DataTextField="Name"
                    DataValueField="Id" DisplyedEntity="Region" Width="152px">
                </cc3:IndCatComboBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblCurrency" runat="server" Text="Currency"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbCurrency" runat="server" EntityProperty="IdCurrency" DataTextField="Name"
                    DataValueField="Id" DisplyedEntity="Currency" ZIndex="301" Width="152px">
                </cc3:IndCatComboBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblEmail" runat="server" Text="Email"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtEmail" runat="server" EntityProperty="Email" Width="150px">
                </cc3:IndCatTextBox><asp:RegularExpressionValidator ID="RegularExpressionValidator1"
                    runat="server" ControlToValidate="txtEmail" ErrorMessage="Field Email is not in the correct format."
                    ForeColor="#626262" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator></td>
        </tr>
         <tr>
            <td align="right">
                <cc3:IndCatLabel ID="Rank" runat="server" Text="Rank" AlphaNumericCheck="True"></cc3:IndCatLabel>
            </td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtRank" runat="server" EntityProperty="Rank" Width="50px" MaxLength="9"></cc3:IndCatTextBox>
                <asp:RegularExpressionValidator ID="revRank" runat="server" ControlToValidate="txtRank"
                        SetFocusOnError="true" ValidationExpression="^\d+$" ErrorMessage="Field Rank must be a positive integer."
                        ForeColor="#626262" Display="Dynamic">*
                    </asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
</cc2:GenericEditControl>
