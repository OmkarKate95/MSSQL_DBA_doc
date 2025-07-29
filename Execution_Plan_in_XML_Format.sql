-- This Query used to capture the execution plan of a currently running query for a specific SPID
-- To extract the execution plan (in XML format) 

	SELECT 
		CONVERT(XML, c.query_plan) AS ExecutionPlan
	FROM sys.dm_exec_requests a WITH (NOLOCK)

	-- Get SQL text for the currently executing request
	OUTER APPLY sys.dm_exec_sql_text(a.sql_handle) b

	-- Get the actual execution plan for the currently executing request
	OUTER APPLY sys.dm_exec_text_query_plan(
		a.plan_handle, 
		a.statement_start_offset, 
		a.statement_end_offset
	) c

	-- Join with memory grants to see if the query is waiting for memory
	LEFT JOIN sys.dm_exec_query_memory_grants m WITH (NOLOCK)
		ON m.session_id = a.session_id
		AND m.request_id = a.request_id

	-- Join to get database name
	JOIN sys.databases d
		ON d.database_id = a.database_id

	WHERE a.session_id = @@SPID
	ORDER BY a.start_time;
