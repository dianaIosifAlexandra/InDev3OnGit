<%@ control language="C#" autoeventwireup="true" inherits="UserControls_Budget_ProjectCoreTeamMember_ProjectCoreTeamMemberView, App_Web_x2wxkadj" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc1" %>
<table cellpadding="0" cellspacing="0" border="0" align="center">
    <tr>
        <td>  
            <cc1:genericviewcontrol id="ProjectCoreTeamMemberViewControl" runat="server" DataSourcePersistent="False"></cc1:genericviewcontrol>
        </td>
    </tr>
	<tr><td><br /></td></tr>
    <tr>
		<td>
			<asp:Button runat="server" Text="Copy Core Team" ID="btnOpenPopupCopyCoreTeam" Visible="false" />
		</td>
    </tr>
</table>     
