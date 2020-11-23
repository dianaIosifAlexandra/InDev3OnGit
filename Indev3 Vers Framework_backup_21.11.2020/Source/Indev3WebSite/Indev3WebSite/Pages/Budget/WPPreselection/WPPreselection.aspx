<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="WPPreselection.aspx.cs" Inherits="Pages_Budget_WPPreselection_WPPreselection"
    Title="INDev3" EnableEventValidation="false" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%--<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radCb" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radCb" %>--%>
<%@ Register Assembly="RadMenu.Net2" Namespace="Telerik.WebControls" TagPrefix="radM" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">

    <script type='text/javascript' src='../../../Scripts/NavigationScripts.js'></script>

    <br />
    <asp:Panel ID="pnlBudgetLayout" runat="server">
        <table id="tableBudgetLayout" runat="server">
            <tr valign="top">
                <td>
                    <table>
                        <tr>
                            <td>
                                <ind:IndComboBox ID="cmbActive" runat="server" CheckDirty="false" AutoPostBack="True"
                                    Width="166px" OnSelectedIndexChanged="cmbActive_SelectedIndexChanged">
                                    <Items>
                                        <telerik:radcomboboxitem runat="server" selected="True" text="Active" value="A">
                                        </telerik:radcomboboxitem>
                                        <telerik:radcomboboxitem runat="server" text="Inactive" value="I">
                                        </telerik:radcomboboxitem>
                                        <telerik:radcomboboxitem runat="server" text="All" value="L">
                                        </telerik:radcomboboxitem>
                                    </Items>
                                </ind:IndComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 7px;">
                                <asp:ListBox ID="lstNotSelectedWPs" runat="server" Height="278px" Width="170px" SelectionMode="Multiple"
                                    CssClass="ListBox"></asp:ListBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 8px;">
                                <ind:IndImageButton ID="btnAddWP" runat="server" ToolTip="Add Work Package" ImageUrl="~/Images/button_tab_add_toright.png"
                                    ImageUrlOver="~/Images/button_tab_add_toright.png" OnClick="btnAddWP_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <table width="170px" class="tabbedNoImage backgroundColorIE">
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <ind:IndLabel ID="IndLabel1" runat="server" Text="Present selection as:"></ind:IndLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:RadioButton ID="radioAllExpanded" runat="server" Text="All expanded" Checked="true"
                                                GroupName="BudgetLayout" CssClass="RadioButton" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:RadioButton ID="radioAllCollapsed" runat="server" Text="All collapsed" GroupName="BudgetLayout"
                                                CssClass="RadioButton" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="padding-left: 10px; padding-top: 2px;">
                    <table>
                        <tr>
                            <td>
                                <radG:RadGrid ID="grdPreselection" runat="server" GridLines="None" SkinsPath="~/Skins/Grid"
                                    Skin="TimingAndInterco" OnNeedDataSource="grdPreselection_NeedDataSource" HorizontalAlign="Center"
                                    OnItemCreated="grdPreselection_ItemCreated">
                                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="IdPhase" HierarchyDefaultExpanded="True"
                                        ShowFooter="True" Name="PreselectionMasterTableView" HierarchyLoadMode="Client"
                                        HorizontalAlign="center">
                                        <Columns>
                                            <radG:GridTemplateColumn UniqueName="EmptyColumn">
                                                <ItemStyle Width="0px" />
                                                <HeaderStyle Width="0px" />
                                            </radG:GridTemplateColumn>
                                            <radG:GridTemplateColumn UniqueName="SelectPhaseCol" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                <ItemTemplate>
                                                    <asp:CheckBox runat="server" ID="chkPhaseCol" />
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    <ind:IndImageButton ID="btnDeleteWP" runat="server" ToolTip="Remove selected Work Packages"
                                                        OnClientClick="if (!CheckBoxesSelectedInterco('ctl00_ph_grdPreselection')) return false;else return true;"
                                                        OnClick="btnDeleteWP_Click" ImageUrl="~/Images/buttons_delete.png" ImageUrlOver="~/Images/buttons_delete_over.png" />
                                                </FooterTemplate>
                                                <ItemStyle Width="40px" />
                                                <HeaderStyle Width="40px" />
                                            </radG:GridTemplateColumn>
                                            <radG:GridBoundColumn DataField="PhaseName" HeaderText="Phase/Work Package" Resizable="False"
                                                UniqueName="PhaseName" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                <ItemStyle HorizontalAlign="Left" Width="483px" />
                                                <HeaderStyle HorizontalAlign="Left" Width="483px" />
                                            </radG:GridBoundColumn>
                                            <radG:GridTemplateColumn UniqueName="StartYearMonth" HeaderText="Start Date" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                <HeaderStyle HorizontalAlign="Left" Width="80px" />
                                            </radG:GridTemplateColumn>
                                            <radG:GridTemplateColumn UniqueName="EndYearMonth" HeaderText="End Date" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                <HeaderStyle HorizontalAlign="Left" Width="80px" />
                                            </radG:GridTemplateColumn>
                                        </Columns>
                                        <ExpandCollapseColumn CollapseImageUrl="~/Skins/Grid/TimingAndInterco/SingleMinus.gif"
                                            ExpandImageUrl="~/Skins/Grid/TimingAndInterco/SinglePlus.gif" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                            <HeaderStyle Width="19px" />
                                        </ExpandCollapseColumn>
                                        <DetailTables>
                                            <radG:GridTableView runat="server" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP"
                                                EditMode="InPlace" HorizontalAlign="right" Width="100%">
                                                <ParentTableRelation>
                                                    <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                </ParentTableRelation>
                                                <Columns>
                                                    <radG:GridTemplateColumn UniqueName="SelectWPCol" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                        SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        <ItemTemplate>
                                                            <asp:CheckBox runat="server" ID="chkWPCol" />
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Left" Width="36px" />
                                                    </radG:GridTemplateColumn>
                                                    <radG:GridTemplateColumn UniqueName="selectWPColumn">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" ID="selectWP" Text='<%# Bind( "WPName" ) %>' OnClick="SelectWP_Click" />
                                                        </ItemTemplate>
                                                        <ItemStyle Width="480px" />
                                                    </radG:GridTemplateColumn>
                                                    <radG:GridTemplateColumn DataField="StartYearMonth" UniqueName="StartYearMonth" HeaderText="StartYearMonth"
                                                        FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                        SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        <ItemTemplate>
                                                            <ind:IndYearMonthLabel runat="server" YearMonthText='<%# Bind( "StartYearMonth" ) %>'
                                                                ID="txtStartYearMonth" />
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                    </radG:GridTemplateColumn>
                                                    <radG:GridTemplateColumn DataField="EndYearMonth" UniqueName="EndYearMonth" HeaderText="EndYearMonth"
                                                        FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                        SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        <ItemTemplate>
                                                            <ind:IndYearMonthLabel runat="server" YearMonthText='<%# Bind( "EndYearMonth" ) %>'
                                                                ID="txtEndYearMonth" />
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Left" Width="76px" />
                                                    </radG:GridTemplateColumn>
                                                    <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                        SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                        SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="HasPeriodAndInterco" UniqueName="HasPeriodAndInterco" Visible="False">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="HasBudget" UniqueName="HasBudget" Visible="False">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="HasActualOrRevisedData" UniqueName="HasActualOrRevisedData"
                                                        Visible="False">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IsActive" UniqueName="IsActive" Visible="False">
                                                    </radG:GridBoundColumn>
                                                </Columns>
                                                <ExpandCollapseColumn Visible="False" CollapseImageUrl="~/Skins/Grid/TimingAndInterco/SingleMinus.gif"
                                                    ExpandImageUrl="~/Skins/Grid/TimingAndInterco/SinglePlus.gif" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <HeaderStyle Width="19px" />
                                                </ExpandCollapseColumn>
                                                <RowIndicatorColumn Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <HeaderStyle Width="20px" />
                                                </RowIndicatorColumn>
                                                <CommandItemSettings AddNewRecordImageUrl="~/Skins/Grid/TimingAndInterco/AddRecord.gif"
                                                    RefreshImageUrl="~/Skins/Grid/TimingAndInterco/Refresh.gif" />
                                                <EditFormSettings>
                                                    <EditColumn CancelImageUrl="~/Skins/Grid/TimingAndInterco/Cancel.gif" EditImageUrl="~/Skins/Grid/TimingAndInterco/Edit.gif"
                                                        FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" InsertImageUrl="~/Skins/Grid/TimingAndInterco/Insert.gif"
                                                        SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif"
                                                        UpdateImageUrl="~/Skins/Grid/TimingAndInterco/Update.gif">
                                                    </EditColumn>
                                                </EditFormSettings>
                                            </radG:GridTableView>
                                        </DetailTables>
                                        <RowIndicatorColumn Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                            <HeaderStyle Width="20px" />
                                        </RowIndicatorColumn>
                                        <CommandItemSettings AddNewRecordImageUrl="~/Skins/Grid/TimingAndInterco/AddRecord.gif"
                                            RefreshImageUrl="~/Skins/Grid/TimingAndInterco/Refresh.gif" />
                                        <EditFormSettings>
                                            <EditColumn CancelImageUrl="~/Skins/Grid/TimingAndInterco/Cancel.gif" EditImageUrl="~/Skins/Grid/TimingAndInterco/Edit.gif"
                                                FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" InsertImageUrl="~/Skins/Grid/TimingAndInterco/Insert.gif"
                                                SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif"
                                                UpdateImageUrl="~/Skins/Grid/TimingAndInterco/Update.gif">
                                            </EditColumn>
                                        </EditFormSettings>
                                    </MasterTableView>
                                    <ClientSettings>
                                        <ClientEvents OnGridCreated="GridCreated" />
                                    </ClientSettings>
                                    <FilterMenu NotSelectedImageUrl="~/Skins/Grid/TimingAndInterco/NotSelectedMenu.gif"
                                        SelectedImageUrl="~/Skins/Grid/TimingAndInterco/SelectedMenu.gif"></FilterMenu>
                                </radG:RadGrid>
                            </td>
                        </tr>
                        <tr>
                            <td valign="bottom" align="right" style="padding-bottom:50px">
                                <ind:IndImageButton runat="server" ID="btnNext" ImageUrl="../../../Images/button_tab_next.png"
                                    ImageUrlOver="../../../Images/button_tab_next.png" ToolTip="Next" OnClick="btnNext_Click" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:Panel ID="pnlUnvalidateBudget" runat="Server" Visible="false" CssClass="UnvalidatedBudget">
            <asp:LinkButton ID="lnkUnvalidateBudget" runat="server" CssClass="IndLabel" Text="Restore Budget to Initial State" OnClick="lnkUnvalidateBudget_Click" OnClientClick="if (!confirm('Are you sure you want to unvalidate this budget?')) {return false;} else {return true;}"></asp:LinkButton>
            <br /><br />
            <label class="IndLabel bold">Caution</label>
            <br /><br />
            <label class="IndLabel">The results of this action cannot be reversed!<br />Clicking on the above link you will delete all project reforcast and revised data.</label>
        </asp:Panel>
        <asp:Button ID="btnDoPostback" runat="server" Text="Button" Visible="false" />
    </asp:Panel>
