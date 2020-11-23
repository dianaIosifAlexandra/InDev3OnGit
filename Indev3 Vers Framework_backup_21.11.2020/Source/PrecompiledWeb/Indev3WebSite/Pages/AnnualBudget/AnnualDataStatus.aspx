<%@ page language="C#" masterpagefile="~/Template.master" autoeventwireup="true" inherits="Pages_AnnualBudget_AnnualDataStatus, App_Web_qopxteba" title="Data Status" %>

<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radC" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <asp:HiddenField ID="hdnRemoveAnnualBudget" runat="server" />

    <asp:Panel ID="pnlDataStatus" runat="server" CssClass="Tabbed" Width="90%">
    
        <table class="tabbed backgroundColorIE">
            <tr>
                <td style="width:100%;">
                    <radG:RadGrid ID="grdDataStatus" runat="server" SkinsPath="~/Skins/Grid" 
                        Skin="TimingAndInterco" HorizontalAlign="Center" 
                        OnNeedDataSource="grdDataStatus_NeedDataSource">
                        <MasterTableView AutoGenerateColumns="false">
                            <Columns>
                                <radG:GridBoundColumn UniqueName="Country" DataField="Country">
                                    <ItemStyle Width="100px" />
                                    <HeaderStyle Width="100px" />
                                </radG:GridBoundColumn>
                            </Columns>
                        </MasterTableView>
                    </radG:RadGrid>
                </td>
            </tr>
        </table>
    </asp:Panel>

<script type="text/javascript">
    function SetHiddenField(trueOrfalse, commandArgument) {
        var elements = document.querySelectorAll("input[type=hidden]");
        if (elements != null) {
            for (var i = 0; i < elements.length; i++) {
                if (elements[i].id.indexOf("hdnRemoveAnnualBudget") > 0) {
                    if (trueOrfalse) elements[i].value = commandArgument;
                }
            }
        }
    }

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
        var ieDocumentMode = document.documentMode;
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

