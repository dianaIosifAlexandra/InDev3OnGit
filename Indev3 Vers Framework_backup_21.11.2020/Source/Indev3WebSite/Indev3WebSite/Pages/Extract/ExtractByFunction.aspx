<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" 
    CodeFile="ExtractByFunction.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_Extract_ExtractByFunction"
    Title="INDev 3" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%--<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radCb" %>--%>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>
    <table style="width: 90%; height: 110%;" class="tabbed backgroundColorIE" border="0">
        <tr>
            <td valign="top" align="center">
                <table cellpadding="5" cellspacing="0" border="0">
                    <tr>
                        <td colspan="3">
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblYear" runat="server" Text="Year:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndCatComboBox ID="cmbYear" runat="server" AutoPostBack="false" Width="200px" CheckDirty="false" AppendDataBoundItems="true"></ind:IndCatComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblIdRegion" runat="server" Text="Region Name:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndComboBox ID="cmbRegion" runat="server" Width="200px" CheckDirty="false" AutoPostBack="true" 
                                OnSelectedIndexChanged="cmbRegion_SelectedIndexChanged">
                            </ind:IndComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblCountry" runat="server" Text="Country:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndComboBox ID="cmbCountry" runat="server" AutoPostBack="true" CheckDirty="false" Width="200px"
                                OnSelectedIndexChanged="cmbCountry_SelectedIndexChanged">
                            </ind:IndComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblInergyLocation" runat="server" Text="Inergy Location:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndComboBox ID="cmbInergyLocation" runat="server" AutoPostBack="true" CheckDirty="false" Width="200px" 
                                OnSelectedIndexChanged="cmbInergyLocation_SelectedIndexChanged">
                            </ind:IndComboBox>                    
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblFunction" runat="server" Text="Function:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndComboBox ID="cmbFunction" runat="server" AutoPostBack="true" CheckDirty="false" Width="200px" 
                                OnSelectedIndexChanged="cmbFunction_SelectedIndexChanged">
                            </ind:IndComboBox>                    
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblDepartment" runat="server" Text="Department:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndComboBox ID="cmbDepartment" runat="server" AutoPostBack="true" CheckDirty="false" Width="200px" 
                                OnSelectedIndexChanged="cmbDepartment_SelectedIndexChanged">
                            </ind:IndComboBox>                    
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lbl2" Text="Extract category:" runat="server"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndCatComboBox ID="cmbSource" runat="server" CheckDirty="false" Width="200px"
                                AppendDataBoundItems="true">
                            </ind:IndCatComboBox>                    
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblCostType" Text="Cost Type:" runat="server" />
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndComboBox ID="cmbCostType" runat="server" CheckDirty="false" AutoPostBack="false" Width="115px">
                                <Items>
                                    <telerik:RadComboBoxItem ID="rciAll" runat="server" text="All" selected="true" value="A" />
                                    <telerik:RadComboBoxItem ID="rciHours" runat="server" text="Hours" value="H" />
                                    <telerik:RadComboBoxItem ID="rciSales" runat="server" text="Sales" value="S" />
                                    <telerik:RadComboBoxItem ID="rciOtherCosts" runat="server" text="On Project Costs" value="O" />
                                </Items>
                            </ind:IndComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblWPActiveStatus" runat="server" Text="Extract only WPs:"></ind:IndCatLabel>
                        </td>
                        <td align="left">
                    
                          <ind:IndComboBox ID="cmbActive" runat="server" CheckDirty="false" AutoPostBack="false"
                                Width="115px">
                                <Items>
                                    <telerik:RadComboBoxItem ID="Radcomboboxitem1" runat="server" text="Active" value="A"  >
                                    </telerik:RadComboBoxItem>
                                    <telerik:RadComboBoxItem ID="Radcomboboxitem2" runat="server" text="Inactive" value="I">
                                    </telerik:RadComboBoxItem>
                                    <telerik:RadComboBoxItem ID="Radcomboboxitem3" runat="server" selected="True" text="All" value="L">
                                    </telerik:RadComboBoxItem>
                                </Items>
                            </ind:IndComboBox>
                        </td>                
                    </tr>
                    <tr >
                        <td align="right">
                            <ind:IndCatLabel ID="lblSeparator" runat="server" Text="Separator:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndCatComboBox ID="cmbSeparator" runat="server" AutoPostBack="false" Width="115px" CheckDirty="false">
                                <Items>
                                    <telerik:RadComboBoxItem runat="server" text="Semicolon (;)" value=";"  >
                                    </telerik:RadComboBoxItem>
                                    <telerik:RadComboBoxItem runat="server" text="Comma (,)" value=",">
                                    </telerik:RadComboBoxItem>
                                </Items>
                            </ind:IndCatComboBox>
                        </td>
                    </tr>  

                    <tr>
                        <td colspan="3" align="center">
                            <asp:Button runat="server" ID="btnDownload" ToolTip="Extract" CssClass="button"
                                Text="Extract" OnClick="btnDownload_Click" />
                        </td>
                    </tr>
                 </table> 
             </td>
        </tr>
    </table>  
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
