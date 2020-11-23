using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    /// <summary>
    /// Class used to represent a pair of 2 objects
    /// </summary>
    public class IndPair
    {
        #region Members
        private object _First;
        /// <summary>
        /// The first element of the pair
        /// </summary>
        public object First
        {
            get { return _First; }
            set { _First = value; }
        }

        private object _Second;
        /// <summary>
        /// The second element of the pair
        /// </summary>
        public object Second
        {
            get { return _Second; }
            set { _Second = value; }
        }
        #endregion Members

        #region Constructors
        /// <summary>
        /// Constructor of the class
        /// </summary>
        /// <param name="first">The first element of the pair</param>
        /// <param name="second">The second element of the pair</param>
        public IndPair(object first, object second)
        {
            _First = first;
            _Second = second;
        }
        #endregion Constructors
    }
}
