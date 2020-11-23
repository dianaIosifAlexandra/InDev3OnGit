' --- File Name:	wsPaging.vbs script
' --- Version:		v1.0
' --- Date:		19/02/2004
' --- Last Updated:	19/02/2004
' --- Author:		WINSIGHT
' --- Support:		support@winsight.fr
' --- Web:		www.winsight.fr
' --- Copyright:	(c) WINSIGHT, 2003
' --- Comments:		Implementation of paging on rows and columns


Public Function wsAddPagingLimit(strText, strParameters, strQuery)
'--- this Function add two boxes that contains
'--- the maximum number of possible pages (columns or rows)
'--- for a particular Query
'--- this boxes are used by wsPaging function in the wsclient.js
'--- to ensure that during navigation on the paging bar the user
'--- does not go over the maximum number of pages
	Dim lastrParams
	Dim i
	Dim ladoRs
	Dim lintMaxRow
	Dim lintMaxCol
	Dim lbolPagRow	'paging row enabled
	Dim lbolPagCol	'paging col enabled

	'If Context("@PAGINGCOL") > 0 Or Context("@PAGINGROW") > 0 Then
	lbolPagCol = InStr(1, strQuery, "@PAGINGCOL") > 0
	lbolPagRow = InStr(1, strQuery, "@PAGINGROW") > 0

	If lbolPagCol Or lbolPagRow Then

		lastrParams = Split(strParameters,";")

		'Ensure there is no space before @PAGINGROW OR @PAGINGCOL due to query update (Cf. replace below)
		While InStr(1, strQuery, " @PAGINGROW") > 0
			strQuery = Replace(strQuery, " @PAGINGROW", "@PAGINGROW")
		Wend
		While InStr(1, strQuery, " @PAGINGCOL") > 0
			strQuery = Replace(strQuery, " @PAGINGCOL", "@PAGINGCOL")
		Wend

		For i = Lbound(lastrParams) To UBound(lastrParams)
			If lastrParams(i)= "@PAGINGROW" Or lastrParams(i)= "@PAGINGCOL" THen
				'Let blank @PAGINGROW and @PAGINGCOL to retrieve total number of records with subset function (update bounds : 0 to All)
				strQuery = Replace(strQuery, "," & lastrParams(i),"")
			ElseIf lastrParams(i)= "@PAGEIDXROW" Or lastrParams(i)= "@PAGEIDXCOL" Then
				'Set to value 0 prms @PAGEIDXROW and @PAGINGCOL to retrieve total number of records with subset function (update bounds : 0 to All)
				strQuery = Replace(strQuery, lastrParams(i),"0")
			Else
				strQuery = Replace(strQuery,lastrParams(i),CONTEXT(lastrParams(i)))
			End If
		Next	

		Set ladoRs = CreateObject("ADOMD.Cellset")
		ladoRs.activeconnection = CONTEXT("CONNECTION")
		ladoRs.open strQuery
	
		IF lbolPagCol THEN
			If (ladoRS.Axes(0).Positions.count Mod CONTEXT("@PAGINGCOL")) = 0 Then
				lintMaxCol = ladoRS.Axes(0).Positions.count/CONTEXT("@PAGINGCOL")
			Else
				lintMaxCol = Int(ladoRS.Axes(0).Positions.count/CONTEXT("@PAGINGCOL")) + 1
			End If
			strText = strText & "<input name='@MAXCOL' id='@MAXCOL' value='" & lintMaxCol  & "' class='owsystem'>"
		End If

		If lbolPagRow Then
			If (ladoRS.Axes(1).Positions.count Mod CONTEXT("@PAGINGROW")) = 0 Then
				lintMaxRow = ladoRS.Axes(1).Positions.count / CONTEXT("@PAGINGROW")
			ELSE
				lintMaxRow = Int(ladoRS.Axes(1).Positions.count / CONTEXT("@PAGINGROW")) + 1
			End If
			strText = strText & "<input name='@MAXROW' id='@MAXROW' value='" &  lintMaxRow & "' class='owsystem'>"
		End If

		strText = strtext & "<TABLE width='100%' cellpadding=1 cellspacing=0 border=0><TR>"

		If lbolPagRow Then
			strText = strText & "<td width='50%' align='left'>&nbsp;&nbsp;"
			strText = strText & "<img alt='Retour à la première page en ligne' class='wsButton' align='absmiddle' onclick=""" & "wsPaging('row','first')" & """ src='images/pg_row_first.gif' width='18' height='16'>&nbsp;"
			strText = strText & "<img alt='Page précédente en ligne' class='wsButton' align='absmiddle' src='images/pg_row_prev.gif' onclick=""" & "wsPaging('row','prev')" & """ width='18' height='16'>&nbsp;"
			' strText = strText & "<input class=formbuttonnum size=3 maxlength=3 type=text id=wsrowpcurbis name=wsrowpcurbis value='" & Cint(CONTEXT("@PAGEIDXROW")/CONTEXT("@PAGINGROW")) + 1 & "'>/" & lintMaxRow + 1
			strText = strText & Int(CONTEXT("@PAGEIDXROW")/CONTEXT("@PAGINGROW")) + 1 & "/" & lintMaxRow & "&nbsp;"
			strText = strText & "<img alt='Page suivante en ligne' class='wsButton' align='absmiddle' onclick=""" & "wsPaging('row','next')" & """ src='images/pg_row_next.gif' width='18' height='16'>&nbsp;"
			strText = strText & "<img alt='Dernière page en ligne' class='wsButton' align='absmiddle' onclick=""" & "wsPaging('row','last')" & """ src='images/pg_row_last.gif' width='18' height='16'></td>"
		End If

		If lbolPagCol Then
			strText = strText & "<td width='50%' align='right'><img alt='Retour première page en colonne' class='wsButton' align='absmiddle' onclick=""" & "wsPaging('col','first')" & """ src='images/pg_col_first.gif' width='18' height='17'>&nbsp;"
			strText = strText & "<img alt='Page précédente en colonne' class='wsButton' align='absmiddle' src='images/pg_col_prev.gif' onclick=""" & "wsPaging('col','prev')" & """ width='18' height='17'>&nbsp;"
			' strText = StrText & "<input class=formbuttonnum size=3 maxlength=3 type=text id=wscolpcurbis name=wscolpcurbis value='" & CInt(CONTEXT("@PAGEIDXCOL")/CONTEXT("@PAGINGCOL")) + 1 & "'>/" &  lintMaxCol +1 & "&nbsp;"
			strText = StrText & Int(CONTEXT("@PAGEIDXCOL")/CONTEXT("@PAGINGCOL")) + 1 & "/" &  lintMaxCol & "&nbsp;"
			strText = strText & "<img alt='Page suivante en colonne' class='wsButton' align='absmiddle' onclick=""" & "wsPaging('col','next')" & """ src='images/pg_col_next.gif' width='18' height='17'>&nbsp;"
			strText = strText & "<img alt='Dernière page en colonne' class='wsButton' align='absmiddle' onclick=""" & "wsPaging('col','last')" & """ src='images/pg_col_last.gif' width='18' height='17'>&nbsp;</td>"
		End If

		strText = strText & "</TR></TABLE>"

		ladoRs.close
		Set ladoRs = Nothing

	End If

End Function

