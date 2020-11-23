using Inergy.Indev3.DataAccess.Financial;
using Inergy.Indev3.Entities.Financial;

namespace Inergy.Indev3.BusinessLogic.Financial
{
    public class ExchangeRate: GenericEntity, IExchangeRate
    {
        #region Public Properties
		
		private int _Year;
        private int _IdCategory = 1;
        private decimal _value = 0;
        private int _IdCurrency;

		public int Year
		{
			get { return _Year; }
			set { _Year = value; }
		}
		
        public int IdCategory
        {
            get {return _IdCategory;}
            set {_IdCategory = value;}
        }

        public decimal Value
        {
            get {return _value;}
            set {_value = value;}
        }

        public int IdCurrency
        {
            get { return _IdCurrency; }
            set { _IdCurrency = value; }
        }

		#endregion Public Properties
		
		
		#region Constructors
		
        public ExchangeRate(): this(null)
        {
        }

		public ExchangeRate(object connectionManager)
            : base(connectionManager)
        {
			SetEntity(new DBExchangeRate(connectionManager));
        }
        
        #endregion Constructors
	}

}
