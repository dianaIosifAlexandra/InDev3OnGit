' --- File Name:	wsAttributes.vbs script
' --- Version:		v2.1.08
' --- Date:		2003/03/13
' --- Last updated:	2005/01/10
' --- Author:		WINSIGHT
' --- Support:		support@winsight.fr
' --- Web:		www.winsight.fr
' --- Copyright:	(c) WINSIGHT, 2003-2005
' --- Comments:		Implementation of support for member properties in WebAnalyst

' This module-level variable is used to store the number of member properties on rows (useful to give the correct width to the top left cell)
' It should be defined at the top of a WebAnalyst Notifications script
Dim mlngRowAttributesCnt


' This function adjusts the width of the top left cell of a WebReporter report to the number of additional columns based on member properties on the rows axis
' It should be called from within the Notify_TopLeftCell() sub af a WebReporter
' It can be placed anywere in a WebAnalyst Notifications script
Function wsAdjustTopLeftCell(ByRef strDisplay, ByRef bytColspan, ByRef bytRowspan, ByRef bolCancel)

	Dim llngIdx

	mlngRowAttributesCnt = 0

	' get total number of member properties for all members on rows axis
	For llngIdx = 0 To Context("CellSet").Axes(1).Positions(0).Members.Count - 1

		' update module-level variable to reflect number of member properties for each member of the 1st position on the rows axis (assuming all positions have same number of properties)
		mlngRowAttributesCnt = mlngRowAttributesCnt + Context("CellSet").Axes(1).Positions(0).Members(llngIdx).Properties.Count

	Next	

	' adjust width of top left cell accordingly
	bytColSpan = bytColSpan + mlngRowAttributesCnt

End Function


' This function takes a string that represents a property=value pair, and returns it in a user-friendly format, as well as the property's name and value, separatly
' It is being used in the wsEnableAttributes() sub
' It can be placed anywere in a WebAnalyst Notifications script
Function wsTrimProperty(ByVal strProperty, ByRef strName, ByRef strValue)

	Dim llngPos
	Dim lstrText

	' first detect the equal sign
	llngPos = Instr(strProperty, "=")
	If llngPos > 0 Then

		' return property only if value not empty
		If Trim(Mid(strProperty, llngPos + 1)) <> "" Then

			' return property's name using the 1st ByRef argument
			strName = Trim(Left(strProperty, llngPos - 1))

			' return property's value using the 2nd ByRef argument
			strValue = Trim(Mid(strProperty, llngPos + 1))

			' then detect the last dot on the left-hand side of the equal sign
			llngPos = InstrRev(strProperty, ".", llngPos - 1)
			If llngPos > 0 Then

				' finally, trim the left-hand part of the property's name
				lstrText = Mid(strProperty, llngPos + 1)

			End If			

			' trim the suare brackets around the property's name
			lstrText = Replace(lstrText, "[", "")
			lstrText = Replace(lstrText, "]", "")

		End If

	End If

	' return the trimmed property/value pair
	wsTrimProperty = lstrText

End Function



' This function gets a semi-column delimited list of property=value pairs from WebReporter, and based on it builds either row headers tooltips (intMode=1), additional report columns (intMode=2), or both
' It uses the wsTrimProperty() function above and should be called from within the WebAnalyst Notify_NewRowHeader() sub
Private Sub wsEnableAttributes(ByVal intMode, ByVal intAxis, ByVal strDefaultText, ByVal strMemberProperties, ByRef strTooltip, ByRef strTextAfter, ByRef lngCount)

	Dim lastrProperties
	Dim lastrPropertyValues()
	Dim lastrPropertyNames()
	Dim llngIdx
	Dim llngCnt
	Dim lstrProperties
	Dim llngPos
	Dim lstrText
	
	' test wether attributes have been enabled
	Dim lbolEnabled
	On Error Resume Next
	If Context("@ATTRIBUTES") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	If (lbolEnabled = False Or Err.Number <> 0) Then Exit Sub
	On Error Goto 0

	' get array of all member properties on the rows axis
	lastrProperties = Split(strMemberProperties,";")

	' get total number of member properties on the rows axis
	llngCnt = UBound(lastrProperties)

	' prepare new arrays to store member property names & values only (useful when in mode 2 = display attributes as columns)
	Redim lastrPropertyNames(llngCnt - 1)
	Redim lastrPropertyValues(llngCnt - 1)
	lstrProperties = strTooltip & vbCrLf

	' get user-defined member properties only (eight first properties for each member are system-reserved)
	For llngIdx = 8 To llngCnt

		' get at the same time property=value pairs, names and corresponding values
		lstrText = wsTrimProperty(lastrProperties(llngIdx), lastrPropertyNames(llngIdx-8), lastrPropertyValues(llngIdx-8))

		If lstrText <> "" Then
			lstrProperties = lstrProperties & lstrText
			If llngIdx < llngCnt Then lstrProperties = lstrProperties & vbCrLf
		End If

	Next

	' return default text if no attributes to display
	If Trim(lstrProperties) = "" Then
		' if default text specified, use it
		If Trim(strDefaultText) <> "" Then
			lstrProperties = strDefaultText
		' otherwise use tooltip's original value
		Else
			lstrProperties = strTooltip
		End If
	End If

	' display member properties as tooltips if option 1 is selected
	If (intMode = 1 Or intMode = 3) Then
		strTooltip = "'" & lstrProperties & "'"
	End If

	' ability to display member properties as additional columns is valid only for member properties on the ROWS axis
	If intAxis = 1 Then

		' display member properties as columns if option 2 is selected
		If (intMode = 2 Or intMode = 3) Then

			For llngIdx = 0 To llngCnt - 8

				' add columns to display member properties
				strTextAfter = strTextAfter & "<td class=owrowheader " & "title='" &  lastrPropertyNames(llngIdx) & "'>" & lastrPropertyValues(llngIdx)

			Next
	
		End If

	End If

	' return count of member properties found
	lngCount = llngCnt - 8

End Sub


