---------------------------------------------- Disk IO Monitoring Script ----------------------------------------------
	USE master;
	GO

-- Check if logging table exists
IF EXISTS (
    SELECT * FROM DBA.sys.tables
    WHERE name = 'diskioinfo'
)
BEGIN
    -- Step 1: Gather Disk IO Statistics into Temporary Table
    SELECT
        [ReadLatency] = CASE WHEN [num_of_reads] = 0 THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
        [WriteLatency] = CASE WHEN [num_of_writes] = 0 THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END,
        [Latency] = CASE 
                        WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0) 
                        THEN 0 
                        ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) 
                   END,
        [AvgBPerRead] = CASE WHEN [num_of_reads] = 0 THEN 0 ELSE ([num_of_bytes_read] / [num_of_reads]) END,
        [AvgBPerWrite] = CASE WHEN [num_of_writes] = 0 THEN 0 ELSE ([num_of_bytes_written] / [num_of_writes]) END,
        [AvgBPerTransfer] = CASE 
                                WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0) 
                                THEN 0 
                                ELSE (([num_of_bytes_read] + [num_of_bytes_written]) / ([num_of_reads] + [num_of_writes])) 
                            END,
        LEFT([mf].[physical_name], 2) AS [Drive],
        DB_NAME([vfs].[database_id]) AS [DB],
        [mf].[physical_name]

    INTO #tempdiskio --Temp table 

    FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS [vfs]
    JOIN sys.master_files AS [mf]
        ON [vfs].[database_id] = [mf].[database_id]
        AND [vfs].[file_id] = [mf].[file_id]

	-- WHERE [vfs].[file_id] = 2 -- log files
	-- ORDER BY [Latency] DESC
	-- ORDER BY [ReadLatency] DESC
    ORDER BY [WriteLatency] DESC;

    -- Step 2: Check for High Latency and Send Alert if Needed
    IF EXISTS (
        SELECT * FROM #tempdiskio
        WHERE ReadLatency > 20 OR WriteLatency > 20
    )
    BEGIN
        -- Step 3: Send Email Notification
        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'Airportwala',
            @recipients = 'omkarkate@gmail.com',
            @body = 'DISKlatency_issue',
            @subject = 'DISKlatency_issue';

        -- Step 4: Insert Data into Log Table
        INSERT INTO DBA.dbo.diskioinfo
        SELECT * FROM #tempdiskio;
    END
    ELSE
    BEGIN
        -- No Alert, Just Log
        INSERT INTO DBA.dbo.diskioinfo
        SELECT * FROM #tempdiskio;
    END

    DROP TABLE #tempdiskio;
END
ELSE
BEGIN
    -- If diskioinfo table does NOT exist, create and log
    SELECT
        [ReadLatency] = CASE WHEN [num_of_reads] = 0 THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
        [WriteLatency] = CASE WHEN [num_of_writes] = 0 THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END,
        [Latency] = CASE 
                        WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0) 
                        THEN 0 
                        ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) 
                   END,
        [AvgBPerRead] = CASE WHEN [num_of_reads] = 0 THEN 0 ELSE ([num_of_bytes_read] / [num_of_reads]) END,
        [AvgBPerWrite] = CASE WHEN [num_of_writes] = 0 THEN 0 ELSE ([num_of_bytes_written] / [num_of_writes]) END,
        [AvgBPerTransfer] = CASE 
                                WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0) 
                                THEN 0 
                                ELSE (([num_of_bytes_read] + [num_of_bytes_written]) / ([num_of_reads] + [num_of_writes])) 
                            END,
        LEFT([mf].[physical_name], 2) AS [Drive],
        DB_NAME([vfs].[database_id]) AS [DB],
        [mf].[physical_name]
    INTO #tempdiskio2
    FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS [vfs]
    JOIN sys.master_files AS [mf]
        ON [vfs].[database_id] = [mf].[database_id]
        AND [vfs].[file_id] = [mf].[file_id]
	
	-- WHERE [vfs].[file_id] = 2 -- log files
	-- ORDER BY [Latency] DESC
	-- ORDER BY [ReadLatency] DESC
	ORDER BY [WriteLatency] DESC;

    -- Check if Latency is High
    IF EXISTS (
        SELECT * FROM #tempdiskio2
        WHERE ReadLatency > 20 OR WriteLatency > 20
    )
    BEGIN
        -- Send Email
        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'Airportwala',
            @recipients = 'omkarkate@gmail.com',
            @body = 'DISKlatency_issue',
            @subject = 'DISKlatency_issue';

        -- Create diskioinfo and insert
        SELECT * INTO DBA.dbo.diskioinfo FROM #tempdiskio2;
    END
    ELSE
    BEGIN
        -- Just create and insert
        SELECT * INTO DBA.dbo.diskioinfo FROM #tempdiskio2;
    END

    DROP TABLE #tempdiskio2;
END;
------------------------------------------------------------------------------------------------------------------------------------

