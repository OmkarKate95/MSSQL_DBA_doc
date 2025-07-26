--  Check Index Usage
	SELECT * FROM emp WHERE id = 10000;
--------------------------------------------------------------------------------------

-- Page scan check
	SET STATISTICS IO ON;
	SELECT * FROM emp WHERE id = 10000;

--------------------------------------------------------------------------------------

-- Just to retrieve a sample of rows. To use a table scan or clustered index scan
	SELECT TOP 10 * FROM emp;
--------------------------------------------------------------------------------------
