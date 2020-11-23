using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.ApplicationFramework.Common;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.Utils
{
    /// <summary>
    /// Provides utilities for the budget
    /// </summary>
    public class BudgetUtils
    {
        /// <summary>
        /// Gets an AmountScaleOption from a string (usually from the amount scale option combobox present in all budget types)
        /// </summary>
        /// <param name="scaleText">the text to be converted as AmountScaleOption</param>
        /// <returns>AmountScaleOption from a string</returns>
        public static AmountScaleOption GetAmountScaleOptionFromText(string scaleText)
        {
            if (scaleText == AmountScaleOption.Unit.ToString())
                return AmountScaleOption.Unit;
            if (scaleText == AmountScaleOption.Millions.ToString())
                return AmountScaleOption.Millions;
            if (scaleText == AmountScaleOption.Thousands.ToString())
                return AmountScaleOption.Thousands;
            throw new IndException("Amount Scale Option " + scaleText + " is not implemented");
        }
    }

    /// <summary>
    /// Class used to store cost centers in the session, so that their edit state can be restored after postback. It is not really the
    /// key of the cost center object but it is enough in the given situation
    /// </summary>
    public class CostCenterKey
    {
        public int IdPhase;
        public int IdWP;
        public int IdCostCenter;
    }

    /// <summary>
    /// A collection of CostCenterKey objects
    /// </summary>
    public class CostCenterKeyCollection : List<CostCenterKey>
    {
        /// <summary>
        /// Hide the default add method. Insert key only if it is not already contained in the list
        /// </summary>
        /// <param name="key">CostCenterKey object to insert into the collection</param>
        public new void Add(CostCenterKey key)
        {
            foreach (CostCenterKey currentKey in this)
            {
                if (currentKey.IdPhase == key.IdPhase && currentKey.IdWP == key.IdWP && currentKey.IdCostCenter == key.IdCostCenter)
                {
                    return;
                }
            }
            base.Add(key);
        }

        /// <summary>
        /// Checks if key is contained in the list
        /// </summary>
        /// <param name="key">CostCenterKeyto search for in the collection</param>
        /// <returns>true if key is in the collection, false otherwise</returns>
        public new bool Contains(CostCenterKey key)
        {
            foreach (CostCenterKey currentKey in this)
            {
                if (currentKey.IdPhase == key.IdPhase && currentKey.IdWP == key.IdWP && currentKey.IdCostCenter == key.IdCostCenter)
                {
                    return true;
                }
            }
            return false;
        }
    }

    /// <summary>
    /// Used in the reforecast budget to populate the combobox which decides which data is displayed
    /// </summary>
    public class ReforecastDataType
    {
        private string _DataTextField;
        public string DataTextField
        {
            get { return _DataTextField; }
        }
        private int _DataValueField;
        public int DataValueField
        {
            get { return _DataValueField; }
        }

        public ReforecastDataType(string dataTextField, int dataValueField)
        {
            _DataTextField = dataTextField;
            _DataValueField = dataValueField;
        }
    }
}
