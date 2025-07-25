--Current CPU utilization

--Step 1

       --Responsible OS \ SQL
       --SQL Server instance CPU usage from last 60 minutes

       DECLARE @ts BIGINT
       SELECT @ts =(SELECT cpu_ticks/(cpu_ticks/ms_ticks)
       FROM sys.dm_os_sys_info);

       SELECT TOP(60)SQLProcessUtilization AS [SQLServer_Process_CPU_Utilization],
       SystemIdle AS [System_Idle_Process],
       100 - SystemIdle - SQLProcessUtilization AS [Other_Process_CPU_Utilization],
       DATEADD(ms,-1 *(@ts - [timestamp]),GETDATE())AS [Event_Time]

       FROM (SELECT record.value('(./Record/@id)[1]','int')AS record_id,
					record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]','int')AS 	[SystemIdle],
					record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)	[1]','int')AS [SQLProcessUtilization],
       	[timestamp]
              
		FROM (SELECT[timestamp], convert(xml, record) AS [record]
                           FROM sys.dm_os_ring_buffers
                           WHERE ring_buffer_type =N'RING_BUFFER_SCHEDULER_MONITOR'
       AND record LIKE'%%')AS x
       )AS y
       ORDER BY record_id DESC;
 

--STEP 2

        --Responsible SPID \ Blocking \ Waittype \ DBID
        -- Status \ ProgramName \ Login

       SELECT * FROM sys.sysprocesses
       WHERE spid >50 and STATUS<>'sleeping'
	   ORDER BY CPU DESC;

 
--Step 3

       -- Chck Actual exe Plan for SPID which is taking High CPU

       SELECT query_plan, session_id, Start_time,
	   Status, database_id, cpu_time, total_elapsed_time, row_count
       FROM sys.dm_exec_requests qs
       CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle)
       WHERE session_id=52

 

--Step 4

       -- CPU Wait Type threading and count

       SELECT spid , COUNT(spid)
       FROM sys.sysprocesses
       WHERE spid >50 and STATUS<>'sleeping'
       GROUP BY spid
       HAVING COUNT(spid)>1
 

       --WaitType count more than 1

       SELECT spid , lastwaittype, COUNT(spid)
       FROM sys.sysprocesses
       WHERE spid >50 and STATUS<>'sleeping'
       GROUP BY spid,lastwaittype
       HAVING COUNT(spid)>1

	-- Check Plan for top SPID
	SELECT * FROM sys.dm_exec_requests qs 
	CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle)
	WHERE session_id=50

