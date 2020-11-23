' --- File Name:	wsStandard.vbs script
' --- Version:		v2.1.08
' --- Date:		2005/01/11
' --- Last Updated:	2005/01/11
' --- Author:		WINSIGHT
' --- Support:		support@olapwebhouse.com
' --- Web:		www.olapwebhouse.com
' --- Copyright:	(c) WINSIGHT, 2003-2005
' --- Comments:		Implementation of WebAnalyst basic functionalities
'			Currently these include alternate row background colors and display of formatted values in data cell tooltips

' This function handles data cells background colors
' It is called from within the Notify_NewCell() sub
' It can be placed anywere in a WebAnalyst Notifications script
Sub wsEnableCellColor(ByVal lngRowIdx, ByRef strStyle)

    If (lngRowIdx mod 2) = 0 Then strStyle = "owcell2"

End Sub


' This function handles data cells tooltips
' It is called from within the Notify_NewCell() sub
' It can be placed anywere in a WebAnalyst Notifications script
Sub wsEnableCellTooltip(ByVal lngColIdx, ByVal lngRowIdx, ByVal strFormattedValue, ByRef strTooltip)

    Dim lstrValue

    ' display formatted value in tooltip by default and (Null) if it is empty (this is especially usefull for data entry when formats are lost in editable cells)
    'lstrValue = Context("Cellset").Item(lngColIdx,lngRowIdx).FormattedValue
    lstrValue = Trim(strFormattedValue)
    If lstrValue = "" Then
    	lstrValue = " = (Null)"
    ElseIf Left(lstrValue, 1) = "<" Then
    	lstrValue = ""
    Else
    	lstrValue = " = " & lstrValue
  	End If

    ' concatenate value to existing cell coordinates in current tooltip
    strTooltip = strTooltip & lstrValue

End Sub