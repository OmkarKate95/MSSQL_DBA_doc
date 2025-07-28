-- Current CPU (to check which spid is gave high CPU)

	SELECT * FROM sys.sysprocesses
	WHERE spid > 50 AND status <> 'sleeping'
	ORDER BY cpu DESC;

-- CPU threading

	SELECT spid, COUNT(spid) AS ThreadCount 
	FROM sys.sysprocesses
	WHERE spid > 50 AND status <> 'sleeping'
	GROUP BY spid
	HAVING COUNT(spid) > 1;

-- To findout which packet in lastwaittype (95% to 98% ) is showing CXPACKET

	SELECT spid, lastwaittype, COUNT(spid) AS WaitCount 
	FROM sys.sysprocesses
	WHERE spid > 50 AND status <> 'sleeping'
	GROUP BY spid, lastwaittype
	HAVING COUNT(spid) > 1;

-- Check Excution Plan for top SPID for make decision Indexing are available or not 

	SELECT * FROM sys.dm_exec_requests qs
	CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
	WHERE qs.session_id = 76;

-- To findout Program name, loginby, db_name, command and cputime

	EXEC sp_who2 76;

-- To findout which query is long running 

	DBCC INPUTBUFFER(76);
