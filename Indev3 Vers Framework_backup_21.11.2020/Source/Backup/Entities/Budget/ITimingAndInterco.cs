using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Inergy.Indev3.Entities.Budget
{
    public interface ITimingAndInterco : IGenericEntity
    {
        int IdProject
        {
            get;
            set;
        }
        int IdPhase
        {
            get;
            set;
        }
        string PhaseCode
        {
            get;
            set;
        }
        string PhaseName
        {
            get;
            set;
        }
        int IdWP
        {
            get;
            set;
        }
        string WPCode
        {
            get;
            set;
        }
        string WPName
        {
            get;
            set;
        }
        int StartYearMonth
        {
            get;
            set;
        }
        int EndYearMonth
        {
            get;
            set;
        }
        int LastUserUpdate
        {
            get;
            set;
        }
        int IdAssociate
        {
            get;
            set;
        }

        List<IIntercoCountry> IntercoCountries { get;set;}

        DataSet GetAffectedWPTiming();
        DataSet GetAffectedWPInterco();
    }

    public interface IIntercoCountry : IGenericEntity
    {
        int IdProject { get;set;}
        int IdPhase { get;set;}
        int IdWP { get;set;}
        int IdCountry { get;set;}
        decimal Percent { get;set;}
        int Position { get;set;}
        string WPCode{get;set;}
    }
}
