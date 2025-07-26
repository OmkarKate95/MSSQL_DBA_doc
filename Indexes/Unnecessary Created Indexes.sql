-- To find Unnecessary created indexes DMVs
--1
	SELECT * 
	FROM sys.dm_db_index_operational_stats(NULL, NULL, NULL, NULL);
--2
	SELECT * 
	FROM sys.dm_db_index_usage_stats;
----------------------------------------------------------------------------------------

-- This query is used to identify indexes on tables how indexes are being modified (DML)

	SELECT 
		OBJECT_NAME(A.[OBJECT_ID]) AS [OBJECT NAME],
		I.[NAME] AS [INDEX NAME],
		A.LEAF_INSERT_COUNT,
		A.LEAF_UPDATE_COUNT,
		A.LEAF_DELETE_COUNT
	FROM sys.dm_db_index_operational_stats(DB_ID(), NULL, NULL, NULL) A
	INNER JOIN sys.indexes AS I
		ON I.[OBJECT_ID] = A.[OBJECT_ID]
		AND I.INDEX_ID = A.INDEX_ID
	WHERE OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1;
----------------------------------------------------------------------------------------

--This query used to analyze how indexes are being accessed (Select Statement)

	SELECT 
		OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
		I.[NAME] AS [INDEX NAME],
		USER_SEEKS,
		USER_SCANS,
		USER_LOOKUPS,
		USER_UPDATES
	FROM SYS.DM_DB_INDEX_USAGE_STATS AS S
	INNER JOIN SYS.INDEXES AS I 
		ON I.[OBJECT_ID] = S.[OBJECT_ID] 
		AND I.INDEX_ID = S.INDEX_ID
	WHERE OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1
		AND S.database_id = DB_ID();

----------------------------------------------------------------------------------------
-- Unused Index Script
========================================================================================
-- Original Author: Pinal Dave
========================================================================================
	
	SELECT TOP 25
		o.name AS [ObjectName],
		i.name AS [IndexName],
		i.index_id AS [IndexID],
		dm_ius.user_seeks AS [UserSeeks],
		dm_ius.user_scans AS [UserScans],
		dm_ius.user_lookups AS [UserLookups],
		dm_ius.user_updates AS [UserUpdates],
		p.TableRows,
		'DROP INDEX ' + QUOTENAME(i.name) + 
		' ON ' + QUOTENAME(s.name) + '.' + QUOTENAME(OBJECT_NAME(dm_ius.OBJECT_ID)) AS [DropStatement]
	FROM
		sys.dm_db_index_usage_stats AS dm_ius
	INNER JOIN 
		sys.indexes AS i 
		ON i.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = i.OBJECT_ID
	INNER JOIN 
		sys.objects AS o 
		ON dm_ius.OBJECT_ID = o.OBJECT_ID
	INNER JOIN 
		sys.schemas AS s 
		ON o.schema_id = s.schema_id
	INNER JOIN 
		(
			SELECT 
				SUM(p.rows) AS TableRows,
				p.index_id,
				p.OBJECT_ID
			FROM 
				sys.partitions AS p
			GROUP BY 
				p.index_id, p.OBJECT_ID
		) AS p 
		ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
	WHERE 
		OBJECTPROPERTY(dm_ius.OBJECT_ID, 'IsUserTable') = 1
		AND dm_ius.database_id = DB_ID()
		AND i.type_desc = 'NONCLUSTERED'
		AND i.is_primary_key = 0
		AND i.is_unique_constraint = 0
	ORDER BY 
		(dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC;
	GO

----------------------------------------------------------------------------------------

