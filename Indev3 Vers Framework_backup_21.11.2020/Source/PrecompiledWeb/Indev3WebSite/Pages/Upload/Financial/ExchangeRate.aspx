<%@ page language="C#" masterpagefile="~/Template.master" autoeventwireup="true" inherits="Pages_Financial_ExchangeRate, App_Web_tlylghoh" title="Exchange Rates" %>

<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <asp:Panel ID="pnlExchangeRates" runat="server" CssClass="tabbed background3ColorIE" Width="90%">
    <br />
        <table width="100%">
            <tr>
                <td>
                    <cc1:IndLabel ID="lblYear" runat="server" CssClass="IndLabel">Year</cc1:IndLabel>&nbsp;
                    <cc1:IndComboBox ID="cmbYear" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbYear_SelectedIndexChanged">
                    </cc1:IndComboBox>
                </td>
            </tr>        
            <tr>
                <td style="width:100%">
                    <radG:RadGrid ID="grdExchangeRates" runat="server" SkinsPath="~/Skins/Grid" Skin="FollowUpBudget" HorizontalAlign="Center">
                        <MasterTableView AutoGenerateColumns="false">
                            <Columns>
                                <radG:GridBoundColumn UniqueName="Currency" HeaderText="Currency" DataField="Currency">
                                    <ItemStyle Width="80px" Height="20px" />
                                    <HeaderStyle Width="80px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="January" HeaderText="Jan" DataField="January">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="February" HeaderText="Feb" DataField="February">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="March" HeaderText="Mar" DataField="March">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="April" HeaderText="Apr" DataField="April">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="May" HeaderText="May" DataField="May">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="June" HeaderText="Jun" DataField="June">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="July" HeaderText="Jul" DataField="July">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="August" HeaderText="Aug" DataField="August">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="September" HeaderText="Sep" DataField="September">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="October" HeaderText="Oct" DataField="October">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="November" HeaderText="Nov" DataField="November">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="December" HeaderText="Dec" DataField="December">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
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
        var elements = document.querySelectorAll(".background3ColorIE");
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

    
