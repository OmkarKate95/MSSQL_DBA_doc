-- Counter DMV to monitor deadlocks in SQL Server
-- 1. First run
	SELECT GETDATE() AS TimeCaptured, 
		   cntr_value AS NumOfDeadLocks
	FROM sys.dm_os_performance_counters
	WHERE object_name = 'SQLServer:Locks'
	  AND counter_name = 'Number of Deadlocks/sec'
	  AND instance_name = '_Total';

-- 2. Run again after 10 minutes and subtract
------------------------------------------------------------------------------------------

-- View All Performance Counters
	
	SELECT * 
	FROM sys.dm_os_performance_counters;

-- This shows thousands of metrics: memory, CPU, IO, locks, buffer cache.
-- Use filters like
	WHERE object_name LIKE '%Buffer%'
OR
	WHERE counter_name LIKE '%Latch%'
---------------------------------------------------------------------------------------------
