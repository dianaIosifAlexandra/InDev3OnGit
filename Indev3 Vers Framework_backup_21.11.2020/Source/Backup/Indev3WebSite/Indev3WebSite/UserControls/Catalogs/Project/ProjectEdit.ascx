<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectEdit.ascx.cs" Inherits="UserControls_Project_ProjectEdit" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="ProjectEditControl" runat="server">
    <table border="0" style="table-layout:fixed">
        <colgroup>
            <col width="140px" />
            <col width="185px" />
        </colgroup>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblCode" runat="server" Text="Code"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtCode" runat="server" EntityProperty="Code" Width="150px"
                    AlphaNumericCheck="True"></cc3:IndCatTextBox></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblName" runat="server" Text="Name"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblProgramCode" runat="server" Text="Program Code"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbProgram" runat="server" EntityProperty="IdProgram" DataTextField="Code"
                    DataValueField="Id" Width="152px" ReferencedControlName="lblProgramName" ReferencedControlValueMember="Name">
                </cc3:IndCatComboBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblProgram" Width="90px" runat="server" Text="Program Name"></cc3:IndCatLabel>
            </td>
            <td align="left" style="padding-left: 8px; padding-top: 3px;">
                <cc3:IndCatLabel ID="lblProgramName" runat="server" CssClass="IndCatLabel" EntityProperty="ProgramName"></cc3:IndCatLabel>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblProjectType" runat="server" Text="Project Type"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbProjectType" runat="server" EntityProperty="IdProjectType"
                    DataTextField="Type" DataValueField="Id" Width="152px">
                </cc3:IndCatComboBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblIsActive" runat="server" Text="Active" CssClass="IndCatLabel"
                    EnabledOnNew="true" EntityProperty=""></cc3:IndCatLabel></td>
            <td align="left" style="padding-left:5px;">
                <cc3:IndCatCheckBox ID="chkIsActive" runat="server" EntityProperty="IsActive" EnabledOnNew="true">
                </cc3:IndCatCheckBox></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblMembers" runat="server" Text="Active Members"></cc3:IndCatLabel>
            </td>
            <td align="left" style="padding-left: 8px; padding-top: 3px;">
                <cc3:IndCatLabel ID="lblActiveMembers" runat="server" CssClass="IndCatLabel" VisibleOnNew="false" EntityProperty="ActiveMembers"></cc3:IndCatLabel>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblTimingInterco" runat="server" Text="Timing & Interco %"></cc3:IndCatLabel>
            </td>
            <td align="left" style="padding-left: 8px; padding-top: 3px;">
                <cc3:IndCatLabel ID="lblTimingIntercoPercent" runat="server" CssClass="IndCatLabel" VisibleOnNew="false" EntityProperty="TimingIntercoPercent"></cc3:IndCatLabel>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblInitialBudget" runat="server" Text="Initial Budget Validated"></cc3:IndCatLabel>
            </td>
            <td align="left" style="padding-left: 8px; padding-top: 3px;">
                <cc3:IndCatLabel ID="lblInitialBudgetValidated" runat="server" CssClass="IndCatLabel" VisibleOnNew="false" EntityProperty="IsInitialBudgetValidated"></cc3:IndCatLabel>
            </td>
        </tr>         
        <tr>
            <td colspan="2">
                <hr style="width: 100%; height: 1px; background: silver;" />
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblUseWorkPackageTemplate" runat="server" Text="Use WP Template" CssClass="IndCatLabel"
                     VisibleOnNew="true" VisibleOnEdit="false" EntityProperty=""></cc3:IndCatLabel></td>
            <td align="left" style="padding-left:5px;">
                <cc3:IndCatCheckBox ID="chkUseWorkPackageTemplate" runat="server" EntityProperty="UseWorkPackageTemplate" VisibleOnNew="true" VisibleOnEdit="false">
                </cc3:IndCatCheckBox></td>
        </tr>
    </table>
</cc2:GenericEditControl>
