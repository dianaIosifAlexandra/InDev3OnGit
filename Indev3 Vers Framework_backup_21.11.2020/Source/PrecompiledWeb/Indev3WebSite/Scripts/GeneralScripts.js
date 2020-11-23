if (!document.querySelectorAll) {
    document.querySelectorAll = function (selectors) {
        var style = document.createElement('style'), elements = [], element;
        document.documentElement.firstChild.appendChild(style);
        document._qsa = [];

        style.styleSheet.cssText = selectors + '{x-qsa:expression(document._qsa && document._qsa.push(this))}';
        window.scrollBy(0, 0);
        style.parentNode.removeChild(style);

        while (document._qsa.length) {
            element = document._qsa.shift();
            element.style.removeAttribute('x-qsa');
            elements.push(element);
        }
        document._qsa = null;
        return elements;
    };
}

if (!document.querySelector) {
    document.querySelector = function (selectors) {
        var elements = document.querySelectorAll(selectors);
        return (elements.length) ? elements[0] : null;
    };
}


// JScript File
function GetInternetExplorerVersion()
// Returns the version of Internet Explorer or a -1
// (indicating the use of another browser).
{
    var rv = -1; // Return value assumes failure.
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null)
            rv = parseFloat(RegExp.$1);
    }
    return rv;
}

function SetDirty(value)
{
    var isDirty = document.getElementById('IsDirty');
    if (isDirty != null)
        isDirty.value = value;
}

function RadComboBoxSetDirty(item)
{
    SetDirty(1);
}

function RadMaskedTextBoxSetDirty(input, args)
{
    SetDirty(1);
}

function CheckDirty() 
{
    var isDirty = document.getElementById('IsDirty');
    if (isDirty.value == 1)
    {
        var answer = confirm("There are unsaved changes on this page. If you click OK you will lose all unsaved changes. Are you sure you want to close this window?");
        if (answer)
        {
            isDirty.value = 0;
            doReturn(0);
        }
    }
    else
    {
        doReturn(0);
    }
}

function IsPageDirty() 
{
    var isDirty = document.getElementById('IsDirty');
    if (isDirty.value == 1)
        return true;
    else
        return false;
}

//Verifies if there are any items selected in a listbox
function VerifySelectedItems(listBoxName)
{
    var listBox = document.getElementById(listBoxName);
    
    if (listBox.selectedIndex == -1)
    {
        alert('Select at least one WP');
        return false;
    }
    else 
       return true;
}

//When this function is added to the onkeypress event of form elements, it prevents the form from
//submitting when the user presses the ENTER key
function PreventFormValidationOnKeyPress() 
{
    return !(window.event && window.event.keyCode == 13); 
}

function doHourglass()
{
    document.body.style.cursor = 'wait';
}

function FixCombo(combo)  
{  
    combo.FixUp(combo.InputDomElement,true);
}

function SetColorDependingOnIE() {
    var elements = document.querySelectorAll(".backgroundColorIE");
    var ieVersion = GetInternetExplorerVersion();
    if (elements != null) {
        for (var i = 0; i < elements.length; i++) {
            if (ieVersion < 9 && ieVersion > 0)
                elements[i].style.backgroundColor = "#626262";
            else {
                elements[i].style.backgroundColor = "#6E6E6E";
            }
        }
    }


    var elements2 = document.querySelectorAll(".foreColorIE");
    if (elements2 != null) {
        for (var ii = 0; ii < elements2.length; ii++) {
            if (ieVersion < 9 && ieVersion > 0)
                elements2[ii].style.color = "#626262";
            else
                elements2[ii].style.color = "#6E6E6E";
        }
    }

    var elements3 = document.querySelectorAll(".background2ColorIE");
    if (elements3 != null) {
        for (var ii = 0; ii < elements3.length; ii++) {
            if (ieVersion < 9 && ieVersion > 0)
                elements3[ii].style.backgroundColor = "#6e6e6e";
            else
                elements3[ii].style.backgroundColor = "#7a7a7a";
        }
    }
	
	if (ieVersion >= 9 || ieVersion < 0)
	{
		var elements4 = document.querySelectorAll(".link")
		for (var jj=0; jj < elements4.length; jj++)
		{

			if (elements4[jj].id.match(/mnuMain_m\d$/) != null)
			{
				elements4[jj].style.backgroundColor = "#545454";
			}
		
		}
	}



}

