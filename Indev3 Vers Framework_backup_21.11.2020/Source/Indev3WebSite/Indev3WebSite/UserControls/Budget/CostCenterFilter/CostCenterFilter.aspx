<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostCenterFilter.aspx.cs"
    Inherits="UserControls_Budget_CostCenterFilter_Filter" %>

<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cost Center Filter</title>
    <base target="_self" />
    <link href="../../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>
<script type='text/javascript' src='../../../Scripts/HourglassScripts.js'></script>
<script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>


<body style="background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom; text-align: center;" onload="SetPopUpHeight(); SetColorDependingOnIE();" class="backgroundColorIE">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress();">        
        <br />
        <table style="table-layout: fixed">
            <colgroup>
                <col width="120px" />
                <col width="255px" />
            </colgroup>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="lblCountry" runat="server" CssClass="IndLabel">Country</cc1:IndLabel>
                </td>
                <td align="left">
                    <asp:Label ID="Label4" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                    <cc1:IndComboBox Width="210px" ID="cmbCountry" runat="server" AutoPostBack="True" CheckDirty="False"
                        OnSelectedIndexChanged="cmbCountry_SelectedIndexChanged">
                    </cc1:IndComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="lblInergyLocation" runat="server" CssClass="IndLabel">Inergy Location</cc1:IndLabel>
                </td>
                <td align="left">
                    <asp:Label ID="Label1" runat="server" ForeColor="#626262" Text="*"  CssClass="foreColorIE"></asp:Label>
                    <cc1:IndComboBox Width="210px" ID="cmbInergyLocation" runat="server" AutoPostBack="True" CheckDirty="False"
                        OnSelectedIndexChanged="cmbInergyLocation_SelectedIndexChanged">
                    </cc1:IndComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="lblFunction" runat="server" CssClass="IndLabel">Function</cc1:IndLabel>
                </td>
                <td align="left">
                    <asp:Label ID="Label2" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                    <cc1:IndComboBox Width="210px" ID="cmbFunction" runat="server" AutoPostBack="True" CheckDirty="False"
                        OnSelectedIndexChanged="cmbFunction_SelectedIndexChanged">
                    </cc1:IndComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="lblCostCenter" runat="server" CssClass="IndLabel">Cost Center</cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label3" runat="server" ForeColor="Yellow" Text="*"></asp:Label>
                    <cc1:IndComboBox Width="210px" ID="cmbCostCenter" runat="server" AutoPostBack="true" CheckDirty="False" OnSelectedIndexChanged="cmbCostCenter_SelectedIndexChanged">
                    </cc1:IndComboBox>
                    <asp:RequiredFieldValidator ID="reqCostCenter" runat="server" ErrorMessage="Cost Center is required."
                        ControlToValidate="cmbCostCenter" ForeColor="#626262" ValidationGroup="CCFValidationGroup" CssClass="foreColorIE">*</asp:RequiredFieldValidator>
                </td>
            </tr>
           
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel">Add to</cc1:IndLabel>
                </td>
                <td align="left">
                <asp:Label ID="Label5" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                <asp:DropDownList id="lstAddCCtoWPs" runat="server">
                    <asp:ListItem Value="Current WP">Current WP</asp:ListItem>
                    <asp:ListItem Value="My WPs">My WPs</asp:ListItem>
                    <asp:ListItem Value="All WPs">All WPs</asp:ListItem>
                </asp:DropDownList>
            </td>
            </tr>
            <tr>
                <td colspan="2" align="left" style="padding-top:10px;">
                    <asp:Button ID="Button1" runat="server" OnClick="btnOk_Click" CssClass="SaveButton"
                        ValidationGroup="CCFValidationGroup" ToolTip="Select" />
                    <asp:Button ID="Button2" runat="server" CausesValidation="False" CssClass="CancelButton"
                        ToolTip="Cancel" OnClientClick="doReturn(0); return false;" />
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <cc1:IndValidationSummary ID="IndValidationSummary1" runat="server" ValidationGroup="CCFValidationGroup"/>
                </td>
            </tr>
        </table>
        
        <radA:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableOutsideScripts="True">
            <ClientEvents OnRequestStart="RequestStartNoMaster" OnResponseEnd="ResponseEndNoMaster" />
            <AjaxSettings>
                <radA:AjaxSetting AjaxControlID="cmbCountry">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbCountry" />
                        <radA:AjaxUpdatedControl ControlID="cmbInergyLocation" />
                        <radA:AjaxUpdatedControl ControlID="cmbFunction" />
                        <radA:AjaxUpdatedControl ControlID="cmbCostCenter" />
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                    </UpdatedControls>
                </radA:AjaxSetting>
                <radA:AjaxSetting AjaxControlID="cmbInergyLocation">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbCountry" />
                        <radA:AjaxUpdatedControl ControlID="cmbInergyLocation" />
                        <radA:AjaxUpdatedControl ControlID="cmbFunction" />
                        <radA:AjaxUpdatedControl ControlID="cmbCostCenter" />
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                    </UpdatedControls>
                </radA:AjaxSetting>
                <radA:AjaxSetting AjaxControlID="cmbFunction">
                    <UpdatedControls>                        
                        <radA:AjaxUpdatedControl ControlID="cmbCostCenter" />
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                    </UpdatedControls>
                </radA:AjaxSetting>
                <radA:AjaxSetting AjaxControlID="cmbCostCenter">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbCountry" />
                        <radA:AjaxUpdatedControl ControlID="cmbInergyLocation" />
                        <radA:AjaxUpdatedControl ControlID="cmbFunction" />
                        <radA:AjaxUpdatedControl ControlID="cmbCostCenter" />
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                    </UpdatedControls>
                </radA:AjaxSetting>
            </AjaxSettings>
        </radA:RadAjaxManager>
    </form>
</body>
</html>
