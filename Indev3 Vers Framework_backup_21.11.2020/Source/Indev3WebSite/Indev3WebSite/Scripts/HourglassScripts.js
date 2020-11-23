// JScript File

function RequestStart(sender, args)             
{ 
    var div = document.getElementById("MasterPageDiv");
    div.className = "Wait";
    div.style.cursor = "wait";
} 
           
function ResponseEnd(sender, args)              
{
    var div = document.getElementById("MasterPageDiv");
    div.className = "Normal";
    div.style.cursor = "default";
} 

function RequestStartNoMaster(sender, args)             
{   
    document.body.className = "Wait";// set wait cursor for inputs too
    document.body.style.cursor = "wait";
} 
           
function ResponseEndNoMaster(sender, args)              
{
    document.body.className = "Normal";
    document.body.style.cursor = "default";
} 
 
  