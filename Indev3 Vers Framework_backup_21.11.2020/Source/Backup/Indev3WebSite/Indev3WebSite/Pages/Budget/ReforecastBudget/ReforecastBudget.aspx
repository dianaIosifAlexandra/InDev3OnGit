<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="ReforecastBudget.aspx.cs" Inherits="Pages_Budget_ReforecastBudget_ReforecastBudget"
    Title="INDev3" EnableEventValidation="false" EnableViewState="true" %>

<%@ Register Assembly="RadMenu.Net2" Namespace="Telerik.WebControls" TagPrefix="radM" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls.Budget"
    TagPrefix="bgt" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<%@ Register Src="~/UserControls/Budget/FollowUpBudget/BudgetEvidenceButton.ascx"
    TagName="EvidenceButton" TagPrefix="mb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">

    <script type='text/javascript' src='../../../Scripts/NumberRepresentation.js'></script>

    <script language="JavaScript" type="text/javascript">
        
    var needToConfirm = true;

    var txtHidden = null;

    window.onbeforeunload = confirmReforecastExit;
    
    function confirmReforecastExit()
    {
        if (needToConfirm)
        {
            if (txtHidden == null)
                txtHidden = document.getElementById('IsDirty');
                
            if (txtHidden.value == '1')
            {
                needToConfirm = false;
                setTimeout("enableCheck()", "100");
                return "There are unsaved changes on the screen.";
            }
        }
    }
    
    function HandleCmbChange(item)
    {
        if (needToConfirm)
        {
            if (txtHidden == null)
                txtHidden = document.getElementById('IsDirty');
                
            if (txtHidden.value == '1')
            {
                var leavePage = confirm("Are you sure you want to navigate away from this page? \r\n\r\nThere is at least one cost center in edit mode.\r\n\r\nPress OK to continue, or cancel to stay on the current page.");
                if (!leavePage)
                {
                    return false;
                }
                else
                {
                    txtHidden.value = '';
                    needToConfirm = false;
                    setTimeout("enableCheck()", "100");
                }
            }
        }
    }
    

    function enableCheck()
    {
        needToConfirm = true;
    }

    function txtChg()
    {
        if (txtHidden == null)
            txtHidden = document.getElementById('IsDirty');
            
        txtHidden.value = '1';
        
        var btnSave = document.getElementById('ctl00_ph_btnSave');
        if (btnSave != null)
        {
            btnSave.disabled = false;
            btnSave.src = '../../../Images/button_tab_save.png';
            btnSave.onmouseout = 'btnSave.src = \'../../../Images/button_tab_save.png\'';
            btnSave.onmouseover = 'btnSave.src = \'../../../Images/button_tab_save.png\'';
        }
        
        var btnSubmit = document.getElementById('ctl00_ph_EvidenceButton_btnSubmit');
        if (btnSubmit != null)
        {
            btnSubmit.disabled = true;
            btnSubmit.src = '../../../Images/button_tab_submit_disabled.png';
            btnSubmit.onmouseout = 'btnSave.src = \'../../../Images/button_tab_submit_disabled.png\'';
            btnSubmit.onmouseover = 'btnSave.src = \'../../../Images/button_tab_submit_disabled.png\'';
        }
        
        var cmbAmountScaleInput = <%= cmbAmountScale.ClientID%>;
        if (cmbAmountScaleInput != null)
        {
            cmbAmountScaleInput.Disable();
        }
		
		var cmbShowCCsWithSignificantValues = <%= cmbShowCCsWithSignificantValues.ClientID%>;
        if (cmbShowCCsWithSignificantValues != null)
        {
			cmbShowCCsWithSignificantValues.Disable();
        }
        
        var cmbCountry = <%= cmbCountry.ClientID%>;
        if (cmbCountry != null)
        {
			cmbCountry.Disable();
        }
        
		var inputTags = document.getElementsByTagName('input'); 
		if (inputTags != null)
		{
			for(var i=0; i<inputTags.length; i++)
			{
				if(inputTags[i].id.indexOf('BtnExpandColumn') != -1)
				{
					inputTags[i].disabled = true;
					inputTags[i].alt = "";
					inputTags[i].title = "";
				}
			}
		}
    }
    
    function ClearDirty()
    {
        if (txtHidden == null) 
            txtHidden = document.getElementById('IsDirty');
        txtHidden.value = "0";
    }
    
    //When pressing delete cc button, this function is called. The enabled state of the save button, submit button and amount scale
    //combobox which is set client side, using txtChg function is not persisted in viewstate (because the enabled state is set on the 
    //client). When a cc is deleted, the state of this controls is lost. We store the state here and restore it after postback, depending
    //on the value of the hidden field (this value is stored because the hidden field has viewstate enabled)
    function StoreUnsafeInEditModeControlsState()
    {
        var btnSave = document.getElementById('ctl00_ph_btnSave');
        if (btnSave != null)
        {
            var hdnReforecast = document.getElementById('ctl00_ph_hdnReforecast');
            if (btnSave.disabled == false)
            {
                hdnReforecast.value = "1";
            }
            else
            {
                hdnReforecast.value = "0";
            }
        }
    }
    
    function TxtKeyPress(keys, txtId)
    {
        txtChg();
        return (RestrictKeys(event, keys, txtId) && PreventFormValidationOnKeyPress());
    }
    
    function DisplayedDataComboChange(item)
    {
        var url = window.location.toString();
        var index = url.indexOf("DisplayedData");
        url = url.substring(0, index);
        
        var cmbAmountScale = <%=cmbAmountScale.ClientID %>;
        var cmbShowCCsWithSignificantValues = <%=cmbShowCCsWithSignificantValues.ClientID %>;
        var cmbCountry = <%=cmbCountry.ClientID %>;

        //If selected displayed data is not hours, put in the querystring the value of cmbAmountScale, else put Units because
        //hours will always be expressed in units
        if (item.Value != "0")
            url = url + "DisplayedData=" + item.Value + "&AmountScale=" + cmbAmountScale.SelectedItem.Value + 
						"&ShowCCsWithValues=" + cmbShowCCsWithSignificantValues.SelectedItem.Value +
						"&IdCountry=" + cmbCountry.SelectedItem.Value;

        else
            url = url + "DisplayedData=" + item.Value + "&AmountScale=Unit" + 
						"&ShowCCsWithValues=" + cmbShowCCsWithSignificantValues.SelectedItem.Value +
						"&IdCountry=" + cmbCountry.SelectedItem.Value;
        
        window.location = url;
    }

    function AmountScaleComboChange(item)
    {
        var url = window.location.toString();
        var index = url.indexOf("DisplayedData");
        url = url.substring(0, index);
        
        var cmbDisplayedData = <%=cmbDisplayedData.ClientID %>;
        var cmbShowCCsWithSignificantValues = <%=cmbShowCCsWithSignificantValues.ClientID %>;
        var cmbCountry = <%=cmbCountry.ClientID %>;
        
        url = url + "DisplayedData=" + cmbDisplayedData.SelectedItem.Value + "&AmountScale=" + item.Value +
					"&ShowCCsWithValues=" + cmbShowCCsWithSignificantValues.SelectedItem.Value +
					"&IdCountry=" + cmbCountry.SelectedItem.Value;
        
        window.location = url;
    }
    
    function SignificantValuesComboChange(item)
    {
		var url = window.location.toString();
        var index = url.indexOf("DisplayedData");
        url = url.substring(0, index);
        
        var cmbDisplayedData = <%=cmbDisplayedData.ClientID %>;
        var cmbAmountScale = <%=cmbAmountScale.ClientID %>;
        var cmbCountry = <%=cmbCountry.ClientID %>;
        
        url = url + "DisplayedData=" + cmbDisplayedData.SelectedItem.Value + "&AmountScale=" + cmbAmountScale.SelectedItem.Value +
					"&ShowCCsWithValues=" + item.Value + "&IdCountry=" + cmbCountry.SelectedItem.Value;
        
        window.location = url;
    }
    
    function CountryComboChange(item)
    {
		var url = window.location.toString();
        var index = url.indexOf("DisplayedData");
        url = url.substring(0, index);
        
        var cmbDisplayedData = <%=cmbDisplayedData.ClientID %>;
        var cmbAmountScale = <%=cmbAmountScale.ClientID %>;
        var cmbShowCCsWithSignificantValues = <%=cmbShowCCsWithSignificantValues.ClientID %>;
        
        url = url + "DisplayedData=" + cmbDisplayedData.SelectedItem.Value + "&AmountScale=" + cmbAmountScale.SelectedItem.Value +
					"&ShowCCsWithValues=" + cmbShowCCsWithSignificantValues.SelectedItem.Value + 
					"&IdCountry=" + item.Value;
        
        window.location = url;
    }
    
    </script>

    <table width="98%">
        <tr>
            <td style="width:40%" align="left">
                <ind:IndLabel ID="lblDisplayedData" runat="server" Text="Data displayed"></ind:IndLabel>
                <radC:RadComboBox ID="cmbDisplayedData" runat="server" OnClientSelectedIndexChanged="DisplayedDataComboChange" AutoPostBack="false" OnSelectedIndexChanged="cmbDisplayedData_SelectedIndexChanged"
                    OnClientSelectedIndexChanging="HandleCmbChange" SkinsPath="~\Skins\ComboBox"
                    Skin="Default">
                </radC:RadComboBox>
                <ind:IndLabel ID="lblCountry" runat="server" Text="Country"></ind:IndLabel>
                <radC:RadComboBox ID="cmbCountry" runat="server" AutoPostBack="false" OnSelectedIndexChanged="cmbCountry_SelectedIndexChanged"
                    OnClientSelectedIndexChanging="HandleCmbChange" OnClientSelectedIndexChanged="CountryComboChange" SkinsPath="~\Skins\ComboBox" Skin="Default">
                </radC:RadComboBox>                
            </td>
            <td style="width:25%" align="center">
				<asp:Label ID="lblAffectedWPsWarning" runat="server" CssClass="Warning" Text="" Width="100%"></asp:Label>
            </td>
            <td style="width:35%" align="right">
                <radC:RadComboBox ID="cmbShowCCsWithSignificantValues" runat="server" AutoPostBack="false" OnClientSelectedIndexChanging="HandleCmbChange"
                    Width="220px" SkinsPath="~\Skins\ComboBox" Skin="Default" OnClientSelectedIndexChanged="SignificantValuesComboChange" 
                    OnSelectedIndexChanged="cmbShowCCsWithSignificantValues_SelectedIndexChanged">
                    <Items>
                        <radC:radcomboboxitem ID="Radcomboboxitem2" runat="server" text="Display only CCs with significant values" value="Filtered">
                        </radC:radcomboboxitem>
                        <radC:radcomboboxitem ID="Radcomboboxitem1" runat="server" text="Display all CCs" value="All"  >
                        </radC:radcomboboxitem>
                    </Items>
                </radC:RadComboBox>
                <ind:IndLabel ID="Label4" runat="server" Text="&nbsp;&nbsp;&nbsp;"></ind:IndLabel>
                <bgt:IndAmountScaleComboBox ID="cmbAmountScale" OnClientSelectedIndexChanged="AmountScaleComboChange" AutoPostBack="false" runat="server"
                    OnSelectedIndexChanged="cmbAmountScale_SelectedIndexChanged">
                </bgt:IndAmountScaleComboBox>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <asp:Panel runat="server" ID="pnlMain">
                    <table class="tabbedNoImage" width="100%">
                        <tr>
                            <td colspan="3">
                                <table cellpadding="0px" cellspacing="0px">
                                    <tr>
                                        <td>
                                            <bgt:IndReforecastGrid EnableOutsideScripts="true" ID="grd" runat="server"
                                                GridLines="None" AllowMultiRowEdit="True" Skin="FollowUpBudget" SkinsPath="~/Skins/Grid"
                                                OnItemCreated="grdReforecast_ItemCreated" OnNeedDataSource="grdReforecast_NeedDataSource">
                                                <MasterTableView HierarchyLoadMode="ServerOnDemand" Name="PhaseWPTableView" AutoGenerateColumns="False"
                                                    EditMode="InPlace" DataKeyNames="IdPhase,IdWP" NoDetailRecordsText="" NoMasterRecordsText=""
                                                    HorizontalAlign="center">
                                                    <Columns>
                                                        <radG:GridTemplateColumn UniqueName="EmptyColumn">
                                                            <itemstyle width="0px" />
                                                            <headerstyle width="0px" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False"
                                                            ReadOnly="true">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" ReadOnly="true">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" ReadOnly="true">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="PhaseWPName" DataField="PhaseWPName" HeaderText="Reforecast Budget"
                                                            ReadOnly="true">
                                                            <itemstyle width="247px" horizontalalign="left" />
                                                            <headerstyle width="247px" horizontalalign="left" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="AddCostCenter">
                                                            <itemtemplate>
                                                    <ind:IndImageButton ID="btnAddCostCenter" runat="server" ImageUrl="../../../Images/button_row_add.png"
                                                        ImageUrlOver="../../../Images/button_row_add.png" ToolTip="Add Cost Center" />
                                            </itemtemplate>
                                                            <itemstyle width="18px" />
                                                            <headerstyle width="18px" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn UniqueName="Progress" DataField="Progress" HeaderText="Progress<br />%">
                                                            <itemstyle width="44px" horizontalalign="center" />
                                                            <headerstyle width="44px" horizontalalign="center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="StartYearMonth" Visible="False" DataField="StartYearMonth"
                                                            ReadOnly="true">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="EndYearMonth" Visible="False" DataField="EndYearMonth"
                                                            ReadOnly="true">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="DateInterval" DataField="DateInterval" ReadOnly="true"
                                                            HeaderText="<br />Period">
                                                            <itemstyle width="93px" horizontalalign="center" />
                                                            <headerstyle width="93px" horizontalalign="center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn HeaderText="<br />Previous" UniqueName="Previous" DataField="Previous"
                                                            ReadOnly="true" DataType="System.Decimal">
                                                            <itemstyle width="72px" horizontalalign="center" />
                                                            <headerstyle width="72px" horizontalalign="center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="CurrentPreviousDiff" DataField="CurrentPreviousDiff"
                                                            ReadOnly="true" Visible="false">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="CurrentPreviousDiffString" DataField="CurrentPreviousDiffString" HeaderText = "<br />Var.">
                                                            <itemtemplate>
                                                                <bgt:IndReforecastBudgetVarLabel ID="lblCPD" runat="server" Text='<%# Bind("CurrentPreviousDiffString") %>'></bgt:IndReforecastBudgetVarLabel>
                                                            </itemtemplate>
                                                            <itemstyle width="72px" horizontalalign="center" />
                                                            <headerstyle width="72px" horizontalalign="center" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn HeaderText="Reforecast<br />Released" UniqueName="Current" DataField="Current"
                                                            ReadOnly="true" DataType="System.Decimal">
                                                            <itemstyle width="72px" horizontalalign="center" />
                                                            <headerstyle width="72px" horizontalalign="center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="NewCurrentDiff" DataField="NewCurrentDiff" ReadOnly="true"
                                                            Visible="false">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="NewCurrentDiffString" DataField="NewCurrentDiffString" HeaderText = "<br />Var.">
                                                            <itemtemplate>
                                                                <bgt:IndReforecastBudgetVarLabel ID="lblNCD" runat="server" Text='<%# Bind("NewCurrentDiffString") %>'></bgt:IndReforecastBudgetVarLabel>
                                                            </itemtemplate>
                                                            <itemstyle width="72px" horizontalalign="center" />
                                                            <headerstyle width="72px" horizontalalign="center" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn HeaderText="<br />InProgress" UniqueName="New" DataField="New" ReadOnly="true" DataType="System.Decimal">
                                                            <itemstyle width="72px" horizontalalign="center" />
                                                            <headerstyle width="72px" horizontalalign="center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="NewRevisedDiff" DataField="NewRevisedDiff" ReadOnly="true"
                                                            Visible="false">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="NewRevisedDiffString" DataField="NewRevisedDiffString" HeaderText = "<br />Var.">
                                                            <itemtemplate>
                                                                <bgt:IndReforecastBudgetVarLabel ID="lblNewRevisedDiff" runat="server" Text='<%# Bind("NewRevisedDiffString") %>'></bgt:IndReforecastBudgetVarLabel>
                                                            </itemtemplate>
                                                            <itemstyle width="72px" horizontalalign="center" />
                                                            <headerstyle width="72px" horizontalalign="center" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn HeaderText="<br />Revised" UniqueName="Revised" DataField="Revised"
                                                            ReadOnly="true" DataType="System.Decimal">
                                                            <itemstyle width="72px" horizontalalign="center" />
                                                            <headerstyle width="72px" horizontalalign="center" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="IsActive" DataField="IsActive" Visible="False"
                                                            ReadOnly="true">
                                                        </radG:GridBoundColumn>
                                                    </Columns>
                                                    <ExpandCollapseColumn Visible="false">
                                                        <HeaderStyle Width="19px" />
                                                    </ExpandCollapseColumn>
                                                    <DetailTables>
                                                        <radG:GridTableView runat="server" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP,IdCostCenter"
                                                            NoDetailRecordsText="" NoMasterRecordsText="" Name="CostCenterTableView" EditMode="InPlace"
                                                            HorizontalAlign="Right" HierarchyLoadMode="ServerOnDemand" ShowHeader="False">
                                                            <parenttablerelation>
                                                <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                <radG:GridRelationFields DetailKeyField="IdWP" MasterKeyField="IdWP" />
                                            </parenttablerelation>
                                                            <columns>
                                                <radG:GridTemplateColumn UniqueName = "Emptyolumn">
                                                    <ItemStyle Width="0px" />
                                                    <HeaderStyle Width="0px" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn DataField="IdProject" UniqueName="IdProject" Visible="False"
                                                    ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="IdPhase" UniqueName="IdPhase" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="IdWP" UniqueName="IdWP" Visible="False" ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="IdCostCenter" UniqueName="IdCostCenter" Visible="False"
                                                    ReadOnly="true">
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn DataField="CurrencyCode" UniqueName="CurrencyCode" ReadOnly="true">
                                                    <ItemStyle ForeColor="orange" Width="19px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridTemplateColumn UniqueName="DeleteCostCenter">
                                                    <ItemTemplate>
                                                        <ind:IndImageButton ID="btnDeleteCostCenter" ToolTip="Delete Cost Center" OnClick="btnDeleteCostCenter_Click"
                                                            runat="server" ImageUrl="../../../Images/button_row_delete.gif" ImageUrlOver="../../../Images/button_row_delete.gif"
                                                            OnClientClick="needToConfirm=false; if (!confirm('Are you sure you want to delete the Cost Center? \r\n\r\nNote that if the Cost Center has actual or revised data, it will still appear in the budget.')) {return false;} else {StoreUnsafeInEditModeControlsState(); return true;}" />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="20px" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn UniqueName="CostCenterName" DataField="CostCenterName" ReadOnly="true">
                                                    <ItemStyle Width="247px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridTemplateColumn UniqueName="Sum">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSum" Text="&Sigma;" runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="center" Width="93px" Font-Bold="true" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn UniqueName="Previous" DataField="Previous" ReadOnly="true"
                                                    DataType="System.Decimal">
                                                    <ItemStyle HorizontalAlign="center" Width="72px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="CurrentPreviousDiff" DataField="CurrentPreviousDiff"
                                                    ReadOnly="true" Visible="false">
                                                </radG:GridBoundColumn>
                                                <radG:GridTemplateColumn UniqueName="CurrentPreviousDiffString" DataField="CurrentPreviousDiffString">
                                                    <ItemTemplate>
                                                        <bgt:IndReforecastBudgetVarLabel ID="lblCPD" runat="server" Text='<%# Bind("CurrentPreviousDiffString") %>'></bgt:IndReforecastBudgetVarLabel>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="center" Width="72px" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn UniqueName="Current" DataField="Current"
                                                    ReadOnly="true" DataType="System.Decimal">
                                                    <ItemStyle HorizontalAlign="center" Width="72px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="NewCurrentDiff" DataField="NewCurrentDiff" ReadOnly="true"
                                                    Visible="false">
                                                </radG:GridBoundColumn>
                                                <radG:GridTemplateColumn UniqueName="NewCurrentDiffString" DataField="NewCurrentDiffString">
                                                    <ItemTemplate>
                                                        <bgt:IndReforecastBudgetVarLabel ID="lblNCD" runat="server" Text='<%# Bind("NewCurrentDiffString") %>'></bgt:IndReforecastBudgetVarLabel>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="center" Width="72px" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn UniqueName="New" DataField="New" DataType="System.Decimal">
                                                    <ItemStyle HorizontalAlign="center" Width="72px" />
                                                </radG:GridBoundColumn>
                                                <radG:GridBoundColumn UniqueName="NewRevisedDiff" DataField="NewRevisedDiff" ReadOnly="true"
                                                    Visible="false">
                                                </radG:GridBoundColumn>
                                                <radG:GridTemplateColumn UniqueName="NewRevisedDiffString" DataField="NewRevisedDiffString">
                                                    <ItemTemplate>
                                                        <bgt:IndReforecastBudgetVarLabel ID="lblNewRevisedDiff" runat="server" Text='<%# Bind("NewRevisedDiffString") %>'></bgt:IndReforecastBudgetVarLabel>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="center" Width="72px" />
                                                </radG:GridTemplateColumn>
                                                <radG:GridBoundColumn UniqueName="Revised" DataField="Revised"
                                                    ReadOnly="true" DataType="System.Decimal">
                                                    <ItemStyle HorizontalAlign="center" Width="72px" />
                                                </radG:GridBoundColumn>
                                            </columns>
                                                            <expandcollapsecolumn visible="true">
                                                <HeaderStyle Width="19px" />
                                            </expandcollapsecolumn>
                                                            <detailtables>
                                                <radG:GridTableView runat="server" AutoGenerateColumns="False" DataKeyNames="IdPhase,IdWP,IdCostCenter,YearMonth"
                                                    EditMode="InPlace" NoDetailRecordsText="" NoMasterRecordsText="" Name="MonthTableView"
                                                    HorizontalAlign="Right" ShowHeader="False" HierarchyLoadMode="ServerOnDemand">
                                                    <ParentTableRelation>
                                                        <radG:GridRelationFields DetailKeyField="IdPhase" MasterKeyField="IdPhase" />
                                                        <radG:GridRelationFields DetailKeyField="IdWP" MasterKeyField="IdWP" />
                                                        <radG:GridRelationFields DetailKeyField="IdCostCenter" MasterKeyField="IdCostCenter" />
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
                                                        <radG:GridBoundColumn DataField="YearMonth" UniqueName="YearMonth" Visible="False"
                                                            ReadOnly="True">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="CostCenterName" DataField="CostCenterName" ReadOnly="true"
                                                            Visible="false">
                                                            <ItemStyle />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="Progress">
                                                            <ItemStyle Width="1px" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn DataField="Date" UniqueName="Date" ReadOnly="True">
                                                            <ItemStyle HorizontalAlign="center" Width="93px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IsPreviousActual" UniqueName="IsPreviousActual"
                                                            ReadOnly="True" Visible="false">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IsCurrentActual" UniqueName="IsCurrentActual" ReadOnly="True"
                                                            Visible="false">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn DataField="IsNewActual" UniqueName="IsNewActual" ReadOnly="True"
                                                            Visible="false">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="Previous" DataField="Previous" ReadOnly="true" DataType="System.Decimal">
                                                            <ItemStyle HorizontalAlign="center" Width="72px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="CurrentPreviousDiff" DataField="CurrentPreviousDiff"
                                                            ReadOnly="true" Visible="false">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="CurrentPreviousDiffString" DataField="CurrentPreviousDiffString">
                                                            <ItemTemplate>
                                                                <bgt:IndReforecastBudgetVarLabel ID="lblCPD" runat="server" Text='<%# Bind("CurrentPreviousDiffString") %>'></bgt:IndReforecastBudgetVarLabel>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="center" Width="72px" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn UniqueName="Current" DataField="Current"
                                                            ReadOnly="true" DataType="System.Decimal">
                                                            <ItemStyle HorizontalAlign="center" Width="72px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridBoundColumn UniqueName="NewCurrentDiff" DataField="NewCurrentDiff" ReadOnly="true"
                                                            Visible="false">
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="NewCurrentDiffString" DataField="NewCurrentDiffString">
                                                            <ItemTemplate>
                                                                <bgt:IndReforecastBudgetVarLabel ID="lblNCD" runat="server" Text='<%# Bind("NewCurrentDiffString") %>'></bgt:IndReforecastBudgetVarLabel>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="center" Width="72px" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridBoundColumn UniqueName="New" DataField="New" DataType="System.Decimal">
                                                            <ItemStyle HorizontalAlign="center" Width="72px" />
                                                        </radG:GridBoundColumn>
                                                        <radG:GridTemplateColumn UniqueName="NewRevisedDiff" >
                                                            <ItemStyle HorizontalAlign="center" Width="72px" />
                                                        </radG:GridTemplateColumn>
                                                        <radG:GridTemplateColumn UniqueName="Revised">
                                                            <ItemStyle HorizontalAlign="center" Width="72px" />
                                                        </radG:GridTemplateColumn>
                                                    </Columns>
                                                    <ExpandCollapseColumn Visible="False">
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
                                            </bgt:IndReforecastGrid>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="padding-top: 0px;">
                                            <asp:Panel runat="server" ID="pnlTotals" HorizontalAlign="Right" CssClass="TotalsPanel">
                                                <table cellspacing="0px">
                                                    <tr>
                                                        <td align="left" style="width: 416px;">
                                                            <ind:IndLabel runat="server" ID="lblTotal" Text="Total"></ind:IndLabel>
                                                        </td>
                                                        <td align="center">
                                                            <ind:IndFormatedLabel runat="server" ID="lblPreviousTotals" Width="74px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                        </td>
                                                        <td align="center">
                                                            <bgt:IndReforecastBudgetVarLabel runat="server" ID="lblCurrentPreviousDiffTotals"
                                                                Width="74px" CssClass="IndGridPagerLabel"></bgt:IndReforecastBudgetVarLabel>
                                                        </td>
                                                        <td align="center">
                                                            <ind:IndFormatedLabel runat="server" ID="lblCurrentTotals" Width="74px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                        </td>
                                                        <td align="center">
                                                            <bgt:IndReforecastBudgetVarLabel runat="server" ID="lblNewCurrentDiffTotals" Width="74px"
                                                                CssClass="IndGridPagerLabel"></bgt:IndReforecastBudgetVarLabel>
                                                        </td>
                                                        <td align="center">
                                                            <ind:IndFormatedLabel runat="server" ID="lblNewTotals" Width="74px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                        </td>
                                                        <td align="center">
                                                            <bgt:IndReforecastBudgetVarLabel runat="server" ID="lblNewRevisedDiffTotals" Width="74px"
                                                                CssClass="IndGridPagerLabel"></bgt:IndReforecastBudgetVarLabel>
                                                        </td>
                                                        <td align="center">
                                                            <ind:IndFormatedLabel runat="server" ID="lblRevisedTotals" Width="74px" CssClass="IndGridPagerLabel"></ind:IndFormatedLabel>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="3">
                                <asp:Label ID="lblWarning" runat="server" CssClass="Warning" Text="The numbers displayed could be inaccurate because of the exchange rate conversion and rounding"
                                    Width="100%">
                                </asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 33%">
                                <ind:IndImageButton runat="server" ID="btnPreselection" ImageUrl="../../../Images/button_tab_preselectionscre.png"
                                    ImageUrlOver="../../../Images/button_tab_preselectionscre.png" />
                            </td>
                            <td align="center" style="width: 33%">
                                <ind:IndImageButton ID="btnSave" runat="server" OnClick="btnSave_Click" ImageUrl="~/Images/button_tab_save.png"
                            ImageUrlOver="~/Images/button_tab_save.png" ToolTip="Save All" />
                            </td>
                            <td align="right" style="width: 33%">
                                <asp:Panel ID="pnlEvidence" runat="server">
                                    <mb:EvidenceButton runat="server" ApprovedVisible="false" RejectVisible="false" SubmitVisible="false"
                                        BudgetState="N" ID="EvidenceButton" BudgetType="0" BudgetVersion="N" />
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
    <asp:Button ID="btnDoPostBack" runat="server" Text="Button" Visible="False" />
    <bgt:IndBudgetContextMenu ID="IndBudgetContextMenu1" runat="server" DataGridName="grd"
        MasterTableName="WPs" DetailTableName="CCs">
    </bgt:IndBudgetContextMenu>
    <asp:HiddenField ID="hdnReforecast" runat="server" />
</asp:Content>
