/* Activate columns freezing */
// var bolFreezeColumns = true;		defined in asp and aspx template
/* Activate rows freezing */
// var bolFreezeRows = true;			defined in asp and aspx template

/* This will adjust the columns header position 
 * if the cells are contained in a element 
 * with a margin or a padding */
var GlobalTopMarginAdjust = -2;
/* This will adjust the row header position 
 * if the cells are contained in a element 
 * with a margin or a padding */
var GlobalLeftMarginAdjust = 0;

/* the size in pixel of a scrollbar, 16 seems to work fine in IE and Mozilla*/
var InnerScrollBarSize = 21;

/* private variable, please don't modify */
var InnerTopLeftCellZIndex = null;
var InnerTopLeftCellBackGroundColor = null;

function initFreeze(){
	fixScrollableBounds();
	var scrollArea = document.getElementById("olapdivdttable");
	if (scrollArea!=null)
	{
		scrollArea.onscroll = scrollDataGridHeader;
	}
	document.getElementById("datacell").cellSpacing=0;
	document.getElementById("datacell").cellPadding=0;
}

/* Defines scrollable area bounds 
 * This can't be done throught CSS as size in % do not work.
 */
function fixScrollableBounds(){
	var scrollArea = document.getElementById("olapdivdttable");
	if (scrollArea!=null)
	{
		scrollArea.style.height = document.body.clientHeight - findYPosition(scrollArea) - InnerScrollBarSize + "px";
		scrollArea.style.width = document.body.clientWidth - findXPosition(scrollArea) - InnerScrollBarSize + "px";
	}
}

function scrollDataGridHeader(e){
	if (!e) 
		e = window.event;

	if(bolFreezeColumns == true || bolFreezeRows == true){
	
		var divObj = e.srcElement || e.target.parentNode;
		var tdsArray = divObj.getElementsByTagName('TD');
		
		for(i = 0; i < tdsArray.length; i++){
			/* scrolling columns Headers */
			if((tdsArray[i].className == "owcolumnheader") && (bolFreezeColumns == true))
				tdsArray[i].style.top = divObj.scrollTop + GlobalTopMarginAdjust;
			
			/* scrolling top left cell */
			if((tdsArray[i].className == "owtopleftcell") && (bolFreezeColumns == true)){
				tdsArray[i].style.top = divObj.scrollTop + GlobalTopMarginAdjust;
				tdsArray[i].style.left = divObj.scrollLeft + GlobalLeftMarginAdjust;
				
				/* store initial Z-Index */
				if(InnerTopLeftCellZIndex == null)
					InnerTopLeftCellZIndex = tdsArray[i].style.zIndex;
					
				/* store initial background color */
				if(InnerTopLeftCellBackGroundColor == null)
					InnerTopLeftCellBackGroundColor = tdsArray[i].style.backgroundColor;
				
				/* restore initial values. */	
				if((divObj.scrollTop == 0) && (divObj.scrollLeft == 0)){
					tdsArray[i].style.zIndex = InnerTopLeftCellZIndex;
					tdsArray[i].style.backgroundColor = InnerTopLeftCellBackGroundColor;
				}
				
				else{
					tdsArray[i].style.zIndex = 100;
					tdsArray[i].style.backgroundColor = "#f8f9f8";
				}
			}
			
			/* scrolling rows headers */
			if((tdsArray[i].className == "owrowheader") && (bolFreezeRows == true))
				tdsArray[i].style.left = divObj.scrollLeft + GlobalLeftMarginAdjust;
		}
		
	}
}

/* Find Y coordinate of an element */
function findYPosition(obj){
	var topY = 0;
	
	if (obj.offsetParent){
		while (obj.offsetParent){
			topY += obj.offsetTop
			obj = obj.offsetParent;
		}
	}
	else if (obj.y)
		topY += obj.offsetTop
	return topY;
}

/* Find X coordinate of an element */
function findXPosition(obj){
	var topX = 0;
	
	if (obj.offsetParent){
		while (obj.offsetParent){
			topX += obj.offsetLeft;
			obj = obj.offsetParent;
		}
	}
	else if (obj.x)
		topX += obj.offsetLeft;
	return topX;
}