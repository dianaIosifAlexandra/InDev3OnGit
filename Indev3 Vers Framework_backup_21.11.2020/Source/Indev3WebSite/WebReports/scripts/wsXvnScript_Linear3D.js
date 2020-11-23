var svgns = "http://www.w3.org/2000/svg";
var svgRoot;

var viewBox;
var tooltipRect;
var tooltipText;
var textNode;
var lastAlign;
var lastMeetOrSlice;

function init(e) {
  if ( window.svgDocument == null )
      svgDocument = e.target.ownerDocument;

  svgRoot         = svgDocument.documentElement;
  viewBox         = new ViewBox(svgDocument.documentElement);

  tooltipRect     = svgDocument.getElementById("tooltipRect");
  tooltipText     = svgDocument.getElementById("tooltipText");
  textNode        = tooltipText.getFirstChild();

  lastAlign       = svgDocument.getElementById("xMidYMid");
  lastMeetOrSlice = svgDocument.getElementById("meet");
}

function getTransformToElement(node) {
  // Initialize our node's Current Transformation Matrix
  var CTM = node.getCTM();

  // Work our way bacwards through the ancestor nodes stopping at the
  // SVG Document
  while ( ( node = node.parentNode ) != svgDocument ) {
    // Multiply the new CTM with what we've accumulated so far
    CTM = node.getCTM().multiply(CTM);
  }

  return CTM;
}

function displayInfo(e) {

  showTooltip(e);

}

function hideInfo(e) {

  hideTooltip(e);

}
