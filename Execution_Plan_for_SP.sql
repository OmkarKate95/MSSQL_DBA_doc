--Check Execution Plan for SP

-- Take plan handler from below query and put to second query

	DECLARE @SPNAME NVARCHAR(100)
	SELECT @SPNAME = 'Stored_Procedure_Name'  -- <-- replace with actual name

	SELECT *
	FROM sys.dm_exec_procedure_stats
	WHERE object_id IN (SELECT id FROM sys.sysobjects 
						WHERE name = @SPNAME)
	ORDER BY execution_count DESC;


--Take Plan handler from above query and put into below bracket.
	SELECT *
	FROM sys.dm_exec_query_plan(0x0500060037E3270F30FD7379CA01000);



 

 
