<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectEdit.ascx.cs" Inherits="UserControls_Project_ProjectEdit" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
    <script type="text/javascript">
        function SetProjectCodeDirty() {

            var isDirty = document.getElementById("IsDirty");
            var codeIsDirty = document.getElementById("CodeIsDirty");

            if (isDirty !== null && codeIsDirty !== null) {
                isDirty.value = "1"; //CheckDirty attribute is false, we need to set IsDirty to 1 manually
                codeIsDirty.value = "1";

                var hasActualData = document.getElementById("hdnHasActualData");
                if (hasActualData != null) {
                    hasActualData.value = "0";

                    var all = document.all;
                    var elements = [];

                    for (var i = 0, l = all.length; i < l; i++) {
                        if (all[i] != null && all[i].attributes != null && all[i].attributes.length > 0 && all[i].attributes["class"] != "undefined") {
                            if (all[i].attributes["class"] != null && all[i].attributes["class"].value != null && all[i].attributes["class"].value == "HasActualData")
                                elements.push(all[i]);
                        }
                    }

                    if (elements != null && elements.length > 0) {
                        if (elements[0].innerHTML == "1")
                            hasActualData.value = "1";
                    }
                }
            }
        }
</script>
<cc2:GenericEditControl ID="ProjectEditControl" runat="server">
    <table border="0" style="table-layout:fixed;">
        <colgroup>
            <col width="140px" />
            <col width="185px" />
            <col width="0px" />
        </colgroup>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblCode" runat="server" Text="Code"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtCode" runat="server" CheckDirty="false" EntityProperty="Code" Width="150px"
                    AlphaNumericCheck="True" onchange="SetProjectCodeDirty();"></cc3:IndCatTextBox>
           </td>
           <td></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblName" runat="server" Text="Name"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox></td>
            <td></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblProgramCode" runat="server" Text="Program Code"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbProgram" runat="server" EntityProperty="IdProgram" DataTextField="Code"
                    DataValueField="Id" Width="152px" ReferencedControlName="lblProgramName" ReferencedControlValueMember="Name">
                </cc3:IndCatComboBox>
            </td>
            <td></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblProgram" Width="90px" runat="server" Text="Program Name"></cc3:IndCatLabel>
            </td>
            <td align="left" style="padding-left: 8px; padding-top: 3px;">
                <cc3:IndCatLabel ID="lblProgramName" runat="server" CssClass="IndCatLabel" EntityProperty="ProgramName"></cc3:IndCatLabel>
            </td>
           <td></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblProjectType" runat="server" Text="Project Type"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbProjectType" runat="server" EntityProperty="IdProjectType"
                    DataTextField="Type" DataValueField="Id" Width="152px">
                </cc3:IndCatComboBox>
            </td>
           <td></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblIsActive" runat="server" Text="Active" CssClass="IndCatLabel"
                    EnabledOnNew="true" EntityProperty=""></cc3:IndCatLabel></td>
            <td align="left" style="padding-left:5px;">
                <cc3:IndCatCheckBox ID="chkIsActive" runat="server" EntityProperty="IsActive" EnabledOnNew="true">
                </cc3:IndCatCheckBox></td>
           <td></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblMembers" runat="server" Text="Active Members"></cc3:IndCatLabel>
            </td>
            <td align="left" style="padding-left: 8px; padding-top: 3px;">
                <cc3:IndCatLabel ID="lblActiveMembers" runat="server" CssClass="IndCatLabel" VisibleOnNew="false" EntityProperty="ActiveMembers"></cc3:IndCatLabel>
            </td>
           <td></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblTimingInterco" runat="server" Text="Timing & Interco %"></cc3:IndCatLabel>
            </td>
            <td align="left" style="padding-left: 8px; padding-top: 3px;">
                <cc3:IndCatLabel ID="lblTimingIntercoPercent" runat="server" CssClass="IndCatLabel" VisibleOnNew="false" EntityProperty="TimingIntercoPercent"></cc3:IndCatLabel>
            </td>
           <td></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblInitialBudget" runat="server" Text="Initial Budget Validated"></cc3:IndCatLabel>
            </td>
            <td align="left" style="padding-left: 8px; padding-top: 3px;">
                <cc3:IndCatLabel ID="lblInitialBudgetValidated" runat="server" CssClass="IndCatLabel" VisibleOnNew="false" EntityProperty="IsInitialBudgetValidated"></cc3:IndCatLabel>
            </td>
            <td align="left">
                <cc3:IndCatLabel ID="IndCatLabel2" runat="server" CssClass="HasActualData" VisibleOnNew="false"
                EntityProperty="HasActualData" style="visibility:hidden; height:0px"></cc3:IndCatLabel>
            </td>       
        </tr>         
        <tr>
            <td colspan="3">
                <hr style="width: 100%; background: silver;" />
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblUseWorkPackageTemplate" runat="server" Text="Use WP Template" CssClass="IndCatLabel"
                     VisibleOnNew="true" VisibleOnEdit="false" EntityProperty=""></cc3:IndCatLabel></td>
            <td align="left" style="padding-left:5px;">
                <cc3:IndCatCheckBox ID="chkUseWorkPackageTemplate" runat="server" EntityProperty="UseWorkPackageTemplate" VisibleOnNew="true" VisibleOnEdit="false">
                </cc3:IndCatCheckBox></td>
            <td></td>
        </tr>
    </table>
    <input type="hidden" id="CodeIsDirty" />
    <input type="hidden" id="hdnHasActualData" />
</cc2:GenericEditControl>