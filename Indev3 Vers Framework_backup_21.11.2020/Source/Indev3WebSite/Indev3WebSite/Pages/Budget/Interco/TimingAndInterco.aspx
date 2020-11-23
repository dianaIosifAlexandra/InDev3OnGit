<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="TimingAndInterco.aspx.cs" Inherits="UserControls_Budget_Interco_TimingAndInterco"
    Title="INDev3" %>

<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%--<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>--%>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="radTS" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">

<%@ Register Src="~/UserControls/Budget/Interco/PeriodMassAttributionDiv.ascx"
    TagName="PeriodMassAttr" TagPrefix="ma" %>
    <script type='text/javascript' src='../../../Scripts/GridScripts.js'></script>

    <script type='text/javascript' src='../../../Scripts/DivScripts.js'></script>

    <script type='text/javascript' src='../../../Scripts/NumberRepresentation.js'></script>

    <script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>

    <script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

    <script language="JavaScript" type='text/javascript'>
    var needToConfirm = true;

    window.onbeforeunload = confirmExit;

    function confirmExit()
    {
        if (needToConfirm)
        {
            var inputs = document.getElementsByTagName('input');
            for(var i=0; i<inputs.length; i++)
            {
                if (inputs[i].getAttribute('type') == 'text')
                {
                    var txtDetail = inputs[i];
                    if ((txtDetail.name.indexOf("grd") > 0) && (txtDetail.disabled == false))
                    {
                        needToConfirm = false;
                        setTimeout("enableCheck()", "100");
                        return "There is at least one work package in edit mode.";
                    }
                }
            }
            var txtIsDirty = document.getElementById("ctl00_ph_hdnIsDirty");
            if (txtIsDirty.value == "1")
            {
                needToConfirm = false;
                setTimeout("enableCheck()", "100");
                return "There are unsaved changes on this page.";
            }
        }
    }
      
    function enableCheck()
    {
        needToConfirm = true;
    }
         
    function ConfirmTabChanged(sender, eventArgs)
    {
        needToConfirm = false;
        var inputs = document.getElementsByTagName('input');
        for(var i=0; i<inputs.length; i++)
        {
            if (inputs[i].getAttribute('type') == 'text')
            {
                var txtDetail = inputs[i];
                if ((txtDetail.name.indexOf("grd") > 0) && (txtDetail.disabled == false))
                {
                    var leavePage = confirm("Are you sure you want to navigate away from this page? \r\n\r\nThere is at least one work package in edit mode.\r\n\r\nPress OK to continue, or cancel to stay on the current page.");
                    if (!leavePage)
                        return false;
                    else
                    {
                        needToConfirm = false;
                        return true;
                    }
                }
            }
        }
        return true;
    }
      
          
    function ClearDirty()
    {
        var txtIsDirty = document.getElementById("ctl00_ph_hdnIsDirty");
        txtIsDirty.value = "0";
    }
      
    function CheckForEditedWPs() 
    {
        var inputs = document.getElementsByTagName('input');
        for(var i=0; i<inputs.length; i++)
        {
            if (inputs[i].getAttribute('type') == 'text')
            {
                var txtDetail = inputs[i];
                if ((txtDetail.name.indexOf("grd") > 0) && (txtDetail.disabled == false))
                {
                    return true;
                }
            }
        }
        var txtIsDirty = document.getElementById("ctl00_ph_hdnIsDirty");
        if (txtIsDirty.value == "1")
        {
            return true;
        }
        return false;
    }
    
    //FIX: issue 0026047. After the column swap, disable column swapping until postback so that the user cannot perform another swap until this
    //swap is complete
    function ColumnSwapped(columnIndex1, columnIndex2)
    { 
        var grdInterco = <%= grdInterco.ClientID%>;
        grdInterco.ClientSettings.AllowColumnsReorder = false;
    }
     
    </script>

    <br />
    <div style="width: 96%; margin-bottom: -43px;">
        <radTS:RadTabStrip ID="tabStripInterco" runat="server" MultiPageID="MultiPageContainer"
            OnTabClick="tabStripInterco_TabClick" AutoPostBack="True" SelectedIndex="0" Skin="Default"
            SkinsPath="~/Skins/Tabstrip" OnClientTabSelecting="ConfirmTabChanged">
            <Tabs>
                <radTS:Tab runat="server" Text="Define WP Period" PageViewID="tabPeriod">
                </radTS:Tab>
                <radTS:Tab runat="server" ID="tInterco" Text="Define Interco Affectation">
                </radTS:Tab>
            </Tabs>
        </radTS:RadTabStrip>
    </div>
    <table width="96%" class="tabbed backgroundColorIE">
        <tr>
            <td align="center" style="width: 200px" valign="top">
                <table style="width: 190px">
                    <tr>
                        <td>
                            <ind:IndLabel ID="lblUnaffected" runat="server" CssClass="IndLabel">Unaffected Work Packages</ind:IndLabel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="lstUnaffectedWP" runat="server" Height="326px" Width="170px" SelectionMode="Multiple"
                                CssClass="ListBox"></asp:ListBox></td>
                    </tr>
                    <tr>
                        <td align="center" style="height: 30px">
                            <ind:IndImageButton ID="btnAddWP" runat="server" ToolTip="Add Work Package" ImageUrl="~/Images/button_tab_add_toright.png"
                                ImageUrlOver="~/Images/button_tab_add_toright.png" OnClick="btnAddWP_Click" OnClientClick="RemoveCheckBoxes();needToConfirm=false;" />
                        </td>
                    </tr>
                </table>
            </td>
            <td align="left" valign="top">
                <radTS:RadMultiPage ID="MultiPageContainer" runat="server"  Width="100%"
                    SelectedIndex="0">
                    <radTS:PageView ID="tabPeriod" runat="server" Width="100%">
                        <br />
                        <table>
                            <tr>
                                <td>
                                    <radG:RadGrid ID="grdPeriod" runat="server" GridLines="None" OnNeedDataSource="grdPeriod_NeedDataSource"
                                        AllowMultiRowEdit="True" OnUpdateCommand="grdPeriod_UpdateCommand" OnItemCreated="grdPeriod_ItemCreated"
                                        OnPreRender="grdPeriod_PreRender" SkinsPath="~/Skins/Grid" Skin="TimingAndInterco" OnEditCommand="grdPeriod_EditCommand" OnCancelCommand="grdPeriod_CancelCommand"  OnItemDataBound="grdPeriod_ItemDataBound">
                                        <MasterTableView HierarchyLoadMode="Client" AutoGenerateColumns="False" DataKeyNames="IdPhase"
                                            EditMode="InPlace" HierarchyDefaultExpanded="True" ShowFooter="True" Name="PeriodMasterTableView"
                                            HorizontalAlign="left">
                                            <Columns>
                                                <radG:GridTemplateColumn UniqueName="SelectPhaseCol" Resizable="False" Reorderable="False"
                                                    FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                    SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <ItemTemplate>
                                                        <asp:CheckBox runat="server" ID="chkPhaseCol" />
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        <ind:IndImageButton ID="btnDeleteWPTiming" CssClass="IndImageButtonFooter" ToolTip="Remove selected Work Packages"
                                                            runat="server" OnClientClick="needToConfirm = false;if (!CheckBoxesSelectedInterco('ctl00_ph_grdPeriod')) return false;else { if (confirm('Are you sure you want to remove the selected Work Packages?')){RemoveCheckBoxes(); return true;} else return false;}"
                                                            OnClick="btnDeleteWP_Click" ImageUrl="~/Images/buttons_delete.png" ImageUrlOver="~/Images/buttons_delete_over.png" />
                                                    </FooterTemplate>
                                                    <ItemStyle Width="29px" />
                                                    <HeaderStyle Width="29px" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn DataField="PhaseCode" HeaderText="Phase/Work Package" Resizable="False"
                                                    Reorderable="False" UniqueName="PhaseCode" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <ItemStyle Width="203px" />
                                                    <HeaderStyle Width="203px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="WPCode" HeaderText="Work Package" Resizable="False"
                                                    Visible="false" Reorderable="False" UniqueName="WPCode" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="StartYearMonth" HeaderText="Start Date" Resizable="False"
                                                    UniqueName="StartYearMonth" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <ItemStyle Width="115px" CssClass="CenteredCell" />
                                                    <HeaderStyle Width="115px" CssClass="CenteredHeaderCell" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="EndYearMonth" HeaderText="End Date" Resizable="False"
                                                    UniqueName="EndYearMonth" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <ItemStyle Width="115px" />
                                                    <HeaderStyle Width="115px" CssClass="CenteredHeaderCell" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="IsChanged" UniqueName="IsChanged" Visible="False"
                                                    FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                    SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                </radG:GridBoundColumn>
                                                <radG:GridTemplateColumn UniqueName="LastUpdate" HeaderText="Last Update" Reorderable="false"
                                                    Resizable="false">
                                                    <ItemStyle Width="84px" />
                                                    <HeaderStyle Width="84px" CssClass="CenteredHeaderCell" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridTemplateColumn UniqueName="LastUserUpdate" HeaderText="Last User" Reorderable="false"
                                                    Resizable="false">
                                                    <ItemStyle Width="95px" CssClass="CenteredCell" />
                                                    <HeaderStyle Width="95px" CssClass="CenteredHeaderCell" />
                                                </radG:GridTemplateColumn>
                                            </Columns>
                                            <ExpandCollapseColumn CollapseImageUrl="~/Skins/Grid/TimingAndInterco/SingleMinus.gif"
                                                ExpandImageUrl="~/Skins/Grid/TimingAndInterco/SinglePlus.gif" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                <HeaderStyle Width="19px" />
                                            </ExpandCollapseColumn>
                                            <DetailTables>
                                                <radG:GridTableView runat="server" AllowPaging="false" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP"
                                                    ShowHeader="False" EditMode="InPlace" HorizontalAlign="right" TableLayout="Auto" Name="PeriodDetailTableView"> 
                                                    <ParentTableRelation>
                                                        <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                    </ParentTableRelation>
                                                    <Columns>
                                                        <radG:GridTemplateColumn UniqueName="SelectWPCol" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <ItemTemplate>
                                                                <asp:CheckBox runat="server" ID="chkWPCol"/>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="25px" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridEditCommandColumn UniqueName="EditPeriod" ButtonType="ImageButton" CancelImageUrl="~/Images/buttons_editrow.png"
                                                            EditImageUrl="~/Images/buttons_editrow.png" UpdateImageUrl="~/Images/buttons_editrow.png"
                                                            FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" InsertImageUrl="~/Skins/Grid/TimingAndInterco/Insert.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <ItemStyle Width="36px" />
                                                        </radG:GridEditCommandColumn>
                                                        <radG:GridBoundColumn DataField="WPCode" Resizable="False" UniqueName="WPCode" ReadOnly="True"
                                                            HeaderText="Work Package" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <ItemStyle Width="160px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn DataField="StartYearMonth" UniqueName="StartYearMonth" HeaderText="StartYearMonth"
                                                            FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                            SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <EditItemTemplate>
                                                                <ind:IndYearMonth runat="server" Text='<%# Bind( "StartYearMonth" ) %>' ID="indYearMonth1" />
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <ind:IndYearMonthLabel runat="server" YearMonthText='<%# Bind( "StartYearMonth" ) %>'
                                                                    ID="txtStartYearMonth" />
                                                            </ItemTemplate>
                                                            <ItemStyle Width="115px" CssClass="CenteredCell" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridTemplateColumn DataField="EndYearMonth" UniqueName="EndYearMonth" HeaderText="EndYearMonth"
                                                            FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                            SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <EditItemTemplate>
                                                                <ind:IndYearMonth runat="server" Text='<%# Bind( "EndYearMonth" ) %>' ID="indYearMonth2" />
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <ind:IndYearMonthLabel runat="server" YearMonthText='<%# Bind( "EndYearMonth" ) %>'
                                                                    ID="txtEndYearMonth" />
                                                            </ItemTemplate>
                                                            <ItemStyle Width="115px" CssClass="CenteredCell" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn DataField="LastUpdate" DataType="System.DateTime" Reorderable="false"
                                                            ReadOnly="true" Resizable="false" UniqueName="LastUpdate" DataFormatString="{0:dd/MM/yyyy}">
                                                            <ItemStyle Width="84px" CssClass="CenteredCell" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="LastUserUpdate" Resizable="false" ReadOnly="true"
                                                            Reorderable="true" UniqueName="LastUserUpdate">
                                                            <ItemStyle Width="91px" CssClass="CenteredCell" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="HasBudget" UniqueName="HasBudget" Visible="False"
                                                            FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                            SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IsChanged" UniqueName="IsChanged" Visible="False"
                                                            FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                            SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
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
                                            <ClientEvents OnRowClick="GridCreated" />
                                        </ClientSettings>
                                        <FilterMenu NotSelectedImageUrl="~/Skins/Grid/TimingAndInterco/NotSelectedMenu.gif"
                                            SelectedImageUrl="~/Skins/Grid/TimingAndInterco/SelectedMenu.gif"></FilterMenu>
                                    </radG:RadGrid><br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="width: 100%; margin-top: 10px">
                                        <tr>
                                            <td align="right" style="width: 45%">
                                            </td>
                                            <td align="left" style="width: 55%">
                                                <ind:IndImageButton ID="btnNext" runat="server" ToolTip="Next" ImageUrl="~/Images/button_tab_next.png"
                                                    ImageUrlOver="~/Images/button_tab_next.png" OnClick="btnNext_Click" OnClientClick="return ConfirmTabChanged(null,null)" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        &nbsp;<br />
                        &nbsp;
                    </radTS:PageView>
                    <radTS:PageView ID="tabInterco" runat="server" CssClass="Panel" Width="100%">
                        <table>
                            <tr>
                                <td>
                                    &nbsp;<table style="width: 371px">
                                        <tr>
                                            <td style="width: 121px">
                                                <ind:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel">Available countries</ind:IndLabel></td>
                                            <td style="width: 172px">
                                                <ind:IndComboBox ID="cmbCountries" runat="server">
                                                </ind:IndComboBox>
                                            </td>
                                            <td align="left">
                                                <ind:IndImageButton ID="btnAddCountry" runat="server" ToolTip="Add Country" ImageUrl="~/Images/button_tab_add_down.png"
                                                    ImageUrlOver="~/Images/button_tab_add_down.png" OnClick="btnAddCountry_Click" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <radG:RadGrid ID="grdInterco" runat="server" OnNeedDataSource="grdInterco_NeedDataSource"
                                        AllowMultiRowEdit="True" OnUpdateCommand="grdInterco_UpdateCommand" OnItemCreated="grdInterco_ItemCreated"
                                        OnPreRender="grdInterco_PreRender" Skin="TimingAndInterco" SkinsPath="~/Skins/Grid"
                                        GridLines="None" OnCancelCommand="grdInterco_CancelCommand" OnEditCommand="grdInterco_EditCommand">
                                        <MasterTableView HierarchyLoadMode="Client" AutoGenerateColumns="False" DataKeyNames="IdPhase"
                                            EditMode="InPlace" HierarchyDefaultExpanded="True" ShowFooter="True" Name="IntercoMasterTableView"
                                            HorizontalAlign="Left">
                                            <Columns>
                                                <radG:GridTemplateColumn UniqueName="SelectPhaseCol" Resizable="False" Reorderable="False"
                                                    FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                    SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <ItemTemplate>
                                                        <asp:CheckBox runat="server" ID="chkPhaseCol" />
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        <ind:IndImageButton ID="btnDeleteWPInterco" runat="server" ToolTip="Remove selected Work Packages"
                                                            OnClientClick="needToConfirm = false; if (!CheckBoxesSelectedInterco('ctl00_ph_grdInterco')) return false;else { if (confirm('Are you sure you want to remove the selected Work Packages?')) {RemoveCheckBoxes();return true}; else return false; }"
                                                            OnClick="btnDeleteWPInterco_Click" ImageUrl="~/Images/buttons_delete.png" ImageUrlOver="~/Images/buttons_delete_over.png" />
                                                    </FooterTemplate>
                                                    <ItemStyle Width="29px" />
                                                    <HeaderStyle Width="29px" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn DataField="PhaseCode" HeaderText="Phase / WorkPackage" Resizable="False"
                                                    Reorderable="False" UniqueName="PhaseCode" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <ItemStyle Width="252px" />
                                                    <HeaderStyle Width="252px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="WPCode" HeaderText="Work Package" Resizable="False"
                                                    Visible="False" Reorderable="False" UniqueName="WPCode" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="Total" UniqueName="Total" HeaderText="Total" Reorderable="False"
                                                    Resizable="False" ReadOnly="True" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                    SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                    <ItemStyle Width="52px" />
                                                    <HeaderStyle Width="52px" />
                                                </radG:GridBoundColumn>
                                            </Columns>
                                            <ExpandCollapseColumn CollapseImageUrl="~/Skins/Grid/TimingAndInterco/SingleMinus.gif"
                                                ExpandImageUrl="~/Skins/Grid/TimingAndInterco/SinglePlus.gif" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif" Resizable="False">
                                                <HeaderStyle Width="20px" />
                                            </ExpandCollapseColumn>
                                            <DetailTables>
                                                <radG:GridTableView runat="server" AllowPaging="false" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP"
                                                    ShowHeader="False" EditMode="InPlace" HorizontalAlign="Right"
                                                    TableLayout="Auto" Name="IntercoDetailTableView">
                                                    <ParentTableRelation>
                                                        <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                    </ParentTableRelation>
                                                    <Columns>
                                                        <radG:GridTemplateColumn UniqueName="SelectWPCol" Reorderable="False" Resizable="False"
                                                            FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                            SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <ItemStyle Width="25px" />
                                                            <ItemTemplate>
                                                                <asp:CheckBox runat="server" ID="chkWPCol" />
                                                            </ItemTemplate>
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridEditCommandColumn UniqueName="EditInterco" ButtonType="ImageButton" CancelImageUrl="~/Images/buttons_editrow.png"
                                                            EditImageUrl="~/Images/buttons_editrow.png" UpdateImageUrl="~/Images/buttons_editrow.png"
                                                            Reorderable="False" Resizable="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            InsertImageUrl="~/Skins/Grid/TimingAndInterco/Insert.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                            SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <ItemStyle Width="36px" />
                                                        </radG:GridEditCommandColumn>
                                                        <radG:GridBoundColumn DataField="WPCode" Resizable="False" UniqueName="WPCode" ReadOnly="True"
                                                            Reorderable="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <ItemStyle Width="209px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="Total" UniqueName="Total" Reorderable="False" Resizable="False"
                                                            ReadOnly="True" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif" SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif"
                                                            SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                            <ItemStyle Width="52px" />
                                                            <HeaderStyle Width="52px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="HasBudget" UniqueName="HasBudget" Visible="False" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                            SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif">
                                                        </radG:GridBoundColumn>
                                                    </Columns>
                                                    <ExpandCollapseColumn Visible="False" CollapseImageUrl="~/Skins/Grid/TimingAndInterco/SingleMinus.gif"
                                                        ExpandImageUrl="~/Skins/Grid/TimingAndInterco/SinglePlus.gif" FilterImageUrl="~/Skins/Grid/TimingAndInterco/Filter.gif"
                                                        SortAscImageUrl="~/Skins/Grid/TimingAndInterco/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/TimingAndInterco/SortDesc.gif" Resizable="False">
                                                        <HeaderStyle Width="20px" />
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
                                        <ClientSettings AllowColumnsReorder="True">
                                            <ClientEvents OnRowClick="GridCreated" OnColumnSwapped="ColumnSwapped" />
                                        </ClientSettings>
                                        <FilterMenu NotSelectedImageUrl="~/Skins/Grid/TimingAndInterco/NotSelectedMenu.gif"
                                            SelectedImageUrl="~/Skins/Grid/TimingAndInterco/SelectedMenu.gif"></FilterMenu>
                                    </radG:RadGrid>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="width: 100%; margin-top: 10px">
                                        <tr>
                                            <td align="right" style="width: 50%">
                                                <ind:IndImageButton ID="btnBack" ToolTip="Back" runat="server" ImageUrl="~/Images/button_tab_prev.png"
                                                    ImageUrlOver="~/Images/button_tab_prev.png" OnClick="btnBack_Click" OnClientClick="return ConfirmTabChanged(null,null);" /></td>
                                            <td align="left">
                                                <ind:IndImageButton ID="btnSave" ToolTip="Save" runat="server" ImageUrl="~/Images/button_tab_save.png"
                                                    ImageUrlOver="~/Images/button_tab_save.png" OnClick="btnSave_Click" OnClientClick="needToConfirm=false;ClearDirty();" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </radTS:PageView>
                </radTS:RadMultiPage>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnSelectedWP" runat="server" />
    &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
    <input id="hdnInterco" type="hidden" />
    <input id="hdnIsDirty1" type="hidden" />
    <asp:HiddenField ID="hdnIsDirty" Value="0" runat="server" />
    <asp:Button ID="btnDoPostback" runat="server" OnClick="btnDoPostback_Click" Text="Button"
        Visible="false" />

    <div id= "timingAndIntercoDiv" runat = "server" style="display:none; width:100%; height:100%;
                position:absolute; top:0; left:0; filter:alpha(opacity=1); background-color:transparent">
    </div>
    
    <ma:PeriodMassAttr class="drag" runat="server" Visible="true" ID="PeriodMassAttr" />
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
