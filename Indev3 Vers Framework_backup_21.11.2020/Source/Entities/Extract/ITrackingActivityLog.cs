using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Extract
{
    public interface ITrackingActivityLog : IGenericEntity
    {
        int IdAssociate
        { get; set; }

        int IdMemberImpersonated
        { get; set; }

        int IdProjectFunctionImpersonated
        { get; set; }

        int IdProject
        { get; set; }

        int IdAction
        { get; set; }

        int IdGeneration
        { get; set; }

        DateTime Logdate
        { get; set; }

    }
}
