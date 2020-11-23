using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace Inergy.Indev3.ApplicationFramework.Common
{
    public enum EBudgetCalculationMethod
    {
        eSUM = 0,
        eAVG
    }

    public enum EBudgetType
    {
        Initial=0,
        Revised,
        Reforecast
    }

    public enum EBudgetVersion
    {
        InProgress = 0,
        Released,
        Previous
    }


    public enum EOtherCostTypes
    {
        TE = 1,
        ProtoParts,
        ProtoTooling,
        Trials,
        OtherExpenses
    }

    public enum EExtractType
    {
        entire_program = 0,
        project_only
    }

    public enum EExtractSource
    {
        reforecast =0,
        revised,
        initial,
        actual,
        annual_budget
    }
    public enum EExtractReforecastType
    {
        actual_tocompletion = 0,
        actual,
        tocompletion
    }
    public enum EExtractSourceFunction
    {
        reforecast = 0,
        revised = 1,
        initial = 2,
        actual = 3,
        annual_budget = 4
    }

    public enum EBudgetStatusNode
    {
        none = 0,
        cancel = 1,
        edit = 2,
        update_first_time = 3,
        update_second_time = 4

    }

    public static class EnumUtil
    {
        /// <summary>
        /// Transforms an enumeration into a dictionary with Key = name from Enumeration (underscore character replaced with space) and Value = value of the enumeration field.
        /// </summary>
        /// <param name="sourceEnum">the instance of the Enum type to be transformed</param>
        /// <returns></returns>
        public static Dictionary<string, int> MakeEnumWithSpaces(Enum sourceEnum)
        {
            Dictionary<string, int> values = new Dictionary<string, int>();

            foreach (string item in Enum.GetNames(sourceEnum.GetType()))
            {
                string newItem = item.Replace('_', ' ');
                values[newItem] = (int)Enum.Parse(sourceEnum.GetType(), item);
            }

            return values;
        }
    }
}
