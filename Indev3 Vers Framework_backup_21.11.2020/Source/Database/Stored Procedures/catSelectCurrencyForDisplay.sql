--Drops the Procedure catSelectCurrency if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catSelectCurrencyForDisplay]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catSelectCurrencyForDisplay
GO
CREATE PROCEDURE catSelectCurrencyForDisplay
as

declare @t table (Id int, Code varchar(4))

insert into @t
SELECT 	C.Id,
	C.Code
FROM CURRENCIES C(nolock)
where Code in ('EUR', 'USD')
order by Id

insert into @t
SELECT 	C.Id,
	C.Code
FROM CURRENCIES C(nolock)
WHERE C.Code not in ('EUR', 'USD', 'GBP', 'SKK', 'ZAR', 'IRR', 'RUB')
order by Code

select * from @t

GO

