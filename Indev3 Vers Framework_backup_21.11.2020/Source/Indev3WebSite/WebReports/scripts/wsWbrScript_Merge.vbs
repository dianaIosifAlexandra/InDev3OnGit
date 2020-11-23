' --- File Name:	wsMerge.vbs script
' --- Version:		v1.0
' --- Date:		19/01/2004
' --- Last Updated:	19/01/2004
' --- Author:		WINSIGHT
' --- Support:		support@winsight.fr
' --- Web:		www.winsight.fr
' --- Copyright:	(c) WINSIGHT, 2003
' --- Comments:		Implementation of merging columns or rows headers


' These module-level variables are use to keep track of report-wide information
' They should be defined at the top of a WebAnalyst Notifications script 
'Dim mlngCurRow
'Dim mlngRowCount
'Dim mlngCurCol
'Dim mlngParents()
'Dim mstrPrevHeaders()


' This function handles headers merging on a given axis
' It is being used in the wsToggleDrillRows()/wsToggleDrillColumns() subs
' It can be placed anywere in a WebAnalyst Notifications script
Function wsGetSpanValue2(intAxis, lngPosition, intMember)

	Dim lstrCaption
	Dim llngCnt
	Dim llngIdx
	Dim lbolFound
	Dim llngStart
	Dim llngSpan

	' get current header's caption
	lstrCaption = Context("CellSet").Axes(intAxis).Positions(lngPosition).Members(intMember).Caption
	' get number of positions along axis
	llngCnt = Context("CellSet").Axes(intAxis).Positions.Count - 1

	' start reviewing the next captions along current axis
	llngStart = lngPosition + 1
	lbolFound = False

	For llngIdx = llngStart To llngCnt

		' compare each caption below current one to current one
		If (Context("CellSet").Axes(intAxis).Positions(llngIdx).Members(intMember).Caption <> lstrCaption) Then

			' if same caption is found below current one, increment span then exit loop				
			llngSpan = llngIdx - llngStart + 1
			lbolFound = True

			Exit For			

		End If

	Next

	' return span value	
	If lbolFound Then
		wsGetSpanValue2 = llngSpan
	Else
		wsGetSpanValue2 = llngIdx - llngStart +1'+ 2
	End If

End Function


