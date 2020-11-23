IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = object_id(N'[dbo].[OLAP_TC]') and OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW OLAP_TC
GO

CREATE VIEW OLAP_TC
AS

SELECT TOP 100 PERCENT
	(case when IL.Code = 'TCL' then 'TC only'
             when IL.Code = 'TCC' then 'TC only'
             when IL.Code in ('MUN', 'RAU')  then 'TC only'
             when IL.Code = 'SHI' then 'TC only'
             when IL.Code = 'TCK' then 'TC only'
             when IL.Code = 'NOH' then 'TC only'
             when IL.Code = 'TCW' then 'TC only'
             else 'Plant only' end) AS TCType,
	(case when IL.Code = 'TCL' then 1
             when IL.Code = 'TCC' then 1
             when IL.Code in ('MUN', 'RAU')  then 1
             when IL.Code = 'SHI' then 1
             when IL.Code = 'TCK' then 1
             when IL.Code = 'NOH' then 1
             when IL.Code = 'TCW' then 1
             else 2 end) AS TCTypeId,
	(case when IL.Code = 'TCL' then 1
             when IL.Code = 'TCC' then 2
             when IL.Code in ('MUN', 'RAU')  then 3
             when IL.Code = 'SHI' then 4
             when IL.Code = 'TCK' then 5
             when IL.Code = 'NOH' then 6
             when IL.Code = 'TCW' then 7
             else 8 end) AS TCId,
      (case when IL.Code = 'TCL' then 'TC Laval'
            when IL.Code = 'TCC' then 'TC Compiegne'
            when IL.Code in ('MUN', 'RAU') then 'Germany'
            when IL.Code = 'SHI' then 'Japan'
            when IL.Code = 'TCK' then 'Korea'
            when IL.Code = 'NOH' then 'Noh'
            when IL.Code = 'TCW' then 'China'
            else 'Plants' end) as TCName,	
       IL.Id as InergyLocationIdKey,
       IL.Code as InergyLocationCode,
       IL.Name as InergyLocationName,
	IL.Rank AS InergyLocationRank
FROM INERGY_LOCATIONS IL 
ORDER BY TCId

GO

