<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" 
	CodeFile="CopyBudget.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_Budget_CopyBudget_CopyBudget" 
	Title="FollowUp Budget" %>


<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">

    <script type='text/javascript' src='../../../Scripts/GridScripts.js'></script>
    
    <script language="JavaScript" type="text/javascript">

    	function SingleSelect(regex, current) 
    	{
    		var checked = current.checked;
    		re = new RegExp(regex);

    		for (i = 0; i < document.forms[0].elements.length; i++) 
    		{
    			elm = document.forms[0].elements[i];

    			if (elm.type == 'checkbox') 
    			{
    				if (re.test(elm.name)) 
    				{
    					elm.checked = false;
    				}
    			}
    		}

    		current.checked = checked;
    	}

    </script>

    <br />
    <table style="width: 90%; height:auto" class="tabbed" border="0">
        <tr>
			<td valign="top" colspan="3">
				<table cellpadding="0" cellspacing="0" border="0" class="tabbedNoImage" width="100%">
					<tr>
						<td style="width: 5%;" align="left">
							<ind:IndCatLabel ID="lblProject" runat="server">Project:</ind:IndCatLabel>
						</td>
						<td style="width: 35%;" align="left">
							<ind:IndCatLabel ID="lblProjectName" runat="server" Style="font-weight: bold"></ind:IndCatLabel>
						</td>
						<td style="width: 60%;" align="left">
							<asp:Label ID="lblCopyBudgetStatus" runat="server" CssClass="Warning" Text="" Width="100%"></asp:Label>
						</td>
					</tr>	
				</table>
			</td>

        </tr>
        <tr>
            <td valign="top" colspan="3">
                <radG:RadGrid ID="grdCopyBudget" HorizontalAlign="center" runat="server" AutoGenerateColumns="False"
                    GridLines="None" SkinsPath="~/Skins/Grid" Skin="FollowUpBudget" EnableOutsideScripts="True"
                    AllowPaging="false" OnItemCreated="grdCopyBudget_ItemCreated">
                    <MasterTableView DataKeyNames="" ShowFooter="false" BorderWidth="0">
                        <Columns>
                            <radG:GridTemplateColumn UniqueName="SelectAssociateCol">
                                <ItemTemplate>
                                    <asp:CheckBox runat="server" ID="chkSelectAssociate" OnClick="SingleSelect('chkSelectAssociate',this);" />
                                </ItemTemplate>
                            </radG:GridTemplateColumn>
                            <radG:GridBoundColumn UniqueName="IdAssociate" DataField="IdAssociate" Display="false">
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn HeaderText="Member Name" UniqueName="Associate" DataField="CoreTeamMemberName"
                                FilterImageUrl="~/Skins/Grid/Budget/Filter.gif" SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif"
                                SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif">
                                <ItemStyle Width="150px" HorizontalAlign="left" />
                                <HeaderStyle Width="150px" HorizontalAlign="left" />
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn HeaderText="Employee Number" UniqueName="EmployeeNumber" DataField="EmployeeNumber"
                                FilterImageUrl="~/Skins/Grid/Budget/Filter.gif" SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif"
                                SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif">
                                <ItemStyle Width="100px" HorizontalAlign="left" />
                                <HeaderStyle Width="100px" HorizontalAlign="left" />
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn HeaderText="Function Name" UniqueName="FunctionName" DataField="FunctionName"
                                FilterImageUrl="~/Skins/Grid/Budget/Filter.gif" SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif"
                                SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif">
                                <ItemStyle Width="100px" HorizontalAlign="left" />
                                <HeaderStyle Width="100px" HorizontalAlign="left" />
                            </radG:GridBoundColumn>   
                            <radG:GridBoundColumn HeaderText="Country" UniqueName="Country" DataField="Country"
                                FilterImageUrl="~/Skins/Grid/Budget/Filter.gif" SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif"
                                SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif">
                                <ItemStyle Width="100px" HorizontalAlign="left" />
                                <HeaderStyle Width="100px" HorizontalAlign="left" />
                            </radG:GridBoundColumn>                                                        
                        </Columns>
                    </MasterTableView>
                </radG:RadGrid>
            </td>
        </tr>
		<tr>
			<td align="left" style="width: 33%">
				<ind:IndImageButton runat="server" ID="btnBackToFollowUp" ImageUrl="../../../Images/button_tab_preselectionscre.png"
					ImageUrlOver="../../../Images/button_tab_preselectionscre.png" />
			</td>
			<td align="center" style="width: 34%">
				<ind:IndImageButton ID="btnCopyBudget" runat="server" OnClick="btnCopyBudget_Click" ImageUrl="~/Images/button_tab_copy.png"
                    ImageUrlOver="~/Images/button_tab_copy.png" ToolTip="Move Budget" 
                    OnClientClick="if (!CheckBoxesSelected()) {alert('Select the target member!');return false;}" />
			</td>
			<td style="width: 33%">&nbsp;</td>
		</tr>    
    </table>
</asp:Content>

