    //<script src="\Script\Function.js"></script>

		SVGDocument = null;			//Stores an handle to loaded SVGDocument.
		InfoNode = null;

      	DeleteList = new Array();

		function Initialize(LoadEvent) {
			SVGDocument = LoadEvent.getTarget().getOwnerDocument()
			ParentGroup1 = SVGDocument.getElementById("slices")
			Grandparent1 = SVGDocument.getElementById("piechart")
			//alert('referrer : ' + SVGDocument.referrer);
			//alert('domain : ' + SVGDocument.domain);
			//alert('URL : ' + SVGDocument.URL);
			//alert('rootElement : ' + SVGDocument.rootElement);
		}

		function DemoIE() {
			_window_impl.parent.TestIE();
			//debugger;
			return;
		}

		/* Move Segment is called to make translation on OnClick event */
		function MoveSegment(MouseEvent, X, Y, Moved, ID) {
	          Element = MouseEvent.getTarget()

			if (Moved==true) {
		          Element.setAttribute("transform", "translate(0,0)")
		          Element.setAttribute("onclick", "MoveSegment(evt, " + X + ", " + Y + ", false, " + ID + ")")
			}
			else {
		          Element.setAttribute("transform", "translate(" + X + "," + Y + ")")
		          Element.setAttribute("onclick", "MoveSegment(evt, " + X + ", " + Y + ", true, " + ID + ")")
			}
		}

		/* DisplayInfo is called on OnMouseOver and OnMouseOut Events to display extra information on drawn value */
		function DisplayInfo(evt, X, Y, Info1, Info2) {

			//Author : Jerome BERTHAUD (jerome.berthaud@winsight.fr)
			if (InfoNode!=null) {
				InfoNode.getParentNode().removeChild(InfoNode);
				InfoNode = null;
			}
			else {
				CurrentNode = evt.currentTarget();
				//Find the Parent element of Pie Chart
				ParentNode = CurrentNode.getParentNode().getParentNode();

				InfoNode = SVGDocument.createElement("text");
				InfoNode.setAttribute("x", X);
				InfoNode.setAttribute("y", Y)
				InfoNode.setAttribute("style", "text-anchor:middle");

				Info1Node = SVGDocument.createElement("tspan");
				Info1Node.setAttribute("style", "font-size:13;font-weight:bold")
				Info1Node.appendChild(SVGDocument.createTextNode(Info1));
				InfoNode.appendChild(Info1Node);

				Info2Node = SVGDocument.createElement("tspan");
				Info2Node.setAttribute("style", "font-size:13")
				Info2Node.appendChild(SVGDocument.createTextNode(Info2));
				InfoNode.appendChild(Info2Node);

				ParentNode.appendChild(InfoNode);
			};
		}

	function DrillDown(strXCoordinates, strYCoordinates, strSlicer) {
		alert(strXCoordinates + '\n' + strYCoordinates + '\n' + strSlicer);
	}

