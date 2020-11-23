<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" CodeFile="Catalogs.aspx.cs" Inherits="Inergy.Indev3.UI.Catalogs" Title="INDev 3" EnableViewState="false" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" Runat="Server" EnableViewState="false">
    <radA:RadAjaxPanel HorizontalAlign="Center" ID="plhCatalogue" runat="server" EnableOutsideScripts="True" LoadingPanelID="" ScrollBars="None" EnableAJAX="False" EnableViewState="false">
    </radA:RadAjaxPanel>
</asp:Content>

