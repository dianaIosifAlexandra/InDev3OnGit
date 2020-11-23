<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UnhandledError.aspx.cs" Inherits="Inergy.Indev3.UI.UnhandledError" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="Label1" runat="server" ForeColor="Red" Text="An unhandled exception has occured. Please contact your administrator and report the following details:"></asp:Label>
        <br />
        <br />
        <asp:Panel ID="pnlErrorDetail" runat="server" Height="360px" Width="728px">
            Error Message<br />
            <asp:TextBox ID="txtErrorMessage" runat="server" Height="56px" ReadOnly="True" TextMode="MultiLine"
                Width="536px"></asp:TextBox><br />
            <br />
            Stack Trace<br />
            <asp:TextBox ID="txtStackTrace" runat="server" Height="280px" ReadOnly="True" TextMode="MultiLine"
                Width="544px"></asp:TextBox>
        </asp:Panel>
    
    </div>
    </form>
</body>
</html>
