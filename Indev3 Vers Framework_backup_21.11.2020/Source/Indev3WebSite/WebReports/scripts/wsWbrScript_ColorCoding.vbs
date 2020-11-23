' --- File Name:	wsColorCoding.vbs script
' --- Version:		v2.0
' --- Date:		2003/03/04
' --- Last updated:	2005/11/02	
' --- Author:		WINSIGHT
' --- Support:		support@winsight.fr
' --- Web:		www.winsight.fr
' --- Copyright:	(c) WINSIGHT, 2003 - 2005
' --- Comments:		Implementation of server-side color-coding for WebAnalyst
' ---                   FontColor, FontName and sized have been fixed
' ---                   FontName can also be used to reference a custom Css style 

' This constant points to the icons used for drill through on data cells
' They should be defined at the top of a WebAnalyst Notifications script

' OLAP cell properties 
Const CELL_PROPERTY_FORMATTED_VALUE = "FORMATTED_VALUE"
Const CELL_PROPERTY_VALUE = "VALUE"
Const CELL_PROPERTY_FORMAT_STRING = "FORMAT_STRING"
Const CELL_PROPERTY_FORE_COLOR = "FORE_COLOR"
Const CELL_PROPERTY_BACK_COLOR = "BACK_COLOR"
Const CELL_PROPERTY_FONT_NAME = "FONT_NAME"
Const CELL_PROPERTY_FONT_SIZE = "FONT_SIZE"
Const CELL_PROPERTY_FONT_FLAGS = "FONT_FLAGS"

' font flags
Const FONT_FLAG_BOLD = &H1
Const FONT_FLAG_ITALIC = &H2
Const FONT_FLAG_UNDERLINE = &H4
Const FONT_FLAG_STRIKEOUT = &H8


' This function returns an RGB color code from a decimal color's value; notice color values obtained are an approximation so some colors may not translate correctly
' It is being used in the wsServerSideFormat() sub below
' It can be placed anywere in a WebAnalyst Notifications script
Private Function wsGetHTMLColorCode(lngCode)

	Dim lstrRedPart
	Dim lstrGreenPart
	Dim lstrBluePart

	Dim BGRColor
	BGRColor = Right("000000" & Hex(lngCode), 6)

	' build the different parts of the RGB color
	lstrRedPart = Right(BGRColor, 2)
	lstrGreenPart = Mid(BGRColor, 3, 2)
	lstrBluePart = Left(BGRColor, 2)
	' return the RGB color	
	wsGetHTMLColorCode = "#" & lstrRedPart & lstrGreenPart & lstrBluePart

End Function


' This function gets an OLAP cell property's value if available from the query, otherwise returns a default
' It is being used in the wsServerSideFormat() sub below
' It can be placed anywere in a WebAnalyst Notifications script
Private Function wsGetCellPropertyValue(oadoCell, strPropertyName, varDefaultValue)

	Dim lvarValue
    

	' handle errors when specified property cannot be found
    	On Error Resume Next
        
	' get property's value
    	lvarValue = oadoCell.Properties(strPropertyName).Value

    	If IsNull(lvarValue) Then
        	lvarValue = varDefaultValue
    	ElseIf IsEmpty(lvarValue) Then
        	lvarValue = varDefaultValue
	End If
    
    	wsGetCellPropertyValue = lvarValue
            
End Function



