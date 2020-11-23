<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" CodeFile="UserSettings.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_UserSettings_UserSettings" Title="User Settings" %>
<%@ Register Src="~/UserControls/UserSettings/UserSettings.ascx" TagName="Settings" TagPrefix="mb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" Runat="Server">
<br />
 <asp:Panel ID="pnlSettings" runat="server">
    <br />
    <mb:Settings id="Settings1" runat="server" />
    </asp:Panel>
</asp:Content>

