<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Upload.ascx.cs" Inherits="Inergy.Indev3.UI.UserControls_DataUpload_Upload_Upload" %>
<%@ Register Assembly="RadUpload.Net2" Namespace="Telerik.WebControls" TagPrefix="radU" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>

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
	
	function checkFileExistence(source, arguments)
	{
	    var j=0;
	    var radUpload = <%= filUpload.ClientID %>;   
        var fileInputs = radUpload.GetFileInputs();
        var fileUpload = fileInputs[0].value;       
        var pos = fileUpload.lastIndexOf("\\");
        if(pos>0)
        {
           fileUpload = fileUpload.slice(pos+1); 
           var table = document.getElementById('<%= grdProcessInformation.ClientID%>');
            var cells = table.getElementsByTagName("td"); 
            var fileInputs = radUpload.GetFileInputs();
            for (var i = 0; i < cells.length; i++)
            { 
                var filename = cells[i].innerHTML;                
                if(fileUpload == filename)
                 {j++;}
            }    
        }        
        if(j>0)
            if(!confirm("File already uploaded. Overwrite?")) arguments.IsValid = false;
	}
	
</script>

<div id="divupload">
    <table cellpadding="2" cellspacing="2" border="0" width="90%" class="tabbed">
        <tr>
            <td align="right" style="width: 40%">
                <cc1:IndLabel ID="IndLabel5" runat="server" CssClass="IndLabel" Width="172px">Period</cc1:IndLabel>
                <asp:Label ID="lblStar1" CssClass="star" runat="Server">*</asp:Label>
            </td>
            <td align="left" style="padding-left: 13px;">
                <cc1:IndYearMonth ID="dtStartDate" runat="server" Width="199px" CheckDirty="true" />
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc1:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel" Width="172px">File Type</cc1:IndLabel>
                <asp:Label ID="Label1" CssClass="star" runat="Server">*</asp:Label>
            </td>
            <td align="left" style="padding-left: 13px;">
                <cc1:IndComboBox ID="cmbFileType" runat="server" Width="132px" />
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc1:IndLabel ID="IndLabel2" runat="server" CssClass="IndLabel" Width="172px">File (CSV)</cc1:IndLabel>
                <asp:Label ID="Label2" CssClass="star" runat="Server">*</asp:Label>
            </td>
            <td align="left">
                <radU:RadUpload ID="filUpload" runat="server" MaxFileInputsCount="1" AllowedFileExtensions=".csv"
                    OverwriteExistingFiles="True" ControlObjectsVisibility="None" SkinsPath="~/Skins/RadUpload"
                    Skin="Custom" Width="450px" ReadOnlyFileInputs="True" LocalizationPath="../../../RadControls/Upload//Localization" />
                <asp:CustomValidator runat="server" ID="CustomValidator1" Display="Dynamic" ClientValidationFunction="ValidatefilUpload"
                    ValidationGroup="Group1">
                    <div style="color:Yellow;font-family:Tahoma;font-size:11px;">Invalid extension. Please select a CSV file.</div>
                </asp:CustomValidator>
                <asp:CustomValidator runat="server" ID="CustomValidator2" Display="Dynamic" ClientValidationFunction="checkUploadFileInput"
                    ValidationGroup="Group1">
                    <div style="color:Yellow;font-family:Tahoma;font-size:11px;">File (CSV) is required.</div>                
                </asp:CustomValidator>
                <asp:CustomValidator runat="server" ID="CustomValidator3" Display="Dynamic" ClientValidationFunction="checkFileExistence"
                    ValidationGroup="Group1"></asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="btnUpload" runat="server" Text="Upload file" CssClass="button" ValidationGroup="Group1"
                    OnClick="btnUpload_Click" />
            </td>
        </tr>
        <tr>
            <td valign="middle" colspan="2">
                <radG:RadGrid ID="grdProcessInformation" HorizontalAlign="center" runat="server"
                    AutoGenerateColumns="False" GridLines="None" SkinsPath="~/Skins/Grid" Skin="TimingAndInterco"
                    EnableOutsideScripts="True" AllowPaging="false">
                    <MasterTableView DataKeyNames="" ShowFooter="true" BorderWidth="0">
                        <Columns>
                            <radG:GridBoundColumn UniqueName="Date" HeaderText="Date" DataField="DataUpload"
                                FilterImageUrl="~/Skins/Grid/Budget/Filter.gif" SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif"
                                SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif" ReadOnly="True" DataFormatString="{0:dd/MM/yyyy}">
                                <ItemStyle Width="100px" />
                                <HeaderStyle Width="100px" />
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn UniqueName="InProcessFileName" HeaderText="In Process file name"
                                DataField="FileName" FilterImageUrl="~/Skins/Grid/Budget/Filter.gif" SortAscImageUrl="~/Skins/Grid/Budget/SortAsc.gif"
                                SortDescImageUrl="~/Skins/Grid/Budget/SortDesc.gif" ReadOnly="True">
                                <ItemStyle Width="350px" />
                                <HeaderStyle Width="350px" />
                            </radG:GridBoundColumn>
                            <radG:GridBoundColumn UniqueName="InProcessRealFileName" HeaderText="RealFileName"
                                DataField="RealFileName" Display="false">
                                <ItemStyle Width="0" CssClass="GridElements_TimingAndInterco_Hide"/>
                                <HeaderStyle Width="0" CssClass="GridElements_TimingAndInterco_Hide"/>
                            </radG:GridBoundColumn>
                        </Columns>
                        <FooterStyle Height="25px" />
                    </MasterTableView>
                </radG:RadGrid>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button runat="server" ID="btnProcess" Text="Process" CssClass="button" OnClientClick="RequestStart(null, null)" OnClick="btnProcess_Click" /></td>
        </tr>
    </table>
</div>
