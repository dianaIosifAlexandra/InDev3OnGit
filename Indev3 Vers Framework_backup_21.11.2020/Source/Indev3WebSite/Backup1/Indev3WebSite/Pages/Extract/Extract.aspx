<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true"
    CodeFile="Extract.aspx.cs" Inherits="Inergy.Indev3.UI.Pages_Extract_Extract"
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
                            <ind:IndCatLabel ID="lblProgram" runat="server">Program:</ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndCatLabel ID="lblProgramName" runat="server"></ind:IndCatLabel>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <ind:IndCatLabel ID="lblProject" runat="server">Project:</ind:IndCatLabel>
                        </td>
                        <td align="left" colspan="2">
                            <ind:IndCatLabel ID="lblProjectName" runat="server"></ind:IndCatLabel>
                        </td>
            </tr>
            <tr>
                <td align="right" style="width: 40%">
                    <ind:IndCatLabel ID="lbl1" Text="Extract level:" runat="server"></ind:IndCatLabel>
                </td>
                <td align="left" colspan="2">
                    <ind:IndCatComboBox ID="cmbType" runat="server" AutoPostBack="true" CheckDirty="false"
                        Width="115px"  OnSelectedIndexChanged="cmbType_SelectedIndexChanged">
                    </ind:IndCatComboBox>
                </td>
            </tr>

            <tr>
                <td align="right">
                    <ind:IndCatLabel ID="lbl2" Text="Extract category:" runat="server"></ind:IndCatLabel>
                </td>
                <td align="left">
                    <ind:IndCatComboBox ID="cmbSource" runat="server" CheckDirty="false" Width="115px"
                        AutoPostBack="true" OnSelectedIndexChanged="cmbSource_SelectedIndexChanged">
                    </ind:IndCatComboBox>                    
                </td>
                <td style="width:250px;"  align="left">
                    <ind:IndCatLabel ID="lblCurrentVersion" runat="server"></ind:IndCatLabel><ind:IndCatLabel ID="lblVersion" runat="server" Text="Version number: "></ind:IndCatLabel><ind:IndCatComboBox ID="cmbVersion" runat="server" AutoPostBack="false" Width="40px" CheckDirty="false" AppendDataBoundItems="true"></ind:IndCatComboBox>
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
                            <radCb:radcomboboxitem runat="server" text="Active" value="A"  >
                            </radCb:radcomboboxitem>
                            <radCb:radcomboboxitem runat="server" text="Inactive" value="I">
                            </radCb:radcomboboxitem>
                            <radCb:radcomboboxitem runat="server" selected="True" text="All" value="L">
                            </radCb:radcomboboxitem>
                        </Items>
                    </ind:IndComboBox>
                </td>                
            </tr>
            <tr >
                <td align="right">
                    <ind:IndCatLabel ID="lblYear" runat="server" Text="Year:"></ind:IndCatLabel>
                </td>
                <td align="left" colspan="2">
                    <ind:IndCatComboBox ID="cmbYear" runat="server" AutoPostBack="false" Width="115px" CheckDirty="false" AppendDataBoundItems="true"></ind:IndCatComboBox>
                </td>
            </tr>            
            <tr>
                <td>
                   <br />
                </td>
                <td align="left">
                    <asp:Button runat="server" ID="btnDownload" ToolTip="Extract" CssClass="button"
                        Text="Extract" OnClick="btnDownload_Click" />
                </td>
                <td>
                   <br />
                </td>
            </tr>
            </table> </td>
        </tr>
    </table>    
</asp:Content>
