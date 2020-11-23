//this is a dummy function to generate client side support
function GridCreated()
{
}

//Verifies if there are checkboxes selected in the WP Timing and Interco (for any tab)
function CheckBoxesSelectedInterco(grid)   
{        
    try
    {
        //Get the grid object
        var grid = window[grid];
        var checkCount = 0;

        //Iterates through the detail tables collection
        for (var k=0; k<grid.DetailTablesCollection.length;k++)
        {
            var detailView = grid.DetailTablesCollection[k];
            //Iterates throug each detail table view records
            for (var i=0; i<detailView.Rows.length; i++)
            {   
                //Get the checkboxes controls from the current row         
                var list = detailView.Rows[i].Control.getElementsByTagName("INPUT");
                //Get the first checkbox (the correct one)
                var checkBox = list[0];
                if (checkBox.checked == true)
                    checkCount++;
            }
        }
        //Verifies if any checkboxes are checked
        if (checkCount == 0){
            alert('Please select at least one work package!');
            return false;
        }
        else
            return true;
            
    }
    catch (err)
    {
        //If an error has occured, show it and cancel the process
        alert(err.description);
        return false;
    }
}   


function CheckBoxesSelected()   
{  
    var inputs = document.getElementsByTagName('input');

    for(var i=0; i<inputs.length; i++)
    {
        if (inputs[i].getAttribute('type') == 'checkbox')
        {
            var checkBox = inputs[i];
            if (checkBox.checked == true)
            {
                return true;
            }
        }
    }
    return false;
}   

function RemoveCheckBoxes(){
 try
 {
    var hdn=document.getElementById("ctl00_ph_hdnSelectedWP");
    hdn.value="";
 }catch(e){ return false;}
}

function StoreCheckValue(checkBox)
{
    var hdn=document.getElementById("ctl00_ph_hdnSelectedWP");
    if (hdn != null) 
    {
        //Add the checkboxid to the list in the hidden field
        if (checkBox.checked)
        {
            hdn.value = hdn.value+":"+checkBox.id.replace("grdInterco","grd").replace("grdPeriod","grd");
        }
        else
        {
            hdn.value = hdn.value.replace(":"+checkBox.id.replace("grdInterco","grd").replace("grdPeriod","grd"),"");
        }
    }
}

function RestoreCheckBoxes()
{
     var inputs = document.getElementsByTagName('input');

    for(var i=0; i<inputs.length; i++)
    {
        if (inputs[i].getAttribute('type') == 'checkbox')
        {
            var checkBox = inputs[i];
            checkBox.checked = false;
            
        }
    }
    
    var hdn=document.getElementById("ctl00_ph_hdnSelectedWP");
    var selectedWP = hdn.value.split(":");
    var i;

    for( i = 1; i<selectedWP.length; i++)
    {
        if ((i != null) && (selectedWP[i]!=""))
        {
            var chkWPId = selectedWP[i];
            
            var chkWPIdAlt = "";
            
            var chkWPIdAlt = chkWPId.replace("grd","grdPeriod");
            chkWPId = chkWPId.replace("grd","grdInterco");
         
            
            var chkBox = document.getElementById(chkWPId);
            if (chkBox != null)
            {
                chkBox.checked = true;
            }
             
            var chkBox = document.getElementById(chkWPIdAlt);
            if (chkBox != null)
            {
                chkBox.checked = true;
            }
        }
    }
    
}

