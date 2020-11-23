<%@ control language="C#" autoeventwireup="true" inherits="UserControls_Department_DepartmentEdit, App_Web_k5h4af5s" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.WebControls"
    TagPrefix="cc3" %>
<%@ Register Assembly="Inergy.Indev3.WebFramework" Namespace="Inergy.Indev3.WebFramework.GenericControls"
    TagPrefix="cc2" %>
<cc2:GenericEditControl ID="DepartmentEditControl" runat="server" Width="281px">
    <table>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblName" runat="server" Text="Name"></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtName" runat="server" EntityProperty="Name" Width="150px"></cc3:IndCatTextBox></td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="lblFunction" runat="server" Text="Function Code" CssClass="IndCatLabel"
                    EntityProperty=""></cc3:IndCatLabel></td>
            <td align="left">
                <cc3:IndCatComboBox ID="cmbFunction" runat="server" EntityProperty="IdFunction" DataTextField="Name"
                    DataValueField="Id" Width="152px">
                </cc3:IndCatComboBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <cc3:IndCatLabel ID="Rank" runat="server" Text="Rank" AlphaNumericCheck="True"></cc3:IndCatLabel>
            </td>
            <td align="left">
                <cc3:IndCatTextBox ID="txtRank" runat="server" EntityProperty="Rank" Width="50px"
                    MaxLength="9"></cc3:IndCatTextBox>
                <asp:RegularExpressionValidator ID="revRank" runat="server" ControlToValidate="txtRank"
                    SetFocusOnError="true" ValidationExpression="^\d+$" ErrorMessage="Field Rank must be a positive integer."
                    ForeColor="#626262" Display="Dynamic"  CssClass="foreColorIE">*
                </asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
</cc2:GenericEditControl>
