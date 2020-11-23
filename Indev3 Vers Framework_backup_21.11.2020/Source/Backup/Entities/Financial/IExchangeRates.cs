using System;

namespace Inergy.Indev3.Entities.Financial
{
	public interface IExchangeRates : IGenericEntity
	{
		int Year
		{
			get;
			set;
		}
	}
}
