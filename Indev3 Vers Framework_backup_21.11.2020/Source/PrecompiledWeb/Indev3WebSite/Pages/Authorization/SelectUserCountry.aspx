<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ page language="C#" autoeventwireup="true" inherits="Pages_Authorization_SelectUserCountry, App_Web_epbzwcsm" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Select Country</title>
    <base target="_self" />
    <link href="../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../Scripts/PopUpScripts.js'></script>

<script type='text/javascript' src='../../Scripts/GeneralScripts.js'></script>

<body style="background: #626262; text-align: center;" onload="SetPopUpHeight();SetColorDependingOnIE();" class="backgroundColorIE">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress();">
        <div>
            <table cellpadding="6px">
                <tr>
                    <td colspan="2">
                        <cc1:IndLabel ID="lblTitle" runat="server" Text="You are registered in two or more countries. Please select one country."></cc1:IndLabel>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <cc1:IndLabel ID="lblCountries" runat="server" Text="Country"></cc1:IndLabel>
                    </td>
                    <td align="left">
                        <cc1:IndLabel ID="lblRequired" runat="server" ForeColor="Yellow" Text="*"></cc1:IndLabel>
                        <cc1:IndComboBox ID="cmbCountries" runat="server">
                        </cc1:IndComboBox>
                        <asp:RequiredFieldValidator ID="reqCountry" runat="server" ControlToValidate="cmbCountries"
                            ErrorMessage="Country is required." ForeColor="#626262" CssClass="foreColorIE">*</asp:RequiredFieldValidator></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <cc1:IndImageButton ID="btnLogin" runat="server" ImageUrl="../../Images/button_save.png"
                            ImageUrlOver="../../Images/button_save.png" OnClick="btnLogin_Click" ToolTip="Select Country" />
                        <input type="button" causesvalidation="false" id="btnCancel" runat="server" onclick="doReturn(0); return false;" title="Cancel" class="CancelButton" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <cc1:IndValidationSummary ID="IndValidationSummary1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
