<meta http-equiv="X-UA-Compatible" content="IE=9" />
<%@ page language="C#" autoeventwireup="true" inherits="Inergy.Indev3.UI.ErrorForm, App_Web_u3dsi22h" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Validation failed</title>
    <base target="_self" />
</head>
<body style="background-color: #e7e7e7">
    <form id="form1" runat="server">
    <div>
        <table style="width: 400px; height: 200px; background-color: #e7e7e7">
            <tr>
                <td style="width: 409px">
                    The following problem has occured:</td>
            </tr>
            <tr>
                <td style="width: 409px">
                    <asp:TextBox ID="txtError" runat="server" ForeColor="Red" Height="152px" ReadOnly="True"
                        TextMode="MultiLine" Width="400px"></asp:TextBox></td>
            </tr>
            <tr>
                <td align="center" style="width: 409px; height: 25px">
                    <asp:Button ID="btnClose" runat="server" Text="Close" Width="64px" /></td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
