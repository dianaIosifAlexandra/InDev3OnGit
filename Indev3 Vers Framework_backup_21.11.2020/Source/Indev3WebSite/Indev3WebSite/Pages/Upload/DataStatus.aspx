<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="DataStatus.aspx.cs" Inherits="Pages_Upload_DataStatus" Title="Data Status" %>

<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%--<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>--%>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <asp:Panel ID="pnlDataStatus" runat="server" CssClass="Tabbed" Width="90%">
        <table class="tabbed backgroundColorIE">
            <tr>
                <td style="text-align: center;">
                    <cc1:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel">Year</cc1:IndLabel>&nbsp;
                    <cc1:IndComboBox ID="cmbYear" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbYear_SelectedIndexChanged">
                    </cc1:IndComboBox>
                </td>
            </tr>
            <tr>
                <td style="width:100%; padding-top: 20px; padding-bottom: 70px;">
                    <radG:RadGrid ID="grdDataStatus" runat="server" SkinsPath="~/Skins/Grid" Skin="TimingAndInterco" HorizontalAlign="Center">
                        <MasterTableView AutoGenerateColumns="false">
                            <Columns>
                                <radG:GridBoundColumn UniqueName="Country" DataField="Country">
                                    <ItemStyle Width="100px" />
                                    <HeaderStyle Width="100px" />
                                </radG:GridBoundColumn>
                                <radG:GridTemplateColumn UniqueName="January" HeaderText="Jan">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgJanuary" DescriptionUrl='<%# Bind("January") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="February" HeaderText="Feb">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgFebruary" DescriptionUrl='<%# Bind("February") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="March" HeaderText="Mar">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgMarch" DescriptionUrl='<%# Bind("March") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="April" HeaderText="Apr">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgApril" DescriptionUrl='<%# Bind("April") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="May" HeaderText="May">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgMay" DescriptionUrl='<%# Bind("May") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="June" HeaderText="Jun">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgJune" DescriptionUrl='<%# Bind("June") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="July" HeaderText="Jul">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgJuly" DescriptionUrl='<%# Bind("July") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="August" HeaderText="Aug">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgAugust" DescriptionUrl='<%# Bind("August") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="September" HeaderText="Sep">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgSeptember" DescriptionUrl='<%# Bind("September") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="October" HeaderText="Oct">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgOctober" DescriptionUrl='<%# Bind("October") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="November" HeaderText="Nov">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgNovember" DescriptionUrl='<%# Bind("November") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="December" HeaderText="Dec">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgDecember" DescriptionUrl='<%# Bind("December") %>' />
                                    </ItemTemplate>
                                    <ItemStyle Width="50px" />
                                    <HeaderStyle Width="50px" />
                                </radG:GridTemplateColumn>
                                <radG:GridTemplateColumn UniqueName="RemoveLastUpload" HeaderText="">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkRemoveLastUpload"  OnClick="lnkRemoveLastUpload_Click" OnClientClick="if (!confirm('Are you sure you want to remove this upload?')) {return false;} else {return true;}"/> 
                                    </ItemTemplate>
                                    <ItemStyle Width="210px" />
                                    <HeaderStyle Width="210px" />
                                </radG:GridTemplateColumn>
                            </Columns>
                        </MasterTableView>
                    </radG:RadGrid>
                </td>
            </tr>
        </table>
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
