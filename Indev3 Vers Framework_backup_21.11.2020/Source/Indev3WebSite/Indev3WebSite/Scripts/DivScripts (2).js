// JScript File
function openDiv() {

    //var inactiveDiv = document.getElementById("ph_timingAndIntercoDiv");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
      var  inactiveDiv = document.getElementById("ctl00_ph_timingAndIntercoDiv")
    //}

    inactiveDiv.style.display = "block";

    //var div = document.getElementById("ph_PeriodMassAttr_periodMassAttributionDiv");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
     var   div = document.getElementById("ctl00_ph_PeriodMassAttr_periodMassAttributionDiv");
    //}
    div.style.display = "block";

    //var cmbStartYear = document.getElementById("ph_PeriodMassAttr_IndStartYearMonth_cmbYear_DropDownPlaceholder");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
    var    cmbStartYear = document.getElementById("ctl00_ph_PeriodMassAttr_IndStartYearMonth_cmbYear_DropDownPlaceholder");
    //}
    cmbStartYear.style.zIndex = 30000;

    //var cmbStartMonth = document.getElementById("ph_PeriodMassAttr_IndStartYearMonth_cmbMonth_DropDownPlaceholder");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
    var    cmbStartMonth = document.getElementById("ctl00_ph_PeriodMassAttr_IndStartYearMonth_cmbMonth_DropDownPlaceholder");
    //}
    cmbStartMonth.style.zIndex = 30000;

    //var cmbEndYear = document.getElementById("ph_PeriodMassAttr_IndEndYearMonth_cmbYear_DropDownPlaceholder");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
    var    cmbEndYear = document.getElementById("ctl00_ph_PeriodMassAttr_IndEndYearMonth_cmbYear_DropDownPlaceholder");
    //}
    cmbEndYear.style.zIndex = 30000;

    //cmbEndMonth = document.getElementById("ph_PeriodMassAttr_IndEndYearMonth_cmbMonth_DropDownPlaceholder");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
     var   cmbEndMonth = document.getElementById("ctl00_ph_PeriodMassAttr_IndEndYearMonth_cmbMonth_DropDownPlaceholder");
    //}
    cmbEndMonth.style.zIndex = 30000;
}

function closeDiv(event, element) {

     //div = document.getElementById("ph_PeriodMassAttr_periodMassAttributionDiv");
     //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
      var   div = document.getElementById("ctl00_ph_PeriodMassAttr_periodMassAttributionDiv");
     //}
    div.style.display = "none";

    //var inactiveDiv = document.getElementById("ph_timingAndIntercoDiv");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
    var    inactiveDiv = document.getElementById("ctl00_ph_timingAndIntercoDiv")
    //}
    inactiveDiv.style.display = "none";


    //var indStartYearMonth_cmbYear_Input = document.getElementById("ph_PeriodMassAttr_IndStartYearMonth_cmbYear_Input");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
        var indStartYearMonth_cmbYear_Input = document.getElementById("ctl00_ph_PeriodMassAttr_IndStartYearMonth_cmbYear_Input");
    //}
    indStartYearMonth_cmbYear_Input.value = "";

    //var indStartYearMonth_cmbMonth_Input = document.getElementById("ph_PeriodMassAttr_IndStartYearMonth_cmbMonth_Input");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
     var   indStartYearMonth_cmbMonth_Input = document.getElementById("ctl00_ph_PeriodMassAttr_IndStartYearMonth_cmbMonth_Input");
    //}
    indStartYearMonth_cmbMonth_Input.value = "";

    //var indEndYearMonth_cmbYear_Input = document.getElementById("ph_PeriodMassAttr_IndEndYearMonth_cmbYear_Input");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
    var    indEndYearMonth_cmbYear_Input = document.getElementById("ctl00_ph_PeriodMassAttr_IndEndYearMonth_cmbYear_Input");
    //}
    indEndYearMonth_cmbYear_Input.value = "";

    //var indEndYearMonth_cmbMonth_Input = document.getElementById("ph_PeriodMassAttr_IndEndYearMonth_cmbMonth_Input");
    //if (GetInternetExplorerVersion() > 0 && GetInternetExplorerVersion() < 9) {
    var    indEndYearMonth_cmbMonth_Input = document.getElementById("ctl00_ph_PeriodMassAttr_IndEndYearMonth_cmbMonth_Input");
    //}
    indEndYearMonth_cmbMonth_Input.value = "";

    if(event)
        event.cancelBubble = true;
}

var _startX = 0;            // mouse starting positions
var _startY = 0;
var _offsetX = 0;           // current element offset
var _offsetY = 0;
var _dragElement;           // needs to be passed from OnMouseDown to OnMouseMove
var _oldZIndex = 0;         // we temporarily increase the z-index during drag
var isFirstLoaded = 1;

function InitDragDrop(trgt) {
    if (isFirstLoaded == 1) {
        document.onmousedown = OnMouseDown;
        document.onmouseup = OnMouseUp;
        OnMouseDown(null, trgt);
        isFirstLoaded = 2;
    }
    else
        OnMouseDown(null, trgt);
}

function OnMouseDown(e, trgt) {
    // IE doesn't pass the event object
    if (e == null)
        e = window.event;

    // IE uses srcElement, others use target
    var target = e.srcElement;

    // for IE, left click == 1
    var str = target.id;

    if ((e.button == 1 && window.event != null) && (str.slice(-24) == "periodMassAttributionDiv")) {

        // grab the mouse position
        _startX = e.clientX;
        _startY = e.clientY;

        // grab the clicked element's position
        if (isFirstLoaded) {
            _offsetX = document.documentElement.clientWidth / 2;
            _offsetY = document.documentElement.clientHeight / 2;
            isFirstLoaded = 0;
        }
        else {
            _offsetX = ExtractNumber(target.style.left);
            _offsetY = ExtractNumber(target.style.top);
        }
        
        // bring the clicked element to the front while it is being dragged
        _oldZIndex = target.style.zIndex;
        target.style.zIndex = 10000;

        // we need to access the element in OnMouseMove
        _dragElement = target;

        // tell our code to start moving the element with the mouse
        document.onmousemove = OnMouseMove;
        OnMouseMove(e, target);

        // cancel out any text selections
        document.body.focus();

        // prevent text selection in IE
        document.onselectstart = function () { return false; };
        // prevent IE from trying to drag an image
        target.ondragstart = function () { return false; };
    }
}

function OnMouseMove(e, trgt) {    
    if (e == null)
        e = window.event;

    //drag code
    if(trgt != undefined)
        _dragElement = trgt;
    if (((_offsetX + e.clientX + e.clientX/6 - _startX) < window.screen.availWidth) && ((_offsetX + e.clientX + e.clientX - _startX) > 300))
        _dragElement.style.left = (_offsetX + e.clientX - _startX) + 'px';
    if (((_offsetY + e.clientY + e.clientY / 4 - _startY) < window.screen.availHeight) && ((_offsetY + e.clientY + e.clientY - _startY) > 180))
        _dragElement.style.top = (_offsetY + e.clientY - _startY) + 'px';
}

function OnMouseUp(e) {
    if (_dragElement != null) {
        _dragElement.style.zIndex = _oldZIndex;

        // we're done with these events until the next OnMouseDown
        document.onmousemove = null;
        document.onselectstart = null;
        _dragElement.ondragstart = null;

        // this is how we know we're not dragging
        _dragElement = null;
    }
}

function ExtractNumber(value) {
    var n = parseInt(value);

    return n == null || isNaN(n) ? 0 : n;
}
