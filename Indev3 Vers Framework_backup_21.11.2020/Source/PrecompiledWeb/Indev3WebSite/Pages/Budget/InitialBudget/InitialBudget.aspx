<%@ page language="C#" masterpagefile="~/Template.master" autoeventwireup="true" inherits="Inergy.Indev3.UI.Pages_Budget_InitialBudget_InitialBudget, App_Web_jmyovmdy" title="INDev3" enableeventvalidation="false" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls.Budget"
    TagPrefix="bgt" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadMenu.Net2" Namespace="Telerik.WebControls" TagPrefix="radM" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<%@ Register Src="~/UserControls/Budget/FollowUpBudget/BudgetEvidenceButton.ascx"
    TagName="EvidenceButton" TagPrefix="mb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">

    <script type='text/javascript' src='../../../Scripts/GridScripts.js'></script>

    <script type='text/javascript' src='../../../Scripts/NumberRepresentation.js'></script>

    <script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>

    <script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

    <script type='text/javascript' src='../../../Scripts/NavigationScripts.js'></script>

    <script language="JavaScript" type="text/javascript">
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
                    if ((txtDetail.name.indexOf("grdInitial") > 0) && (txtDetail.disabled == false))
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
      
    function ComboChange(item)
    {
        var url = window.location.toString();
        var index = url.indexOf("AmountScale");
        url = url.substring(0, index);
        
        var controlCmbCurrency = null;
        var cmbCountry = <%= cmbCountry.ClientID%>;
	var cmbCurrency = document.getElementById('<%= cmbCurrency.ClientID%>');

        if (cmbCurrency !== undefined && cmbCurrency != null &&  cmbCurrency.SelectedItem.Value != null)
        {
            url = url + "AmountScale=" + item.Value + "&IdCountry=" + cmbCountry.SelectedItem.Value + "&IdCurrency=" + cmbCurrency.SelectedItem.Value;
        }
        else
        {
            url = url + "AmountScale=" + item.Value + "&IdCountry=" + cmbCountry.SelectedItem.Value;
        }
        
        window.location = url;
    }
    
    function CountryComboChange(item)
    {
        var url = window.location.toString();
        var index = url.indexOf("AmountScale");
        url = url.substring(0, index);

        var cmbAmountScale = <%= cmbAmountScale.ClientID%>;
	var cmbCurrency =  document.getElementById('<%= cmbCurrency.ClientID%>');

        if (cmbCurrency !== undefined && cmbCurrency != null &&  cmbCurrency.SelectedItem.Value != null)
        {
            url = url + "AmountScale=" + cmbAmountScale.SelectedItem.Value + "&IdCountry=" + item.Value+ "&IdCurrency=" + cmbCurrency.SelectedItem.Value;
        }
        else
        {
            url = url + "AmountScale=" + cmbAmountScale.SelectedItem.Value + "&IdCountry=" + item.Value;        
        }
        
        window.location = url;
    }

    function CurrencyComboChange(item)
    {
        var url = window.location.toString();
        var index = url.indexOf("AmountScale");
        url = url.substring(0, index);
        
        var cmbAmountScale = <%= cmbAmountScale.ClientID%>;
        var cmbCountry = <%= cmbCountry.ClientID%>;
        url = url + "AmountScale=" + cmbAmountScale.SelectedItem.Value + "&IdCountry=" + cmbCountry.SelectedItem.Value + "&IdCurrency=" + item.Value;
        
        window.location = url;
    }
    </script>

    <table style="vertical-align: bottom">
        <tr>
            <td style="height: 40px; vertical-align: bottom">
				<table width="100%">
					<tr>
						<td align="left" style="width:25%">
							<asp:Label ID="lblNoWPsAffected" runat="server" CssClass="Warning" Text="" Width="100%"></asp:Label>
						</td>
						<td align="right">
                            <ind:IndLabel ID="lblCurrency" runat="server" Text="Currency"></ind:IndLabel>
							<radC:RadComboBox ID="cmbCurrency" runat="server" AutoPostBack="false" OnSelectedIndexChanged="cmbCurrency_SelectedIndexChanged"
								OnClientSelectedIndexChanged="CurrencyComboChange" SkinsPath="~\Skins\ComboBox" Skin="Default">
							</radC:RadComboBox>                
							<ind:IndLabel ID="lblCountry" runat="server" Text="Country"></ind:IndLabel>
							<radC:RadComboBox ID="cmbCountry" runat="server" AutoPostBack="false" OnSelectedIndexChanged="cmbCountry_SelectedIndexChanged"
								OnClientSelectedIndexChanged="CountryComboChange" SkinsPath="~\Skins\ComboBox" Skin="Default">
							</radC:RadComboBox>                
							<bgt:IndAmountScaleComboBox ID="cmbAmountScale" OnClientSelectedIndexChanged="ComboChange" AutoPostBack="false" runat="server">
							</bgt:IndAmountScaleComboBox>
						</td>
					</tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table style="" class="tabbedNoImage backgroundColorIE" cellpadding="0px" cellspacing="0px">
                    <tr>
                        <td valign="top" colspan="3" style="padding-bottom:0px;">
                            <ind:IndGrid ID="grdInitialBudget" runat="server" AllowMultiRowEdit="True" AutoGenerateColumns="False"
                                OnNeedDataSource="grdInitialBudget_NeedDataSource" SkinsPath="~/Skins/Grid" Skin="Budget"
                                OnItemCreated="grdInitialBudget_ItemCreated" EnableOutsideScripts="True" OnUpdateCommand="grdInitialBudget_UpdateCommand"
                                OnCancelCommand="grdInitialBudget_CancelCommand" OnEditCommand="grdInitialBudget_EditCommand">
                                <MasterTableView HierarchyLoadMode="ServerOnDemand" Name="PhaseTableView" DataKeyNames="IdProject,IdPhase"
                                    NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="center" EditMode="InPlace">
                                    <Columns>
                                        <radG:GridBoundColumn HeaderText="IdProject" UniqueName="IdProject" DataField="IdProject"
                                            Visible="False" ReadOnly="true">
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn HeaderText="IdPhase" UniqueName="IdPhase" DataField="IdPhase"
                                            Visible="False" ReadOnly="true">
                                        </radG:GridBoundColumn>
                                        <radG:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditColumn">
                                            <ItemStyle Width="36px" HorizontalAlign="right" />
                                        </radG:GridEditCommandColumn>
                                        <radG:GridBoundColumn UniqueName="PhaseName" HeaderText="Initial Budget" DataField="PhaseName"
                                            ReadOnly="True">
                                            <itemstyle width="321px" horizontalalign="Left" />
                                            <headerstyle width="321px" horizontalalign="Left" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn HeaderText="Tot. Hours" UniqueName="TotalHours" DataField="TotalHours"
                                            DataType="System.Int32" ReadOnly="true">
                                            <itemstyle width="96px" horizontalalign="Center" />
                                            <headerstyle width="96px" horizontalalign="Center" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn HeaderText="Averate" UniqueName="Averate" DataField="Averate"
                                            DataType="System.Decimal" ReadOnly="true">
                                            <itemstyle width="96px" horizontalalign="Center" />
                                            <headerstyle width="96px" horizontalalign="Center" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn HeaderText="Val. Hours" UniqueName="ValuedHours" DataField="ValuedHours"
                                            DataType="System.Decimal" ReadOnly="true">
                                            <itemstyle width="96px" horizontalalign="Center" />
                                            <headerstyle width="96px" horizontalalign="Center" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn HeaderText="On Project Costs" UniqueName="OtherCosts" DataField="OtherCosts"
                                            DataType="System.Decimal" ReadOnly="true">
                                            <itemstyle width="96px" horizontalalign="Center" />
                                            <headerstyle width="96px" horizontalalign="Center" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn HeaderText="Sales" UniqueName="Sales" DataField="Sales" DataType="System.Decimal" ReadOnly="true">
                                            <itemstyle width="96px" horizontalalign="Center" />
                                            <headerstyle width="96px" horizontalalign="Center" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn HeaderText="Net Cost" UniqueName="NetCosts" DataField="NetCosts"
                                            DataType="System.Decimal" ReadOnly="true">
                                            <itemstyle width="96px" horizontalalign="Center" />
                                            <headerstyle width="96px" horizontalalign="Center" />
                                        </radG:GridBoundColumn>
                                    </Columns>
                                    <ExpandCollapseColumn>
                                        <HeaderStyle Width="19px" />
                                    </ExpandCollapseColumn>
                                    <DetailTables>
                                        <radG:GridTableView runat="server" Name="WPTableView" EditMode="InPlace" DataKeyNames="IdProject,IdPhase,IdWP"
                                            Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                            Font-Underline="False" NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="right"
                                            HierarchyLoadMode="ServerOnDemand" ShowHeader="False">
                                            <parenttablerelation>
                                                <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                            </parenttablerelation>
                                            <columns>
                                                <radG:GridBoundColumn UniqueName="IdProject" DataField="IdProject" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="IdPhase" DataField="IdPhase" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="IdWP" DataField="IdWP" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditColumn">
                                                    <ItemStyle Width="36px" HorizontalAlign="right" />
                                                </radG:GridEditCommandColumn>
                                                <radG:GridBoundColumn UniqueName="WPName" DataField="WPName" ReadOnly="True">
                                                    <ItemStyle Width="178px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridTemplateColumn UniqueName="colAddCostCenter">
                                                    <ItemTemplate>
                                                        <ind:IndImageButton ID="btnAddCostCenter" runat="server" ImageUrl="../../../Images/button_row_add.png"
                                                            ImageUrlOver="../../../Images/button_row_add.png" ToolTip="Add Cost Center" />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="18px" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn UniqueName="StartYearMonth" DataField="StartYearMonth" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="EndYearMonth" DataField="EndYearMonth" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="DateInterval" DataField="DateInterval" ReadOnly="true">
                                                    <ItemStyle Width="94px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="TotalHours" DataField="TotalHours" DataType="System.Int32" ReadOnly="true">
                                                    <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="Averate" DataField="Averate" DataType="System.Decimal" ReadOnly="true">
                                                    <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="ValuedHours" DataField="ValuedHours" DataType="System.Decimal" ReadOnly="true">
                                                    <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="OtherCosts" DataField="OtherCosts" DataType="System.Decimal" ReadOnly="true">
                                                    <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="Sales" DataField="Sales" DataType="System.Decimal" ReadOnly="true">
                                                    <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="NetCosts" DataField="NetCosts" DataType="System.Decimal" ReadOnly="true">
                                                    <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="IsActive" DataField="IsActive" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                            </columns>
                                            <expandcollapsecolumn>
                                                <HeaderStyle Width="19px" />
                                            </expandcollapsecolumn>
                                            <detailtables>
                                                <radG:GridTableView Name="CostCenterTableView" runat="server" EditMode="InPlace"
                                                    DataKeyNames="IdProject,IdPhase,IdWP,IdCostCenter" Font-Bold="False"
                                                    Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False"
                                                    NoDetailRecordsText="" NoMasterRecordsText="" HorizontalAlign="right"
                                                    HierarchyLoadMode="ServerOnDemand" ShowHeader="false">
                                                    <ParentTableRelation>
                                                        <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                        <radG:GridRelationFields DetailKeyField="IdWP" MasterKeyField="IdWP" />
                                                    </ParentTableRelation>
                                                    <Columns>
                                                        <radG:GridBoundColumn UniqueName="IdProject" DataField="IdProject" Visible="False">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="IdPhase" DataField="IdPhase" Visible="False">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="IdWP" DataField="IdWP" Visible="False">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="IdCostCenter" DataField="IdCostCenter" Visible="False">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="IdCurrency" DataField="IdCurrency" Visible="False">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="CurrencyCode" DataField="CurrencyCode" ReadOnly="True">
                                                            <ItemStyle ForeColor="Orange" Width="22px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridEditCommandColumn UniqueName="EditCostCenter" ButtonType="ImageButton">
                                                            <ItemStyle HorizontalAlign="Right" Width="42px" />
                                                        </radG:GridEditCommandColumn>
                                                        <radG:GridTemplateColumn UniqueName="DeleteColumn">
                                                            <ItemTemplate>
                                                                <ind:IndImageButton ID="btnDeleteCostCenter" ToolTip="Delete Cost Center" OnClick="btnDeleteWP_Click"
                                                                    runat="server" ImageUrl="../../../Images/button_row_delete.gif" ImageUrlOver="../../../Images/button_row_delete.gif"
                                                                    OnClientClick="if (!confirm('Are you sure you want to delete the Cost Center?')) return false; else return true;" />
                                                            </ItemTemplate>
                                                            <ItemStyle Width="20px" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn UniqueName="CostCenterName" DataField="CostCenterName" ReadOnly="True">
                                                            <ItemStyle Width="242px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="Total Hours" DataField="TotalHours" DataType="System.Int32">
                                                            <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="Averate" DataField="Averate" DataType="System.Decimal" ReadOnly="True">
                                                            <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="Valued Hours" DataField="ValuedHours" DataType="System.Decimal">
                                                            <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="OtherCosts" DataField="OtherCosts" DataType="System.Decimal">
                                                            <ItemTemplate>
                                                                <ind:IndFormatedLabel ID="lblOtherCosts" runat="server" Text='<%# Bind( "OtherCosts" ) %>' />
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:LinkButton ID="lnkOtherCosts" runat="server" Text='<%# Bind( "OtherCosts" ) %>'
                                                                    OnClick="lnkOtherCosts_Click" />
                                                            </EditItemTemplate>
                                                            <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn UniqueName="Sales" DataField="Sales" DataType="System.Decimal">
                                                            <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="NetCosts" DataField="NetCosts" ReadOnly="True" DataType="System.Decimal">
                                                            <ItemStyle Width="96px" HorizontalAlign="Center" />
                                                        </radG:GridBoundColumn>
                                                    </Columns>
                                                    <ExpandCollapseColumn Visible="False">
                                                        <HeaderStyle Width="19px" />
                                                    </ExpandCollapseColumn>
                                                    <RowIndicatorColumn Visible="False">
                                                        <HeaderStyle Width="20px" />
                                                    </RowIndicatorColumn>
                                                </radG:GridTableView>
                                            </detailtables>
                                            <rowindicatorcolumn visible="False">
                                                <HeaderStyle Width="20px" />
                                            </rowindicatorcolumn>
                                        </radG:GridTableView>
                                    </DetailTables>
                                    <RowIndicatorColumn Visible="False">
                                        <HeaderStyle Width="20px" />
                                    </RowIndicatorColumn>
                                </MasterTableView>
                            </ind:IndGrid>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="right" style="padding-top:0px;">
                            <asp:Panel runat="server" ID="pnlTotals" CssClass="TotalsPanel">
                                <table cellspacing="0px">
                                    <tr>
                                        <td align="left" style="width:323px;">
                                            <ind:IndLabel runat="server" ID="lblTotal" Text="Total"></ind:IndLabel>
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
                    <tr>
                        <td align="center" colspan="3">
                            <asp:Label ID="lblWarning" runat="server" CssClass="Warning" Text="The numbers displayed could be inaccurate because of the exchange rate conversion and rounding"
                                Width="100%"></asp:Label></td>
                    </tr>
                    <tr>
                        <td align="left" style="width: 33%; padding-bottom:50px">
                            <ind:IndImageButton runat="server" ID="btnPreselection" ImageUrl="../../../Images/button_tab_preselectionscre.png"
                                ImageUrlOver="../../../Images/button_tab_preselectionscre.png" />
                        </td>
                        <td align="center" style="width: 33%">
                            <ind:IndImageButton ID="btnSave" runat="server" ImageUrl="~/Images/button_tab_save.png"
                            ImageUrlOver="~/Images/button_tab_save.png" OnClick="btnSave_Click" OnClientClick="needToConfirm=false;"
                            ToolTip="Save All" />
                        </td>
                        <td align="right" style="width: 33%">
                            <asp:Panel ID="pnlEvidence" runat="server" Height="50px" Width="125px">
                                <mb:EvidenceButton runat="server" ApprovedVisible="false" RejectVisible="false"
                                    SubmitVisible="false" BudgetState="N" ID="EvidenceButton" />
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Button ID="btnDoPostback" runat="server" Text="Button" Visible="false" />
    <bgt:IndBudgetContextMenu ID="IndBudgetContextMenu1" runat="server" DataGridName="grdInitialBudget"
        MasterTableName="Phases" DetailTableName="WPs">
    </bgt:IndBudgetContextMenu>
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
