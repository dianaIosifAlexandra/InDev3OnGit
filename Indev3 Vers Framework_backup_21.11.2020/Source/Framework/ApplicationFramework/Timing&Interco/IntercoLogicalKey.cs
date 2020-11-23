using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.ApplicationFramework.Timing_Interco
{
    public class IntercoLogicalKey
    {
        public int IdProject = ApplicationConstants.INT_NULL_VALUE;
        public int IdPhase = ApplicationConstants.INT_NULL_VALUE;
        public int IdWP = ApplicationConstants.INT_NULL_VALUE;
        /// <summary>
        /// Has nothing to do with the logical key but will be stored when the object is passed to the Budget screen for
        /// better performance
        /// </summary>
        public string PhaseName = String.Empty;
        //used to check wp existence before save
        public string WPCode = string.Empty;

        /// <summary>
        /// Specifies if the key is null or not
        /// </summary>
        /// <returns>A bool value that speicifies if the key is null</returns>
        public bool IsNull()
        {
            if ((IdProject == ApplicationConstants.INT_NULL_VALUE) && (IdPhase == ApplicationConstants.INT_NULL_VALUE) && (IdWP == ApplicationConstants.INT_NULL_VALUE))
                return true;
            return false;
        }
        public static bool AreKeysEqual(IntercoLogicalKey firstKey, IntercoLogicalKey secondKey)
        {
            if ((firstKey.IdProject == secondKey.IdProject) && (firstKey.IdPhase == secondKey.IdPhase) && (firstKey.IdWP == secondKey.IdWP))
                return true;
            else
                return false;
        }
    }
}
