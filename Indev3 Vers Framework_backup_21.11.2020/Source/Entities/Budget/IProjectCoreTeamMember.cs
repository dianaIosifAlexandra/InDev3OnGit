using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
    /// <summary>
    /// Interface for the ProjectCoreTeam entity
    /// </summary>
    public interface IProjectCoreTeamMember : IGenericEntity
    {
        int IdProject
        {
            get;
            set;
        }

        string ProjectName
        {
            get;
            set;
        }

        int IdAssociate
        {
            get;
            set;
        }

        string CoreTeamMemberName
        {
            get;
            set;
        }

        int IdFunction
        {
            get;
            set;
        }

        string FunctionName
        {
            get;
            set;
        }

        bool IsActive
        {
            get;
            set;
        }

        DateTime LastUpdateDate
        {
            get;
            set;
        }
    }
}
