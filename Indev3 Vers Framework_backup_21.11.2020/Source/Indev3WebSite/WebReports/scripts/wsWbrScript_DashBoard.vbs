' ### START OF SALES DASHBOARD SAMPLE ###

' This function creates report cells that contain up/down arrows in place of the values
' It applies only to the Sales Dashboard report
' It should be called from within the Notify_Cell() sub of a WebReporter's notification script
' It should be placed after any other notifications for that sub
Sub wsEnableDashBoard(ByVal lngColIndex, ByVal lngRowIndex, ByVal strMemberProperties, ByVal varValue, ByRef strTextBefore, ByRef strFormattedValue, ByRef strClassCell, ByRef strTooltip, ByRef strTextAfter, ByRef strClassInput, ByRef bolRW, ByRef bolCancel,Byval lngColIndexSelected,Byval dblUpperValue,byval dblLowerValue,Byval lngUpperImage,Byval lngEqualImage,Byval lngLowerImage)

	If Context("@DASHBOARD") = 1 Then

		Dim lstrImgUp,lstrImgEqual, lstrImgDown, lstrCell, lastrImgUpNames(4),lastrImgDownNames(4) ,lastrImgEqNames(4)

		lastrImgUpNames(0) = "ico-ind-a1.gif"
		lastrImgUpNames(1) = "ico-ind-b1.gif"
		lastrImgUpNames(2) = "ico-ind-c1.gif"
		lastrImgUpNames(3) = "ico-ind-d1.gif"
		lastrImgUpNames(4) = "ico-ind-e1.gif"				

		
		lastrImgDownNames(0) = "ico-ind-a3.gif"
		lastrImgDownNames(1) = "ico-ind-b3.gif"
		lastrImgDownNames(2) = "ico-ind-c3.gif"
		lastrImgDownNames(3) = "ico-ind-d3.gif"
		lastrImgDownNames(4) = "ico-ind-e3.gif"				

		lastrImgEqNames(0) = "ico-ind-a2.gif"
		lastrImgEqNames(1) = "ico-ind-b2.gif"
		lastrImgEqNames(2) = "ico-ind-c2.gif"
		lastrImgEqNames(3) = "ico-ind-d2.gif"
		lastrImgEqNames(4) = "ico-ind-e2.gif"				



		'lstrImgUp = "<img width=17px src='./Images/Up.gif'>"
		'lstrImgEqual = "<img width=17px src='./Images/Equal.gif'>"
		'lstrImgDown = "<img width=17px src='./Images/Down.gif'>"
		
		lstrImgUp = "<img width=17px src='./Images/" & lastrImgUpNames(lngUpperImage) & "'>"
		lstrImgEqual = "<img width=17px src='./Images/" & lastrImgEqNames(lngEqualImage) & "'>"
		lstrImgDown = "<img width=17px src='./Images/" & lastrImgDownNames(lngLowerImage) & "'>"
		
	
		' Replace values with arrows only for 3rd column (Store Sales Trend)
		If lngColIndex = lngColIndexSelected Then
		
			' first cancel regular cell
			bolCancel = True
			
			'use same style for all rows
			strClassCell = "owcell"


					
			If varValue <> "-" Then

					' display % of drop/increase on tooltips
					lstrCell = "<td class=" & strClassCell & " title='"
								
			

				' choose picture to display
				If CDbl(varValue) > dblUpperValue Then
					lstrCell = lstrCell & "Value increased by " & strFormattedValue & "'>" & lstrImgUp & "&nbsp;&nbsp;&nbsp;&nbsp;</td>"
				
				ElseIf CDbl(varValue) < dblLowerValue Then
					lstrCell = lstrCell & "Value increased by " & strFormattedValue & "'>" &  lstrImgDown & "&nbsp;&nbsp;&nbsp;&nbsp;</td>"
				Else
					lstrCell = lstrCell & "Value dropped by " & strFormattedValue & "'>" & lstrImgEqual & "&nbsp;&nbsp;&nbsp;&nbsp;</td>"
				End If
			End If

			' replace output text
			strTextBefore = lstrCell

		End If	
		
	End If
	
End Sub

' ### END OF SALES DASHBOARD SAMPLE ###