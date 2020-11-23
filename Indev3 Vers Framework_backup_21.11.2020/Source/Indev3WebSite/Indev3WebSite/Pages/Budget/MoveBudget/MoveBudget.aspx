<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" 
	CodeFile="MoveBudget.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_Budget_MoveBudget_MoveBudget" 
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
    <table style="width: 90%; height:auto" class="tabbed backgroundColorIE" border="0">
        <tr>
			<td valign="top" colspan="3">
				<table cellpadding="0" cellspacing="0" border="0" class="tabbedNoImage backgroundColorIE" width="100%">
					<tr>
						<td style="width: 5%;" align="left">
							<ind:IndCatLabel ID="lblProject" runat="server">Project:</ind:IndCatLabel>
						</td>
						<td style="width: 30%;" align="left">
							<ind:IndCatLabel ID="lblProjectName" runat="server" Style="font-weight: bold"></ind:IndCatLabel>
						</td>
						<td style="width: 65%;" align="left">
							<asp:Label ID="lblMoveBudgetStatus" runat="server" CssClass="Warning" Text="" Width="100%"></asp:Label>
						</td>
					</tr>	
				</table>
			</td>

        </tr>
        <tr>
            <td valign="top" colspan="3">
                <radG:RadGrid ID="grdMoveBudget" HorizontalAlign="center" runat="server" AutoGenerateColumns="False"
                    GridLines="None" SkinsPath="~/Skins/Grid" Skin="FollowUpBudget" EnableOutsideScripts="True"
                    AllowPaging="false" OnItemCreated="grdMoveBudget_ItemCreated">
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
                            <radG:GridBoundColumn HeaderText="Employee Number" UniqueName="EmployeeNumber" DataField="EmployeeNumber" Display="false"
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
				<ind:IndImageButton ID="btnMoveBudget" runat="server" OnClick="btnMoveBudget_Click" ImageUrl="~/Images/button_tab_copy.png"
                    ImageUrlOver="~/Images/button_tab_copy.png" ToolTip="Move Budget" 
                    OnClientClick="if (!CheckBoxesSelected()) {alert('Select the target member!');return false;}" />
			</td>
			<td style="width: 33%">&nbsp;</td>
		</tr>    
    </table>
     <input id="hdnAssociateName" type="hidden" runat="server" />

     <!--fix for IE8 - TODO: delete this when IE7 is dropped completely :) -->
     <!-- hides unwanted columns: IdAssociate and EmployeeNumber -->
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

         if (GetInternetExplorerVersion() == 8) {
             var elements = document.querySelectorAll('.GridHeader_FollowUpBudget');
             if (elements !== null && elements.length > 0) {

                 elements[0].nextSibling.style.display = "none";
                 elements[3].style.display = "none";

                 var elements2 = document.querySelectorAll('.IndOddColumn');
                 if (elements2 !== null) {
                     for (var j = 0; j < elements2.length; j = j + 2) {
                         elements2[j].nextSibling.style.display = "none";
                     } 
                 }

                 var elements3 = document.querySelectorAll('.IndEvenColumn');
                 if (elements3 !== null) {
                     for (var j = 0; j < elements3.length; j = j + 2) {
                         elements3[j].nextSibling.style.display = "none";
                     } 
                 }
             }
         }

         (function() {
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
         })();

     </script>
</asp:Content>

