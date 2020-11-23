function showTooltip(e) {

  var targetNode    = e.currentTarget;

  var info = getInfo(targetNode);

  if (info!=null) {
		showTooltipExt(e, info);
  }
}

function showTooltipExt(e, txt) {

  var targetNode    = e.currentTarget;
  var CTM           = getTransformToElement(targetNode);
  var trans         = svgRoot.getCurrentTranslate();
  var scale         = svgRoot.getCurrentScale();
  var m             = viewBox.getTM();
  var p1            = svgRoot.createSVGPoint();
  var p2, p3;

  m = m.scale( 1/scale );
  m = m.translate(-trans.x, -trans.y);
		
  p1.x = e.clientX;
  p1.y = e.clientY;

  p2 = p1.matrixTransform(m);

  // Update Tooltip Text
  tooltipText.setAttribute("x", p2.x);
  tooltipText.setAttribute("y", p2.y-30);

  var svgstyle = tooltipText.getStyle();
  svgstyle.setProperty ('visibility', 'visible');
  textNode.setData(txt);

  // Update Tooltip Rectangle
  tooltipRect.setAttribute ('x', p2.x-(0.6*tooltipText.getComputedTextLength()));
  tooltipRect.setAttribute ('y', p2.y-40);
  tooltipRect.setAttribute ('width', 1.2*tooltipText.getComputedTextLength());
  var svgstyle = tooltipRect.getStyle();
  svgstyle.setProperty('visibility', 'visible');
}

function hideTooltip() {

  var svgstyle;

  svgstyle = tooltipRect.getStyle();
  svgstyle.setProperty("visibility", "hidden");

  svgstyle = tooltipText.getStyle();
  svgstyle.setProperty("visibility", "hidden");
}

function getInfo(node) {

  var metadata;
  var fmtValue;
  var info;

	info = node.getAttribute("id");

  if (node.getElementsByTagName("metadata").length > 0) {
    metadata = node.getElementsByTagName("metadata").item(0);
    if (metadata.getElementsByTagName("xvn:FmtValue").length == 1) {
      fmtValue = metadata.getElementsByTagName("xvn:FmtValue").item(0);
      //If FmtValue has Value
      if (fmtValue.firstChild()!=null) {
      	if (info=="") {
      		info = fmtValue.firstChild().nodeValue();
      	}
      	else {
	      	info += " : " + fmtValue.firstChild().nodeValue();
      	}
      }
      else {
        info += " no value to display";
      }
    }
  }
  return info;
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