' This function retrieves the server-side defined formatting rules for a given cell and applies it to the current WebAnalyst data cell
' The calling script should pass a style class (strCellStyleName parameter) that does not conflict with server-side formatting rules
' It uses the wsGetHTMLColorCode() and wsGetCellPropertyValue() functions above, and can be placed anywhere in a WebAnalyst's Notifications script
Private Function wsServerSideFormat(lngColIdx, lngRowIdx, strCellText, strCellStyleName ,strCellValue,varDefaultForeColor, varDefaultBackColor, strDefaultFontName, SngDefaultFontSize)
    
	Dim lvarForeColor
    	Dim lvarBackColor
	Dim lvarFontName
    	Dim lstrFontName
    	Dim lsglFontSize
	Dim lstrFontSize
    	Dim llngFontFlags
	Dim lstrFontColor
	Dim bolFontSetting

    	Dim lstrHTML
    	Dim lstrTD	
    	Dim oAdoCellSet
    	Dim oAdoCell

	Dim llngStart
	Dim llngEnd
	Dim lstrCurClass	

	'Dim lstrFontHeaderHTML

    	Const DEFAULT_FONT_FLAGS = 0
    
       	' if property does not work, ignore
	On Error Resume Next

	' make sure we use a correct style class by default; owcellcolorcondig should be defined in the WebAnalyst skinfile with no backcolor
	If strCellStyleName = "" or strCellStyleName = "owCell" or strCellStyleName = "owCell2"  Then strCellStyleName = "owcellcolorcoding"

	' get current cellset and cell
	Set oAdoCellSet = Context("Cellset")
        Set oAdoCell = oAdoCellSet(lngColIdx,lngRowIdx)    

	' retrieve currently applied style class
	llngStart = Instr(strCellText, " class=")
	If llngStart > 0 Then
		lstrCurClass = Mid(strCellText, llngStart + 7)
		llngEnd = Instr(lstrCurClass, " ")
		If llngEnd > 0 Then
			lstrCurClass = Left(lstrCurClass, llngEnd - 1)
		End If
	End If

	
	
	lstrHTML = strCellValue
	


	lstrFontName=""
	lstrFontSize = ""
	lstrFontColor = ""
	'--- used to check if the FONT tag should be added
	bolFontSetting = False

	' set other styles 
	' set Cell Font Flags
        llngFontFlags = wsGetCellPropertyValue(oadoCell, CELL_PROPERTY_FONT_FLAGS, DEFAULT_FONT_FLAGS)
        
        If CBool(Clng(llngFontFlags) and FONT_FLAG_BOLD) Then lstrHTML = "<B>" & lstrHTML & "</B>"

        If CBool(Clng(llngFontFlags) And FONT_FLAG_ITALIC) Then lstrHTML = "<I>" & lstrHTML  & "</I>"
       	If CBool(Clng(llngFontFlags) And FONT_FLAG_UNDERLINE) Then lstrHTML = "<U>" & lstrHTML & "</U>"
	If CBool(Clng(llngFontFlags) And FONT_FLAG_STRIKEOUT) Then lstrHTML = "<S>" & lstrHTML & "</S>" 

	' set ForeColor
        lvarForeColor = wsGetCellPropertyValue(oadoCell, CELL_PROPERTY_FORE_COLOR, varDefaultForeColor)
        If Clng(lvarForeColor)<>Clng(varDefaultForeColor) Then 
			lstrFontColor = " COLOR='" & Cstr(wsGetHTMLColorCode(Clng(lvarforecolor))) & "'"
			bolFontSetting = True
	end IF
	
	       

        ' set Cell FontName
	' we already tested it in the calling function
        ' lvarFontName = wsGetCellPropertyValue(oadoCell, CELL_PROPERTY_FONT_NAME, strDefaultFontName)
	lvarFontName = strDefaultFontName
	if lvarFontName <>"" then 
		lstrFontName = " FACE='" & lvarFontName & "'"
		bolFontSetting = True
	end if
	

        ' set Cell Font Size
        lsglFontSize = wsGetCellPropertyValue(oadoCell, CELL_PROPERTY_FONT_SIZE, SngDefaultFontSize)
	If Not IsNull(lsglFontSize) and Clng(lsglFontSize)<> Clng(SngDefaultFontSize) then 
			lstrFontSize = " SIZE='" & Cstr(lsglFontSize) & "'"
			bolFontSetting=True
	end if
		
	If bolFontSetting then	lstrHTML = "<FONT" &  lstrFontName & lstrFontSize & lstrFontColor & ">" & lstrHTML & "</FONT>"        




        strCellText = Replace(strCelltext,"@#wsFMTVALUE",lstrHTML)


	' get BackColor
        lvarBackColor = wsGetCellPropertyValue(oadoCell, CELL_PROPERTY_BACK_COLOR, varDefaultBackColor)
	If Clng(lvarBackColor) = Clng(varDefaultBackColor) Then
		strCellText =  Replace(strCelltext, lstrCurClass, strCellStyleName)
	Else
		strCellText = Replace(strCelltext, lstrCurClass, strCellStyleName & " bgcolor='" & wsGetHTMLColorCode(Clng(lvarBackColor)) & "'")
	End if
 
          
         
        'Print CBool(iFontFlags And FONT_FLAG_STRIKEOUT)
       
	' return updated HTML cell
	wsServerSideFormat = strCellText
    
	' release objects
	Set oAdoCell = Nothing

