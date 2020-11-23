' --- File Name:	wsDrillThrough.vbs script
' --- Version:		v2.1.08
' --- Date:		2003/03/04
' --- Last Updated:	2005/01/11
' --- Author:		WINSIGHT
' --- Support:		support@winsight.fr
' --- Web:		www.winsight.fr
' --- Copyright:	(c) WINSIGHT, 2003 - 2005
' --- Comments:		Implementation of drill-through for WebAnalyst

' This constant points to the icons used for drill through on data cells
' They should be defined at the top of a WebAnalyst Notifications script
Const lstrDRILLTHROUGHIMG = "./images/drill.gif"


' This function builds the drill-through MDX statement for a given OLAP cell
' It is being used in the wsGetDTLink() subs
' It can be placed anywere in a WebAnalyst Notifications script
Function mGetDTFormula(lngColIdx, lngRowIdx, strCube, intEncode,lngMaxRows)

	Dim lstrFormula
	Dim lstrMember
	Dim llngAxisIdx
	Dim llngDTAxisCnt
	Dim lobjCurAxis
	Dim llngIdx
	Dim llngPosIdx
	Dim llngCnt

	' exit if position is negative or cube name is not provided
	If lngColIdx < 0 Or lngRowIdx < 0 Or Trim(strCube) = "" Then Exit Function

	' initialize drill-through axes count (in DT formulas, *each Axis must bear a single member!*)
	llngDTAxisCnt = 0

	' start drill-through formula for current cell
	lstrFormula= "DRILLTHROUGH MAXROWS "  & Cstr(lngMaxRows) & " SELECT "

	' all queries must have exactly 2 axes (plus slicer)
	For llngAxisIdx = 0 To 2

		If llngAxisIdx < 2 Then

			' set current Axis object
			Set lobjCurAxis = Context("CellSet").Axes(llngAxisIdx)

			' select the appropriate index to wortk with current axis
			If llngAxisIdx = 0 Then llngPosIdx = lngColIdx Else llngPosIdx = lngRowIdx

		Else

			' last axis is the slicer
			Set lobjCurAxis = Context("CellSet").FilterAxis

		End If

		' for regular axes (e.g. rows/cols) check *current* position only
		If llngAxisIdx < 2 Then

			' number of members for each position on rows/col axis = number of dimensions on axis		
			llngCnt = lobjCurAxis.DimensionCount -1

			For llngIdx = 0 To llngCnt

				' get unique name of *each* member for *current* position
				lstrMember = lobjCurAxis.Positions(llngPosIdx).Members(llngIdx).UniqueName
			
				' concatenate element with tuple using cLBas as separators (*don't forget curly brakets!*)
				lstrFormula = lstrFormula & "{" & lstrMember & "} ON AXIS(" & llngDTAxisCnt & "),"

				'increase DT axes counter
				llngDTAxisCnt = llngDTAxisCnt + 1

			Next

		' for slicer axis check *all* positions
		Else

			' number of members for each position on slicer axis = always 1, but serveral positions
			'--- LB, Code modified to iterate on members on the single position on slicers
			llngCnt = lobjCurAxis.Positions(0).members.Count -1

			For llngPosIdx = 0 To llngCnt

				' get unique name of *single* member for *each* position
				lstrMember = lobjCurAxis.Positions(0).Members(llngPosIdx).UniqueName
			
				' if not last element, concatenate with tuple using cLBas as separators (*don't forget curly brakets!*)
				lstrFormula = lstrFormula & "{" & lstrMember & "} ON AXIS(" & llngDTAxisCnt & ")"

				If llngPosIdx < llngCnt Then
					lstrFormula = lstrFormula & ","
				End If		

				'increase DT axes counter
				llngDTAxisCnt = llngDTAxisCnt + 1

			Next

		End If

	Next

	' finish formula string with current cube name
	lstrFormula = lstrFormula & " FROM " & strCube

	' encode if required to be able to pass formula in URL
	If intEncode <> 0 Then

		lstrFormula = Replace(lstrFormula, " ", "+") 

	End If

	' release objects
	Set lobjCurAxis = Nothing

	' return cLBpleted drill-through formula for current cell
	mGetDTFormula = lstrFormula

End Function


