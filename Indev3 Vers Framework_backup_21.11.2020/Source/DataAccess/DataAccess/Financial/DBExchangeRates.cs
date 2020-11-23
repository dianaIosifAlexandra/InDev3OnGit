using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Financial;

namespace Inergy.Indev3.DataAccess.Financial
{
	public class DBExchangeRates : DBGenericEntity
	{
		public DBExchangeRates(object connectionManager)
            : base(connectionManager)
        {
        }

		protected override void InitializeObject(IGenericEntity ent)
		{
			if (ent is IExchangeRates)
			{
				IExchangeRates exchangeRates = (IExchangeRates)ent;

				DBStoredProcedure spSelect = new DBStoredProcedure();
				spSelect.ProcedureName = "catSelectExchangeRates";
				spSelect.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, exchangeRates.Year));
				this.AddStoredProcedure("SelectObject", spSelect);
			}
		}

	}
}
