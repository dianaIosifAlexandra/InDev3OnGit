<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="AnnualDataStatus.aspx.cs" Inherits="Pages_AnnualBudget_AnnualDataStatus" Title="Data Status" %>

<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <asp:Panel ID="pnlDataStatus" runat="server" CssClass="Tabbed" Width="90%">
    <br />
        <table width="100%" class="tabbed">
            <tr>
                <td style="width:100%">
                    <radG:RadGrid ID="grdDataStatus" runat="server" SkinsPath="~/Skins/Grid" Skin="TimingAndInterco" HorizontalAlign="Center" OnNeedDataSource="grdDataStatus_NeedDataSource">
                        <MasterTableView AutoGenerateColumns="false">
                            <Columns>
                                <radG:GridBoundColumn UniqueName="Country" DataField="Country">
                                    <ItemStyle Width="100px" />
                                    <HeaderStyle Width="100px" />
                                </radG:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </radG:RadGrid>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>

