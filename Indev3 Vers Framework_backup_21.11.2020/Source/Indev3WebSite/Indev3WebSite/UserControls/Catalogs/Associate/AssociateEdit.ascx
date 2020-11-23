<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AssociateEdit.ascx.cs"
    Inherits="UserControls_Associate_AssociateEdit" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="AssociateEditControl" runat="server">
    <table>
        <tbody>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblCountry" runat="server" Text="Country" CssClass="IndLabel"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatComboBox ID="cmbCountry" runat="server" EntityProperty="IdCountry" DataTextField="Name"
                        DataValueField="Id" Width="152px">
                    </cc3:IndCatComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblEmployeeNumber" runat="server" Text="Employee Number"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtEmployeeNumber" Width="150px" runat="server" EntityProperty="EmployeeNumber"></cc3:IndCatTextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblName" runat="server" Text="Name"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtName" Width="150px" runat="server" EntityProperty="Name"></cc3:IndCatTextBox>
                    <asp:RegularExpressionValidator ID="revName" runat="server" ControlToValidate="txtName"
                        SetFocusOnError="true" ValidationExpression=".+,\s.+" ErrorMessage="Filed Name must be in the form 'Family name, First Name'"
                        ForeColor="#626262" Display="Dynamic"  CssClass="foreColorIE">*
                    </asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblInergyLogin" runat="server" Text="Inergy Login"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtInergyLogin" Width="150px" runat="server" EntityProperty="InergyLogin"></cc3:IndCatTextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblIsActive" runat="server" Text="Active" CssClass="IndCatLabel"
                        EnabledOnNew="False" EntityProperty=""></cc3:IndCatLabel>
                </td>
                <td align="left" style="padding-left:5px;">
                    <cc3:IndCatCheckBox ID="chkIsActive" runat="server" EntityProperty="IsActive" EnabledOnNew="False">
                    </cc3:IndCatCheckBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblPercentageFullTIme" runat="server" Text="Full Time"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtPercentageFullTIme" Width="150px" runat="server" EntityProperty="PercentageFullTime"
                        MaxLength="3"></cc3:IndCatTextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblIsSubContractor" runat="server" Text="Subcontractor"></cc3:IndCatLabel>
                </td>
                <td align="left" style="padding-left:5px;">
                    <cc3:IndCatCheckBox ID="chkIsSubContractor" runat="server" EntityProperty="IsSubContractor">
                    </cc3:IndCatCheckBox>
                </td>
            </tr>
        </tbody>
    </table>
</cc2:GenericEditControl>
