<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Navigation.ascx.cs" Inherits="UserControls_Visuals_Navigation" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<cc1:IndImageButton ID="btnBack" runat="server" ImageUrl="~/Images/rightbuttons_back.png"
    ImageUrlOver="~/Images/rightbuttons_back_over.png" OnClientClick="NavigateBack();return false;"
    ToolTip="Back" /><cc1:IndImageButton ID="btnForward" runat="server" ImageUrl="~/Images/rightbuttons_forward.png"
        ImageUrlOver="~/Images/rightbuttons_forward_over.png" OnClientClick="NavigateForward();return false;"
        ToolTip="Forward" />&nbsp;
<cc1:IndImageButton runat="server" ID="btnRefresh" ImageUrl="~/Images/rightbuttons_reload.png"
    ImageUrlOver="~/Images/rightbuttons_reload_over.png" 
    ToolTip="Refresh" CausesValidation="False" OnClick="btnRefresh_Click" />
<cc1:IndImageButton ID="btnCsv" runat="server" ImageUrl="~/Images/rightbuttons_csv.png"
    ImageUrlOver="~/Images/rightbuttons_csv_over.png" OnClick="btnCsv_Click" ToolTip="Export to CSV"
    OnClientClick="ResponseEnd()" CausesValidation="false" />
