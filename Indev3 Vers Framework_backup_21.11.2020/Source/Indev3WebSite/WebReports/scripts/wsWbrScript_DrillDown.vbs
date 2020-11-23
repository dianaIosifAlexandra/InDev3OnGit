' --- File Name:	wsDrillDown.vbs script
' --- Version:		v2.1.08
' --- Date:		2003/03/04
' --- Last Updated:	2005/01/10
' --- Author:		WINSIGHT
' --- Support:		support@olapwebhouse.com
' --- Web:		www.olapwebhouse.com
' --- Copyright:	(c) WINSIGHT, 2003-2005
' --- Comments:		Implementation of drill-up/down for WebAnalyst

' These module-level variables are use to keep track of report-wide information
' They should be defined at the top of a WebAnalyst Notifications script 
Dim mlngCurRow
Dim mlngRowCount
Dim mlngCurCol
Dim mlngParents()
Dim mstrPrevHeadersCols()
Dim mstrPrevHeadersRows()


' These constants point to the icons used for drill up/down anf filtering on columns
' They should be defined at the top of a WebAnalyst Notifications script
Const lstrEXPANDIMG = "./images/expand.gif"
Const lstrCOLLAPSEIMG = "./images/collapse.gif"

' These constants determine the maximum number of characters to display for row/column headers (0 = unlimited size)
Const llngHEADERMAXSIZEROW = 25
Const llngHEADERMAXSIZECOL = 25

' These constants determine whether row/column headers spaces should be replaced with non-breakable spaces (0 = standard spaces / 1 = non-breakable spaces)
Const lintHEADERNBSPROW = 1
Const lintHEADERNBSPCOL = 0


' This function handles headers merging on a given axis
' It is being used in the wsToggleDrillRows()/wsToggleDrillColumns() subs
' It can be placed anywere in a WebAnalyst Notifications script
Function wsGetSpanValue(intAxis, lngPosition, intMember)

	Dim lstrCaption
	Dim llngCnt
	Dim llngIdx
	Dim lbolFound
	Dim llngStart
	Dim llngSpan

	' get current member's FULL PATH (WARNING! The parameters to the algorithm are flipped for rows/cols)
	If (intAxis = 0) Then
		lstrCaption = wsGetCrossPath(intAxis, lngPosition, intMember)
	Else
		lstrCaption = wsGetCrossPath(intAxis, intMember, lngPosition)
	End If

	' get number of positions along axis
	llngCnt = Context("CellSet").Axes(intAxis).Positions.Count - 1

	' start reviewing the next captions along current axis
	llngStart = lngPosition + 1
	lbolFound = False

	'WARNING! The parameters to the algorithm are flipped for rows/cols
	For llngIdx = llngStart To llngCnt

		If (intAxis = 0) Then

			' compare each FULL PATH below current member to current one
			If (wsGetCrossPath(intAxis, llngIdx, intMember) <> lstrCaption) Then

			' if same caption is found below current one, increment span then exit loop				
			llngSpan = llngIdx - llngStart + 1
			lbolFound = True

			Exit For			

			End If

		Else

			' compare each FULL PATH below current member to current one
			If (wsGetCrossPath(intAxis, intMember, llngIdx) <> lstrCaption) Then

				' if same caption is found below current one, increment span then exit loop				
				llngSpan = llngIdx - llngStart + 1
				lbolFound = True

				Exit For			

			End If

		End If

	Next

	' return span value	
	If lbolFound Then
		wsGetSpanValue = llngSpan
	Else
		wsGetSpanValue = llngIdx - llngStart +1
	End If

End Function


' This function computes the full path to a member from a given row on a given axis and returns a pipe-separeted list of member captions
' It is being used in the wsToggleDrillRows()/wsToggleDrillColumns() subs
' It can be placed anywere in a WebAnalyst Notifications script
Function wsGetCrossPath(ByVal intAxis, ByVal lngColIdx, ByVal lngRowIdx)

	Dim llngIdx
	Dim lstrPath

	' get path for COLUMNS
	If (intAxis = 0) Then

		For llngIdx = 0 To lngRowIdx
			lstrPath =  lstrPath & Context("Cellset").Axes(intAxis).Positions(lngColIdx).Members(llngIdx).Caption & "|"
		Next

	' get path for ROWS
	Else

		For llngIdx = 0 To lngColIdx
			lstrPath = lstrPath & Context("Cellset").Axes(intAxis).Positions(lngRowIdx).Members(llngIdx).Caption & "|"
		Next

	End If

	If Trim(lstrPath) <> "" Then
		wsGetCrossPath = Left(lstrPath, Len(lstrPath) - 1)
	End If

