<%@ page language="C#" masterpagefile="~/Template.master" autoeventwireup="true" inherits="Inergy.Indev3.UI.Pages_Extract_Extract, App_Web_rzrjdajc" title="INDev 3" %>

<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="RadComboBox.Net2" Namespace="Telerik.WebControls" TagPrefix="radCb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <table style="width: 90%; height: 110%;" class="tabbed backgroundColorIE" border="0">
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
                        AutoPostBack="true" OnSelectedIndexChanged="cmbSource_SelectedIndexChanged" OnClientSelectedIndexChanged="cmbSourceSelectedIndexChanged">
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
            <tr id="trCmbYear" runat="server" class="trCmbYear" style="display:none">
                <td align="right">
                    <ind:IndCatLabel ID="lblYear" runat="server" Text="Year:"></ind:IndCatLabel>
                </td>
                <td align="left" colspan="2">
                    <ind:IndCatComboBox ID="cmbYear" runat="server" AutoPostBack="false" Width="150px" CheckDirty="false" AppendDataBoundItems="true"></ind:IndCatComboBox>
                </td>
            </tr>            
            <tr >
                <td align="right">
                    <ind:IndCatLabel ID="lblSeparator" runat="server" Text="Separator:"></ind:IndCatLabel>
                </td>
                <td align="left">
                    <ind:IndCatComboBox ID="cmbSeparator" runat="server" AutoPostBack="false" Width="115px" CheckDirty="false">
                        <Items>
                            <radCb:radcomboboxitem runat="server" text="Semicolon (;)" value=";"  >
                            </radCb:radcomboboxitem>
                            <radCb:radcomboboxitem runat="server" text="Comma (,)" value=",">
                            </radCb:radcomboboxitem>
                        </Items>
                    </ind:IndCatComboBox>
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

    function cmbSourceSelectedIndexChanged(source, event) {
        var elements2 = document.querySelectorAll(".trCmbYear");
        if (elements2.length > 0)
        {
            var tr = elements2[0];
            var cmbSourceId = tr.id.replace("trCmbYear","cmbSource")+"_c4"; //combo telerik is using some div. We are searching for the 4th one

            var divAnnual = document.getElementById(cmbSourceId);
            if (divAnnual != null)
            {
                var s = divAnnual.innerText;
                if (s.trim() == "annual budget")
                {
                    tr.style.display = "block";
                }
                else
                {
                    tr.style.display = "none";
                }
            }
        }
    }

</script>

</asp:Content>
