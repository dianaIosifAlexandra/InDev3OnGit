--Drops the Procedure catUpdateWorkPackageTemplateRank if it exists
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[catUpdateWorkPackageTemplateRank]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE catUpdateWorkPackageTemplateRank
GO
CREATE PROCEDURE catUpdateWorkPackageTemplateRank
	@TableName	NVARCHAR(200),	--The Name of the table you want to Update
	@Rank 		INT,
	@Direction	INT,		-- UP (Rank+1), DOWN (Rank-1)
	@Id		INT,		-- id of the row that change rank
	@IdPhase	INT
AS

DECLARE @SQL  NVARCHAR(500)

IF (@Rank<1)
BEGIN 
	RAISERROR('Rank field must be bigger than 0',16,1)		
	RETURN -1
END

DECLARE @RANK_ORIGINAL INT
SELECT @RANK_ORIGINAL = ISNULL(Rank,0)
FROM WORK_PACKAGES_TEMPLATE
WHERE IdPhase = @IdPhase AND
      Id = @Id

IF(@Rank = @RANK_ORIGINAL)
	RETURN

--DELETE OPERATION
IF(@Direction=0)
BEGIN
-- 	PRINT @Rank
	SET @SQL = 'UPDATE '+ @TableName + ' SET Rank = Rank - 1 WHERE Rank> '+ CAST(@Rank AS NVARCHAR(9))
-- 	PRINT @SQL
	EXEC(@SQL)
	RETURN
END

--INSERT OPERATION
IF(@Direction=1)
BEGIN
-- 	PRINT 'HERE 1'
	SET @SQL = 'DECLARE @IDTEST INT; SELECT @IDTEST=ID FROM ' + @TableName + ' WHERE RANK ='+CAST(ISNULL(@Rank,0) AS NVARCHAR(9)) + CHAR(13)
	SET @SQL = @SQL + ' IF @IDTEST>0 ' + CHAR(13)
	SET @SQL = @SQL + 'UPDATE '+ @TableName + ' SET Rank = Rank +1 WHERE Rank>= '+ CAST(@Rank AS NVARCHAR(9))		
--  	PRINT @SQL
	EXEC(@SQL)
	RETURN
END
--UPDATE OPERATION
IF(@Direction=2)
BEGIN
-- PRINT 'HERE 2'
	SET @SQL=N'DECLARE @IDTEST INT; SELECT @IDTEST=ID FROM ' + @TableName + ' WHERE RANK ='+CAST(ISNULL(@Rank,0) AS NVARCHAR(9)) + CHAR(13)
	SET @SQL = @SQL + ' IF @IDTEST>0 ' + CHAR(13)
	SET @SQL=@SQL + ' BEGIN ' + CHAR(13)
	SET @SQL=@SQL + ' DECLARE @OLDRANK INT;' + CHAR(13)
	SET @SQL=@SQL + ' SELECT @OLDRANK=RANK FROM ' + @TableName + ' WHERE ID='+ CAST(@ID AS NVARCHAR(9))+  + CHAR(13)
	SET @SQL=@SQL + ' AND IdPhase='+ CAST(@IdPhase AS NVARCHAR(9))+  + CHAR(13)

	SET @SQL=@SQL + ' UPDATE '+ @TableName + ' SET Rank = -1 WHERE Id ='+ CAST(@Id AS NVARCHAR(9)) + CHAR(13)
	SET @SQL=@SQL + ' AND IdPhase='+ CAST(@IdPhase AS NVARCHAR(9))+  + CHAR(13)

	SET @SQL=@SQL + ' IF @OLDRANK<'+CAST(@RANK AS NVARCHAR(9)) + CHAR(13)
	SET @SQL=@SQL + ' UPDATE '+ @TableName + ' SET Rank =Rank-1 WHERE Rank>@OLDRANK AND Rank <=' + CAST(@Rank AS NVARCHAR(9)) + CHAR(13)
	SET @SQL=@SQL + ' IF @OLDRANK>'+CAST(@RANK AS NVARCHAR(9))+ CHAR(13)
	SET @SQL=@SQL + ' UPDATE '+ @TableName + ' SET Rank =Rank+1 WHERE Rank>=' + CAST(@Rank AS NVARCHAR(9))+' AND Rank<@OLDRANK;' + CHAR(13)
	SET @SQL=@SQL + ' END '
	
--    	PRINT @SQL
	EXEC sp_executesql @SQL
--BEGIN TRAN;exec catDeleteWorkPackage @IdProject = 26, @IdPhase = 1, @Id = 1;SELECT * FROM WORK_PACKAGES;ROLLBACK TRAN	

END




GO



