/* Winsight
** XVision 2.5 script
** Last modification 2005-10-08
** Scatter chart
**/

function showDetail(evt) {

	/* Add Custom code here */

  _window_impl.parent.showDetail("OK");

}

function displayInfo(e) {

	/* Default implementation shows FmtValue text node */
	/* Custom code may display information with a call with showTooltipExt(e, txt); */
  showTooltip(e);

}

function hideInfo(e) {

  hideTooltip(e);

}
