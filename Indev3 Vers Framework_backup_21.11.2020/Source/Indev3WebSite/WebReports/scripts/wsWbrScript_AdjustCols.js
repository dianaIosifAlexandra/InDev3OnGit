function wsRemoveTBody()
{
	var lstrTable;
	var lregExp1;
	var lregExp2;

	lstrTable = document.all("datacell").innerHTML;

	lregExp1 =/<TBODY>|<.TBODY>/ig;
	lstrTable = lstrTable.replace(lregExp1, "");
	//lregExp2 =/<TBODY>/ig;
	//document.all("datacell").innerHTML = document.all("datacell").innerHTML.replace(lregExp2, "");

	//alert(lstrTable);
	//document.all("datacell").innerHTML = lstrTable;

}

function wsToggleDrillRowsSrv(strMember)
{
	document.all("@ROWS").firstChild.value =  "ToggleDrillState(" + document.all("@ROWS").value + " , {" + strMember + "} , RECURSIVE )" ;
	document.all("@ROWS").firstChild.text = document.all("@ROWS").firstChild.value
	document.all("@ROWS").value = document.all("@ROWS").firstChild.value
	document.all("wsDynamicMenu").submit();
}


function wsToggleDrillColumnsSrv(strMember)
{
	document.all("@COLUMNS").firstChild.value =  "ToggleDrillState(" + document.all("@COLUMNS").value + " , {" + strMember + "} , RECURSIVE )" ;
	document.all("@COLUMNS").firstChild.text = document.all("@COLUMNS").firstChild.value
	document.all("@COLUMNS").value = document.all("@COLUMNS").firstChild.value
	document.all("wsDynamicMenu").submit();
}

function ToggleDrill(strEltID, intAction) {
	
	var objCurTD;
	var objCurTR;
	var objNextTR;
	var objTable;
	var lngIdx;
	var strDisplay;
	var strOldCursorStyle

	//save current cursor style then change to hourglass
	strOldCursorStyle = document.all("olapdivdttable").style.cursor;
	document.all("olapdivdttable").style.cursor = "wait";

	objCurTD = document.all(strEltID);
	objCurTR = objCurTD.parentElement; 
	objTable = objCurTR.parentElement.parentElement; 

	if (objCurTD.firstChild != null)
		{

		// if no action is specified, simply toggle current state
		if (intAction == 0)
			{
			// drill up
			if( objCurTD.firstChild.src.indexOf("Collapse") > 0)
				{
				intAction = -1;
				}
			// drill down
			else
				{ 
				intAction = 1;
				}
			}

		// action is drill down
		if (intAction > 0)
			{
			// toggle icon to reflect drill down
			objCurTD.firstChild.src = "Collapse.gif";
			// change event code for current button to prepare for next drill up
			//objCurTD.firstChild.attributes("onclick").value = objCurTD.firstChild.attributes("onclick").value.replace("1)", "-1)");
			// children must be displayed
			strDisplay = "inline";
			}
		// action is drill up
		else
			{	
			// toggle icon to reflect drill up
			objCurTD.firstChild.src = "Expand.gif";
			// change event code for current button to prepare for next drill down
			//objCurTD.firstChild.attributes("onclick").value = objCurTD.firstChild.attributes("onclick").value.replace("-1)", "1)");
			//window.alert(objCurTD.firstChild.attributes("onclick").value);
			// children must be hidden
			strDisplay = "none";
			}		

	// retrieve all nodes for which parentID = current node's id and switch their display property
	for (lngIdx=0; lngIdx < objTable.rows.length; lngIdx++)
		{
		objNextTR = objTable.rows[lngIdx];
		// first child of current TR is the TD containing the drill icon
		if (objNextTR.firstChild != null)
			{
			if( (objNextTR.firstChild.parentid == objCurTR.firstChild.id) && (objNextTR.firstChild.id != objCurTR.firstChild.id) )
				{
				objNextTR.style.display = strDisplay;
				if (intAction < 0)
					{
					ToggleDrill(objNextTR.firstChild.id, -1);
					}
				else
					{
					ToggleDrill(objNextTR.firstChild.id, -1);	
					}
				}
			}
		}
	}
	else
	{
	return;
	}	

	//change cursor back to standard
	document.all("olapdivdttable").style.cursor = strOldCursorStyle;

}

/*******************************************************************************
- wsExcelReport : fonction appelée lors du click sur l'icone d'export vers excel
	création le 20/04/2001
	auteur	: RC
	paramètre(s)
	- strID : ID de la balise qui englobe le tableau HTML à exporter necessite
	- un formulaire dont l'attribut "name" est égal à "excelform"
	- un champ de type "hidden" dont l'attribut "name" est égal à "excelreport"
	- de placer un appel à la fonction dans un lien pour soummettre le formulaire
*******************************************************************************/
function wsExcelReport(strID)
{
	//récuperer le contenu HTML du tag spécifié par l'ID passé en paramètre
	//et affecte celui-ci à l'attribut value du champs caché du formulaire
	document.excelform.excelreport.value = strID.innerHTML;
	//Envoie le formulaire
	document.excelform.submit();
}


