-- Memory Utilization of SQL  /  Other Processes
Declare @SQLPages bigint

--Memory used by SQL Server
SELECT
@SQLPages  =(physical_memory_in_use_kb/1024)
--,(locked_page_allocations_kb/1024 )Locked_pages_used_Sqlserver_MB,
--(total_virtual_address_space_kb/1024 )Total_VAS_in_MB,
--process_physical_memory_low,
--process_virtual_memory_low

FROM sys.dm_os_process_memory

SELECT
	GETDATE() AS Date,
		total_physical_memory_kb/1024 AS Total_physical_memory_mb,
			@SQLPages     SQL_Pages_In_Memory_MB,
		available_physical_memory_kb/1024 AS available_physical_memory_mb,
		total_page_file_kb/1024 AS total_page_file_mb,
		available_page_file_kb/1024 AS available_page_file_mb,
		100 - (100 * CAST(available_physical_memory_kb AS DECIMAL(18,3))/
					 CAST(total_physical_memory_kb AS DECIMAL(18,3)))
		AS 'Total_Percentage',
 
		CAST(( @SQLPages*100)/(total_physical_memory_kb/1024 ) as Decimal(18,3)) as SQLServer_Percent,
			(100 - (100 * CAST(available_physical_memory_kb AS DECIMAL(18,3))/
						  CAST(total_physical_memory_kb AS DECIMAL(18,3)))) -
			
			(( @SQLPages*100)/(total_physical_memory_kb/1024 )) as Other_Processes,
			(100-(100 - (100 * CAST(available_physical_memory_kb AS DECIMAL(18,3))/
							   CAST(total_physical_memory_kb AS DECIMAL(18,3))))) as FreePercent, 
							   system_memory_state_desc
INTO #Memory
FROM  sys.dm_os_sys_memory;


-- If Memory Utilization > 85% Then Send Mail

If exists(

			SELECT * FROM #Memory 
			WHERE Total_Percentage > 85
			)
	BEGIN
		-- Send email alert
			EXECUTE msdb.dbo.sp_send_dbmail
			@profile_name = 'airportwala',
			@recipients = 'omkar.k@gmail.com',
			@body = 'Memory Utilization > 85%.',
			@subject = 'High Memory Utilization';
	END

-- Loading Values from #Memory to DBA.dbo.Memory

If exists (
			SELECT * FROM DBA.sys.tables
			WHERE NAME = 'Memory_info'
			)
	BEGIN
		-- Destination table avilable
			INSERT INTO DBA.dbo.Memory_info
			SELECT * FROM #Memory
	END

ELSE
	BEGIN
		-- Destination table not avilable
			SELECT * INTO DBA.dbo.Memory_info
			FROM #Memory
	END

DROP TABLE #Memory


