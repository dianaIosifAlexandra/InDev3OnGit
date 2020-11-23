<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PeriodMassAttribution.aspx.cs"
    Inherits="UserControls_Budget_Interco_PeriodMassAttribution" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Period Mass Attribution</title>
    <base target="_self" />
    <link href="../../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src="../../../Scripts/PopUpScripts.js"></script>

<script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

<body style="background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom;"
    onload="SetOnBeforeUnload();SetPopUpHeight();">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress()">
        <div>
            <br />
            <br />
            <table style="width: 320px">
                <tr>
                    <td style="height: 27px; width: 145px;" align="right">
                        <cc1:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel" Width="60px">Start Date</cc1:IndLabel></td>
                    <td style="height: 27px; width: 160px;">
                        <cc1:IndYearMonth ID="IndStartYearMonth" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="height: 27px; width: 145px;" align="right">
                        <cc1:IndLabel ID="IndLabel2" runat="server" CssClass="IndLabel" Width="60px">End Date</cc1:IndLabel></td>
                    <td style="height: 27px; width: 160px;">
                        <cc1:IndYearMonth ID="IndEndYearMonth" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="height: 27px; width: 145px; padding-top: 10px" align="right">
                        <cc1:IndImageButton ID="btnApply" ImageUrl="../../../Images/button_save.png" ImageUrlOver="../../../Images/button_save.png"
                            runat="server" OnClick="btnApply_Click" ToolTip="Save" OnClientClick="ClearOnBeforeUnload();" />
                    </td>
                    <td style="height: 27px; width: 160px; padding-top: 10px" valign="top">
                        <input id="btnCancel" type="button" causesvalidation="false" runat="server" class="CancelButton"
                            onclick="CheckDirty();" title="Cancel" />
                    </td>
                </tr>
            </table>
        </div>
        <table style="width: 320px">
            <tr>
                <td style="width: 320px">
                    <asp:Table ID="tblErrorMessages" runat="server" CssClass="IndValidationSummaryHRMassAttr">
                        <asp:TableRow runat="server">
                            <asp:TableCell runat="server">
                                <asp:BulletedList runat="server" ID="lstValidationSummary">
                                </asp:BulletedList>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
