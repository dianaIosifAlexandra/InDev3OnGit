<%@ Control Language="C#" AutoEventWireup="true" CodeFile="WorkPackageTemplateEdit.ascx.cs" 
    Inherits="UserControls_Catalogs_WorkPackageTemplate_WorkPackageTemplateEdit" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="WP" runat="server">
    <table border="0">
        <tbody>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblPhase" runat="server" Text="Phase"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatComboBox ID="cmbPhase" runat="server" EntityProperty="IdPhase" DataTextField="Name"
                        DataValueField="Id" Width="152px" EnabledOnEdit="true">
                    </cc3:IndCatComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblCode" runat="server" Text="Code" CssClass="IndLabel" EntityProperty=""></cc3:IndCatLabel></td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtCode" runat="server" EntityProperty="Code" Width="150px"
                        EnabledOnEdit="False" AlphaNumericCheck="True"></cc3:IndCatTextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblName" runat="server" Text="Name" CssClass="IndLabel" EntityProperty=""></cc3:IndCatLabel></td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox></td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblDisplayNo" runat="server" Text="Rank" CssClass="IndLabel"
                        EntityProperty=""></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtRank" runat="server" EntityProperty="Rank" Width="50px"></cc3:IndCatTextBox>
                    <asp:RegularExpressionValidator ID="revRank" runat="server" ControlToValidate="txtRank"
                        SetFocusOnError="true" ValidationExpression="^\d+$" ErrorMessage="Field 'Rank' must be a positive integer."
                        ForeColor="#626262" Display="Dynamic">*
                    </asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblIsActive" runat="server" Text="Active" CssClass="IndLabel"
                        EnabledOnNew="true"></cc3:IndCatLabel>
                </td>
                <td align="left" style="padding-left:5px;">
                    <cc3:IndCatCheckBox ID="chkIsActive" runat="server" EntityProperty="IsActive" EnabledOnNew="true"
                        Checked="True"></cc3:IndCatCheckBox>
                </td>
            </tr>
        </tbody>
    </table>
</cc2:GenericEditControl>
