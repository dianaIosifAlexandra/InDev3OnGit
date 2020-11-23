<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PopUp.aspx.cs" Inherits="Inergy.Indev3.UI.PopUp"  EnableEventValidation="false" %>

<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add/Edit Entity</title>
    <base target="_self" />
    <link href="Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='Scripts/PopUpScripts.js'></script>

<script type='text/javascript' src='Scripts/ErrorScripts.js'></script>

<script type='text/javascript' src='Scripts/GeneralScripts.js'></script>

<script type='text/javascript' src='Scripts/NumberRepresentation.js'></script>
<body style="background: #626262 url('Images/back_popup.png') no-repeat right bottom;
    text-align: center;" onload="SetOnBeforeUnload();SetPopUpHeight(); SetColorDependingOnIE();" class="backgroundColorIE">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress()">
        <div style="width: 90%;">
            <table style="width:100%">
                <tr style="width:100%" align="left">
                    <td align="left">
                        <asp:Table ID="tblHeader" runat="server" Width="100%">
                            <asp:TableRow ID="HeaderRow">
                                <asp:TableCell ID="HeaderCell" HorizontalAlign="left" VerticalAlign="bottom">
                                    <cc1:IndCatLabel ID="HeaderLabel" runat="server"></cc1:IndCatLabel>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <hr style="width: 100%; background: silver;" />
                    </td>
                </tr>
                <tr style="width:100%" align="center">
                    <td align="center">
                        <asp:Table ID="tbl" runat="server" Width="100%" align="center">
                            <asp:TableRow>
                                <asp:TableCell HorizontalAlign="center" VerticalAlign="Top">
                                    <asp:PlaceHolder ID="plhEditControl" runat="server" EnableViewState="true"></asp:PlaceHolder>
                                </asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow ID="FooterRow">
                                <asp:TableCell ID="FooterCell" HorizontalAlign="center" VerticalAlign="bottom">
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <asp:Table ID="tblFooter" runat="server" Width="100%">
                            <asp:TableRow ID="ValidationRow">
                                <asp:TableCell ID="ValidationCell" HorizontalAlign="left">
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
<script type='text/javascript' src='Scripts/GetInternetExplorerVersion.js'></script>
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
