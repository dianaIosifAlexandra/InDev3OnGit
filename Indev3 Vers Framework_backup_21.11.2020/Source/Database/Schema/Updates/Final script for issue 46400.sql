if exists(select * from Information_schema.Columns where TABLE_NAME='ANNUAL_BUDGET_IMPORT_DETAILS' and COLUMN_NAME='Quantity')
	exec sp_RENAME 'ANNUAL_BUDGET_IMPORT_DETAILS.Quantity', 'Quantity1', 'COLUMN'
go

if exists(select * from Information_schema.Columns where TABLE_NAME='ANNUAL_BUDGET_IMPORT_DETAILS' and COLUMN_NAME='Value')
	exec sp_RENAME 'ANNUAL_BUDGET_IMPORT_DETAILS.Value', 'Value1', 'COLUMN'
go


if not exists(select * from Information_schema.Columns where TABLE_NAME='ANNUAL_BUDGET_IMPORT_DETAILS' and COLUMN_NAME='Quantity2')
   begin
	ALTER TABLE ANNUAL_BUDGET_IMPORT_DETAILS
	add 	[Quantity2] [decimal](18, 2) NULL,
		[Quantity3] [decimal](18, 2) NULL,
		[Quantity4] [decimal](18, 2) NULL,
		[Quantity5] [decimal](18, 2) NULL,
		[Quantity6] [decimal](18, 2) NULL,
		[Quantity7] [decimal](18, 2) NULL,
		[Quantity8] [decimal](18, 2) NULL,
		[Quantity9] [decimal](18, 2) NULL,
		[Quantity10] [decimal](18, 2) NULL,
		[Quantity11] [decimal](18, 2) NULL,
		[Quantity12] [decimal](18, 2) NULL,
		[Value2] [decimal](18, 2) NULL,
		[Value3] [decimal](18, 2) NULL,
		[Value4] [decimal](18, 2) NULL,
		[Value5] [decimal](18, 2) NULL,
		[Value6] [decimal](18, 2) NULL,
		[Value7] [decimal](18, 2) NULL,
		[Value8] [decimal](18, 2) NULL,
		[Value9] [decimal](18, 2) NULL,
		[Value10] [decimal](18, 2) NULL,
		[Value11] [decimal](18, 2) NULL,
		[Value12] [decimal](18, 2) NULL
	end
GO

if exists(select * from COST_INCOME_TYPES where DefaultAccount='10000007')
begin
  delete COST_INCOME_TYPES where DefaultAccount='10000007'
end
go

if exists(select * from COST_INCOME_TYPES where DefaultAccount='10000008')
begin
  delete COST_INCOME_TYPES where DefaultAccount='10000008'
end
go

if exists(select * from COST_INCOME_TYPES where DefaultAccount='10000009')
begin
  delete COST_INCOME_TYPES where DefaultAccount='10000009'
end
go