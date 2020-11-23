<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ page language="C#" autoeventwireup="true" inherits="Pages_Budget_InitialBudget_OtherCosts, App_Web_jmyovmdy" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>On Project Costs</title>
    <base target="_self" />
    <link href="../../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>

<script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

<body style="background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom;
    text-align: center;" onload="SetPopUpHeight();SetColorDependingOnIE();" class="backgroundColorIE">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress()">
        <div>
            <table style="width: 300px" class="tabbed backgroundColorIE" align="center">
                <tr>
                    <td align="right">
                        <ind:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel" Text="T&E" />
                    </td>
                    <td align="left">
                        <ind:IndTextBox ID="txtTE" runat="server" MaxLength="9"></ind:IndTextBox>
                        <asp:RangeValidator ID="rngTE" runat="server" ControlToValidate="txtTE" ErrorMessage="Field T&E must be a positive decimal number"
                            ForeColor="#626262" MaximumValue="999999999" MinimumValue="0" Type="Double" ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <ind:IndLabel ID="IndLabel3" runat="server" CssClass="IndLabel" Text="Proto Parts" />
                    </td>
                    <td align="left">
                        <ind:IndTextBox ID="txtProtoParts" runat="server" MaxLength="9"></ind:IndTextBox>
                        <asp:RangeValidator ID="rngProtoParts" runat="server" ControlToValidate="txtProtoParts"
                            ErrorMessage="Field Proto parts must be a positive decimal number" ForeColor="#626262"
                            MaximumValue="999999999" MinimumValue="0" Type="Double" ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <ind:IndLabel ID="IndLabel2" runat="server" CssClass="IndLabel" Text="Proto Tooling" />
                    </td>
                    <td align="left">
                        <ind:IndTextBox ID="txtProtoTooling" runat="server" MaxLength="9"></ind:IndTextBox>
                        <asp:RangeValidator ID="rngProtoTooling" runat="server" ControlToValidate="txtProtoTooling"
                            ErrorMessage="Field Proto tooling must be a positive decimal number" ForeColor="#626262"
                            MaximumValue="999999999" MinimumValue="0" Type="Double" ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <ind:IndLabel ID="indLabel" runat="server" CssClass="IndLabel" Text="Trials" />
                    </td>
                    <td align="left">
                        <ind:IndTextBox ID="txtTrials" runat="server" MaxLength="9"></ind:IndTextBox>
                        <asp:RangeValidator ID="rngTrials" runat="server" ControlToValidate="txtTrials" ErrorMessage="Field Trials must be a positive decimal number"
                            ForeColor="#626262" MaximumValue="999999999" MinimumValue="0" Type="Double" ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <ind:IndLabel ID="IndLabel5" runat="server" CssClass="IndLabel" Text="Other Expenses" />
                    </td>
                    <td align="left">
                        <ind:IndTextBox ID="txtOtherExpenses" runat="server" MaxLength="9"></ind:IndTextBox>
                        <asp:RangeValidator ID="rngOtherExpenses" runat="server" ControlToValidate="txtOtherExpenses"
                            ErrorMessage="Field Other expenses must be a positive decimal number" ForeColor="#626262"
                            MaximumValue="999999999" MinimumValue="0" Type="Double" ValidationGroup="OtherCosts" CssClass="foreColorIE">*</asp:RangeValidator>
                    </td>
                </tr>
            </table>
            <table style="width: 300px; border: 0px" align="center">
                <tr>
                    <td align="right">
                        <ind:IndImageButton ID="btnApply" ValidationGroup="OtherCosts" ImageUrl="../../../Images/button_save.png"
                            ImageUrlOver="../../../Images/button_save.png" runat="server" OnClick="btnApply_Click"
                            OnClientClick="ClearOnBeforeUnload();" />
                    </td>
                    <td align="left">
                        <ind:IndImageButton ID="btnCancel" CausesValidation="false" runat="server" ImageUrl="../../../Images/button_cancel.png"
                            ImageUrlOver="../../../Images/button_cancel.png" OnClientClick="CheckDirty(); return false;" /></td>
                </tr>
            </table>
            <table style="width: 300px" align="center">
                <tr>
                    <td align="center" style="width: 369px">
                        <asp:Table ID="tblErrorMessages" runat="server">
                            <asp:TableRow ID="TableRow1" runat="server">
                                <asp:TableCell ID="TableCell1" runat="server">
                                    <ind:IndValidationSummary ID="sumOtherCosts" runat="server" ValidationGroup="OtherCosts" />
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                     </td>
                 </tr>
            </table>
        </div>
    </form>
<script type="text/javascript">
    if (!document.querySelectorAll) {
        document.querySelectorAll = function (selectors) {
            var style = document.createElement('style'), elements = [], element;
            document.documentElement.firstChild.appendChild(style);
            document._qsa = [];

            style.styleSheet.cssText = selectors + '{x-qsa:expression(document._qsa && document._qsa.push(this))}';
            window.scrollBy(0, 0);
            style.parentNode.removeChild(style);

            while (document._qsa.length) {
                element = document._qsa.shift();
                element.style.removeAttribute('x-qsa');
                elements.push(element);
            }
            document._qsa = null;
            return elements;
        };
    }

    if (!document.querySelector) {
        document.querySelector = function (selectors) {
            var elements = document.querySelectorAll(selectors);
            return (elements.length) ? elements[0] : null;
        };
    }

    (function () {
        var elements = document.querySelectorAll(".backgroundColorIE");
        var ieVersion = GetInternetExplorerVersion();
        if (elements != null) {
            for (var i = 0; i < elements.length; i++) {
                if (ieVersion < 9 && ieVersion > 0)
                    elements[i].style.backgroundColor = "#757575";
                else {
                    elements[i].style.backgroundColor = "#6E6E6E";
                }
            }
        }
    })()
</script>

</body>
</html>