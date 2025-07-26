-- Fragmentaion 

-- Database Information
	SELECT * FROM sys.databases 

-- Table Information
	SELECT * FROM sys.tables 

-- Index/Object ID Information
SELECT * FROM sys.objects WHERE object_id = 37223533
SELECT * FROM sys.indexes WHERE object_id = 37223533
-----------------------------------------------------------------------------------------------------------------------

-- To Rebuild
	SELECT * FROM sys.dm_db_index_physical_stats(35 ,null, null, null, null) 
	WHERE avg_fragmentation_in_percent > 30 and database_id >5

--To Reorgnize
	SELECT * FROM sys.dm_db_index_physical_stats(null, null, null, null, null)
	WHERE avg_fragmentation_in_percent >5 and avg_fragmentation_in_percent <30  and database_id >5
-----------------------------------------------------------------------------------------------------------------------

-- To check index fragmentation in a database.

	SELECT * FROM sys.dm_db_index_physical_stats(35, null, null , null,null) 
-----------------------------------------------------------------------------------------------------------------------

-- Shows the statistics for index PK_REPORTMASTER_MST on the table REPORTMASTER_MST

	DBCC SHOW_STATISTICS (REPORTMASTER_MST, PK_REPORTMASTER_MST ) 
-----------------------------------------------------------------------------------------------------------------------


-- All Index Rebuild on table level
	ALTER INDEX all ON REPORTMASTER_MST
	REBUILD


---Database level

	EXEC sp_msforeachtable 
		'SET QUOTED_IDENTIFIER ON; 
		ALTER INDEX ALL ON ? REBUILD';
	GO

	EXEC sp_msforeachtable 
	    'SET QUOTED_IDENTIFIER ON; 
		ALTER INDEX ALL ON ? REORGANIZE';
	GO

--------------------------------------------Rebuild---------------------------------------------------------------

-- Check for fragmented indexes having more than 1000 pages
	SELECT 
		S.name AS [Schema],                     -- Schema name
		T.name AS [Table],                      -- Table name
		I.name AS [Index],                      -- Index name
		DDIPS.avg_fragmentation_in_percent,     -- Fragmentation %
		DDIPS.page_count                        -- Number of pages
	FROM 
		sys.dm_db_index_physical_stats (
			DB_ID(),        -- Current DB
			NULL,           -- All objects
			NULL,           -- All indexes
			NULL,           -- All partitions
			NULL            -- DEFAULT: LIMITED scan
		) AS DDIPS
	INNER JOIN 
		sys.tables T ON T.object_id = DDIPS.object_id
	INNER JOIN 
		sys.schemas S ON T.schema_id = S.schema_id
	INNER JOIN 
		sys.indexes I ON I.object_id = DDIPS.object_id
					  AND I.index_id = DDIPS.index_id

	WHERE 
		DDIPS.database_id = DB_ID()
		AND I.name IS NOT NULL                 -- Skip heaps
		AND DDIPS.avg_fragmentation_in_percent > 0
		AND DDIPS.page_count > 1000           -- Filter only large indexes
	ORDER BY 
		DDIPS.avg_fragmentation_in_percent DESC;

-----------------------------------------------Reorgnize------------------------------------------------------------

-- List indexes with fragmentation between 5% and 30% and more than 1000 pages (recommended for REORGANIZE)
SELECT 
    S.name AS [Schema],
    T.name AS [Table],
    I.name AS [Index],
    DDIPS.avg_fragmentation_in_percent,
    DDIPS.page_count
FROM 
    sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN 
    sys.tables T ON T.object_id = DDIPS.object_id
INNER JOIN 
    sys.schemas S ON T.schema_id = S.schema_id
INNER JOIN 
    sys.indexes I ON I.object_id = DDIPS.object_id
                AND I.index_id = DDIPS.index_id
WHERE 
    DDIPS.database_id = DB_ID()
    AND I.name IS NOT NULL
    AND DDIPS.avg_fragmentation_in_percent BETWEEN 5 AND 30
    AND DDIPS.page_count > 1000
ORDER BY 
    DDIPS.avg_fragmentation_in_percent DESC;
---------------------------------------------------------------------------------------------------------------------


