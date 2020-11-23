<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DataLogs.ascx.cs" Inherits="UserControls_DataUpload_Upload_DataLogs" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<asp:Panel ID="pnlLogs" runat="server" Width="708px">
    <ind:IndCatGrid ID="grdLogs" runat="server" UserCanAdd="False" UserCanDelete="true"
        UserCanEdit="true" >
        <PagerStyle Visible="false" />
        <MasterTableView TableLayout="Fixed">
            <Columns>
            </Columns>
            <ExpandCollapseColumn Visible="False">
                <HeaderStyle Width="19px" />
            </ExpandCollapseColumn>
        </MasterTableView>
    </ind:IndCatGrid>
</asp:Panel>

