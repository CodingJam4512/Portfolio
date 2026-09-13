<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="crypt.aspx.cs" Inherits="Assignment5.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="height: 74px">
            Welcome to decryption/encryption try it page<br />
            Pick a word, encrypt it, then copy and paste it into decrypt to see the original word come back OUT!<br />
            Created using System.Security.Cryptography<br />
            <br />
            encryption<br />
            <asp:TextBox ID="eTextBox" runat="server"></asp:TextBox>
            <asp:Label ID="eText" runat="server" Text=" Result"></asp:Label>
            <br />
            <asp:Button ID="EGo" runat="server" Text="Go" OnClick="EGo_click" />
            <br />
            <asp:Label ID="Label1" runat="server" Text="decryption"></asp:Label>
            <br />
            <asp:TextBox ID="dTextBox" runat="server"></asp:TextBox>
            <asp:Label ID="dText" runat="server" Text=" Result"></asp:Label>
            <br />
            <asp:Button ID="DGo" runat="server" Text="Go" OnClick="DGo_click"/>
            <br />
        </div>
    </form>
</body>
</html>
