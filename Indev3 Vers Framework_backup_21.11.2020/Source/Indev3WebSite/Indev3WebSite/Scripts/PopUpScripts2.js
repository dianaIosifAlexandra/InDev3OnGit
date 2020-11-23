// JScript File

function OnBeforeClose()
{
    var isDirty = document.getElementById('IsDirty');
    if (isDirty.value == 1)
    {
         return "There are unsaved changes on this page. If you click OK you will lose all unsaved changes.";        
    }
}

function ClearOnBeforeUnload() 
{
    window.onbeforeunload = "";
    var codeIsDirty = document.getElementById("CodeIsDirty");
    var hasActualData = document.getElementById("hdnHasActualData");

    if (codeIsDirty != null) {
        var valDirty = codeIsDirty.value;
        var valHasCode = 0;
        if (valDirty == 1) {
            if (hasActualData != null)
                valHasCode = hasActualData.value;
            if (valHasCode == 1) {
                if (!confirm("Are you sure you want to change Project Code ?")) {
                    return false;
                }
            }
        }
    }
    return true;
}

function SetOnBeforeUnload() 
{
    window.onbeforeunload = OnBeforeClose; 
}

function ShowPopUp(name, height, width, parent, sessionExpiredUrl) {
    var returnValue = window.showModalDialog(name, null, "status:no;center:yes;resizable:no;help:no;dialogHeight:" + height + "px;dialogWidth:" + width + "px");
    if (returnValue == 1) {
        window.location = parent;
        return true;
    }
    //If the cancel button is pressed
    if (returnValue == 0) {
        return false;
    }
    if (returnValue == -1) {
        window.location = sessionExpiredUrl;
        return true;
    }
    return true;
}

function ShowPopUpWithReload(name, height, width, parent, sessionExpiredUrl, doReload, targetFormForRefresh) {
    var returnValue = window.showModalDialog(name, null, "status:no;center:yes;resizable:no;help:no;dialogHeight:" + height + "px;dialogWidth:" + width + "px");
    if (returnValue == 1) 
    {
        window.location = parent;
        return true;
    }
    //If the cancel button is pressed
    if (returnValue == 0) 
    {
        return false;
    }
    if (returnValue == -1) 
    {
        window.location = sessionExpiredUrl;
        return true;
    }
    if (doReload == "True") {
        document.forms[targetFormForRefresh].submit();
    }
    return true;
}

function ShowPopUpWithoutPostBack(name,height,width,sessionExpiredUrl) 
{
    var returnValue = window.showModalDialog(name, null, "status:no;center:yes;resizable:no;help:no;dialogHeight:" + height + "px;dialogWidth:"+width+"px");
    
    //If the ok button is pressed
    if (returnValue == 1)
    {
        return true;
    }
    if (returnValue == -1) 
    {
        window.location = sessionExpiredUrl;
        return true;
    }
    return false;
}

function ShowPopUpWithDirtyCheck(name,height,width,parent,sessionExpiredUrl) 
{
    //Check if the page is dirty
    var isPageDirty = CheckDirtyBeforeOpeningPopUp();
    if (isPageDirty)
    {
        //If the user presses cancel, return false (do not post back)
        if (!confirm("There are unsaved changes on this page. If you click OK you may lose all unsaved changes. Are you sure you want to close this window?"))
        {
            return false;
        }
    }
    var returnValue = window.showModalDialog(name, null, "status:no;center:yes;resizable:no;help:no;dialogHeight:" + height + "px;dialogWidth:"+width+"px");

    if (returnValue == 1) 
    {
        //If the user pressed the save button in the pop-up, clear the dirty flag
        ClearDirtyBeforePopUp();
        window.location = parent;
        return true;
    }
    //If the cancel button is pressed
    if (returnValue == 0)
    {
        return false;
    }
    if (returnValue == -1) 
    {
        window.location = sessionExpiredUrl;
        return true;
    }
    return true;
}


function ShowPopUpWithoutPostBackWithDirtyCheck(name,height,width,sessionExpiredUrl) {

    //used by project selector

    //var returnValue = window.showModalDialog(name, null, "status:no;center:yes;resizable:no;help:no;dialogHeight:" + height + "px;dialogWidth:" + width + "px");
    

    //statements before showing a modal dialog
        var isPageDirty = CheckDirtyBeforeOpeningPopUp();
        if (isPageDirty)
        {
            if (!confirm("There are unsaved changes on this page. If you click OK you may lose all unsaved changes. Are you sure you want to close this window?"))
            {
                return false;
            }
        }

       var returnValue = null;
       if (false) {
           returnValue = window.showModalDialog(name, null, "status:no;center:yes;resizable:no;help:no;dialogHeight:400px;dialogWidth:" + width + "px");
       } else {
//           returnValue = window.open(name, null,
//          'height=' + height + 'px,width=' + width + 'px,toolbar=no,directories=no,status=no, continued from previous linemenubar = no, scrollbars = no, resizable = no, modal = yes ');
//           console.log(returnValue);
           //           returnValue = 1;
           returnValue = window.showModalDialog("http://localhost:56999/Indev3WebSite/UserControls/ProjectSelector/SelectProject.aspx", "status:no;center:yes;resizable:no;help:no", "dialogWidth:" + width + "px;dialogHeight:" + height + "px");
           console.log(returnValue);
        }
        //var returnValue = window.showModalDialog(name, null, "status:no;center:yes;resizable:no;help:no;dialogHeight:" + height + "px;dialogWidth:" + width + "px");
//            var returnValue = window.showModalDialog('/Indev3WebSite/UserControls/ProjectSelector/SelectProject.aspx', "status:no;center:yes;resizable:no;help:no;", "dialogHeight:" + height + "px;dialogWidth:" + width + "px");
            if (returnValue == 1) {
                //If the user pressed the save button in the pop-up, clear the dirty flag
                ClearDirtyBeforePopUp();
                return true;
            }

            if (returnValue == -1) {
                window.location = sessionExpiredUrl;
                return true;
            }
        return false;   

    //statements after closing a modal dialog
    //If the ok button is pressed
}




function doReturn(n)
{
    window.returnValue = n;
    window.close(); 
}

function DoAlertMessage(msg)
{
    alert(msg);
}

function SetPopUpHeight() 
{
    //This fixes the issue of the pop-ups that, when opened for the first time, have a greater height than needed (because
    //document.body.scrollHeight is too big (this happens because the telerik comboboxes have a greater height before rendering ->
    //the height of the entire body element is greater))
    setTimeout("SetPopUpHeightWithoutDelay()", "0");
}

function SetPopUpHeightWithoutDelay() 
{
    var title_bar_estimated = 31; // 31 pixels or so for XP, 22 for Win2K...etc.
    var chrome_thickness_estimated = 2; // about 2 pixels or so...
    var adjusted_height = document.body.scrollHeight + (2 * chrome_thickness_estimated) + title_bar_estimated;
    window.dialogHeight = adjusted_height + 'px';
}

//Returns true if the page if dirty, false otherwise
function CheckDirtyBeforeOpeningPopUp() 
{
     var isDirty = document.getElementById('IsDirty');
     if (isDirty != null)
     {
         if (isDirty.value == 1)
         {
            return true;
         }
         return false;
     }
     return false;
}

function ClearDirtyBeforePopUp()
{
    var isDirty = document.getElementById('IsDirty');
    if (isDirty != null)
        isDirty.value = 0;
}

function ButtonLoseFocus()
{
    var body = document.getElementsByTagName("body");
    body[0].focus();
}
