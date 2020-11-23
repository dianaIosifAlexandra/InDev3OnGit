<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CopyCoreTeam.aspx.cs" Inherits="UserControls_Budget_ProjectCopyCoreTeam_CopyCoreTeam" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls" TagPrefix="ind" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Copy Core Team</title>
    <base target="_self" />
    <link href="../../../Styles/WebControls.css" rel="stylesheet" type="text/css" />
    <link href="../../../Styles/Grid.css" rel="stylesheet" type="text/css" />
</head>

<script type='text/javascript' src='../../../Scripts/PopUpScripts.js'></script>
<script type='text/javascript' src='../../../Scripts/GridScripts.js'></script>

<body style="background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom;" onload="SetPopUpHeight(); SetColorDependingOnIE();" class="backgroundColorIE">
    <form id="form1" runat="server">
		<table style="width: 100%; height:auto" border="0">
			<tr><td>&nbsp;</td></tr>
		    <tr>
				<td valign="top" colspan="3" align="center">
					<asp:Label ID="lblStatus" runat="server" CssClass="Warning" Text="" Width="100%"></asp:Label>
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="3">
					<radG:RadGrid ID="grdCopyCoreTeam" HorizontalAlign="center" runat="server" AutoGenerateColumns="False"
						GridLines="None" SkinsPath="~/Skins/Grid" Skin="FollowUpBudget" EnableOutsideScripts="True"	AllowPaging="false">
						<MasterTableView DataKeyNames="" ShowFooter="false" BorderWidth="0">
							<Columns>
								<radG:GridTemplateColumn UniqueName="SelectProjectCol">
									<ItemTemplate>
										<asp:CheckBox runat="server" ID="chkSelectProject" />
									</ItemTemplate>
								</radG:GridTemplateColumn>
								<radG:GridBoundColumn UniqueName="IdProject" DataField="IdProject" Display="false">
								</radG:GridBoundColumn>
								<radG:GridBoundColumn HeaderText="Project Code" UniqueName="ProjectCode" DataField="ProjectCode">
									<ItemStyle Width="100px" HorizontalAlign="left" />
									<HeaderStyle Width="100px" HorizontalAlign="left" />
								</radG:GridBoundColumn>
								<radG:GridBoundColumn HeaderText="Project Name" UniqueName="ProjectName" DataField="ProjectName">
									<ItemStyle Width="300px" HorizontalAlign="left" />
									<HeaderStyle Width="300px" HorizontalAlign="left" />
								</radG:GridBoundColumn>
								<radG:GridBoundColumn HeaderText="Team Members" UniqueName="TeamMembers" DataField="TeamMembers">
									<ItemStyle Width="100px" HorizontalAlign="left" />
									<HeaderStyle Width="100px" HorizontalAlign="left" />
								</radG:GridBoundColumn>   
							</Columns>
						</MasterTableView>
					</radG:RadGrid>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="left" style="width: 33%">&nbsp;</td>
				<td align="center" style="width: 34%">
					<ind:IndImageButton ID="btnCopyCoreTeam" runat="server" OnClick="btnCopyCoreTeam_Click" ImageUrl="~/Images/button_save.png"
						ImageUrlOver="~/Images/button_save.png" ToolTip="Copy Core Team" 
						OnClientClick="if (CheckBoxesSelected()) {if(!confirm('Any team already defined on the target project(s) will be overridden. Do you confirm?'))return false;}else {alert('Select at least one target project!');return false;}" />
					<ind:IndImageButton runat="server" ID="btnCloseWindow" ToolTip="Close Window" OnClientClick="window.close();" 
						ImageUrl="../../../Images/button_cancel.png" ImageUrlOver="../../../Images/button_cancel.png" />
				</td>
				<td style="width: 33%">&nbsp;</td>
			</tr>
		</table>
    </form>
</body>
</html>

