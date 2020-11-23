using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.Entities;

namespace Inergy.Indev3.BusinessLogic.Budget
{
    public class TIList : List<TimingAndInterco>
    {
        public new void Add(TimingAndInterco newInterco)
        {
            base.Add(newInterco);
        }
    }
}
