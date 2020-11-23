<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" CodeFile="UploadInitialBudget.aspx.cs" Inherits="Pages_UploadInitialBudget_UploadInitialBudget" Title="Initial Upload" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"  TagPrefix="ind" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls" TagPrefix="cc1" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="RadUpload.Net2" Namespace="Telerik.WebControls" TagPrefix="radU" %>
<%@ Register Assembly="Inergy.Indev3.ApplicationFramework" Namespace="Inergy.Indev3.ApplicationFramework" TagPrefix="afr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ph" Runat="Server">
<script type="text/javascript">
function ValidatefilUpload(source, arguments)
{
    arguments.IsValid = GetRadUpload('<%= filUpload.ClientID %>').ValidateExtensions();
    if(!arguments.IsValid){
        HideErrorPanel();
    }
}

function checkUploadFileInput(source, arguments)   
{   
    var radUpload = <%= filUpload.ClientID %>;   
    var fileInputs = radUpload.GetFileInputs();
    if(fileInputs[0].value.length==0)
    {        
        arguments.IsValid = false;HideErrorPanel();
    } 
}  

function HideErrorPanel()
{
    try{
        var pnlErrors = "<%=((Panel)this.Page.Master.FindControl("pnlErrors")).ClientID%>";
        var pnl = document.getElementById(pnlErrors);
        pnl.style.display = "none";
     }catch(e){}
}


</script>
<script type="text/javascript">
	var clearUploadsFlag = true;

	//This function clears the file input fields of
	// the r.a.d.upload instance if the clearUploadsFlag flag is set to false
	function clearUploads()
	{
		if (clearUploadsFlag)
		{
			var radUploadId = '<%= filUpload.ClientID %>';
			var theRadUploadInstance = window[radUploadId];
			var radUploadTable = document.getElementById(radUploadId + "ListContainer");
			for (var i=0; i<radUploadTable.rows.length; i++)
			{
				theRadUploadInstance.ClearFileInputAt(i);
			}
		}
	}

	//This function changes the original form submit function
	// in order to clear the file upload input fields:
	function changeOriginalSubmit()
	{
		var theForm = document.forms[0];
		var originalSubmit = theForm.submit;
		theForm.submit = function()
		{
			clearUploads();
			this.submit = originalSubmit;
			this.submit();
		}
		if (window.attachEvent)
		{
			theForm.attachEvent("onsubmit", clearUploads);
		}
		else if (window.addEventListener)
		{
			theForm.addEventListener("submit", clearUploads, false);
		}
	}

	changeOriginalSubmit();		
</script>
<br />
 <table style="width:90%;height:110%;" class="tabbed" border="0">
<tr>
    <td valign="top" align="center">                
        <table cellpadding="5" cellspacing="0" border="0">
            <tr><td colspan="2"><br /></td></tr>
            <tr>
                <td align="right">
                    <ind:IndCatLabel ID="lblProgram" runat="server">Program:</ind:IndCatLabel>
                </td>
                <td align="left" colspan="2" style="padding-left:13px">
                    <ind:IndCatLabel ID="lblProgramName" runat="server"></ind:IndCatLabel>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <ind:IndCatLabel ID="lblProject" runat="server">Project:</ind:IndCatLabel>
                </td>
                <td align="left" colspan="2" style="padding-left:13px">
                    <ind:IndCatLabel ID="lblProjectName" runat="server"></ind:IndCatLabel>
                </td>
            </tr>
            <tr>
                <td align="right">
                      <cc1:IndLabel ID="IndLabel2" runat="server" CssClass="IndLabel">File (CSV)</cc1:IndLabel>
                      <asp:Label ID="Label1" CssClass="star" runat="Server">*</asp:Label>         
                </td>

                <td align="left">        
                    <radU:RadUpload ID="filUpload" runat="server" MaxFileInputsCount="1" AllowedFileExtensions=".csv" 
                        OverwriteExistingFiles="True" ControlObjectsVisibility="None" SkinsPath="~/Skins/RadUpload" Skin="Custom" Width="450px"  ReadOnlyFileInputs="True" LocalizationPath="../../../RadControls/Upload//Localization"/>
                              
                </td>
            </tr>
           <tr>
                <td></td>
                <td align="left" style="padding-left:20px;">            
                    <asp:CustomValidator runat="server" ID="CustomValidator1"  Display="Dynamic" ClientValidationFunction="ValidatefilUpload" ValidationGroup="Group1">
                            <div class="star">Invalid extension. Please select a .csv file!</div>
                    </asp:CustomValidator>           
                  <asp:CustomValidator runat="server" ID="CustomValidator2"  Display="Dynamic" ClientValidationFunction="checkUploadFileInput" ValidationGroup="Group1">
                            <div class="star">Please select file!</div>                
                </asp:CustomValidator>
                </td>
           </tr>
            <tr>
                <td colspan="2" >
                    <asp:Button ID="btnUpload" runat="server" Text="Upload file" CssClass="button" ValidationGroup="Group1" OnClick="btnUpload_Click" />&nbsp;
                    <asp:Button runat="server" ID="btnProcess" Enabled="false" Text="Process" CssClass="button" OnClientClick="RequestStart(null, null);" OnClick="btnProcess_Click" />
                    <asp:HiddenField ID="ProcessIdHdn" Value="0" runat="server" />
                </td>
            </tr>          
            </table>               
    </td>
</tr>
</table>
</asp:Content>