' This sub toggles the drill status of a given position/member along rows
' It should be called from within the Notify_NewRowHeader() section of a WebAnalyst Notifications file
Sub wsMergeRowHeaders(ByVal lngColIndex, ByVal strMemberProperties, ByRef strTextBefore, ByRef strTextCell, ByRef strClassCell, ByRef strTooltip, ByRef strTextAfter, ByRef bolCancel)

	Dim lintDepth
	Dim lstrIncrement
	Dim lintCount
	Dim lbolExpanded
	Dim llngDimCnt
	Dim lstrMemberKey
	Dim llngChildCnt
	Dim llngRowSpan
	Dim lbolWebPopup

	' test wether attributes have been enabled
	Dim lbolEnabled
	On Error Resume Next
	If Context("@MERGEROWS") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	If (lbolEnabled = False Or Err.Number<>0) Then Exit Sub
	On Error Goto 0

	' this is to cancel the creation of a regular header by WebAnalyst 	
	bolCancel = True

	' count dimensions along the rows axis and size global array holding row headers accordingly
	llngDimCnt = Context("Cellset").Axes(1).DimensionCount	
	' this module-level array is used to store row headers in order to handle captions merging correctly
	Redim Preserve mstrPrevHeaders(llngDimCnt - 1)

	' gather information about the current member: level depth, drilled status, child count, member key
	lintDepth = Context("Cellset").Axes(1).Positions(mlngCurRow).Members(lngColIndex).LevelDepth
	lbolExpanded = Context("Cellset").Axes(1).Positions(mlngCurRow).Members(lngColIndex).DrilledDown
	llngChildCnt = Context("Cellset").Axes(1).Positions(mlngCurRow).Members(lngColIndex).ChildCount
	lstrMemberKey = Context("Cellset").Axes(1).Positions(mlngCurRow).Members(lngColIndex).UniqueName

	' determine row span value to handle captions merging correctly
	If lngColIndex < llngDimCnt - 1 Then
		' the wsGetSpanValue2() function should be available in the current script
		llngRowSpan = wsGetSpanValue2(1, mlngCurRow, lngColIndex) '+ 1
	Else
		' by default use a span value of 1
		llngRowSpan = 1
	End If


	' set Depth and member key for current member
	'lstrIMGDrill = replace(lstrIMGDrill, "@DP@", lintDepth)
	'lstrIMGDrill = replace(lstrIMGDrill, "@UQ@", lstrMemberKey)

	' create increment for current header based on current level depth
	lstrIncrement=""
	For lintCount = 0 To lintDepth-1
		lstrIncrement = lstrIncrement & "&nbsp;&nbsp;&nbsp;"
	Next

	' a new row header gets created only if it is different from previous one
	If strTextCell <> mstrPrevHeaders(lngColIndex) Or lngColIndex = llngDimCnt - 1 Then

		' build entire <td> for row header to be returned to WebAnalyst when exiting the Notify_NewRowHeader() sub
		'strTextBefore = "<td rowspan=@RS@ title=@TT@ class=""@CL@"">@INCR@@IMG@&nbsp;@MBR@</td>" 
		strTextBefore = "<td rowspan=@RS@ title=@TT@ class=""@CL@"">@INCR@&nbsp;@MBR@</td>" 
		strTextBefore = Replace(strTextBefore, "@RS@", llngRowSpan)
		strTextBefore = Replace(strTextBefore, "@CL@", strClassCell)
		'strTextBefore = Replace(strTextBefore, "@IMG@", lstrIMGDrill)
		strTextBefore = Replace(strTextBefore, "@MBR@", strTextCell)
		strTextBefore = Replace(strTextBefore, "@INCR@", lstrIncrement)
		If Left(strTooltip,1) = "'" Then strTooltip = Mid(strTooltip, 2)
		If Right(strTooltip,1) = "'" Then strTooltip = Left(strTooltip, Len(strTooltip)-1)
		strTextBefore = Replace(strTextBefore, "@TT@", """" & strTooltip & """")

	End If

	' store current row header to handle captions merging for next loop
	mstrPrevHeaders(lngColIndex) = strTextCell

End Sub


' This sub toggles the drill status of a given position/member along columns
' It should be called from within the Notify_NewRowHeader() section of a WebAnalyst Notifications file
Sub wsMergeColumnHeaders(ByVal lngColIndex, ByVal strMemberProperties, ByRef strTextBefore, ByRef strTextCell, ByRef strClassCell, ByRef strTooltip, ByRef strTextAfter, ByRef bolCancel)

	Dim lstrIMGDrill
	Dim lintDepth
	Dim lstrIncrement
	Dim lintCount
	Dim lbolExpanded
	Dim lstrDrilledDown
	Dim llngMemberID
	Dim llngParentID
	Dim lstrCurTD
	Dim lstrMemberKey
	Dim llngChildCnt
	Dim llngColSpan
	Dim llngDimCnt
	Dim lstrMenuMember
	Dim lstrCurUQ
	Dim lbolWebPopup

	' test wether attributes have been enabled
	Dim lbolEnabled
	On Error Resume Next
	If Context("@MERGECOLS") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	If (lbolEnabled = False Or Err.Number<>0) Then Exit Sub
	On Error Goto 0

	On Error Resume Next
	If Context("@WEBPOPUP") = 1 Then
		lbolWebPopup = True
	Else
		lbolWebPopup = False
	End If
	On Error Goto 0

	' display filters popup menu
	'lstrMenuMember="<img class=owimgorder src=""" & lstrORDERIMG  & """ onclick=""toggleM('@UQ@')"" width=14 height=11>"

	' init columns counter
	If lngColIndex=0 then
		mlngCurCol = 0
	End If

	' this is to cancel the creation of a regular header by WebAnalyst 	
	bolCancel = True

	' count dimensions along the rows axis and size global array holding row headers accordingly
	llngDimCnt = Context("Cellset").Axes(0).DimensionCount	

	' this module-level array is used to store column headers in order to handle captions merging correctly
	Redim Preserve mstrPrevHeaders(llngDimCnt - 1)

	' gather information about the current member: level depth, drilled status, child count, member key
	lintDepth = Context("Cellset").Axes(0).Positions(lngColIndex).Members(mlngRowCount-1).LevelDepth
	lbolExpanded = Context("Cellset").Axes(0).Positions(lngColIndex).Members(mlngRowCount-1).DrilledDown
	llngChildCnt = Context("Cellset").Axes(0).Positions(lngcolIndex).Members(llngDimCnt + mlngCurRow).ChildCount
	lstrMemberKey = Context("Cellset").Axes(0).Positions(lngColIndex).Members(llngDimCnt + mlngCurRow).UniqueName

	' determine colspan value to handle captions merging correctly
	If mlngCurRow < - 1 Then
		llngColSpan = wsGetSpanValue2(0, lngColIndex, llngDimCnt + mlngCurRow)
	Else
		llngcolSpan = 1
	End If


	' set Depth and member key for current member
	'lstrIMGDrill = replace(lstrIMGDrill, "@DP@", lintDepth)
	lstrCurUQ = Context("Cellset").Axes(0).Positions(lngColIndex).Members(mlngRowCount-1).uniquename
	lstrIMGDrill = replace(lstrIMGDrill, "@UQ@", lstrCurUQ)
	'lstrMenuMember = Replace(lstrMenuMember, "@UQ@", lstrCurUQ,1,1,0)

	' create increment for current header based on current level depth
	lstrIncrement=""
	For lintCount = 0 To lintDepth-1
		lstrIncrement = lstrIncrement & "&nbsp;&nbsp;"
	Next

	' a new row header gets created only if it is different from previous one
	If strTextCell <> mstrPrevHeaders(llngDimCnt + mlngCurRow) Or mlngCurRow = - 1 Then

		' build entire <td> for row header to be returned to WebAnalyst when exiting the Notify_NewRowHeader() sub
		strTextBefore = "<td colspan=""@CS@"" title=@TT@ class=""@CL@"" id=""@ID@""><table class=""@CL@"" width=100% cellpadding=0 cellspacing=0><tr><td>@INCR@&nbsp;@MBR@<td align=right>@MEN@</td></tr></table></td>" 
		strTextBefore = Replace(strTextBefore, "@ID@", CStr(lstrMemberKey))
		strTextBefore = Replace(strTextBefore, "@CS@", CStr(llngColSpan))
		strTextBefore = Replace(strTextBefore, "@CL@", strClassCell)
		'strTextBefore = Replace(strTextBefore, "@IMG@", lstrIMGDrill)
		strTextBefore = Replace(strTextBefore, "@MBR@", strTextCell)
		strTextBefore = Replace(strTextBefore, "@INCR@", lstrIncrement)
		strTextBefore = Replace(strTextBefore, "@MEN@", lstrMenuMember)
		If Left(strTooltip,1) = "'" Then strTooltip = Mid(strTooltip, 2)
		If Right(strTooltip,1) = "'" Then strTooltip = Left(strTooltip, Len(strTooltip)-1)
		strTextBefore = Replace(strTextBefore, "@TT@", """" & strTooltip & """")

	End If

	' store current row header to handle captions merging for next loop
	mstrPrevHeaders(llngDimCnt + mlngCurRow) = strTextCell

	' increasecolumns counter
	mlngCurCol = mlngCurCol + 1

End Sub

