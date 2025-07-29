	USE [PerfDB];
	GO

-- Step 1: Run sp_monitor (deprecated, rarely used today)
	EXEC sp_monitor;

-- Step 2: Look up object metadata
	SELECT * FROM sys.objects 
	WHERE object_id = 917578307

-- Step 3: Check active locks in the database
	SELECT * FROM sys.dm_tran_locks 
	WHERE resource_database_id = 17



