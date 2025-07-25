--  Page life Expectancy:

SELECT object_name, counter_name, cntr_value, cntr_type

FROM sys.dm_os_performance_counters

WHERE [object_name] LIKE '%Buffer Manager%' AND [counter_name] =  'Page life Expectancy'

---------------------------------------------------------------------------------------------------------------------------------

-- Buffer Cache Hit ratio: 

SELECT object_name, counter_name, cntr_value, cntr_type

FROM sys.dm_os_performance_counters WHERE [object_name] LIKE '%Buffer Manager%' AND [counter_name] = 'Buffer cache hit ratio'
---------------------------------------------------------------------------------------------------------------------------------

-- Lazy writes/ sec 

SELECT object_name, counter_name, cntr_value, cntr_type

FROM sys.dm_os_performance_counters

WHERE [object_name] LIKE '%Buffer Manager%' AND [counter_name] = 'Lazy writes/sec'
---------------------------------------------------------------------------------------------------------------------------------

-- Enhanced Lazy Write Tracking (Over Time):

DECLARE @LazyWrites1 bigint;

SELECT @LazyWrites1 = cntr_value

FROM sys.dm_os_performance_counters   WHERE counter_name = 'Lazy writes/sec';

WAITFOR DELAY '00:00:10';
 

SELECT(cntr_value - @LazyWrites1) / 10 AS 'LazyWrites/sec'

FROM sys.dm_os_performance_counters   WHERE counter_name = 'Lazy writes/sec';
---------------------------------------------------------------------------------------------------------------------------------

-- Free list Stall / Sec

SELECT object_name, counter_name, cntr_value, cntr_type

FROM sys.dm_os_performance_counters

WHERE [object_name] LIKE '%Buffer Manager%'

AND [counter_name] =  'Free list stalls/sec'

---------------------------------------------------------------------------------------------------------------------------------

--  Page read/Sec

SELECT object_name, counter_name, cntr_value

FROM sys.dm_os_performance_counters

WHERE [object_name] LIKE '%Buffer Manager%' AND [counter_name] = 'Page reads/sec'

---------------------------------------------------------------------------------------------------------------------------------

-- Page writes/sec:

SELECT object_name, counter_name, cntr_value

FROM sys.dm_os_performance_counters

WHERE [object_name] LIKE '%Buffer Manager%'

AND [counter_name] = 'Page writes/sec'

---------------------------------------------------------------------------------------------------------------------------------

                                    