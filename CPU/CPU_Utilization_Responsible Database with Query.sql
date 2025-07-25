--CPU by Database

WITH DB_CPU_Stats
AS
(SELECT DatabaseID,
	DB_Name(DatabaseID)AS [DatabaseName],
	SUM(total_worker_time)AS [CPU_Time(Ms)]
FROM sys.dm_exec_query_stats AS qs
	CROSS APPLY(SELECT CONVERT(int, value)AS [DatabaseID]
FROM sys.dm_exec_plan_attributes(qs.plan_handle)
WHERE attribute =N'dbid')AS epa
GROUP BY DatabaseID)

SELECT ROW_NUMBER()OVER(ORDER BY [CPU_Time(Ms)] DESC)AS [row_num], DatabaseName, [CPU_Time(Ms)],
	   CAST([CPU_Time(Ms)] * 1.0 /SUM([CPU_Time(Ms)])
OVER()* 100.0 AS DECIMAL(5, 2))AS [CPUPercent]
FROM DB_CPU_Stats
WHERE DatabaseID > 4 -- system databases
AND DatabaseID <> 32767 -- ResourceDB
ORDER BY row_num
OPTION(RECOMPILE);



-- To this script you can get responsible query from that database 
-- Find top N queries in particular database for CPU utilization

use PerfDB
GO
SELECT TOP 5 query_stats.query_hash AS "Query Hash",
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS "Avg CPU Time",
    MIN(query_stats.statement_text) AS "Statement Text"
FROM

    (SELECT QS.*,
	    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,
    ((CASE statement_end_offset
        WHEN -1 THEN DATALENGTH(ST.text)
        ELSE QS.statement_end_offset 
		END
            - QS.statement_start_offset)/2) + 1) AS statement_text
     FROM sys.dm_exec_query_stats AS QS
	     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats

GROUP BY query_stats.query_hash
ORDER BY 2 DESC;

-- Used to identify active sessions consuming the most CPU in SQL Server

SELECT spid, kpid, status, cpu, memusage, open_tran, dbid, db_name(dbid)
FROM sysprocesses  
WHERE spid > 50  
ORDER BY cpu DESC;
