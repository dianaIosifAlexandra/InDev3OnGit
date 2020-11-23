<%@ page language="C#" masterpagefile="~/Template.master" autoeventwireup="true" inherits="Inergy.Indev3.UI.Pages_UserSettings_UserSettings, App_Web_oumsopuw" title="User Settings" %>
<%@ Register Src="~/UserControls/UserSettings/UserSettings.ascx" TagName="Settings" TagPrefix="mb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" Runat="Server">
<br />
 <asp:Panel ID="pnlSettings" runat="server">
    <br />
    <mb:Settings id="Settings1" runat="server" />
    </asp:Panel>
</asp:Content>

