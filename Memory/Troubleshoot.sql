--Step 1:

             --Blocking

             --Responsible SPID

             --Long Running Query

       SELECT * from Sys.sysprocesses
	   where SPID > 50 and status <>'Sleeping'
       Order By CPU desc

--Step 2:

             -- Responsible LOGIN
             -- Host Name
             -- Program Name

       SP_Who2 62

--Step 3:

             -- RESPONSIBLE QUERY

             DBCC INPUTBUFFER (62)

-- Step 4:

             --EXECUTION PLAN
             SELECT * FROM sys.dm_exec_requests qs CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle)
             where session_id=62

 --Step 5:

             --MISSING INDEXES ON PARTICULAR DATABASE