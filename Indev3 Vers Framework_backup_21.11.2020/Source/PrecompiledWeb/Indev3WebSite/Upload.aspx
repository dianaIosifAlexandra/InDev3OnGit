<%@ page language="C#" masterpagefile="~/Template.master" autoeventwireup="true" inherits="Inergy.Indev3.UI.Upload, App_Web_zu4hwgzb" title="INDev 3" %>
<%@ Register Src="./UserControls/DataUpload/Upload/Upload.ascx" TagName="Upload" TagPrefix="mb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" Runat="Server">
    <br />
    <asp:Panel ID="pnlUpload" runat="server">
    <br />
    <mb:Upload id="Upload1" runat="server" />
    </asp:Panel>
<script type="text/javascript">
    if (!document.querySelectorAll) {
        document.querySelectorAll = function (selectors) {
            var style = document.createElement('style'), elements = [], element;
            document.documentElement.firstChild.appendChild(style);
            document._qsa = [];

            style.styleSheet.cssText = selectors + '{x-qsa:expression(document._qsa && document._qsa.push(this))}';
            window.scrollBy(0, 0);
            style.parentNode.removeChild(style);

            while (document._qsa.length) {
                element = document._qsa.shift();
                element.style.removeAttribute('x-qsa');
                elements.push(element);
            }
            document._qsa = null;
            return elements;
        };
    }

    if (!document.querySelector) {
        document.querySelector = function (selectors) {
            var elements = document.querySelectorAll(selectors);
            return (elements.length) ? elements[0] : null;
        };
    }

    (function () {
        var elements = document.querySelectorAll(".backgroundColorIE");
        var ieVersion = GetInternetExplorerVersion();
        if (elements != null) {
            for (var i = 0; i < elements.length; i++) {
                if (ieVersion < 9 && ieVersion > 0)
                    elements[i].style.backgroundColor = "#757575";
                else {
                    elements[i].style.backgroundColor = "#6E6E6E";
                }
            }
        }
    })()
</script>
</asp:Content>

