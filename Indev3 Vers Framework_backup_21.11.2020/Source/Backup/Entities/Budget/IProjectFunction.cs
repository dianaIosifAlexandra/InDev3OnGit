using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    public interface IProjectFunction : IGenericEntity
    {
        string Name
        {
            get;
            set;
        }
    }
}
