<%@ control language="C#" autoeventwireup="true" inherits="UserControls_GlAccount_GlAccountEdit, App_Web_htpwxr0f" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:genericeditcontrol id="GlAccountEditControl" runat="server">
    <table>
        <tr>
            <td align="right" >
                <cc3:IndCatLabel ID="lblCountry" runat="server" Text="Country" CssClass="IndLabel" EnabledOnEdit="False" EntityProperty=""></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbCountry" runat="server" EntityProperty="IdCountry" DataTextField="Name" DataValueField="Id" Width="152px" EnabledOnEdit="false">
                </cc3:IndCatComboBox>
            </td>
        </tr>
        <tr>
            <td align="right" >
                <cc3:IndCatLabel ID="lblAccount" runat="server" Text="G/L Account" CssClass="IndLabel" EntityProperty="" EnabledOnEdit="false"></cc3:IndCatLabel></td>
            <td align="left" >
                <cc3:IndCatTextBox ID="txtAccount" runat="server" EntityProperty="Account" Width="150px" EnabledOnEdit="false"></cc3:IndCatTextBox></td>
        </tr>
                <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblName" runat="server" Text="Name"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox></td>
        </tr>
                <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblCostType" runat="server" Text="Cost Type" CssClass="IndLabel" EntityProperty=""></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbCostType" runat="server" EntityProperty="IdCostType" DataTextField="Name" DataValueField="Id" Width="152px">
                </cc3:IndCatComboBox>
            </td>
        </tr>
    </table>
</cc2:genericeditcontrol>

