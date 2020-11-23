<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AnnualDataLogsDetail.aspx.cs" Inherits="Pages_AnnualBudget_AnnualDataLogsDetail" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Data Logs Detail</title>
    <base target="_self" />
    <link href="../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Grid.css" rel="stylesheet" type="text/css" />
</head>
<script type='text/javascript' src="../../Scripts/DataGridScripts.js"></script>
<script type='text/javascript' src="../../Scripts/PopUpScripts.js"></script>
<script type='text/javascript' src="../../Scripts/NumberRepresentation.js"></script>
<script type='text/javascript' src="../../Scripts/GeneralScripts.js"></script>

<body style="background: #626262 url('../../Images/back_popup.png') no-repeat right bottom;"
    onload="SetPopUpHeight(); SetColorDependingOnIE(); " class="backgroundColorIE">
    <form id="form1" runat="server">
    <asp:Panel ID="pnlImportDetails" runat="server">
        <table cellspacing="5px" width="100%">
            <tr>
                <td align="center">
                    <div>
                        <table style="border:solid 1px orange;width:100%" border="0">
                            <tr align="left">
                                <td style="width: 100px">
                                    <cc1:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel">Country</cc1:IndLabel></td>
                                <td style="width: 350px">
                                    <cc1:IndLabel ID="txtCountry" runat="server" CssClass="IndLabel">Label</cc1:IndLabel></td>
                                <td style="width: 200px">
                                    <cc1:IndLabel ID="IndLabel4" runat="server" CssClass="IndLabel">Period</cc1:IndLabel></td>
                                <td style="width: 200px">
                                    <cc1:IndLabel ID="txtPeriod" runat="server" CssClass="IndLabel">Label</cc1:IndLabel>
                                </td>
                                <td style="width: 270px">
                                    <cc1:IndLabel ID="IndLabel18" runat="server" CssClass="IndLabel">Number of rows ignored</cc1:IndLabel>
                                </td>
                                <td style="width: 250px">
                                    <cc1:IndLabel ID="txtNoOfRowsIgnored" runat="server" CssClass="IndLabel">Label</cc1:IndLabel>
                                 </td>
                              
                            </tr>
                            <tr align="left">                                
                                <td style="width: 100px">
                                    <cc1:IndLabel ID="IndLabel5" runat="server" CssClass="IndLabel">User name</cc1:IndLabel>
                                </td>
                                <td style="width: 350px">
                                    <cc1:IndLabel ID="txtUserName" runat="server" CssClass="IndLabel">Label</cc1:IndLabel>
                                </td>
                                 <td style="width: 200px">
                                    <cc1:IndLabel ID="IndLabel3" runat="server" CssClass="IndLabel">Date</cc1:IndLabel>
                                  </td>
                                <td style="width: 200px">
                                    <cc1:IndLabel ID="txtDate" runat="server" CssClass="IndLabel">Label</cc1:IndLabel>
                                 </td>
                                 <td style="width: 250px">
                                    <cc1:IndLabel ID="IndLabel10" runat="server" CssClass="IndLabel">Number of rows OK</cc1:IndLabel>
                                 </td>
                                <td>
                                    <cc1:IndLabel ID="txtNoOfRowsOK" runat="server" CssClass="IndLabel">Label</cc1:IndLabel>
                                </td>                               
                            </tr>
                            <tr align="left">
                                <td style="width: 100px">
                                    <cc1:IndLabel ID="IndLabel2" runat="server" CssClass="IndLabel">File name</cc1:IndLabel></td>
                                <td style="width: 350px">
                                    <cc1:IndLabel ID="txtFileName" runat="server" CssClass="IndLabel">Label</cc1:IndLabel>
                                 </td>
                                 <td style="width: 200px">
                                    <cc1:IndLabel ID="IndLabel12" runat="server" CssClass="IndLabel">Number of errors</cc1:IndLabel>
                                 </td>
                                <td style="width: 200px">
                                    <cc1:IndLabel ID="txtNoOfErrors" runat="server" CssClass="IndLabel">Label</cc1:IndLabel>
                                 </td>
                                  <td style="width: 150px">
                                    <cc1:IndLabel ID="IndLabel6" runat="server" CssClass="IndLabel">Total number of rows</cc1:IndLabel>
                                 </td>
                                <td>
                                    <cc1:IndLabel ID="txtLines" runat="server" CssClass="IndLabel">Label</cc1:IndLabel>
                                 </td> 
                            </tr>
                            
                           
                        </table>
                    </div>
                </td>
            </tr>           
            <tr>
                <td align="center">
                    <table>
                        <tr>
                            <td>
                                <radG:RadGrid ID="grdImportDetails" runat="server" SkinsPath="~/Skins/Grid" Skin="FollowUpBudget"
                                EnableOutsideScripts="True" AllowPaging="true" AllowCustomPaging="false" AllowMultiRowEdit="true"
                                PageSize="8" OnItemCommand="grdImportDetails_ItemCommand" OnItemCreated="grdImportDetails_ItemCreated">
                                <PagerStyle Visible="False" />
                                <MasterTableView EditMode="InPlace" AutoGenerateColumns="False" TableLayout="Auto"
                                    CommandItemDisplay="Bottom">
                                    <Columns>
                                        <radG:GridBoundColumn UniqueName="Row Number" DataField="IdRow" ReadOnly="true">
                                           <HeaderStyle Width="40px" HorizontalAlign="center" />
                                            <ItemStyle Width="40px" HorizontalAlign="center"/>
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn UniqueName="CostCenter" DataField="CostCenter" HeaderText="Cost Center" MaxLength="15">
                                            <HeaderStyle Width="65px" HorizontalAlign="center"/>
                                            <ItemStyle Width="65px" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn UniqueName="ProjectCode" DataField="ProjectCode" HeaderText="Project Code" MaxLength="10">
                                            <HeaderStyle Width="70px" HorizontalAlign="center"/>
                                            <ItemStyle Width="70px" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn UniqueName="WPCode" DataField="WPCode" HeaderText="WP Code" MaxLength="3">
                                            <HeaderStyle Width="40px" HorizontalAlign="center"/>
                                            <ItemStyle Width="40px" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn UniqueName="AccountNumber" DataField="AccountNumber" HeaderText="Account Number" MaxLength="20">
                                            <HeaderStyle Width="90px" HorizontalAlign="center"/>
                                            <ItemStyle Width="90px" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn UniqueName="Quantity" DataField="Quantity" HeaderText="Quantity">
                                            <HeaderStyle Width="70px" HorizontalAlign="center"/>
                                            <ItemStyle Width="70px" />
                                        </radG:GridBoundColumn>                                       
                                        <radG:GridBoundColumn UniqueName="Value" DataField="Value" HeaderText="Value">
                                            <HeaderStyle Width="50px" HorizontalAlign="center"/>
                                            <ItemStyle Width="50px" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn UniqueName="CurrencyCode" DataField="CurrencyCode" HeaderText="Currency Code" MaxLength="3">
                                            <HeaderStyle Width="50px" HorizontalAlign="center"/>
                                            <ItemStyle Width="50px" />
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn UniqueName="RowErrors" DataField="RowErrors" HeaderText="Errors" ReadOnly="true">
                                            <HeaderStyle Width="300px" HorizontalAlign="center" />
                                            <ItemStyle Width="300px" Font-Names="Trebuchet" Font-Size="10px" HorizontalAlign="left"/>
                                        </radG:GridBoundColumn>                                        
                                        <radG:GridBoundColumn UniqueName="IdImport" DataField="IdImport" HeaderText="IdImport"
                                            Display="False">
                                        </radG:GridBoundColumn>
                                        <radG:GridBoundColumn Display="False" UniqueName="IdRow" DataField="IdRow" HeaderText="IdRow">
                                        </radG:GridBoundColumn>                                      
                                      
                                    </Columns>
                                    <ExpandCollapseColumn Visible="False">
                                    </ExpandCollapseColumn>
                                    <RowIndicatorColumn Visible="False">
                                    </RowIndicatorColumn>
                                    <PagerStyle HorizontalAlign="center" Mode="NextPrevNumericAndAdvanced" CssClass="CustomGridPager"/>
                                    <CommandItemTemplate>
                                        <asp:Button runat="server" ID="UpdateAllRecords" Enabled="<%#CreateNewImportFileButtonEnable%>" Text="Create the new import file and go to process" CommandName="UpdateAll" />                                         
                                    </CommandItemTemplate>                                  
                                </MasterTableView>
                                <ClientSettings>
                                    <Resizing AllowColumnResize="true" />
                                </ClientSettings>
                            </radG:RadGrid>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
             <tr>
                <td align="center">                   
                    <asp:Button runat="server" Text="Close Window" ID="btnCloseWindow" OnClientClick="window.close();" />
                </td>
        </table>
        </asp:Panel>
        <radA:RadAjaxManager ID="RadAjaxManager1" runat="server" EnableOutsideScripts="True">
            <AjaxSettings>
                <radA:AjaxSetting AjaxControlID="pnlImportDetails">
                    <UpdatedControls>
                        <radA:AjaxUpdatedControl ControlID="pnlErrors" />
                        <radA:AjaxUpdatedControl ControlID="pnlImportDetails" />
                    </UpdatedControls>
                </radA:AjaxSetting>                
            </AjaxSettings>
        </radA:RadAjaxManager>
    </form>
</body>
</html>

