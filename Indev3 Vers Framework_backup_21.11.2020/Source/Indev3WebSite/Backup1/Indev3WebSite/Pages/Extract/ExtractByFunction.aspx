<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" 
    CodeFile="ExtractByFunction.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_Extract_ExtractByFunction"
    Title="INDev 3" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radCb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <table style="width: 90%; height: 110%;" class="tabbed" border="0">
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
                                    <radCb:RadComboBoxItem ID="rciAll" runat="server" text="All" selected="true" value="A" />
                                    <radCb:RadComboBoxItem ID="rciHours" runat="server" text="Hours" value="H" />
                                    <radCb:RadComboBoxItem ID="rciSales" runat="server" text="Sales" value="S" />
                                    <radCb:RadComboBoxItem ID="rciOtherCosts" runat="server" text="On Project Costs" value="O" />
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
                                    <radCb:radcomboboxitem ID="Radcomboboxitem1" runat="server" text="Active" value="A"  >
                                    </radCb:radcomboboxitem>
                                    <radCb:radcomboboxitem ID="Radcomboboxitem2" runat="server" text="Inactive" value="I">
                                    </radCb:radcomboboxitem>
                                    <radCb:radcomboboxitem ID="Radcomboboxitem3" runat="server" selected="True" text="All" value="L">
                                    </radCb:radcomboboxitem>
                                </Items>
                            </ind:IndComboBox>
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
    
     
</asp:Content>