' This function builds the URL to the drill-through page (wsDrillThrough.asp) for a given OLAP cell
' It calls the wsGetDTFormula() function above
' It can be placed anywere in a WebAnalyst Notifications script
Function wsGetDTLink(lngColIdx, lngRowIdx, strCube, strText,lngMaxRows)


	'specify the name and path of the drill-through ASP page
	Const lcstrDTPage = "wsDrillThrough.asp"
	
	Dim lstrCon
	Dim lstrFormula
	Dim lstrLink
	Dim lstrXsltSheet

	' exit if position is negative or cube name or cell text is not provided
	If lngColIdx < 0 Or lngRowIdx < 0 Or Trim(strCube) = "" Then Exit Function

	' build drill-through formula for current cell, encoding it to be able to pass as URL
	lstrFormula = mGetDTFormula(lngColIdx, lngRowIdx, strCube, 1,lngMaxRows)
	' Escape URL to handle special chars
	lstrFormula = Escape(lstrFormula)

	' get current connection string and encode it to be able to pass as URL
	lstrCon = Escape(Context("Connection").ConnectionString)

	'Handle cases when no xslt have been defined
	On Error Resume Next
	lstrXsltSheet = Context("@XSLTDRILTHROUGH")
	On Error Goto 0

	' build HTML link for current cell, based on the name of the drill-through ASP page, the DT formula just built, the current connection string and the original cell's text
	'lstrLink = "<a target=_blank href=" & lcstrDTPage & "?formula=" & lstrFormula & "&connection=" & lstrCon & "&maxrows=" & lngMaxRows & ">" & strText & "</a>"
	lstrLink = strText & "&nbsp;<a target=_blank href=" & lcstrDTPage & "?formula=" & lstrFormula & "&connection=" & lstrCon & "&maxrows=" & lngMaxRows & "&xsltsheet=" & lstrXsltSheet & ">" & "<img class=owimgdt border=0 src=" & lstrDRILLTHROUGHIMG & ">" & "</a>"

	' return HTML link that will open a new window and display drill-through data for current cell
	wsGetDTLink = lstrLink

End Function


' This function builds the URL to the drill-through page (wsDrillThrough.asp) for a given OLAP cell
' It calls the wsGetDTFormula() function above and is being used in the Notify_NewCell() sub
' It uses the wsGetDTLink() function above and should be called from within the WebAnalyst Notify_NewCell() sub
Sub wsEnableDrillThrough(ByVal lngColIndex, ByVal lngRowIndex, ByVal strMemberProperties, ByVal varValue, ByRef strTextBefore, ByRef strFormattedValue, ByRef strClassCell, ByRef strTooltip, ByRef strTextAfter, ByRef strClassInput, ByRef bolRW, ByRef bolCancel)

	Dim llngCellIdx

	' test wether drillthrough has been enabled
	Dim lbolEnabled
	On Error Resume Next
	If Context("@DRILLTHROUGH") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	If (lbolEnabled = False Or Err.Number <> 0) Then Exit Sub
	On Error Goto 0

	' this is to cancel the creation of a regular data cell by WebAnalyst
	bolCancel = True

	' handle cases when write-back is enabled and input zones are included in data cells
	If bolRW Then

		' get cell ordinal to use as Id for the cell when WB is enabled
		llngCellIdx = Context("CellSet").Item(lngColIndex,lngRowIndex).Ordinal
		' add a drill-through icon pointing to the URL determined using wsGetDTLink() and wsGetDTFormula()
		strTextBefore =  "<td class=" & strClassCell & " title='Click to drill-through on: " & strTooltip & "'><INPUT class='" & strClassInput & "' id='cl" & Trim(CStr(llngCellIdx)) & "' value='" & varValue & "' onfocus='CellFocus(this);' onblur='CellBlur(this);'/>" & wsGetDTLink(lngColIndex,mlngCurRow,Context("CubeName"), "",10) & "</td>"

	' alternatively, handle cases when write-back is disabled and data values are found directly in data cells
	Else

		' add a drill-through icon pointing to the URL determined using wsGetDTLink() and wsGetDTFormula()
		strTextBefore =  "<td class=" & strClassCell & " title='Click to drill-through on: " & strTooltip & "'>" & wsGetDTLink(lngColIndex,mlngCurRow,Context("CubeName"), strFormattedValue,10) & "</td>"

	End If

End Sub