End Function


' This sub toggles the drill status of a given position/member along rows
' It should be called from within the Notify_NewRowHeader() section of a WebAnalyst Notifications file
Sub wsToggleDrillRows(ByVal lngColIndex, ByVal strMemberProperties, ByRef strTextBefore, ByRef strTextCell, ByRef strClassCell, ByRef strTooltip, ByRef strTextAfter, ByRef bolCancel)

	Dim lstrIMGDrill
	Dim lintDepth
	Dim lstrIncrement
	Dim lintCount
	Dim lbolExpanded
	Dim llngDimCnt
	Dim lstrMemberKey
	Dim llngChildCnt
	Dim llngRowSpan
	Dim lbolWebPopup
	Dim lstrTextCell
	Dim lstrTextCellInit

	' test wether attributes have been enabled
	Dim lbolEnabled
	On Error Resume Next
	If Context("@DRILLROWS") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	' exit only if error because we need to merge headers even if drilldown is not activated
	If (Err.Number<>0) Then Exit Sub
	On Error Goto 0

	' save original header for display in tooltip
	lstrTextCellInit = strTextCell

	' handle headers ellipsis
	If (llngHEADERMAXSIZEROW > 0 And Len(lstrTextCellInit) > llngHEADERMAXSIZEROW ) Then
		lstrTextCell = Left(lstrTextCellInit, llngHEADERMAXSIZEROW) & "..."
	Else
		lstrTextCell = lstrTextCellInit
	End If

	' replace headers regular spaces with unseccable spaces and save it for display in tooltip
	If lintHEADERNBSPROW > 0 Then lstrTextCell = Replace(lstrTextCell, " ", "&nbsp;")

	' this is to cancel the creation of a regular header by WebAnalyst 	
	bolCancel = True

	' count dimensions along the rows axis and size global array holding row headers accordingly
	llngDimCnt = Context("Cellset").Axes(1).DimensionCount	
	' this module-level array is used to store row headers in order to handle captions merging correctly
	Redim Preserve mstrPrevHeadersRows(llngDimCnt - 1)

	' gather information about the current member: level depth, drilled status, child count, member key
	lintDepth = Context("Cellset").Axes(1).Positions(mlngCurRow).Members(lngColIndex).LevelDepth
	lbolExpanded = Context("Cellset").Axes(1).Positions(mlngCurRow).Members(lngColIndex).DrilledDown
	llngChildCnt = Context("Cellset").Axes(1).Positions(mlngCurRow).Members(lngColIndex).ChildCount
	lstrMemberKey = Context("Cellset").Axes(1).Positions(mlngCurRow).Members(lngColIndex).UniqueName

	' determine row span value to handle captions merging correctly
	If lngColIndex < llngDimCnt - 1 Then
		' the wsGetSpanValue() function should be available in the current script
		llngRowSpan = wsGetSpanValue(1, mlngCurRow, lngColIndex) '+ 1
	Else
		' by default use a span value of 1
		llngRowSpan = 1
	End If

	' if drilldown is enabled we must handle the expand/collapse buttons
	If (lbolEnabled = True) Then

	' if current member is currently collapsed and has children then prefix with an Expand icon and add supporting client-script 
	If lbolExpanded = False Then

		If llngChildCnt > 0 Then
			' we use different client-side functions, depending on wether WenPopup is activated or not
			'lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick='wsToggleDrillRowsSrv(""@DP@;@UQ@"");'>", "@SRC@", lstrEXPANDIMG)
			If lbolWebPopup = True Then
				lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick=""wsToggleDrillRowsSrvWP('@UQ@');"">", "@SRC@", lstrEXPANDIMG)
			Else
				lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick=""wsToggleDrillRowsSrv('@UQ@');"">", "@SRC@", lstrEXPANDIMG)
			End If
		Else
			lstrIMGDrill = ""
		End If

	' otherwise it must be already expanded and we must allow for collapse
	Else
		' we use different client-side functions, depending on wether WenPopup is activated or not
		'lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick='wsToggleDrillRowsSrv(""@DP@;@UQ@"");'>", "@SRC@", lstrCOLLAPSEIMG)
		If lbolWebPopup = True Then
			lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick=""wsToggleDrillRowsSrvWP('@UQ@');"">", "@SRC@", lstrCOLLAPSEIMG)
		Else
			lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick=""wsToggleDrillRowsSrv('@UQ@');"">", "@SRC@", lstrCOLLAPSEIMG)
		End If

	End If
	
	' set Depth and member key for current member
		lstrMemberKey = Replace(lstrMemberKey, "'","%27")
	lstrIMGDrill = replace(lstrIMGDrill, "@UQ@", replace(lstrMemberKey, "'", "\'"))
	' if drilldown is NOT enable there is no expand/collapse button but we must still handle headers merging
	Else
		lstrIMGDrill = ""
	End If

	' create increment for current header based on current level depth
	lstrIncrement=""
	For lintCount = 0 To lintDepth-1
		lstrIncrement = lstrIncrement & "&nbsp;&nbsp;&nbsp;"
	Next

	' a new row header gets created only if its FULL PATH is different from previous one
	If ( wsGetCrossPath(1, lngColIndex, mlngCurRow) <> mstrPrevHeadersRows(lngColIndex) Or lngColIndex = llngDimCnt - 1) Then

		' build entire <td> for row header to be returned to WebAnalyst when exiting the Notify_NewRowHeader() sub
		strTextBefore = "<td rowspan=@RS@ title=@TT@ class=""@CL@"">@INCR@@IMG@&nbsp;@MBR@</td>" 
		strTextBefore = Replace(strTextBefore, "@RS@", llngRowSpan)
		strTextBefore = Replace(strTextBefore, "@CL@", strClassCell)
		strTextBefore = Replace(strTextBefore, "@IMG@", lstrIMGDrill)
		strTextBefore = Replace(strTextBefore, "@MBR@", lstrTextCell)
		strTextBefore = Replace(strTextBefore, "@INCR@", lstrIncrement)
		If Left(strTooltip,1) = "'" Then strTooltip = Mid(strTooltip, 2)
		If Right(strTooltip,1) = "'" Then strTooltip = Left(strTooltip, Len(strTooltip)-1)
		' update tooltip with both members caption AND unique name to handle headers ellipsis
		strTooltip =  lstrTextCellInit &  vbCrLf & strTooltip
		strTextBefore = Replace(strTextBefore, "@TT@", """" & strTooltip & """")

	End If

	' store current FULL PATH to handle captions merging for next loop
	mstrPrevHeadersRows(lngColIndex) = wsGetCrossPath(1, lngColIndex, mlngCurRow)

End Sub


' This sub toggles the drill status of a given position/member along columns
' It should be called from within the Notify_NewRowHeader() section of a WebAnalyst Notifications file
Sub wsToggleDrillColumns(ByVal lngColIndex, ByVal strMemberProperties, ByRef strTextBefore, ByRef strTextCell, ByRef strClassCell, ByRef strTooltip, ByRef strTextAfter, ByRef bolCancel)

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
	Dim lstrTextCell
	Dim lstrTextCellInit

	' test wether attributes have been enabled
	Dim lbolEnabled
	On Error Resume Next
	If Context("@DRILLCOLS") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	' exit only if error because we need to merge headers even if drilldown is not activated
	If (Err.Number<>0) Then Exit Sub
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

	' save original header for display in tooltip
	lstrTextCellInit = strTextCell

	' handle headers ellipsis
	If (llngHEADERMAXSIZECOL > 0 And Len(lstrTextCellInit) > llngHEADERMAXSIZECOL ) Then
		lstrTextCell = Left(lstrTextCellInit, llngHEADERMAXSIZECOL) & "..."
	Else
		lstrTextCell = lstrTextCellInit
	End If

	' replace headers regular spaces with unseccable spaces and save it for display in tooltip
	If lintHEADERNBSPCOL > 0 Then lstrTextCell = Replace(lstrTextCell, " ", "&nbsp;")

	' this is to cancel the creation of a regular header by WebAnalyst 	
	bolCancel = True

	' count dimensions along the rows axis and size global array holding row headers accordingly
	llngDimCnt = Context("Cellset").Axes(0).DimensionCount	
	' this module-level array is used to store column headers in order to handle captions merging correctly
	Redim Preserve mstrPrevHeadersCols(llngDimCnt - 1)

	' gather information about the current member: level depth, drilled status, child count, member key
	lintDepth = Context("Cellset").Axes(0).Positions(lngColIndex).Members(mlngRowCount-1).LevelDepth
	lbolExpanded = Context("Cellset").Axes(0).Positions(lngColIndex).Members(mlngRowCount-1).DrilledDown
	llngChildCnt = Context("Cellset").Axes(0).Positions(lngcolIndex).Members(llngDimCnt + mlngCurRow).ChildCount
	lstrMemberKey = Context("Cellset").Axes(0).Positions(lngColIndex).Members(llngDimCnt + mlngCurRow).UniqueName

	' determine colspan value to handle captions merging correctly
	If mlngCurRow < - 1 Then
		llngColSpan = wsGetSpanValue(0, lngColIndex, llngDimCnt + mlngCurRow)
	Else
		llngcolSpan = 1
	End If

	' if drilldown is enabled we must handle the expand/collapse buttons
	If (lbolEnabled = True) Then
		' if current member is currently collapsed and has children then prefix with an Expand icon and add supporting client-script 
		If lbolExpanded = False Then

			If Context("Cellset").Axes(0).Positions(lngColIndex).Members(mlngRowCount-1).ChildCount>0 Then
			' we use different client-side functions, depending on wether WenPopup is activated or not
			'lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick='wsDrillDown(""@DP@;@UQ@"");'>", "@SRC@", lstrEXPANDIMG)
				If lbolWebPopup = True Then
					lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick=""wsToggleDrillColumnsSrvWP('@UQ@');""'>", "@SRC@", lstrEXPANDIMG)
				Else
					lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick=""wsToggleDrillColumnsSrv('@UQ@');"">", "@SRC@", lstrEXPANDIMG)
				End If
			Else
				lstrIMGDrill = ""
			End If

		' otherwise it must be already expanded and we must allow for collapse
		Else
			' we use different client-side functions, depending on wether WenPopup is activated or not
			'lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick='wsDrillUp(""@DP@;@UQ@"");'>", "@SRC@", lstrCOLLAPSEIMG)
			If lbolWebPopup = True Then
				lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick=""wsToggleDrillColumnsSrvWP('@UQ@');"">", "@SRC@", lstrCOLLAPSEIMG)
			Else
				lstrIMGDrill = replace("<img class=owimgdrill src=@SRC@ onclick=""wsToggleDrillColumnsSrv('@UQ@');"">", "@SRC@", lstrCOLLAPSEIMG)
			End If			
		End If
		
	' if drilldown is NOT enable there is no expand/collapse button but we must still handle headers merging
	Else
		lstrIMGDrill = ""
	End If

	' set Depth and member key for current member
	'lstrIMGDrill = replace(lstrIMGDrill, "@DP@", lintDepth)
	lstrCurUQ = Context("Cellset").Axes(0).Positions(lngColIndex).Members(mlngRowCount-1).uniquename
	lstrCurUQ = Replace(lstrCurUQ, "'","%27")
	lstrIMGDrill = replace(lstrIMGDrill, "@UQ@", Replace(lstrCurUQ, "'", "\'"))

	' create increment for current header based on current level depth
	'lstrIncrement=""
	'For lintCount = 0 To lintDepth-1
	'	lstrIncrement = lstrIncrement & "&nbsp;&nbsp;"
	'Next

	' a new row header gets created only if its FULL PATH is different from previous one
	If (wsGetCrossPath(0, lngColIndex, llngDimCnt + mlngCurRow) <> mstrPrevHeadersCols(llngDimCnt + mlngCurRow) Or mlngCurRow = - 1) Then

		' build entire <td> for row header to be returned to WebAnalyst when exiting the Notify_NewRowHeader() sub
		strTextBefore = "<td colspan=""@CS@"" title=@TT@ class=""@CL@"" id=""@ID@""><table class=""@CL@"" width=100% cellpadding=0 cellspacing=0><tr><td>@IMG@@INCR@&nbsp;@MBR@<td align=right>@MEN@</td></tr></table></td>" 
		strTextBefore = Replace(strTextBefore, "@ID@", CStr(lstrMemberKey))
		strTextBefore = Replace(strTextBefore, "@CS@", CStr(llngColSpan))
		strTextBefore = Replace(strTextBefore, "@CL@", strClassCell)
		strTextBefore = Replace(strTextBefore, "@IMG@", lstrIMGDrill)
		strTextBefore = Replace(strTextBefore, "@MBR@", strTextCell)
		strTextBefore = Replace(strTextBefore, "@INCR@", lstrIncrement)
		strTextBefore = Replace(strTextBefore, "@MEN@", lstrMenuMember)
		If Left(strTooltip,1) = "'" Then strTooltip = Mid(strTooltip, 2)
		If Right(strTooltip,1) = "'" Then strTooltip = Left(strTooltip, Len(strTooltip)-1)
		' update tooltip with both members caption AND unique name to handle headers ellipsis
		strTooltip =  lstrTextCellInit &  vbCrLf & strTooltip
		strTextBefore = Replace(strTextBefore, "@TT@", """" & strTooltip & """")

	End If

	' store current row header to handle captions merging for next loop
	mstrPrevHeadersCols(llngDimCnt + mlngCurRow) = wsGetCrossPath(0, lngColIndex, llngDimCnt + mlngCurRow)

	' increasecolumns counter
	mlngCurCol = mlngCurCol + 1

End Sub

