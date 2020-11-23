function drillDown(evt) {

  var geoElement = evt.getTarget().parentNode;
  var metaData = geoElement.getElementsByTagName('metadata').item(0);

  try {
    //Get unique name on hierarchy assaciated with country (stored on firstChild wich is the text node)
    var uniqueName = metaData.getElementsByTagName('xvn:uniquename').item(0).firstChild.nodeValue();

    //Call drill function for WebAnalyst
    _window_impl.parent.wsDrillDown(uniqueName, null);
	}
	catch (e) {
		return
	}
}

function displayInfo(e) {

  e.currentTarget.getStyle().setProperty('filter','url(#DropShadowFilter)');
  showTooltip(e);

}

function hideInfo(e) {

  e.currentTarget.getStyle().setProperty('filter','url(#DropShadowFilterOut)')
  hideTooltip(e);

}

function showDetail(e) {

	//JB : if Parent node isn't the parent node of metadata, give a class on g node and search parent with this class attribute
  var geoElement = evt.getTarget().parentNode;
  var metaData = geoElement.getElementsByTagName('metadata').item(0);

  try {
    //Get unique name on hierarchy assaciated with country (stored on firstChild wich is the text node)
    var uniqueName = metaData.getElementsByTagName('xvn:uniquename').item(0).firstChild.nodeValue();
		var drillDownMap = metaData.getElementsByTagName('xvn:drillDownMap')
		if (drillDownMap.length == 0) {
			alert('Drilldown map is not defined');
			return;
		}
		else {
			drillDownMap = drillDownMap.item(0).firstChild.nodeValue();
		}

    //Call drill function in parent document
    _window_impl.parent.wsDrillDown(uniqueName, drillDownMap);
	}
	catch (e) {
		//TODO : show error message
	  return;
	}
	
}