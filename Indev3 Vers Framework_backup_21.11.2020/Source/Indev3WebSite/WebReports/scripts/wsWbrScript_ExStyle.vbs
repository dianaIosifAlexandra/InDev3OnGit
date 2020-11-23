' --- Version:		v1.0
' --- Date:		2005
' --- Last updated:	2005/10/10	
' --- Author:		WINSIGHT
' --- Support:		support@winsight.fr
' --- Web:		www.winsight.fr
' --- Copyright:	(c) WINSIGHT, 2003 - 2005
' --- Comments:		Implementation of Extended Style definition for report
' ---                   ColumnHeader, RowHeader, Cells
' ---                   The style of report element can now be defined through
' ---			simple parameter definition in defaultparameter section
' ---			of .rpt configuration file

Dim mlngNbRow 
Dim mlngNbCol
Dim mstrLastColheader
Dim mDctStyleRowDict, mDctStyleColDict, mDctStyleRowHeaderDict, mDctStyleColHeaderDict

Sub wsEnableCellStyle(ByVal lngColIndex, ByVal lngRowIndex, ByRef strClassCell)

	Dim strRowheader
	Dim strNextRowheader
	Dim strColheader
	Dim strNextColheader
	Dim lbolEnabled

  strColheader = Context("Cellset").axes(0).positions(lngColIndex).members(0).name
  strRowheader = Context("Cellset").axes(1).positions(lngRowIndex).members(0).name
    
  If lngColIndex = (mlngNbCol-1) Then
   	strNextColheader = "NULL"
  Else
   	strNextColheader = Context("Cellset").axes(0).positions(lngColIndex+1).members(0).name
  End If
    
  If lngRowIndex = (mlngNbRow-1) Then
   	strNextRowheader = "NULL"
   Else
   	strNextRowheader = Context("Cellset").axes(1).positions(lngRowIndex+1).members(0).name
  End If

	On Error Resume Next
	
	If Context("@EXSTYLE") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	If (lbolEnabled = False Or Err.Number <> 0) Then Exit Sub
		
	strClassCell = context("@STLCEL")
		
	'cells on even rows
	If (lngRowIndex Mod 2) Then
		strClassCell = context("@STLCELROWEVN")
	Else 'cells on odd rows
		strClassCell = context("@STLCELROWODD")
	End If
	
	'cells on odd column
	If (lngColIndex Mod 2) Then
		strClassCell = context("@STLCELCOLEVN")
	Else 'cells on odd columns
		strClassCell = context("@STLCELCOLODD")
	End If
	
	'cells on first dimension column
	If (mstrLastColheader <> strColheader) Then
		strClassCell = context("@STLCELFSTDIMCOL")
	End If
	
	'cells on last dimension column
	If (strNextColheader <> strColheader) Then
		strClassCell = context("@STLCELLSTDIMCOL")
	End If
	
	'cells on first dimension row
	If (mstrLastRowheader <> strRowheader) Then
		strClassCell = context("@STLCELFSTDIMROW")
	End If
	
	'cells on last dimension row
	If (strNextRowheader <> strRowheader) Then
		strClassCell = context("@STLCELLSTDIMROW")
	End If		

	'cells on first row
	If (lngRowIndex = 0) Then
		strClassCell = context("@STLCELFSTROW")
	End If
	
	'cells on last row
	If (lngRowIndex = mlngNbRow-1) Then
		strClassCell = context("@STLCELLSTROW")
	End If
	
	'cells on fisrt column
	If (lngColIndex = 0) Then
		strClassCell = context("@STLCELFSTCOL")
	End If
	
	'cells on last column
	If (lngColIndex = mlngNbCol-1) Then
		strClassCell = context("@STLCELLSTCOL")
	End If
	
	If lngColIndex = (mlngNbCol-1) Then mstrLastRowheader = strRowheader End If
	
	mstrLastColheader = strColheader
		
	'handle Styles for specified row number		
	If mDctStyleRowDict.Exists(CStr(lngRowIndex)) Then
		strClassCell = mDctStyleRowDict.item(CStr(lngRowIndex))
	End If
	
	'handle Styles for specified column number		
	If mDctStyleColDict.Exists(CStr(lngColIndex)) Then
		strClassCell = mDctStyleColDict.item(CStr(lngColIndex))
	End If

