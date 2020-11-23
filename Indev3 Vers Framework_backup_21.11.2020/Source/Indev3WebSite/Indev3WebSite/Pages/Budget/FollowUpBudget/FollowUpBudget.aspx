<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="FollowUpBudget.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_Budget_FollowUpBudget_FollowUpBudget"
    Title="FollowUp Budget" %>

<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <script type='text/javascript' src='../../../Scripts/GridScripts.js'></script>
    <table style="width: 90%; height: 110%;" class="tabbed backgroundColorIE" border="0">
        <tr>
            <td valign="top">
                <table cellpadding="5" cellspacing="0" border="0" class="tabbedNoImage backgroundColorIE"
                    width="100%">
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblProject" runat="server">Project:</ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="4">
                            <ind:IndCatLabel ID="lblProjectName" runat="server" Style="font-weight: bold"></ind:IndCatLabel>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" style="width: 10px;">
                            <ind:IndCatLabel ID="lblType" runat="server">Type:</ind:IndCatLabel>
                        </td>
                        <td align="left">
                            <ind:IndCatComboBox ID="cmbType" runat="server" AutoPostBack="true" CheckDirty="false"
                                Width="100px" OnSelectedIndexChanged="cmbType_SelectedIndexChanged" AppendDataBoundItems="true">
                            </ind:IndCatComboBox>
                        </td>
                        <td align="left" style="width: 10px;">
                            <ind:IndCatLabel ID="lblVersions" runat="server">Version:</ind:IndCatLabel>
                        </td>
                        <td align="left">
                            <ind:IndCatComboBox ID="cmbVersions" runat="server" AutoPostBack="true" CheckDirty="false"
                                Width="100px" OnSelectedIndexChanged="cmbVersions_SelectedIndexChanged">
                            </ind:IndCatComboBox>
                        </td>
                        <td align="right" style="width: 70%;">
                            <div runat="server" id="divUnvalidate" visible="false" class="divUnvalidate">
                               <asp:Button ID="btnUnvalidate" runat="server" Text="Un-Validate" class="button" Visible="false" OnClick="btnUnvalidate_Click"
                                  OnClientClick="if (!confirm('Are you sure you want to unvalidate the revised budget?')) {return false;} else {return true;}" />
                            </div>
                            <ind:IndImageButton ID="btnValidate" ToolTip="Validate" runat="server" OnClick="btnValidate_Click" />
                        </td>
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
                            <radG:GridBoundColumn HeaderText="Project Function" UniqueName="Project Function"
                                DataField="Project Function" FilterImageUrl="~/Skins/Grid/Budget/Filter.gif"
                                SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif" SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif">
                                <ItemStyle Width="150px" HorizontalAlign="left" />
                                <HeaderStyle Width="150px" HorizontalAlign="left" />
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn UniqueName="HasData" DataField="HasData" ReadOnly="True" Display="false">
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
                                    <asp:HyperLink runat="server" ID="btnNavigate" ImageUrl="~/Images/button_row_magnify.png"
                                        ToolTip="View Budget" />
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:LinkButton runat="server" CommandName="NavigateAll" ID="btnNavigateAll" Text="All"></asp:LinkButton>
                                </FooterTemplate>
                                <FooterStyle VerticalAlign="top"></FooterStyle>
                            </radG:GridTemplateColumn>
                            <radG:GridTemplateColumn UniqueName="MoveCol">
                                <ItemTemplate>
                                    <asp:HyperLink runat="server" ID="btnMoveBudget" ImageUrl="~/Images/button_row_copy_darkBg.png"
                                        ToolTip="Move Budget" />
                                </ItemTemplate>
                                <FooterStyle VerticalAlign="top"></FooterStyle>
                            </radG:GridTemplateColumn>
                        </Columns>
                    </MasterTableView>
                </radG:RadGrid>
            </td>
        </tr>
    </table>
    <!--fix for IE8 - TODO: delete this when IE7 is dropped completely :) -->
    <!-- hides unwanted columns: IdAssociate and HasData -->
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


        if (GetInternetExplorerVersion() <= 8) {
            var elements = document.querySelectorAll('.GridHeader_FollowUpBudget');
            if (elements !== null && elements.length > 0) {
                elements[1].style.display = "none";
                elements[4].style.display = "none";

                var elements2 = document.querySelectorAll('.IndOddColumn');
                // case when there is an extra column for the move functionallity
                if (elements.length == 9 && elements2 !== null) {
                    for (var j = 0; j < elements2.length; j = j + 4) {
                        elements2[j].nextSibling.style.display = "none";
                        elements2[j].nextSibling.nextSibling.nextSibling.nextSibling.style.display = "none";
                    }
                }
                else
                // case when there is no column for the move functionallity
                    if (elements.length == 8 && elements2 !== null) {
                        for (var j = 0; j < elements2.length; j = j + 3) {
                            elements2[j].nextSibling.style.display = "none";
                            elements2[j].nextSibling.nextSibling.nextSibling.nextSibling.style.display = "none";
                        }
                    }
            }
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
