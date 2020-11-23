<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ page language="C#" autoeventwireup="true" inherits="UserControls_Budget_ProjectCoreTeamMember_SelectCoreTeamMember, App_Web_x2wxkadj" %>

<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Select Associate</title>
    <base target="_self" />
    <link href="../../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>

<script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

<body style="background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom;" onload="SetPopUpHeight(); SetColorDependingOnIE();"  class="backgroundColorIE">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress()">
        <br />
        <div style="padding-left:15px;">
            <table>
                <tr>
                    <td align="right">
                        <cc1:IndLabel ID="lblCountry" runat="server" CssClass="IndLabel">Country</cc1:IndLabel>
                    </td>
                    <td align="left">
                        <asp:Label ID="Label2" runat="server" ForeColor="#626262" Text="*"  CssClass="foreColorIE"></asp:Label>
                        <cc1:IndComboBox ID="cmbCt" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbCt_SelectedIndexChanged"
                            CheckDirty="False">
                        </cc1:IndComboBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <cc1:IndLabel ID="lblAssociate" runat="server" CssClass="IndLabel">Associate</cc1:IndLabel></td>
                    <td align="left">
                        <asp:Label ID="Label1" runat="server" ForeColor="Yellow" Text="*"></asp:Label>
                        <cc1:IndComboBox ID="cmbAs" runat="server" CheckDirty="false" DropDownWidth="139px">
                        </cc1:IndComboBox>
                        <asp:RequiredFieldValidator ID="RFV1" runat="server" ErrorMessage="Associate is required."
                            ForeColor="#626262" ControlToValidate="cmbAs" CssClass="foreColorIE">*</asp:RequiredFieldValidator></td>
                </tr>
                <tr>
                    <td colspan="2" align="left" style="padding-top: 10px;">
                        <cc1:IndImageButton ID="btnSave" runat="server" ToolTip="Select" ImageUrl="../../../Images/button_save.png"
                            ImageUrlOver="../../../Images/button_save.png" CheckDirty="false"/>
                        <input type="button" id="btnCancel" runat="server" title="Cancel" causesvalidation="False"
                            class="CancelButton" onclick="doReturn(0); return false;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <cc1:IndValidationSummary ID="ValidationSummary1" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
        <radA:RadAjaxManager ID="Aj" runat="server" EnableOutsideScripts="True">
            <AjaxSettings>
                <radA:AjaxSetting AjaxControlID="cmbCt">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbAs" />
                    </UpdatedControls>
                </radA:AjaxSetting>
            </AjaxSettings>
        </radA:RadAjaxManager>
    </form>
</body>
<script type='text/javascript' src='../../../Scripts/GetInternetExplorerVersion.js'></script>
<script type="text/javascript">
    if (GetInternetExplorerVersion() < 9 && GetInternetExplorerVersion() > 0)
{
    try {
        if (RadComboBox !== undefined) {
            var prototype = RadComboBox.prototype;
            var set_text = prototype.SetText;
            var propertyChange = prototype.OnInputPropertyChange;

            prototype.SetText = function (value) {
                this._skipEvent = 0;
                set_text.call(this, value);
            };

            prototype.OnInputPropertyChange = function () {
                if (!event.propertyName)
                    event = event.rawEvent;
                if (event.propertyName == "value") {
                    this._skipEvent++;
                    if (this._skipEvent == 2)
                        return;
                    propertyChange.call(this);
                }
            }
        }
    }
    catch (err) {
    }
}
</script> 

</html>
