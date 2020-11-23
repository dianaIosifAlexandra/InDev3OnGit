using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.Entities.Budget
{
	/// <summary>
	/// Interface for the ProjectCopyCoreTeam entity
	/// </summary>
	public interface IProjectCopyCoreTeam : IGenericEntity
	{
		int IdProject
		{
			get;
			set;
		}
		int IdTargetProject
		{
			get;
			set;
		}
		int IdAssociate
		{
			get;
			set;
		}
	}
}
