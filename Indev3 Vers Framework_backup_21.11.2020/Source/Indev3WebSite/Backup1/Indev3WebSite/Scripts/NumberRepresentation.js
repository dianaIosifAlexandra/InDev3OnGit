// JScript File
function RestrictRangeValues(textBox, minValue, maxValue)
{
    try
    {
        var newValue = parseFloat(textBox.value);
        if ((newValue>maxValue) || (newValue<minValue))
        {
            alert('The value should be in the following range: ('+minValue+','+maxValue+')');
            textBox.value = textBox.defaultValue;
        }
    }
    catch(err)
    {
        alert(err.description);
        textBox.value = textBox.defaultValue;
    }
}
function getKeyCode(e)
{
    if (window.event)
        return window.event.keyCode;
    else if (e)
        return e.which;
    else
        return null;
}
function RestrictKeys(e, validchars, textBox) 
{
    e.cancelBubble=true; 
    var obj = document.getElementById(textBox);
    var oldValue = obj.value;
    var key='', keychar='';
    key = getKeyCode(e);
    if (key==46)
    {
        if (oldValue.indexOf(".") != -1)
            return false;
    }
    if (key == null) 
        return true;
    keychar = String.fromCharCode(key);
    keychar = keychar.toLowerCase();
    validchars = validchars.toLowerCase();
    if (validchars.indexOf(keychar) != -1)
        return true;
    //numeric keypad
    if (key >= 96 && key <= 105)
        return true;
    if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 )
        return true;
    return false;
}

function RestrictKeysByName(e, validchars, textBox) 
{
    e.cancelBubble=true; 
    var obj = document.getElementsByName(textBox)[0];
    var oldValue = obj.value;
    var key='', keychar='';
    key = getKeyCode(e);
    if (key==46)
    {
        if (oldValue.indexOf(".") != -1)
            return false;
    }
    if (key == null) 
        return true;
    keychar = String.fromCharCode(key);
    keychar = keychar.toLowerCase();
    validchars = validchars.toLowerCase();
    if (validchars.indexOf(keychar) != -1)
        return true;
    if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 )
        return true;
    return false;
}

//This function will not permit entering the chars in the invalidchars parameter
function RestrictSpecialKeys(e, invalidchars, textBox) 
{
    e.cancelBubble=true; 
    var obj = document.getElementById(textBox);
    var oldValue = obj.value;
    var key='', keychar='';
    key = getKeyCode(e);
    if (key==46)
    {
        if (oldValue.indexOf(".") != -1)
            return false;
    }

    if (key == null) 
        return true;
    keychar = String.fromCharCode(key);
    keychar = keychar.toLowerCase();
    invalidchars = invalidchars.toLowerCase();
    if (invalidchars.indexOf(keychar) != -1)
    {
        return false;
    }
    if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 )
        return true;
    return true;
}

