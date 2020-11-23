--select * from fnValidateYearMonth(194535)
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[fnValidateYearMonth]'))
	DROP FUNCTION fnValidateYearMonth
GO

CREATE FUNCTION fnValidateYearMonth
	(@YearMonth	INT)	--The YearMonth to validate
returns @ValidationTable table
(ValidationResult int, --has the value 0 if ok, negative value if not ok
 ErrorMessage     varchar(255) -- contains the string representing the error
) 
AS
BEGIN

declare @month int,
	@errMessage varchar(255)

--check the length to be 6
if (@YearMonth<100000 or @YearMonth>999999)
begin
	set @errMessage = REPLACE('Invalid YearMonth database value: ''%d''. YearMonth must be in the form YYYYMM with length 6.', '%d', @YearMonth)
	insert into @ValidationTable values(-1, @errMessage)
	return
end


--check the boundaries against smalldatetime boundaries
if (@YearMonth<190000 or @YearMonth>207905)
begin
	set @errMessage = REPLACE('Invalid YearMonth database value: ''%d''. YearMonth must contain values between 1900/01 and 2079/06.', '%d', @YearMonth)
	insert into @ValidationTable values(-2, @errMessage)
	return
end


--check the month value
SET @Month = @YearMonth % 100
if (@Month=0 or @Month>12)
begin
	SET @errMessage = REPLACE('Invalid Month in YearMonth database value: ''%d''. Valid values are between 1 and 12.', '%d', @YearMonth)
	insert into @ValidationTable values(-3, @errMessage)
	return
end

insert into @ValidationTable values (0, '')
return

end
go
