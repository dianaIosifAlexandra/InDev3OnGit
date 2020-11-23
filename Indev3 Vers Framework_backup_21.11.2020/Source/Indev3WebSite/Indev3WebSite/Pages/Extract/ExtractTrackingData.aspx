<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" 
CodeFile="ExtractTrackingData.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_Extract_ExtractTrackingData" Title="INDev 3" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls" TagPrefix="ind" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%--<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radCb" %>--%>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
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
                            <ind:IndCatComboBox ID="cmbYear" runat="server" AutoPostBack="false" Width="300px" CheckDirty="false" AppendDataBoundItems="true"></ind:IndCatComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblProgram" runat="server" Text="Program:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndComboBox ID="cmbProgram" runat="server" Width="300px" CheckDirty="false"  OnSelectedIndexChanged="cmbProgram_SelectedIndexChanged" AutoPostBack="True"></ind:IndComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblProject" runat="server" Text="Project:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndComboBox ID="cmbProject" runat="server" Width="300px" CheckDirty="false" OnSelectedIndexChanged="cmbProject_SelectedIndexChanged" AutoPostBack="True"></ind:IndComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblRole" runat="server" Text="Role:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndCatComboBox ID="cmbRole" runat="server" AutoPostBack="false" Width="300px" CheckDirty="false">
                                <Items>
                                    <telerik:radcomboboxitem runat="server" text="" value="-1"></telerik:radcomboboxitem>
                                    <telerik:radcomboboxitem runat="server" text="Business Administrator" value="1"></telerik:radcomboboxitem>
                                    <telerik:radcomboboxitem runat="server" text="Key User" value="8"></telerik:radcomboboxitem>
                                </Items>
                            </ind:IndCatComboBox>
                        </td>
                    </tr>
                    <tr >
                        <td align="right">
                            <ind:IndCatLabel ID="lblSeparator" runat="server" Text="Separator:"></ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndCatComboBox ID="cmbSeparator" runat="server" AutoPostBack="false" Width="300" CheckDirty="false">
                                <Items>
                                    <telerik:radcomboboxitem runat="server" text="Semicolon (;)" value=";"  >
                                    </telerik:radcomboboxitem>
                                    <telerik:radcomboboxitem runat="server" text="Comma (,)" value=",">
                                    </telerik:radcomboboxitem>
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

</script>
  
</asp:Content>