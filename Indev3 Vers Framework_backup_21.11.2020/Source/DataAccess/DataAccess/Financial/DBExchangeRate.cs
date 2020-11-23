using System.Data;
using Inergy.Indev3.Entities;
using Inergy.Indev3.Entities.Financial;

namespace Inergy.Indev3.DataAccess.Financial
{
    public class DBExchangeRate : DBGenericEntity
    {
		public DBExchangeRate(object connectionManager)
            : base(connectionManager)
        {
        }

		protected override void InitializeObject(IGenericEntity ent)
		{
			if (ent is IExchangeRate)
			{
				IExchangeRate exchangeRate = (IExchangeRate)ent;

				DBStoredProcedure spUpdate = new DBStoredProcedure();
                spUpdate.ProcedureName = "catUpdateBudgetExchangeRate";
                spUpdate.AddParameter(new DBParameter("@IdCategory", DbType.Int32, ParameterDirection.Input, exchangeRate.IdCategory));
                spUpdate.AddParameter(new DBParameter("@Year", DbType.Int32, ParameterDirection.Input, exchangeRate.Year));
                spUpdate.AddParameter(new DBParameter("@Rate", DbType.Decimal, ParameterDirection.Input, exchangeRate.Value));
                spUpdate.AddParameter(new DBParameter("@IdCurrency", DbType.Decimal, ParameterDirection.Input, exchangeRate.IdCurrency));
                this.AddStoredProcedure("UpdateObject", spUpdate);
			}
		}

    }
}
