// JScript File

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
        console.log("GGG25_after");
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

