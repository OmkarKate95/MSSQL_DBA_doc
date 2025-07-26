-- Session 2 – User B
	USE DBA
	GO
----------------------------------------------------------------------------------------------------------------------------

-- Step 2: Start transaction and lock EMP1

	BEGIN TRAN;
	UPDATE EMP1 
	SET NAME = 'Krishna' 
	WHERE ID = 3;
----------------------------------------------------------------------------------------------------------------------------

-- Step 4: Set lower deadlock priority and try to access emp1 (held by Session 1)
	SET DEADLOCK_PRIORITY LOW;
	GO

	SELECT * FROM EMP 
	WHERE ID = 3

-- This creates a circular wait -> DEADLOCK
----------------------------------------------------------------------------------------------------------------------------

-- To Cleanup In Session 1 or 2

	ROLLBACK;
----------------------------------------------------------------------------------------------------------------------------
