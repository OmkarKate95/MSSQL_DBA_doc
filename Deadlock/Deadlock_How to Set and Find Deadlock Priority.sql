-- DBA There are two ways to enable deadlock flag 
-- 1. Temprory, 2. Permently 

-- 1. In temprory way you can set deadlock flag through DBCC command its a particular session only and globally, when restart sqlserverices that time its automatically goes to normal state it means desible.
-- 2. In perment way you can enable through add deadlock flag in startup parameter ..
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For check dead lock flag activate or not value 1 for activate value 0 for deactivate
	DBCC TRACESTATUS(1222,1204)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- To on deadlock flag on 1222  value (-1 for globally, 1 for session only)
	DBCC TRACEON(1222,1)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- To on deadlock flag on 1204 (-1 for globally, 1 for session only)
	DBCC TRACEON(1204,-1)
	DBCC TRACESTATUS(1222,1204)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- To OFF deadlock flag on 1222  value (-1 for globally, 1 for session only)
	DBCC TRACEOFF(1204,0)
	DBCC TRACEOFF(1222,0)
	DBCC TRACEOFF (1204,-1)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For enable permentaly deadlock with using add startup parameter with -T1222, -T1204
-- Go to configuration manager and add startup parameter 

-- Findout deadlock error another way

	Exec XP_ReadErrorLog 0
	Exec XP_ReadErrorLog 0, 1
	Exec XP_ReadErrorLog 0, 1, 'deadlock'
	Exec XP_ReadErrorLog 0, 1, 'deadlock', 'MDW'
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- To check the deadlock_priority setting for all active sessions

	SELECT deadlock_priority FROM sys.dm_exec_sessions

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Set deadlock priority using keyword

	SET DEADLOCK_PRIORITY LOW;
	SET DEADLOCK_PRIORITY NORMAL;
	SET DEADLOCK_PRIORITY HIGH;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Set deadlock priority using an integer from -10 to 10:

	SET DEADLOCK_PRIORITY -5;
	SET DEADLOCK_PRIORITY 5;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Set to custom deadlock priority
	DECLARE @deadlock_priority INT = -5;

-- Apply the priority for current session
	SET DEADLOCK_PRIORITY @deadlock_priority;

-- Check current session's deadlock priority
	SELECT session_id, deadlock_priority  
	FROM sys.dm_exec_sessions  
	WHERE session_id = @@SPID;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

