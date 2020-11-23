<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IntercoMassAttribution.aspx.cs"
    Inherits="UserControls_Budget_Interco_IntercoMassAttribution" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Period Mass Attribution</title>
    <base target="_self" />
    <link href="../../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>

<script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

<body style="background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom;"
    onload="SetOnBeforeUnload();SetPopUpHeight();SetColorDependingOnIE();" class="backgroundColorIE">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress();">
        <div>
            <br />
            <table style="width: 220px">
                <tr>
                    <td align="right">
                        <cc1:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel">Percent</cc1:IndLabel>
                    </td>
                    <td align="left" style="width: 50%">
                        <asp:Label ID="lblValidation" runat="Server" Text="*" CssClass="ErrorLabel"></asp:Label><cc1:IndTextBox
                            ID="txtPercent" runat="server" CheckDirty="True" Width="62px"></cc1:IndTextBox><asp:RequiredFieldValidator
                                ID="reqPercent" runat="server" ErrorMessage="Select the Percent" ControlToValidate="txtPercent"
                                ForeColor="#626262" ValidationGroup="vgrPercent" CssClass="foreColorIE">*</asp:RequiredFieldValidator><asp:RangeValidator
                                    ID="rngPercent" runat="server" ControlToValidate="txtPercent" ErrorMessage="Percent must be between 0 and 100."
                                    ForeColor="#626262" MaximumValue="100" MinimumValue="0" Type="Double" ValidationGroup="vgrPercent" CssClass="foreColorIE">*</asp:RangeValidator></td>
                </tr>
                <tr>
                    <td align="right" style="padding-top: 10px">
                        <cc1:IndImageButton ID="btnApply" ImageUrl="../../../Images/button_save.png" ImageUrlOver="../../../Images/button_save.png"
                            runat="server" OnClientClick="ClearOnBeforeUnload();" OnClick="btnApply_Click"
                            ValidationGroup="vgrPercent" ToolTip="Save" />
                    </td>
                    <td align="left" style="width: 50%; padding-top: 10px" valign="top">
                        <input id="btnCancel" type="button" causesvalidation="false" runat="server" class="CancelButton"
                            onclick="CheckDirty();" title="Cancel" />
                    </td>
                </tr>
            </table>
        </div>
        <table style="width: 220px">
            <tr>
                <td align="center">
                    <cc1:IndValidationSummary ID="vsmPercent" runat="server" ValidationGroup="vgrPercent" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
