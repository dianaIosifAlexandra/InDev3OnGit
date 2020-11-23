using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace Inergy.Indev3.WebFramework.Utils
{
   public static  class IndConstants
    {
       public static Color ColorSubmitted = Color.FromArgb(252, 248, 163);
       public static Color ColorSubmittedForPhase = Color.FromArgb(249, 243, 90);
       public static Color ColorActual = Color.FromArgb(204, 255, 255);
       public static Color ColorValidator = (System.Web.HttpContext.Current.Request.Browser.Version == "8" || System.Web.HttpContext.Current.Request.Browser.Version == "7") ? Color.FromArgb(98, 98, 98) : Color.FromArgb(110, 110, 110);

    }
}
