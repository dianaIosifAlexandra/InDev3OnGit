<%@ Page Language="vb" AutoEventWireup="false" ASPCompat="true" %>
<%@ Register TagPrefix="winsight" Namespace="Winsight.WebControls" Assembly="Winsight.WebControls" %>
<html>
	<head>
		<meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
		<title>WINSIGHT OLAPWEBHOUSE</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link rel="stylesheet" href="styles/wsStyle_Page.css" type="text/css">
		<link rel="stylesheet" href="styles/wsStyle_WebReporter.css" type="text/css">
		<link rel="stylesheet" href="styles/wsStyle_WebPopup.css" type="text/css">
		<!-- Freeze Columns/Headers -->
		<script src="scripts/wsWbrScript_Freeze.js" language="javascript" type="text/javascript"></script>
		<script><!--
			//Initialize flags to set if scroll is enabled on columns and Rows
			var bolFreezeColumns = false;
			var bolFreezeRows = false;
			//This function is called from svg client function showDetail(e)
			//arg contains drillDownMap when drill is made in svg map.
			function wsDrillDown(strMember, arg) {
				alert(strMember + "\n" + arg);
			}
		//-->
		</script>
	</head>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0">
	<form method=post>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td valign="bottom" background="images\top.gif"><img style="CLEAR: left; DISPLAY: inline; FLOAT: left" alt="" src="images\logo.gif"><img style="CLEAR: left; DISPLAY: inline; FLOAT: right" alt="" src="images\winsight.gif"
						align="bottom"></td>
			</tr>
			<tr>
				<td class="wsTitleDiv">Exchange Rates Evolution</td>
			</tr>
			<tr>
				<td valign="top" align="center">
					<table cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td>
								<%
								Dim strParams As String = String.Empty
								%>
								<!-- ### GESTION DES MENUS ### -->
								<span class="wsMenuDiv">
								<%
									WebPopup1.Connection = "Provider=MSOLAP.2;Data Source=patrocle;Initial Catalog=Indev3"
									WebPopup1.MenuFile = "reports\SampleReport.mnu"
									WebPopup1.Generate()
									strParams = WebPopup1.ParamertersDefault
									WebPopup1 = Nothing
								%>
								<winsight:webpopup id="WebPopup1" runat="server"></winsight:webpopup>
								</span>
								<!-- ### FIN DE LA GESTION DES MENUS ### -->
							</td>
							<td><span class="wsExportDiv"><a href='javascript:wsExcelReportFull()'><img alt="Export vers Excel" src="Images/Excel.gif" border="0"></a></span></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>		
		<table align=center>
			<tr>
				<td align=center>
					<!-- ### GESTION DU TABLEAU ### --> 
					<span id="report1">
					<%
					WebReporter1.Connection = "Provider=MSOLAP.2;Data Source=patrocle;Initial Catalog=Indev3"
					WebReporter1.ReportFile = "reports\SampleReport.rpt"
					WebReporter1.Parameters.Set(Request.Form)
					If Not strParams = String.Empty Then
						WebReporter1.Parameters.Set(strParams)
					End If
					WebReporter1.Generate()
					WebReporter1 = Nothing
					%>
					<winsight:webreporter id="WebReporter1" runat="server"></winsight:webreporter>
					</span>
					<!-- ### FIN DE LA GESTION DU TABLEAU ### -->
				</td>
			</tr>
		</table>
				
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<!-- ### GESTION DU GRAPHE ### -->                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         <!-- ### FIN DE LA GESTION DU GRAPHE ### -->
				</td>
			</tr>
			<tr valign="middle">
				<td class="pageFooter">Copyright© WINSIGHT 2004</td>
			</tr>
		</table>
		<input type="hidden" name="wsXLTemplate" id="wsXLTemplate" value="Reports\SampleReport.rpt">
		<input type="hidden" name="wsXLConnection" id="wsXLConnection" value="Provider=MSOLAP.2;Data Source=patrocle;Initial Catalog=Indev3">
		<script language="javascript" type="text/javascript">initFreeze();</script>
	</form>
	</body>
</html>