//In master-detail grids, when checking or unchecking a checkbox in the parent table, this function checks or unchecks the checkboxes in the
//detail table
function SelectChildCheckBoxes(grid, senderId)
{
    try
    {
        //Get the grid object
        var grid = window[grid];
        var masterRowCounter = -1;
        //Get the sender checkbox
        var senderCheckBox = document.getElementById(senderId);
        if (senderCheckBox != null)
        {
            //Iterates through the master table rows
            for (var k = 0; k < grid.MasterTableView.Rows.length; k++)
            {
                var currentRow = grid.MasterTableView.Rows[k];
                var currentTr = currentRow.Control;
                //Because of a bug in telerik (which takes into account more rows than those of the master table), we calculate the real
                //row index using masterRowCounter variable. If a row does not have the class attribute set, it is not in the master table
                //otherwis it is in the master table
                var aaa = ((currentTr.getAttribute("className")).toString()).trim();
                if (aaa == "")
                {
                    continue;
                }
                else
                {
                    masterRowCounter++;
                }
                //Get the checkbox from the current row in the master table
                var currentCheckBox = currentRow.Control.getElementsByTagName("INPUT")[0];
                //if it is the same as the caller checkbox, check the child checkboxes
                if (senderId == currentCheckBox.id) 
                {
                    //Get the corresponding detail table
                    var detailTable = grid.DetailTablesCollection[masterRowCounter];
                    StoreCheckValue(senderCheckBox);
                    for (var j = 0; j < detailTable.Rows.length; j++)
                    {
                        var currentDetailRow = detailTable.Rows[j];
                        //get the current checkbox in the detail table 
                        var detailCheckBox = currentDetailRow.Control.getElementsByTagName("INPUT")[0];
                        //check or uncheck the child checkbox
                        if (detailCheckBox != null)
                        {
                            if (!detailCheckBox.disabled)
                            {
                                var hasChanged = false;
                                if (detailCheckBox.checked != senderCheckBox.checked)
                                    hasChanged = true;
                                detailCheckBox.checked = senderCheckBox.checked;
                                if ( (hasChanged) && ( (senderId.indexOf('Interco') >= 0) || (senderId.indexOf('Period') >=0) ) )
                                    StoreCheckValue(detailCheckBox);
                            }
                        }
                    }
                }
            }
        }
    }
    catch (err)
    {
        //If an error has occured, show it and cancel the process
        alert(err.description);
        return false;
    }
}


function RecalcSum(txtDetail)
{
    var indexOfDetail = txtDetail.name.indexOf("Detail");
    var indexOfPrefix = txtDetail.name.indexOf("$",indexOfDetail);
    indexOfDetail = indexOfPrefix;
    var indexOfPrefix = txtDetail.name.indexOf("$",indexOfDetail+1);
    //Get the prefix name
    var namePrefix = txtDetail.name.substring(0,indexOfPrefix);
    //The details will be the one that contain the namePrefix having the last digit increased with 1
    var lastDigitText = namePrefix.substring(namePrefix.length-1,namePrefix.length);
    var lastDigit = parseInt(lastDigitText, 10);
    var detailPrefix = namePrefix.substring(0,namePrefix.length-1)+lastDigit.toString();
    lastDigit--;
    var masterPrefix = namePrefix.substring(0,namePrefix.length-1)+lastDigit.toString();
    
    var oldValue = 0;
    var inputs = document.getElementsByTagName('input');
    var txtMaster = null;
    for(var i=0; i<inputs.length; i++)
    {
        if (inputs[i].getAttribute('type') == 'text')
        {
            var txtCurrent = inputs[i];
//            if (txtCurrent.name.indexOf(detailPrefix) >= 0)
//            {
//                if (txtCurrent.value != null)
//                    newValue += parseInt(txtCurrent.value);
//            }
            if (txtCurrent.name.indexOf(masterPrefix) >= 0)
            {
                txtMaster = txtCurrent;
            }
        }
    }
    var newValue = 0;
    if (txtMaster != null)
    {
        
        var masterValue = 0;
        if (txtMaster.value != "")
            masterValue = parseInt(RemoveThousandSeparator(txtMaster.value), 10);
           
        var defaultValue = 0;
        if (txtDetail.defaultValue != "")
            defaultValue = parseInt(RemoveThousandSeparator(txtDetail.defaultValue), 10);
        
        var currentValue = 0;
        if (txtDetail.value != "")
            currentValue = parseInt(RemoveThousandSeparator(txtDetail.value), 10);
            
        newValue = masterValue+currentValue-defaultValue;

        txtDetail.defaultValue = currentValue;
        txtMaster.value = newValue.toString();
        txtMaster.defaultValue = newValue.toString();
    }
}


