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

//The following function handles paging with WebPopup
function wsPaging2() {

	alert(document.all("wsPageSelector").value);
	alert(document.all("wsPageSelector2").value);
	
	alert(document.all("@PAGING").value);

	alert(document.all("@PAGEIDX").value);
	//document.all("@PAGEIDX").firstChild.value = document.all("wsPageSelector").value;
	//document.all("@PAGEIDX").firstChild.text = document.all("@PAGEIDX").firstChild.value;

	
	document.all("@PAGING").form.submit();

}

function wsPaging(axis,action) {

	// 04/2004 Modif. Same process as drilldown (up) needed for working in .NET
	var intComboValue;

	intComboValue=0;

	if (axis=="row")  {
	
		if (action=="next" && parseInt(document.all("@PAGEIDXROW").value)<(parseInt(document.all("@MAXROW").value)-1)*parseInt(document.all("@PAGINGROW").value)) {
			intComboValue =  parseInt(document.all("@PAGEIDXROW").value) + parseInt(document.all("@PAGINGROW").value);
			// document.all("@PAGEIDXROW").value = parseInt(document.all("@PAGEIDXROW").value) + parseInt(document.all("@PAGINGROW").value);
		}
		if (action=="prev" && parseInt(document.all("@PAGEIDXROW").value)>0) {
			intComboValue =  parseInt(document.all("@PAGEIDXROW").value) - parseInt(document.all("@PAGINGROW").value);
			// document.all("@PAGEIDXROW").value = parseInt(document.all("@PAGEIDXROW").value) - parseInt(document.all("@PAGINGROW").value);
		}
		if (action=="first") {
			intComboValue = 0;
		}
		if (action=="last") {
			// document.all("@PAGEIDXROW").value = parseInt(document.all("@MAXROW").value)*parseInt(document.all("@PAGINGROW").value)
			intComboValue =  (parseInt(document.all("@MAXROW").value) - 1 )*parseInt(document.all("@PAGINGROW").value);
		}

		document.all("@PAGEIDXROW").firstChild.value = intComboValue;
		document.all("@PAGEIDXROW").firstChild.text = document.all("@PAGEIDXROW").firstChild.value;
		document.all("@PAGEIDXROW").value = document.all("@PAGEIDXROW").firstChild.value;
		document.all("@PAGEIDXROW").form.submit();
	}

if (axis=="col")

{
	if (action=="next" && parseInt(document.all("@PAGEIDXCOL").value)<(parseInt(document.all("@MAXCOL").value)-1)*parseInt(document.all("@PAGINGCOL").value)) {
		intComboValue = parseInt(document.all("@PAGEIDXCOL").value) + parseInt(document.all("@PAGINGCOL").value);
	}

	if (action=="prev" && parseInt(document.all("@PAGEIDXCOL").value)>0) {
		intComboValue = parseInt(document.all("@PAGEIDXCOL").value) - parseInt(document.all("@PAGINGCOL").value);
	}


	if (action=="first") {
		intCombovalue = 0;
	}
	
	if (action=="last") {
		intComboValue = (parseInt(document.all("@MAXCOL").value)-1)*parseInt(document.all("@PAGINGCOL").value);
	}



		document.all("@PAGEIDXCOL").firstChild.value = intComboValue;
		document.all("@PAGEIDXCOL").firstChild.text = document.all("@PAGEIDXCOL").firstChild.value;
		document.all("@PAGEIDXCOL").value = document.all("@PAGEIDXCOL").firstChild.value;
		document.all("@PAGEIDXCOL").form.submit();

}

	
}



//The following function handles client-side drill-up/down

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


//The next two functions are used when implementing server-side drill up/down WITHOUT WebPopup

function wsToggleDrillRowsSrv(strMember)
{
	var re="/\+/ig";
	var re2="/%26/ig";
	
	strMember=strMember.replace(re," ");
	strMember=strMember.replace(re2,"%");

	document.all("@ROWS").firstChild.value =  "ToggleDrillState(" + document.all("@ROWS").value + " , {" + strMember + "} , RECURSIVE )" ;
	document.all("@ROWS").firstChild.text = document.all("@ROWS").firstChild.value
	document.all("@ROWS").value = document.all("@ROWS").firstChild.value
	//document.all("wsDynamicMenu").submit();
	document.all("@ROWS").form.submit();
}


