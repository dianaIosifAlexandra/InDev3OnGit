<%@ page language="C#" masterpagefile="~/Template.master" autoeventwireup="true" inherits="Pages_AnnualBudget_AnnualDownload, App_Web_qopxteba" title="Annual Download Page" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"  TagPrefix="ind" %>
<%@ Register Assembly="Inergy.Indev3.ApplicationFramework" Namespace="Inergy.Indev3.ApplicationFramework" TagPrefix="afr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ph" Runat="Server">
<script type="text/javascript">
function ValidateComboCountry(source, arguments){
    var cCombo = <%=cmbCountry.ClientID%>;
    if(cCombo!="undefined")
        if(cCombo.GetValue()==<%= CountryDefaultValue%>)
             arguments.IsValid = false;
}

function ValidateComboYear(source, arguments){
    var cCombo = <%=cmbYear.ClientID%>;
    if(cCombo!="undefined")
        if(cCombo.GetValue()==<%= ApplicationConstants.INT_NULL_VALUE %>)
             arguments.IsValid = false;
}

</script>

<br />
 <table style="width:90%;height:110%;" class="tabbed backgroundColorIE" border="0">
       <tr>
            <td valign="top" align="center">
                
                    <table cellpadding="5" cellspacing="0" border="0"  width="100%">
                        <tr><td colspan="2"><br /></td></tr>
                        <tr>
                            <td align="right" style="width:50%"><ind:IndCatLabel ID="lblCountry" runat="server" >Country</ind:IndCatLabel><asp:Label ID="lblStar1" CssClass="star" style="margin-left:2px;" runat="Server">*</asp:Label></td>
                            <td align="left"><ind:IndCatComboBox ID="cmbCountry" runat="server" AutoPostBack="true" CheckDirty="false" Width="200px"
                                                   AppendDataBoundItems="true" OnSelectedIndexChanged="cmbCountry_SelectedIndexChanged" ValidationGroup="Group1"></ind:IndCatComboBox> </td>
                        </tr>
                        <tr>
                            <td align="right"><ind:IndCatLabel ID="lblInergyLocation" runat="server">Inergy Location</ind:IndCatLabel></td>                            
                            <td align="left">
                                <ind:IndCatComboBox ID="cmbInergyLocation" runat="server" AutoPostBack="true" CheckDirty="false" Width="200px" 
                                    OnSelectedIndexChanged="cmbInergyLocation_SelectedIndexChanged" AppendDataBoundItems="true" ValidationGroup="Group1">
                                </ind:IndCatComboBox>
                            </td>                 
                            
                        </tr>
                        <tr>
                            <td align="right"><ind:IndCatLabel ID="lblYear" runat="server">Year</ind:IndCatLabel><asp:Label ID="Label1" style="margin-left:2px;" CssClass="star" runat="Server">*</asp:Label></td>
                            <td align="left"><ind:IndCatComboBox ID="cmbYear"  runat="server" Width="200px" CheckDirty="false" AppendDataBoundItems="true" ValidationGroup="Group1"></ind:IndCatComboBox></td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center"><asp:Button runat="server" ID="btnExtract" ToolTip="Extract" CssClass="button" Text="Extract" OnClick="btnExtract_Click" ValidationGroup="Group1"/></td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <asp:CustomValidator runat="server" ID="CustomValidator2" Display="Dynamic" ClientValidationFunction="ValidateComboCountry"
                                    ValidationGroup="Group1">
                                    <div style="color:Yellow;font-family:Tahoma;font-size:12px;">Please select Country!</div>                
                                </asp:CustomValidator>
                                 <asp:CustomValidator runat="server" ID="CustomValidator1" Display="Dynamic" ClientValidationFunction="ValidateComboYear"
                                    ValidationGroup="Group1">
                                    <div style="color:Yellow;font-family:Tahoma;font-size:12px;">Please select Year!</div>                
                                </asp:CustomValidator>
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

