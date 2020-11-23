<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SelectProject.aspx.cs" Inherits="UserControls_ProjectSelector_SelectProject" %>

<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls" TagPrefix="cc1" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Project Selector</title>
    <base target="_self" />    
    <link href="../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../Scripts/PopUpScripts.js'></script>
<script type='text/javascript' src='../../Scripts/HourglassScripts.js'></script>
<script type='text/javascript' src='../../Scripts/GeneralScripts.js'></script>
<script type='text/javascript' src='../../Scripts/GeneralScripts.js'></script>
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

<body  style="background-color: #626262; background: url('../../Images/back_popup.png') no-repeat right bottom;
    text-align: center;" onload="SetPopUpHeight(); SetColorDependingOnIE();" class="backgroundColorIE">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress()">
    <telerik:RadScriptManager ID="RadScriptManager2" runat="server">
    </telerik:RadScriptManager>
        <br />
        <table>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="IndLabel2" runat="server" CssClass="IndLabel">Program Owner</cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label4" runat="server" ForeColor="#626262" Text="*" class="foreColorIE"></asp:Label>
                    <cc1:IndComboBox ID="cmbOW" runat="server" OnSelectedIndexChanged="cmbOW_SelectedIndexChanged"
                        Width="345px" DropDownWidth="334px" AutoPostBack="True" CheckDirty="False">
                    </cc1:IndComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="IndLabel4" runat="server" CssClass="IndLabel">Program</cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label3" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                    <cc1:IndComboBox ID="cmbPG" runat="server" Width="345px" DropDownWidth="334px"
                        OnSelectedIndexChanged="cmbPG_SelectedIndexChanged" AutoPostBack="True"
                        CheckDirty="False">
                    </cc1:IndComboBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="IndLabel3" runat="server" CssClass="IndLabel">Project</cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label7" runat="server" ForeColor="Yellow" Text="*"></asp:Label>
                    <cc1:IndComboBox ID="cmbPJ" runat="server" Width="345px" DropDownWidth="334px"
                        OnSelectedIndexChanged="cmbPJ_SelectedIndexChanged" AutoPostBack="True"
                        CheckDirty="False">
                    </cc1:IndComboBox>
                    <asp:RequiredFieldValidator ID="reqProjects" runat="server" ControlToValidate="cmbPJ"
                        ErrorMessage="Project is required." ForeColor="#626262" CssClass="foreColorIE">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
				<td align="right">
					<cc1:IndLabel ID="lblProjectsOrder" runat="server" Text="Order Projects by"></cc1:IndLabel>
				</td>
				<td align="left">
					<asp:RadioButtonList ID="rbOrderProjects" runat="server" AutoPostBack="true" RepeatDirection="Horizontal" 
						CssClass="RadioButton" OnSelectedIndexChanged="rbOrderProjects_SelectedIndexChanged">
						<asp:ListItem Selected="True" Value="C" Text="Code" />
						<asp:ListItem Value="N" Text="Name" />
					</asp:RadioButtonList>
				</td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="Label2" runat="server" Text="Your Function"></cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label6" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                    <cc1:IndLabel ID="lblFunction" runat="server" CssClass="IndLabel"></cc1:IndLabel>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="IndLabel1" runat="server" Text="Active Members"></cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label1" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                    <cc1:IndLabel ID="lblActiveMembers" runat="server" CssClass="IndLabel"></cc1:IndLabel>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="IndLabel5" runat="server" Text="Timing & Interco %"></cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label5" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                    <cc1:IndLabel ID="lblTimingIntercoPercent" runat="server" CssClass="IndLabel"></cc1:IndLabel>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="IndLabel6" runat="server" Text="Initial Budget Validated"></cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label9" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                    <cc1:IndLabel ID="lblInitialBudgetValidated" runat="server" CssClass="IndLabel"></cc1:IndLabel>
                </td>
            </tr>            
            <tr>
                <td align="right">
                    <cc1:IndLabel ID="lblShowOnly" runat="server" CssClass="IndLabel">Show only</cc1:IndLabel></td>
                <td align="left">
                    <asp:Label ID="Label8" runat="server" ForeColor="#626262" Text="*" CssClass="foreColorIE"></asp:Label>
                    <cc1:IndComboBox ID="cmbShowOnly" runat="server" Width="80px" OnSelectedIndexChanged="cmbShowOnly_SelectedIndexChanged"
                        AutoPostBack="True" CheckDirty="False">
                    </cc1:IndComboBox>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left">
                    <cc1:IndImageButton ID="btnSelect" runat="server" OnClick="btnSelect_Click"
                        ImageUrl="../../Images/button_save.png" ImageUrlOver="../../Images/button_save.png"
                        ToolTip="Select" />
                    <%--<asp:Button ID="Button1" runat="server" CausesValidation="False" CssClass="CancelButton"
                        ToolTip="Cancel" OnClientClick="doReturn(0); return false;" />--%>
                    <asp:Button ID="Button1" runat="server" CausesValidation="False" CssClass="CancelButton"
                        ToolTip="Cancel" OnClientClick="sendAndClose('cancel'); return false;" />
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <cc1:IndValidationSummary ID="IndValidationSummary1" runat="server" />
                </td>
            </tr>
        </table>
        
        <radA:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableOutsideScripts="True">
            <ClientEvents OnRequestStart="RequestStartNoMaster" OnResponseEnd="ResponseEndNoMaster" />
            <AjaxSettings>
                <radA:AjaxSetting AjaxControlID="cmbOW">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbOW" />
                        <radA:AjaxUpdatedControl ControlID="cmbPG" />
                        <radA:AjaxUpdatedControl ControlID="cmbPJ" />
                        <radA:AjaxUpdatedControl ControlID="lblFunction" />
                        <radA:AjaxUpdatedControl ControlID="lblActiveMembers" />
                        <radA:AjaxUpdatedControl ControlID="lblTimingIntercoPercent" />
                        <radA:AjaxUpdatedControl ControlID="lblInitialBudgetValidated" />
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                        <radA:AjaxUpdatedControl ControlID="rbOrderProjects" />
                    </UpdatedControls>
                </radA:AjaxSetting>
                <radA:AjaxSetting AjaxControlID="cmbPG">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbOW" />
                        <radA:AjaxUpdatedControl ControlID="cmbPG" />
                        <radA:AjaxUpdatedControl ControlID="cmbPJ" />
                        <radA:AjaxUpdatedControl ControlID="lblFunction" />
                        <radA:AjaxUpdatedControl ControlID="lblActiveMembers" />
                        <radA:AjaxUpdatedControl ControlID="lblTimingIntercoPercent" />
                        <radA:AjaxUpdatedControl ControlID="lblInitialBudgetValidated" />                        
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                        <radA:AjaxUpdatedControl ControlID="rbOrderProjects" />
                    </UpdatedControls>
                </radA:AjaxSetting>
                <radA:AjaxSetting AjaxControlID="cmbPJ">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbOW" />
                        <radA:AjaxUpdatedControl ControlID="cmbPG" />
                        <radA:AjaxUpdatedControl ControlID="cmbPJ" />
                        <radA:AjaxUpdatedControl ControlID="lblFunction" />
                        <radA:AjaxUpdatedControl ControlID="lblActiveMembers" />
                        <radA:AjaxUpdatedControl ControlID="lblTimingIntercoPercent" />
                        <radA:AjaxUpdatedControl ControlID="lblInitialBudgetValidated" />                        
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                        <radA:AjaxUpdatedControl ControlID="rbOrderProjects" />
                    </UpdatedControls>
                </radA:AjaxSetting>
                <radA:AjaxSetting AjaxControlID="cmbShowOnly">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbOW" />
                        <radA:AjaxUpdatedControl ControlID="cmbPG" />
                        <radA:AjaxUpdatedControl ControlID="cmbPJ" />
                        <radA:AjaxUpdatedControl ControlID="lblFunction" />
                        <radA:AjaxUpdatedControl ControlID="lblActiveMembers" />
                        <radA:AjaxUpdatedControl ControlID="lblTimingIntercoPercent" />
                        <radA:AjaxUpdatedControl ControlID="lblInitialBudgetValidated" />                          
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                        <radA:AjaxUpdatedControl ControlID="rbOrderProjects" />
                    </UpdatedControls>
                </radA:AjaxSetting>
                <radA:AjaxSetting AjaxControlID="rbOrderProjects">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="cmbOW" />
                        <radA:AjaxUpdatedControl ControlID="cmbPG" />
                        <radA:AjaxUpdatedControl ControlID="cmbPJ" />
                        <radA:AjaxUpdatedControl ControlID="lblFunction" />
                        <radA:AjaxUpdatedControl ControlID="lblActiveMembers" />
                        <radA:AjaxUpdatedControl ControlID="lblTimingIntercoPercent" />
                        <radA:AjaxUpdatedControl ControlID="lblInitialBudgetValidated" />                          
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                        <radA:AjaxUpdatedControl ControlID="rbOrderProjects" />
                    </UpdatedControls>
                </radA:AjaxSetting>                
                <radA:AjaxSetting AjaxControlID="btnSelect">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                    </UpdatedControls>
                </radA:AjaxSetting>
            </AjaxSettings>
        </radA:RadAjaxManager>
    </form>
</body>
<script type='text/javascript' src="../../Scripts/GetInternetExplorerVersion.js"></script>
<script type="text/javascript">
    if (GetInternetExplorerVersion() < 9 && GetInternetExplorerVersion() > 0) {
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

        function GetRadWindow()
        {
            var oWindow = null;
            if (window.radWindow)
                oWindow = window.radWindow;
            else if (window.frameElement.radWindow)
                oWindow = window.frameElement.radWindow;
            return oWindow;
        }

        function sendAndClose(par, returnLink)
        {
            //get a reference to the RadWindow
            var oArg = new Object();
            oArg.ProjectName = par;
            oArg.ReturnLink = returnLink;
            var oWnd = GetRadWindow();
            //create the argument
            //send the argument in RadWindow's close() method
             oWnd.close(oArg);
        }
</script> 

</html>
