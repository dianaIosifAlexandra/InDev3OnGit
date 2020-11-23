using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;

namespace Inergy.Indev3.BusinessLogic.Authorization
{
    /// <summary>
    /// A comparer class used to compare to IndPair objects (the IndPair objects are keys in a dictionary - authorization)
    /// </summary>
    public class IndPairComparer : IEqualityComparer<IndPair>
    {
        #region IEqualityComparer<IndPair> Members
        /// <summary>
        /// Shows whether to IndPair objects are equal or not
        /// </summary>
        /// <param name="x">the first pair</param>
        /// <param name="y">the second pair</param>
        /// <returns>true if the pairs are equal (they have the correpsonding elements equal), false otherwise</returns>
        public bool Equals(IndPair x, IndPair y)
        {
            return (x.First.ToString() == y.First.ToString()) && ((int)x.Second == (int)y.Second);
        }
        /// <summary>
        /// Get the has code of a pair. It is implemented to to ensure that if the Equals method returns true for two IndPair objects x and y,
        /// then the value returned by the GetHashCode method for x is equal to the value returned for y
        /// </summary>
        /// <param name="obj">The pair for which the hash code is calculated</param>
        /// <returns>the hash code of the pair</returns>
        public int GetHashCode(IndPair pair)
        {
            //Build a string consisting of the concatenation of the 2 elements of the pair (as strings)
            string concatenation = pair.First.ToString() + pair.Second.ToString();
            //Get the hash code for the concatenated string
            return concatenation.GetHashCode();
        }

        #endregion
    }
}