function addTableContent(tblId, strContent) {
//works correctly only when there is a special contaner for the table. i.e. a div (example)
  var strTmp = tblId.outerHTML;
  var intPosX = strTmp.indexOf('<TABLE');
  var intPosY = strTmp.indexOf('>', intPosX);
  var strTable = strTmp.substring(intPosX, intPosY+1);

  strTable+=tblId.innerHTML+strContent+'</TABLE>'
  tblId.parentElement.innerHTML = strTable;
}

  function adjustColsFC(header,data) {
//Resize <table> columns in case of headercol is frozen and sata is in separate <div>.
//for give to cells the same width.
  
  var i, j, k;
  //for (i=0; i<header.cells.length; i++) {
  //  header.cells[i].noWrap=true;
  //}
  //divOutput.style.width=header.offsetWidth+17;

  var headerLastRow = header.rows[header.rows.length-1];   //Niveau fin
  var dataFirstRow = data.rows[0];
  var lngTopColSpan, lngBtmColSpan;
  var lngTopWidth, lngBtmWidth;
  var lngNbBtmCell;

  var oTLCell = header.rows[0].cells[0];       //Top Left Cell object of header <table>
  oTLCell.noWrap=true;                         //necessary. otherwise width attribute is not reflected
  lngTopColSpan=oTLCell.colSpan;
  lngTopWidth=oTLCell.offsetWidth;

  lngNbBtmCell=0; j=0; lngBtmWidth=0;
  while (j<lngTopColSpan) {
    j+=dataFirstRow.cells[lngNbBtmCell].colSpan;
    lngBtmWidth+=dataFirstRow.cells[lngNbBtmCell].offsetWidth;
    lngNbBtmCell++;
  }

  if (lngTopWidth>lngBtmWidth) {
    for (k=0; k<lngNbBtmCell; k++) {
      dataFirstRow.cells[k].width=(dataFirstRow.cells[k].offsetWidth)*(lngTopWidth/lngBtmWidth);
    }
  }
  else {
    oTLCell.width=lngBtmWidth;
  }

  //Align cells width of the last header row with the first data header
  var lngBtmOffset = lngNbBtmCell;
  //For each cell of the last line of header <table>
  if (header.rows.length==1) {k=1} else {k=0}
  for (i=k; i<headerLastRow.cells.length; i++) {
    lngTopColSpan=headerLastRow.cells[i].colSpan;
    lngTopWidth=headerLastRow.cells[i].offsetWidth;

    lngNbBtmCell=0; j=0; lngBtmWidth=0;
    while (j<lngTopColSpan) {
      //alert(lngBtmOffset);
      j+=dataFirstRow.cells[lngBtmOffset].colSpan;
      lngBtmWidth+=dataFirstRow.cells[lngBtmOffset].offsetWidth;
      lngNbBtmCell++;
    }
    //if (i==19) alert('Ok');
    if (lngTopWidth>lngBtmWidth) {
      for (k=0; k<lngNbBtmCell; k++) {
        //alert('i>j '+ i + ', ' + (k+lngBtmOffset) + ' : ' + lngTopWidth + '>' + lngBtmWidth);
        dataFirstRow.cells[k+lngBtmOffset].width=(dataFirstRow.cells[k+lngBtmOffset].offsetWidth)*(lngTopWidth/lngBtmWidth);
        //alert(divOutput.style.width);
        //if (k+lngBtmOffset==5) dataFirstRow.cells[k+lngBtmOffset].width=150;
        //alert(divOutput.offsetWidth);
      }
    }
    else {
      headerLastRow.cells[i].width=lngBtmWidth;
    }
    lngBtmOffset+=lngNbBtmCell;
  }
  olapdivdttable.style.width=header.offsetWidth+15;
  //alert(header.style.width);
}

function adjustRows (headerRow, data){

  var oTLCell = headerRow.rows[0].cells[0]
  var oHcTBody = data.tBodies[0]

  if (data.cellSpacing=="") {
    data.cellSpacing=2;             //default value
  }

  var i;
  var intHeight;

  intHeight=0;
  for (i=0;i<oHcTBody.rows.length;i++) {
    intHeight+=parseInt(oHcTBody.rows[i].offsetHeight)+parseInt(data.cellSpacing);
  }
  intHeight-=data.cellSpacing;
  //alert(intHeight);
  oTLCell.height=intHeight;
  
  data.parentElement.style.height=parseInt(headerRow.offsetHeight)+16;
}
