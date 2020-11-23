<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="FollowUpBudget.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_Budget_FollowUpBudget_FollowUpBudget"
    Title="FollowUp Budget" %>

<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">

    <script type='text/javascript' src='../../../Scripts/GridScripts.js'></script>

    <br />
    <table style="width: 90%; height: 110%;" class="tabbed" border="0">
        <tr>
            <td valign="top">
                <table cellpadding="5" cellspacing="0" border="0" class="tabbedNoImage" width="100%">
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblProject" runat="server">Project:</ind:IndCatLabel></td>
                        <td align="left" colspan="4">
                            <ind:IndCatLabel ID="lblProjectName" runat="server" Style="font-weight: bold"></ind:IndCatLabel></td>
                    </tr>
                    <tr>
                        <td align="left" style="width: 10px;">
                            <ind:IndCatLabel ID="lblType" runat="server">Type:</ind:IndCatLabel></td>
                        <td align="left">
                            <ind:IndCatComboBox ID="cmbType" runat="server" AutoPostBack="true" CheckDirty="false"
                                Width="100px" OnSelectedIndexChanged="cmbType_SelectedIndexChanged" AppendDataBoundItems="true">
                            </ind:IndCatComboBox>
                        </td>
                        <td align="left" style="width: 10px;">
                            <ind:IndCatLabel ID="lblVersions" runat="server">Version:</ind:IndCatLabel></td>
                        <td align="left">
                            <ind:IndCatComboBox ID="cmbVersions" runat="server" AutoPostBack="true" CheckDirty="false"
                                Width="100px" OnSelectedIndexChanged="cmbVersions_SelectedIndexChanged">
                            </ind:IndCatComboBox>
                        </td>
                        <td align="right" style="width: 70%">
                            <ind:IndImageButton ID="btnValidate" ToolTip="Validate" runat="server" OnClick="btnValidate_Click" /></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top" colspan="2">
                <radG:RadGrid ID="grdFollowUpBudget" HorizontalAlign="center" runat="server" AutoGenerateColumns="False"
                    GridLines="None" SkinsPath="~/Skins/Grid" Skin="FollowUpBudget" EnableOutsideScripts="True"
                    AllowPaging="false" OnItemCreated="grdFollowUpBudget_ItemCreated" OnPreRender="grdFollowUpBudget_PreRender">
                    <MasterTableView DataKeyNames="" ShowFooter="true" BorderWidth="0">
                        <Columns>
                            <radG:GridTemplateColumn UniqueName="SelectBudgetCol">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="chkDeleteCol" />
                                </ItemTemplate>
                                <FooterTemplate>
                                    <ind:IndImageButton ID="btnDelete" OnClick="btnDelete_Click" OnClientClick="if (CheckBoxesSelected()) {if(!confirm('Are you sure you want to delete the selected entries?'))return false;}else {alert('Select at least one entry');return false;}"
                                        runat="server" CommandName="DeleteSelected" ImageUrl="~/Images/buttons_delete.png"
                                        ImageUrlOver="~/Images/buttons_delete_over.png" ToolTip="Delete" />
                                </FooterTemplate>
                            </radG:GridTemplateColumn>
                            <radG:GridBoundColumn UniqueName="IdAssociate" DataField="IdAssociate" Display="false">
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn HeaderText="Associate" UniqueName="Associate" DataField="Associate"
                                FilterImageUrl="~/Skins/Grid/Budget/Filter.gif" SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif"
                                SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif">
                                <ItemStyle Width="150px" HorizontalAlign="left" />
                                <HeaderStyle Width="150px" HorizontalAlign="left" />
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn UniqueName="State" HeaderText="Status" DataField="State" FilterImageUrl="~/Skins/Grid/Budget/Filter.gif"
                                SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif"
                                ReadOnly="True">
                                <ItemStyle Width="100px" HorizontalAlign="left" />
                                <HeaderStyle Width="100px" HorizontalAlign="left" />
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn UniqueName="Last Update Date" HeaderText="Last Update" DataField="StateDate"
                                FilterImageUrl="~/Skins/Grid/Budget/Filter.gif" SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif"
                                SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif" ReadOnly="True" DataFormatString="{0:dd/MM/yyyy}">
                                <ItemStyle Width="70px" HorizontalAlign="left" />
                                <HeaderStyle Width="70px" HorizontalAlign="left" />
                            </radG:GridBoundColumn>
                            <radG:GridTemplateColumn UniqueName="NavigateCol">
                                <ItemTemplate>
                                    <asp:HyperLink runat="server" ID="btnNavigate" ImageUrl="~/Images/buton_row_magnify.png" ToolTip="View Budget" />
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:LinkButton runat="server" CommandName="NavigateAll" ID="btnNavigateAll" Text="All"></asp:LinkButton>
                                </FooterTemplate>
                                <FooterStyle VerticalAlign="top"></FooterStyle>
                            </radG:GridTemplateColumn>
                            <radG:GridTemplateColumn UniqueName="CopyCol">
                                <ItemTemplate>
                                    <asp:HyperLink runat="server" ID="btnCopyBudget" ImageUrl="~/Images/buton_row_copy_darkBg.png" ToolTip="Move Budget" />
                                </ItemTemplate>
                                <FooterStyle VerticalAlign="top"></FooterStyle>
                            </radG:GridTemplateColumn>
                        </Columns>
                    </MasterTableView>
                </radG:RadGrid>
            </td>
        </tr>
    </table>
</asp:Content>
