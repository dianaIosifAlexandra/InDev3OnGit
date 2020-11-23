<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserSettings.ascx.cs"
    Inherits="Inergy.Indev3.UI.UserControls_UserSettings_UserSettings"%>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>

<script type="text/javascript">
    var needToConfirm = true;
    window.onbeforeunload = confirmExit;
    
    function UserSettingsComboSetDirty(input, args)
    {
        SetUserSettingsDirtyFlag();
    }
    
    function SetUserSettingsDirtyFlag() 
    {try{
        var hdn=document.getElementById("<%=hdnUserSettingsDirty.ClientID%>");
        hdn.value = "1";
        }
        catch(e){}
    }
    
    function ClearUserSettingsDirtyFlag() 
    {try{
        var hdn=document.getElementById("<%=hdnUserSettingsDirty.ClientID%>");
        hdn.value = "0";}catch(e){}
    }
    
    function confirmExit()
    {
        if (needToConfirm)
        {
            var hdn=document.getElementById("<%=hdnUserSettingsDirty.ClientID%>");
            if (hdn!=null && hdn.value == "1") 
            {
                needToConfirm = false;
                setTimeout("enableCheck()", "100");
                return "There are unsaved changes in this page. If you click OK you may lose all unsaved changes.";
            }
        }
    }
    
    function enableCheck()
    {
        needToConfirm = true;
    }
    
</script>

<table cellpadding="2" cellspacing="2" width="100%">
    <tr>
        <td>
            <asp:Panel ID="pnlUserSettings" runat="server" CssClass="Panel">
                <table cellpadding="2" cellspacing="0" border="0">
                    <tr>
                        <td align="right">
                            <cc1:IndLabel ID="lblAmountScaleOption" runat="server" Text="Amount scale option"></cc1:IndLabel>
                        </td>
                        <td>
                        </td>
                        <td align="left">
                            <cc1:IndComboBox ID="cmbAmountScaleOption" runat="server" CheckDirty="false" OnClientSelectedIndexChanged="UserSettingsComboSetDirty">
                            </cc1:IndComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <cc1:IndLabel ID="lblNumberOfRecordsPerPage" runat="server" Text="Number of lines displayed per page"
                                CssClass="IndLabel"></cc1:IndLabel>
                        </td>
                        <td>
                            <cc1:IndLabel ID="IndLabel1" runat="server" CssClass="IndLabel" ForeColor="Yellow">*</cc1:IndLabel></td>
                        <td align="left">
                            <cc1:IndTextBox ID="txtNumberOfRecordsPerPage" CheckDirty="false" runat="server"
                                CssClass="txtBoxTechSettings" Width="148px" onchange="SetUserSettingsDirtyFlag();"></cc1:IndTextBox><asp:RegularExpressionValidator
                                    ID="revNumberOfRecords" runat="server" ControlToValidate="txtNumberOfRecordsPerPage"
                                    SetFocusOnError="true" ValidationExpression="^\d+$" ErrorMessage="Field 'Number of lines displayed per page' must be a positive integer."
                                    ForeColor="#6E6E6E" ValidationGroup="UserSettingsValidationGroup">*
                                </asp:RegularExpressionValidator><asp:RequiredFieldValidator ID="reqNumberofRecords"
                                    runat="server" ControlToValidate="txtNumberOfRecordsPerPage" ErrorMessage="'Number of lines displayed per page' is required."
                                    ForeColor="#6E6E6E" SetFocusOnError="True" ValidationGroup="UserSettingsValidationGroup">*
                                </asp:RequiredFieldValidator><asp:RangeValidator ID="reqRecordsRange" runat="server"
                                    ControlToValidate="txtNumberOfRecordsPerPage" ErrorMessage="Field 'Number of lines displayed per page' must be between 1 and 100."
                                    ForeColor="#6E6E6E" MinimumValue="1" MaximumValue="100" SetFocusOnError="True"
                                    Type="Integer" ValidationGroup="UserSettingsValidationGroup">* </asp:RangeValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <cc1:IndLabel ID="lblCurrencyRepresentation" runat="server" Text="Currency to be displayed"
                                CssClass="IndLabel"></cc1:IndLabel>
                        </td>
                        <td>
                        </td>
                        <td align="left">
                            <cc1:IndComboBox ID="cmbCurrencyRepresentation" runat="server" CheckDirty="false"
                                OnClientSelectedIndexChanged="UserSettingsComboSetDirty">
                            </cc1:IndComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <cc1:IndLabel ID="lblUserCountry" runat="server" Text="User Country" CssClass="IndLabel"></cc1:IndLabel>
                        </td>
                        <td>
                        </td>
                        <td align="left">
                            <table cellspacing="0">
                                <tr>
                                    <td>
                                        <cc1:IndLabel ID="lblCountry" runat="server" CssClass="IndLabel"></cc1:IndLabel>
                                    </td>
                                    <td style="padding-left: 8px">
                                        <asp:Button ID="btnChangeCountry" runat="server" Text="Change" PostBackUrl="~/Pages/UserSettings/UserSettings.aspx?Code=UST&ChangeCountry=1" OnClick="btnChangeCountry_Click"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="3">
                            <asp:Button ID="btnSaveConfiguration" Text="Save configuration" runat="server" OnClientClick="ClearUserSettingsDirtyFlag();" OnClick="btnSaveConfiguration_Click"
                                ValidationGroup="UserSettingsValidationGroup" /></td>
                    </tr>
                    <tr>
                        <td colspan="3" align="center" style="height: 50px">
                            <cc1:IndValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="UserSettingsValidationGroup" />
                        </td>
                    </tr>
                </table>
                <asp:HiddenField ID="hdnUserSettingsDirty" runat="server" />
            </asp:Panel>
        </td>
    </tr>
</table>
