-- To Check Disk I/O latency for database or file 

	SELECT
		[database_id],
		[file_id],
		[ReadLatency] = 
			CASE WHEN [num_of_reads] = 0 
				 THEN 0 
				 ELSE ([io_stall_read_ms] / [num_of_reads]) 
			END,
		[WriteLatency] = 
			CASE WHEN [num_of_writes] = 0 
				 THEN 0 
				 ELSE ([io_stall_write_ms] / [num_of_writes]) 
			END
	FROM sys.dm_io_virtual_file_stats (NULL, NULL)
	WHERE [file_id] = 2 OR [database_id] = 2;
