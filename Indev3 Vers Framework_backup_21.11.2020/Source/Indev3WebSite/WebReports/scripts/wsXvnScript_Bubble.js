/* Winsight
** XVision 2.5 script
** Last modification 2005-10-08
** Bubble chart
**/

function showDetail(evt) {

	/* Add Custom code here */

  _window_impl.parent.showDetail("These function has been called from wsXvnScript_Bubble.js");

}

function displayInfo(e) {

	/* Default implementation shows FmtValue text node */
	/* Custom code may display information with a call with showTooltipExt(e, txt); */
  showTooltip(e);

}

function hideInfo(e) {

  hideTooltip(e);

}
