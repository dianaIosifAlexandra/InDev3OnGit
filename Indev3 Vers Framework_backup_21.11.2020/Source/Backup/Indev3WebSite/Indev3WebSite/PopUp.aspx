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
    text-align: center;" onload="SetOnBeforeUnload();SetPopUpHeight();">
    <form id="form1" runat="server" onkeypress="return PreventFormValidationOnKeyPress()">
        <div style="width: 90%;">
            <asp:Table ID="tblHeader" runat="server" Width="100%">
                <asp:TableRow ID="HeaderRow">
                    <asp:TableCell ID="HeaderCell" HorizontalAlign="left" VerticalAlign="bottom">
                        <cc1:IndCatLabel ID="HeaderLabel" runat="server"></cc1:IndCatLabel>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <hr style="width: 100%; height: 1px; background: silver;" />
            <asp:Table ID="tbl" runat="server" Width="100%">
                <asp:TableRow>
                    <asp:TableCell HorizontalAlign="left" VerticalAlign="Top">
                        <asp:PlaceHolder ID="plhEditControl" runat="server" EnableViewState="true"></asp:PlaceHolder>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow ID="FooterRow">
                    <asp:TableCell ID="FooterCell" HorizontalAlign="left" VerticalAlign="bottom">
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <asp:Table ID="tblFooter" runat="server" Width="100%">
                <asp:TableRow ID="ValidationRow">
                    <asp:TableCell ID="ValidationCell" HorizontalAlign="left">
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </div>
    </form>
</body>
</html>