End Sub

Sub wsEnableColHeaderStyle(ByVal lngColIndex, ByVal lngRowIndex, ByRef strClassCell)

	Dim strNextRowheader
	Dim strColheader
	Dim strNextColheader
	Dim lbolEnabled

	On Error Resume Next
	If Context("@EXSTYLE") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	If (lbolEnabled = False Or Err.Number <> 0) Then Exit Sub End If
		
  strColheader = Context("Cellset").axes(0).positions(lngColIndex).members(0).name
  strRowheader = Context("Cellset").axes(1).positions(lngRowIndex).members(0).name
    
  If lngColIndex = (mlngNbCol-1) Then
   	strNextColheader = "NULL"
  Else
   	strNextColheader = Context("Cellset").axes(0).positions(lngColIndex+1).members(0).name
  End If
    
  If lngRowIndex = (mlngNbRow-1) Then
   	strNextRowheader = "NULL"
   Else
   	strNextRowheader = Context("Cellset").axes(1).positions(lngRowIndex+1).members(0).name
  End If
  
  strClassCell = context("@STLCHD")
  
  'row headers on even rows
	If (lngRowIndex Mod 2) Then
		strClassCell = context("@STLCHDROWEVN")
	Else 'row headers on odd rows
		strClassCell = context("@STLCHDROWODD")
	End If
	
	'row headers on odd column
	If (lngColIndex Mod 2) Then
		strClassCell = context("@STLCHDCOLEVN")
	Else 'row headers on odd columns
		strClassCell = context("@STLCHDCOLODD")
	End If
	
	'row headers on first dimension 
	If (mstrLastColheader <> strColheader) Then
		strClassCell = context("@STLCHDFSTDIMCOL")
	End If
	
	'row headers on last dimension column
	If (strNextColheader <> strColheader) Then
		strClassCell = context("@STLCHDLSTDIMCOL")
	End If

	'row headers on first row
	If (lngRowIndex = -Context("Cellset").axes(0).positions(lngColIndex+1).members.count) Then
		strClassCell = context("@STLCHDFSTROW")
	End If
	
	'row headers on last row
	If (lngRowIndex = -1) Then
		strClassCell = context("@STLCHDLSTROW")
	End If
	
	'row headers  on fisrt column
	If (lngColIndex = 0) Then
		strClassCell = context("@STLCHDFSTCOL")
	End If
	
	'row headers  on last column
	If (lngColIndex = Context("Cellset").axes(0).positions.count) Then
		strClassCell = context("@STLCHDLSTCOL")
	End If
	
	'handle Styles for specified column number		
	If mDctStyleColHeaderDict.Exists(CStr(lngColIndex)) Then
		strClassCell = mDctStyleColHeaderDict.item(CStr(lngColIndex))
	End If
	
	If lngColIndex = (mlngNbCol-1) Then mstrLastRowheader = strRowheader End If
	
	mstrLastColheader = strColheader

End Sub

