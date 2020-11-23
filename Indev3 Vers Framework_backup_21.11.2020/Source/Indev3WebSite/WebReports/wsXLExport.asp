<%@ Language=VBScript %>

<%
Option Explicit

' Get connection string from XML file
Public Function GetConnectionStringFromXML(ByVal DatasourceId)

  Dim lstrReturn
  Dim lxmlDoc
  Dim lxmlNodDatasource

  Set lxmlDoc = Server.CreateObject("MSXML2.DOMDocument.4.0")
  With lxmlDoc
    .async = False
    .Load Server.MapPath(".") & "\_private\wswebanalyst.xml"
  End With

  Set lxmlNodDatasource = lxmlDoc.selectSingleNode("wsWebAnalyst/Datasources/Datasource[Datasource_ID=" & DatasourceId & "]")
  If lxmlNodDatasource Is Nothing Then
    lstrReturn = "Nothing"
  Else
    lstrReturn = lxmlNodDatasource.selectSingleNode("Connection").Text
  End If

  GetConnectionStringFromXML = lstrReturn

  Set lxmlNodDatasource = Nothing
  Set lxmlDoc = Nothing

End Function

' Get The connection string
Public Function GetConnectionString()

	Dim lstrReturn
	
	If Request.Form("wsDatasourceId") <> "" Then
		lstrReturn  = GetConnectionStringFromXML(Request.Form("wsDatasourceId"))
	Else
		lstrReturn = CStr(Request.Form("wsXLConnection"))
	End If
	
	GetConnectionString = lstrReturn

End Function

Response.Write "<HTML>" & vbcrlf
Response.Write "<HEAD>" & vbcrlf

Response.ContentType = "application/vnd.ms-excel"
'Response.ContentType = "application/msword"
'Response.ContentType = "text/html"

Response.Write "<title>Microsoft Excel export</title>" & vbcrlf
Response.Write "<link rel='stylesheet' href='styles/wsStyle_WebReporter.css' type='text/css'>" & vbcrlf
Response.Write "</HEAD>" & vbcrlf

Response.Write "<BODY>" & vbcrlf

Dim objWebReporter

If Request.Form("wsXlQuery") <> "" then

	Set objWebReporter = Server.CreateObject("wsWebReporter.OWReporter")
	
	objWebReporter.Cellset = Cstr(Request.Form("wsXlQuery"))
	objWebReporter.Connection = GetConnectionString()
	objWebReporter.MergeColumnHeaders = 1
	objWebReporter.MergeRowHeaders = 1
	objWebReporter.EmptyCell = " "
	
	Response.Write Replace(objWebReporter.Generate(),"€","&euro;")
	
	Set objWebReporter = Nothing
		
ElseIf Request.Form("wsXLExport") <> "" Then

	Response.Write Request.Form("wsXLExport")
		
Else

	dim strQuery 
	dim straParams
	dim strParamName
	dim strParamValue
	dim strParams
	dim straLabels
	dim strFilterLabel
	dim i

	'---- First : We display the selected filters
	'--- we display parameters value in a more user friendly way
	'--- we remove @ in front of parameters name and we do not display
	'--- internal only parameters such as @ROWS,@COLS,@PAGEIDXCOL,@PAGINGCOL ...
	
	For i=1 To Request.Form.Count
		'Response.Write "Debug : " & Request.Form.Key(i) & " " & Request.Form(i) & "<br>"
		
		If Left(Request.Form.Key(i),1) = "@" Then
			strParamName = Request.Form.Key(i)
			
			Select Case Request.Form.Key(i)
				Case "@PAGINGCOL","@PAGINGROW"
				'strParamValue = ""
				'strParams = strParams & strParamName & "=" & strParamValue & ";"

				Case "@PAGEIDXCOL","@PAGEIDXROW"
				'strParamValue = 0
				'strParams = strParams & strParamName & "=" & strParamValue & ";"
			
				Case "@MAXCOL","@MAXROW"

				Case Else
				strParamValue = Request.Form(i)
				strParams = strParams & strParamName & "=" & strParamValue & ";"
			End Select
			
		End If
		
	Next
	
	strParams = strParams & "@DRILLCOLS=0;@DRILLROWS=0;@DRILLTHROUGH=0;@ATTRIBUTES=0;@COLORCODING=0;"

	Dim lstTemp
	Dim strReportTemplate

	Set objWebReporter = Server.CreateObject("wsWebReporter.OWReporter")

	objWebReporter.Parameters = strParams

	objWebReporter.ReportFile = Server.MapPath(Request.Form("wsXLTemplate"))		
	objWebReporter.Notify = False
	objWebReporter.WriteBackEnabled = False
	objWebReporter.Cellset = Replace(objWebReporter.Cellset,"SubSet(@COLUMNS,@PAGEIDXCOL,@PAGINGCOL)","@COLUMNS")
	objWebReporter.Cellset = Replace(objWebReporter.Cellset,"SubSet(@ROWS,@PAGEIDXROW,@PAGINGROW)","@ROWS")

	objWebReporter.Connection = GetConnectionString()

	Response.Write Replace(objWebReporter.Generate(),"€","&euro;")

	Set objWebReporter = Nothing
	
End If
%>