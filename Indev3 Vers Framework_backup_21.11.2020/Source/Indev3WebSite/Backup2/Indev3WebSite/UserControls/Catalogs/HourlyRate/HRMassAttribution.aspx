<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="HRMassAttribution.aspx.cs"
    Inherits="UserControls_Catalogs_HourlyRate_HRMassAttribution" %>

<%@ Register Assembly="RadInput.Net2" Namespace="Telerik.WebControls" TagPrefix="radI" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc2" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Hourly Rate Mass Attribution</title>
    <base target="_self" />
    <link href="../../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>

<script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

<script type='text/javascript'>
function EnableControls() 
{
    var btnSave = document.getElementById('btnSave');
    var btnCancel = document.getElementById('btnCancel');

    btnSave.disabled = false;
    btnCancel.disabled = false;
}

function DisableControls()
{
    var btnSave = document.getElementById('btnSave');
    var btnCancel = document.getElementById('btnCancel');

    btnSave.disabled = true;
    btnCancel.disabled = true;
    
    __doPostBack('btnSave', null);
}
</script>

<body onload="SetOnBeforeUnload(); EnableControls();" style="background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom;">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress()">
        <div style="padding-right: 2%; padding-left: 10%; padding-bottom: 2%; margin: 2%;
            padding-top: 2%; text-align: center">
            <table style="width: 85%" border="0">
                <tr>
                    <td style="width: 205px; height: 21px;" align="center">
                        <cc2:IndLabel ID="IndLabel5" runat="server" CssClass="IndLabel" Width="172px">Available Inergy Locations</cc2:IndLabel></td>
                    <td style="height: 21px" align="center">
                        <cc2:IndLabel ID="IndLabel6" runat="server" CssClass="IndLabel" Width="172px">Mass Attribution Parameters</cc2:IndLabel></td>
                </tr>
                <tr>
                    <td style="width: 205px">
                        <asp:ListBox ID="lstInergyLogins" runat="server" Width="205px" Height="310px" SelectionMode="Multiple"
                            Rows="10" OnSelectedIndexChanged="lstInergyLogins_SelectedIndexChanged" AutoPostBack="true"
                            EnableViewState="true"></asp:ListBox></td>
                    <td align="left" valign="top">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 82px" align="right">
                                    <cc2:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel" Width="82px">Start Period</cc2:IndLabel></td>
                                <td align="right" style="width: 43px">
                                    <asp:Label ID="Label1" runat="server" ForeColor="Yellow" Text="*"></asp:Label></td>
                                <td style="width: 39px" align="left">
                                    <cc2:IndYearMonth ID="dtStartDate" runat="server" Width="120px" CheckDirty="true" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 82px" align="right">
                                    <cc2:IndLabel ID="IndLabel2" runat="server" CssClass="IndLabel" Width="82px">End Period</cc2:IndLabel></td>
                                <td align="right" style="width: 43px">
                                    <asp:Label ID="Label2" runat="server" ForeColor="Yellow" Text="*"></asp:Label></td>
                                <td style="width: 39px" align="left">
                                    <cc2:IndYearMonth ID="dtEndDate" runat="server" Width="120px" CheckDirty="true" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 82px" align="right">
                                    <cc2:IndLabel ID="IndLabel3" runat="server" CssClass="IndLabel" Width="60px">Currency</cc2:IndLabel></td>
                                <td align="right" style="width: 43px">
                                    <asp:Label ID="Label3" runat="server" ForeColor="Yellow" Text="*"></asp:Label></td>
                                <td style="width: 39px" align="left">
                                    <cc2:IndLabel ID="lblCurrencyName" runat="server" Width="132px">
                                    </cc2:IndLabel>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 82px" align="right">
                                    <cc2:IndLabel ID="IndLabel4" runat="server" CssClass="IndLabel" Width="69px">Hourly Rate</cc2:IndLabel></td>
                                <td align="right" style="width: 43px">
                                    <asp:Label ID="Label4" runat="server" ForeColor="Yellow" Text="*"></asp:Label></td>
                                <td style="width: 39px" align="left">
                                    <cc2:IndCatTextBox ID="txtHourlyRate" runat="server" Width="106px" MaxLength="11" />
                                </td>
                            </tr>
                        </table>
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
            <table style="width: 85%;margin-top:20px;" border="0">
                <tr>
                    <td align="right" style="width: 50%" valign="top">
                        <cc2:IndImageButton ID="btnSave" runat="server" Text="Save" OnClientClick="ClearOnBeforeUnload(); DisableControls();"
                            OnClick="btnSave_Click" ImageUrl="../../../Images/button_save.png" ImageUrlOver="../../../Images/button_save.png" ToolTip="Save" />
                            </td>                       
                    <td style="width: 50%" align="left" valign="top">
                        <input id="btnCancel" type="button" value="" runat="server" onclick="CheckDirty();" class="CancelButton" title="Cancel" />
                    </td>
                </tr>
            </table>
            <radA:RadAjaxManager ID="Aj" runat="server" EnableOutsideScripts="True">
            </radA:RadAjaxManager>
        </div>
    </form>
</body>
</html>
