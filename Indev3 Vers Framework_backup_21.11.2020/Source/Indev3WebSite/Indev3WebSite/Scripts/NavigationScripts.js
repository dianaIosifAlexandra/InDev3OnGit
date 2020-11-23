// JScript File

function NavigateForward()
{
    var isDirty = document.getElementById('IsDirty');
    if (isDirty.value == 1)
    {
        var answer = confirm("There are unsaved changes on this page. If you click OK you will lose all unsaved changes. Are you sure you want to close this window?");
        if (answer)
        {
            isDirty.value = 0;
            history.go(1);
        }
    }
    else
    {
       history.go(1);
    }
    
}


function NavigateBack()
{
    var isDirty = document.getElementById('IsDirty');
    if (isDirty.value == 1)
    {
        var answer = confirm("There are unsaved changes on this page. If you click OK you will lose all unsaved changes. Are you sure you want to close this window?");
        if (answer)
        {
            isDirty.value = 0;
            history.go(-1);
        }
    }
    else
    {
       history.go(-1);
    }
}
