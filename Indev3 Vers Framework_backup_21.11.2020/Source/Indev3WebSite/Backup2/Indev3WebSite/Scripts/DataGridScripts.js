// JScript File
var RadGrid;
function ChangePage(eventTarget, eventArgument, gridClientID, e)
{
    if(e.keyCode == 13)
	{
        e.cancelBubble = true;
        e.returnValue = false;

        if (e.preventDefault)
        {
            e.preventDefault();
        }
        try 
        {
            RadGridNamespace.AsyncRequest(eventTarget, eventArgument, gridClientID);
        }
        catch(err)
        {
            __doPostBack(eventTarget, eventArgument);
        }
    }
}

function ChangePageRadGrid(sender, e) 
{
    if (e.keyCode == 13) {
        var btn = document.getElementById(sender);
        if (btn != null) {
            e.cancelBubble = true;
            e.returnValue = false;

            if (e.preventDefault) {
                e.preventDefault();
            }

            btn.click();
        }
    }
}

function doFilter(sender, e)
{
   if(e.keyCode == 13)
   {
        var btn = document.getElementById(sender);
        if(btn != null)
        {
            e.cancelBubble = true;
            e.returnValue = false;

            if (e.preventDefault)
            {
                e.preventDefault();
            }

            btn.click();
        }
   }
}

//Opens the Edit Window
function OpenEditWindow(editButton,editControl,openAddWindow,sessionExpiredUrl)
{    
    //Get all the tables from the HTML body
    var tables = document.getElementsByTagName("TABLE");
    var gridTable;
    
    //Find the table that represents the Catalogues grid
    for (i=0;i<tables.length;i++)
    {
        if (tables[i].id.indexOf("grd") > 0) 
        {
            gridTable = tables[i];
            break;
        }
    }
    //Cycle through the collection of rows of the grid table
    for (i=0;i<gridTable.rows.length;i++)
    {
        //Get the value from the first column - this is the column that holds the edit button
        var firstColumn = gridTable.rows[i].cells[0].innerHTML;
        //Verify if this is the row that contains the button that called this method
        if (firstColumn.indexOf(editButton.id) > 0)
        {
            var cellNumber = gridTable.rows[i].cells.length-1;
            //Gets the id from the last column
            var idValue = gridTable.rows[i].cells[cellNumber].innerHTML;

            ShowPopUp('PopUp.aspx?Code='+editControl+'&Id='+idValue, 0, 360, 'Catalogs.aspx?Code='+editControl,sessionExpiredUrl);
        }
    }
    return false;        
}

//Opens the Add window
function OpenAddWindow(editControl,sessionExpiredUrl)
{    
   ShowPopUp('PopUp.aspx?Code='+editControl+'&Id=', 0, 360, 'Catalogs.aspx?Code='+editControl,sessionExpiredUrl);
   return false;
}

