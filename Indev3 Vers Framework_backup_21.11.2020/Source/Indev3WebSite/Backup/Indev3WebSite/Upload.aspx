<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" CodeFile="Upload.aspx.cs" Inherits="Inergy.Indev3.UI.Upload" Title="INDev 3" %>
<%@ Register Src="./UserControls/DataUpload/Upload/Upload.ascx" TagName="Upload" TagPrefix="mb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" Runat="Server">
    <br />
    <asp:Panel ID="pnlUpload" runat="server">
    <br />
    <mb:Upload id="Upload1" runat="server" />
    </asp:Panel>
</asp:Content>