function wsToggleDrillColumnsSrv(strMember)
{
	document.all("@COLUMNS").value =  "ToggleDrillState(" + document.all("@COLUMNS").value + " , {" + strMember + "} , RECURSIVE )" ;
	document.all("@COLUMNS").form.submit();
}


//The next two functions are used when implementing server-side drill up/down WITH WebPopup

function wsToggleDrillRowsSrvWP(strMember)
{
	document.all("@ROWS").firstChild.value =  "ToggleDrillState(" + document.all("@ROWS").value + " , {" + strMember + "} , RECURSIVE )" ;
	document.all("@ROWS").text = document.all("@ROWS").firstChild.value
	document.all("@ROWS").value = document.all("@ROWS").firstChild.value
	document.all("@ROWS").form.submit();
}

function wsToggleDrillColumnsSrvWP(strMember)
{
	document.all("@COLUMNS").firstChild.value =  "ToggleDrillState(" + document.all("@COLUMNS").value + " , {" + strMember + "} , RECURSIVE )" ;
	document.all("@COLUMNS").firstChild.text = document.all("@COLUMNS").firstChild.value
	document.all("@COLUMNS").value = document.all("@COLUMNS").firstChild.value
	document.all("@COLUMNS").form.submit();
}

// OM 01/03/2003 : added support for XL export
/*******************************************************************************
- wsXLExport : fonction appelée lors du click sur l'icone d'export vers excel
	création le 20/04/2001
	auteur	: RC
	paramètre(s)
	- strID : ID de la balise qui englobe le tableau HTML à exporter necessite
	- un formulaire dont l'attribut "name" est égal à "excelform"
	- un champ de type "hidden" dont l'attribut "name" est égal à "excelreport"
	- de placer un appel à la fonction dans un lien pour soummettre le formulaire
*******************************************************************************/
function wsExcelReportFull()
{
	document.forms(0).action = "wsXLExport.asp";
	document.forms(0).target = "_blank";
	document.forms(0).submit();
	document.forms(0).action = "";
	document.forms(0).target = "";
}

function wsExcelReport(objID)
{

	//supprimer les images du tableau avant l'export
	var lstrTable = objID.innerHTML
	var re = /<img(.*?)>/ig; 
	//var lstrTableExport = lstrTable.replace(re, "");
	var lstrTableExport = lstrTable;

	//supprimer aussi les liens (drillthrough active)
	re = /<a(.*?)>(.*?)a>/ig;
	//lstrTableExport = lstrTableExport.replace(re, "");

	//supprimer aussi les champs de formulaire (write-back active)
	//Attention il faut proceder en deux fois pour recuperer la valeur de l'attribut VALUE
	re = /<INPUT(.*) value=/ig;
	//lstrTableExport = lstrTableExport.replace(re, "");
	re = /onfocus(.*?)>/ig;
	//lstrTableExport = lstrTableExport.replace(re, "");

	//supprimer le formulaire de WB
	re = /<DIV class="owdivwbbuttons" id="olapdivwbbuttons">(.*?)div>/ig;
	//lstrTableExport = lstrTableExport.replace(re, "");

	//récuperer le contenu HTML du tag spécifié par l'ID passé en paramètre
	//et affecte celui-ci à l'attribut value du champs caché du formulaire
	document.wsXLForm.wsXLExport.value = lstrTableExport;

	//Envoie le formulaire
	document.wsXLForm.submit();

}

var pValue;
var aValue = new Array();

function getWBRequest() {
  var intCell;
  var s = "";
	var wbData=document.getElementsByTagName("input");
	for(i=0;i<wbData.length;i++) {
		if(wbData[i].className=="owcellupdated") {
	    intCell=parseInt(wbData[i].id.substr(2));
	    s += wbData[i].id + "=" + wbData[i].value + ";";
		}
	}
  if (s != "") {
    s = s.substr(0, s.length-1);
  }
  return s;
}

function formSubmit() {
  document.all("WBData").value = getWBRequest();
  document.all("Action").value = "Save";
	document.all("cmdSave").form.submit();
}

function formTry() {
  document.all("WBData").value = getWBRequest();
  document.all("Action").value = "Try";
  document.all("cmdTry").form.submit();
}

function CellFocus(oTxt) {
  pValue = oTxt.value;
}

function CellBlur(oTxt) {
  if (oTxt.value != pValue) {
    oTxt.className = "owcellupdated";
  }
}
