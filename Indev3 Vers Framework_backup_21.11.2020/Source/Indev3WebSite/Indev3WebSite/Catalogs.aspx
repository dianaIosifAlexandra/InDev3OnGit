<%@ Page Language="C#" MasterPageFile="~/Template.master" AutoEventWireup="true" CodeFile="Catalogs.aspx.cs" Inherits="Inergy.Indev3.UI.Catalogs" Title="INDev 3" EnableViewState="false" %>
<%@ Register Assembly="RadAjax.Net2" Namespace="Telerik.WebControls" TagPrefix="radA" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ph" Runat="Server" EnableViewState="false">
    <radA:RadAjaxPanel HorizontalAlign="Center" ID="plhCatalogue" runat="server" EnableOutsideScripts="True" LoadingPanelID="" ScrollBars="None" EnableAJAX="False" EnableViewState="false" CssClass="catalogPanel">
    </radA:RadAjaxPanel>
<!--[if IE 11]>
    <style>
        .radPopupImage_NewDefault img {
        padding-top: 3px !important;
        }

        div.RadGrid_IndGenericGrid table td
        {
	        padding-top: 2px !important;
        }
    </style>
<![endif]-->        
<!--[if IE 8]>
    <style>
        .radPopupImage_NewDefault img {
        padding-top: 7px !important;
        }

        div.RadGrid_IndGenericGrid table td
        {
	        padding-top: 6px !important;
        }
    </style>
<![endif]-->        
<!--[if IE 9]>
    <style>
        .radPopupImage_NewDefault img {
        padding-top: 3px !important;
        }

        div.RadGrid_IndGenericGrid table td
        {
	        padding-top: 2px !important;
        }
    </style>
<![endif]-->        
      

<script type='text/javascript' src='Scripts/GetInternetExplorerVersion.js'></script>
<script type="text/javascript">
    if (GetInternetExplorerVersion() < 9 && GetInternetExplorerVersion() > 0)
{
    try {
        if (RadComboBox !== undefined) {
            var prototype = RadComboBox.prototype;
            var set_text = prototype.SetText;
            var propertyChange = prototype.OnInputPropertyChange;

            prototype.SetText = function (value) {
                this._skipEvent = 0;
                set_text.call(this, value);
            };

            prototype.OnInputPropertyChange = function () {
                if (!event.propertyName)
                    event = event.rawEvent;
                if (event.propertyName == "value") {
                    this._skipEvent++;
                    if (this._skipEvent == 2)
                        return;
                    propertyChange.call(this);
                }
            }
        }
    }
    catch (err) {
    }
 }
</script> 
 </asp:Content>