function DistributeValues(txtMaster, toCompletionType)
{
    var masterValue = 0;
    var DATA_VALUES_SALES = 8;
    masterValue = parseInt(RemoveThousandSeparator(txtMaster.value), 10);
    if (masterValue.toString() == 'NaN')
    {
        txtMaster.value = txtMaster.defaultValue;
        return;
    }
    
    var response = confirm("This will overwrite the forecasted values for all the months. Are you sure?")
    if (response == false)
    {
        txtMaster.value = txtMaster.defaultValue;
        return;
    }
    
        
    var indexOfDetail = txtMaster.name.indexOf("Detail");
    var indexOfPrefix = txtMaster.name.indexOf("$",indexOfDetail);
    indexOfDetail = indexOfPrefix;
    var indexOfPrefix = txtMaster.name.indexOf("$",indexOfDetail+1);
    //Get the prefix name
    var namePrefix = txtMaster.name.substring(0,indexOfPrefix);
    //The details will be the one that contain the namePrefix having the last digit increased with 1
    var lastDigitText = namePrefix.substring(namePrefix.length-1,namePrefix.length);
    var lastDigit = parseInt(lastDigitText, 10);
    lastDigit++;
    namePrefix = namePrefix.substring(0,namePrefix.length-1)+lastDigit.toString();
    
    //Get all input items
    var inputs = document.getElementsByTagName('input');
    
    //Holds the number of detail textboxes
    var txtCount = 0;
    //Holds the txtDetails objects
    var objList = new Array();

    for(var i=0; i<inputs.length; i++)
    {
        if (inputs[i].getAttribute('type') == 'text')
        {
            var txtDetail = inputs[i];
            if ((txtDetail.name.indexOf(namePrefix) >= 0) && (txtDetail.name != txtMaster.name) && (txtDetail.disabled == false))
            {
                objList[txtCount] = txtDetail;
                txtCount++;
                
            }
        }
    }
    
    var previousMonthsValue = 0;
    
    for(var i=0; i<inputs.length; i++)
    {
        if (inputs[i].getAttribute('type') == 'text')
        {
            var txtDetail = inputs[i];
            if ((txtDetail.name.indexOf(namePrefix) >= 0) && (txtDetail.name != txtMaster.name) && (txtDetail.disabled == true))
            {
             if(txtDetail.value.length>0)
                    previousMonthsValue += parseInt(RemoveThousandSeparator(txtDetail.value), 10);
            }
        }
    }
    
    var labels = document.getElementsByTagName('SPAN');
    var actualDataValue = 0;
    var adLabelsCount = 0;
    for(var i=0; i<labels.length; i++)
    {
        var lblDetail = labels[i];
        
        if ((lblDetail.id.indexOf(namePrefix.replace(/\$/g,'_')) >= 0) && (lblDetail.id.indexOf('_AD') >= 0))
        {
            if(lblDetail.innerHTML.length>0)
            {
               actualDataValue += parseInt(RemoveThousandSeparator(IsNullOrEmptyReturnZero(lblDetail.innerHTML)), 10);
               adLabelsCount++;
            }
        }
    } 
    if ((masterValue-actualDataValue-previousMonthsValue<0) && (toCompletionType!=DATA_VALUES_SALES))
    {
        alert('The new value should be greater than sum of actual data values ('+actualDataValue+') and the sum of previous months values (' + previousMonthsValue + ').'); 
        txtMaster.value = txtMaster.defaultValue;
        return;
    }
    txtMaster.defaultValue = txtMaster.value;
    
    var values = new Array();
    var totalVal =  masterValue - actualDataValue - previousMonthsValue;  
    var decimalVal = Math.round(totalVal / txtCount);  
   
    for (i = 0; i < txtCount; i++)
    {
        values[i] = RoundDecimal(totalVal,decimalVal,i, txtCount);
    }
    
    
    for (i=0; i<objList.length;i++)
    {
        objList[i].value = values[i];
        objList[i].defaultValue = values[i];
    }
}

function RemoveThousandSeparator(text)
{
    return text.replace(/,/g,"");
}

function IsNullOrEmptyReturnZero(val)
{
    if(val==null) {
       return "0";
    }
    else
    {
        if(val.length==0)
            return "0";
        else
        {
            if(parseFloat(val,10)!=(val*1))
                return "0";
        }
     }
     return val;
}

function RoundDecimal(total, splittedValue, index, totalIndex)
{
    if(splittedValue==0)
    {
        if(index<totalIndex-1)
            {return 0;}
        else
            {return total;}
    }
    else
    {
        var NoMonthsTotalReached = Math.floor(total/splittedValue) -1;        
        if(index == NoMonthsTotalReached + 1)
        {
            return (total%splittedValue);
        }
        if(index > NoMonthsTotalReached + 1)
            {return 0;}
         
        if(index < totalIndex-1)
        {
            if(index <= NoMonthsTotalReached)
                return splittedValue;
        }
        else
        {            
                return total-splittedValue*(totalIndex-1);            
        }
    }
    
    return 0;
    
}

