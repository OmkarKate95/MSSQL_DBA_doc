-- Create table in PerfDB database
	CREATE TABLE PerfDB.dbo.EMP
	(
		id INT,
		name VARCHAR(100),
		salary INT,
		deptid INT,
		c1 CHAR(1000),
		c2 CHAR(1000)
	);
	GO

-- Insert 100,000 sample rows into EMP table
	SET NOCOUNT ON

BEGIN TRAN
	DECLARE  @i int

	SET @i = 1

	WHILE  (@i<=100000)
	BEGIN
		INSERT INTO PerfDB.dbo.EMP 
			VALUES ( @i, CHAR((@i % 26) + 97) + CAST(@i AS VARCHAR(100)),
				RAND() * 100000, (@i % 3) + 1, 'test', 'test');
		
		IF(@i%50000 = 0)
		BEGIN
			COMMIT;
			BEGIN TRAN;
		END;
	SET @i = @i + 1;
END;

COMMIT;
