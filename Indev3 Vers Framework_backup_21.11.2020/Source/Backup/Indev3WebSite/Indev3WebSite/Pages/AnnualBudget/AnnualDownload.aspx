<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" CodeFile="AnnualDownload.aspx.cs" Inherits="Pages_AnnualBudget_AnnualDownload" Title="Annual Download Page" %>
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
 <table style="width:90%;height:110%;" class="tabbed" border="0">
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
                            <td colspan="2"><asp:Button runat="server" ID="btnExtract" ToolTip="Extract" CssClass="button" Text="Extract" OnClick="btnExtract_Click" ValidationGroup="Group1"/></td>
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
</asp:Content>

