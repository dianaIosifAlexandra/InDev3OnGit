<%@ control language="C#" autoeventwireup="true" inherits="UserControls_Region_RegionEdit, App_Web_fwhesefm" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc1" %>
<cc2:GenericEditControl ID="RegionEditControl" runat="server">
    <table id="tbl">
        <tr>
            <td align="right">
                <cc1:IndCatLabel ID="Code" runat="server" Text="Code"></cc1:IndCatLabel>
            </td>
            <td align="left">
                <cc1:IndCatTextBox ID="txtCode" runat="server" EntityProperty="Code" Width="150px"
                    AlphaNumericCheck="True"></cc1:IndCatTextBox>
                <asp:RegularExpressionValidator ID="revCode" runat="server" ControlToValidate="txtCode"
                    SetFocusOnError="true" ValidationExpression="[\w]+" ErrorMessage="Filed Code can only contain alphanumeric characters"
                    ForeColor="#626262" Display="Dynamic" CssClass="foreColorIE">*
                </asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc1:IndCatLabel ID="Name" runat="server" Text="Name"></cc1:IndCatLabel>
            </td>
            <td align="left">
                <cc1:IndCatTextBox ID="IndCatTextBox1" runat="server" EntityProperty="Name" Width="150px"></cc1:IndCatTextBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc1:IndCatLabel ID="Rank" runat="server" Text="Rank" AlphaNumericCheck="True"></cc1:IndCatLabel>
            </td>
            <td align="left">
                <cc1:IndCatTextBox ID="txtRank" runat="server" EntityProperty="Rank" Width="50px"
                    MaxLength="9"></cc1:IndCatTextBox>
                <asp:RegularExpressionValidator ID="revRank" runat="server" ControlToValidate="txtRank"
                    SetFocusOnError="true" ValidationExpression="^\d+$" ErrorMessage="Field Rank must be a positive integer."
                    ForeColor="#626262" Display="Dynamic" CssClass="foreColorIE">*
                </asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
</cc2:GenericEditControl>
