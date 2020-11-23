﻿<%@ page language="C#" autoeventwireup="true" masterpagefile="~/Template.master" inherits="TestGrid, App_Web_zu4hwgzb" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<%@ Register Assembly="RadGrid.Net2" Namespace="Telerik.WebControls" TagPrefix="radG" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls" TagPrefix="ind" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ph" runat="Server">
    <script type='text/javascript' src='Scripts/GeneralScripts.js'></script>

    <script language="JavaScript" type='text/javascript'>
    var needToConfirm = true;

    window.onbeforeunload = confirmExit;

    function confirmExit()
    {
        if (needToConfirm)
        {
            var inputs = document.getElementsByTagName('input');
            for(var i=0; i<inputs.length; i++)
            {
                if (inputs[i].getAttribute('type') == 'text')
                {
                    var txtDetail = inputs[i];
                    if ((txtDetail.name.indexOf("grd") > 0) && (txtDetail.disabled == false))
                    {
                        needToConfirm = false;
                        setTimeout("enableCheck()", "100");
                        return "There is at least one Budget Exchange Rate in edit mode.";
                    }
                }
            }
            var txtIsDirty = document.getElementById("ctl00_ph_hdnIsDirty");
            if (txtIsDirty.value == "1")
            {
                needToConfirm = false;
                setTimeout("enableCheck()", "100");
                return "There are unsaved changes on this page.";
            }
        }
    }
      
    function enableCheck()
    {
        needToConfirm = true;
    }
         
    function ConfirmYearChanged(sender, eventArgs)
    {
        needToConfirm = false;
        var inputs = document.getElementsByTagName('input');
        for(var i=0; i<inputs.length; i++)
        {
            if (inputs[i].getAttribute('type') == 'text')
            {
                var txtDetail = inputs[i];
                if ((txtDetail.name.indexOf("grd") > 0) && (txtDetail.disabled == false))
                {
                    var leavePage = confirm("Are you sure you want to navigate away from this page? \r\n\r\nThere is at least one Budget Exchange Rate in edit mode.\r\n\r\nPress OK to continue, or cancel to stay on the current page.");
                    if (!leavePage)
                        return false;
                    else
                    {
                        needToConfirm = false;
                        return true;
                    }
                }
            }
        }
        return true;
    }
      
          
    function ClearDirty()
    {
        var txtIsDirty = document.getElementById("ctl00_ph_hdnIsDirty");
        txtIsDirty.value = "0";
    }
      
    function CheckForEditedWPs() 
    {
        var inputs = document.getElementsByTagName('input');
        for(var i=0; i<inputs.length; i++)
        {
            if (inputs[i].getAttribute('type') == 'text')
            {
                var txtDetail = inputs[i];
                if ((txtDetail.name.indexOf("grd") > 0) && (txtDetail.disabled == false))
                {
                    return true;
                }
            }
        }
        var txtIsDirty = document.getElementById("ctl00_ph_hdnIsDirty");
        if (txtIsDirty.value == "1")
        {
            return true;
        }
        return false;
    }
  
    </script>

    <asp:Panel ID="pnlExchangeRates" runat="server" CssClass="tabbed" Width="90%">
    <br />
        <table width="100%">
            <tr>
                <td>
                    <ind:IndLabel ID="lblYear" runat="server" CssClass="IndLabel">Year</ind:IndLabel>&nbsp;
                    <ind:IndComboBox ID="cmbYear" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbYear_SelectedIndexChanged">
                    </ind:IndComboBox>
                </td>
            </tr>        
            <tr>
                <td style="width:100%">
        <radG:RadGrid ID="RadGrid1" runat="server" AutoGenerateColumns="False" OnUpdateCommand="RadGrid1_UpdateCommand"
            OnNeedDataSource="RadGrid1_NeedDataSource" AllowSorting="true"  SkinsPath="~/Skins/Grid" Skin="FollowUpBudget">
            <ItemStyle HorizontalAlign="Center"></ItemStyle>
            <AlternatingItemStyle HorizontalAlign="Center"></AlternatingItemStyle>
            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
            <MasterTableView EditMode="InPlace" DataKeyNames="IdCurrency">
                <Columns>
                    <radG:GridEditCommandColumn ButtonType="ImageButton" UpdateText="Update" CancelText="Cancel"
                        EditText="Edit" EditImageUrl="~/Skins/Grid/TimingAndInterco/Edit.gif" CancelImageUrl="~/Skins/Grid/TimingAndInterco/Cancel.gif" 
                        UpdateImageUrl="~/Skins/Grid/TimingAndInterco/Update.gif">
                        <ItemStyle Width="35px" />
                    </radG:GridEditCommandColumn>
                    <radG:GridBoundColumn UniqueName="Currency" HeaderText="Currency" DataField="Currency" ReadOnly="true">
                        <ItemStyle Width="80px" Height="20px" />
                        <HeaderStyle Width="80px" />
                    </radG:GridBoundColumn>
                    <radG:GridTemplateColumn DataField="AvgYear" UniqueName="AvgYear" HeaderText="Avg Year">
                        <EditItemTemplate>
                            <ind:IndTextBox runat="server" Text='<%# Bind( "BudgetExchangeRate" ) %>' ID="indAvgYear" Width="65px" Height="14px" />
                        </EditItemTemplate>
                        <ItemTemplate>
                            <ind:IndLabel runat="server" Text='<%# Bind( "BudgetExchangeRate" ) %>' CssClass="RadGrid_FollowUpBudget"
                                ID="txtAvgYear" />
                        </ItemTemplate>
                        <ItemStyle Width="80px" Height="20px" />
                    </radG:GridTemplateColumn>
                    <radG:GridBoundColumn UniqueName="January" HeaderText="Jan" DataField="January"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="February" HeaderText="Feb" DataField="February"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="March" HeaderText="Mar" DataField="March"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="April" HeaderText="Apr" DataField="April"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="May" HeaderText="May" DataField="May"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="June" HeaderText="Jun" DataField="June"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="July" HeaderText="Jul" DataField="July"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="August" HeaderText="Aug" DataField="August"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="September" HeaderText="Sep" DataField="September"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="October" HeaderText="Oct" DataField="October"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="November" HeaderText="Nov" DataField="November"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                    <radG:GridBoundColumn UniqueName="December" HeaderText="Dec" DataField="December"  ReadOnly="true">
                        <ItemStyle Width="60px" Height="20px" />
                        <HeaderStyle Width="60px" />
                    </radG:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </radG:RadGrid>
<%--    </radA:RadAjaxPanel>--%>
                </td>
            </tr>
        </table>
</asp:Panel>
</asp:Content>