<script type="text/javascript">
    if (!document.querySelectorAll) {
        document.querySelectorAll = function (selectors) {
            var style = document.createElement('style'), elements = [], element;
            document.documentElement.firstChild.appendChild(style);
            document._qsa = [];

            style.styleSheet.cssText = selectors + '{x-qsa:expression(document._qsa && document._qsa.push(this))}';
            window.scrollBy(0, 0);
            style.parentNode.removeChild(style);

            while (document._qsa.length) {
                element = document._qsa.shift();
                element.style.removeAttribute('x-qsa');
                elements.push(element);
            }
            document._qsa = null;
            return elements;
        };
    }

    if (!document.querySelector) {
        document.querySelector = function (selectors) {
            var elements = document.querySelectorAll(selectors);
            return (elements.length) ? elements[0] : null;
        };
    }

    (function () {
        var elements = document.querySelectorAll(".backgroundColorIE");
        var ieVersion = GetInternetExplorerVersion();
        if (elements != null) {
            for (var i = 0; i < elements.length; i++) {
                if (ieVersion < 9 && ieVersion > 0)
                    elements[i].style.backgroundColor = "#757575";
                else {
                    elements[i].style.backgroundColor = "#6E6E6E";
                }
            }
        }
    })()
</script>
</asp:Content>
