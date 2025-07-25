-- Store Procedure
    SP_WHO2  -- To Find who is responsible for blocking

----------------------------------------------------------------------------

-- Find which query is responsible for blocking using DBCC command
	
	DBCC inputbuffer
----------------------------------------------------------------------------

-- For killing responsible blocking spid using kill(spid)
	Kill 50
----------------------------------------------------------------------------

-- Processes table

	Select * From sys.sysprocesses
    where blocked<>0
----------------------------------------------------------------------------

-- DMV
--1
    Select * From  sys.dm_os_waiting_tasks
    where blocking_session_id <>0

--2
	Select * From  sys.dm_exec_requests
	where blocking_session_id <>0

--3
	Select * From sys.sysprocesses 
	where spid > 50 and blocked <> 0

--4
	Select * From sys.dm_os_waiting_tasks
	where blocking_session_id is not null

--5
	Select session_id, blocking_session_id,wait_type 
	From sys.dm_exec_requests
	where blocking_session_id <> 0

--6
	SELECT * FROM sys.dm_exec_requests;

--7
	SELECT * FROM sys.dm_os_waiting_tasks;


----------------------------------------------------------------------------
