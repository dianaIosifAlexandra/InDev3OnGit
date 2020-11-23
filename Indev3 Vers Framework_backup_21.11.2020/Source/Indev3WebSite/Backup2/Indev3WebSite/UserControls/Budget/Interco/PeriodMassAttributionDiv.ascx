<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PeriodMassAttributionDiv.ascx.cs" Inherits="Inergy.Indev3.UI.UserControls_Budget_Interco_PeriodMassAttributionDiv" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>

    <script type='text/javascript' src='../../../Scripts/DivScripts.js'></script>

<div class="drag" id= "periodMassAttributionDiv" runat="server" style="display:none; border:0px 2px 2px 2px; border-color:#0834DE; border-style:none solid solid solid;
                width:320px; height:255px; 
                position:absolute; top:50%; left:50%; margin-top:-140px; margin-left:-160px; filter:alpha(opacity=100);
                background: url('../../../Images/titlebar.png') repeat-x" 
                onmousedown="InitDragDrop(this)">
        <div id="closeButtonDiv" runat = "server" style="display:block; visibility:hidden; width:48px; height:30px; right:1; top:1;" align="right">
            <asp:Button id="closeButton" runat="server" style="display:block; visibility:visible; width:23px; height:23px; position:absolute;
                right:3px; top:3px; border:0px; cursor:pointer; filter:alpha(opacity=100);
                background: #505050 url('../../../Images/buton_close.png') no-repeat"  OnClick="cancelButton_Click"
                OnClientClick="closeDiv(event, this)"/>
        </div>

        <div id="startEndDateDiv" runat = "server" style="display:block; width:320px; height:225px;
                position:absolute; margin-top:30px; margin-left:0px; left:0; bottom:0; right:0; filter:alpha(opacity=100);
                background-color:transparent; background: #626262 url('../../../Images/back_popup.png') no-repeat right bottom">

            <br />
            <br />
            <table align="left" border="0" style="width:250;vertical-align:top">
                <tr>
                    <td style="height: 27px; width: 100px;" align="right">
                        <asp:Label ID="startDateLabel" Text="Start Date" runat="server" style="display:block; visibility:visible; width:60px; height:27px;
                                font-family:tahoma; font-style:normal; font-size:13px; color:white;font-weight:normal; filter:alpha(opacity=100)"/>
                    </td>
                    <td nowrap="nowrap">
                        <ind:IndYearMonth ID="IndStartYearMonth" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="height: 27px; padding-right:0px" align="right">
                        <asp:Label ID="endDateLabel" Text="End Date" runat="server" style="display:block; visibility:visible; width:60px; height:27px;
                                font-family:tahoma; font-style:normal; font-size:13px; color:white;font-weight:normal; filter:alpha(opacity=100)"/>
                    </td>
                    <td>
                        <ind:IndYearMonth ID="IndEndYearMonth" runat="server"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center" style="height:27px">
                        <table cellspacing="2" cellpadding="0" border="0" width="92">
                        <tr>
                            <td>
                                <asp:Button id="saveButton" runat="server" style="display:block; visibility:visible; width:46px; height:27px; border:0;
                                    cursor:pointer; filter:alpha(opacity=100);
                                    background: #626262 url('../../../Images/button_save.png') no-repeat" OnClick="saveButton_Click" ToolTip="Save"/>
                            </td>
                            <td>
                                <asp:Button id="cancelButton" runat="server" style="display:block; visibility:visible; width:46px; height:27px; border:0;
                                    cursor:pointer; filter:alpha(opacity=100);
                                    background: #626262 url('../../../Images/button_cancel.png') no-repeat" OnClick="cancelButton_Click"
                                    OnClientClick="closeDiv(event, this)" ToolTip="Cancel"/>
                            </td>
                        </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table style="width: 300px; height:80px" align="left" id="tableErrorMessages" runat="server">
                <tr align="left">
                    <td style="width: 320px" align="left">
                            <asp:Table ID="tblErrorMessages" runat="server" CssClass="IndValidationSummaryHRMassAttr" align="left">
                            <asp:TableRow ID="TableRow1" runat="server" align="left">
                                <asp:TableCell ID="TableCell1" runat="server">
                                    <asp:BulletedList runat="server" DisplayMode="Text" ID="lstValidationSummary">
                                    </asp:BulletedList>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
