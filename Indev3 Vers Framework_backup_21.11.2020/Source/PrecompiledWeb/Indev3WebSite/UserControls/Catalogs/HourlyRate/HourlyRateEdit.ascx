<%@ control language="C#" autoeventwireup="true" inherits="UserControls_HourlyRate_HourlyRateEdit, App_Web_tipncokx" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="HourlyRateEditControl" runat="server">
    <table style="table-layout:fixed">
        <colgroup>
            <col width="110px" />
            <col width="185px" />
        </colgroup>
        <tbody>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblInergyLocation" runat="server" Text="Inergy Location" CssClass="IndCatLabel"
                        EnabledOnEdit="False"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatComboBox ID="cmbInergyLocation" runat="server" DataValueField="Id" DataTextField="Name"
                        EntityProperty="IdInergyLocation" Width="152px" EnabledOnEdit="False" OnSelectedIndexChanged="cmbInergyLocation_SelectedIndexChanged"
                        AutoPostBack="true" ReferencedControlName="lblCurrencyName" ReferencedControlValueMember="CurrencyName">
                    </cc3:IndCatComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblCostCenter" runat="server" Text="Cost Center Code" CssClass="IndCatLabel"
                        EnabledOnEdit="False"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatComboBox ID="cmbCostCenter" runat="server" DataValueField="Id" DataTextField="Code"
                        EntityProperty="IdCostCenter" Width="152px" EnabledOnEdit="False" ReferencedControlName="lblCostCenterNameTag"
                        ReferencedControlValueMember="Name" OnSelectedIndexChanged="cmbCostCenter_SelectedIndexChanged">
                    </cc3:IndCatComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblCostCenterName" runat="server" Text="Cost Center Name" CssClass="IndCatLabel"
                        EnabledOnEdit="False"></cc3:IndCatLabel>
                </td>
                <td align="left" style="padding-left: 8px; padding-top: 3px;">
                    <cc3:IndCatLabel ID="lblCostCenterNameTag" runat="server" CssClass="IndCatLabel"
                        EnabledOnEdit="False" EntityProperty="CostCenterName"></cc3:IndCatLabel>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblYear" runat="server" Text="Period" CssClass="IndCatLabel"
                        EnabledOnEdit="False"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc1:IndCatYearMonth ID="ucYearMonth" runat="server" EnabledOnEdit="False" EntityProperty="YearMonth" />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblCurrency" runat="server" Text="Currency" CssClass="IndCatLabel"
                        EnabledOnEdit="False" EntityProperty=""></cc3:IndCatLabel>
                </td>
                <td align="left" style="padding-left:8px;">
                    <cc3:IndCatLabel ID="lblCurrencyName" runat="server" EntityProperty="CurrencyName"
                        Width="152px" EnabledOnEdit="False"></cc3:IndCatLabel>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc3:IndCatLabel ID="lblValue" runat="server" Text="Hourly Rate"></cc3:IndCatLabel>
                </td>
                <td align="left">
                    <cc3:IndCatTextBox ID="txtValue" runat="server" EntityProperty="Value" Width="150px"></cc3:IndCatTextBox>
                </td>
            </tr>
        </tbody>
    </table>
</cc2:GenericEditControl>