Sub wsEnableRowHeaderStyle(ByVal lngColIndex, ByVal lngRowIndex, ByRef strClassCell)

	Dim strNextRowheader
	Dim strColheader
	Dim strNextColheader
	Dim lbolEnabled

	On Error Resume Next
	If Context("@EXSTYLE") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	If (lbolEnabled = False Or Err.Number <> 0) Then Exit Sub
		

  strColheader = Context("Cellset").axes(0).positions(lngColIndex).members(0).name
  strRowheader = Context("Cellset").axes(1).positions(lngRowIndex).members(0).name
    
  If lngColIndex = (mlngNbCol-1) Then
   	strNextColheader = "NULL"
  Else
   	strNextColheader = Context("Cellset").axes(0).positions(lngColIndex+1).members(0).name
  End If
    
  If lngRowIndex = (mlngNbRow-1) Then
   	strNextRowheader = "NULL"
   Else
   	strNextRowheader = Context("Cellset").axes(1).positions(lngRowIndex+1).members(0).name
  End If
  
  strClassCell = context("@STLRHD")
  
  'row headers on even rows
	If (lngRowIndex Mod 2) Then
		strClassCell = context("@STLRHDROWEVN")
	Else 'row headers on odd rows
		strClassCell = context("@STLRHDROWODD")
	End If
	
	'row headers on odd column
	If (lngColIndex Mod 2) Then
		strClassCell = context("@STLRHDCOLEVN")
	Else 'row headers on odd columns
		strClassCell = context("@STLRHDCOLODD")
	End If
	
	'row headers on first dimension row
	If (mstrLastRowheader <> strRowheader) Then
		strClassCell = context("@STLRHDFSTDIMROW")
	End If
	
	'row headers on last dimension row
	If (strNextRowheader <> strRowheader) Then
		strClassCell = context("@STLRHDLSTDIMROW")
	End If	

	'row headers on first row
	If (lngRowIndex = 0) Then
		strClassCell = context("@STLRHDFSTROW")
	End If
	
	'row headers on last row
	If (lngRowIndex = mlngNbRow-1) Then
		strClassCell = context("@STLRHDLSTROW")
	End If
	
	'row headers  on fisrt column
	If (lngColIndex = 0) Then
		strClassCell = context("@STLRHDFSTCOL")
	End If
	
	'row headers  on last column
	If (lngColIndex = Context("Cellset").axes(1).positions(lngRowIndex+1).members.count-1) Then
		strClassCell = context("@STLRHDLSTCOL")
	End If
	
	'handle Styles for specified row number		
	If mDctStyleRowHeaderDict.Exists(CStr(lngRowIndex)) Then
		strClassCell = mDctStyleRowHeaderDict.item(CStr(lngRowIndex))
	End If
	
	If lngColIndex = (mlngNbCol-1) Then mstrLastRowheader = strRowheader End If
	
	mstrLastColheader = strColheader

End Sub


Sub wsCreateStyleDict()

	Dim arrStlArray, arrKeyArray, lngKey, lngCur

	arrKeyArray = NULL

	On Error Resume Next
	'Create dictionanary for Row styles
	arrStlArray = Split(context("@STLCELROWSTL"),",")	
	arrKeyArray = Split(context("@STLCELROWKEY"),",")
	Set mDctStyleRowDict = CreateObject("Scripting.Dictionary")
	
	lngCur = 0
	For Each lngKey in arrKeyArray	
			mDctStyleRowDict.Add lngKey, arrStlArray(lngCur)
			lngCur = lngCur+1
	Next
	
	arrKeyArray = NULL
	
	'Create dictionanary for Col styles
	arrStlArray = Split(context("@STLCELCOLSTL"),",")	
	arrKeyArray = Split(context("@STLCELCOLKEY"),",")
	Set mDctStyleColDict = CreateObject("Scripting.Dictionary")
	
	lngCur = 0
	For Each lngKey in arrKeyArray		
			mDctStyleColDict.Add lngKey, arrStlArray(lngCur)
			lngCur = lngCur+1
	Next
	
	arrKeyArray = NULL
	
	'Create dictionanary for Col header styles
	arrStlArray = Split(context("@STLCHDSTL"),",")	
	arrKeyArray = Split(context("@STLCHDKEY"),",")
	Set mDctStyleColHeaderDict = CreateObject("Scripting.Dictionary")
	
	lngCur = 0
	For Each lngKey in arrKeyArray		
			mDctStyleColHeaderDict.Add lngKey, arrStlArray(lngCur)
			lngCur = lngCur+1
	Next
	
	arrKeyArray = NULL
	
	'Create dictionanary for Row header styles
	arrStlArray = Split(context("@STLRHDSTL"),",")	
	arrKeyArray = Split(context("@STLRHDKEY"),",")
	Set mDctStyleRowHeaderDict = CreateObject("Scripting.Dictionary")
	
	lngCur = 0
	For Each lngKey in arrKeyArray	
			mDctStyleRowHeaderDict.Add lngKey, arrStlArray(lngCur)
			lngCur = lngCur+1
	Next
	
End Sub