/****** Object:  StoredProcedure [dbo].[catUpdateBudgetExchangeRate]    Script Date: 03/18/2015 11:31:54 ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'[dbo].[catUpdateBudgetExchangeRate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[catUpdateBudgetExchangeRate]
GO

/****** Object:  StoredProcedure [dbo].[catUpdateBudgetExchangeRate]    Script Date: 03/18/2015 11:31:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[catUpdateBudgetExchangeRate]

@IdCategory int,
@Year int,
@IdCurrency int,
@Rate numeric(10,4)

as
-- Rate for Budget is same in all months of the year
-- Insert records if they don't exist. One can insert for all currencies
insert into EXCHANGE_RATES
(IdCurrencyTo, YearMonth, IdCategory, ConversionRate)
select a.IdCurrencyTo,b.YearMonth, 2 as IdCategory, 0 as ConversionRate 
from
(
	select distinct IdCurrencyTo 
	from EXCHANGE_RATES 
	where floor(YearMonth/100) = @Year-1
	and IdCategory=1
) a
cross join
(
	select @Year*100+1 as YearMonth
	union
	select @Year*100+2
	union
	select @Year*100+3
	union
	select @Year*100+4
	union
	select @Year*100+5
	union
	select @Year*100+6
	union
	select @Year*100+7
	union
	select @Year*100+8
	union
	select @Year*100+9
	union
	select @Year*100+10
	union
	select @Year*100+11
	union
	select @Year*100+12
) b
left join EXCHANGE_RATES c on c.IdCurrencyTo = a.IdCurrencyTo and c.YearMonth = b.YearMonth and c.IdCategory=2
where c.IdCurrencyTo is null

update dbo.EXCHANGE_RATES
set ConversionRate = @Rate
where IdCurrencyTo = @IdCurrency and floor(YearMonth/100) = @Year
and IdCategory=2


GO

