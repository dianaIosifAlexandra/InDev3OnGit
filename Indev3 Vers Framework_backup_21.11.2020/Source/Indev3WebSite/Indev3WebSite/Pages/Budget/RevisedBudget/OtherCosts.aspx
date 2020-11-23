<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OtherCosts.aspx.cs" Inherits="Pages_Budget_RevisedBudget_OtherCosts" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>On Project Costs</title>
    <base target="_self" />
    <link href="../../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>

<script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

<body style="background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom;
    text-align: center;" onload="SetOnBeforeUnload();SetPopUpHeight();SetColorDependingOnIE();" class="backgroundColorIE">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress()">
        <div style="width: 90%;">
            <table width="100%">
                <tr>
                    <td align="right">
                    </td>
                    <td align="center">
                        <ind:IndLabel ID="IndLabel6" runat="server" CssClass="IndLabel">Released</ind:IndLabel>
                    </td>
                    <td>
                        <ind:IndLabel ID="IndLabel7" runat="server" CssClass="IndLabel">Update</ind:IndLabel>
                    </td>
                    <td align="center">
                        <ind:IndLabel ID="IndLabel8" runat="server" CssClass="IndLabel">InProgress</ind:IndLabel>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="padding-right: 10px">
                        <ind:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel">T&E</ind:IndLabel>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblCurrentTE" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                    <td align="center">
                        <ind:IndTextBox ID="txtUpdateTE" runat="server" CssClass="txtOtherCosts" MaxLength="9"></ind:IndTextBox>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblNewTE" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="padding-right: 10px">
                        <ind:IndLabel ID="IndLabel2" runat="server" CssClass="IndLabel">Proto parts</ind:IndLabel>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblCurrentProtoParts" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                    <td align="center">
                        <ind:IndTextBox ID="txtUpdateProtoParts" runat="server" CssClass="txtOtherCosts"
                            MaxLength="9"></ind:IndTextBox>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblNewProtoParts" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="padding-right: 10px">
                        <ind:IndLabel ID="IndLabel3" runat="server" CssClass="IndLabel">Proto tooling</ind:IndLabel>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblCurrentProtoTooling" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                    <td align="center">
                        <ind:IndTextBox ID="txtUpdateProtoTooling" runat="server" CssClass="txtOtherCosts"
                            MaxLength="9"></ind:IndTextBox>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblNewProtoTooling" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="padding-right: 10px">
                        <ind:IndLabel ID="IndLabel4" runat="server" CssClass="IndLabel">Trials</ind:IndLabel>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblCurrentTrials" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                    <td align="center">
                        <ind:IndTextBox ID="txtUpdateTrials" runat="server" CssClass="txtOtherCosts" MaxLength="9"></ind:IndTextBox>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblNewTrials" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="padding-right: 10px">
                        <ind:IndLabel ID="IndLabel5" runat="server" CssClass="IndLabel">Other expenses</ind:IndLabel>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblCurrentOtherExpenses" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                    <td align="center">
                        <ind:IndTextBox ID="txtUpdateOtherExpenses" runat="server" CssClass="txtOtherCosts"
                            MaxLength="9"></ind:IndTextBox>
                    </td>
                    <td align="center">
                        <ind:IndFormatedLabel ID="lblNewOtherExpenses" runat="server" CssClass="IndLabel"></ind:IndFormatedLabel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right" style="width: 50%;">
                        <asp:Button ID="btnSave" runat="server" CssClass="SaveButton" ToolTip="Save" ValidationGroup="OtherCosts"
                            OnClientClick="ClearOnBeforeUnload();" OnClick="btnSave_Click" Style="Cursor:Hand"/>
                    </td>
                    <td colspan="2" align="left" style="width: 50%;">
                        <input id="btnCancel" causesvalidation="false" type="button" title="Cancel" runat="server"
                            class="CancelButton" onclick="CheckDirty(); return false;" />
                            
                        <asp:RangeValidator
                                ID="rngTE" runat="server" ControlToValidate="txtUpdateTE" ErrorMessage="T&E is not decimal"
                                ForeColor="#626262" MaximumValue="999999999" MinimumValue="-999999999" Type="Double"
                                ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                        <asp:RangeValidator ID="rngProtoParts"
                                    runat="server" ControlToValidate="txtUpdateProtoParts" ErrorMessage="Proto parts is not decimal"
                                    ForeColor="#626262" MaximumValue="999999999" MinimumValue="-999999999" Type="Double"
                                    ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                        <asp:RangeValidator ID="rngProtoTooling"
                                        runat="server" ControlToValidate="txtUpdateProtoTooling" ErrorMessage="Proto tooling is not decimal"
                                        ForeColor="#626262" MaximumValue="999999999" MinimumValue="-999999999" Type="Double"
                                        ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                        <asp:RangeValidator ID="rngTrials"
                                            runat="server" ControlToValidate="txtUpdateTrials" ErrorMessage="Trials is not decimal"
                                            ForeColor="#626262" MaximumValue="999999999" MinimumValue="-999999999" Type="Double"
                                            ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                         <asp:RangeValidator ID="rngOtherExpenses"
                                                runat="server" ControlToValidate="txtUpdateOtherExpenses" ErrorMessage="Other expenses is not decimal"
                                                ForeColor="#626262" MaximumValue="999999999" MinimumValue="-999999999" Type="Double"
                                                ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                        <asp:CompareValidator ID="cmpTE" runat="server" ControlToValidate="txtUpdateTE" ForeColor="#626262"
                            Type="Double" ValidationGroup="OtherCosts" ErrorMessage="InProgress T&E must be positive." Operator="GreaterThanEqual" CssClass="foreColorIE">*</asp:CompareValidator>
                        <asp:CompareValidator ID="cmpProtoParts" runat="server" ControlToValidate="txtUpdateProtoParts"
                            ForeColor="#626262" Type="Double" ValidationGroup="OtherCosts" ErrorMessage="InProgress Proto Parts must be positive." Operator="GreaterThanEqual" CssClass="foreColorIE">*</asp:CompareValidator>
                        <asp:CompareValidator ID="cmpProtoTooling" runat="server" ControlToValidate="txtUpdateProtoTooling"
                            ForeColor="#626262" Type="Double" ValidationGroup="OtherCosts" ErrorMessage="InProgress Proto Tooling must be positive." Operator="GreaterThanEqual" CssClass="foreColorIE">*</asp:CompareValidator>
                        <asp:CompareValidator ID="cmpTrials" runat="server" ControlToValidate="txtUpdateTrials"
                            ForeColor="#626262" Type="Double" ValidationGroup="OtherCosts" ErrorMessage="InProgress Trials must be positive." Operator="GreaterThanEqual" CssClass="foreColorIE">*</asp:CompareValidator>
                        <asp:CompareValidator ID="cmpOtherExpenses" runat="server" ControlToValidate="txtUpdateOtherExpenses"
                            ForeColor="#626262" Type="Double" ValidationGroup="OtherCosts" ErrorMessage="InProgress Other Expenses must be positive." Operator="GreaterThanEqual" CssClass="foreColorIE">*</asp:CompareValidator></td>
                </tr>
            </table>
            <ind:IndValidationSummary ID="sumOtherCosts" runat="server" ValidationGroup="OtherCosts" />
            </div>
    </form>
</body>
</html>
