	USE TCS

	BEGIN TRANSACTION

-- Step 1: Create a Partition Function on CITY
	CREATE PARTITION FUNCTION [CITY] (NCHAR(10)) 
	AS RANGE LEFT FOR VALUES (N'MUMBAI', N'PUNE')

-- This creates 3 partitions: 
-- Partition 1: CITY <= 'MUMBAI'
-- Partition 2: 'MUMBAI' < CITY <= 'PUNE'
-- Partition 3: CITY > 'PUNE'

-- Step 2: Create a Partition Scheme using the above function
	CREATE PARTITION SCHEME [CITY] 
	AS PARTITION [CITY] TO ([MUMBAI], [PUNE], [PRIMARY])
-

-- Step 3: Create a clustered index on CITY using the partition scheme
	SET ANSI_PADDING ON
	CREATE CLUSTERED INDEX [ClusteredIndex_on_CITY] ON [dbo].[employee]
	(
		[CITY]
	)
	WITH (
		SORT_IN_TEMPDB = OFF, 
		DROP_EXISTING = OFF, 
		ONLINE = OFF
	)
	ON [CITY]([CITY])  -- This links index to the partition scheme

	DROP INDEX [ClusteredIndex_on_CITY] ON [dbo].[employee]

	COMMIT TRANSACTION




-- Right click on database ---> Properties ---> Click on filegroups---> Add file groups ---> Add memory optimize data ---> DONE ---> click on files
	--->add database files
 
--Right click on your table ---> Storage ---> Create partitation ---> Select column name---> Create partitation function ---> Create partitation schema 
	---> Assign the partitions to filegroups and set the boundaries. --->Select Run immediately and then click Next. ---> DONE
