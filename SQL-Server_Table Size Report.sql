	USE DBA;
	GO

--Create a Temporary Table to store report
	DECLARE @StorageRepTable TABLE
	(
		Table_Name VARCHAR(80),
		RowCnt INT,
		TableSize VARCHAR(80),
		DataSpaceUsed VARCHAR(80),
		IndexSpaceUsed VARCHAR(80),
		Unused_Space VARCHAR(80)
	);

--Populate Temporary Report Table
	INSERT INTO @StorageRepTable
	EXEC ('sp_msforeachtable ''sp_spaceused "?"''');

-- Sorting the report result 
	SELECT * FROM @StorageRepTable
	ORDER BY Table_Name;

--==================================================================================================================

-- Create table variable to hold results
	DECLARE @StorageRepTable TABLE
	(
		Table_Name SYSNAME,
		RowCnt INT,
		TableSize VARCHAR(50),
		DataSpaceUsed VARCHAR(50),
		IndexSpaceUsed VARCHAR(50),
		Unused_Space VARCHAR(50)
	);

-- Declare a table to hold intermediate results
	CREATE TABLE #tempSpaceUsed 
	(
		name SYSNAME,
		rows CHAR(11),
		reserved VARCHAR(18),
		data VARCHAR(18),
		index_size VARCHAR(18),
		unused VARCHAR(18)
	);

-- Use sp_msforeachtable to populate #tempSpaceUsed
	EXEC sp_msforeachtable 'INSERT INTO #tempSpaceUsed EXEC sp_spaceused ''?''';

-- Insert cleaned data into final table variable
	INSERT INTO @StorageRepTable (Table_Name, RowCnt, TableSize, DataSpaceUsed, IndexSpaceUsed, Unused_Space)
	SELECT 
		name,
		CAST(rows AS INT),
		reserved,
		data,
		index_size,
		unused
	FROM #tempSpaceUsed;

-- Drop temp table
	DROP TABLE #tempSpaceUsed;

-- Show the results sorted by table name
	SELECT * FROM @StorageRepTable
	ORDER BY Table_Name;
--==================================================================================================================
