<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DataLogs.ascx.cs" Inherits="UserControls_AnnualBudget_DataLogs" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<table align="center">
    <tr>
        <td>
            <asp:Panel ID="pnlLogs" runat="server" Width="526px">
                <ind:IndCatGrid ID="grdLogs" runat="server" UserCanAdd="false" UserCanDelete="true"
                    UserCanEdit="true" Width="526px">
                    <PagerStyle Visible="false" />
                    <MasterTableView TableLayout="fixed">
                        <Columns>
                        </Columns>
                        <ExpandCollapseColumn Visible="False">
                            <HeaderStyle Width="19px" />
                        </ExpandCollapseColumn>
                    </MasterTableView>
                </ind:IndCatGrid>
            </asp:Panel>
        </td>
    </tr>
</table>