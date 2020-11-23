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
