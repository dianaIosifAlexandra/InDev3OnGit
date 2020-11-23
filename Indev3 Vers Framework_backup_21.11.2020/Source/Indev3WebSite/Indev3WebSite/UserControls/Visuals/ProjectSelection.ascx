<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectSelection.ascx.cs" Inherits="UserControls_Visuals_ProjectSelection" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<asp:Label ID="lblProjectName" ClientIDMode="Static" runat="server" Text="No project selected" ForeColor="#C9C9C9" Font-Bold="True" Font-Names="Tahoma" Font-Size="7pt"></asp:Label>
<asp:LinkButton ID="lnkChange" runat="server" ForeColor="#C9C9C9" Font-Names="Tahoma" Font-Size="7pt" OnClick="lnkChange_Click">change</asp:LinkButton>
