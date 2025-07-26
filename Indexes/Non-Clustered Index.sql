-- Non-Clustered Index
------------------------------------------------------------------------------------------------------------------
	USE PerfDB;
	GO

-- Check current data
	SELECT * FROM EMP;
	GO

-- Enable IO stats to analyze logical reads
	SET STATISTICS IO ON;
	SELECT * FROM EMP
	WHERE name = 'f5';
	GO

-- Insert 10,000 rows into EMP table
	BEGIN TRAN;

	DECLARE @i INT = 1;

	WHILE (@i <= 10000)
	BEGIN
		INSERT INTO PerfDB.dbo.EMP
		VALUES (
			@i,
			CHAR((@i % 26) + 97) + CAST(@i AS VARCHAR(100)),
			RAND() * 100000,
			(@i % 3) + 1,
			'test',
			'test'
		);

		-- Commit every 50000 rows (not needed here since i only goes to 10,000)
		IF (@i % 50000 = 0)
		BEGIN
			COMMIT;
			BEGIN TRAN;
		END;

		SET @i = @i + 1;
	END;

	COMMIT;
------------------------------------------------------------------------------------------------------------------
