<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PeriodMassAttributionDiv.ascx.cs" Inherits="Inergy.Indev3.UI.UserControls_Budget_Interco_PeriodMassAttributionDiv" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="ind" %>

    <script type='text/javascript' src='../../../Scripts/DivScripts.js'></script>

<div class="drag PeriodMassAttribDiv" id="periodMassAttributionDiv" runat="server" 
                onmousedown="InitDragDrop(this)">
                <div id="titleDiv">Period Mass Attribution</div>
        <div id="closeButtonDiv" runat="server" class="CloseButtonDiv">
            <asp:Button id="closeButton" runat="server"  class="CloseButton" OnClick="cancelButton_Click"
                OnClientClick="closeDiv(event, this)"/>
        </div>

        <div id="startEndDateDiv" runat = "server" class="BodyDiv">

            <br />
            <br />
            <table align="left" border="0" style="width:250;vertical-align:top">
                <tr>
                    <td style="height: 27px; width: 100px;" align="right">
                        <asp:Label ID="startDateLabel" Text="Start Date" runat="server" CssClass="DateLabel"/>
                    </td>
                    <td nowrap="nowrap">
                        <ind:IndYearMonth ID="IndStartYearMonth" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="height: 27px; padding-right:0px" align="right">
                        <asp:Label ID="endDateLabel" Text="End Date" runat="server" CssClass="DateLabel"/>
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
                                <asp:Button id="saveButton" runat="server" CssClass="PeriodMassAttributionDiv_SaveButton" OnClick="saveButton_Click" ToolTip="Save"/>
                            </td>
                            <td>
                                <asp:Button id="cancelButton" runat="server" CssClass="PeriodMassAttributionDiv_CancelButton" OnClick="cancelButton_Click"
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
