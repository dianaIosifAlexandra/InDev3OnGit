function showDetail(evt) {

  var queryString;

  queryString = getQuery(evt.currentTarget);
  if(queryString!='' && queryString!=undefined) {
    //alert(queryString);
    _window_impl.parent.ShowDetail(queryString);
  }

}

function showPointDetail(evt) {

  var queryString;

  queryString = getQuery(evt.currentTarget);
  if(queryString!='' && queryString!=undefined) {
    //alert(queryString);
    _window_impl.parent.ShowPointDetail(queryString);
  }

}

function getQuery(node) {

  var metadataNodes = node.getElementsByTagName("metadata");
  var metadataNodesCount = metadataNodes.length;
  var metadataNode;
  var queryNode;
  var i;

  //Read metadata node query
  if (metadataNodesCount > 0) {
    //loop on metadata nodes if there's more than one metadata node
    for(i=0;i<metadataNodesCount;i++) {
      metadataNode = metadataNodes.item(i);
      if (metadataNode.getElementsByTagName("xvn:Query").length == 1) {
        queryNode = metadataNode.getElementsByTagName("xvn:Query").item(0);
        //debugger;
        return queryNode.firstChild().nodeValue();
      }
    }
  }
}

function displayInfo(e) {

  showTooltip(e);

}

function hideInfo(e) {

  hideTooltip(e);

}
