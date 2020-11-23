<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" 
	CodeFile="ExchangeRate.aspx.cs" Inherits="Pages_Financial_ExchangeRate" Title="Exchange Rates" %>

<%--<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>--%>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">

    <script type='text/javascript' src='../../../Scripts/GeneralScripts.js'></script>

    <asp:Panel ID="pnlExchangeRates" runat="server" CssClass="tabbed backgroundColorIE" Width="90%">
        <table width="100%" align="center">
            <tr>
                <td align="center">
                    <cc1:IndLabel ID="lblYear" runat="server" CssClass="IndLabel">Year</cc1:IndLabel>&nbsp;
                    <cc1:IndComboBox ID="cmbYear" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbYear_SelectedIndexChanged">
                    </cc1:IndComboBox>
                </td>
            </tr>        
            <tr>
                <td style="width:100%;" align="center">
                    <radG:RadGrid ID="grdExchangeRates" runat="server" AutoGenerateColumns="False" OnUpdateCommand="grdExchangeRates_UpdateCommand"
                        OnNeedDataSource="grdExchangeRates_NeedDataSource" AllowSorting="true"  SkinsPath="~/Skins/Grid" Skin="FollowUpBudget">
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        <AlternatingItemStyle HorizontalAlign="Center"></AlternatingItemStyle>
                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                        <MasterTableView EditMode="InPlace" DataKeyNames="IdCurrency">
                            <Columns>
                                <radG:GridEditCommandColumn ButtonType="ImageButton" UpdateText="Update" CancelText="Cancel"
                                    EditText="Edit" EditImageUrl="~/Skins/Grid/TimingAndInterco/Edit.gif" CancelImageUrl="~/Skins/Grid/TimingAndInterco/Cancel.gif" 
                                    UpdateImageUrl="~/Skins/Grid/TimingAndInterco/Update.gif">
                                    <ItemStyle Width="36px" />
                                </radG:GridEditCommandColumn>
                                <radG:GridBoundColumn UniqueName="Currency" HeaderText="Currency" DataField="Currency" ReadOnly="true">
                                    <ItemStyle Width="80px" Height="20px" />
                                    <HeaderStyle Width="80px" />
                                </radG:GridBoundColumn>
                                <radG:GridTemplateColumn DataField="BudgetExchangeRate" UniqueName="BudgetExchangeRate" HeaderText="Budget Rate">
                                    <EditItemTemplate>
                                        <cc1:IndTextBox runat="server" Text='<%# Bind("BudgetExchangeRate") %>' ID="indBudgetExchangeRate" Width="65px" Height="14px" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <cc1:IndLabel runat="server" Text='<%# Bind("BudgetExchangeRate") %>' CssClass="RadGrid_FollowUpBudget" ID="txtAvgYear" />
                                    </ItemTemplate>
                                    <ItemStyle Width="80px" Height="20px" />
                                </radG:GridTemplateColumn>
                                <radG:GridBoundColumn UniqueName="January" HeaderText="Jan" DataField="January"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="February" HeaderText="Feb" DataField="February"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="March" HeaderText="Mar" DataField="March"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="April" HeaderText="Apr" DataField="April"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="May" HeaderText="May" DataField="May"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="June" HeaderText="Jun" DataField="June"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="July" HeaderText="Jul" DataField="July"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="August" HeaderText="Aug" DataField="August"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="September" HeaderText="Sep" DataField="September"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="October" HeaderText="Oct" DataField="October"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="November" HeaderText="Nov" DataField="November"  ReadOnly="true">
                                    <ItemStyle Width="60px" Height="20px" />
                                    <HeaderStyle Width="60px" />
                                </radG:GridBoundColumn>
                                <radG:GridBoundColumn UniqueName="December" HeaderText="Dec" DataField="December"  ReadOnly="true">
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
    <asp:HiddenField ID="hdnIsDirty" Value="0" runat="server" />
<%--    <asp:Button ID="btnDoPostback" runat="server" OnClick="btnDoPostback_Click" Text="Button" Visible="false" />--%>
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

    
