<%@ control language="C#" autoeventwireup="true" inherits="UserControls_DataUpload_Upload_DataLogs, App_Web_o2x3hbgh" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<table align="center">
    <tr>
        <td>
            <asp:Panel ID="pnlLogs" runat="server" Width="642px">
                <ind:IndCatGrid ID="grdLogs" runat="server" UserCanAdd="False" UserCanDelete="true"
                    UserCanEdit="true" >
                    <PagerStyle Visible="false" />
                    <MasterTableView TableLayout="auto">
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