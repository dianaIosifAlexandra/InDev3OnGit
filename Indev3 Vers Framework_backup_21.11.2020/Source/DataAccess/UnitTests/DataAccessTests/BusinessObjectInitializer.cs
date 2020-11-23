using System;
using System.Collections.Generic;
using System.Text;
using Inergy.Indev3.BusinessLogic.Catalogues;
using Inergy.Indev3.Entities.Catalogues;
using Inergy.Indev3.BusinessLogic.Budget;

namespace Inergy.Indev3.DataAccessTests
{
    internal static class BusinessObjectInitializer
    {
        internal static Associate CreateAssociate()
        {
            return new Associate();
        }

        internal static CostCenter CreateCostCenter()
        {
            return new CostCenter();
        }

        internal static CostIncomeType CreateCostIncomeType()
        {
            return new CostIncomeType();
        }

        internal static Country CreateCountry()
        {
            return new Country();
        }

        internal static Currency CreateCurrency()
        {
            return new Currency();
        }

        internal static Department CreateDepartment()
        {
            return new Department();
        }

        internal static Function CreateFunction()
        {
            return new Function();
        }

        internal static GlAccount CreateGLAccount()
        {
            return new GlAccount();
        }

        internal static HourlyRate CreateHourlyRate()
        {
            return new HourlyRate();
        }

        internal static InergyLocation CreateInergyLocation()
        {
            return new InergyLocation();
        }

        internal static Owner CreateOwner()
        {
            return new Owner();
        }

        internal static OwnerType CreateOwnerType()
        {
            return new OwnerType();
        }

        internal static Program CreateProgram()
        {
            return new Program();
        }

        internal static ProjectPhase CreateProjectPhase()
        {
            return new ProjectPhase();

        }

        internal static Project CreateProject()
        {
            return new Project();
        }

        internal static ProjectType CreateProjectType()
        {
            return new ProjectType();
        }

        internal static Region CreateRegion()
        {
            return new Region();
        }

        internal static WorkPackage CreateWorkPackage()
        {
            return new WorkPackage();
        }
        internal static CurrentProject CreateCurrentProject()
        {
            return new CurrentProject(null);
        }
        internal static ProjectCoreTeamMember CreateProjectCoreTeamMember()
        {
            return new ProjectCoreTeamMember();
        }
        internal static ProjectFunction CreateProjectFunction()
        {
            return new ProjectFunction(null);
        }
        internal static TimingAndInterco CreateTimingAndInterco()
        {
            return new TimingAndInterco(null);
        }
        internal static InitialBudget CreateInitialBudget()
        {
            return new InitialBudget(null);
        }
        internal static RevisedBudget CreateRevisedBudget()
        {
            return new RevisedBudget(null);
        }
        internal static FollowUpInitialBudget CreateValidateBudget()
        {
            return new FollowUpInitialBudget(null);
        }
        internal static FollowUpRevisedBudget ValidateFollowUpRevisedBudget()
        {
            return new FollowUpRevisedBudget(null);
        }
    }
}
