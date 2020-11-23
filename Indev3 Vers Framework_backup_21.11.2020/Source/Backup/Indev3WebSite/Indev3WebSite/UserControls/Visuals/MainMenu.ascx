<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MainMenu.ascx.cs" Inherits="Inergy.Indev3.UI.UserControls_Menus_MainMenu" %>
<%@ Register Assembly="RadMenu.Net2" Namespace="Telerik.WebControls" TagPrefix="radM" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="indControl" %>
<radM:RadMenu EnableViewState="false" ID="mnuMain" runat="server" Style="left: 0px;
    top: 0px" BorderWidth="0px" Height="31px" CausesValidation="False" Skin="Default"
    SkinsPath="~/Skins/Menu">
    <Items>
        <indControl:IndMenuItem ID="RadMenuItem1" runat="server" Text="Reporting" ModuleCode="REP"
            Value="0">
            <GroupSettings Flow="Horizontal"></GroupSettings>
        </indControl:IndMenuItem>
        <indControl:IndMenuItem ID="RadMenuItem24" runat="server" Text="Project Information">
            <Items>
                <indControl:IndMenuItem runat="server" Text="Budget" ID="RadMenuItem27" CssClass="l1left">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="INI" Text="Initial" ID="RadMenuItem2"
                            NavigateUrl="~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=INI">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="REV" Text="Revised" ID="RadMenuItem3"
                            NavigateUrl="~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=REV">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="REF" Text="Reforecast" ID="RadMenuItem4"
                            NavigateUrl="~/Pages/Budget/WPPreselection/WPPreselection.aspx?Code=REF">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="FOL" Text="Follow-up" ID="RadMenuItem5"
                            NavigateUrl="~/Pages/Budget/FollowUpBudget/FollowUpBudget.aspx?">
                        </indControl:IndMenuItem>
                    </Items>
                </indControl:IndMenuItem>
                <indControl:IndMenuItem runat="server" Text="Information" ID="RadMenuItem28" CssClass="l1right">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="CRT" Text="Core Team" ID="RadMenuItem6"
                            NavigateUrl="~/Catalogs.aspx?Code=CRT">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="TIN" Text="Timing &amp; Interco"
                            ID="RadMenuItem7" NavigateUrl="~/Pages/Budget/Interco/TimingAndInterco.aspx">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="WKP" Text="Work Package" ID="RadMenuItem41"
                            NavigateUrl="~/Catalogs.aspx?Code=WKP">
                        </indControl:IndMenuItem>
                    </Items>
                </indControl:IndMenuItem>
            </Items>
            <GroupSettings Flow="Horizontal" OffsetX="-55"></GroupSettings>
        </indControl:IndMenuItem>
        <indControl:IndMenuItem runat="server" Text="Administration">
            <Items>
                <indControl:IndMenuItem runat="server" Text="Organizational Data" ID="RadMenuItem29"
                    CssClass="l1left">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="REG" Text="Region" ID="RadMenuItem32"
                            NavigateUrl='~/Catalogs.aspx?Code=REG'>
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="CTY" Text="Country" ID="RadMenuItem33"
                            NavigateUrl="~/Catalogs.aspx?Code=CTY">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="INL" Text="Inergy Location" ID="RadMenuItem34"
                            NavigateUrl="~/Catalogs.aspx?Code=INL">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="DEP" Text="Department" ID="RadMenuItem35"
                            NavigateUrl="~/Catalogs.aspx?Code=DEP">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="ASC" Text="Associate" ID="RadMenuItem36"
                            NavigateUrl="~/Catalogs.aspx?Code=ASC">
                        </indControl:IndMenuItem>
                    </Items>
                </indControl:IndMenuItem>
                <indControl:IndMenuItem runat="server" Text="Project Data" ID="RadMenuItem30" CssClass="l1center">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="TYP" Text="Project Type" ID="RadMenuItem37"
                            NavigateUrl="~/Catalogs.aspx?Code=TYP">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="OWN" Text="Program Owner" ID="RadMenuItem38"
                            NavigateUrl="~/Catalogs.aspx?Code=OWN">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="PRG" Text="Program" ID="RadMenuItem39"
                            NavigateUrl="~/Catalogs.aspx?Code=PRG">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="PRJ" Text="Project" ID="RadMenuItem40"
                            NavigateUrl="~/Catalogs.aspx?Code=PRJ">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="WPT" Text="WP Template" ID="IndMenuItem2"
                            NavigateUrl="~/Catalogs.aspx?Code=WPT">
                        </indControl:IndMenuItem>
                    </Items>
                </indControl:IndMenuItem>
                <indControl:IndMenuItem runat="server" Text="Financial Data" ID="RadMenuItem31" CssClass="l1right">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="GLA" Text="G/L Account" ID="RadMenuItem43"
                            NavigateUrl="~/Catalogs.aspx?Code=GLA">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="CTC" Text="Cost Center" ID="RadMenuItem44"
                            NavigateUrl="~/Catalogs.aspx?Code=CTC">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="HRA" Text="Hourly Rate" ID="RadMenuItem46"
                            NavigateUrl="~/Catalogs.aspx?Code=HRA">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="EXR" Text="Exchange Rate" ID="IndMenuItem5"
                            CssClass="l1right" NavigateUrl="~/Pages/Financial/ExchangeRate.aspx">
                        </indControl:IndMenuItem>                        
                    </Items>
                </indControl:IndMenuItem>
            </Items>
            <GroupSettings Flow="Horizontal" OffsetX="-110"></GroupSettings>
        </indControl:IndMenuItem>
        <indControl:IndMenuItem runat="server" Text="Data Upload">
            <Items>
                <indControl:IndMenuItem Text="Actual" runat="server" CssClass="l1left">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="UPL" Text="Upload" ID="RadMenuItem8"
                            CssClass="l1left" NavigateUrl="~/Upload.aspx">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="DLG" Text="Logs" ID="RadMenuItem9"
                            CssClass="l1center" NavigateUrl="~/Catalogs.aspx?Code=DLG">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="STS" Text="Status" ID="RadMenuItem10"
                            CssClass="l1right" NavigateUrl="~/Pages/Upload/DataStatus.aspx">
                        </indControl:IndMenuItem>
                    </Items>
                </indControl:IndMenuItem>
                
                <indControl:IndMenuItem Text="Initial Budget" runat="server" CssClass="l1center">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="IBU" Value="mnuInitialBudget" Text="Upload" Id="RadMenuItem42" 
                        CssClass="l1center_only" NavigateUrl="~/Pages/UploadInitialBudget/UploadInitialBudget.aspx">
                        </indControl:IndMenuItem>
                    </Items>
                </indControl:IndMenuItem>
                
                <indControl:IndMenuItem Text="Annual Budget" runat="server" CssClass="l1right">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="AND" Text="Download" ID="RadMenuItem14"
                            CssClass="l1left" NavigateUrl="~/Pages/AnnualBudget/AnnualDownload.aspx">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="ANU" Text="Upload" ID="RadMenuItem15"
                            CssClass="l1center" NavigateUrl="~/Pages/AnnualBudget/AnnualUpload.aspx">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="ANL" Text="Logs" ID="RadMenuItem16"
                            CssClass="l1right" NavigateUrl="~/Catalogs.aspx?Code=ANL">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="ANS" Text="Status" ID="RadMenuItem17"
                            CssClass="l1right" NavigateUrl="~/Pages/AnnualBudget/AnnualDataStatus.aspx">
                        </indControl:IndMenuItem>
                    </Items>
                </indControl:IndMenuItem>
            </Items>
            <GroupSettings Flow="Horizontal" OffsetX="-110"></GroupSettings>
        </indControl:IndMenuItem>
        <indControl:IndMenuItem runat="server" Text="Extract">
            <Items>
                <indControl:IndMenuItem runat="server" Text="Criteria" ID="IndMenuItem3" CssClass="l1center_only">
                    <Items>
                        <indControl:IndMenuItem runat="server" ModuleCode="EXT" Text="Extract by Project" Value="mnuExtract" ID="IndMenuItem1"
                            NavigateUrl="~/Pages/Extract/Extract.aspx">
                        </indControl:IndMenuItem>
                        <indControl:IndMenuItem runat="server" ModuleCode="EXF" Text="Extract by Function" ID="IndMenuItem4"
                            NavigateUrl="~/Pages/Extract/ExtractByFunction.aspx">
                        </indControl:IndMenuItem>
                    </Items>
                </indControl:IndMenuItem>
            </Items>
            <GroupSettings Flow="Horizontal" ></GroupSettings>
        </indControl:IndMenuItem>
        <indControl:IndMenuItem ID="RadMenuItem11" runat="server" Text="Settings">
            <Items>
                <indControl:IndMenuItem runat="server" ModuleCode="TST" Text="Technical Settings"
                    ID="RadMenuItem12" CssClass="l1left" NavigateUrl="~/Catalogs.aspx?Code=TST">
                </indControl:IndMenuItem>
                <indControl:IndMenuItem runat="server" ModuleCode="PRF" Text="Profile" ID="RadMenuItem47"
                    CssClass="l1center" NavigateUrl="~/Catalogs.aspx?Code=PRF">
                </indControl:IndMenuItem>
                <indControl:IndMenuItem runat="server" ModuleCode="UST" Text="User Settings" ID="RadMenuItem13"
                    CssClass="l1right" NavigateUrl="~/Pages/UserSettings/UserSettings.aspx">
                </indControl:IndMenuItem>
            </Items>
            <GroupSettings Flow="Horizontal" OffsetX="-110"></GroupSettings>
        </indControl:IndMenuItem>
    </Items>
</radM:RadMenu>
