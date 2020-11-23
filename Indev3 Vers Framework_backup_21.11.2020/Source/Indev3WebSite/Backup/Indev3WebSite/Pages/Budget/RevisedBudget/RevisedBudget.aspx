<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="RevisedBudget.aspx.cs" Inherits="Pages_Budget_RevisedBudget_RevisedBudget"
    Title="INDev3" EnableEventValidation="false" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls.Budget"
    TagPrefix="cc2" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadTabStrip.Net2" Namespace="Telerik.WebControls" TagPrefix="radTS" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls.Budget"
    TagPrefix="cc1" %>
<%@ Register Src="~/UserControls/Budget/FollowUpBudget/BudgetEvidenceButton.ascx"
    TagName="EvidenceButton" TagPrefix="mb" %>
<asp:Content ID="ph" ContentPlaceHolderID="ph" runat="Server">

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
                        return "There is at least one cost center in edit mode.";
                    }
                }
            }
            
        }
      }
      
      function enableCheck()
      {
        needToConfirm = true;
      }
         
      function ConfirmTabChanged(sender, eventArgs)
      {
       var inputs = document.getElementsByTagName('input');
            for(var i=0; i<inputs.length; i++)
            {
                if (inputs[i].getAttribute('type') == 'text')
                {
                    var txtDetail = inputs[i];
                    if ((txtDetail.name.indexOf("grd") > 0) && (txtDetail.disabled == false))
                    {
                       var leavePage = confirm("Are you sure you want to navigate away from this page? \r\n\r\nThere is at least one cost center in edit mode.\r\n\r\nPress OK to continue, or cancel to stay on the current page.");
                       if (!leavePage)
                            return false;
                       else
                       {
                            needToConfirm = false;
                            return;
                       }
                    }
                }
            }
      }
      
        function ComboChange(item)
        {
            var url = window.location.toString();
            var index = url.indexOf("AmountScale");
            url = url.substring(0, index);
            
            var cmbCountry = <%= cmbCountry.ClientID%>;
            
            url = url + "AmountScale=" + item.Value + "&IdCountry=" + cmbCountry.SelectedItem.Value;
            
            window.location = url;
        }
        
        function CountryComboChange(item)
        {
            var url = window.location.toString();
            var index = url.indexOf("AmountScale");
            url = url.substring(0, index);
            
            var cmbAmountScale = <%= cmbAmountScale.ClientID%>;
            
            url = url + "AmountScale=" + cmbAmountScale.SelectedItem.Value + "&IdCountry=" + item.Value;
            
            window.location = url;
        }        
    </script>

    <br />
    <div style="width: 98%;">
        <table width="100%">
            <tr>
                <td style="width:25%" align="left">
                    <radTS:RadTabStrip ID="tabStripRevisedBudget"  runat="server" MultiPageID="MultiPageContainer"
                        AutoPostBack="True" Skin="Default" SkinsPath="~/Skins/Tabstrip"
                        OnTabClick="tabStripRevisedBudget_TabClick" OnClientTabSelecting="ConfirmTabChanged">
                        <Tabs>
                            <radTS:Tab ID="Tab1" runat="server" Text="Hours" PageViewID="tabHours">
                            </radTS:Tab>
                            <radTS:Tab ID="Tab2" runat="server" Text="Costs &amp; Sales" PageViewID="tabCostsSales">
                            </radTS:Tab>
                            <radTS:Tab ID="Tab3" runat="server" Text="Summary" PageViewID="tabValidation">
                            </radTS:Tab>
                        </Tabs>
                    </radTS:RadTabStrip>
                </td>
                <td style="width:35%" align="center">
					<asp:Label ID="lblNoWPsAffected" runat="server" CssClass="Warning" Text="" Width="100%"></asp:Label>
				</td>
                <td style="width:40%" align="right">
					<ind:IndLabel ID="lblCountry" runat="server" Text="Country"></ind:IndLabel>
					<radC:RadComboBox ID="cmbCountry" runat="server" AutoPostBack="false" OnSelectedIndexChanged="cmbCountry_SelectedIndexChanged"
						OnClientSelectedIndexChanged="CountryComboChange" SkinsPath="~\Skins\ComboBox" Skin="Default">
					</radC:RadComboBox>                
                    <cc2:IndAmountScaleComboBox ID="cmbAmountScale" OnClientSelectedIndexChanged="ComboChange" runat="server" AutoPostBack="False">
                    </cc2:IndAmountScaleComboBox>
                </td>
            </tr>
        </table>
    </div>
    <table width="98%" class="tabbedNoImage">
        <tr>
            <td colspan="3">
                <radTS:RadMultiPage ID="MultiPageContainer" runat="server" Width="100%" SelectedIndex="0">
                    <radTS:PageView ID="tabHours" runat="server" Width="100%">
                        <table cellpadding="0px" cellspacing="0px" align="center">
                            <tr>
                                <td>
                                    <ind:IndGrid ID="grdHours" runat="server" GridLines="None" AllowMultiRowEdit="True"
                                        Skin="Budget" SkinsPath="~/Skins/Grid" OnNeedDataSource="grdHours_NeedDataSource"
                                        OnItemCreated="grdHours_ItemCreated" OnUpdateCommand="grdHours_UpdateCommand"
                                        OnCancelCommand="grdHours_CancelCommand" OnEditCommand="grdHours_EditCommand"
                                        OnPreRender="grdHours_PreRender">
                                        <MasterTableView HierarchyLoadMode="ServerOnDemand" Name="PhaseTableView" AutoGenerateColumns="False"
                                            DataKeyNames="IdPhase" NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="center"
                                            EditMode="InPlace">
                                            <CommandItemSettings AddNewRecordImageUrl="~/Skins/Grid/TimingAndInterco/AddRecord.gif"
                                                RefreshImageUrl="~/Skins/Grid/TimingAndInterco/Refresh.gif" />
                                            <Columns>
                                                <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False"
                                                    ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditColumn">
                                                    <itemstyle width="36px" horizontalalign="right" />
                                                </radG:GridEditCommandColumn>
                                                <radG:GridBoundColumn UniqueName="PhaseName" DataField="PhaseName" HeaderText="Revised Budget"
                                                    ReadOnly="true">
                                                    <itemstyle width="321px" horizontalalign="left" />
                                                    <headerstyle width="321px" horizontalalign="left" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="<br />Released" UniqueName="CurrentHours" DataField="CurrentHours"
                                                    DataType="System.Int32" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Hours<br />Update" UniqueName="UpdateHours" DataField="UpdateHours"
                                                    DataType="System.Int32" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="<br />InProgress" UniqueName="NewHours" DataField="NewHours"
                                                    DataType="System.Int32" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="<br />Released" UniqueName="CurrentVal" DataField="CurrentVal"
                                                    DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Valorization<br />Update" UniqueName="UpdateVal"
                                                    DataField="UpdateVal" DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="<br />InProgress" UniqueName="NewVal" DataField="NewVal"
                                                    DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                            </Columns>
                                            <ExpandCollapseColumn>
                                                <HeaderStyle Width="19px" />
                                            </ExpandCollapseColumn>
                                            <DetailTables>
                                                <radG:GridTableView runat="server" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP"
                                                    NoDetailRecordsText="" NoMasterRecordsText="" Name="WPTableView" HorizontalAlign="Right"
                                                    HierarchyLoadMode="ServerOnDemand" ShowHeader="False" EditMode="InPlace">
                                                    <parenttablerelation>
                                            <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                        </parenttablerelation>
                                                    <columns>
                                            <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditColumn">
                                                <ItemStyle Width="36px" HorizontalAlign="right" />
                                            </radG:GridEditCommandColumn>
                                            <radG:GridBoundColumn UniqueName="WPName" DataField="WPName" ReadOnly="true">
                                                <ItemStyle Width="178px" />
                                            </radG:GridBoundColumn>
                                            <radG:GridTemplateColumn UniqueName="AddCostCenter">
                                                <ItemTemplate>
                                                    <ind:IndImageButton ID="btnAddCostCenter" runat="server" ImageUrl="../../../Images/button_row_add.png"
                                                        ImageUrlOver="../../../Images/button_row_add.png" ToolTip="Add Cost Center" />
                                                </ItemTemplate>
                                                <ItemStyle Width="18px" />
                                            </radG:GridTemplateColumn>
                                            <radG:GridBoundColumn UniqueName="StartYearMonth" Visible="False" DataField="StartYearMonth" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="EndYearMonth" Visible="False" DataField="EndYearMonth" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="DateInterval" DataField="DateInterval" ReadOnly="true">
                                                <ItemStyle Width="94px" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="CurrentHours" DataField="CurrentHours" DataType="System.Int32" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="UpdateHours" DataField="UpdateHours" DataType="System.Int32" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="NewHours" DataField="NewHours" DataType="System.Int32" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="CurrentVal" DataField="CurrentVal" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="UpdateVal" DataField="UpdateVal" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="NewVal" DataField="NewVal" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="IsActive" DataField="IsActive" Visible="False" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                        </columns>
                                                    <expandcollapsecolumn>
                                            <HeaderStyle Width="19px" />
                                        </expandcollapsecolumn>
                                                    <detailtables>
                                            <radG:GridTableView Name="HoursCostCenterView" runat="server" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP,IdCostCenter"
                                                EditMode="InPlace" NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="Right"
                                                ShowHeader="false">
                                                <EditFormSettings>
                                                    <EditColumn ButtonType="ImageButton">
                                                    </EditColumn>
                                                </EditFormSettings>
                                                <ParentTableRelation>
                                                    <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                    <radG:GridRelationFields DetailKeyField="IdWP" MasterKeyField="IdWP" />
                                                </ParentTableRelation>
                                                <Columns>
                                                    <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False"
                                                        ReadOnly="True">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" ReadOnly="True">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" ReadOnly="True">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdCostCenter" UniqueName="IdCostCenter" Visible="False"
                                                        ReadOnly="True">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="CurrencyCode" ReadOnly="True" UniqueName="CurrencyCode">
                                                        <ItemStyle Width="22px" ForeColor="orange" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditColumn">
                                                        <ItemStyle Width="42px" HorizontalAlign="right" />
                                                    </radG:GridEditCommandColumn>
                                                    <radG:GridTemplateColumn UniqueName="DeleteColumn">
                                                        <ItemTemplate>
                                                            <ind:IndImageButton ID="btnDeleteCostCenter" ToolTip="Delete Cost Center" OnClick="btnDeleteCostCenter_Click"
                                                                runat="server" ImageUrl="../../../Images/button_row_delete.gif" ImageUrlOver="../../../Images/button_row_delete.gif"
                                                                OnClientClick="if (!confirm('Are you sure you want to delete the Cost Center?')) return false; else return true;" />
                                                        </ItemTemplate>
                                                        <ItemStyle Width="20px" />
                                                    </radG:GridTemplateColumn>
                                                    <radG:GridBoundColumn UniqueName="CostCenterName" DataField="CostCenterName" ReadOnly="True">
                                                        <ItemStyle Width="242px" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="CurrentHours" DataField="CurrentHours" ReadOnly="True" DataType="System.Int32">
                                                        <ItemStyle Width="96px" HorizontalAlign="center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="UpdateHours" DataField="UpdateHours" DataType="System.Int32">
                                                        <ItemStyle Width="96px" HorizontalAlign="center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="NewHours" DataField="NewHours" ReadOnly="True" DataType="System.Int32">
                                                        <ItemStyle Width="96px" HorizontalAlign="center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="CurrentVal" DataField="CurrentVal" ReadOnly="True" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="UpdateVal" DataField="UpdateVal" ReadOnly="True" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="NewVal" DataField="NewVal" ReadOnly="True" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdCurrency" ReadOnly="True" UniqueName="IdCurrency"
                                                        Visible="False">
                                                    </radG:GridBoundColumn>
                                                </Columns>
                                                <ExpandCollapseColumn>
                                                    <HeaderStyle Width="19px" />
                                                </ExpandCollapseColumn>
                                                <RowIndicatorColumn Visible="False">
                                                </RowIndicatorColumn>
                                            </radG:GridTableView>
                                        </detailtables>
                                                    <rowindicatorcolumn visible="False">
                                        </rowindicatorcolumn>
                                                </radG:GridTableView>
                                            </DetailTables>
                                            <RowIndicatorColumn Visible="False">
                                            </RowIndicatorColumn>
                                        </MasterTableView>
                                    </ind:IndGrid>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="padding-top: 0px;">
                                    <asp:Panel runat="server" ID="pnlTotalsHours" HorizontalAlign="Right" CssClass="TotalsPanel">
                                        <table cellspacing="0px" align="right">
                                            <tr>
                                                <td align="left" style="width:323px;">
                                                    <ind:IndLabel runat="server" ID="lblTotal1" Text="Total"></ind:IndLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblCurrentHoursTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblUpdateHoursTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblNewHoursTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblCurrentValTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblUpdateValTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblNewValTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </radTS:PageView>
                    <radTS:PageView ID="tabCostsSales" runat="server" Width="100%">
                        <table cellpadding="0px" cellspacing="0px">
                            <tr>
                                <td>
                                    <ind:IndGrid ID="grdCostsSales" runat="server" GridLines="None" AllowMultiRowEdit="True"
                                        Skin="Budget" SkinsPath="~/Skins/Grid" OnNeedDataSource="grdCostsSales_NeedDataSource"
                                        OnItemCreated="grdHours_ItemCreated" OnCancelCommand="grdCostsSales_CancelCommand"
                                        OnUpdateCommand="grdCostsSales_UpdateCommand" OnEditCommand="grdHours_EditCommand"
                                        OnPreRender="grdCostsSales_PreRender">
                                        <MasterTableView Name="PhaseTableView" AutoGenerateColumns="False" DataKeyNames="IdPhase"
                                            NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="Center" HierarchyLoadMode="ServerOnDemand"
                                            EditMode="InPlace">
                                            <Columns>
                                                <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False"
                                                    ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditColumn">
                                                    <itemstyle width="36px" horizontalalign="right" />
                                                </radG:GridEditCommandColumn>
                                                <radG:GridBoundColumn UniqueName="PhaseName" DataField="PhaseName" HeaderText="Revised Budget"
                                                    ReadOnly="true">
                                                    <itemstyle width="321px" horizontalalign="left" />
                                                    <headerstyle width="321px" horizontalalign="left" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="<br />Released" UniqueName="CurrentCost" DataField="CurrentCost"
                                                    DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Costs<br />Update" UniqueName="UpdateCost" DataField="UpdateCost"
                                                    DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="<br />InProgress" UniqueName="NewCost" DataField="NewCost"
                                                    DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="<br />Released" UniqueName="CurrentSales" DataField="CurrentSales"
                                                    DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Sales<br />Update" UniqueName="UpdateSales" DataField="UpdateSales"
                                                    DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="<br />InProgress" UniqueName="NewSales" DataField="NewSales"
                                                    DataType="System.Decimal" ReadOnly="true">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                            </Columns>
                                            <ExpandCollapseColumn>
                                                <HeaderStyle Width="19px" />
                                            </ExpandCollapseColumn>
                                            <DetailTables>
                                                <radG:GridTableView runat="server" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP"
                                                    NoDetailRecordsText="" NoMasterRecordsText="" Name="WPTableView" HorizontalAlign="Right"
                                                    HierarchyLoadMode="ServerOnDemand" ShowHeader="False" EditMode="InPlace">
                                                    <parenttablerelation>
                                            <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                        </parenttablerelation>
                                                    <columns>
                                            <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditColumn">
                                                <ItemStyle Width="36px" HorizontalAlign="right" />
                                            </radG:GridEditCommandColumn>
                                            <radG:GridBoundColumn UniqueName="WPName" DataField="WPName" ReadOnly="true">
                                                <ItemStyle Width="178px" />
                                            </radG:GridBoundColumn>
                                            <radG:GridTemplateColumn UniqueName="AddCostCenter">
                                                <ItemTemplate>
                                                    <ind:IndImageButton ID="btnAddCostCenter" runat="server" ImageUrl="../../../Images/button_row_add.png"
                                                        ImageUrlOver="../../../Images/button_row_add.png" ToolTip="Add Cost Center" />
                                                </ItemTemplate>
                                                <ItemStyle Width="18px" />
                                            </radG:GridTemplateColumn>
                                            <radG:GridBoundColumn UniqueName="StartYearMonth" Visible="False" DataField="StartYearMonth" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="EndYearMonth" Visible="False" DataField="EndYearMonth" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="DateInterval" DataField="DateInterval" ReadOnly="true">
                                                <ItemStyle Width="94px" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="CurrentCost" DataField="CurrentCost" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="UpdateCost" DataField="UpdateCost" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="NewCost" DataField="NewCost" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="CurrentSales" DataField="CurrentSales" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="UpdateSales" DataField="UpdateSales" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="NewSales" DataField="NewSales" DataType="System.Decimal" ReadOnly="true">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="IsActive" DataField="IsActive" Visible="False" ReadOnly="true">
                                            </radG:GridBoundColumn>
                                        </columns>
                                                    <expandcollapsecolumn>
                                            <HeaderStyle Width="19px" />
                                        </expandcollapsecolumn>
                                                    <detailtables>
                                            <radG:GridTableView runat="server" Name="CostsCostCenterView" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP,IdCostCenter"
                                                EditMode="InPlace" NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="Right"
                                                ShowHeader="false">
                                                <EditFormSettings>
                                                    <EditColumn ButtonType="ImageButton">
                                                    </EditColumn>
                                                </EditFormSettings>
                                                <ParentTableRelation>
                                                    <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                    <radG:GridRelationFields DetailKeyField="IdWP" MasterKeyField="IdWP" />
                                                </ParentTableRelation>
                                                <Columns>
                                                    <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False"
                                                        ReadOnly="True">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" ReadOnly="True">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" ReadOnly="True">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdCostCenter" UniqueName="IdCostCenter" Visible="False"
                                                        ReadOnly="True">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="CurrencyCode" ReadOnly="True" UniqueName="CurrencyCode">
                                                        <ItemStyle Width="22px" ForeColor="orange" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditColumn">
                                                        <ItemStyle Width="42px" HorizontalAlign="right" />
                                                    </radG:GridEditCommandColumn>
                                                    <radG:GridTemplateColumn UniqueName="DeleteColumn">
                                                        <ItemTemplate>
                                                            <ind:IndImageButton ID="btnDeleteCostCenter" ToolTip="Delete Cost Center" OnClick="btnDeleteCostCenter_Click"
                                                                runat="server" ImageUrl="../../../Images/button_row_delete.gif" ImageUrlOver="../../../Images/button_row_delete.gif"
                                                                OnClientClick="if (!confirm('Are you sure you want to delete the Cost Center?')) return false; else return true;" />
                                                        </ItemTemplate>
                                                        <ItemStyle Width="20px" />
                                                    </radG:GridTemplateColumn>
                                                    <radG:GridBoundColumn UniqueName="CostCenterName" DataField="CostCenterName" ReadOnly="True">
                                                        <ItemStyle Width="242px" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="CurrentCost" DataField="CurrentCost" ReadOnly="True" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridTemplateColumn UniqueName="UpdateCost" DataType="System.Decimal">
                                                        <ItemTemplate>
                                                            <ind:IndFormatedLabel ID="lblOtherCosts" runat="server" Text='<%# Bind( "UpdateCost" ) %>' />
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:LinkButton ID="lnkOtherCosts" runat="server" Text='<%# Bind( "UpdateCost" ) %>'
                                                                OnClick="lnkOtherCosts_Click" />
                                                        </EditItemTemplate>
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridTemplateColumn>
                                                    <radG:GridBoundColumn UniqueName="NewCost" DataField="NewCost" ReadOnly="True" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="CurrentSales" DataField="CurrentSales" ReadOnly="True" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="UpdateSales" DataField="UpdateSales" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="NewSales" DataField="NewSales" ReadOnly="True" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdCurrency" ReadOnly="True" UniqueName="IdCurrency"
                                                        Visible="False">
                                                    </radG:GridBoundColumn>
                                                </Columns>
                                                <ExpandCollapseColumn>
                                                    <HeaderStyle Width="19px" />
                                                </ExpandCollapseColumn>
                                                <RowIndicatorColumn Visible="False">
                                                </RowIndicatorColumn>
                                            </radG:GridTableView>
                                        </detailtables>
                                                    <rowindicatorcolumn visible="False">
                                        </rowindicatorcolumn>
                                                </radG:GridTableView>
                                            </DetailTables>
                                            <RowIndicatorColumn Visible="False">
                                            </RowIndicatorColumn>
                                        </MasterTableView>
                                    </ind:IndGrid>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="padding-top: 0px;">
                                    <asp:Panel runat="server" ID="pnlTotalsCostsSales" HorizontalAlign="Right" CssClass="TotalsPanel">
                                        <table cellspacing="0px">
                                            <tr>
                                                <td align="left" style="width:323px;">
                                                    <ind:IndLabel runat="server" ID="lblTotal2" Text="Total"></ind:IndLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblCurrentCostsTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblUpdateCostsTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblNewCostsTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblCurrentSalesTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblUpdateSalesTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblNewSalesTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </radTS:PageView>
                    <radTS:PageView ID="tabValidation" runat="server" Width="100%">
                        <table cellpadding="0px" cellspacing="0px">
                            <tr>
                                <td>
                                    <ind:IndGrid ID="grdValidation" runat="server" GridLines="None" AllowMultiRowEdit="True"
                                        Skin="Budget" SkinsPath="~/Skins/Grid" OnNeedDataSource="grdValidation_NeedDataSource"
                                        OnItemCreated="grdValidation_ItemCreated">
                                        <MasterTableView Name="PhaseTableView" AutoGenerateColumns="False" DataKeyNames="IdPhase"
                                            NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="Center" HierarchyLoadMode="ServerOnDemand">
                                            <Columns>
                                                <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="PhaseName" DataField="PhaseName" HeaderText="Revised Budget">
                                                    <itemstyle width="361px" horizontalalign="left" />
                                                    <headerstyle width="361px" horizontalalign="left" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Total Hours" UniqueName="TotHours" DataField="TotHours"
                                                    DataType="System.Int32">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Averate" UniqueName="Averate" DataField="Averate"
                                                    DataType="System.Decimal">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Value Hours" UniqueName="ValHours" DataField="ValHours"
                                                    DataType="System.Decimal">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="On Project Costs" UniqueName="OtherCost" DataField="OtherCost"
                                                    DataType="System.Decimal">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Sales" UniqueName="Sales" DataField="Sales" DataType="System.Decimal">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn HeaderText="Net Costs" UniqueName="NetCost" DataField="NetCost"
                                                    DataType="System.Decimal">
                                                    <itemstyle width="96px" horizontalalign="center" />
                                                    <headerstyle width="96px" horizontalalign="center" />
                                                </radG:GridBoundColumn>
                                            </Columns>
                                            <ExpandCollapseColumn>
                                                <HeaderStyle Width="19px" />
                                            </ExpandCollapseColumn>
                                            <DetailTables>
                                                <radG:GridTableView runat="server" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP"
                                                    NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="Right" HierarchyLoadMode="ServerOnDemand"
                                                    ShowHeader="false" Name="WPTableView">
                                                    <parenttablerelation>
                                            <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                        </parenttablerelation>
                                                    <columns>
                                            <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="WPName" DataField="WPName">
                                                <ItemStyle Width="236px" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="StartYearMonth" Visible="False" DataField="StartYearMonth">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="EndYearMonth" Visible="False" DataField="EndYearMonth">
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="DateInterval" DataField="DateInterval">
                                                <ItemStyle Width="94px" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="TotHours" DataField="TotHours" DataType="System.Int32">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="Averate" DataField="Averate" DataType="System.Decimal">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="ValHours" DataField="ValHours" DataType="System.Decimal">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="OtherCost" DataField="OtherCost" DataType="System.Decimal">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="Sales" DataField="Sales" DataType="System.Decimal">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                            <radG:GridBoundColumn UniqueName="NetCost" DataField="NetCost" DataType="System.Decimal">
                                                <ItemStyle Width="96px" HorizontalAlign="center" />
                                            </radG:GridBoundColumn>
                                        </columns>
                                                    <expandcollapsecolumn>
                                            <HeaderStyle Width="19px" />
                                        </expandcollapsecolumn>
                                                    <detailtables>
                                            <radG:GridTableView runat="server" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP,IdCostCenter"
                                                NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="Right" ShowHeader="False" Name="SummaryCostCenterTableView">
                                                <EditFormSettings>
                                                    <EditColumn ButtonType="ImageButton">
                                                    </EditColumn>
                                                </EditFormSettings>
                                                <ParentTableRelation>
                                                    <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                    <radG:GridRelationFields DetailKeyField="IdWP" MasterKeyField="IdWP" />
                                                </ParentTableRelation>
                                                <Columns>
                                                    <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdCostCenter" UniqueName="IdCostCenter" Visible="False">
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="CurrencyCode" UniqueName="CurrencyCode">
                                                        <ItemStyle ForeColor="orange" Width="22px" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="CostCenterName" DataField="CostCenterName">
                                                        <ItemStyle Width="304px" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="TotHours" DataField="TotHours" DataType="System.Int32">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="Averate" DataField="Averate" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="ValHours" DataField="ValHours" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="OtherCost" DataField="OtherCost" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="Sales" DataField="Sales" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn UniqueName="NetCost" DataField="NetCost" DataType="System.Decimal">
                                                        <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                    </radG:GridBoundColumn>
                                                    <radG:GridBoundColumn DataField="IdCurrency" ReadOnly="True" UniqueName="IdCurrency"
                                                        Visible="False">
                                                    </radG:GridBoundColumn>
                                                </Columns>
                                                <ExpandCollapseColumn>
                                                    <HeaderStyle Width="19px" />
                                                </ExpandCollapseColumn>
                                                <RowIndicatorColumn Visible="False">
                                                </RowIndicatorColumn>
                                            </radG:GridTableView>
                                        </detailtables>
                                                    <rowindicatorcolumn visible="False">
                                        </rowindicatorcolumn>
                                                </radG:GridTableView>
                                            </DetailTables>
                                            <RowIndicatorColumn Visible="False">
                                            </RowIndicatorColumn>
                                        </MasterTableView>
                                    </ind:IndGrid>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="padding-top: 0px;">
                                    <asp:Panel runat="server" ID="pnlTotalsSummary" HorizontalAlign="Right" CssClass="TotalsPanel">
                                        <table cellspacing="0px">
                                            <tr>
                                                <td align="left" style="width:363px;">
                                                    <ind:IndLabel runat="server" ID="lblTotal3" Text="Total"></ind:IndLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblTotalHoursTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblAverateTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblValHoursTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblOtherCostsTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblSalesTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                                <td align="center">
                                                    <ind:IndFormatedLabel runat="server" ID="lblNetCostsTotals" Width="98px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </radTS:PageView>
                </radTS:RadMultiPage>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <asp:Label ID="lblWarning" runat="server" CssClass="Warning" Text="The numbers displayed could be inaccurate because of the exchange rate conversion and rounding"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" style="width: 33%;">
                <ind:IndImageButton runat="server" ID="btnPreselection" ImageUrl="../../../Images/button_tab_preselectionscre.png"
                    ImageUrlOver="../../../Images/button_tab_preselectionscre.png" />
            </td>
            <td align="center" style="width: 33%;">
                <ind:IndImageButton ID="btnSave" runat="server" ImageUrl="~/Images/button_tab_save.png"
                ImageUrlOver="~/Images/button_tab_save.png" OnClick="btnSave_Click" OnClientClick="needToConfirm=false;"
                ToolTip="Save All" />
            </td>
            <td align="right" style="width: 33%;">
                <asp:Panel ID="pnlEvidence" runat="server">
                    <mb:EvidenceButton runat="server" ApprovedVisible="false" RejectVisible="false" SubmitVisible="false"
                        BudgetState="N" ID="EvidenceButton" BudgetType="0" BudgetVersion="N" />
                </asp:Panel>
            </td>
        </tr>
    </table>
    <asp:Button ID="btnDoPostBack" runat="server" Text="Button" Visible="False" />
    <cc1:IndBudgetContextMenu ID="IndBudgetContextMenu1" runat="server" Style="left: 11px;
        top: 1px" MasterTableName="Phases" DetailTableName="WPs">
    </cc1:IndBudgetContextMenu>
</asp:Content>
