<%@ control language="C#" autoeventwireup="true" inherits="Inergy.Indev3.UI.UserControls_Budget_FollowUpBudget_BudgetEvidenceButton, App_Web_2vtanlmb" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls" TagPrefix="cc2" %>

<div id ="EvidenceButton" runat="server" >
    <table cellpadding="0" cellspacing="0" border="0" >
    <tr>
        <td><cc2:IndImageButton ID="btnApprove" ToolTip="Approve" runat="server" OnClick="btnApprove_Click" ImageUrl="~/Images/button_tab_approve.png" ImageUrlOver="~/Images/button_tab_approve.png"/></td>
        <td><cc2:IndImageButton ID="btnReject" runat="server" ToolTip="Disapprove" OnClick="btnReject_Click" ImageUrl="~/Images/button_tab_reject.png" ImageUrlOver ="~/Images/button_tab_reject.png" /></td>
        <td><cc2:IndImageButton ID="btnSubmit" runat="server" ToolTip="Submit" OnClick="btnSubmit_Click" ImageUrl="~/Images/button_tab_submit.png" ImageUrlOver="~/Images/button_tab_submit.png"/></td>
    </tr>
    </table>
</div>
