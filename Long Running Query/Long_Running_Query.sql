-- Long Running Query
-- Find which query is causing high CPU load.

	SELECT 
		sqltext.TEXT,
		req.session_id,
		req.status,
		req.command,
		req.cpu_time,
		req.total_elapsed_time
	FROM sys.dm_exec_requests AS req
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
	ORDER BY req.cpu_time DESC;

------------------------------------------------------------------------------

-- Long Running Queries with Execution Plan

	SELECT 
		QP.query_plan AS [Query Plan],
		r.session_id,
		r.status,
		r.command,
		r.cpu_time,
		r.total_elapsed_time,
		ST.text AS [Query Text]
	FROM sys.dm_exec_requests AS r
	CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) AS QP
	CROSS APPLY sys.dm_exec_sql_text(r.plan_handle) AS ST
	ORDER BY r.total_elapsed_time DESC;

------------------------------------------------------------------------------

	SELECT * 
	FROM sys.sysprocesses
	WHERE spid > 50 AND status <> 'sleeping'
	ORDER BY cpu DESC;

-------------------------------------------------------------------------------

-- We can find open tran with particular database to check open tran  
-- First select particular database
	DBCC opentran()

	SELECT * FROM sys.syslogins
	WHERE sid= 0xafa2aa765a6e234e8a1de44fbe8d715c

-- Get 
	sp_who2

-- Do check which query in long running 
	DBCC inputbuffer(57)

--------------------------------------------------------------------------------