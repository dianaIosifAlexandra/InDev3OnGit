using Inergy.Indev3.DataAccess.Financial;
using Inergy.Indev3.Entities.Financial;


namespace Inergy.Indev3.BusinessLogic.Financial
{
	public class ExchangeRates : GenericEntity, IExchangeRates
	{
		#region Public Properties
		
		private int _Year;
		public int Year
		{
			get { return _Year; }
			set { _Year = value; }
		}
		
		#endregion Public Properties
		
		
		#region Constructors
		
        public ExchangeRates()
            : this(null)
        {
        }
		public ExchangeRates(object connectionManager)
            : base(connectionManager)
        {
			SetEntity(new DBExchangeRates(connectionManager));
        }
        
        #endregion Constructors
	}
}
