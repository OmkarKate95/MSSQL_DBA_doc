-- Analyze Historical CPU usage in SQL Server
DECLARE @ts_now BIGINT;

SELECT @ts_now = cpu_ticks / CONVERT(FLOAT, cpu_ticks)
FROM   sys.dm_os_sys_info;

SELECT record_id,
       Dateadd(ms, -1 * ( @ts_now - [timestamp]),
       Getdate()) AS EventTime,
       sqlprocessutilization,
       systemidle,
       100 - systemidle - sqlprocessutilization AS OtherProcessUtilization
FROM   (SELECT record.value('(./Record/@id)[1]', 'int') AS record_id,
               record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle,
               record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization,
               timestamp
 FROM   (SELECT timestamp,
                CONVERT(XML, record) AS record
         FROM   sys.dm_os_ring_buffers
         WHERE  ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
            AND record LIKE '%<SystemHealth>%') AS x) AS y
ORDER BY record_id DESC;

-- Use this along with real-time DMV queries like--

SELECT TOP 5 
    r.session_id, s.login_name, r.cpu_time, t.text
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
ORDER BY r.cpu_time DESC;