End Function



' This function enables server-side color-coding for WebAnalyst
' It calls the wsServerSideFormat() function above, and should be called from within the Notify_NewCell() sub of a WebAnalyst's Notifications script
Private Sub wsEnableColorCoding(ByVal lngColIndex, ByVal lngRowIndex, ByVal strMemberProperties, ByVal varValue, ByRef strTextBefore, ByRef strFormattedValue, ByRef strClassCell, ByRef strTooltip, ByRef strTextAfter, ByRef strClassInput, ByRef bolRW, ByRef bolCancel)

	Dim llngCellIdx
	

	' test wether server-side color coding has been enabled
	Dim lbolEnabled
	Dim lvarFontName

	On Error Resume Next
	If Context("@COLORCODING") = 1 Then
		lbolEnabled = True
	Else
		lbolEnabled = False
	End If
	If (lbolEnabled = False Or Err.Number <> 0) Then Exit Sub
	
	On Error Goto 0


	'--- We get two Scenarios : 
	'    Scenario 1 : the user use the FontName to store the name of a css style (in this case the FontName begins with #ws_), in this case we simply change the cell's style
	'    Scenario 2 : the user use color coding the standard way, in this case we change the font property accordingly
	Dim intCssPosit
	
	lvarFontName=wsGetCellPropertyValue(Context("CellSet").Item(lngColIndex,lngRowIndex), CELL_PROPERTY_FONT_NAME, "")
	intCssPosit = Instr(lvarFontName,"#ws_")
	'--- Check if a css has been defined in the fontName field of the cube
	'--- but we also verify that we do not encounter a reserved Priority style
	If intCssPosit>0 and Left(strClassCell,3)<>"owP" then

		'--- we make special test here to avoid incompatibility with other browsers
		'--- FontName could be : #ws_Arial,Verdana for example
		Dim commaPosit
		commaPosit= Instr(intCssPosit,lvarFontName,",")
		If commaPosit>0 then
			strClassCell = Mid(lvarFontName,intCssPosit+4,commaPosit-(intCssPosit+4))
		else
			strClassCell = Mid(lvarFontName,intCssPosit+4)
		
		end if
		
	Else



	' this is to cancel the default cell automatically generated by WebAnalyst
	bolCancel = true
		
	
	
	' if drill-through was enabled, strTextBefore has been changed and we can apply color-coding direclty; otherwise we must build strTextBefore first coz we just cancelled the creation of current cell
	If strTextBefore  = "" Then



		' we must distinguish wether writebackhas been enabled or not
		If bolRW Then

			' get cell ordinal to use as Id for the cell when WB is enabled
			llngCellIdx = Context("CellSet").Item(lngColIndex,lngRowIndex).Ordinal

			' rebuild cell contents
			strTextBefore =  "<td class=" & strClassCell & " title='" & strTooltip & "'><INPUT class='" & strClassInput & "' id='cl" & Trim(CStr(llngCellIdx)) & "' value='" & varValue & "' onfocus='CellFocus(this);' onblur='CellBlur(this);'/></td>"

		Else

			' rebuild cell contents
			' strTextBefore =  "<td class=" & strClassCell & " title='" & strTooltip & "'>" & strFormattedValue & "</td>"
			strTextBefore =  "<td class=" & strClassCell & " title='" & strTooltip & "'>@#wsFMTVALUE</td>"

		End If
	

	End If

	' retrieve and apply server-side formatting
	 strTextBefore =  wsServerSideFormat(lngColIndex,lngRowIndex,strTextBefore,strClassCell,strFormattedValue,0,0,lvarFontName,10)
	End if
	
End Sub