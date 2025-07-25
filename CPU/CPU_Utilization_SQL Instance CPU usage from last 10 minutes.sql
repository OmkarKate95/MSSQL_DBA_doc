--SQL Server instance CPU usage from last 10 minutes

DECLARE @ts BIGINT

SELECT @ts =(SELECT cpu_ticks/(cpu_ticks/ms_ticks) FROM sys.dm_os_sys_info);

SELECT TOP(10)SQLProcessUtilization AS [SQL_CPU], 100 - SystemIdle - SQLProcessUtilization AS [Other_Process_CPU],

		100 - SystemIdle   as Total_CPU, SystemIdle AS [Free_CPU], DATEADD(ms,-1 *(@ts - [timestamp]),GETDATE())AS [Event_Time]

FROM (SELECT record.value('(./Record/@id)[1]','int')AS record_id,

		record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]','int')AS [SystemIdle],
		record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]','int')AS [SQLProcessUtilization],
		[timestamp] FROM (SELECT[timestamp], convert(xml, record) AS [record]
				   FROM sys.dm_os_ring_buffers
				   WHERE ring_buffer_type =N'RING_BUFFER_SCHEDULER_MONITOR' AND record LIKE'%%')AS x )AS y
				   ORDER BY record_id DESC;


If exists(
			Select * from #CPU
			where Total_CPU > 10
		)
	BEGIN
		-- Send email alert
			EXECUTE msdb.dbo.sp_send_dbmail
			@profile_name = 'airportwala',
			@recipients = 'omkarkate0007@gmail.com',
			@body = 'CPU Utilization > 10%.',
			@subject = 'High CPU Utilization';
	END

-- Loading Values from #CPU to DBA.dbo.CPU

if exists(
			Select * from DBA.sys.tables
			where name = 'CPU_info'
		)
	BEGIN
		-- Destination table avilable
			Insert into DBA.dbo.CPU_info
			Select * from #CPU
	END

else
	BEGIN
		-- Destination tabel not avilavle
			Select * into DBA.dbo.CPU_info
			from #CPU
	END
DROP table #CPU
